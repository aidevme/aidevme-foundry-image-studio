# Research Document Style

| Field | Value |
| --- | --- |
| **Document Title** | Research Document Style |
| **Document Location** | `docs/templates/RESEARCH_DOCUMENT_STYLE.md` |
| **Document Description** | Defines the layout, naming, index format, and synchronization rules for research documents, which are local reference copies of external documentation. It is intended for contributors and agents who copy, refresh, or index such documentation. |
| **Version** | 1.2 |
| **Last Updated On** | 2026-09-30 |

## Introduction

A **research document set** is a local copy of an external documentation site, stored next to the project documents so that engineers and agents can read it offline and cite it. Examples are the Microsoft Foundry documentation and a WordPress plugin handbook.

This guide defines how a set is organized: the folder layout, the file names, the **index document** that lists every page with its source URL and synchronization time, and the rules for keeping the copy current. The layout follows the WordPress Plugin Development Guide, which is the reference example for the index format (see [Template](#template)).

The [Generic Document Style](GENERIC_DOCUMENT_STYLE.md) still applies to the header of every document. Only its writing-style rules do not apply to the copied article text, which is not rewritten.

## Where research documents are stored

Each set has its own folder under `docs/research-docs/`, named after the subject in lowercase with hyphens, for example `docs/research-docs/azure-foundry/` or `docs/research-docs/wordpress-plugins/`.

```text
docs/research-docs/<subject>/
├── index.md                                   # the index document
├── 01-<section-slug>/
│   └── <section-slug>.md                      # the section page itself
├── 02-<section-slug>/
│   ├── <section-slug>.md                      # the section page
│   ├── <page-slug>.md                         # child page 2.1
│   └── <page-slug>.md                         # child page 2.2
└── 03-<section-slug>/
    └── ...
```

## Naming rules

| Item | Rule | Example |
| --- | --- | --- |
| Subject folder | Lowercase letters, digits, and hyphens | `wordpress-plugins` |
| Section folder | One folder for each top-level item of the source navigation. Prefix with the position as two digits, then a hyphen, then the slug of the section title. | `03-plugin-basics` |
| Section page | The page of the section itself is stored in the section folder and named after the section slug. | `03-plugin-basics/plugin-basics.md` |
| Child page | Named after the slug of its **title** (not the last part of its URL). It is stored in the folder of its top-level section. | `header-requirements.md` |
| Slug | Lowercase the title, replace every run of characters other than letters and digits with one hyphen, and remove leading and trailing hyphens. Keep the slug under 80 characters. | "Term Splitting (WordPress 4.2)" becomes `term-splitting-wordpress-4-2` |
| Duplicate titles | If two pages in one folder give the same slug, add the index number to the second file name. | `summary-16-5.md` |

The order of the section folders and of the rows in the index is the order of the source navigation.

## The index document

The index document is `index.md` in the subject folder. It lists every page of the set. It has this structure, in this order:

1. The title (`# <Subject> Guide`).
2. The document header table (five fields, see the [Generic Document Style](GENERIC_DOCUMENT_STYLE.md)).
3. A `Reference:` line with the URL of the source start page, written as an autolink in angle brackets.
4. An optional short introduction.
5. The heading `## Index`, followed by the index table.

### Index table columns

| Column | Content | Rules |
| --- | --- | --- |
| **Index** | Position in the source navigation | A number for a top-level item (`3`) and a dotted number for its children (`3.1`, `3.2`). Do not pad with zeros. Deeper levels continue the dotted number (`3.2.1`). |
| **Name** | Title of the page | The title as it appears on the source page, unchanged. |
| **Document** | Link to the local file | A relative Markdown link. The link text is the file name and the target is the path from the index document, for example `[header-requirements.md](03-plugin-basics/header-requirements.md)`. |
| **Reference Url** | The page that was copied | The final URL after redirects, in angle brackets: `<https://...>`. |
| **Last Synced On** | When the page was copied | UTC, ISO 8601, to the second, with `Z`: `2026-09-24T07:44:37Z`. |
| **Notes** | Synchronization status | A status word, optionally followed by an em dash and a short qualifier. See [Notes values](#notes-values). |

### Notes values

| Value | Meaning |
| --- | --- |
| `Synced` | The page was copied and matches the source at **Last Synced On**. |
| ``Synced — real slug is `routes-endpoints` `` | The URL name differs from the title slug used for the file name. The qualifier names the real URL slug. |
| `Synced — redirected: real URL is <path>` | The source URL redirected. **Reference Url** holds the final URL, and the note records the change. |
| `Synced — source content moved to <place>` | The page exists but its content now lives elsewhere at the source. |
| `Pending` | The page is in the source navigation but has not been copied yet. Leave **Document** and **Last Synced On** empty. |
| `Failed — <reason>` | The last attempt failed, for example `HTTP 404`. Keep the previous file and time if a copy exists. |
| `Synced — duplicate of <index>` | The source lists the same page in more than one place. The file is stored once, at one entry, and the other rows link to the same file and name the index of that entry. The stored entry is normally the first one in navigation order. The owner can choose another entry, for example the section that fits the page best. That entry keeps the value `Synced`. |
| `Group — no page at the source` | A navigation heading that has no page of its own. Keep the row so that the dotted numbering matches the source. Leave **Document**, **Reference Url**, and **Last Synced On** empty. |
| `Not copied — <reason>` | The page is linked but deliberately not copied, for example `outside the docset`. **Document** is empty and **Reference Url** links the source. |
| `Removed at source` | The page no longer exists at the source. The local file is kept until you decide to delete it. |

The values `Pending`, `Failed`, `Not copied`, `Removed at source`, `Group`, and the `duplicate of` qualifier extend the reference example, which only shows `Synced` and its other qualifiers.

## Page documents

Each copied page is a Markdown file that starts with:

1. The page title as a `#` heading.
2. The document header table (five fields). **Document Description** starts with "Reference copy of the source article" and adds the source description. **Last Updated On** is the date of the synchronization.
3. A source block that states the source, the index number, and the synchronization time:

   ```markdown
   > **Source:** [<site name>](<final url>). Index: <index number>. Article date: <date from the source>. Last synced: <ISO 8601 UTC>.
   >
   > **Reference copy.** <Owner> owns this content. It was converted to Markdown and is not rewritten. Check the source for the current version.
   ```

4. The article body.

Body rules:

- Keep the source wording. Do not summarize, translate, or restyle it.
- Convert the HTML structure faithfully: headings, lists, tables, code blocks with their language, and callouts as block quotes that start with a bold label (`> **Note**`).
- Keep the relative order of the source. Label tabbed or multi-language code samples with the tab name in bold.
- Rewrite a link to another page of the same set as a relative link to the local file. Leave every other link absolute.
- Link images to the source. Do not download them.
- Escape a `<` in plain text as `&lt;` so that it is not read as HTML.

## Synchronization rules

1. **Scope.** Copy the pages that belong to the documentation set (the same site path as the start page). Link, but do not copy, pages outside it and external sites, and mark them `Not copied`.
2. **Source of truth.** The source navigation defines the section order, the titles, and the index numbers. Read it from the site (for example a `toc.json` file) and do not build it by hand.
3. **One timestamp per run.** Every page fetched in one run gets the same **Last Synced On** value. A page that a run skips keeps its previous value.
4. **Refresh.** To refresh a set, run the copy again for the same subject folder. Overwrite the files that the run generates, update the index rows, and leave other files in the folder untouched, for example a hand-written overview.
5. **Redirects and slug differences.** Record them in **Notes**. Use the final URL in **Reference Url**.
6. **Removed pages.** Mark the row `Removed at source` and keep the file. Delete it only on a decision.
7. **Be polite to the site.** Fetch with a low concurrency, do not sign in, and stop on HTTP 403 or 429.
8. **Record the run.** State in the pull request or the run report how many pages were copied, skipped, and failed.

The [fetch-site-docs skill](../project-docs/claude/skills/fetch-site-docs.md) implements the copy for Microsoft Learn, and the [researcher agent](../project-docs/claude/agents/researcher.md) runs it.

## Licensing and attribution

The copied text belongs to its owner. Every page states the source and the owner. Check the licence terms of the source before you publish the copy, in particular in a public repository, and record the result in the index introduction. This guide does not assess any licence.

## Quality checks

Before you commit a set, confirm that:

- Every row of the index that names a **Document** points to an existing file, and every file of the set has at least one row.
- Every relative link in the set resolves.
- Every file has the five header fields, and **Document Location** matches its path.
- Every **Last Synced On** value uses the format `YYYY-MM-DDThh:mm:ssZ`.
- Every **Notes** value is one of the [defined values](#notes-values).
- Section folders are numbered in the order of the source navigation, without gaps.
- The set is listed in [docs/index.md](../index.md).

## Template

### Index document

````markdown
# <Subject> Guide

| Field | Value |
| --- | --- |
| **Document Title** | <Subject> Guide |
| **Document Location** | `docs/research-docs/<subject>/index.md` |
| **Document Description** | Index of the local reference copy of <the source documentation>, in the order of its navigation. |
| **Version** | 1.0 |
| **Last Updated On** | YYYY-MM-DD |

Reference: <https://example.com/docs/>

## Index

| Index | Name | Document | Reference Url | Last Synced On | Notes |
| --- | --- | --- | --- | --- | --- |
| 1 | Handbook | [handbook.md](01-handbook/handbook.md) | <https://example.com/docs/> | 2026-09-24T07:44:37Z | Synced |
| 2 | Introduction | [introduction.md](02-introduction/introduction.md) | <https://example.com/docs/intro/> | 2026-09-24T07:44:37Z | Synced |
| 2.1 | What is a Plugin? | [what-is-a-plugin.md](02-introduction/what-is-a-plugin.md) | <https://example.com/docs/intro/what-is-a-plugin/> | 2026-09-24T07:44:37Z | Synced |
| 2.2 | Routes & Endpoints | [routes-and-endpoints.md](02-introduction/routes-and-endpoints.md) | <https://example.com/docs/intro/routes-endpoints/> | 2026-09-24T07:44:37Z | Synced — real slug is `routes-endpoints` |
| 2.3 | Responses | [responses.md](02-introduction/responses.md) | <https://example.com/docs/intro/responses-2/> | 2026-09-24T07:44:37Z | Synced — redirected: real URL is /docs/intro/responses-2/ |
| 3 | Reference | | <https://example.com/api/> | | Not copied — outside the docset |
````

### Page document

````markdown
# <Page title>

| Field | Value |
| --- | --- |
| **Document Title** | <Page title> |
| **Document Location** | `docs/research-docs/<subject>/<NN-section>/<page-slug>.md` |
| **Document Description** | Reference copy of the source article "<Page title>". <Source description.> |
| **Version** | 1.0 |
| **Last Updated On** | YYYY-MM-DD |

> **Source:** [<Site name>](<final url>). Index: <index number>. Article date: <date>. Last synced: YYYY-MM-DDThh:mm:ssZ.
>
> **Reference copy.** <Owner> owns this content. It was converted to Markdown and is not rewritten. Check the source for the current version.

<Article body.>
````

## Current state

The Microsoft Foundry set in [docs/research-docs/azure-foundry/](../research-docs/azure-foundry/index.md) uses the index table of this guide. It still differs from the guide in two ways:

- File names start with a sequence number and use the last part of the URL (`01-deploy-foundry-models.md`), not the page title.
- It uses group subfolders (`06.1-explore-foundry-models`) below the section folders. The guide treats them as an option, and the set declares its use in the index introduction.

Its **Last Synced On** values show the date of the first synchronization (2026-09-29) with the time `00:00:00Z`, because the time of day was not recorded. The next synchronization replaces them with exact times.

## Related documents

- [Generic Document Style](GENERIC_DOCUMENT_STYLE.md)
- [fetch-site-docs skill](../project-docs/claude/skills/fetch-site-docs.md)
- [researcher agent](../project-docs/claude/agents/researcher.md)
- [Documentation index](../index.md)
