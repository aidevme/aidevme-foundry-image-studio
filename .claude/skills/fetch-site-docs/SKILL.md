---
name: fetch-site-docs
description: Retrieve documentation pages from a website with the Playwright MCP browser and save them as Markdown reference copies under docs/. Supports Microsoft Learn documentation sets (learn.microsoft.com) by reading their toc.json navigation. Use when asked to copy, mirror, download, or refresh documentation from a website into the repository, for example the Microsoft Foundry documentation.
---

# Fetch site documentation into docs/

Copies the pages of a documentation set into Markdown files under `docs/`, in the order of the site's navigation. It is proven on Microsoft Learn. Other sites need their own extractor (see [Limits](#limits)).

Files in this skill:

| File | Purpose |
| --- | --- |
| [references/learn-to-markdown.js](references/learn-to-markdown.js) | Runs inside the page. Reads the navigation (`toc.json`), fetches pages, and converts the article HTML to Markdown. |
| [references/build-learn-docs.py](references/build-learn-docs.py) | Writes the files: numbered folders, document headers, local link rewriting, and `index.md`. |

## Before you start

1. Confirm with the user: the **start URL**, the **target folder** under `docs/`, and whether existing files may be overwritten. Do not guess the target folder.
2. Tell the user that the pages are Microsoft (or other third-party) content, that the copy goes into the repository, and that they must check the licence terms before publishing it. This repository can be public.
3. Use only the Playwright MCP tools `browser_navigate`, `browser_evaluate`, `browser_wait_for`, and `browser_close`. Never use `browser_run_code_unsafe`, file upload, form, or click tools for this task.

## Steps

1. **Open the start page.** Call `browser_navigate` with the start URL. Every later `browser_evaluate` call runs on this origin, so the page must stay loaded. If the page becomes `about:blank`, navigate again and reload the converter (step 2).
2. **Load the converter.** Read `references/learn-to-markdown.js`. Pass its whole content (the `() => { ... }` function) as the `function` argument of `browser_evaluate`. The result must be `window.__learn ready`.
3. **Read the navigation.** The docset navigation file is named in `<meta name="toc_rel">` (usually `toc.json` next to the docset root, for example `/en-us/azure/foundry/toc.json`). Run:

   ```js
   async () => { window.__all = await window.__learn.tocItems('/en-us/azure/foundry/toc.json'); return window.__all.length; }
   ```

   Then save it with `browser_evaluate` and `filename: ".playwright-mcp/crawl/toc.json"` using `() => window.__all`. The tool writes only inside the repository or `.playwright-mcp`.
4. **Choose the pages.** Keep the nodes whose URL starts with the docset prefix (for example `https://learn.microsoft.com/en-us/azure/foundry/`). Remove the query string and fragment, and keep the first occurrence of each URL, because a page can appear in several places in the navigation:

   ```js
   () => {
     const prefix = location.origin + '/en-us/azure/foundry/';
     const seen = new Set(); const todo = [];
     for (const n of window.__all) {
       if (!n.url || n.external || !n.url.startsWith(prefix)) continue;
       const key = n.url.split('#')[0].split('?')[0];
       if (seen.has(key)) continue;
       seen.add(key); todo.push({ idx: n.idx, url: key });
     }
     window.__todo = todo; return todo.length;
   }
   ```

   Report the number of pages to the user before you fetch them. Pages outside the docset (API references, other Azure services) and external sites are linked in the index, not copied.
5. **Fetch in batches.** For each block of 40 pages, call `browser_evaluate` with `filename: ".playwright-mcp/crawl/batch-NN.json"` (`NN` is 01, 02, ...) and:

   ```js
   async () => await window.__learn.crawl(window.__todo.slice(0, 40), 8)
   ```

   Move the slice (`40, 80`, `80, 120`, ...) for each batch, and use `slice(440)` for the last one. The concurrency is 8. Do not raise it. Stop and report if the site answers with 403 or 429.
6. **Validate the batches.** With Python, load every `batch-*.json` and check: the count equals the number of pages, no entry has `ok: false` or `error`, no page is empty, and no Markdown contains `Ask Learn`, `Was this page helpful`, or raw `<div`. Fetch a failed page again in a smaller batch. Report pages that still fail.
7. **Build the files.** Run:

   ```bash
   python .claude/skills/fetch-site-docs/references/build-learn-docs.py \
     --toc .playwright-mcp/crawl/toc.json --batches .playwright-mcp/crawl \
     --out docs/<target-folder> --repo-root . \
     --prefix https://learn.microsoft.com/en-us/azure/foundry/ \
     --date <today, YYYY-MM-DD> --start-url <start URL>
   ```

   The script places each page in `NN-<section>/` (top-level navigation item) or `NN-<section>/NN.g-<group>/` (second-level group, counted from 1), names the file `<seq>-<url-leaf>.md`, adds the repository document header and a source block, rewrites links between copied pages to relative links, and writes `index.md`. It overwrites files it generates and leaves every other file untouched, for example an existing `overview.md`.
8. **Verify.** Count the written files and check that every one has the five header fields, and that every relative link resolves. Links that match only inside code blocks are not links.
9. **Clean up.** Delete the `.playwright-mcp/` folder in the repository root (raw batches, snapshots, and console logs), and call `browser_close`.
10. **Report** to the user: pages copied, pages not copied and why, folders created, size, failures, the licence reminder, and that images are linked to the source, not downloaded.

## Rules

- Read only. Fetch pages with same-origin `fetch` inside `browser_evaluate`. Do not sign in, submit forms, or change anything on the site.
- Write only under the target folder in `docs/`, and only through `build-learn-docs.py`. Do not edit or delete other files.
- Do not rewrite or summarize the article text. The copy keeps the source wording and states that Microsoft owns the content.
- Keep the source URL, article date, page update date, and retrieval date in each file. Do not remove the reference-copy notice.
- Follow the repository document style for the header and the folder names (`docs/templates/GENERIC_DOCUMENT_STYLE.md`). The article body is not restyled.
- After a run, list the new documents in `docs/index.md` (link `index.md` of the target folder) and update `docs/project-docs/claude/skills/` if the skill changed.

## Limits

- The converter reads `[data-main-column]` and `toc.json`, which are specific to Microsoft Learn. Another site needs a new extractor file in `references/` and a matching section in this skill.
- Learn API reference pages (`/rest/api/`, `/python/api/`) use a different layout and are outside the Foundry docset, so they are not copied.
- Code samples for several languages (zone pivots) are all kept and labeled `**[python]**`, `**[rest-api]**`, and so on. Tabbed sections are labeled with their tab names.
- Images are not downloaded. Their links point to the source site.
- Heading anchors in links to other copied pages assume GitHub anchor rules and can differ from Learn anchors in rare cases.
- A page that changes on the site after the copy needs a refresh. Run the skill again for the same target folder.
