# Microsoft Foundry product and capability map

| Field | Value |
| --- | --- |
| **Document Title** | Microsoft Foundry product and capability map |
| **Document Location** | `docs/research-docs/azure-foundry/02-product-and-capability-map/01-capabilities.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Microsoft Foundry product and capability map". Find where to start in Microsoft Foundry. Match your goal to a starting point, then compare the major products and capabilities and who each one is for. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/concepts/capabilities). Article date: 2026-08-12. Page updated: 2026-09-24. Retrieved: 2026-09-29. Navigation: Product and capability map.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Microsoft Foundry covers a wide range of features, and the hardest part is often knowing where to start. This article maps common goals to a starting point, then summarizes the major Foundry products and capabilities so you can tell them apart.

For an exhaustive list of everything in Foundry, see the [capability reference](../03-capability-reference/01-capability-reference.md).

## Start with your goal

Find the row closest to what you're trying to do.

| I want to | Start here | Why |
| --- | --- | --- |
| Send a prompt to a model, with no agent or tools | [Build with models and agents](../04-get-started/04.1-what-do-you-want-to-build/03-get-started-code.md) | The shortest path to a working call. Add an agent later only if you need tools or orchestration. |
| Build my first agent | [Choose how to build](../01-what-is-microsoft-foundry/01-what-is-foundry.md#start-by-building-an-agent) | Decides prompt agent versus hosted agent before you invest in either. That choice shapes everything after it. |
| Host an agent I already wrote | [Deploy a hosted agent](../07-agents/07.3-hosted-agents/07-quickstart-hosted-agent.md) | Runs your existing code or container with a managed endpoint, scaling, and identity. |
| Use an open-source framework with Foundry | [Frameworks for hosted agents](../07-agents/07.3-hosted-agents/24-framework-hosted-agents.md) | Shows how LangGraph, Microsoft Agent Framework, and Semantic Kernel map onto Foundry hosting. |
| Evaluate agent quality | [Evaluate generative AI apps](../10-evaluation/10.3-run-evaluations/12-evaluate-generative-ai-app.md) | Establishes a baseline score first, so later changes are measurable rather than anecdotal. |
| Add observability | [Foundry Observability](../09-observability/01-observability.md) | Tracing, monitoring, and evaluation share one data model, so set them up together. |
| Deploy and operate an application | [Set up CI/CD for agents](../07-agents/07.3-hosted-agents/16-set-up-cicd-hosted-agent.md) | Gets a repeatable release path before you scale. For fleet-wide governance, see the [control plane](../13-manage-and-operate/13.2-govern-at-scale/01-overview.md). |

## Major products and capabilities

Each row names one decision-level entry point. The **When to use it** column states the fit first, then the boundary where another option is a better match.

| Product or capability | What it is | When to use it | Who it's for |
| --- | --- | --- | --- |
| [Foundry portal](../13-manage-and-operate/13.1-set-up-and-configure/01-general-availability.md) | Web experience for models, agents, evaluations, and resources. | Use to explore and prototype without writing code. If you need repeatable builds, move to the SDKs or CLI. | Anyone evaluating Foundry |
| [Prompt agents](../04-get-started/04.1-what-do-you-want-to-build/01-prompt-agent.md) | Declarative agents defined by instructions, a model, and tools. | Use when you want an agent with no runtime to manage. If you need custom code or a container, use hosted agents instead. | Agent developer |
| [Voice-based prompt agents](../04-get-started/04.1-what-do-you-want-to-build/02-prompt-voice-agent.md) | Prompt agents that speak and listen in real time, with managed voice orchestration. | Use when you want a spoken experience without hosting a speech pipeline. If you only need text responses, use prompt agents. | Agent developer |
| [Hosted agents](../07-agents/07.3-hosted-agents/01-hosted-agents.md) | Your own agent code or framework, run by Foundry. | Use when you need full control of agent logic and dependencies. If instructions and tools are enough, prompt agents are simpler. | Agent developer |
| [Foundry Models](../06-models/01-foundry-models-overview.md) | Catalog of models from Microsoft, OpenAI, Anthropic, Meta, and others. | Use to choose and deploy the model behind your app or agent. If a model needs your domain data, consider fine-tuning. | Application developer |
| [Fine-tuning](../06-models/06.8-fine-tuning/07-fine-tune-cli.md) | Customization of a model on your own data. | Use when prompting and retrieval can't reach the quality you need. If the gap is missing context, use retrieval instead. | ML engineer |
| [Toolbox](../04-get-started/04.1-what-do-you-want-to-build/06-toolbox-overview.md) | Managed endpoint that packages the tools an agent can call. | Use to give an agent actions and to govern tools centrally. If the agent only needs your own data, start with Foundry IQ. | Agent developer |
| [Foundry IQ](../08-toolboxes/08.1-add-tools-and-skills/14-what-is-foundry-iq.md) | Agentic retrieval over a knowledge base. | Use to ground answers in your content. If you only need a few uploaded files, file search is lighter weight. | Agent developer |
| [Memory](../08-toolboxes/08.1-add-tools-and-skills/38-what-is-memory.md) (preview) | Persistent agent recall across sessions. | Use when an agent must remember prior turns or user context. If each request stands alone, skip it. | Agent developer |
| [Workflows](../07-agents/07.1-concepts/06-workflow.md) | Orchestration of multiple agents and steps. | Use when one task spans several agents or stages. If a single agent with tools can finish the job, stay simpler. | Agent developer |
| [Microsoft Foundry SDKs](../05-developer-tools-and-integrations/05.4-sdks-and-apis/01-sdk-overview.md) | Client libraries for Python, C#, JavaScript, and Java. | Use to build Foundry into an application. If you're scaffolding and deploying agent projects, add the Azure Developer CLI. | Application developer |
| [Azure Developer CLI (azd)](../05-developer-tools-and-integrations/05.1-azure-developer-cli/01-cli-agent-development.md) | Command-line scaffolding, deployment, and environment management. | Use to create, run, and ship agent projects repeatably. If you only call models from an app, the SDKs are enough. | Platform engineer |
| [Visual Studio Code extension](https://learn.microsoft.com/en-us/azure/foundry/how-to/develop/get-started-projects-vs-code) | Foundry projects, models, and agents inside the editor. | Use to build and debug without leaving VS Code. If you want an AI assistant to drive Foundry, use coding agents. | Application developer |
| [Coding agents and MCP](../04-get-started/04.1-what-do-you-want-to-build/05-use-microsoft-foundry-skill.md) | Model Context Protocol access to Foundry for coding agents. | Use to let GitHub Copilot or Claude Code work against Foundry. If you prefer direct authoring, use the VS Code extension. | Application developer |
| [LangChain and LangGraph](../05-developer-tools-and-integrations/05.5-develop-with-langchain-and-langgraph/01-langchain.md) | Integration of Foundry models, tools, memory, and tracing. | Use when your team already builds on LangChain or LangGraph. If you're starting fresh, native agents need less glue code. | Agent developer |
| [Foundry Observability](../09-observability/01-observability.md) | Tracing, monitoring, and dashboards for agents and models. | Use to see what agents actually did in production. If you're comparing versions before release, start with evaluations. | AI quality engineer |
| [Evaluations](../10-evaluation/10.3-run-evaluations/12-evaluate-generative-ai-app.md) | Scoring for generative AI apps and agents. | Use to measure quality and catch regressions before release. If you need adversarial coverage, add AI red teaming. | AI quality engineer |
| [AI red teaming](../10-evaluation/10.4-ai-red-teaming/01-ai-red-teaming-agent.md) | Automated adversarial scans against a model or agent. | Use to probe for unsafe or exploitable behavior. If you're measuring everyday quality, evaluations fit better. | Security administrator |
| [Guardrails and controls](../12-trust-and-safety/12.1-guardrails-and-controls/01-guardrails-overview.md) | Content filters and safety controls for models and agents. | Use to enforce safety at run time. If you're testing safety before release, pair it with AI red teaming. | Security administrator |
| [Foundry control plane](../13-manage-and-operate/13.2-govern-at-scale/01-overview.md) | Governance for agents, models, and tools across your estate. | Use to set limits, policy, and oversight across many projects. If you're governing a single project, project settings are enough. | Platform engineer |

## Related content

- [Microsoft Foundry capability reference](../03-capability-reference/01-capability-reference.md)
- [What is Microsoft Foundry?](../01-what-is-microsoft-foundry/01-what-is-foundry.md)
- [Choose how to build with Microsoft Foundry](../01-what-is-microsoft-foundry/01-what-is-foundry.md#start-by-building-an-agent)
- [Service architecture](../13-manage-and-operate/13.3-security-and-governance/22-architecture.md)
