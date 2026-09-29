# reviewer agent memory

| Field | Value |
| --- | --- |
| **Document Title** | reviewer agent memory |
| **Document Location** | `docs/claude/agent-memory/reviewer.md` |
| **Document Description** | Describes the persistent memory of the reviewer subagent: where it is stored, what the agent records, its current contents, and how to review or reset it. It is intended for contributors who use Claude Code subagents. |
| **Version** | 1.0 |
| **Last Updated On** | 2026-09-29 |

## Introduction

The reviewer agent keeps a project-scoped memory of review knowledge. Read this document to learn what the agent stores and how to maintain the memory. The concepts that all agent memories share are in the [agent memory overview](index.md). The agent itself is described in the [reviewer agent](../agents/reviewer.md).

## Storage

| Item | Value |
| --- | --- |
| Location | `.claude/agent-memory/reviewer/` |
| Index file | `MEMORY.md` |
| Scope | `project` (shared through version control) |

## What the agent records

After the agent finishes, it records durable learnings only:

- Defect patterns seen in this codebase
- Areas that need extra scrutiny
- Findings that you rejected as not relevant, so that the agent does not raise them again

Before the agent starts, it also checks its memory for recurring findings and review conventions.

## What the agent does not record

- Secrets or credentials

## Current contents

The folder contains only the starter index, `MEMORY.md`. No topic files exist, and the agent has not recorded any learning yet. Contents checked on 2026-09-29.

| File | Content |
| --- | --- |
| `MEMORY.md` | Title `# reviewer agent memory` and one sentence that describes the index line format |

## Review, edit, and reset

1. Open `.claude/agent-memory/reviewer/MEMORY.md` and each file that it links to.
2. To correct an entry, edit the file and keep its line in `MEMORY.md` accurate.
3. To remove an entry, delete its topic file and its line in `MEMORY.md`. If the entry is a rejected finding, the agent can raise that finding again.
4. To reset the memory, delete every file in the folder except `MEMORY.md`, and restore `MEMORY.md` to the starter content.

The starter content is:

```markdown
# reviewer agent memory

Index of memory files for the reviewer agent. Add one line per file: `- [Title](file.md) - one-line hook`.
```

## Related documents

- [Agent memory overview](index.md)
- [reviewer agent](../agents/reviewer.md)
