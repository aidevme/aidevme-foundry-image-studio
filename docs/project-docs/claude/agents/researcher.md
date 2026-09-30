# researcher agent

| Field | Value |
| --- | --- |
| **Document Title** | researcher agent |
| **Document Location** | `docs/project-docs/claude/agents/researcher.md` |
| **Document Description** | Describes the researcher subagent, which investigates external facts needed to design or implement aidevme-foundry-image-studio. It is intended for contributors who use Claude Code subagents. |
| **Version** | 3.2 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The researcher agent answers specific factual questions and reports sourced findings. It does not design the system (the [architect agent](architect.md) does that) or write code (the [developer agent](developer.md) does that). Read this document to decide when to invoke the agent. The agent runs as a Claude Code subagent, and its definition is in [.claude/agents/researcher.md](../../../../.claude/agents/researcher.md).

## Configuration

| Setting | Value |
| --- | --- |
| Model | `opus` |
| Tools | `Read`, `Grep`, `Glob`, `Bash`, `WebFetch`, `WebSearch`, and the Playwright MCP tools `browser_navigate`, `browser_evaluate`, `browser_wait_for`, and `browser_close` |
| Skills | [fetch-site-docs](../skills/fetch-site-docs.md) |
| Memory | `project` (`.claude/agent-memory/researcher/`) |

The agent has no `Write` or `Edit` tool in its tool list, so it does not edit repository files directly. Enabling memory gives it file access for its memory directory only. The only repository files it creates are the reference copies that the `fetch-site-docs` skill writes through its build script, under the `docs/` folder that you name. The agent has no access to the Playwright tool that runs arbitrary code (`browser_run_code_unsafe`).

> **Note:** The Playwright tool names come from the `model-apps` plugin. If that plugin is not installed, the browser tools are unavailable and the skill cannot run.

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
5. When you ask it to copy documentation from a website into the repository, it uses the [fetch-site-docs skill](../skills/fetch-site-docs.md). It reads the navigation and pages with the browser tools, writes Markdown reference copies in numbered folders under the `docs/` folder that you name, keeps the source text unchanged, and reminds you to check the licence of the copied content.

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

## Example requests

```text
Use the researcher agent to find the current rate limits and supported image
sizes for GPT-image-2.5 Flare on Microsoft Foundry.
```

```text
Use the researcher agent to copy the Microsoft Foundry documentation from
https://learn.microsoft.com/en-us/azure/foundry/what-is-foundry, including all
sub pages, into docs/research-docs/azure-foundry.
```

## Related documents

- [fetch-site-docs skill](../skills/fetch-site-docs.md): copies documentation websites into `docs/`
- [architect agent](architect.md): uses the findings to design the system
- [developer agent](developer.md): uses the findings to implement changes
