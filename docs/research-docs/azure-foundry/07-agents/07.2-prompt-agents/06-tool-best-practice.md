# Tool best practices for Microsoft Foundry Agent Service

| Field | Value |
| --- | --- |
| **Document Title** | Tool best practices for Microsoft Foundry Agent Service |
| **Document Location** | `docs/research-docs/azure-foundry/07-agents/07.2-prompt-agents/06-tool-best-practice.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Tool best practices for Microsoft Foundry Agent Service". Learn tool best practices for Foundry Agent Service: configure tool_choice, secure tool usage, and troubleshoot tool-calling issues. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/tool-best-practice). Article date: 2026-09-11. Page updated: 2026-09-24. Retrieved: 2026-09-29. Navigation: Agents > Prompt agents > Text-based agents > Build > Best practices.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

When you build agents in Microsoft Foundry Agent Service, tools extend what your agent can do—retrieving information, calling APIs, and connecting to external services. This article helps you configure tools effectively, control when the agent calls them, and keep your data secure.

> **Tip**
>
> In your agent instructions, describe what each tool is for and when to use it. For example:
>
> `When you need information from my indexed documents, use File Search. When you need to call an API, use the OpenAPI tool. When a tool call fails or returns no results, explain what happened and ask a follow-up question.`

## Prerequisites

- Access to a Foundry project in the Foundry portal with the **Azure AI Developer** role or equivalent permissions.
- A model deployed in the same project.
- Any required connections configured for the tools you plan to use (for example, Azure AI Search, SharePoint, or Bing grounding).
- A model and project region that both support the tool. See [Tool support by region and model](../07.6-reference/01-limits-quotas-regions.md#tool-support-by-region-and-model).

## Configure and validate tool usage

- Organize tools and connections in a toolbox. See [Create and manage a toolbox in Foundry](../../08-toolboxes/01-toolbox.md).
- Review traces to confirm when your agent calls tools and to inspect tool inputs and outputs. For setup guidance, see [Set up tracing for Foundry agents](../../09-observability/09.2-tracing/02-trace-agent-setup.md).

## Improve tool-calling reliability

### Design tools for voice-based prompt agents

Voice-based prompt agents use tools during a live audio conversation, so tool latency and response length affect the caller's experience. Keep tool descriptions concise, return only the information the agent needs to answer the current request, and provide a short spoken progress response when a tool call takes time.

- Use native function tools when the connected client must perform the action.
- Use MCP or toolbox tools when the agent service or Voice Live integration performs the tool call.
- Set `tool_choice` deliberately for opening or other time-sensitive turns. Use `none` when the agent should speak without calling a tool, `auto` when the model decides, or `required` when a tool call is necessary.
- Test interruptions and tool failures in a live voice session. The agent should remain usable when a caller speaks while a tool is running or when a tool returns no result.

For setup, see [Quickstart: Create a voice-based prompt agent](../../04-get-started/04.1-what-do-you-want-to-build/02-prompt-voice-agent.md).

### Control tool calling with `tool_choice`

Use `tool_choice` for the most deterministic control over tool calling.

- `auto`: The model decides whether to call tools.
- `required`: The model must call one or more tools.
- `none`: The model doesn't call tools.

For details, see `tool_choice` in the [Foundry project REST reference](https://ai.azure.com/api-reference/responses).

### Write effective tool instructions

- Keep instructions specific and consistent with your tool setup.
- Tell the model what each tool is for.
- If you have multiple tools that overlap, add a decision rule (for example, "Use File Search before Web Search for internal content.").

## Secure tool usage

Tools send and receive data outside the model. Reduce security and privacy risks with these practices:

- Treat tool outputs as untrusted input and validate critical values before acting on them.
- Validate structured outputs against an expected schema, allow only known fields and operations, and require user approval before consequential actions.
- Send only the information required to complete the task.
- Don't include keys, tokens, or other credentials in prompts.
- Avoid logging secrets in traces or application logs.
- If you connect to non-Microsoft services (for example, third-party MCP servers), review the data handling considerations in [Create and manage a toolbox in Foundry](../../08-toolboxes/01-toolbox.md).
- If you need centralized routing and policy enforcement for MCP tools, see [Tools governance with AI Gateway (preview)](../../08-toolboxes/08.2-manage-toolbox/01-governance.md).

## Troubleshooting

Use these checks to resolve common issues:

- **Your agent doesn't call a tool**:
  - Confirm the tool is attached to the agent.
  - Confirm the model supports the tool.
  - If you need deterministic behavior, set `tool_choice` to `required`.
  - Review traces to confirm whether the model produced a tool call.
- **Tool calls return empty or irrelevant results**:
  - Improve tool descriptions and agent instructions.
  - For retrieval tools, ensure your data is ingested and searchable.
- **Tool calls fail**:
  - Verify tool configuration and authentication.
  - For MCP and OpenAPI tools, validate the endpoint is reachable and returns expected responses.
- **Foundry returns a "tool not supported" error even though the tables show support**:
  - Tool availability requires support from **both** the model and the region. Check the [region availability table](../07.6-reference/01-limits-quotas-regions.md#tool-support-by-region-and-model) for your region and the [model support table](../07.6-reference/01-limits-quotas-regions.md#tool-support-by-region-and-model) for your model. If either table shows `No`, the tool can't run, even if the other table shows `Yes`.
  - Confirm the model is actually deployed in the project and region you're targeting. A model that supports a tool in general might not be deployed in every region.
  - Try a different region or a different model deployment that supports the tool. For example, code interpreter doesn't run in regions that show `no` for Code Interpreter (such as `southcentralus` and `spaincentral`), regardless of which model you use.

## FAQ

**How do I validate whether a tool was called?**

Review traces to confirm whether your agent called a tool and to inspect tool inputs and outputs. For setup guidance, see [Set up tracing for Foundry agents](../../09-observability/09.2-tracing/02-trace-agent-setup.md).

**How do I make tool usage more reliable?**

Start with clear tool instructions. If you need deterministic tool calling, use `tool_choice`. For details, see [Control tool calling with `tool_choice`](#control-tool-calling-with-tool_choice).

## Related content

### Tool management

- [What is Toolbox in Foundry?](../../04-get-started/04.1-what-do-you-want-to-build/06-toolbox-overview.md)
- [Create and manage a toolbox in Foundry](../../08-toolboxes/01-toolbox.md)
- [Tools governance with AI Gateway (preview)](../../08-toolboxes/08.2-manage-toolbox/01-governance.md)

### Retrieval and search tools

- [Azure AI Search](../../08-toolboxes/08.1-add-tools-and-skills/28-ai-search.md)
- [File search](../../08-toolboxes/08.1-add-tools-and-skills/23-file-search.md)
- [Web search](../../08-toolboxes/08.1-add-tools-and-skills/12-web-search.md)
- [Grounding with Bing tools](../../08-toolboxes/08.1-add-tools-and-skills/13-bing-tools.md)
- [SharePoint (preview)](../../08-toolboxes/08.1-add-tools-and-skills/35-sharepoint.md)

### Data and integration tools

- [Fabric data agent (preview)](../../08-toolboxes/08.1-add-tools-and-skills/34-fabric.md)
- [Model Context Protocol (MCP)](../../08-toolboxes/08.1-add-tools-and-skills/01-model-context-protocol.md)
- [OpenAPI tool](../../08-toolboxes/08.1-add-tools-and-skills/08-openapi.md)
- [Function calling](../../08-toolboxes/08.1-add-tools-and-skills/29-function-calling.md)

### Automation and generation tools

- [Code interpreter](../../08-toolboxes/08.1-add-tools-and-skills/26-code-interpreter.md)
- [Browser automation (preview)](../../08-toolboxes/08.1-add-tools-and-skills/31-browser-automation.md)
- [Computer Use (preview)](../../08-toolboxes/08.1-add-tools-and-skills/32-computer-use.md)
- [Image generation (preview)](../../08-toolboxes/08.1-add-tools-and-skills/33-image-generation.md)
- [Agent-to-Agent (A2A)](../../08-toolboxes/08.1-add-tools-and-skills/09-agent-to-agent.md)
