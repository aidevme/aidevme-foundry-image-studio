# tester agent

| Field | Value |
| --- | --- |
| **Document Title** | tester agent |
| **Document Location** | `docs/claude/agents/tester.md` |
| **Document Description** | Describes the tester subagent, which writes and runs tests and reproduces reported bugs in aidevme-foundry-image-studio. It is intended for contributors who use Claude Code subagents. |
| **Version** | 1.0 |
| **Last Updated On** | 2026-09-29 |

## Introduction

The tester agent makes behavior verifiable. It writes test code and runs test suites, but it does not implement application features. Read this document to decide when to invoke the agent and how it reports results. The agent runs as a Claude Code subagent, and its definition is in [.claude/agents/tester.md](../../../.claude/agents/tester.md).

## Configuration

| Setting | Value |
| --- | --- |
| Model | `sonnet` |
| Tools | `Read`, `Write`, `Edit`, `Bash`, `Grep`, `Glob` |
| Skills | None |

## When to use the agent

Invoke the agent for these tasks:

- Unit tests for routing logic and specialist agents
- Integration tests for the Model Context Protocol (MCP) server
- Regression tests after a bug fix
- Reproducing a reported bug with a failing test before a fix is written

## Behavior

The agent performs these actions:

1. Reads the code under test and does not guess at its behavior or interface.
2. Identifies the risk surface: routing-tier selection, MCP tool request and response contracts, error paths (Microsoft Foundry API failures, rate limits, malformed input), and orchestrator-to-specialist handoffs.
3. Writes tests that exercise real behavior instead of mocking the component under test. This rule matters most for routing decisions and MCP schema conformance, where a mock can hide the defect.
4. Covers the main path and the edge cases that affect this system: an unavailable model, an exceeded quota, an ambiguous prompt, and a malformed MCP request.
5. For a bug report, writes the failing test first, confirms that it fails for the expected reason, and then hands off the fix or applies the minimal fix.

## Output

The agent returns test code and a pass or fail report. The report lists anything the agent could not exercise, such as live Microsoft Foundry behavior when no credentials are available. The agent does not mark a feature as verified when the tests do not cover the claimed behavior.

## Example request

```text
Use the tester agent to write a failing test for the bug where the routing
logic selects GPT-image-2.5 Sunburst after the quota is exhausted.
```

## Related documents

- [developer agent](developer.md): writes the code that the tester verifies
- [reviewer agent](reviewer.md): findings can become regression tests
