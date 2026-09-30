# Quickstart: Deploy a Microsoft Foundry resource by using a Bicep file

| Field | Value |
| --- | --- |
| **Document Title** | Quickstart: Deploy a Microsoft Foundry resource by using a Bicep file |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.1-set-up-and-configure/03-create-resource-template.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Quickstart: Deploy a Microsoft Foundry resource by using a Bicep file". Learn how to use a Bicep file (template) to create a Microsoft Foundry resource in your Azure subscription. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/create-resource-template). Article date: 2026-07-28. Page updated: 2026-09-25. Retrieved: 2026-09-29. Navigation: Manage and operate > Set up and configure > Manage Foundry resources > Create resources using Bicep template.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

In this quickstart, you deploy a [Microsoft Foundry](https://ai.azure.com/?cid=learnDocs) resource and project by using a [Microsoft Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview) template. Bicep helps you create related resources in one coordinated deployment and reuse the same configuration across environments.

If you already configured a Foundry resource in the Azure portal, you can [export that configuration as a Bicep file](#export-an-existing-resource-to-a-bicep-file) instead of authoring a template from scratch.

> **Tip**
>
> For production-ready Bicep templates that cover common Foundry deployment scenarios, see the [infrastructure-setup-bicep](https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-bicep) folder in the Foundry samples repository. Clone the repository and customize the templates instead of starting from scratch.

## Prerequisites

An Azure account with an active subscription. If you don't have one, create a [free Azure account, which includes a free trial subscription](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

- Access to a role that allows you to complete role assignments, such as **Owner**. For more information about permissions, see [Role-based access control for Microsoft Foundry](../13.3-security-and-governance/02-rbac-foundry.md#permissions-for-each-built-in-role).
- [Install the Bicep CLI](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install).

Get the sample files:

**[Azure CLI]**

```azurecli
git clone https://github.com/microsoft-foundry/foundry-samples
cd foundry-samples/infrastructure/infrastructure-setup-bicep/00-basic
```

**[Azure PowerShell]**

```azurepowershell
git clone https://github.com/microsoft-foundry/foundry-samples
cd foundry-samples/infrastructure/infrastructure-setup-bicep/00-basic
```

## Deploy the Bicep file

Deploy the Bicep file by using either Azure CLI or Azure PowerShell:

**[Azure CLI]**

```azurecli
az group create --name exampleRG --location eastus
az deployment group create --resource-group exampleRG --template-file main.bicep --parameters aiFoundryName=myai aiProjectName=myai-proj 
```

Reference: [az group create](https://learn.microsoft.com/en-us/cli/azure/group#az-group-create), [az deployment group create](https://learn.microsoft.com/en-us/cli/azure/deployment/group#az-deployment-group-create).

**[Azure PowerShell]**

```azurepowershell
New-AzResourceGroup -Name exampleRG -Location eastus
New-AzResourceGroupDeployment -ResourceGroupName exampleRG -TemplateFile main.bicep -aiFoundryName myai -aiProjectName myai-proj
```

Reference: [New-AzResourceGroup](https://learn.microsoft.com/en-us/powershell/module/az.resources/new-azresourcegroup), [New-AzResourceGroupDeployment](https://learn.microsoft.com/en-us/powershell/module/az.resources/new-azresourcegroupdeployment).

> **Note**
>
> Replace `myai` with the name of your resource. `exampleRG` is the name of the resource group, and `eastus` is the Azure region where resources are deployed.

When the deployment finishes, you see a message indicating the deployment succeeded (output displays: `"provisioningState": "Succeeded"`). This confirms that your Foundry resource and project have been created.

## Export an existing resource to a Bicep file

If you already configured a Foundry resource in the Azure portal, you can export that configuration as a Bicep file. The exported file captures your current resource settings, including network rules, identity configuration, and project associations. Use it as a starting point for repeatable deployments across environments.

1. In the [Azure portal](https://portal.azure.com/), go to your Foundry resource.
2. In the left menu, expand **Automation**, and then select **Export template**.

   [![Screenshot of a Foundry resource left menu with the Automation group expanded and Export template selected.](https://learn.microsoft.com/en-us/azure/foundry/how-to/media/export-template/foundry-resource-export-template-menu.png)](https://learn.microsoft.com/en-us/azure/foundry/how-to/media/export-template/foundry-resource-export-template-menu.png#lightbox)
3. Select the **Bicep** tab to view the generated Bicep code.

   [![Screenshot of the Foundry Export template page with the Bicep tab selected, showing the Download and Copy buttons above the generated Bicep code.](https://learn.microsoft.com/en-us/azure/foundry/how-to/media/export-template/foundry-export-template-bicep.png)](https://learn.microsoft.com/en-us/azure/foundry/how-to/media/export-template/foundry-export-template-bicep.png#lightbox)
4. Select **Download** to save the file locally, or **Copy** to copy the code to your clipboard.

> **Note**
>
> The export might complete with warnings if some resource types don't support full export. Review the output and fill in any missing properties manually.

### Customize the exported template

The exported Bicep file contains hardcoded values specific to your subscription and resource group. Before you reuse the template, review and update the following:

- Replace hardcoded subscription IDs, resource group names, and resource IDs with [Bicep parameters](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameters).
- Remove any properties you don't need or that reference resources outside the deployment scope.
- Add or adjust security configurations to match your organization's requirements.

For production-ready Bicep templates with enterprise security configurations already built in, see the [infrastructure-setup-bicep](https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-bicep) folder in the Foundry samples repository.

### Related security configurations

When you customize your template, consider adding the following security configurations. Choose based on your governance requirements:

| Control | When to add it | Learn more |
| --- | --- | --- |
| **Private endpoints (network isolation)** | Your organization bans public endpoints, or you need to keep traffic on your virtual network for compliance (HIPAA, PCI, FedRAMP). | [Configure network isolation with private endpoints](../13.3-security-and-governance/07-configure-private-link.md) |
| **Customer-managed keys (CMK) for encryption** | You must control the encryption-key lifecycle, rotation cadence, or revocation, or your data classification requires bring-your-own-key. | [Set up customer-managed keys for encryption](../13.3-security-and-governance/12-encryption-keys-portal.md) |
| **Role-based access control (RBAC)** | You need least-privilege access for builders versus administrators, or you grant access to multiple teams that share a Foundry resource. | [Configure role-based access control for Foundry](../13.3-security-and-governance/02-rbac-foundry.md) |
| **Agent capability settings** | Your agents must store state, vector data, and files in Azure resources you own rather than platform-managed resources. | [Configure agent capability settings](09-configure-capability-settings.md) |
| **Custom Azure Policy definitions** | Your platform team enforces a security baseline (allowed regions, required tags, allowed SKUs, mandatory CMK or private link) across every Foundry resource the organization creates. | [Create custom Azure Policy definitions](../13.3-security-and-governance/15-custom-policy-definition.md) |

### Check deployment permissions before you deploy

If your template sets agent capability settings, the identity that runs the deployment needs more than permission to create the Foundry resource. Confirm each of the following before you deploy, because a missing assignment fails the deployment partway through:

- The deployment principal holds **Storage Blob Data Contributor** on every Azure Storage account the template references.
- The deployment principal holds **Cosmos DB Operator** on every Azure Cosmos DB account the template references.

Azure AI Search doesn't require a caller role for capability settings provisioning. Your deployment principal still needs the permissions required to create or update every resource declared in the template.

Run the following command to list the deployment principal's current assignments:

```azurecli
az role assignment list --assignee <principal-id> --all --output table
```

### Grant runtime access after provisioning

Provisioning permissions and runtime permissions are separate. After the deployment succeeds, grant the project managed identity the data-plane roles it needs on each referenced resource, then confirm an agent can read and write. The caller roles in the previous section don't satisfy this requirement. For the per-resource role list, see [Standard agent setup](10-standard-agent-setup.md).

## Review the Bicep file (optional)

Optionally, review the Bicep template to understand the resource definitions.

You can find the Bicep file used in this article at [https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-bicep/00-basic](https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-bicep/00-basic).

This template creates the following resources:

- [microsoft.cognitiveservices/accounts](https://learn.microsoft.com/en-us/azure/templates/microsoft.cognitiveservices/accounts?pivots=deployment-language-bicep)
- [microsoft.cognitiveservices/accounts/projects](https://learn.microsoft.com/en-us/azure/templates/microsoft.cognitiveservices/accounts/projects?pivots=deployment-language-bicep)

## Review deployed resources

Use the [Foundry portal](https://ai.azure.com/?cid=learnDocs) to view the created resources. You can also use Azure CLI or Azure PowerShell to list the resources.

**[Azure CLI]**

```azurecli
az resource list --resource-group exampleRG
```

**[Azure PowerShell]**

```azurepowershell
Get-AzResource -ResourceGroupName exampleRG
```

## Clean up resources

If you plan to continue working with subsequent quickstarts and tutorials, you can keep the resources you created in this quickstart. If you want to remove the resources, use the following command.

**[Azure CLI]**

```azurecli
az group delete --name exampleRG
```

Reference: [az group delete](https://learn.microsoft.com/en-us/cli/azure/group#az-group-delete)

**[Azure PowerShell]**

```azurepowershell
Remove-AzResourceGroup -Name exampleRG
```

Reference: [Remove-AzResourceGroup](https://learn.microsoft.com/en-us/powershell/module/az.resources/remove-azresourcegroup)

## Troubleshooting

| Symptom | Cause | Resolution |
| --- | --- | --- |
| `ServiceModelDeprecating` error during deployment | The Bicep template includes a model deployment that references a retired or deprecating model version. | Open `main.bicep`, find the `modelDeployment` resource block, and either comment it out or update the model `name` and `version` to a currently available model. Run `az cognitiveservices model list --location <your-location> --query "[?model.lifecycleStatus=='GenerallyAvailable']"` to find available models. |
| `The content for this response was already consumed` | Azure CLI versions 2.74–2.75 have a known bug that masks the actual deployment error. | Run the command again with `--debug` and search for `Exception Details:` in the output to find the real error. |
| Deployment fails with `AccountNameInvalid` | The `aiFoundryName` value must be globally unique, 2–64 characters, and can contain only lowercase letters, numbers, and hyphens. | Choose a different name, such as `<your-name>-foundry-<random-suffix>`. |
| Resources deploy to a different region than the resource group | The Bicep template's `location` parameter defaults to `eastus2`, but the resource group might be in a different region. | Pass the `location` parameter explicitly. For example, add `location=eastus` to your `--parameters` list. |

## Related content

- [Get started with the SDK](../../04-get-started/04.1-what-do-you-want-to-build/03-get-started-code.md)
- [Configure network isolation with private endpoints](../13.3-security-and-governance/07-configure-private-link.md)
- [Set up customer-managed keys for encryption](../13.3-security-and-governance/12-encryption-keys-portal.md)
- [Configure role-based access control for Foundry](../13.3-security-and-governance/02-rbac-foundry.md)
- [Security configurations samples](https://github.com/microsoft-foundry/foundry-samples/tree/main/samples) — See example Bicep template configurations for enterprise security configurations, including network isolation, customer-managed key encryption, advanced identity options, and Agents standard setup.
