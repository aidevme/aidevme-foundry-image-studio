# Microsoft Foundry Toolkit for Visual Studio Code overview

| Field | Value |
| --- | --- |
| **Document Title** | Microsoft Foundry Toolkit for Visual Studio Code overview |
| **Document Location** | `docs/research-docs/azure-foundry/05-developer-tools-and-integrations/05.2-foundry-toolkit-for-visual-studio-code/01-get-started-projects-visual-studio-code.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Microsoft Foundry Toolkit for Visual Studio Code overview". Learn how Microsoft Foundry Toolkit helps you discover models and build, test, deploy, evaluate, and monitor AI apps and agents in Visual Studio Code. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/develop/get-started-projects-visual-studio-code). Article date: 2026-09-10. Page updated: 2026-09-17. Retrieved: 2026-09-29. Navigation: Developer tools and integrations > Foundry Toolkit for Visual Studio Code > Overview.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Microsoft Foundry Toolkit for Visual Studio Code is an extension for building, testing, deploying, evaluating, and monitoring AI apps and agents. Use it locally or connect to Microsoft Foundry to manage your AI development workflow without leaving Visual Studio Code.

Foundry Toolkit is the new name for AI Toolkit. It also includes the capabilities previously provided by the separate Microsoft Foundry extension, so you can work with local resources and Foundry resources in one extension.

## Who should use Foundry Toolkit

Foundry Toolkit supports different roles and levels of AI development experience:

- **Application developers** can add generative AI features to web, desktop, and mobile apps.
- **AI and machine learning engineers** can compare, customize, optimize, and deploy models and agents.
- **Data scientists and researchers** can experiment with prompts, models, datasets, and evaluation criteria.
- **Educators and students** can explore generative AI concepts through interactive playgrounds and local models.

## How the Toolkit workspace is organized

Foundry Toolkit separates resources that you have from actions that you can take. The extension has three main sections.

[![Screenshot of Foundry Toolkit in Visual Studio Code with My Resources, Developer Tools, and Help and Feedback sections.](https://learn.microsoft.com/en-us/azure/foundry/media/how-to/get-started-projects-vs-code/foundry-toolkit-overview.png)](https://learn.microsoft.com/en-us/azure/foundry/media/how-to/get-started-projects-vs-code/foundry-toolkit-overview.png#lightbox)

| Section | Purpose |
| --- | --- |
| **My Resources** | View models, agents, tools, knowledge sources, evaluations, recent resources, local resources, and resources in your Foundry project. |
| **Developer Tools** | Discover models and tools. Build, debug, deploy, test, evaluate, and monitor AI apps and agents. |
| **Help And Feedback** | Ask Copilot, get started, open documentation and release information, report issues, or join the community. |

The exact tools and resource types can change as the extension evolves. Use the Toolkit view to see the features in your installed version.

## Work with models

Foundry Toolkit provides an end-to-end model development workflow:

- Use the **Model Catalog** to discover models from Foundry and external providers, or use local models through ONNX, Ollama, and Foundry Local.
- Compare models and test prompts, parameters, images, and attachments in the **Model Playground**.
- Convert, quantize, optimize, and evaluate supported models for local Windows deployment.
- Fine-tune supported models locally with a GPU or remotely with Azure Container Apps.
- Profile CPU, GPU, and NPU usage for supported Windows machine learning workloads.

## Build and operate agents

Foundry Toolkit supports prompt agents and code-based hosted agents. Start with [Create an agent](04-create-agent-visual-studio-code.md) to compare Agent Builder, hosted-agent samples, and Copilot-assisted coding.

| Task | Guide |
| --- | --- |
| Configure a model, instructions, and tools without a hosted-agent code project. | [Create a prompt agent](05-create-prompt-agent-visual-studio-code.md). |
| Develop, inspect, and deploy code-based orchestration with Microsoft Agent Framework. | [Create hosted agents](06-vs-code-agents-workflow-pro-code.md). |
| Maintain an existing declarative workflow and prepare its migration. | [Use and migrate declarative agent workflows](07-vs-code-agents-workflow-low-code.md). |

Agent Builder also supports locally stored prompts. Their tools, structured output, and dataset evaluation options differ from those of Foundry prompt agents. Local storage doesn't mean that model inference runs on your machine. See [Work with local prompts](05-create-prompt-agent-visual-studio-code.md#work-with-local-prompts).

During development, you can:

- Use **Agent Builder** to test conversations, save prompt-agent versions, and generate client code that calls a saved Foundry agent.
- Use the **Tool Catalog** to discover Foundry tools, Model Context Protocol (MCP) servers, and toolboxes, and then add them to agents.
- Use **Agent Inspector** to debug local agents, inspect streaming responses and tool calls, and visualize workflow execution.
- Deploy hosted agents to Foundry Agent Service from source code or a container image.
- Test deployed agents in the **Hosted Agent Playground**, inspect logs and traces, and manage versions.
- Evaluate models, prompts, and agents with datasets, built-in evaluators, or custom criteria.

> **Important**
>
> Declarative workflows in Microsoft Foundry retire on December 1, 2026. Use Microsoft Agent Framework for new workflow development. This retirement doesn't affect code-based orchestration in hosted agents. See the [workflow migration guide](../../07-agents/07.1-concepts/06-workflow.md#migration-guide).

Some Toolkit experiences are available in preview. Review the [Foundry Toolkit release notes](https://github.com/microsoft/foundry-dev-tools/blob/main/WHATS_NEW.md) for release details.

## Manage Foundry resources

Sign in to Azure and set a Foundry project to manage cloud resources from Visual Studio Code. You can:

- Browse Foundry projects and the resources available to your account.
- Discover and deploy models from the Foundry model catalog.
- View model endpoints and authentication information.
- Create and version prompt agents, and deploy and test hosted agents.
- Inspect and test existing declarative workflows before migration.
- Browse tools and knowledge sources used by your agents.
- Open evaluations, conversations, logs, and traces during development.

For broader resource administration, use the [Foundry portal](https://ai.azure.com/). To automate a workflow in application code, use the [Microsoft Foundry SDKs](../05.4-sdks-and-apis/01-sdk-overview.md).

## Related content

- [Install Foundry Toolkit for Visual Studio Code](02-install-foundry-toolkit-visual-studio-code.md)
- [Set up a Foundry project in Visual Studio Code](03-set-up-foundry-project-visual-studio-code.md)
- [Report a Foundry Toolkit issue](https://aka.ms/AIToolkit/feedback)
- [Create an agent with Microsoft Foundry Toolkit](04-create-agent-visual-studio-code.md)
