# developer agent memory

| Field | Value |
| --- | --- |
| **Document Title** | developer agent memory |
| **Document Location** | `docs/claude/agent-memory/developer.md` |
| **Document Description** | Describes the persistent memory of the developer subagent: where it is stored, what the agent records, its current contents, and how to review or reset it. It is intended for contributors who use Claude Code subagents. |
| **Version** | 1.0 |
| **Last Updated On** | 2026-09-29 |

## Introduction

The developer agent keeps a project-scoped memory of implementation knowledge. Read this document to learn what the agent stores and how to maintain the memory. The concepts that all agent memories share are in the [agent memory overview](index.md). The agent itself is described in the [developer agent](../agents/developer.md).

## Storage

| Item | Value |
| --- | --- |
| Location | `.claude/agent-memory/developer/` |
| Index file | `MEMORY.md` |
| Scope | `project` (shared through version control) |

## What the agent records

After the agent finishes, it records durable learnings only:

- Project conventions that it had to discover
- Build and test commands that work
- Recurring mistakes to avoid

## What the agent does not record

- Code that is already in the repository
- Secrets or credentials

## Current contents

The folder contains only the starter index, `MEMORY.md`. No topic files exist, and the agent has not recorded any learning yet. Contents checked on 2026-09-29.

| File | Content |
| --- | --- |
| `MEMORY.md` | Title `# developer agent memory` and one sentence that describes the index line format |

## Review, edit, and reset

1. Open `.claude/agent-memory/developer/MEMORY.md` and each file that it links to.
2. To correct an entry, edit the file and keep its line in `MEMORY.md` accurate.
3. To remove an entry, delete its topic file and its line in `MEMORY.md`.
4. To reset the memory, delete every file in the folder except `MEMORY.md`, and restore `MEMORY.md` to the starter content.

The starter content is:

```markdown
# developer agent memory

Index of memory files for the developer agent. Add one line per file: `- [Title](file.md) - one-line hook`.
```

## Related documents

- [Agent memory overview](index.md)
- [developer agent](../agents/developer.md)
