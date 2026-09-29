---
name: project-open-gaps
description: Documentation gaps flagged to the user that still need a decision
metadata:
  type: project
---

- docs/templates/GENERIC_DOCUMENT_STYLE.md, docs/index.md, README.md, CONTRIBUTING.md, CLAUDE.md, assets/index.md (empty file) have no five-field header; unclear if exempt. Flagged 2026-09-29.
- write-document evals have stale preconditions (eval 2 reviewer.md header, eval 3 style guide header, evals 5/6 docs/azure-foundry/) and no eval runner or results exist.

**Why:** Needs user decision; do not invent headers for template/index/root files without it.
**How to apply:** Re-check whether the user has decided before flagging again.
