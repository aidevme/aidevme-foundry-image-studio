# Use and migrate declarative agent workflows with Microsoft Foundry Toolkit

| Field | Value |
| --- | --- |
| **Document Title** | Use and migrate declarative agent workflows with Microsoft Foundry Toolkit |
| **Document Location** | `docs/research-docs/azure-foundry/05-developer-tools-and-integrations/05.2-foundry-toolkit-for-visual-studio-code/07-vs-code-agents-workflow-low-code.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Use and migrate declarative agent workflows with Microsoft Foundry Toolkit". Edit and test existing declarative workflows in Microsoft Foundry Toolkit for Visual Studio Code, then migrate them to Agent Framework code. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/develop/vs-code-agents-workflow-low-code). Article date: 2026-09-10. Page updated: 2026-09-17. Retrieved: 2026-09-29. Navigation: Developer tools and integrations > Foundry Toolkit for Visual Studio Code > Use and migrate declarative agent workflows.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Use Microsoft Foundry Toolkit for Visual Studio Code to work with existing declarative workflows and prepare them for migration. You can test a saved workflow, edit its exported YAML, and use GitHub Copilot to help convert the definition to Microsoft Agent Framework code.

> **Important**
>
> Declarative workflows in Microsoft Foundry are in preview and retire on December 1, 2026. Use Microsoft Agent Framework for new workflow development. This retirement doesn't affect code-based orchestration in hosted agents. See the [workflow migration guide](../../07-agents/07.1-concepts/06-workflow.md#migration-guide) for supported migration paths.

## Prerequisites

- [Install Microsoft Foundry Toolkit for Visual Studio Code](02-install-foundry-toolkit-visual-studio-code.md).
- [Select the Foundry project](03-set-up-foundry-project-visual-studio-code.md) that contains your existing declarative workflow.
- Access to read and run that workflow and its referenced agents. To save changes, you also need permission to create an agent version in the project. See [Foundry role-based access control](../../13-manage-and-operate/13.3-security-and-governance/02-rbac-foundry.md).
- For code conversion, access to [GitHub Copilot in Visual Studio Code](https://code.visualstudio.com/docs/copilot/overview).

## View a declarative agent workflow

Find the workflow in your project's consolidated agent list.

1. In the **Foundry Toolkit** view, under **My Resources**, confirm the selected Foundry project.
2. Select **Agents**, and then select the **Workflow** tab.
3. Select the workflow name to open its playground.
4. Use the version selector to choose the saved version you want to inspect.

The playground shows the workflow graph and a conversation area. The graph is read-only. Use the exported YAML or the Foundry portal to edit the definition.

## Edit an existing workflow definition

Export the definition before you edit or migrate it. Keep a copy of the original YAML so that you can compare it with your changes.

1. Open the existing workflow in the [Foundry portal](https://ai.azure.com/).
2. In the workflow designer, switch to the **YAML** view and copy or export the definition. For details, see [Export your workflow definition](../../07-agents/07.1-concepts/06-workflow.md#before-you-migrate-export-your-workflow-definition).
3. Save the definition in your local workspace with a name ending in `.workflow.yaml`, such as `support.workflow.yaml`.
4. Open the file in Visual Studio Code and edit the YAML.
5. Save the file. Local file changes don't update the workflow in Foundry.

### Save a new version of the existing workflow

Before retirement, you can deploy an edited definition to the same workflow. Confirm the project and workflow name to avoid creating a different resource.

1. Confirm that the original workflow's project is selected in Foundry Toolkit.
2. With the `.workflow.yaml` file open, select **Deploy** in the editor toolbar.
3. In **Enter workflow name**, enter the name of the existing workflow.
4. Wait for the deployment success notification.
5. Reopen the workflow from **Agents** > **Workflow** and select the new version.

Deploying with an existing workflow name creates a new version. A different name creates a separate workflow; don't use this path to start new workflow development.

## Test a workflow in the playground

Test the saved version that you plan to maintain or migrate. Use the same requests later to compare the migrated implementation.

1. Open the workflow's playground and select the required version.
2. On the **Playground** tab, select **New** to start a new playground session.
3. Enter a request that exercises the workflow and send it.
4. Review the response and the execution graph. Confirm that the expected agents, branches, and steps run.
5. Repeat with requests that exercise different branches, missing inputs, and any approval steps in your workflow.

The playground runs the saved Foundry workflow. It doesn't run unsaved changes in your local YAML file or the code that Copilot generates.

## Convert a YAML workflow to Agent Framework code

Use the playground's code-generation action to ask GitHub Copilot to convert the selected workflow definition. Generated code is a starting point that you must review and test.

1. In the workflow playground, select the version to migrate.
2. Select **Generate Code**.
3. Choose **Python** or **C#**.
4. Review the conversion request in Copilot Chat and follow its prompts to generate the code.
5. Review the generated project, dependencies, model connections, tools, and authentication configuration.
6. Compare its orchestration with the exported YAML. Check branching, variables, agent calls, and human approval steps.
7. Run the code locally and test it with the requests you used for the original workflow. Use Agent Inspector to inspect execution.
8. When the code behaves as required, follow [Create hosted agents](06-vs-code-agents-workflow-pro-code.md) to prepare a supported hosted-agent project, deploy it, and test the deployed version.

Code conversion doesn't deploy a hosted agent or guarantee equivalent behavior. Keep the original definition until you complete migration and confirm that dependent applications use the replacement.

For other migration choices, including Agent Framework declarative YAML, Azure Logic Apps, and direct A2A connections, see the [workflow migration guide](../../07-agents/07.1-concepts/06-workflow.md#migration-guide).

## Related content

Use these guides to choose and complete your migration:

- [Create an agent with Microsoft Foundry Toolkit](04-create-agent-visual-studio-code.md)
- [Microsoft Agent Framework workflows](https://learn.microsoft.com/en-us/agent-framework/workflows/)
- [Hosted agent concepts](../../07-agents/07.3-hosted-agents/01-hosted-agents.md)
