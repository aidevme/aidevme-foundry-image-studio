# reviewer agent

| Field | Value |
| --- | --- |
| **Document Title** | reviewer agent |
| **Document Location** | `docs/project-docs/claude/agents/reviewer.md` |
| **Document Description** | Describes the reviewer subagent, which reviews code changes in aidevme-foundry-image-studio before they merge. It is intended for contributors who use Claude Code subagents. |
| **Version** | 2.2 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The reviewer agent reports findings about code changes. It does not fix them unless you explicitly ask. Read this document to learn what the agent checks and what its findings contain. The agent runs as a Claude Code subagent, and its definition is in [.claude/agents/reviewer.md](../../../../.claude/agents/reviewer.md).

## Configuration

| Setting | Value |
| --- | --- |
| Model | `opus` |
| Tools | `Read`, `Grep`, `Glob`, `Bash` |
| Skills | None |
| Memory | `project` (`.claude/agent-memory/reviewer/`) |

The agent has no `Write` or `Edit` tool in its tool list, so it does not change repository files. Enabling memory gives it file access for its memory directory only.

## When to use the agent

Invoke the agent on a diff, branch, or pull request that changes any of the following:

- The orchestrator
- Specialist agents
- Model-routing logic
- The Model Context Protocol (MCP) server
- Agent skills

## Review scope

The agent reviews for correctness first, and then for reuse, simplification, and efficiency. It gives extra attention to the failure modes that are specific to this system.

| Area | Question |
| --- | --- |
| Model routing | Does tier selection match the stated cost, quality, and latency policy? Are edge cases, such as an unavailable model, an exhausted quota, or an ambiguous input, handled instead of silently defaulted? |
| MCP server contract | Do tool schemas match what VS Code clients expect? Are requests and responses validated at the boundary? |
| Orchestrator and specialist handoffs | Can a specialist's failure or malformed output propagate incorrectly, be swallowed, or corrupt orchestrator state? |
| Secrets | Are Microsoft Foundry API keys or tokens committed or logged? |
| Concurrency | Do parallel specialists or requests cause shared-state races? |

## Exclusions

The agent does not report:

- Style issues that a linter detects
- Speculative refactors that are unrelated to the diff
- Filler findings. If no finding survives scrutiny, the agent states that.

## Output

Each finding includes a concrete failure scenario: the inputs or state that lead to a wrong output or a crash.

## Agent memory

The agent has persistent project memory. The memory files are stored in `.claude/agent-memory/reviewer/` and are shared with the team through version control.

- Before the agent starts, it reads its memory directory.
- After the agent finishes, it records durable learnings only, such as defect patterns seen in this codebase, areas that need extra scrutiny, and findings that you rejected as not relevant.
- The agent does not store information that it can read from the repository, and it never stores secrets or credentials.

Review memory files in pull requests like any other file. Delete a memory file to make the agent forget its content. For the current contents and the reset procedure, see the [reviewer agent memory](../agent-memory/reviewer.md).

## Example request

```text
Use the reviewer agent to review the changes on this branch.
```

## Related documents

- [architect agent](architect.md): designs are the basis for the review
- [developer agent](developer.md): writes the code that the reviewer checks
- [tester agent](tester.md): converts findings into regression tests
