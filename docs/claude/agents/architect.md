# architect agent

| Field | Value |
| --- | --- |
| **Document Title** | architect agent |
| **Document Location** | `docs/claude/agents/architect.md` |
| **Document Description** | Describes the architect subagent, which designs and evaluates the architecture of aidevme-foundry-image-studio. It is intended for contributors who use Claude Code subagents. |
| **Version** | 1.0 |
| **Last Updated On** | 2026-09-29 |

## Introduction

The architect agent produces designs and plans. It does not implement them. Read this document to decide when to invoke the agent and what output to expect. The agent runs as a Claude Code subagent, and its definition is in [.claude/agents/architect.md](../../../.claude/agents/architect.md).

## Configuration

| Setting | Value |
| --- | --- |
| Model | `opus` |
| Tools | `Read`, `Grep`, `Glob`, `Bash`, `WebFetch`, `WebSearch` |
| Skills | None |

The agent has no `Write` or `Edit` tool, so it cannot change files.

## When to use the agent

Invoke the agent before you write significant new code, for example:

- A new feature or a new specialist agent
- A routing-tier change
- A change to the Model Context Protocol (MCP) server contract or to agent skill boundaries
- A cross-cutting refactor

## Behavior

The agent performs these actions:

1. Reads the current repository state and does not assume that components exist before it verifies them.
2. Identifies the constraints: Microsoft Foundry API and model limits, MCP protocol requirements, latency and cost tradeoffs across model tiers, and how the orchestrator hands work to specialist agents.
3. Produces a design that defines component responsibilities, data and control flow, the routing decision (which condition selects GPT-image-2.5 Flare, GPT-image-2.5 Sunburst, or MAI-Image), and new interfaces such as MCP tool schemas and skill contracts.
4. States tradeoffs explicitly instead of choosing silently.
5. Flags decisions that only you can make, such as a new dependency, a breaking interface change, or a cost implication.

## Output

The agent returns a plan with concrete file and module boundaries. The [developer agent](developer.md) can implement the plan directly. The plan does not include speculative abstractions.

## Example request

```text
Use the architect agent to design how the orchestrator selects between
GPT-image-2.5 Flare, GPT-image-2.5 Sunburst, and MAI-Image for a request.
```

## Related documents

- [researcher agent](researcher.md): supplies the external facts that the architect uses
- [developer agent](developer.md): implements the architect's plan
- [reviewer agent](reviewer.md): reviews the resulting changes
