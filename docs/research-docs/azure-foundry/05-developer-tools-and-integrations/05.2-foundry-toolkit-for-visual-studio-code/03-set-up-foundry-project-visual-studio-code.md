# Set up a Microsoft Foundry project in Visual Studio Code

| Field | Value |
| --- | --- |
| **Document Title** | Set up a Microsoft Foundry project in Visual Studio Code |
| **Document Location** | `docs/research-docs/azure-foundry/05-developer-tools-and-integrations/05.2-foundry-toolkit-for-visual-studio-code/03-set-up-foundry-project-visual-studio-code.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Set up a Microsoft Foundry project in Visual Studio Code". Sign in to Azure, select an existing Microsoft Foundry project, or create a project with Foundry Toolkit for Visual Studio Code. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/develop/set-up-foundry-project-visual-studio-code). Article date: 2026-08-20. Page updated: 2026-08-25. Retrieved: 2026-09-29. Navigation: Developer tools and integrations > Foundry Toolkit for Visual Studio Code > Set up a Foundry project.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Sign in to Azure, and then select an existing Foundry project or create one with Microsoft Foundry Toolkit for Visual Studio Code. Foundry Toolkit uses the project you select as its default project for cloud models, agents, tools, and evaluations.

## Prerequisites

- [Install Microsoft Foundry Toolkit for Visual Studio Code](02-install-foundry-toolkit-visual-studio-code.md).
- An [Azure subscription](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- To select an existing project, access to that project. For more information, see [Role-based access control for Microsoft Foundry](../../13-manage-and-operate/13.3-security-and-governance/02-rbac-foundry.md).
- To create a project, meet the [prerequisites to create a Foundry project](../../13-manage-and-operate/13.1-set-up-and-configure/07-create-projects.md#prerequisites).

## Sign in to Azure

Foundry Toolkit uses the account, tenant, and subscriptions available through the Azure Resources extension.

1. In the Activity Bar, select **Azure**.
2. In the **Azure Resources** view, select **Sign in to Azure**.
3. Complete the sign-in flow.
4. In **Accounts & Tenants**, confirm that the account and tenant for your Foundry resources are selected.
5. In **Resources**, confirm that the target subscription is visible.

## Select an existing project

Set an accessible project as the default project for Foundry Toolkit.

1. In the Activity Bar, select **Foundry Toolkit**.
2. Under **My Resources**, select **Set Foundry Project**.
3. Select **Switch project**.

   [![Screenshot of Foundry Toolkit showing Set Foundry Project and the choices to switch projects or create a project.](https://learn.microsoft.com/en-us/azure/foundry/media/how-to/get-started-projects-vs-code/set-foundry-project.png)](https://learn.microsoft.com/en-us/azure/foundry/media/how-to/get-started-projects-vs-code/set-foundry-project.png#lightbox)
4. Select the Azure subscription that contains the project.
5. Select the Foundry project.
6. Under **My Resources**, confirm that the project resources appear.

The selected project remains the default until you select another project, clear the default project, sign out, or lose access to the project.

## Create a project

Use Foundry Toolkit to create a Foundry account and project with basic default settings. For customized networking, security, naming, or Azure Policy requirements, use the [Foundry portal](https://ai.azure.com/) or an [infrastructure template](../../13-manage-and-operate/13.1-set-up-and-configure/03-create-resource-template.md).

1. In the Activity Bar, select **Foundry Toolkit**.
2. Under **My Resources**, select **Set Foundry Project**.
3. Select **Create project**.
4. Select your Azure subscription.
5. Select an existing resource group, or select **Create new resource group**.
6. If you create a resource group, enter the resource group name, and then select a location.
7. Enter a name for the Foundry project.
8. Monitor the notification for project creation progress.

   [![Screenshot of a Foundry Toolkit notification showing Foundry project creation progress.](https://learn.microsoft.com/en-us/azure/foundry/media/how-to/get-started-projects-vs-code/project-creation-progress.png)](https://learn.microsoft.com/en-us/azure/foundry/media/how-to/get-started-projects-vs-code/project-creation-progress.png#lightbox)
9. Wait for the notification that the project deployed successfully.
10. Under **My Resources**, confirm that the new project resources appear.

Foundry Toolkit creates a Foundry account named from the project, creates the project under that account, and sets the project as the Toolkit default.

## Switch the default project

Change the cloud project used by Foundry Toolkit without changing your Azure account.

1. Under **My Resources**, locate the current default project.
2. Select the gear icon next to the project.
3. Select **Switch Default Project**.

   [![Screenshot of the Foundry Toolkit project actions menu with Switch Default Project selected.](https://learn.microsoft.com/en-us/azure/foundry/media/how-to/get-started-projects-vs-code/switch-default-project.png)](https://learn.microsoft.com/en-us/azure/foundry/media/how-to/get-started-projects-vs-code/switch-default-project.png#lightbox)
4. Select **Switch project**.
5. Select the subscription and another accessible project.
6. Under **My Resources**, confirm that the selected project resources appear.

To work without a cloud project, run **Foundry Toolkit: Clear Default Project**.

## Clean up resources

Selecting an existing project doesn't create Azure resources. If you created a project in this article, its resources can incur charges.

- If you used a shared resource group, don't delete the resource group. Follow [Delete projects](../../13-manage-and-operate/13.1-set-up-and-configure/07-create-projects.md#delete-projects) to remove the project. Delete the Foundry account only if Toolkit created it for this procedure and it contains no other projects or resources.
- If you created a dedicated resource group and no longer need anything in it, open the [Azure portal](https://portal.azure.com/), select the resource group, and select **Delete resource group**.

> **Warning**
>
> Deleting a resource group permanently deletes every resource in it. Review the resource list before you confirm deletion.

## Related content

- [Microsoft Foundry Toolkit for Visual Studio Code overview](01-get-started-projects-visual-studio-code.md)
- [Create a project for Microsoft Foundry](../../13-manage-and-operate/13.1-set-up-and-configure/07-create-projects.md)
- [Role-based access control for Microsoft Foundry](../../13-manage-and-operate/13.3-security-and-governance/02-rbac-foundry.md)
