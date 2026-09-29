# researcher agent

| Field | Value |
| --- | --- |
| **Document Title** | researcher agent |
| **Document Location** | `docs/claude/agents/researcher.md` |
| **Document Description** | Describes the researcher subagent, which investigates external facts needed to design or implement aidevme-foundry-image-studio. It is intended for contributors who use Claude Code subagents. |
| **Version** | 2.1 |
| **Last Updated On** | 2026-09-29 |

## Introduction

The researcher agent answers specific factual questions and reports sourced findings. It does not design the system (the [architect agent](architect.md) does that) or write code (the [developer agent](developer.md) does that). Read this document to decide when to invoke the agent. The agent runs as a Claude Code subagent, and its definition is in [.claude/agents/researcher.md](../../../.claude/agents/researcher.md).

## Configuration

| Setting | Value |
| --- | --- |
| Model | `opus` |
| Tools | `Read`, `Grep`, `Glob`, `Bash`, `WebFetch`, `WebSearch` |
| Skills | None |
| Memory | `project` (`.claude/agent-memory/researcher/`) |

The agent has no `Write` or `Edit` tool in its tool list, so it does not change repository files. Enabling memory gives it file access for its memory directory only.

## When to use the agent

Invoke the agent to answer a specific factual question about any of these topics:

- Microsoft Foundry API and model capabilities and limits (GPT-image-2.5 Flare, GPT-image-2.5 Sunburst, MAI-Image)
- Model Context Protocol (MCP) specification details
- VS Code extension APIs
- Pricing and rate limits
- Competing approaches

## Behavior

The agent performs these actions:

1. Checks the repository first (`docs/`, existing code, and configuration) and does not research externally what the repository already answers.
2. Uses primary sources, such as official Microsoft, Anthropic, and MCP documentation, in preference to blog posts or forum answers. The agent fetches the current page instead of relying on general knowledge, because APIs and pricing change.
3. States explicitly when sources conflict or when a detail is undocumented, instead of selecting one source silently or guessing.
4. Separates three categories: documented fact, inferred from behavior, and could not verify.

## Output

The agent returns a concise report that contains:

- The direct answer
- The sources
- Any caveat or gap that matters to the requester, usually the architect agent, the developer agent, or you

The report omits tangential findings that were not requested.

## Agent memory

The agent has persistent project memory. The memory files are stored in `.claude/agent-memory/researcher/` and are shared with the team through version control.

- Before the agent starts, it reads its memory directory.
- After the agent finishes, it records durable learnings only, such as the answer to each question, the primary source, and the date it checked the source, with pricing, limits, and API details marked as time-sensitive.
- The agent does not store information that it can read from the repository, and it never stores secrets or credentials.

Review memory files in pull requests like any other file. Delete a memory file to make the agent forget its content. For the current contents and the reset procedure, see the [researcher agent memory](../agent-memory/researcher.md).

## Example request

```text
Use the researcher agent to find the current rate limits and supported image
sizes for GPT-image-2.5 Flare on Microsoft Foundry.
```

## Related documents

- [architect agent](architect.md): uses the findings to design the system
- [developer agent](developer.md): uses the findings to implement changes
