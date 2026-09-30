---
name: project-open-gaps
description: Documentation gaps flagged to the user that still need a decision (checked 2026-09-29)
metadata:
  type: project
---

- docs/templates/GENERIC_DOCUMENT_STYLE.md, docs/index.md, README.md, CONTRIBUTING.md, CLAUDE.md, assets/index.md (empty file) have no five-field header; unclear if exempt. Flagged 2026-09-29.
- write-document evals have stale preconditions (eval 2 reviewer.md header, eval 3 style guide header, evals 5/6 docs/research-docs/azure-foundry/) and no eval runner or results exist. Flagged 2026-09-29.
- docs/aidevme-foundry-image-studio/SPECIFICATION.md and docs/adr/ADR-010.md are empty files and are not listed in docs/index.md. Flagged 2026-09-29 (orchestration update).
- D3/D9 (orchestration mechanism, hosted-agent language) are "recommended, pending owner decision"; docs must not present them as accepted. Where hosted-agent code lives (agents/ vs src/) is open (architecture open question 14).

- docs/project-docs/github/workflows/ (created 2026-09-30): AADSTS7002138 cause and AI Search capacity cause are unverified; infra-delete dry run does not list soft-deleted resources although the workflow file comment says it does (owner may fix the workflow or comment); no workflow run has been observed.

- docs/project-docs/bicep/ (created 2026-09-30, 16 docs): bicep lint/build could not be run (Bash disabled in the subagent); role display names in rbac.md derived from variable names, not looked up; unresolved template risks flagged to owner: containerapps placeholder image port (helloworld vs targetPort 8080), no identity clientId/AZURE_CLIENT_ID, App Insights DisableLocalAuth with no Monitoring Metrics Publisher role, facade external ingress without auth, no roles for Search/Key Vault/ACR push, dev allowedIpAddresses empty. ARCHITECTURE change-table has G-17 above G-16 (cosmetic). INFRASTRUCTURE.md code samples are still stale (note added, v3.1); azd sections kept for reference.

**Why:** Needs user decision; do not invent headers, index entries or decisions without it.
**How to apply:** Re-check whether the user has decided before flagging again; when a decision is recorded, change "Proposed" wording in ARCHITECTURE.md (5.6, ADR-016, open questions 2 and 14), IMPLEMENTATION.md (D3, D9), CLAUDE.md and the developer agent files together.
