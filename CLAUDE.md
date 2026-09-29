# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

aidevme-foundry-image-studio: multi-agent image generation on Microsoft Foundry — an orchestrator plus specialist agents, tier-based model routing (GPT-image-2.5 Flare/Sunburst, MAI-Image), an MCP server for VS Code, reusable agent skills, and official Microsoft product icons.

## Repository state

This repository currently contains no source code — only project scaffolding:

- `README.md`, `LICENSE` (MIT), `assets/` (social preview image)
- `.github/ISSUE_TEMPLATE/` — bug report, feature request, and question templates
- `docs/azure-foundry/`, `docs/claude/` — empty placeholder directories for future documentation
- `.infrastructure/` — empty placeholder directory for future deployment/infra config
- `.claude/agents/` — custom subagents (`architect`, `developer`, `tester`, `reviewer`, `documenter`, `researcher`) for this project's workflow

There is no build system, package manifest, lint config, or test suite yet. Do not assume any particular language, framework, or tooling until it is actually added to the repo — check for a manifest file (e.g. `package.json`, `pyproject.toml`, `*.csproj`) before running build/lint/test commands, since none currently exists. When the codebase is scaffolded, update this file with the real commands and architecture.
