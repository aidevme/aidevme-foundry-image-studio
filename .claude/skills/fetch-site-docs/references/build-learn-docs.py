#!/usr/bin/env python3
"""Write crawled Microsoft Learn pages as Markdown files under a docs folder.

Input (produced by references/learn-to-markdown.js through Playwright MCP):
  --toc      JSON list of navigation nodes: idx, depth, title, href, url, external, hasChildren
  --batches  folder with batch-*.json files (page results with markdown and metadata)

Layout written under --out:
  NN-<section-slug>/                 one folder per top-level navigation item (NN = position, 2 digits)
  NN-<section>/NN.g-<group-slug>/    one folder per second-level GROUP (g counts groups only, from 1)
  <seq>-<url-leaf>.md                pages in navigation order; deeper levels are flattened into the group folder
  index.md                           table of contents linking every page

Every page gets the repository document header (five fields), a source block and the converted content.
Links between copied pages are rewritten to relative local links. Nothing outside --out is touched.
"""
import argparse, collections, glob, json, os, posixpath, re, sys
from urllib.parse import urlsplit


def slug(text, limit=70):
    s = re.sub(r'[^a-z0-9]+', '-', text.lower()).strip('-')
    return s[:limit].strip('-') or 'page'


def norm(url):
    """Key used to match links to copied pages: host + path without locale, query, fragment or slash."""
    p = urlsplit(url)
    path = re.sub(r'^/en-us(?=/)', '', p.path).rstrip('/').lower()
    return p.netloc.lower() + path


def unescape_gt(md):
    """Turn "&gt;" back into ">" outside fenced code, except at a line start (where ">" would open a quote)."""
    parts = re.split(r'(?ms)(^`{3,}[^\n]*\n.*?^`{3,}[ \t]*$)', md)
    out = []
    for i, seg in enumerate(parts):
        if i % 2 == 1:          # fenced code block: leave untouched
            out.append(seg)
            continue

        def f(m, seg=seg):
            st = m.start()
            return '&gt;' if st == 0 or seg[st - 1] == '\n' else '>'

        out.append(re.sub(r'&gt;', f, seg))
    return ''.join(out)


