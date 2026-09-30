# Create an agent with Microsoft Foundry Toolkit for Visual Studio Code

| Field | Value |
| --- | --- |
| **Document Title** | Create an agent with Microsoft Foundry Toolkit for Visual Studio Code |
| **Document Location** | `docs/research-docs/azure-foundry/05-developer-tools-and-integrations/05.2-foundry-toolkit-for-visual-studio-code/04-create-agent-visual-studio-code.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Create an agent with Microsoft Foundry Toolkit for Visual Studio Code". Choose a prompt or hosted agent and start with Agent Builder, samples, or GitHub Copilot in Microsoft Foundry Toolkit for Visual Studio Code. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/develop/create-agent-visual-studio-code). Article date: 2026-09-10. Page updated: 2026-09-17. Retrieved: 2026-09-29. Navigation: Developer tools and integrations > Foundry Toolkit for Visual Studio Code > Create an agent.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Use Microsoft Foundry Toolkit for Visual Studio Code to configure a prompt agent or develop a code-based hosted agent. Choose a creation route based on whether instructions and supported tools meet your needs, or you need custom runtime logic.

## Prerequisites

- [Install Microsoft Foundry Toolkit for Visual Studio Code](02-install-foundry-toolkit-visual-studio-code.md).
- For agents that use Foundry resources, [set up a Foundry project](03-set-up-foundry-project-visual-studio-code.md). Follow the guide for your chosen route for model, permission, and runtime requirements.
- For Copilot-assisted coding, access to [GitHub Copilot in Visual Studio Code](https://code.visualstudio.com/docs/copilot/overview).

## Choose an agent type

Foundry supports [prompt agents and hosted agents](../../07-agents/07.1-concepts/01-development-lifecycle.md#agent-types-in-microsoft-foundry). Both agent types can use tools and integrate into applications. Prompt agents aren't limited to prototypes.

| Compare | Prompt agent | Hosted agent |
| --- | --- | --- |
| Define behavior | Configure a model, instructions, and supported tools. | Implement custom logic with a framework or your own code. |
| Use it for | Tasks that instructions and supported tools can handle, such as answering questions or summarizing documents. | Custom orchestration, dependencies, or runtime behavior, such as a multi-agent workflow. |
| What you maintain | The agent configuration and saved versions. | The agent code, dependencies, packaging, and deployment configuration. |
| Where to start | Agent Builder. | Hosted-agent samples or Copilot-assisted coding. |

Start with a prompt agent when its configuration options meet your needs. Choose a hosted agent when you need more control over execution. For details, see [When to use hosted agents](../../07-agents/07.3-hosted-agents/01-hosted-agents.md#when-to-use-hosted-agents).

## Open Create Agent

Open the creation page to choose how to build your agent.

1. In the Activity Bar, select **Foundry Toolkit**.
2. Under **Developer Tools**, expand **Build**, and select **Create Agent**.

   [![Screenshot of Create Agent with options to code from samples, code with Copilot, or build an agent in Agent Builder.](https://learn.microsoft.com/en-us/azure/foundry/media/how-to/create-agent-vs-code/create-agent.png)](https://learn.microsoft.com/en-us/azure/foundry/media/how-to/create-agent-vs-code/create-agent.png#lightbox)

If Developer Tools uses **Group by Resource**, find **Create Agent** under **Agent Dev Tools** instead of **Build**.

## Choose a creation route

Select the route that matches your agent type, and then follow its guide to configure, test, and save or deploy the agent.

| Route | Action in Create Agent | Next guide |
| --- | --- | --- |
| Agent Builder | Select **Build an agent** to configure a prompt agent without a hosted-agent code project. | [Create a prompt agent](05-create-prompt-agent-visual-studio-code.md). |
| Hosted-agent samples | Under **Code an agent from samples**, select a framework or **Browse all samples**. Choose a sample for your scenario. | For code-based orchestration, [create hosted agents](06-vs-code-agents-workflow-pro-code.md). For other scenarios, follow the selected sample's generated `README.md`. |
| Copilot-assisted coding | Select **Code an agent with Copilot** to develop agent code with GitHub Copilot and Foundry skills. | [Use the Microsoft Foundry Skill in coding agents](../../04-get-started/04.1-what-do-you-want-to-build/05-use-microsoft-foundry-skill.md). Review generated code and test it before deployment. |

Agent Builder also supports locally stored prompts. Their storage, tools, and evaluation options differ from Foundry prompt agents. See [Work with local prompts](05-create-prompt-agent-visual-studio-code.md#work-with-local-prompts).

## Choose how to orchestrate or schedule work

For new code-based workflows, use Microsoft Agent Framework through the sample or Copilot route. To invoke an existing agent on a trigger or schedule, see [Routines in Foundry Agent Service (preview)](../../07-agents/07.1-concepts/05-routines.md).

> **Important**
>
> Declarative workflows in Microsoft Foundry are in preview and retire on December 1, 2026. This retirement doesn't affect code-based orchestration in hosted agents. To work with an existing declarative workflow, see [Use and migrate declarative agent workflows](07-vs-code-agents-workflow-low-code.md).

## Related content

Use these guides as you develop and integrate your agent:

- [Microsoft Foundry Toolkit for Visual Studio Code overview](01-get-started-projects-visual-studio-code.md)
- [Agent development lifecycle](../../07-agents/07.1-concepts/01-development-lifecycle.md)
- [Publish an agent application](../../07-agents/07.2-prompt-agents/04-agent-applications.md)
