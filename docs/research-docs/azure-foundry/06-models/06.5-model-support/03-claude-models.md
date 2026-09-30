# Claude models in Microsoft Foundry

| Field | Value |
| --- | --- |
| **Document Title** | Claude models in Microsoft Foundry |
| **Document Location** | `docs/research-docs/azure-foundry/06-models/06.5-model-support/03-claude-models.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Claude models in Microsoft Foundry". Discover Claude models in Microsoft Foundry. Compare available models, capabilities, hosting options, and supported regions to choose the right model. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/concepts/claude-models). Article date: 2026-09-21. Page updated: 2026-09-22. Retrieved: 2026-09-29. Navigation: Models > Model support > Anthropic > Overview of Claude models in Foundry.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Anthropic's Claude models bring advanced conversational AI capabilities to Microsoft Foundry, providing state-of-the-art language understanding and generation for intelligent applications. Claude models excel at complex reasoning, code generation, and multimodal tasks including image analysis. This article describes the available Claude models, how they're hosted and billed, supported APIs, capabilities, and best practices.

To deploy and call a Claude model, see [Deploy and use Claude models in Microsoft Foundry](06-use-foundry-models-claude.md).

> **Important**
>
> Items marked (preview) in this article are currently in public preview. This preview is provided without a service-level agreement, and we don't recommend it for production workloads. Certain features might not be supported or might have constrained capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## How Claude models are hosted and billed

Microsoft Foundry offers Claude models in two versions:

- Version 1: **Hosted on Anthropic infrastructure**; these models run on Anthropic's infrastructure (outside of Azure).
- Version 2: **Hosted on Azure**; these models run on Azure infrastructure end-to-end and are all Generally available (GA).

Not all models are available in both versions. A model's lifecycle stage, such as Preview or Generally available, can differ between the two versions. For per-model availability and lifecycle status, see [Available Claude models](#available-claude-models).

To compare both hosting options across data residency, SLAs, support paths, compliance, and purchasing flow, see [Compare Azure-hosted and Anthropic-hosted Claude models](05-claude-models-hosting-comparison.md).

> **Note**
>
> You access Claude models in Microsoft Foundry through [Foundry Models from partners and community](../06.1-explore-foundry-models/03-models-from-partners.md). Models from partners and community that Anthropic sells and operates are Non-Microsoft Products under the Product Terms.
>
> Claude models in Foundry require an Azure Marketplace subscription and bill through Claude Consumption Units (CCU). Ensure that you have the [permissions required to subscribe to model offerings](../06.1-explore-foundry-models/03-models-from-partners.md#permissions-required-to-subscribe-to-models-from-partners-and-community) before you deploy. For pricing details, see [Claude Consumption Units (CCU) billing in Microsoft Foundry](../../13-manage-and-operate/13.1-set-up-and-configure/20-claude-models-billing.md).

## Available Claude models

> **Important**
>
> The following Claude models comply with the **EU watermarking** standard: `claude-mythos-5-1`, `claude-fable-5-1`, and `claude-fable-5`. While `claude-fable-5` uses single-key watermarking, `claude-mythos-5-1` and `claude-fable-5-1` use double key (interwoven 2-key and C2PA) as follows:
>
> - **Interwoven text watermarking (second key)**: a second key is added for interwoven watermark detection per EU standards. Watermarking happens server-side at generation time; there is no change to request or response shapes. A separate watermark detection API is in early access and isn't part of the Foundry launch scope.
> - **C2PA watermarking**: C2PA content-provenance marking, handled server/client-side by Anthropic surfaces. No API shape change.

The following table compares model availability for both versions of Claude models in Foundry. For details on the features referenced in the table, see the [Capabilities and advanced features](#capabilities-and-advanced-features) section.

For errors you might encounter when you deploy or call Claude models, see [Deploy and use Claude models: Troubleshooting](06-use-foundry-models-claude.md#troubleshooting).

| Model | Availability | Context window / Max output | Key capabilities | Best for |
| --- | --- | --- | --- | --- |
| `claude-fable-5-1` | Hosted on Anthropic infrastructure: Preview | 1M / 128K | Adaptive thinking Long-running work Scientific research with self verification Knowledge work; handling challenging knowledge work with less hands-on oversight Refusal `stop_reason` on dual-use safeguard policies1 See [What's new in Claude Fable 5.1 and Claude Mythos 5.1](https://platform.claude.com/docs/en/models/fable-5-1/whats-new-fable-5-1) | Long-running agents Coding and agents, with deeper reasoning for enterprise workflows General science and research Financial analysis Vision |
| `claude-fable-5` | Hosted on Anthropic infrastructure: Preview | 1M / 128K | Adaptive thinking Reasoning over entire codebases and multi-day project context Longer independent work than any prior Claude model Self verification Sub-agent orchestration Refusal `stop_reason` on dual-use safeguard policies1 See [Migrating to Claude Fable 5.1 and Claude Mythos 5.1](https://platform.claude.com/docs/en/models/fable-5-1/migration-guide) | Cybersecurity Autonomous coding Long-running agents Coding and agents, with deeper reasoning for enterprise workflows |
| `claude-mythos-5-1`2 | Hosted on Anthropic infrastructure: Gated research preview | 1M / 128K | Adaptive thinking Image and text input Microsoft Entra ID authentication only See [What's new in Claude Fable 5.1 and Claude Mythos 5.1](https://platform.claude.com/docs/en/models/fable-5-1/whats-new-fable-5-1) | Biology and life sciences Cybersecurity (defensive use cases prioritized): vulnerability discovery, attack-surface auditing, red teaming, threat intelligence Autonomous coding Long-running agents |
| `claude-mythos-5`2 | Hosted on Anthropic infrastructure: Gated research preview | 1M / 128K | Adaptive thinking Image and text input Microsoft Entra ID authentication only See [Migrating to Claude Fable 5.1 and Claude Mythos 5.1](https://platform.claude.com/docs/en/models/fable-5-1/migration-guide) | Biology and life sciences Cybersecurity (defensive use cases prioritized): vulnerability discovery, attack-surface auditing, red teaming, threat intelligence Autonomous coding Long-running agents |
| `claude-mythos-preview`2 | Hosted on Anthropic infrastructure: Gated research preview | 1M / 128K | Adaptive thinking Image and text input Microsoft Entra ID authentication only See [Migrating to Claude Fable 5.1 and Claude Mythos 5.1](https://platform.claude.com/docs/en/models/fable-5-1/migration-guide) | Cybersecurity (defensive use cases prioritized) Autonomous coding Long-running agents |
| `claude-opus-5-5` | Hosted on Azure: GA Hosted on Anthropic infrastructure: GA | 1M / 128K | Cost efficient with lower per-token prices and less expensive cache reads Agentic coding across long-running sessions; finding root causes before making changes and checking work as it goes Adaptive thinking always on with effort parameter to steer depth and cost with `xhigh` and `max` effort levels; Default is medium; {"type": "adaptive"} is accepted for thinking; Requests that set thinking to disabled, or to enabled with a manual budget_tokens, are rejected with a `400`; Requests that omit thinking run with adaptive thinking Communicates shorter and easy-to-follow summaries of long runs Performs knowledge work to produce documents that require limited editing compared to previous models Per-turn effort controls3 Mid-conversation3 `role:"system"` Token budgets3 (`task_budget`) See [What's new in Claude Opus 5.5](https://platform.claude.com/docs/en/models/opus-5-5/whats-new-opus-5-5) | Long-running agents with minimal oversight and clear reports along the way Enterprise workflows Financial analysis Computer use Vision |
| `claude-opus-5` | Hosted on Azure: GA Hosted on Anthropic infrastructure: GA | 1M / 128K | Adaptive thinking with `xhigh` and `max` effort levels Reasoning over entire codebases and multi-day project context Per-turn effort controls3 Mid-conversation3 `role:"system"` Token budgets3 (`task_budget`) See [Migrating to Claude Opus 5.5](https://platform.claude.com/docs/en/about-claude/models/migration-guide#migrating-to-claude-opus-5-5) | Near-Fable intelligence for long-horizon coding and complex agentic orchestration Long-running agents Enterprise workflows Financial analysis Computer use |
| `claude-opus-4-8` | Hosted on Azure: GA Hosted on Anthropic infrastructure: GA | 1M / 128K | Adaptive thinking with `xhigh` effort level Reasoning over entire codebases and multi-day project context High-resolution image input (up to 2576px / 3.75MP) See [Migrating to Claude Opus 5.5](https://platform.claude.com/docs/en/models/opus-5-5/migration-guide) | Coding Long-running agents Financial analysis Cybersecurity Computer use |
| `claude-opus-4-7` | Hosted on Anthropic infrastructure: GA | 1M / 128K | Adaptive thinking Reasoning over entire codebases High-resolution image input (up to 2576px / 3.75MP) See [Migrating to Claude Opus 5.5](https://platform.claude.com/docs/en/models/opus-5-5/migration-guide) | Coding Enterprise workflows Long-running agents Multimodal reasoning Financial analysis Cybersecurity |
| `claude-opus-4-6` | Hosted on Anthropic infrastructure: GA | 1M / 128K | Adaptive thinking Image and text input Computer use Advanced tool use (search, programmatic calling, examples) See [Migrating to Claude Opus 5.5](https://platform.claude.com/docs/en/models/opus-5-5/migration-guide) | Coding Enterprise agents |
| `claude-opus-4-5` | Hosted on Anthropic infrastructure: GA | 200K / 64K | Extended thinking Image and text input Computer use Advanced tool use (search, programmatic calling, examples) See [Migrating to Claude Opus 5.5](https://platform.claude.com/docs/en/models/opus-5-5/migration-guide) | Coding Agents Computer use Enterprise workflows |
| `claude-sonnet-5-5` | Hosted on Azure: GA Hosted on Anthropic infrastructure: GA | 1M / 128K | Adaptive thinking `xhigh` effort level Reasoning over entire codebases and multi-day project context High-res image input (up to 2576px / 3.75MP) are on by default Mid-conversation3 `role:"system"` Token budgets3 (`task_budget`) | Coding Long-running agents Financial analysis Cybersecurity Computer use See [What's new in Claude Sonnet 5.5](https://platform.claude.com/docs/en/models/sonnet-5-5/whats-new-sonnet-5-5) |
| `claude-sonnet-5` | Hosted on Azure: GA Hosted on Anthropic infrastructure: GA | 1M / 128K | Adaptive thinking `xhigh` effort level Reasoning over entire codebases and multi-day project context High-res image input (up to 2576px / 3.75MP) are on by default Mid-conversation3 `role:"system"` Token budgets3 (`task_budget`) See [What's new in Claude Sonnet 5](https://platform.claude.com/docs/en/about-claude/models/whats-new-sonnet-5) | Coding Long-running agents Financial analysis Cybersecurity Computer use |
| `claude-sonnet-4-6` | Hosted on Anthropic infrastructure: GA | 1M / 128K | Adaptive thinking Image and text input Computer use Advanced tool use (search, programmatic calling, examples) See [Migrating to Claude Sonnet 5](https://platform.claude.com/docs/en/about-claude/models/migration-guide#migrating-to-claude-sonnet-5) | Coding Agents Enterprise workflows |
| `claude-sonnet-4-5` | Hosted on Anthropic infrastructure: GA | 200K / 64K | Extended thinking Image and text input Computer use See [Migrating to Claude Sonnet 5](https://platform.claude.com/docs/en/about-claude/models/migration-guide#migrating-to-claude-sonnet-5) | Agents and complex, long-horizon tasks High-volume workloads |
| `claude-haiku-4-5` | Hosted on Azure: GA Hosted on Anthropic infrastructure: GA | 200K / 64K | Extended thinking Image and text input | Coding Agents |

1 **Claude Fable 5** and **Claude Fable 5.1** apply extra input/output classifiers that might refuse requests if the content triggers dual-use safeguard policies. When a refusal happens, the request returns a successful (200) response with a refusal indicator `stop_reason: "refusal"` instead of model-generated content. You aren't billed for input tokens that are refused.

2 **Claude Mythos 5-1**, **Claude Mythos 5**, and **Claude Mythos Preview** are only available as *gated research preview*. Access to the models is granted solely at Anthropic's discretion and prioritized for defensive cybersecurity use cases. See the [Claude Fable 5.1 & Claude Mythos 5.1 system card](https://www.anthropic.com/claude-fable-5-1-mythos-5-1-system-card), [Claude Mythos 5 system card](https://www.anthropic.com/claude-mythos-5-system-card), and [Claude Mythos Preview system card](https://www.anthropic.com/claude-mythos-preview-system-card) for responsible use guidance.

3 Per-turn effort controls, Mid-conversation, and Token budgets are currently in Beta state.

## API overview

The following table lists the APIs that you can use to interact with both the **Hosted on Azure** and **Hosted on Anthropic infrastructure** versions of Claude models in Foundry.

Use the [Anthropic SDKs](https://docs.claude.com/en/api/client-sdks) and the following Claude APIs:

> **Tip**
>
> The *Hosted on Anthropic infrastructure version* of Claude models in Foundry supports more APIs than the ones listed in this table. You can see them on the [Claude API docs: API overview](https://platform.claude.com/docs/en/api/overview#available-apis) page.

| API | Description |
| --- | --- |
| Messages1 (`POST /v1/messages`) | Core [Messages API](https://docs.claude.com/en/api/messages): Send a structured list of input messages with text or image content, including streaming responses. The model generates the next message in the conversation. |
| Token counting (`POST /v1/messages/count_tokens`) | [Token Count API](https://docs.claude.com/en/api/messages-count-tokens): Count the number of tokens in a message before sending it to Claude. |

1You can call the Messages API from the `anthropic` Python package, the `@anthropic-ai/foundry-sdk` JavaScript package, or directly through REST. The deployment endpoint follows the shape `https://<resource-name>.services.ai.azure.com/anthropic/v1/messages`, and REST and JavaScript clients use the `anthropic-version: 2023-06-01` header.

