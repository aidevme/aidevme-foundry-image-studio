# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

aidevme-foundry-image-studio: multi-agent image generation on Microsoft Foundry — an orchestrator plus specialist agents, tier-based model routing (GPT-image-2.5 Flare/Sunburst, MAI-Image), an MCP server for VS Code, reusable agent skills, and official Microsoft product icons.

## Repository state

This repository currently contains no source code — only project scaffolding:

- `README.md`, `CONTRIBUTING.md`, `LICENSE` (MIT), `assets/` (social preview image)
- `.github/ISSUE_TEMPLATE/` — bug report, feature request, and question templates
- `docs/` — documentation, with `docs/index.md` as the index
  - `docs/claude/agents/` — one document per custom subagent
  - `docs/claude/agent-memory/` — one document per subagent memory, plus an overview
  - `docs/claude/skills/` — one document per skill, plus an overview
  - `docs/templates/GENERIC_DOCUMENT_STYLE.md` — the required document header and writing style
  - `docs/azure-foundry/`, `docs/open-ai/`, `docs/azure-ai-search/`, `docs/terraform/` — empty placeholder directories for future documentation
- `.infrastructure/` — empty placeholder directory for future deployment/infra config
- `.claude/agents/` — custom subagents (`architect`, `developer`, `tester`, `reviewer`, `documenter`, `researcher`) for this project's workflow
- `.claude/agent-memory/<agent>/` — persistent project memory for each subagent (`memory: project`), created by the agents at run time and shared through version control; never store secrets there
- `.claude/skills/write-document/` — skill (with `evals/evals.json`) that applies the document style; preloaded by the `documenter` agent

There is no build system, package manifest, lint config, or test suite yet. Do not assume any particular language, framework, or tooling until it is actually added to the repo — check for a manifest file (e.g. `package.json`, `pyproject.toml`, `*.csproj`) before running build/lint/test commands, since none currently exists. When the codebase is scaffolded, update this file with the real commands and architecture.

## Documentation conventions

- Every document under `docs/` must follow `docs/templates/GENERIC_DOCUMENT_STYLE.md`: a header table with Document Title, Document Location, Document Description, Version, and Last Updated On, and a professional technical writing style. Use the `write-document` skill or the `documenter` agent to create or edit docs.
- Update a document's Version and Last Updated On whenever you change its content (typo-only fixes excepted), and list every new document in `docs/index.md`.
- When an agent definition in `.claude/agents/` or a skill in `.claude/skills/` changes, update the matching document in `docs/claude/agents/` or `docs/claude/skills/`.
- The `documenter` agent reviews all documents on every invocation and updates those that are outdated.
