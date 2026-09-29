# documenter agent memory

| Field | Value |
| --- | --- |
| **Document Title** | documenter agent memory |
| **Document Location** | `docs/claude/agent-memory/documenter.md` |
| **Document Description** | Describes the persistent memory of the documenter subagent: where it is stored, what the agent records, its current contents, and how to review or reset it. It is intended for contributors who use Claude Code subagents. |
| **Version** | 1.0 |
| **Last Updated On** | 2026-09-29 |

## Introduction

The documenter agent keeps a project-scoped memory of documentation knowledge. Read this document to learn what the agent stores and how to maintain the memory. The concepts that all agent memories share are in the [agent memory overview](index.md). The agent itself is described in the [documenter agent](../agents/documenter.md).

## Storage

| Item | Value |
| --- | --- |
| Location | `.claude/agent-memory/documenter/` |
| Index file | `MEMORY.md` |
| Scope | `project` (shared through version control) |

## What the agent records

After the agent finishes, it records durable learnings only:

- Terminology decisions
- Recurring style corrections
- Gaps that the agent flagged and that still need a decision from you

Before the agent starts, it also checks its memory for documentation conventions and known gaps.

## What the agent does not record

- Document content that is already in the repository
- Secrets or credentials

## Current contents

The folder contains only the starter index, `MEMORY.md`. No topic files exist, and the agent has not recorded any learning yet. Contents checked on 2026-09-29.

| File | Content |
| --- | --- |
| `MEMORY.md` | Title `# documenter agent memory` and one sentence that describes the index line format |

## Review, edit, and reset

1. Open `.claude/agent-memory/documenter/MEMORY.md` and each file that it links to.
2. To correct an entry, edit the file and keep its line in `MEMORY.md` accurate.
3. To remove an entry, delete its topic file and its line in `MEMORY.md`. If the entry is an open gap, the agent flags the gap again on its next review.
4. To reset the memory, delete every file in the folder except `MEMORY.md`, and restore `MEMORY.md` to the starter content.

The starter content is:

```markdown
# documenter agent memory

Index of memory files for the documenter agent. Add one line per file: `- [Title](file.md) - one-line hook`.
```

## Related documents

- [Agent memory overview](index.md)
- [documenter agent](../agents/documenter.md)