## Capabilities and advanced features

Claude models in Foundry expose *core capabilities* for processing, analyzing, and generating content, and *tools* that let Claude interact with external systems, execute code, and perform automated tasks. Claude's API surface is organized into five areas:

- [Model capabilities](#model-capabilities)
- [Tools](#tools)
- [Tool infrastructure](#tool-infrastructure)
- [Context management](#context-management)
- [Files and assets](#files-and-assets)

The following sections and tables summarize capabilities available across the **Hosted on Azure** and **Hosted on Anthropic infrastructure** versions of Claude models in Foundry. Unless noted, a capability applies to both versions.

> **Tip**
>
> The *Hosted on Anthropic infrastructure version* of Claude models in Foundry supports more capabilities than the ones listed in these tables. You can see the full list of capabilities on [Claude Platform Docs: Features overview](https://platform.claude.com/docs/en/build-with-claude/overview).
>
> For more information about the available capabilities and advanced features for Claude models in Foundry, see the [Microsoft Developer Blog](https://aka.ms/ClaudeGAfeaturesblog).

### Model capabilities

Ways to steer Claude and Claude's direct outputs, including response format, reasoning depth, and input modalities.

| Feature | Description |
| --- | --- |
| [Streaming messages](https://platform.claude.com/docs/en/build-with-claude/streaming) | When creating a Message, set `"stream": true` to incrementally stream the response using server-sent events (SSE). |
| [Thinking](https://platform.claude.com/docs/en/build-with-claude/thinking) | Enhanced reasoning capabilities for complex tasks, providing transparency into Claude's step-by-step thought process before delivering its final answer. See [Thinking and effort](#thinking-and-effort) for `thinking` parameter values per model. |
| [Adaptive thinking](https://platform.claude.com/docs/en/build-with-claude/thinking) | Let Claude dynamically decide when and how much to think. This feature is the only thinking mode on Claude 4.7 and later models. Use the `effort` parameter to control thinking depth. |
| [Effort](https://platform.claude.com/docs/en/build-with-claude/effort) | Control how many tokens Claude uses when responding, trading off between response thoroughness and token efficiency. See [Thinking and effort](#thinking-and-effort) for `effort` parameter values per model. |
| [Citations](https://platform.claude.com/docs/en/build-with-claude/citations) | Ground Claude's responses in sources, including [search results](https://platform.claude.com/docs/en/build-with-claude/search-results) content blocks `search_result`. |
| [Images and vision](https://platform.claude.com/docs/en/build-with-claude/vision) | Process and analyze content from images. **Hosted on Azure** deployments only accept base64 encoded or URL-based images. |
| [PDF support](https://platform.claude.com/docs/en/build-with-claude/pdf-support) | Process and analyze text and visual content from PDF documents. Provide PDFs as base64 or URL. |
| [1M context window](https://platform.claude.com/docs/en/build-with-claude/context-windows) | Up to 1 million tokens for processing large documents, extensive codebases, and long conversations. Support is subject to model eligibility. |
| [Structured outputs](https://platform.claude.com/docs/en/build-with-claude/structured-outputs) | Constrain Claude's responses to follow a specific JSON schema, using two complementary features: JSON outputs (the `output_config.format` parameter) for structured responses, and strict tool use (`strict: true`) for validated tool inputs. For **Hosted on Azure** deployments, structured outputs also support the legacy parameter for JSON outputs (the `output_format` parameter). |

#### Thinking and effort

The **Thinking** feature allows specific values for the `thinking` parameter type, depending on the model, as described in the following table. The `adaptive` type configures the **adaptive thinking** feature, allowing the model to decide whether to think, based on query complexity and effort level. For example, `thinking={"type": "adaptive"}`.

| Model | `adaptive` | `enabled` | `disabled` |
| --- | --- | --- | --- |
| `claude-fable-5-1` | Yes | No | No |
| `claude-fable-5` | Yes | No | No |
| `claude-mythos-5-1` | Yes | No | No |
| `claude-mythos-5` | Yes | No | No |
| `claude-mythos-preview` | Yes | Yes | No |
| `claude-opus-5-5` | Yes | No | Yes1 |
| `claude-opus-5` | Yes | No | Yes1 |
| `claude-opus-4-8` | Yes | No | Yes |
| `claude-opus-4-7` | Yes | No | Yes |
| `claude-opus-4-6` | Yes | Yes | Yes |
| `claude-sonnet-5-5` | Yes | Yes | Yes |
| `claude-sonnet-5` | Yes | No | Yes |
| `claude-sonnet-4-6` | Yes | Yes | Yes |

1 Thinking can be `disabled` only at effort `high` or below

The **Effort** feature allows specific `effort` levels for each model, as described in the following table. The `xhigh` level produces the same result as `max`.

| Model | `low` | `medium` | `high` | `xhigh` | `max` |
| --- | --- | --- | --- | --- | --- |
| `claude-fable-5-1` | Yes | Yes | Yes | Yes | No |
| `claude-fable-5` | Yes | Yes | Yes | Yes | No |
| `claude-mythos-5-1` | Yes | Yes | Yes | Yes | No |
| `claude-mythos-5` | Yes | Yes | Yes | Yes | No |
| `claude-opus-5-5` | Yes | Yes | Yes | Yes | Yes |
| `claude-opus-5` | Yes | Yes | Yes | Yes | Yes |
| `claude-opus-4-8` | Yes | Yes | Yes | Yes | Yes |
| `claude-opus-4-7` | Yes | Yes | Yes | Yes | Yes |
| `claude-opus-4-6` | Yes | Yes | Yes | No | Yes |
| `claude-sonnet-5-5` | Yes | Yes | Yes | Yes | Yes |
| `claude-sonnet-5` | Yes | Yes | Yes | Yes | Yes |
| `claude-sonnet-4-6` | Yes | Yes | Yes | No | Yes |

### Tools

Let Claude take actions on the web or in your environment. This feature consists of built-in tools that Claude invokes through `tool_use`. The platform runs server-side tools, and you implement and execute client-side tools.

| Feature | Description |
| --- | --- |
| Tool use with client-executed tools | Custom tools plus Anthropic-defined `bash`, `text editor`, `computer use`, and `memory`. For more information about these tools, see [Bash](https://platform.claude.com/docs/en/agents-and-tools/tool-use/bash-tool), [Text editor](https://platform.claude.com/docs/en/agents-and-tools/tool-use/text-editor-tool), [Computer use](https://platform.claude.com/docs/en/agents-and-tools/tool-use/computer-use-tool), and [Memory](https://platform.claude.com/docs/en/agents-and-tools/tool-use/memory-tool). |
| [Web search](https://platform.claude.com/docs/en/agents-and-tools/tool-use/web-search-tool) | Discover current real-world data from across the web to use to augment Claude's knowledge. For **Hosted on Azure** deployments, only the `web_search_20250305` tool version is supported. |
| [Web fetch](https://platform.claude.com/docs/en/agents-and-tools/tool-use/web-fetch-tool) | Retrieve and perform in-depth analysis of full content from specified web pages and PDF documents, augmenting Claude's context with live web content. On Foundry, web fetch requires a **Hosted on Anthropic infrastructure** deployment. For **Hosted on Azure** deployments, only the `web_fetch_20250910` tool version is supported. |

### Tool infrastructure

Discover, orchestrate, and scale tool use.

| Feature | Description |
| --- | --- |
| [Fine-grained tool streaming](https://platform.claude.com/docs/en/agents-and-tools/tool-use/fine-grained-tool-streaming) | Stream tool use parameters without buffering or JSON validation, reducing latency for large parameters. Requires the `anthropic-beta` header `fine-grained-tool-streaming-2025-05-14`. |
| [MCP connector](https://platform.claude.com/docs/en/agents-and-tools/mcp-connector) | Connect to remote MCP servers directly from the Messages API without a separate MCP client. |
| [Tool search](https://platform.claude.com/docs/en/agents-and-tools/tool-use/tool-search-tool) | Scale to thousands of tools by dynamically discovering and loading tools on demand using regex- and BM25-based search, optimizing context usage and improving tool selection accuracy. For **Hosted on Azure** deployments, both the `tool_search_tool_bm25_20251119` and `tool_search_tool_regex_20251119` tool versions are supported. The legacy aliases `tool_search_tool_bm25` and `tool_search_tool_regex` are also accepted. |

### Context management

Control and optimize Claude's context window for long-running sessions.

| Feature | Description |
| --- | --- |
| [Automatic prompt caching](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#automatic-caching) | Simplify prompt caching to a single API parameter. The system automatically caches the last cacheable block in your request, moving the cache point forward as conversations grow. |
| [Prompt caching (5m)](https://platform.claude.com/docs/en/build-with-claude/prompt-caching) | Provide Claude with more background knowledge and example outputs to reduce costs and latency. |
| [Prompt caching (1hr)](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#1-hour-cache-duration) | Extended 1-hour cache duration for less frequently accessed but important context, complementing the standard 5-minute cache. |
| [Context editing](https://platform.claude.com/docs/en/build-with-claude/context-editing) | Automatically manage conversation context with configurable strategies, including clearing tool results and managing thinking blocks. Requires the anthropic-beta header `context-management-2025-06-27`. |
| [Token counting](https://platform.claude.com/docs/en/build-with-claude/token-counting) | Token counting enables you to determine the number of tokens in a message before sending it to Claude, helping you make informed decisions about your prompts and usage. |

### Files and assets

Manage the documents and data you provide to Claude.

| Feature | Description |
| --- | --- |
| [Files API](https://platform.claude.com/docs/en/build-with-claude/files) | Currently available only on **Hosted on Anthropic infrastructure** deployments. Upload and manage files to use with Claude without re-uploading content with each request. Supports PDFs, images, and text files. |

## Agent support

- [Microsoft Agent Framework](https://learn.microsoft.com/en-us/agent-framework/user-guide/agents/agent-types/anthropic-agent) supports creating agents that use Claude models.
- Build custom AI agents with the [Claude Agent SDK](https://docs.claude.com/en/docs/agent-sdk/overview).

## Deployment types and regions

Claude models in Foundry are available for the following deployment types in specific Azure regions:

- **Global Standard**: All Claude models (Hosted on Azure and Hosted on Anthropic infrastructure).
- **Data Zone Standard (US)**: Hosted on Azure versions of `claude-opus-5-5`, `claude-opus-5`, `claude-opus-4-8`, `claude-sonnet-5`, and `claude-sonnet-5-5`.

For the exact Azure regions where Claude models are available for deployment, see [Region availability by deployment type](../06.1-explore-foundry-models/03-models-from-partners.md#region-availability-by-deployment-type).

## Quotas and rate limits

Rate limits for Claude models vary by model, deployment type, hosting version, and Azure subscription type. Limits are measured in requests per minute (RPM), uncached input tokens per minute (ITPM), and output tokens per minute (OTPM).

For current limits, shared quota behavior, and prompt cache accounting, see [Claude model quotas and rate limits](04-claude-models-quotas-limits.md).

## Responsible AI considerations

When using Claude models in Foundry, consider these responsible AI practices:

- Review [Data, privacy, and security for Claude models in Microsoft Foundry](../../13-manage-and-operate/13.3-security-and-governance/23-data-privacy.md) to understand how your data is processed and retained when you deploy Claude models.
- Configure AI content safety during model inference, because Foundry doesn't provide built-in content filtering for Claude models at deployment time.
- Ensure your applications comply with [Anthropic's Acceptable Use Policy](https://www.anthropic.com/legal/aup). Also, see details of safety evaluations for [Claude Fable 5.1 & Claude Mythos 5.1](https://www.anthropic.com/claude-fable-5-1-mythos-5-1-system-card), [Claude Fable 5](https://www.anthropic.com/claude-fable-5-system-card), [Claude Mythos 5](https://www.anthropic.com/claude-mythos-5-system-card), [Claude Mythos Preview](https://www.anthropic.com/claude-mythos-preview-system-card), [Claude Opus 5.5](https://aka.ms/waterfall/systemcard), [Claude Opus 5](https://www.anthropic.com/claude-opus-5-system-card), [Claude Opus 4.8](https://www.anthropic.com/claude-opus-4-8-system-card), [Claude Opus 4.7](https://www.anthropic.com/claude-opus-4-7-system-card), [Claude Opus 4.6](https://www.anthropic.com/claude-opus-4-6-system-card), [Claude Opus 4.5](http://www.anthropic.com/claude-opus-4-5-system-card), [Claude Sonnet 5](https://www.anthropic.com/claude-sonnet-5-system-card), [Claude Sonnet 4.6](https://www.anthropic.com/claude-sonnet-4-6-system-card), [Claude Sonnet 4.5](https://assets.anthropic.com/m/12f214efcc2f457a/original/Claude-Sonnet-4-5-System-Card.pdf), and [Claude Haiku 4.5](https://assets.anthropic.com/m/99128ddd009bdcb/Claude-Haiku-4-5-System-Card.pdf).

## Best practices

Follow these best practices when working with Claude models in Foundry:

### Prompt engineering

- **Clear instructions**: Provide specific and detailed prompts.
- **Context management**: Use the available context window effectively.
- **Role definitions**: Use system messages to define the assistant's role and behavior.
- **Structured prompts**: Use consistent formatting for better results.

### Cost optimization

To optimize your usage and avoid rate limiting:

- **Implement retry logic**: Handle 429 responses with exponential backoff.
- **Batch requests**: Combine multiple prompts when possible.
- **Monitor token usage**: Track your token consumption and request patterns.
- **Use appropriate models**: Use the most cost-effective model for your use case. See [Available Claude models](#available-claude-models).

## Related content

- [Deploy and use Claude models in Microsoft Foundry](06-use-foundry-models-claude.md)
- [Deploy Claude models in Microsoft Foundry using Bicep or Terraform](https://learn.microsoft.com/en-us/azure/developer/ai/how-to/deploy-claude-foundry?context=/azure/foundry/context/context)
- [Foundry Models from partners and community](../06.1-explore-foundry-models/03-models-from-partners.md)
- [Claude Consumption Units (CCU) billing in Microsoft Foundry](../../13-manage-and-operate/13.1-set-up-and-configure/20-claude-models-billing.md)
- [Data, privacy, and security for Claude models in Microsoft Foundry](../../13-manage-and-operate/13.3-security-and-governance/23-data-privacy.md)
