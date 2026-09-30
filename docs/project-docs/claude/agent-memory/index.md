# Agent memory overview

| Field | Value |
| --- | --- |
| **Document Title** | Agent memory overview |
| **Document Location** | `docs/project-docs/claude/agent-memory/index.md` |
| **Document Description** | Explains the concepts that all Claude Code subagent memories in aidevme-foundry-image-studio share: scope, storage layout, version control, and how to review or reset a memory. It is intended for contributors who use or maintain the subagents. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

## Introduction

Each custom subagent in this repository has a persistent memory. The memory lets the agent keep durable learnings between sessions. Read this document to understand the rules that apply to every agent memory. Read the per-agent documents listed in [Agent memory documents](#agent-memory-documents) for what each agent records and what its memory contains.

## Scope and storage

Every agent definition in [.claude/agents/](../../../../.claude/agents/) sets `memory: project`. The `project` scope stores the memory inside the repository instead of in a user profile.

| Item | Value |
| --- | --- |
| Location | `.claude/agent-memory/<agent>/` |
| Index file | `MEMORY.md` in each agent folder |
| Topic files | Optional. The index lists each one as `- [Title](file.md) - one-line hook`. |
| Sharing | Through version control, like any other repository file |

The starter `MEMORY.md` of each agent contains a title and one sentence that describes the index format.

## Rules that apply to every agent

- Before the agent starts, it reads its memory directory.
- After the agent finishes, it records durable learnings only.
- The agent does not store information that it can read from the repository.
- The agent never stores secrets or credentials. Do not add API keys, tokens, or endpoints that contain secrets to a memory file.

## Review, edit, and reset

Memory files are ordinary Markdown files. Treat them like source files.

- To review a memory, open `.claude/agent-memory/<agent>/MEMORY.md` and the files that it links to. Review changes to these files in pull requests.
- To edit a memory, change the file and keep the matching line in `MEMORY.md` correct.
- To make an agent forget one entry, delete the topic file and remove its line from `MEMORY.md`.
- To reset a memory completely, delete every topic file in the agent folder, and restore `MEMORY.md` to the starter content shown in the per-agent document.

> **Note:** Commit memory changes only after you confirm that they contain no secrets and no content that the repository already provides.

## Agent memory documents

| Agent | Memory document | Agent document |
| --- | --- | --- |
| architect | [architect memory](architect.md) | [architect agent](../agents/architect.md) |
| developer | [developer memory](developer.md) | [developer agent](../agents/developer.md) |
| tester | [tester memory](tester.md) | [tester agent](../agents/tester.md) |
| reviewer | [reviewer memory](reviewer.md) | [reviewer agent](../agents/reviewer.md) |
| researcher | [researcher memory](researcher.md) | [researcher agent](../agents/researcher.md) |
| documenter | [documenter memory](documenter.md) | [documenter agent](../agents/documenter.md) |

## Related documents

- [Documentation index](../../../index.md)
- [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md)
