# researcher agent memory

| Field | Value |
| --- | --- |
| **Document Title** | researcher agent memory |
| **Document Location** | `docs/claude/agent-memory/researcher.md` |
| **Document Description** | Describes the persistent memory of the researcher subagent: where it is stored, what the agent records, its current contents, and how to review or reset it. It is intended for contributors who use Claude Code subagents. |
| **Version** | 1.0 |
| **Last Updated On** | 2026-09-29 |

## Introduction

The researcher agent keeps a project-scoped memory of earlier findings. Read this document to learn what the agent stores and how to maintain the memory. The concepts that all agent memories share are in the [agent memory overview](index.md). The agent itself is described in the [researcher agent](../agents/researcher.md).

## Storage

| Item | Value |
| --- | --- |
| Location | `.claude/agent-memory/researcher/` |
| Index file | `MEMORY.md` |
| Scope | `project` (shared through version control) |

## What the agent records

After the agent finishes, it records durable findings only:

- The answer to the question
- The primary source URL
- The date on which the agent checked the source

The agent marks pricing, limits, and API details as time-sensitive and re-verifies them when they are old.

## What the agent does not record

- Secrets or credentials

## Current contents

The folder contains only the starter index, `MEMORY.md`. No topic files exist, and the agent has not recorded any finding yet. Contents checked on 2026-09-29.

| File | Content |
| --- | --- |
| `MEMORY.md` | Title `# researcher agent memory` and one sentence that describes the index line format |

## Review, edit, and reset

1. Open `.claude/agent-memory/researcher/MEMORY.md` and each file that it links to.
2. To correct an entry, edit the file and keep its line in `MEMORY.md` accurate. Update the check date only after you re-verify the source.
3. To remove an entry, delete its topic file and its line in `MEMORY.md`.
4. To reset the memory, delete every file in the folder except `MEMORY.md`, and restore `MEMORY.md` to the starter content.

The starter content is:

```markdown
# researcher agent memory

Index of memory files for the researcher agent. Add one line per file: `- [Title](file.md) - one-line hook`.
```

## Related documents

- [Agent memory overview](index.md)
- [researcher agent](../agents/researcher.md)
