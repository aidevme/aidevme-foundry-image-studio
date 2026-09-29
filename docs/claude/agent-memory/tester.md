# tester agent memory

| Field | Value |
| --- | --- |
| **Document Title** | tester agent memory |
| **Document Location** | `docs/claude/agent-memory/tester.md` |
| **Document Description** | Describes the persistent memory of the tester subagent: where it is stored, what the agent records, its current contents, and how to review or reset it. It is intended for contributors who use Claude Code subagents. |
| **Version** | 1.0 |
| **Last Updated On** | 2026-09-29 |

## Introduction

The tester agent keeps a project-scoped memory of testing knowledge. Read this document to learn what the agent stores and how to maintain the memory. The concepts that all agent memories share are in the [agent memory overview](index.md). The agent itself is described in the [tester agent](../agents/tester.md).

## Storage

| Item | Value |
| --- | --- |
| Location | `.claude/agent-memory/tester/` |
| Index file | `MEMORY.md` |
| Scope | `project` (shared through version control) |

## What the agent records

After the agent finishes, it records durable learnings only:

- How to run each test suite
- Environment limits, for example no live Microsoft Foundry credentials
- Edge cases that previously hid defects

Before the agent starts, it also checks its memory for known flaky tests, test commands, and fixtures.

## What the agent does not record

- Secrets or credentials

## Current contents

The folder contains only the starter index, `MEMORY.md`. No topic files exist, and the agent has not recorded any learning yet. Contents checked on 2026-09-29.

| File | Content |
| --- | --- |
| `MEMORY.md` | Title `# tester agent memory` and one sentence that describes the index line format |

## Review, edit, and reset

1. Open `.claude/agent-memory/tester/MEMORY.md` and each file that it links to.
2. To correct an entry, edit the file and keep its line in `MEMORY.md` accurate.
3. To remove an entry, delete its topic file and its line in `MEMORY.md`.
4. To reset the memory, delete every file in the folder except `MEMORY.md`, and restore `MEMORY.md` to the starter content.

The starter content is:

```markdown
# tester agent memory

Index of memory files for the tester agent. Add one line per file: `- [Title](file.md) - one-line hook`.
```

## Related documents

- [Agent memory overview](index.md)
- [tester agent](../agents/tester.md)
