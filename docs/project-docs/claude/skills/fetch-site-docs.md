# fetch-site-docs skill

| Field | Value |
| --- | --- |
| **Document Title** | fetch-site-docs skill |
| **Document Location** | `docs/project-docs/claude/skills/fetch-site-docs.md` |
| **Document Description** | Describes the fetch-site-docs skill, which retrieves the pages of a documentation website with the Playwright MCP browser and saves them as Markdown reference copies under docs/. It is intended for contributors who use, test, or maintain the skill. |
| **Version** | 1.2 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The fetch-site-docs skill copies a documentation set into the repository. It reads the site navigation, fetches every page, converts the article HTML to Markdown, and writes numbered folders that follow the navigation. It is a development skill: it helps Claude Code build this repository and is never deployed (see [Skills overview](index.md)).

The skill was first used on the Microsoft Foundry documentation on Microsoft Learn. The copy is stored in [docs/research-docs/azure-foundry/](../../../research-docs/azure-foundry/index.md).

## Location and files

The skill is in `.claude/skills/fetch-site-docs/`.

| Path | Purpose |
| --- | --- |
| [SKILL.md](../../../../.claude/skills/fetch-site-docs/SKILL.md) | Frontmatter and the ten steps that Claude follows |
| [references/learn-to-markdown.js](../../../../.claude/skills/fetch-site-docs/references/learn-to-markdown.js) | Runs inside the browser page. Reads `toc.json`, fetches pages, and converts HTML to Markdown. |
| [references/build-learn-docs.py](../../../../.claude/skills/fetch-site-docs/references/build-learn-docs.py) | Places pages in folders, adds document headers, rewrites links, and writes `index.md` |
| [evals/evals.json](../../../../.claude/skills/fetch-site-docs/evals/evals.json) | Seven test cases. They have not been run. |

Frontmatter fields: `name` (`fetch-site-docs`) and `description`.

## Who uses it

The [researcher agent](../agents/researcher.md) preloads the skill through its `skills:` list. Its tool list contains four Playwright MCP tools from the `model-apps` plugin (`browser_navigate`, `browser_evaluate`, `browser_wait_for`, `browser_close`). It does not have the tool that runs arbitrary code (`browser_run_code_unsafe`).

## How it works

1. Claude confirms the start URL, the target folder under `docs/`, and whether existing files may be overwritten, and warns about licensing.
2. It opens the start page and loads the converter into the page.
3. It reads the docset navigation (`toc.json`), saves it, and selects the pages of the docset. Pages that appear in several places in the navigation are stored once.
4. It fetches the pages in batches of 40 with a concurrency of 8, and saves each batch to `.playwright-mcp/crawl/`.
5. It validates the batches, runs the build script, and verifies the files and links.
6. It deletes `.playwright-mcp/`, closes the browser, and reports.

### Folder and file layout

| Item | Rule | Example |
| --- | --- | --- |
| Section folder | One folder per top-level navigation item, numbered `NN-<slug>` | `06-models` |
| Group folder | One folder per second-level group, numbered `NN.g-<slug>`, where `g` counts groups from 1 | `06.4-model-deployment` |
| Page file | `<seq>-<url-leaf>.md`, in navigation order. Deeper levels are flattened into the group folder. | `01-deploy-foundry-models.md` |
| Index | `index.md` in the target folder lists every page in navigation order | `docs/research-docs/azure-foundry/index.md` |

Each page starts with the repository document header (five fields), a source block (URL, article date, page update date, retrieval date, navigation path), and a reference-copy notice. Links to other copied pages are relative, and links to pages outside the copy stay absolute.

## Inputs and outputs

| Item | Detail |
| --- | --- |
| Input | Start URL, target folder under `docs/`, retrieval date |
| Output | Markdown files and `index.md` under the target folder |
| Temporary files | `.playwright-mcp/crawl/` (deleted at the end) |
| Result of the first run | 463 pages in 49 folders, about 10 MB, from the Microsoft Foundry documentation on 2026-09-29 |

## Constraints

- The skill only reads the website and writes only under the named `docs/` folder.
- It does not rewrite article text, and it keeps the source URL and dates in each file.
- It supports Microsoft Learn only. Another site needs its own extractor.
- Images are linked to the source and not downloaded.
- The browser can write files only inside the repository and its `.playwright-mcp` folder.

## Licensing

The copied pages are Microsoft content. The skill adds a notice to each file and asks Claude to remind you to check the licence terms before you publish the copy. This repository can be public. The licence terms of the Microsoft Learn source were not verified when the skill was written.

## Test and maintain

1. Run the seven cases in `evals/evals.json`. They have not been run.
2. To test on a small scale, ask the researcher agent to copy one section into a temporary folder under `docs/` and review the result.
3. When Microsoft changes the page layout, update `learn-to-markdown.js` (the selectors `[data-main-column]` and `div.content`, and the callout classes) and run the skill on a few pages.
4. To refresh a copy, run the skill again for the same target folder. It overwrites the files that it generated and leaves other files untouched.
5. When you change the skill, update this document and the version in the header.

## Related documents

- [Skills overview](index.md)
- [researcher agent](../agents/researcher.md)
- [Microsoft Foundry documentation copy](../../../research-docs/azure-foundry/index.md)
- [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md)