def cell(s):
    return re.sub(r'\s+', ' ', s).replace('|', '\\|').strip()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--toc', required=True)
    ap.add_argument('--batches', required=True)
    ap.add_argument('--out', required=True, help='target docs folder, for example docs/research-docs/azure-foundry')
    ap.add_argument('--repo-root', required=True)
    ap.add_argument('--prefix', required=True, help='URL prefix of the docset, for example https://learn.microsoft.com/en-us/azure/foundry/')
    ap.add_argument('--date', required=True, help='retrieval date, YYYY-MM-DD')
    ap.add_argument('--title', default='Microsoft Foundry documentation (reference copy)')
    ap.add_argument('--start-url', default='')
    args = ap.parse_args()

    toc = json.load(open(args.toc, encoding='utf-8'))
    pages = {}
    for f in sorted(glob.glob(os.path.join(args.batches, 'batch-*.json'))):
        for r in json.load(open(f, encoding='utf-8')):
            pages[r['idx']] = r
    out_root = os.path.abspath(args.out)
    repo_root = os.path.abspath(args.repo_root)

    titles = {n['idx']: n['title'] for n in toc}

    # ---- placement -------------------------------------------------------------------------
    node_path = {}                       # toc idx -> absolute file path (first occurrence only)
    seen = {}                            # normalized url -> file path
    seq = collections.Counter()
    top_dir = cur_dir = None
    top_no = group = 0
    for n in toc:
        if n['depth'] == 1:
            top_no += 1
            group = 0
            top_dir = os.path.join(out_root, '%02d-%s' % (top_no, slug(n['title'])))
            cur_dir = top_dir
        elif n['depth'] == 2:
            if n['hasChildren']:
                group += 1
                cur_dir = os.path.join(top_dir, '%02d.%d-%s' % (top_no, group, slug(n['title'])))
            else:
                cur_dir = top_dir
        if n['idx'] not in pages:
            continue
        key = norm(n['url'])
        if key in seen:
            continue
        seq[cur_dir] += 1
        leaf = urlsplit(n['url']).path.rstrip('/').rsplit('/', 1)[-1]
        path = os.path.join(cur_dir, '%02d-%s.md' % (seq[cur_dir], slug(leaf)))
        seen[key] = path
        node_path[n['idx']] = path

    url_to_path = dict(seen)
    for idx, r in pages.items():
        if idx in node_path and r.get('finalUrl'):
            url_to_path.setdefault(norm(r['finalUrl']), node_path[idx])

    def rel_repo(path):
        return os.path.relpath(path, repo_root).replace(os.sep, '/')

    def rewrite(md, from_path):
        base = os.path.dirname(from_path)

        def sub(m):
            url = m.group(1)
            frag = ''
            if '#' in url:
                url, frag = url.split('#', 1)
                frag = '#' + frag
            target = url_to_path.get(norm(url))
            if not target:
                return m.group(0)
            rel = os.path.relpath(target, base).replace(os.sep, '/')
            return '](' + rel + frag + ')'

        return re.sub(r'\]\((https?://[^)\s]+)\)', sub, md)

    # ---- write pages -----------------------------------------------------------------------
    written = 0
    for n in toc:
        path = node_path.get(n['idx'])
        if not path:
            continue
        r = pages[n['idx']]
        crumbs = []
        parts = n['idx'].split('.')
        for i in range(1, len(parts)):
            crumbs.append(titles.get('.'.join(parts[:i]), ''))
        crumb = ' > '.join([c for c in crumbs if c] + [n['title']])
        desc = cell(r.get('description') or '')
        title = r['title']
        header = [
            '# ' + title,
            '',
            '| Field | Value |',
            '| --- | --- |',
            '| **Document Title** | %s |' % cell(title),
            '| **Document Location** | `%s` |' % rel_repo(path),
            '| **Document Description** | Reference copy of the Microsoft Learn article "%s". %s |' % (cell(title), desc),
            '| **Version** | 1.0 |',
            '| **Last Updated On** | %s |' % args.date,
            '',
            '> **Source:** [%s](%s). Article date: %s. Page updated: %s. Retrieved: %s. Navigation: %s.' % (
                'Microsoft Learn', r['canonical'] or r['url'], (r.get('msDate') or '')[:10] or 'not stated',
                (r.get('updatedAt') or '')[:10] or 'not stated', args.date, crumb),
            '>',
            '> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.',
            '',
        ]
        md = unescape_gt(rewrite(r['markdown'], path))
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, 'w', encoding='utf-8', newline='\n') as fh:
            fh.write('\n'.join(header) + '\n' + md.rstrip() + '\n')
        written += 1

    # ---- index -----------------------------------------------------------------------------
    idx_path = os.path.join(out_root, 'index.md')
    lines = [
        '# ' + args.title, '',
        '| Field | Value |', '| --- | --- |',
        '| **Document Title** | %s |' % args.title,
        '| **Document Location** | `%s` |' % rel_repo(idx_path),
        '| **Document Description** | Index of the local reference copy of the Microsoft Foundry documentation on Microsoft Learn, in the order of its navigation. It is intended for engineers who need the Foundry documentation offline or next to the architecture documents. |',
        '| **Version** | 1.0 |', '| **Last Updated On** | %s |' % args.date, '',
        '## Introduction', '',
        'The folders below follow the navigation of the Microsoft Foundry documentation%s. Top-level sections are numbered `01` to `%02d`. Second-level groups inside a section are numbered `NN.1`, `NN.2`, and so on. Each page is a Markdown copy of a Microsoft Learn article that starts with a source block. Pages that appear in more than one place in the navigation are stored once.' % (
            (' (start page: %s)' % args.start_url) if args.start_url else '', top_no),
        '', 'Articles outside the Foundry documentation set (API references and other Azure services) and external sites are linked, not copied.', '',
        '## Contents', '',
    ]
    for n in toc:
        indent = '  ' * (n['depth'] - 1)
        title = n['title']
        target = node_path.get(n['idx']) or (url_to_path.get(norm(n['url'])) if n.get('url') and not n.get('external') else None)
        if target:
            rel = os.path.relpath(target, out_root).replace(os.sep, '/')
            lines.append('%s- [%s](%s)' % (indent, title, rel))
        elif n.get('url'):
            lines.append('%s- [%s](%s) (not copied)' % (indent, title, n['url']))
        else:
            lines.append('%s- **%s**' % (indent, title))
    lines += ['', '## Related documents', '', '- [Documentation index](../index.md)', '']
    with open(idx_path, 'w', encoding='utf-8', newline='\n') as fh:
        fh.write('\n'.join(lines))

    folders = sorted({os.path.dirname(p) for p in node_path.values()})
    print('pages written:', written)
    print('folders used:', len(folders))
    print('unique pages placed:', len(node_path), '| duplicate navigation entries linked to existing copy:',
          sum(1 for n in toc if n['idx'] in pages and n['idx'] not in node_path))
    print('not copied (outside docset or external):', sum(1 for n in toc if n.get('url') and n['idx'] not in pages and norm(n['url']) not in url_to_path))


if __name__ == '__main__':
    sys.exit(main())
