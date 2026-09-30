# Upgrade from Azure OpenAI to Microsoft Foundry

| Field | Value |
| --- | --- |
| **Document Title** | Upgrade from Azure OpenAI to Microsoft Foundry |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.1-set-up-and-configure/05-upgrade-azure-openai.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Upgrade from Azure OpenAI to Microsoft Foundry". Upgrade your Azure OpenAI resource to Microsoft Foundry to access advanced capabilities including a broader model catalog, agents service, and evaluation tools. Learn how to upgrade seamlessly. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/upgrade-azure-openai). Article date: 2026-08-19. Page updated: 2026-08-20. Retrieved: 2026-09-29. Navigation: Manage and operate > Set up and configure > Manage Foundry resources > Upgrade from Azure OpenAI Service.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

If Microsoft scheduled your resource for automatic upgrade, see [Manage automatic upgrades from Azure OpenAI to Microsoft Foundry](https://learn.microsoft.com/en-us/azure/foundry/how-to/upgrade-azure-openai-auto).

The Microsoft Foundry resource type provides a superset of capabilities compared to the Azure OpenAI resource type. It gives you access to a broader model catalog, agents service, and evaluation capabilities.

You can upgrade your Azure OpenAI resource to a Foundry resource. You keep your existing Azure OpenAI API endpoint, state of work, and security configurations, and don't need to create a new Foundry resource.

## Benefits of upgrading

When you upgrade your Azure OpenAI resource to a Foundry resource, you get access to the following capabilities.

| Feature | Azure OpenAI | Foundry |
| --- | --- | --- |
| Foundry Models sold by Azure | Azure OpenAI only | Azure OpenAI, Black Forest Labs, DeepSeek, Meta, xAI, Mistral, Microsoft |
| Partner and community models sold through Marketplace - Stability, Cohere, and others |   | ✅ |
| Azure OpenAI API - batch, stored completions, fine-tuning, evaluation, and more | ✅ | ✅ |
| Agent service |   | ✅ |
| Azure Foundry API |   | ✅ |
| Foundry Tools - Speech, Vision, Language, Content Understanding |   | ✅ |

Your existing resource configurations and state stay the same, including:

- Resource name
- Azure resource tags
- Network configurations
- Access and identity configurations
- API endpoint and API key
- Custom Domain Name
- Existing state including fine-tuning jobs, batch, stored completions, and more

## Limitations

- Foundry model and feature availability [differs by region](../../06-models/06.2-quota-limits-and-region-availability/08-region-support.md). For example, Agent service is [available](../../07-agents/07.6-reference/01-limits-quotas-regions.md) in select regions compared to Azure OpenAI service.
- Azure OpenAI resources using **customer-managed keys** for encryption are available for upgrade by request only. [Fill out the request form here](https://forms.office.com/r/sKGZJ0YhDd).
- The Foundry resource type doesn't support configuring Weights & Biases.
- Private network setups require [additional DNS zone configurations](#private-network-configuration) next to your existing Azure OpenAI DNS Zone before all Foundry capabilities can be used.
- Resources with existing private endpoints can't be upgraded from Azure OpenAI to Foundry through the Foundry portal or the Azure portal. Delete the private endpoints before you upgrade, and recreate them afterward. Alternatively, manage the upgrade using Azure Bicep or Terraform.

## Support level post-upgrade

The upgrade converts your Azure OpenAI resource type to Foundry resource type. Both services are generally available and supported before and after the upgrade. Upgrading your Azure OpenAI resource is an opt-in capability. If needed, you can [roll back to your previous setup](#roll-back-to-azure-openai).

## How to upgrade

### Prerequisites for upgrade

Before you upgrade your Azure OpenAI resource to a Foundry resource, ensure you have:

- **Azure role requirements**: You must have one of the following Azure roles on your subscription or resource group:
  - **Owner** role on the subscription or resource group for resource management and configuration and assign roles to the new project.

  You need this role to enable managed identity and perform the upgrade operation.
- **Managed identity**: You must enable managed identity on your Azure OpenAI resource. If it's not already enabled, you can enable it through the [Azure portal](https://portal.azure.com/). Go to your resource, select **Identity** from the left menu, and toggle **System assigned** to **On**.

### Upgrade your resource

You can complete the upgrade through the Foundry (classic) portal, Azure portal, or by using Azure Bicep or Resource Manager templates (recommended for resource configurations with custom security settings).

**[Foundry portal]**

1. Sign in to [Microsoft Foundry](https://ai.azure.com/?cid=learnDocs). Make sure the **New Foundry** toggle is off. These steps refer to **Foundry (classic)**.![](https://learn.microsoft.com/en-us/azure/foundry/media/version-banner/classic-foundry.png)
2. Select your Azure OpenAI resource.
3. On the overview page, find the banner **Want to try the latest industry models and Agents?** and select **Get started**.
4. Enter a name for your first project. A project is a folder to organize your work in Foundry. Your first 'default' project is backward compatible with your previous work in Azure OpenAI.
5. Confirm to start the upgrade.

**Success**: After the upgrade completes, you're taken to your new Foundry project. Your resource name, API endpoint, and existing configurations remain unchanged. You now have access to the broader model catalog, agent service, and Foundry Tools.

You can use this project in either the Foundry (classic) or the Foundry (new) portal. To switch to the new portal, turn **New Foundry** toggle to **on**.

**[Azure portal]**

1. Sign in to [Azure portal](https://portal.azure.com/).
2. Select your Azure OpenAI resource.
3. On the overview page, locate the banner "Want to try the latest industry models and Agents?" and select **Get Started**.
4. Confirm to start the upgrade.

[![Screenshot shows how to upgrade in Azure portal.](https://learn.microsoft.com/en-us/azure/foundry/media/upgrade-azure-openai/azure-portal-upgrade.png)](https://learn.microsoft.com/en-us/azure/foundry/media/upgrade-azure-openai/azure-portal-upgrade.png#lightbox)

**Success**: The upgrade completes, and you're returned to your resource overview page. Your resource type is now **Foundry** (previously **Azure OpenAI**). All existing configurations, endpoints, and API keys remain the same.

**[Azure Bicep]**

Starting with your existing Azure OpenAI template configuration, set the following properties:

- Update `kind` from value `OpenAI` to `AIServices`.
- Set `allowProjectManagement` to `true`.
- Configure managed identity.

Sample configuration:

```bicep
resource foundry 'Microsoft.CognitiveServices/accounts@2025-06-01' = {
    name: foundryName // Your existing resource name
    location: location
    identity: {
        type: 'SystemAssigned'
    }
    sku: {
        name: 'S0'
    }
    kind: 'AIServices' // Update from 'OpenAI'
    properties: {
        // required to work in Foundry
        allowProjectManagement: true 

        // Needed for capabilities that require EntraID authentication
        customSubDomainName: foundryName
        disableLocalAuth: true
    }
}
```

Run the template by using [Azure Bicep CLI](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-cli) or your [Visual Studio Code extension for Bicep](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) as a patch operation on your current resource.

**References**: [`Microsoft.CognitiveServices/accounts`](https://learn.microsoft.com/en-us/azure/templates/microsoft.cognitiveservices/accounts), [Bicep CLI documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-cli).

**Success**: The patch operation completes with no errors. Your resource's `kind` property changes from `OpenAI` to `AIServices`, and `allowProjectManagement` is set to `true`. Your existing endpoint, API keys, and configurations are preserved.

**[Terraform]**

You can upgrade your Azure OpenAI resource by using either the AzAPI or AzureRM Terraform providers.

> **Important**
>
> When you use the [AzureRM provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account.html), use version 4.56.0 or later for a non-destructive resource update between the `OpenAI` and `AIServices` resource kinds.

Start from your existing Azure OpenAI configuration and update the following properties:

- Update kind from value `OpenAI` to `AIServices`.
- Set `allowProjectManagement: True`.
- Configure managed identity.

Finally, run `terraform apply` to complete the upgrade.

## Portal navigation differences after upgrading

After upgrading from Azure OpenAI to Foundry, you see updates to the portal's navigation and feature access:

- **Updated left-side navigation**

  The portal reorganizes the left-hand menu to consolidate playgrounds, including Assistants, under a single landing page. This change streamlines access to experimentation environments. You find access to new features including Agent Service and Content Understanding.

  An *Azure OpenAI section* provides access to features that you exclusively use with Azure OpenAI models.

  > **Note**
  >
  > The portal doesn't show all Foundry tools by default in the left side navigation. The navigation is customizable. Select *... More* to locate them.
- **Your default view is now a project**

  Projects are folders to organize your work in Foundry. They're also a container for access management and data isolation. You can create multiple projects as part of your Foundry resource, so you can separate your work between use cases that you're working on. Your first project after upgrade has access to your previous work in Azure OpenAI.

  You can also use this project in the Foundry (new) portal.
- **Broader set of models in model catalog**

  Your model catalog now includes more models that you can directly deploy by using your Foundry resource.
- **Developer endpoints**

  Your project overview page includes your previous Azure OpenAI endpoint, and a new Foundry endpoint. Foundry API and SDK grant access to the broader set of models and features including agent service.

## Understanding pricing

When you upgrade to Foundry, you don't pay more for existing Azure OpenAI functionality. Your current usage patterns and costs stay the same. However, Foundry provides access to more features, such as expanded model catalogs, agent services, and evaluation tools. These features might have their own pricing structures depending on the models and services you use.

To estimate the costs of new features available in Foundry, use the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/).

## Considerations for RBAC and policy during upgrade

Microsoft Foundry provides a broader set of models and capabilities than an Azure OpenAI resource. If your organization relies on Azure RBAC or Azure Policy, these controls continue to function after upgrade because both resource types use the same management APIs.

However, **IT administrators should review any wildcard role assignments or policies that don't restrict access to a specific resource kind.** These broad definitions might unintentionally grant users access to Foundry-only features immediately after upgrade.

If you plan to roll out non-OpenAI features gradually, update your RBAC role assignments, Azure Policy definitions, and any custom roles before you perform the upgrade. For details on permissions, see [Role-based access control](../13.3-security-and-governance/02-rbac-foundry.md).

Post-upgrade behavior depends on your existing governance setup:

| Governance control | Access before upgrade | Access after upgrade |
| --- | --- | --- |
| [Cognitive Services User (RBAC role)](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/ai-machine-learning#cognitive-services-user) | OpenAI features | All Foundry features |
| [Cognitive Services OpenAI User (RBAC role)](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/ai-machine-learning#cognitive-services-openai-user) | OpenAI features | OpenAI features |
| [Custom RBAC roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles) | Only features you defined | Only features you defined |
| Model access (no policy applied) | OpenAI models | Any Foundry model |
| [Model access (policy enforced)](../13.3-security-and-governance/14-model-deployment-policy.md) | Only OpenAI models allowed by policy | Only models you allow through policy |

## Private network configuration

Foundry resource is a superset of Azure OpenAI resource. It exposes its capabilities over three FQDNs:

- {custom-domain}.openai.azure.com
- {custom-domain}.services.ai.azure.com
- {custom-domain}.cognitiveservices.azure.com

Your DNS configuration must resolve each of these FQDNs to use the full set of Foundry capabilities.

- If you're using Azure DNS, create an [Azure DNS Zone](https://learn.microsoft.com/en-us/azure/dns/dns-zones-records) for each of the above domains.
- If you're using a custom DNS implementation, implement a conditional forwarder for each of the above configurations.

After you configure DNS, update or alternatively [delete and re-create a private link endpoint](../13.3-security-and-governance/07-configure-private-link.md) on your resource. Your private link endpoint creates an IP address in your Azure Virtual Network to map to each endpoint.

> **Important**
>
> When upgrading to Foundry, you must recreate your private link endpoint for the "services.ai.azure.com" and "{custom-domain}.cognitiveservices.azure.com" IP configurations to be created.

## Roll back to Azure OpenAI

If you run into any problems, you can roll back. To roll back, first delete any of the following configurations:

- Projects
- Connections
- Non-Azure OpenAI model deployments

Then, use either the Foundry (classic) portal, Azure portal, or an ARM template to roll back:

**[Foundry portal]**

1. Select the project in the Foundry (classic) portal.
2. Select **Management Center** in the lower left of your screen.
3. On your resource overview page, find the rollback option.
4. Select **Rollback**.

[![Screenshot shows the rollback option in the Foundry portal.](https://learn.microsoft.com/en-us/azure/foundry/media/upgrade-azure-openai/rollback.png)](https://learn.microsoft.com/en-us/azure/foundry/media/upgrade-azure-openai/rollback.png#lightbox)

**[Azure portal]**

1. Sign in to [Azure portal](https://portal.azure.com/).
2. Select your Foundry resource.
3. On the overview page, select **rollback upgrade**.

[![Screenshot shows how to roll back in Azure portal.](https://learn.microsoft.com/en-us/azure/foundry/media/upgrade-azure-openai/rollback-azure-portal.png)](https://learn.microsoft.com/en-us/azure/foundry/media/upgrade-azure-openai/rollback-azure-portal.png#lightbox)

**[Azure Bicep]**

To roll back, convert your template configuration back to `OpenAI` as kind.

```bicep
resource foundry 'Microsoft.CognitiveServices/accounts@2025-06-01' = {
name: foundryName
location: location
identity: {
    type: 'SystemAssigned'
}
sku: {
    name: 'S0'
}
kind: 'OpenAI'
properties: {

    // Defines developer API endpoint subdomain
    customSubDomainName: foundryName
    disableLocalAuth: true

    // Required, or the deployment fails with "PublicNetworkAccess is required for this resource."
    publicNetworkAccess: 'Enabled'
}
}
```

Run the template by using [Azure Bicep CLI](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-cli) or your [Visual Studio Code extension for Bicep](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) as a patch operation on your current resource.

**References**: [`Microsoft.CognitiveServices/accounts`](https://learn.microsoft.com/en-us/azure/templates/microsoft.cognitiveservices/accounts), [Bicep CLI documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-cli).

**[Terraform]**

To roll back to Azure OpenAI, use either the AzAPI or AzureRM Terraform providers.

> **Note**
>
> When you use the [AzureRM provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account.html), use version 4.56.0 or later for a non-destructive resource update between the `AIServices` and `OpenAI` resource kinds.

- Delete any non-OpenAI model deployments.
- Delete Foundry-specific sub-resources, including projects and connections.
- In your `azurerm_cognitive_account` resource, update kind from value 'AIServices' to 'OpenAI' and set `allowProjectManagement` to False.

## Troubleshooting common issues

Azure resource limits and organizational configurations might require extra steps to complete the upgrade. The following table outlines some of the most common issues along with recommended solutions to help troubleshooting.

| Issue | Solution or mitigation |
| --- | --- |
| User principal lacks account or write permissions | Get a privileged Azure RBAC role to manage top-level Azure resource. For example, **Owner**, **Contributor**, or **Azure AI Administrator**. |
| Managed identity isn't enabled on the Azure OpenAI resource | Configure managed identity on your resource by using templates or Azure portal. |
| No permissions to create agents, while you're the owner or contributor on the resource. | An EntraID data plane role is required for development actions including agents. Examples include **Foundry User**, **Foundry Project Manager**, or **Foundry Owner** roles. **Owner** and **Contributor** roles only grant access to management operations in Azure such as managing deployments. |
| An Azure Policy conflict occurred. | Your organization might put constraints on resource configurations. Inspect the details of the policy violation error. Then upgrade your resource via template options for further customization. For example, network configurations for Agents can only be configured via template options such as Azure Bicep. |
| Exceeded number of Azure OpenAI instances of 30 per subscription per region when rolling back. | Delete an Azure OpenAI resource or upgrade it to the Foundry. Then retry rolling back your current resource. |
| Exceeded number of AIServices instances of 100 per subscription per region. | Delete a Foundry resource you might not use in this subscription. Then retry upgrading your current resource. |
| I can't access my resource over the private network | See [private networking configuration](#private-network-configuration) for the required steps. |

> **Important**
>
> The Foundry RBAC roles were recently renamed. **Foundry User**, **Foundry Owner**, **Foundry Account Owner**, and **Foundry Project Manager** were previously named Azure AI User, Azure AI Owner, Azure AI Account Owner, and Azure AI Project Manager. You might still see the previous names in some places while the rename rolls out. The role IDs and core permissions are unchanged by the rename.

## How to check if a resource was upgraded

You can check the following Azure resource property to see if a resource was previously upgraded to Foundry.

```json
{
  "properties": {
    // Read only property present if your resource was upgraded:
    "previousKind": "OpenAI"
  }
}
```

If you're not sure who upgraded your resource to Foundry, you can [view the activity log in the Azure portal](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log-insights#view-the-activity-log) to find out when the upgrade operation took place and which user performed it:

1. Use Azure Activity Logs (under "Monitoring") to see if an upgrade operation was performed.
2. Filter by "Write" operations on the Cognitive Services account.
3. Look for operations listed as `Microsoft.CognitiveServices/accounts/write`.

## Related content

- [Bicep samples for Foundry common infrastructure configurations](https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-bicep)
