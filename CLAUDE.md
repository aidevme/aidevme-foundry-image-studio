# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

aidevme-foundry-image-studio: multi-agent image generation on Microsoft Foundry — an orchestrator plus specialist agents, tier-based model routing (GPT-image-2.5 Flare/Sunburst, MAI-Image), an MCP server for VS Code, reusable agent skills, and official Microsoft product icons.

## Repository state

This repository currently contains no implemented source code — only project scaffolding:

- `README.md`, `CONTRIBUTING.md`, `LICENSE` (MIT), `assets/` (social preview image)
- `.github/ISSUE_TEMPLATE/` — bug report, feature request, and question templates
- `docs/` — documentation, with `docs/index.md` as the index
  - `docs/claude/agents/` — one document per custom subagent
  - `docs/claude/agent-memory/` — one document per subagent memory, plus an overview
  - `docs/claude/skills/` — one document per skill, plus an overview
  - `docs/templates/GENERIC_DOCUMENT_STYLE.md` — the required document header and writing style
  - `docs/azure-foundry/`, `docs/open-ai/`, `docs/azure-ai-search/`, `docs/terraform/` — empty placeholder directories for future documentation
- `src/` — all source code lives here, one folder per service (`image-mcp`, `facade-mcp`, `icon-service`, `vscode-proxy`, `shared`); each currently holds only a README stub
- `.infrastructure/` — Bicep templates (`main.bicep`, `modules/`, `main.dev.bicepparam`) that provision the Azure resources; workflows that deploy them are `.github/workflows/infra-validate.yml` and `infra-deploy.yml`. Check with `az bicep lint --file .infrastructure/main.bicep`. See `docs/aidevme-foundry-image-studio/INFRASTRUCTURE.md`.
- `.claude/agents/` — custom subagents (`architect`, `developer`, `tester`, `reviewer`, `documenter`, `researcher`) for this project's workflow
- `.claude/agent-memory/<agent>/` — persistent project memory for each subagent (`memory: project`), created by the agents at run time and shared through version control; never store secrets there
- `.claude/skills/write-document/` — skill (with `evals/evals.json`) that applies the document style; preloaded by the `documenter` agent

There is no build system, package manifest, lint config, or test suite yet. The implementation language is decided: **TypeScript on Node.js** for all services under `src/` and for the VS Code proxy (an npm package), with Python only for the icon scripts (ADR-015, decision D2). The toolchain (workspace manifest, TypeScript configuration, linter, formatter, test runner) is task P0.1.2 and does not exist yet, so check for a `package.json` before running build, lint, or test commands, and do not invent commands. When the codebase is scaffolded, update this file with the real commands and architecture.

## Source code conventions

- Store all source code under `src/`, in the folder of the service it belongs to. Do not put source files at the repository root or under `docs/`.
- The planned layout and build order are in `docs/aidevme-foundry-image-studio/ARCHITECTURE.md` (section 18) and `IMPLEMENTATION.md`. Follow them unless you record a decision to change them.
- The VS Code proxy lives in `src/vscode-proxy/` (the architecture originally placed it in `clients/`; the architecture has been updated).

## Documentation conventions

- Every document under `docs/` must follow `docs/templates/GENERIC_DOCUMENT_STYLE.md`: a header table with Document Title, Document Location, Document Description, Version, and Last Updated On, and a professional technical writing style. Use the `write-document` skill or the `documenter` agent to create or edit docs.
- Update a document's Version and Last Updated On whenever you change its content (typo-only fixes excepted), and list every new document in `docs/index.md`.
- When an agent definition in `.claude/agents/` or a skill in `.claude/skills/` changes, update the matching document in `docs/claude/agents/` or `docs/claude/skills/`.
- The `documenter` agent reviews all documents on every invocation and updates those that are outdated.
