# architect agent memory

| Field | Value |
| --- | --- |
| **Document Title** | architect agent memory |
| **Document Location** | `docs/claude/agent-memory/architect.md` |
| **Document Description** | Describes the persistent memory of the architect subagent: where it is stored, what the agent records, its current contents, and how to review or reset it. It is intended for contributors who use Claude Code subagents. |
| **Version** | 1.0 |
| **Last Updated On** | 2026-09-29 |

## Introduction

The architect agent keeps a project-scoped memory of design knowledge. Read this document to learn what the agent stores and how to maintain the memory. The concepts that all agent memories share are in the [agent memory overview](index.md). The agent itself is described in the [architect agent](../agents/architect.md).

## Storage

| Item | Value |
| --- | --- |
| Location | `.claude/agent-memory/architect/` |
| Index file | `MEMORY.md` |
| Scope | `project` (shared through version control) |

## What the agent records

After the agent finishes, it records durable decisions only:

- The accepted routing-tier policy
- Interface contracts
- Rejected alternatives and the reasons for rejecting them
- Open questions for you

## What the agent does not record

- Anything that it can re-read from the repository
- Secrets or credentials

## Current contents

The folder contains only the starter index, `MEMORY.md`. No topic files exist, and the agent has not recorded any decision yet. Contents checked on 2026-09-29.

| File | Content |
| --- | --- |
| `MEMORY.md` | Title `# architect agent memory` and one sentence that describes the index line format |

## Review, edit, and reset

1. Open `.claude/agent-memory/architect/MEMORY.md` and each file that it links to.
2. To correct an entry, edit the file and keep its line in `MEMORY.md` accurate.
3. To remove an entry, delete its topic file and its line in `MEMORY.md`.
4. To reset the memory, delete every file in the folder except `MEMORY.md`, and restore `MEMORY.md` to the starter content.

The starter content is:

```markdown
# architect agent memory

Index of memory files for the architect agent. Add one line per file: `- [Title](file.md) - one-line hook`.
```

## Related documents

- [Agent memory overview](index.md)
- [architect agent](../agents/architect.md)
