# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

aidevme-foundry-image-studio: multi-agent image generation on Microsoft Foundry — an orchestrator plus specialist agents, tier-based model routing (GPT-image-2.5 Flare/Sunburst, MAI-Image), an MCP server for VS Code, reusable agent skills, and official Microsoft product icons.

## Repository state

This repository currently contains no implemented source code — only project scaffolding:

- `README.md`, `CONTRIBUTING.md`, `LICENSE` (MIT), `assets/` (social preview image)
- `.github/ISSUE_TEMPLATE/` — bug report, feature request, and question templates
- `docs/` — documentation, with `docs/index.md` as the index
  - `docs/project-docs/claude/agents/` — one document per custom subagent
  - `docs/project-docs/claude/agent-memory/` — one document per subagent memory, plus an overview
  - `docs/project-docs/claude/skills/` — one document per skill, plus an overview
  - `docs/project-docs/bicep/` — one document per Bicep file (`main.bicep`, the parameter file, and each module in `docs/project-docs/bicep/modules/`), plus an overview
  - `docs/project-docs/github/workflows/` — one document per GitHub Actions workflow, plus an overview
  - `docs/templates/GENERIC_DOCUMENT_STYLE.md` — the required document header and writing style
  - `docs/templates/RESEARCH_DOCUMENT_STYLE.md` — layout, index table, and sync rules for research documents (copies of external documentation under `docs/research-docs/`)
  - `docs/research-docs/azure-foundry/` (with numbered subfolders `01-` to `13-` that follow the Microsoft Foundry documentation sections), `docs/open-ai/`, `docs/azure-ai-search/`, `docs/terraform/` — empty placeholder directories for future documentation
- `src/` — all source code lives here, one folder per service (`image-mcp`, `facade-mcp`, `icon-service`, `vscode-proxy`, `infrastructure`, `shared`); each currently holds only a README stub. `src/infrastructure/` holds infrastructure code that is not Bicep (post-provisioning scripts for agents, toolbox, skills, routing table and brand index)
- `bicep/` — Bicep templates only (`main.bicep`, `modules/`, `main.dev.bicepparam`) that provision the Azure resources; workflows that validate, deploy and delete them are `.github/workflows/infra-validate.yml`, `infra-deploy.yml` and `infra-delete.yml` (all manual; documented in `docs/project-docs/github/workflows/`). Check with `az bicep lint --file bicep/main.bicep`. See `docs/project-docs/bicep/index.md` for the templates as implemented and `docs/aidevme-foundry-image-studio/INFRASTRUCTURE.md` for the design. When you change a file in `bicep/`, update the matching document in `docs/project-docs/bicep/`.
- `.claude/agents/` — custom subagents (`architect`, `developer`, `tester`, `reviewer`, `documenter`, `researcher`) for this project's workflow
- `.claude/agent-memory/<agent>/` — persistent project memory for each subagent (`memory: project`), one subfolder per agent (`architect`, `developer`, `documenter`, `researcher`, `reviewer`, `tester`), created by the agents at run time and shared through version control; never store secrets there. See [Agent memory conventions](#agent-memory-conventions)
- `.claude/skills/write-document/` — skill (with `evals/evals.json`) that applies the document style; preloaded by the `documenter` agent

There is no build system, package manifest, lint config, or test suite yet. The implementation language is decided: **TypeScript on Node.js** for all services under `src/` and for the VS Code proxy (an npm package), with Python only for the icon scripts (ADR-015, decision D2). The hosted agents (orchestrator and image agent) cannot be TypeScript because Foundry hosted agents support only Python and C#. They are proposed to be Python or C# pending the owner's decision (D9, open question 14 in the architecture), so do not create them in TypeScript and do not start them before the decision is recorded. The toolchain (workspace manifest, TypeScript configuration, linter, formatter, test runner) is task P0.1.2 and does not exist yet, so check for a `package.json` before running build, lint, or test commands, and do not invent commands. When the codebase is scaffolded, update this file with the real commands and architecture.

## Source code conventions

- Store all source code under `src/`, in the folder of the service it belongs to. Do not put source files at the repository root or under `docs/`.
- The planned layout and build order are in `docs/aidevme-foundry-image-studio/ARCHITECTURE.md` (section 18) and `IMPLEMENTATION.md`. Follow them unless you record a decision to change them.
- The VS Code proxy lives in `src/vscode-proxy/` (the architecture originally placed it in `clients/`; the architecture has been updated).

## Skills conventions

There are two kinds of skills. Keep them apart.

- **Development skills** help Claude Code work on this repository. They live in `.claude/skills/` (today: `write-document` and `fetch-site-docs`), are documented in `docs/project-docs/claude/skills/`, and are never deployed. `fetch-site-docs` copies documentation websites into `docs/` with the Playwright MCP browser and is preloaded by the `researcher` agent.
- **Product skills** are part of the Foundry solution: `image-brief`, `image-generate`, `image-edit`, and `microsoft-product-icons`. They live in `skills/` at the repository root (not created yet), are served to the Foundry agents through a Toolbox, and are published to consuming repositories. They will be documented in `docs/skills/`.
- Never put a product skill in `.claude/skills/`, and never put a development skill in `skills/`. See `docs/aidevme-foundry-image-studio/ARCHITECTURE.md` section 12.

## Agent memory conventions

Each subagent keeps its persistent memory in its own subfolder of `.claude/agent-memory/` at the repository root. The folder name is the agent name.

| Agent | Memory folder |
| --- | --- |
| architect | `.claude/agent-memory/architect/` |
| developer | `.claude/agent-memory/developer/` |
| documenter | `.claude/agent-memory/documenter/` |
| researcher | `.claude/agent-memory/researcher/` |
| reviewer | `.claude/agent-memory/reviewer/` |
| tester | `.claude/agent-memory/tester/` |

- An agent reads and writes only its own folder, for example the documenter agent uses `.claude/agent-memory/documenter/`. It does not write to another agent's folder.
- Resolve the folder from the repository root, never from the current working directory. Do not create nested paths such as `.claude/agent-memory/.claude/agent-memory/<agent>/`. If the working directory is not the repository root, change to it or use the full path to the repository root before you write.
- Each folder has a `MEMORY.md` index with one line per memory file. A memory file holds one fact and starts with `name`, `description`, and `metadata.type` (`user`, `feedback`, `project`, or `reference`) in its frontmatter. Update an existing file before you create a new one.
- Store only durable learnings that the repository does not already record. Never store secrets or credentials.
- Memory files are shared through version control. Review them in pull requests like any other file. The behavior is documented in `docs/project-docs/claude/agent-memory/`. Update the matching document when an agent's memory rules change.

## Documentation conventions

- Every document under `docs/` must follow `docs/templates/GENERIC_DOCUMENT_STYLE.md`: a header table with Document Title, Document Location, Document Description, Version, and Last Updated On, and a professional technical writing style. Use the `write-document` skill or the `documenter` agent to create or edit docs.
- Update a document's Version and Last Updated On whenever you change its content (typo-only fixes excepted), and list every new document in `docs/index.md`.
- When an agent definition in `.claude/agents/` or a skill in `.claude/skills/` changes, update the matching document in `docs/project-docs/claude/agents/` or `docs/project-docs/claude/skills/`.
- The `documenter` agent reviews all documents on every invocation and updates those that are outdated.
