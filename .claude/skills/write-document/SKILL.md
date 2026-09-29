---
name: write-document
description: Write or update a documentation file in this repository following the standard document style (metadata header with title, location, description, version and last-updated date, professional technical writing). Use whenever creating or editing files under docs/, including agent docs, guides and reference pages.
---

# Write a document in the repository style

The single source of truth is [docs/templates/GENERIC_DOCUMENT_STYLE.md](../../../docs/templates/GENERIC_DOCUMENT_STYLE.md). Read it in full before writing. Do not restate its rules from memory, because it may have changed.

## Steps

1. **Read the style guide.** Open `docs/templates/GENERIC_DOCUMENT_STYLE.md` and follow its header, structure, writing style, and naming rules.
2. **Read the source material.** Read the code, configuration, or agent definition you are documenting. Do not describe behavior from the request alone.
3. **Choose the location.** Save the file under `docs/<topic-folder>/` with a lowercase, hyphen-separated name.
4. **Create or update the document.**
   - New document: start from the template at the bottom of the style guide. Fill in all five header fields: Document Title, Document Location, Document Description, Version (`1.0`) and Last Updated On (today's date, `YYYY-MM-DD`).
   - Existing document: apply the change, then update **Version** and **Last Updated On** according to the versioning rules in the style guide. If the file has no header, add one.
5. **Update the index.** Add or update the entry in `docs/index.md`.
6. **Run the review checklist.** Complete the checklist at the end of the style guide's writing style section before you finish.

## Reporting

End with a short summary of the files created or changed and their versions. State anything you could not verify against code or configuration, such as an inferred setting or environment variable name.

## Constraints

- Write documentation only. Do not change application code.
- Never include secrets, keys, or tokens. Use placeholders.
- Link to existing documents instead of duplicating their content.
