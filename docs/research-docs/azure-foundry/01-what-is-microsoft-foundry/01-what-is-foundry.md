# What is Microsoft Foundry?

| Field | Value |
| --- | --- |
| **Document Title** | What is Microsoft Foundry? |
| **Document Location** | `docs/research-docs/azure-foundry/01-what-is-microsoft-foundry/01-what-is-foundry.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "What is Microsoft Foundry?". Microsoft Foundry is a trusted platform that empowers developers to build AI agents, models, and apps. Learn what you can build and how to choose your build approach. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/what-is-foundry). Article date: 2026-08-13. Page updated: 2026-09-24. Retrieved: 2026-09-29. Navigation: What is Microsoft Foundry?.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Microsoft Foundry unifies agents, models, and tools under a single management grouping with built-in enterprise-readiness capabilities including tracing, monitoring, evaluations, and customizable enterprise setup configurations. The platform provides streamlined management through unified role-based access control (RBAC), networking, and policies under one Azure resource provider namespace.

> **Tip**
>
> - Coming from Azure OpenAI? [Upgrade your Azure OpenAI resource to a Foundry resource](../13-manage-and-operate/13.1-set-up-and-configure/05-upgrade-azure-openai.md) while preserving your endpoint, API keys, and existing state.
> - Using hub-based projects? Hub-based projects are accessible in the [Foundry (classic) portal](https://learn.microsoft.com/en-us/azure/foundry-classic/what-is-foundry). New investments are focused on Foundry projects in the new portal.

## Get started

Build your first agent in minutes, or open the portal to explore models and tools.

[Build with models and agents](../04-get-started/04.1-what-do-you-want-to-build/03-get-started-code.md)

[Open the Foundry portal](https://ai.azure.com/) | [Get an Azure account](https://azure.microsoft.com/pricing/purchase-options/azure-account)

## What you can build

| Capability | Description |
| --- | --- |
| **Agents** | Build declarative [prompt agents](../04-get-started/04.1-what-do-you-want-to-build/01-prompt-agent.md) and managed [voice-based prompt agents](../04-get-started/04.1-what-do-you-want-to-build/02-prompt-voice-agent.md) in the portal or SDK, or deploy [hosted agents](../07-agents/07.3-hosted-agents/07-quickstart-hosted-agent.md) that run your own code. Learn more in [Foundry Agent Service](../07-agents/01-overview.md). |
| **Models** | Access more than 10,000 models from Microsoft, OpenAI, Anthropic, Meta, and others. Browse the [Foundry Models catalog](../06-models/01-foundry-models-overview.md). |
| **Tools and knowledge** | Extend agents with built-in tools, memory, and retrieval using a [Foundry Toolbox](../04-get-started/04.1-what-do-you-want-to-build/06-toolbox-overview.md). |

Not sure where to start? See the [product and capability map](../02-product-and-capability-map/01-capabilities.md) to match your goal to a starting point.

### Voice-based prompt agents

Build real-time, spoken experiences with a voice-based prompt agent in Foundry Agent Service. Configure the model, instructions, audio settings, optional greeting, and tools. Then connect to the agent through Voice Live. Foundry manages the agent lifecycle and voice orchestration, so you don't need to host that infrastructure yourself. For more information, see [Quickstart: Create a voice-based prompt agent](../04-get-started/04.1-what-do-you-want-to-build/02-prompt-voice-agent.md).

## Enterprise-ready platform

Foundry brings platform capabilities to every project. Some capabilities are in preview. For current status, see the [general availability overview](../13-manage-and-operate/13.1-set-up-and-configure/01-general-availability.md).

- **Observability:** Trace and evaluate agents and models, and monitor them with built-in dashboards (preview). See [Observability](../09-observability/01-observability.md).
- **Governance and security:** Apply Microsoft Entra identity, role-based access control, content filters, network isolation, and Azure Policy. See the [Foundry control plane](../13-manage-and-operate/13.2-govern-at-scale/01-overview.md).
- **One management plane:** Manage agents, models, and tools as a single Azure resource with unified access control, networking, and policies.

## Start by building an agent

Most projects on Foundry center on an agent: a model paired with instructions and tools that can reason over a request and take action. The main decision is how much you want to customize and control how that agent runs. Think of it as a spectrum from declarative to full code.

- **Declarative, with the least to manage.** Specify instructions, choose a model, and attach tools in the Foundry portal or with the SDK. Foundry hosts and runs the agent for you, with no application code or containers to maintain. In Foundry, this is a **prompt agent**. [Create a prompt agent](../04-get-started/04.1-what-do-you-want-to-build/01-prompt-agent.md). For a real-time spoken experience, build a **voice-based prompt agent**. [Create a voice-based prompt agent](../04-get-started/04.1-what-do-you-want-to-build/02-prompt-voice-agent.md).
- **Full code, with the most control.** Bring your own code or framework (for example, Microsoft Agent Framework, LangGraph, or Semantic Kernel), package it as a container, and Foundry runs it with a managed endpoint, scaling, identity, and observability. In Foundry, this is a **hosted agent**. [Deploy a hosted agent](../07-agents/07.3-hosted-agents/07-quickstart-hosted-agent.md).

You can start declarative and move to code as your needs grow. For a detailed comparison, see [What are hosted agents?](../07-agents/07.3-hosted-agents/01-hosted-agents.md). For the end-to-end build, test, and ship cycle, see the [agent development lifecycle](../07-agents/07.1-concepts/01-development-lifecycle.md).

Not building an agent yet? If you only need to send prompts to a model with no tools or orchestration, start with a single [model call](../04-get-started/04.1-what-do-you-want-to-build/03-get-started-code.md).

## Choose your developer surface

Foundry supports several surfaces. Many developers combine them, for example, prototyping in the portal and then moving to code.

| Surface | Best for | Start here |
| --- | --- | --- |
| **Foundry portal** | Exploring models, prototyping prompts, and building prompt agents without writing code. | [Playgrounds and quick evaluation](../05-developer-tools-and-integrations/02-concept-playgrounds.md) |
| **SDKs** | Building applications in Python, C#, JavaScript, or Java. | [Microsoft Foundry SDKs](../05-developer-tools-and-integrations/05.4-sdks-and-apis/01-sdk-overview.md) |
| **Azure Developer CLI (azd)** | Scaffolding, running, testing, and deploying Hosted agent projects from the command line. | [Develop agents with the Azure Developer CLI](../05-developer-tools-and-integrations/05.1-azure-developer-cli/01-cli-agent-development.md) |
| **Visual Studio Code** | Building and debugging agents in your editor with the Foundry extension. | [Work in VS Code](../05-developer-tools-and-integrations/05.2-foundry-toolkit-for-visual-studio-code/01-get-started-projects-visual-studio-code.md) |
| **Coding agents and MCP** | Driving Foundry from coding agents (for example, GitHub Copilot or Claude Code) with the Foundry Skill and MCP server. | [Use the Microsoft Foundry Skill in coding agents](../04-get-started/04.1-what-do-you-want-to-build/05-use-microsoft-foundry-skill.md) |

## Recommended path for new developers

Follow these steps to go from zero to a working integration:

1. **Make your first model call.** Set up your environment and send a prompt with the [build with models and agents quickstart](../04-get-started/04.1-what-do-you-want-to-build/03-get-started-code.md).
2. **Set up your developer environment.** Install the CLI and SDK so you can build in code. See [Set up your developer environment](../05-developer-tools-and-integrations/01-install-cli-sdk.md).
3. **Choose a model.** Browse the catalog and compare options in the [Foundry Models overview](../06-models/01-foundry-models-overview.md).
4. **Build your first agent.** Start with a [prompt agent](../04-get-started/04.1-what-do-you-want-to-build/01-prompt-agent.md), or go straight to a [Hosted agent](../07-agents/07.3-hosted-agents/07-quickstart-hosted-agent.md) if you want to bring your own code.
5. **Add tools and knowledge.** Extend your agent with tools, retrieval, and memory (preview). Start with the [toolbox overview](../04-get-started/04.1-what-do-you-want-to-build/06-toolbox-overview.md), the recommended way to add tools to an agent.

## Evolution of Foundry

Foundry consolidates several previous Azure AI services and tools into a unified platform. For detailed guidance on transitioning, see [Navigate from classic to the new experience](../04-get-started/04.2-explore-and-migrate/01-navigate-from-classic.md).

**Previous concepts and their current equivalents**

| Dimension | Previous | Current |
| --- | --- | --- |
| Brand | Azure AI Studio / Azure AI Foundry | Microsoft Foundry |
| Brand | Azure AI Services | Foundry Tools |
| Portal | [Foundry (classic)](https://learn.microsoft.com/en-us/azure/foundry-classic/) | [Foundry](https://learn.microsoft.com/en-us/azure/foundry) |
| Agent API | Assistants API (Agents v0.5/v1) | Responses API (Agents v2) |
| API versioning | Monthly `api-version` params | v1 stable routes (`/openai/v1/`) |
| Resource model | Hub + Azure OpenAI + Azure AI Services | Foundry resource (single, with projects) |
| SDKs & endpoints | Multiple packages (`azure-ai-inference`, `azure-ai-generative`, `azure-ai-ml`, `AzureOpenAI()`) against 5+ endpoints | Unified project client (`azure-ai-projects` 2.x) + `OpenAI()` against one project endpoint. |
| Terminology | Threads, Messages, Runs, Assistants | Conversations, Items, Responses, Agent Versions |

## Related content

- [What is Foundry Agent Service?](../07-agents/01-overview.md)
- [Microsoft Foundry product and capability map](../02-product-and-capability-map/01-capabilities.md)
- [Microsoft Foundry capability reference](../03-capability-reference/01-capability-reference.md)
- [Foundry Models](../06-models/01-foundry-models-overview.md)
- [Microsoft Foundry architecture](../13-manage-and-operate/13.3-security-and-governance/22-architecture.md)
- [Agent development lifecycle](../07-agents/07.1-concepts/01-development-lifecycle.md)
- [What's new in Microsoft Foundry](../13-manage-and-operate/13.4-operate-and-support/01-whats-new-foundry.md)
- [Microsoft Foundry product and capability map](../02-product-and-capability-map/01-capabilities.md)
- [Microsoft Foundry capability reference](../03-capability-reference/01-capability-reference.md)
- [Microsoft Foundry portal general availability overview](../13-manage-and-operate/13.1-set-up-and-configure/01-general-availability.md)
- [Upgrade your Azure OpenAI resource to a Foundry resource](../13-manage-and-operate/13.1-set-up-and-configure/05-upgrade-azure-openai.md)
- [Find hub-based projects in the Foundry (classic) portal](https://learn.microsoft.com/en-us/azure/foundry-classic/what-is-foundry)
