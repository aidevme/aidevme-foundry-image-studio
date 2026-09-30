# Connect to your own storage

| Field | Value |
| --- | --- |
| **Document Title** | Connect to your own storage |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.1-set-up-and-configure/16-bring-your-own-azure-storage-foundry.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Connect to your own storage". Learn how to bring your own storage to Microsoft Foundry for agents, evaluations, datasets, and other capabilities. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/bring-your-own-azure-storage-foundry). Article date: 2026-08-11. Page updated: 2026-09-25. Retrieved: 2026-09-29. Navigation: Manage and operate > Set up and configure > Connect services and tools > Connect to your own storage in Foundry.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

> **Important**
>
> Items marked (preview) in this article are currently in public preview. This preview is provided without a service-level agreement, and we don't recommend it for production workloads. Certain features might not be supported or might have constrained capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

Microsoft Foundry brings Agents, Azure OpenAI, Speech, and Language services together under one unified resource type. Bring-your-own-storage (BYOS) lets you route data produced by these capabilities to an Azure Storage account that you own and govern. The configuration patterns align with (and provide backward compatibility to) earlier standalone Speech and Language resource types.

This article shows you how to connect your storage to Foundry by using two overarching approaches:

- **Connections**: recommended baseline for most features. Connections provide the shared data pointer.
- **Capability settings**: declare the storage account that Foundry Agent Service uses for agent files.
- **userOwnedStorage field:** a resource-level binding used only by Speech and Language.

## Prerequisites

Before connecting your storage, ensure you have:

An Azure account with an active subscription. If you don't have one, create a [free Azure account, which includes a free trial subscription](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

1. An [Azure Storage account](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-portal) in the same subscription (Blob Storage supported) with the following configuration:
   - `allowSharedKeyAccess` set to `false`. Foundry uses identity-based (Microsoft Entra) access with the project managed identity and Azure RBAC, so shared key access isn't required.
   - `minimumTlsVersion` set to `TLS1_2`
   - `allowBlobPublicAccess` set to `false`
   - `allowCrossTenantReplication` set to `false` (recommended hardening)
2. Contributor or Owner permissions on both the Foundry resource and the storage account.
3. Clarity on which features you plan to use (Agents, Evaluations, Datasets, Content Understanding, Speech, Language).
4. (Optional) A plan for customer-managed keys (CMK) encryption on the storage account.

