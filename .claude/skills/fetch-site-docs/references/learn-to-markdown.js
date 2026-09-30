// Converts Microsoft Learn article HTML to Markdown, inside the page context.
// Usage: pass the whole function body below as the `function` argument of the Playwright MCP
// browser_evaluate tool, while the browser is on any learn.microsoft.com page (same origin).
// It defines window.__learn, which the next calls use:
//
//   window.__learn.tocItems('/en-us/azure/foundry/toc.json')   -> flat list of { idx, depth, title, href, url }
//   window.__learn.crawl(items, 6)                              -> array of page results (see below)
//
// Each page result: { idx, url, finalUrl, ok, status, title, description, msDate, updatedAt, gitUrl,
//                     markdown, chars, error? }
// Reads only. It does not change the page or the site.
() => {
  const SKIP = 'script,style,nav,button,form,svg,bread-crumbs,local-time,.notification,' +
    '.authentication-determined,.page-metadata-container,.action-panel,.doc-outline,' +
    '.ai-summary-cta-text,.thumb-rating-button,.visually-hidden,.icon';
  const CALLOUT = { NOTE: 'Note', TIP: 'Tip', IMPORTANT: 'Important', WARNING: 'Warning', CAUTION: 'Caution' };
  const BLOCK = new Set(['ADDRESS', 'ARTICLE', 'ASIDE', 'BLOCKQUOTE', 'DD', 'DETAILS', 'DIV', 'DL', 'DT', 'FIGCAPTION',
    'FIGURE', 'FOOTER', 'H1', 'H2', 'H3', 'H4', 'H5', 'H6', 'HEADER', 'HR', 'LI', 'MAIN', 'OL', 'P', 'PRE', 'SECTION',
    'SUMMARY', 'TABLE', 'UL']);

  function make(base) {
    const abs = (u) => { try { return new URL(u, base).href; } catch (e) { return u; } };
    const text = (s) => s.replace(/\s+/g, ' ').replace(/</g, '&lt;');

    const inline = (n) => {
      if (n.nodeType === 3) return text(n.nodeValue);
      if (n.nodeType !== 1 || n.matches(SKIP)) return '';
      const kids = () => [...n.childNodes].map(inline).join('');
      switch (n.tagName) {
        case 'STRONG': case 'B': { const s = kids().trim(); return s ? '**' + s + '**' : ''; }
        case 'EM': case 'I': { const s = kids().trim(); return s ? '*' + s + '*' : ''; }
        case 'CODE': {
          const s = n.textContent;
          if (!s) return '';
          const f = s.includes('`') ? '``' : '`';
          return f + s + f;
        }
        case 'A': {
          const s = kids().trim();
          const h = n.getAttribute('href');
          if (!h || !s) return s;
          return '[' + s + '](' + (h.startsWith('#') ? h : abs(h)) + ')';
        }
        case 'BR': return '  \n';
        case 'IMG': {
          const src = n.getAttribute('src');
          return src ? '![' + (n.getAttribute('alt') || '') + '](' + abs(src) + ')' : '';
        }
        default: return BLOCK.has(n.tagName) ? ' ' + kids() + ' ' : kids();
      }
    };
    const inlineKids = (n) => [...n.childNodes].map(inline).join('').replace(/[ \t]+\n/g, '\n').replace(/ {2,}(?!\n)/g, ' ').trim();

    const fence = (code, lang) => {
      const f = code.includes('```') ? '````' : '```';
      return f + (lang || '') + '\n' + code.replace(/\n+$/, '') + '\n' + f;
    };

    const table = (t) => {
      const rows = [...t.querySelectorAll('tr')].filter((r) => r.closest('table') === t);
      if (!rows.length) return '';
      const cell = (c) => [...c.childNodes].map(inline).join('').replace(/\s*\n\s*/g, ' ').replace(/\s+/g, ' ').replace(/\|/g, '\\|').trim() || ' ';
      const data = rows.map((r) => [...r.children].filter((c) => /^(TD|TH)$/.test(c.tagName)).map(cell));
      const cols = Math.max(...data.map((r) => r.length));
      const pad = (r) => r.concat(Array(cols - r.length).fill(' '));
      const line = (r) => '| ' + pad(r).join(' | ') + ' |';
      return [line(data[0]), '| ' + Array(cols).fill('---').join(' | ') + ' |', ...data.slice(1).map(line)].join('\n');
    };

    const list = (el) => {
      const ordered = el.tagName === 'OL';
      const start = parseInt(el.getAttribute('start') || '1', 10);
      return [...el.children].filter((c) => c.tagName === 'LI').map((li, i) => {
        const marker = ordered ? (start + i) + '. ' : '- ';
        const arr = blocksArr(li);
        let out = '';
        arr.forEach((b, j) => { if (j) out += /^([-*]|\d+\.) /.test(b) ? '\n' : '\n\n'; out += b; });
        const pad = ' '.repeat(marker.length);
        return marker + out.split('\n').map((l, k) => (k ? (l ? pad + l : l) : l)).join('\n');
      }).join('\n');
    };

    const quote = (s) => s.split('\n').map((l) => (l ? '> ' + l : '>')).join('\n');

    const blockEl = (n) => {
      const tag = n.tagName;
      if (/^H[1-6]$/.test(tag)) { const s = inlineKids(n); return s ? '#'.repeat(+tag[1]) + ' ' + s : ''; }
      if (tag === 'P') return inlineKids(n);
      if (tag === 'UL' || tag === 'OL') return list(n);
      if (tag === 'PRE') {
        const code = n.querySelector('code');
        const m = ((code && code.className) || n.className || '').match(/lang-([\w+#-]+)/);
        return fence((code || n).textContent, m ? m[1] : '');
      }
      if (tag === 'TABLE') return table(n);
      if (tag === 'HR') return '---';
      if (tag === 'BLOCKQUOTE') return quote(blocksArr(n).join('\n\n'));
      if (tag === 'DT') return '**' + inlineKids(n) + '**';
      if (tag === 'DD') return blocksArr(n).join('\n\n');
      if (tag === 'DETAILS') {
        const sum = n.querySelector(':scope > summary');
        const head = sum ? inlineKids(sum) : '';
        const body = blocksArr(n, sum).join('\n\n');
        return (head ? '**' + head + '**\n\n' : '') + body;
      }
      if (n.hasAttribute && n.hasAttribute('data-pivot')) {
        return '**[' + n.getAttribute('data-pivot') + ']**\n\n' + blocksArr(n).join('\n\n');
      }
      if (n.classList.contains('tabGroup')) {
        const labels = [...n.querySelectorAll('[role="tab"]')].map((t) => t.textContent.trim());
        const panels = [...n.querySelectorAll('[role="tabpanel"]')];
        return panels.map((p, i) => '**[' + (labels[i] || 'tab ' + (i + 1)) + ']**\n\n' + blocksArr(p).join('\n\n')).join('\n\n');
      }
      for (const k of Object.keys(CALLOUT)) {
        if (n.classList.contains(k)) {
          const arr = blocksArr(n);
          if (arr.length && arr[0].replace(/[*:]/g, '').trim().toLowerCase() === CALLOUT[k].toLowerCase()) arr.shift();
          return quote('**' + CALLOUT[k] + '**\n\n' + arr.join('\n\n'));
        }
      }
      return blocksArr(n).join('\n\n');
    };

    function blocksArr(container, except) {
      const out = [];
      let buf = '';
      const flush = () => { const s = buf.replace(/[ \t]+\n/g, '\n').replace(/ {2,}(?!\n)/g, ' ').trim(); if (s) out.push(s); buf = ''; };
      for (const n of container.childNodes) {
        if (n === except) continue;
        if (n.nodeType === 3) { buf += text(n.nodeValue); continue; }
        if (n.nodeType !== 1 || n.matches(SKIP)) continue;
        if (!BLOCK.has(n.tagName)) { buf += inline(n); continue; }
        flush();
        const b = blockEl(n);
        if (b && b.trim()) out.push(b);
      }
      flush();
      return out;
    }
    return { blocksArr };
  }

  const meta = (doc, name) => (doc.querySelector('meta[name="' + name + '"]') || {}).content || '';

  function convert(html, pageUrl) {
    const doc = new DOMParser().parseFromString(html, 'text/html');
    const col = doc.querySelector('[data-main-column]');
    if (!col) return { error: 'no [data-main-column]' };
    const bodies = [...col.querySelectorAll('div.content')].sort((a, b) => b.textContent.length - a.textContent.length);
    const body = bodies[0] || col;
    const h1 = col.querySelector('h1');
    const base = (doc.querySelector('link[rel="canonical"]') || {}).href || pageUrl;
    const md = make(base).blocksArr(body).join('\n\n');
    return {
      title: h1 ? h1.textContent.trim() : doc.title,
      description: meta(doc, 'description'),
      msDate: meta(doc, 'ms.date'),
      updatedAt: meta(doc, 'updated_at'),
      gitUrl: meta(doc, 'original_content_git_url'),
      canonical: base,
      markdown: md,
      chars: md.length,
    };
  }

  function flatten(items) {
    const flat = [];
    const walk = (list, path) => (list || []).forEach((it, i) => {
      const p = path.concat(i + 1);
      flat.push({ idx: p.join('.'), depth: p.length, title: it.toc_title, href: it.href || null, hasChildren: !!(it.children && it.children.length) });
      walk(it.children, p);
    });
    walk(items, []);
    return flat;
  }

  window.__learn = {
    convert,
    async tocItems(tocPath) {
      const j = await (await fetch(tocPath)).json();
      const base = new URL(tocPath, location.href);
      return flatten(j.items).map((n) => {
        let url = null;
        if (n.href) url = /^https?:\/\//i.test(n.href) ? n.href : new URL(n.href, base).href;
        return Object.assign(n, { url, external: !!url && new URL(url).origin !== location.origin });
      });
    },
    async crawl(items, concurrency) {
      const results = new Array(items.length);
      let next = 0;
      const worker = async () => {
        while (next < items.length) {
          const i = next++;
          const it = items[i];
          try {
            const r = await fetch(it.url, { credentials: 'omit' });
            const html = await r.text();
            const base = { idx: it.idx, url: it.url, finalUrl: r.url, ok: r.ok, status: r.status };
            results[i] = r.ok ? Object.assign(base, convert(html, r.url)) : base;
          } catch (e) {
            results[i] = { idx: it.idx, url: it.url, ok: false, error: String(e) };
          }
        }
      };
      await Promise.all(Array.from({ length: concurrency || 6 }, worker));
      return results;
    },
  };
  return 'window.__learn ready';
}
