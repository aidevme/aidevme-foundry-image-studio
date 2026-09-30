# Microsoft Foundry capability reference

| Field | Value |
| --- | --- |
| **Document Title** | Microsoft Foundry capability reference |
| **Document Location** | `docs/research-docs/azure-foundry/03-capability-reference/01-capability-reference.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Microsoft Foundry capability reference". Reference list of Microsoft Foundry capabilities by area, including models, agents, tools, knowledge, observability, evaluation, guardrails, and governance. |
| **Version** | 1.2 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/concepts/capability-reference). Article date: 2026-08-12. Page updated: 2026-09-24. Retrieved: 2026-09-29. Navigation: Capability reference.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

This article lists Microsoft Foundry capabilities by area and links each one to its canonical documentation. Use it when you know roughly what you need and want to find the right article.

If you're deciding where to start instead, see [Microsoft Foundry product and capability map](../02-product-and-capability-map/01-capabilities.md).

Each entry is a capability family rather than an individual article, model, or API operation. Capabilities marked (preview) are offered under [supplemental terms of use](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) and aren't recommended for production workloads. Preview status can vary by feature, region, and API version, so check the linked article for current details.

## Build surfaces and developer tools

Where you author, test, and ship Foundry work.

| Capability | What it does |
| --- | --- |
| [Foundry portal](../13-manage-and-operate/13.1-set-up-and-configure/01-general-availability.md) | Web experience for exploring models, building prompt agents, running evaluations, and managing resources. |
| [Playgrounds](../05-developer-tools-and-integrations/02-concept-playgrounds.md) | Try models, prompts, and agents interactively before you write code. |
| [Microsoft Foundry SDKs](../05-developer-tools-and-integrations/05.4-sdks-and-apis/01-sdk-overview.md) | Client libraries for Python, C#, JavaScript, and Java. |
| [Azure Developer CLI (azd) extensions](../05-developer-tools-and-integrations/05.1-azure-developer-cli/01-cli-agent-development.md) | Scaffold, run, test, and deploy agent projects from the command line. |
| [Visual Studio Code extension](https://learn.microsoft.com/en-us/azure/foundry/how-to/develop/get-started-projects-vs-code) | Work with Foundry projects, models, and agents inside VS Code. |
| [Foundry Agent Canvas](../05-developer-tools-and-integrations/05.3-coding-agents/03-foundry-agent-canvas.md) | Visual surface for composing and inspecting agents. |
| [Coding agent integration](../05-developer-tools-and-integrations/05.3-coding-agents/02-use-cli-with-coding-agents.md) | Build Foundry projects with AI coding agents such as GitHub Copilot, including Model Context Protocol access through the Foundry MCP Server. |
| [Templates and samples](../04-get-started/04.1-what-do-you-want-to-build/07-ai-template-get-started.md) | Start from prebuilt application templates and GitHub samples. |
| [LangChain and LangGraph integration](../05-developer-tools-and-integrations/05.5-develop-with-langchain-and-langgraph/01-langchain.md) | Use Foundry models, tools, memory, and tracing from LangChain and LangGraph apps. |

## Models

Model selection, deployment, and lifecycle.

| Capability | What it does |
| --- | --- |
| [Foundry Models catalog](../06-models/01-foundry-models-overview.md) | Discover and compare models from Microsoft, OpenAI, Anthropic, Meta, and others, across models sold by Azure and models from partners and community. |
| [Model deployment](../06-models/06.4-model-deployment/02-create-model-deployments.md) | Create and manage model endpoints from the portal or code. |
| [Deployment types](../06-models/06.3-offers-deployment-types-and-pricing/04-deployment-types.md) | Choose how capacity is served, including standard, global, data zone, provisioned throughput (PTU), batch, and priority processing. |
| [Managed compute](../06-models/06.3-offers-deployment-types-and-pricing/03-managed-compute-overview.md) (preview) | Deploy models to dedicated virtual machine capacity in your resource. |
| [Instant access models](../06-models/06.3-offers-deployment-types-and-pricing/02-instant-models.md) (preview) | Use selected models without provisioning a deployment first. |
| [Model router](../06-models/06.1-explore-foundry-models/19-model-router.md) | Route requests automatically to the best model for cost and quality. |
| [Model benchmarks and leaderboards](../06-models/06.1-explore-foundry-models/05-model-benchmarks.md) | Compare model quality, cost, and performance before you commit. |
| [Fine-tuning](../06-models/06.8-fine-tuning/07-fine-tune-cli.md) | Customize models on your own data, including synthetic data generation. |
| [Model versions and lifecycle](../06-models/06.1-explore-foundry-models/09-model-versions.md) | Track versions, automatic updates, retirement schedules, and support policy. |
| [Healthcare AI models](../06-models/06.5-model-support/09-healthcare-ai-models.md) | Domain-specific models for medical imaging and reporting scenarios. |
| [Hugging Face models](../06-models/06.1-explore-foundry-models/04-hugging-face-models.md) | Deploy open models from Hugging Face into Foundry. |
| [Fireworks on Foundry](../05-developer-tools-and-integrations/05.7-fireworks-on-foundry/01-enable-fireworks-models.md) | Use Fireworks models and import custom models. |
| [Quotas and region availability](../06-models/06.2-quota-limits-and-region-availability/05-quotas-limits.md) | Understand and manage capacity limits by model and region. |

## Agents

Foundry Agent Service and the agent development lifecycle.

| Capability | What it does |
| --- | --- |
| [Foundry Agent Service](../07-agents/01-overview.md) | Build, run, and operate agents as a managed service. |
| [Prompt agents](../04-get-started/04.1-what-do-you-want-to-build/01-prompt-agent.md) | Declarative agents defined by instructions, a model, and attached tools. |
| [Hosted agents](../07-agents/07.3-hosted-agents/01-hosted-agents.md) | Run your own agent code or framework in a Foundry-managed runtime. |
| [Agent development lifecycle](../07-agents/07.1-concepts/01-development-lifecycle.md) | End-to-end build, test, deploy, and iterate workflow for agents. |
| [Agent identity](../07-agents/07.1-concepts/02-agent-identity.md) | Give agents a Microsoft Entra identity for authenticated access to resources. |
| [Workflows](../07-agents/07.1-concepts/06-workflow.md) | Coordinate multiple agents and steps into a single orchestrated process. |
| [Routines](../07-agents/07.1-concepts/05-routines.md) | Package repeatable agent procedures for reuse. |
| [Agent-to-agent (A2A)](../08-toolboxes/08.1-add-tools-and-skills/09-agent-to-agent.md) | Let agents call other agents across services and vendors. |
| [Responses API](../07-agents/07.2-prompt-agents/01-responses-api.md) | Stateful API for model and agent interactions. |
| [Voice agents](../04-get-started/04.1-what-do-you-want-to-build/02-prompt-voice-agent.md) | Add speech input and output to agents. |
| [Microsoft Agent 365 integration](../07-agents/07.1-concepts/03-agent-365-integration.md) | Manage and observe Foundry agents alongside Microsoft 365 agents. |
| [Continuous integration and deployment](../07-agents/07.3-hosted-agents/16-set-up-cicd-hosted-agent.md) | Ship agents through automated pipelines. |
| [Agent debugging tools](../07-agents/07.3-hosted-agents/27-agent-inspector.md) | Inspect and diagnose agent behavior locally and in the cloud. |

## Tools

Capabilities you attach to an agent so it can act.

| Capability | What it does |
| --- | --- |
| [Tool catalog](https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/tool-catalog) | Browse every tool an agent can use, with setup requirements. |
| [Function calling](../08-toolboxes/08.1-add-tools-and-skills/29-function-calling.md) | Let an agent call your own functions with structured arguments. |
| [Code interpreter](../08-toolboxes/08.1-add-tools-and-skills/26-code-interpreter.md) | Run generated code in a sandbox to analyze data and produce files. |
| [File search](../08-toolboxes/08.1-add-tools-and-skills/23-file-search.md) | Ground answers in uploaded files through managed vector stores. |
| [Web search and Grounding with Bing](../08-toolboxes/08.1-add-tools-and-skills/11-web-overview.md) | Ground answers in current web results. |
| [Browser automation](../08-toolboxes/08.1-add-tools-and-skills/31-browser-automation.md) (preview) | Let an agent navigate and act on websites. |
| [Computer use](../08-toolboxes/08.1-add-tools-and-skills/32-computer-use.md) (preview) | Let an agent operate a virtual computer interface. |
| [Image generation](../08-toolboxes/08.1-add-tools-and-skills/33-image-generation.md) (preview) | Generate images from an agent. |
| [OpenAPI tool](../08-toolboxes/08.1-add-tools-and-skills/08-openapi.md) | Call any REST API described by an OpenAPI specification. |
| [Model Context Protocol (MCP)](../08-toolboxes/08.1-add-tools-and-skills/01-model-context-protocol.md) | Connect agents to MCP servers, including managed servers and your own. |
| [Azure Functions](../08-toolboxes/08.1-add-tools-and-skills/36-azure-functions.md) | Trigger serverless functions as agent actions. |
| [SharePoint and Fabric connectors](../08-toolboxes/08.1-add-tools-and-skills/02-connectors.md) (preview) | Reach enterprise data sources from an agent. |
| [Toolbox](../04-get-started/04.1-what-do-you-want-to-build/06-toolbox-overview.md) | Bundle and manage the tools available to an agent, including tool search for large tool sets and a private catalog of organization-approved tools. |
| [Skills](../08-toolboxes/08.1-add-tools-and-skills/06-skills.md) (preview) | Package reusable agent behavior beyond a single tool call. |
| [Foundry Tools: Speech, Language, Translator](../08-toolboxes/08.1-add-tools-and-skills/37-azure-ai-speech.md) | Add speech, language understanding, PII detection, and translation. |

## Knowledge and retrieval

How agents and applications ground responses in your data.

| Capability | What it does |
| --- | --- |
| [Retrieval-augmented generation (RAG)](../08-toolboxes/08.1-add-tools-and-skills/24-retrieval-augmented-generation.md) | Patterns for grounding model responses in your own content. |
| [Azure AI Search integration](../08-toolboxes/08.1-add-tools-and-skills/28-ai-search.md) | Use Azure AI Search indexes as agent knowledge. |
| [Vector stores](../08-toolboxes/08.1-add-tools-and-skills/25-vector-stores.md) | Managed storage and indexing for file search. |
| [Foundry IQ](../08-toolboxes/08.1-add-tools-and-skills/14-what-is-foundry-iq.md) | Agentic retrieval over a knowledge base, including private networking. |
| [Fabric IQ](../08-toolboxes/08.1-add-tools-and-skills/21-fabric-iq.md) (preview) | Reason over Microsoft Fabric data and semantic models. |
| [Work IQ](../08-toolboxes/08.1-add-tools-and-skills/22-work-iq.md) (preview) | Reason over Microsoft 365 work data. |
| [Memory](../08-toolboxes/08.1-add-tools-and-skills/38-what-is-memory.md) (preview) | Give agents persistent memory across sessions. |

## Observability

Understand what your agents and models are doing in production.

| Capability | What it does |
| --- | --- |
| [Foundry Observability](../09-observability/01-observability.md) | Unified monitoring, tracing, and evaluation for agents and models. |
| [Tracing](../09-observability/09.2-tracing/01-trace-agent-concept.md) | Capture and replay agent execution traces, including client-side spans. |
| [Agent monitoring dashboard](../07-agents/07.3-hosted-agents/33-how-to-monitor-agents-dashboard.md) | Track agent health, usage, quality, and cost over time. |
| [Model deployment monitoring](../09-observability/09.1-monitoring/04-monitor-models.md) | Watch latency, throughput, and errors for model endpoints. |
| [End-user feedback logging](../09-observability/09.1-monitoring/03-log-end-user-feedback.md) | Collect and analyze feedback signals from your application. |
| [Notification Center](../09-observability/09.1-monitoring/01-concept-notification-center.md) | See service and resource notifications in the portal. |
| [External agent registration](../09-observability/09.2-tracing/07-register-external-agent.md) (preview) | Bring agents that run outside Foundry into Foundry observability. |
| [Diagnostic logging](../13-manage-and-operate/13.3-security-and-governance/16-diagnostic-logging.md) | Send platform logs and metrics to Azure Monitor. |

## Evaluation and optimization

Measure and improve quality, safety, and cost.

| Capability | What it does |
| --- | --- |
| [Evaluations](../10-evaluation/10.3-run-evaluations/12-evaluate-generative-ai-app.md) | Score generative AI apps and agents from the portal, SDK, or CI/CD. |
| [Built-in evaluators](../10-evaluation/10.1-supported-evaluators/01-built-in-evaluators.md) | Use general purpose, similarity, RAG, agent, safety, and rubric evaluators. |
| [Custom evaluators](../10-evaluation/10.1-supported-evaluators/09-custom-evaluators.md) | Define your own scoring logic. |
| [Agent evaluation](../10-evaluation/10.3-run-evaluations/01-evaluate-agent.md) | Evaluate agent trajectories, tool calls, and task completion. |
| [Continuous evaluation](../10-evaluation/10.3-run-evaluations/02-cloud-evaluation.md) | Evaluate production traffic on an ongoing basis. |
| [Evaluation datasets](../10-evaluation/10.2-evaluation-datasets/03-evaluation-dataset-synthetic.md) | Generate synthetic test data or build datasets from agent traces when you don't have labeled examples. |
| [Human evaluation](../10-evaluation/10.3-run-evaluations/14-human-evaluation.md) | Collect structured human judgments and annotate traces. |
| [Prompt optimizer](../11-optimization/11.1-run-optimizations/01-prompt-optimizer.md) | Improve agent instructions automatically from evaluation results. |
| [Agent optimizer](../11-optimization/01-agent-optimizer-overview.md) (preview) | Tune hosted agent instructions and skills against a target dataset. |
| [AI red teaming](../10-evaluation/10.4-ai-red-teaming/01-ai-red-teaming-agent.md) | Run automated adversarial scans locally or in the cloud. |
| [Evaluations in CI/CD](../10-evaluation/10.5-evaluations-in-ci-cd-pipelines/01-evaluation-github-action.md) | Gate releases with evaluations in GitHub Actions or Azure DevOps. |

## Trust and safety

Guardrails, content safety, and responsible AI.

| Capability | What it does |
| --- | --- |
| [Guardrails and controls](../12-trust-and-safety/12.1-guardrails-and-controls/01-guardrails-overview.md) | Filter and control content across models and agents. Includes harm category filters, Prompt Shields for jailbreak and prompt injection, groundedness detection, sensitive data (PII) detection, and protected material detection. |
| [Custom filtering](../12-trust-and-safety/12.1-guardrails-and-controls/02-how-to-create-guardrails.md) | Extend the built-in filters with your own block lists and custom categories. |
| [Task adherence](../12-trust-and-safety/12.1-guardrails-and-controls/07-task-adherence.md) | Detect when an agent strays from its assigned task. |
| [Guided Guardrail](../12-trust-and-safety/12.1-guardrails-and-controls/14-guided-set-up.md) (preview) | Configure guardrails through a guided setup experience. |
| [Third-party guardrail integrations](../12-trust-and-safety/12.1-guardrails-and-controls/13-third-party-integrations.md) | Plug partner safety systems into Foundry intervention points. |
| [Responsible AI transparency notes](../12-trust-and-safety/12.2-responsible-ai/08-transparency-note.md) | Understand intended uses, limitations, and data handling. |
| [Customer Copyright Commitment](../12-trust-and-safety/12.2-responsible-ai/06-customer-copyright-commitment.md) | Review Microsoft's copyright commitment for covered services. |

## Manage, secure, and govern

Platform administration for Foundry at scale.

| Capability | What it does |
| --- | --- |
| [Foundry resources and projects](../13-manage-and-operate/13.1-set-up-and-configure/07-create-projects.md) | Organize work with Foundry resources and projects. |
| [Foundry control plane](../13-manage-and-operate/13.2-govern-at-scale/01-overview.md) | Govern agents, models, and tools across your estate. |
| [Fleet monitoring](../13-manage-and-operate/13.2-govern-at-scale/02-monitoring-across-fleet.md) | Track health and performance across many agents. |
| [Token limit enforcement](../13-manage-and-operate/13.2-govern-at-scale/06-how-to-enforce-limits-models.md) | Cap model consumption per agent, project, or team. |
| [AI gateway integration](../13-manage-and-operate/13.1-set-up-and-configure/14-ai-gateway.md) | Front Foundry with Azure API Management for routing and policy. |
| [Role-based access control](../13-manage-and-operate/13.3-security-and-governance/02-rbac-foundry.md) | Assign Foundry roles and scope permissions. |
| [Keyless authentication](../13-manage-and-operate/13.3-security-and-governance/05-configure-entra-id.md) | Use Microsoft Entra identities instead of API keys. |
| [Network isolation](../13-manage-and-operate/13.3-security-and-governance/06-networking-options.md) | Use private endpoints, managed virtual networks, and network security perimeter. |
| [Customer-managed keys](../13-manage-and-operate/13.3-security-and-governance/12-encryption-keys-portal.md) | Encrypt data with keys you control. |
| [Azure Policy support](../13-manage-and-operate/13.3-security-and-governance/14-model-deployment-policy.md) | Apply built-in and custom policy definitions to Foundry resources. |
| [Cost management](../06-models/06.3-offers-deployment-types-and-pricing/16-manage-costs.md) | Plan, monitor, and optimize Foundry spend. |
| [High availability and disaster recovery](../13-manage-and-operate/13.3-security-and-governance/18-high-availability-resiliency.md) | Design for resiliency and recover from outages or data loss. |
| [Azure Government support](../13-manage-and-operate/13.4-operate-and-support/05-foundry-azure-government.md) | Run Foundry workloads in Azure Government. |
| [Infrastructure as code](../13-manage-and-operate/13.1-set-up-and-configure/03-create-resource-template.md) | Deploy Foundry with Bicep, Terraform, or the Azure CLI. |

## APIs and SDKs

Programmatic surfaces for building on Foundry.

| Capability | What it does |
| --- | --- |
| [Foundry API reference](https://ai.azure.com/api-reference/) | Browse the interactive reference for Foundry data plane operations. |
| [Foundry Models endpoints](../05-developer-tools-and-integrations/05.4-sdks-and-apis/02-endpoints.md) | Call deployed models over a consistent inference endpoint. |
| [Foundry v1 REST API](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/?view=rest-microsoft-foundry-v1&preserve-view=true) | Use the OpenAI-compatible surface for chat, responses, embeddings, files, and fine-tuning. |
| [Resource management API](https://learn.microsoft.com/en-us/azure/templates/microsoft.cognitiveservices/accounts?pivots=deployment-language-bicep) | Create and configure Foundry resources with ARM, Bicep, or the Azure CLI. |

## Related content

- [Microsoft Foundry product and capability map](../02-product-and-capability-map/01-capabilities.md)
- [What is Microsoft Foundry?](../01-what-is-microsoft-foundry/01-what-is-foundry.md)
- [Choose how to build with Microsoft Foundry](../01-what-is-microsoft-foundry/01-what-is-foundry.md#start-by-building-an-agent)