> **Tip**
>
> See [Azure Storage documentation](https://learn.microsoft.com/en-us/azure/storage/) for guidance on security, networking, and encryption options.

## Understand storage connection approaches

| Approach | What it is | Features supported | Scope | When to use |
| --- | --- | --- | --- | --- |
| Foundry connections (shared data pointer) | Sub-resource holding endpoint and authentication; grants project users indirect access | Agents, Evaluations, Datasets, Content Understanding | Resource or project level | Default pattern for most scenarios |
| Capability settings (agent storage declaration) | Account and project properties naming the storage account that holds agent files | Agents (standard setup) | Account and project level | When agents must store files in a storage account you own |
| userOwnedStorage field (resource storage binding) | Resource property assigning one storage account for Speech and Language (shared) | Speech, Language | Resource level only | To enable customer-managed storage for Speech and Language at creation time |

### Foundry connections

Foundry connections act as shared data pointers across Foundry capabilities (agents, evaluations, datasets, content understanding). Each connection wraps the target storage endpoint plus authentication so users with project access can use the data without direct storage account permissions. Use connections as the default pattern for evaluations, datasets, and content understanding.

### Capability settings

Capability settings are properties on the Foundry account and project that declare which Azure resources hold agent state, vector data, and files. Set `blobStore` to the resource ID of your storage account, and Agent Service provisions the required underlying infrastructure and the connection to that account. You don't create or bind the connection yourself.

If you don't set `blobStore`, Foundry uses Microsoft-managed storage for agent files. See [Configure agent capability settings](09-configure-capability-settings.md) for settings, permissions, and Bicep examples.

### userOwnedStorage (resource storage binding)

The `userOwnedStorage` field enables customer-managed storage for Speech and Language capabilities. Set this field during resource creation at the resource level, so all projects within the resource share the same storage account.

Speech and Language capabilities share the storage account but use different containers within it. The setting applies at the resource level and can't be changed after creation without recreating the resource.

If strict data isolation is required between Speech and Language scenarios, create separate Foundry resources with different storage accounts.

> **Important**
>
> If you delete or move (change resource ID of) the storage account bound by `userOwnedStorage`, Speech and Language stop functioning. Consider attempting account recovery first: [Recover a storage account](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-recover). Otherwise you must recreate the Foundry resource.

## Create a storage connection

1. Sign in to [Microsoft Foundry](https://ai.azure.com/?cid=learnDocs). Make sure the **New Foundry** toggle is on. These steps refer to **Foundry (new)**.![](https://learn.microsoft.com/en-us/azure/foundry/media/version-banner/new-foundry.png)
2. Select **Manage** in the upper-right navigation.
3. Select **Project details** in the left pane.
4. Select the **Connected resources** tab, and then select **Add connection**.
5. In the list of available services, select **Azure Storage**.
6. Browse for and select your Azure Storage account, choose an **Authentication** type, and then select **Add connection**.

> **Note**
>
> Azure portal (portal.azure.com) steps are version-agnostic and intentionally not wrapped in moniker blocks.

## Configure agent storage

Declare your storage account in the capability settings on the Foundry account or project. Agent Service provisions the required underlying infrastructure and the connection to that account, so you don't create or bind a connection for agent files yourself.

1. Get the full Azure resource ID of your storage account.
2. Set `blobStore` in `capabilitySettings` on the Foundry account to establish the default for its projects.
3. Create or open a project. The project inherits the account value unless you override `blobStore` on the project.
4. Verify that agent data now writes to your storage account.

### Example (Bicep)

The following `properties` block sets the storage account that agents use for files. Use it with API version `2026-07-15-preview`.

```bicep
properties: {
  allowProjectManagement: true
  customSubDomainName: accountName
  capabilitySettings: {
    blobStore: storageAccountId
  }
}
```

The identity that runs this deployment needs **Storage Blob Data Contributor** on the storage account, in addition to permission to create the Foundry account. For the full permission model, see [Configure agent capability settings](09-configure-capability-settings.md#permissions).

## Verify your storage configuration

After you configure storage connections and capability settings, confirm that data routes to your storage account:

1. Sign in to the [Azure portal](https://portal.azure.com/) and open your storage account.
2. Navigate to **Containers** under **Data storage**.
3. Create a test agent in your Foundry project and run a simple interaction.
4. Return to the storage account and refresh the **Containers** view.
5. Verify that new containers or blobs appear in your storage account.

If data doesn't appear in your storage account, check the following:

- A GET on the project returns the `blobStore` value you expect, either set on the project or inherited from the account.
- The project managed identity has the required storage roles: **Storage Account Contributor** on the storage account, **Storage Blob Data Contributor** on the `<workspaceId>-azureml-blobstore` container, and **Storage Blob Data Owner** on the `<workspaceId>-agents-blobstore` container. See [Standard agent setup](10-standard-agent-setup.md) for the complete role list.
- Network settings on the storage account allow access from Microsoft Foundry.

## Set userOwnedStorage for Speech and Language

Set the field during resource creation—via Bicep, ARM, Terraform, CLI, or PowerShell.

### Bicep example

```bicep
resource foundry 'Microsoft.CognitiveServices/accounts@2026-07-01' = {
  name: myFoundryName
  location: location
  kind: 'AIServices'
  sku: { name: 'S0' }
  properties: {
    userOwnedStorage: [
      {
        resourceId: storageAccount.id
      }
    ]
  }
}
```

### Terraform snippet

Refer to [Terraform cognitive_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account).

```hcl
resource "azurerm_cognitive_account" "foundry" {
  name                = var.foundry_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "AIServices"
  sku_name            = "S0"

  storage { # userOwnedStorage equivalent
    storage_account_id = azurerm_storage_account.speechlang.id
  }
}
```

### Role assignment

Create the role assignment on the Azure Storage account for the Foundry project managed identity. Assign the `Storage Blob Data Contributor` role so the project identity can read and write blobs in your storage account.

```azurecli
az role assignment create \
  --assignee <project-managed-identity-principal-id> \
  --role "Storage Blob Data Contributor" \
  --scope /subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>
```

## End-to-end customer-managed storage checklist

1. Create resource with `userOwnedStorage` (if Speech or Language features are needed).
2. Create storage connection.
3. Set `blobStore` in the account capability settings so agents use your storage account.
4. Override `blobStore` on a project only if that project needs a different storage account.
5. Bind Content Understanding to the storage connection.

After these steps, all features (Agents, Evaluations, Datasets, Content Understanding, Speech, Language) route to customer-managed storage.

## Troubleshooting

### Agents still use Microsoft-managed storage

If agents continue to write data to Microsoft-managed storage instead of your storage account:

- Verify that a GET on the project returns the `blobStore` value you expect, either set on the project or inherited from the account.
- Confirm the resource ID in `blobStore` points to the expected storage account.
- Confirm the deployment that set the capability settings succeeded. A caller missing **Storage Blob Data Contributor** fails provisioning before the setting takes effect.
- Review role assignments on the storage account. Standard agent setup requires **Storage Account Contributor** on the account, **Storage Blob Data Contributor** on the `<workspaceId>-azureml-blobstore` container, and **Storage Blob Data Owner** on the `<workspaceId>-agents-blobstore` container.

### Permission errors when accessing storage

If you get authorization or permission errors:

- Confirm that the project managed identity (not the resource identity) has the required storage roles on the storage account and containers.
- Confirm the storage account permits the authentication method your connection uses.
- Check that network rules on the storage account allow traffic from Microsoft Foundry. If the storage account uses a firewall, add the appropriate exceptions.

### Speech or Language stops working after storage changes

If Speech or Language capabilities stop functioning after changes to your storage account:

- Don't delete or move (change the resource ID of) the storage account bound by `userOwnedStorage`.
- If the storage account was deleted, attempt recovery first: [Recover a storage account](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-recover).
- If recovery isn't possible, recreate the Foundry resource with a new storage account. You can't change the `userOwnedStorage` field after resource creation.

## Related content

- [Configure agent capability settings](09-configure-capability-settings.md)
- [Understanding Agents standard setup](10-standard-agent-setup.md)
- [Add connections to your project](15-connections-add.md)
- [Recover a storage account](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-recover).
- [Azure Storage documentation](https://learn.microsoft.com/en-us/azure/storage/).
- [Infrastructure setup samples](https://github.com/microsoft-foundry/foundry-samples/tree/main/samples).
- [Connect storage for Speech/Language](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/bring-your-own-storage-speech-resource?tabs=portal).
