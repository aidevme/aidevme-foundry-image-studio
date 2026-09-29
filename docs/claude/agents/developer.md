# developer agent

| Field | Value |
| --- | --- |
| **Document Title** | developer agent |
| **Document Location** | `docs/claude/agents/developer.md` |
| **Document Description** | Describes the developer subagent, which implements features, fixes, and refactors in aidevme-foundry-image-studio from a concrete specification. It is intended for contributors who use Claude Code subagents. |
| **Version** | 1.0 |
| **Last Updated On** | 2026-09-29 |

## Introduction

The developer agent writes and edits code. It does not decide architecture. Read this document to learn what input the agent needs and how it reports its work. The agent runs as a Claude Code subagent, and its definition is in [.claude/agents/developer.md](../../../.claude/agents/developer.md).

## Configuration

| Setting | Value |
| --- | --- |
| Model | `sonnet` |
| Tools | `Read`, `Write`, `Edit`, `Bash`, `Grep`, `Glob` |
| Skills | None |

## When to use the agent

Provide a concrete specification, ideally a plan from the [architect agent](architect.md), and the exact files and interfaces to change. Typical targets are:

- Orchestrator logic
- Specialist agents
- The Model Context Protocol (MCP) server
- Model-routing code
- Agent skills

## Behavior

Before the agent writes code, it performs these actions:

1. Reads the relevant files and matches the existing conventions for naming, error handling, and module layout.
2. Resolves ambiguity in the specification by making the smallest reasonable assumption and recording it. If the ambiguity affects a cost-sensitive choice, such as which model tier to call, the agent asks you instead.

While the agent implements the change, it follows these rules:

- It prefers editing existing files to creating new files.
- It does not add abstractions, configuration flags, or error handling for scenarios that cannot occur.
- It keeps routing logic, MCP tool definitions, and skill contracts consistent with the plan and does not redesign them.
- It adds comments only to explain non-obvious constraints or workarounds.
- It runs the project's build, lint, and test commands, if they exist, and fixes any failures it caused.

## Output

The agent reports what changed, which files changed, and anything it could not verify. For example, it reports when it did not run against the live Microsoft Foundry API because no credentials were available.

## Example request

```text
Use the developer agent to implement the routing function from the
architect's plan in the routing module.
```

## Related documents

- [architect agent](architect.md): supplies the plan that the developer implements
- [tester agent](tester.md): verifies the implemented behavior
- [reviewer agent](reviewer.md): reviews the changes before merge
