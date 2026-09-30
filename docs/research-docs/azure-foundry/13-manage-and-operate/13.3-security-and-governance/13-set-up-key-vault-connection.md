# Set up an Azure Key Vault connection in Microsoft Foundry

| Field | Value |
| --- | --- |
| **Document Title** | Set up an Azure Key Vault connection in Microsoft Foundry |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.3-security-and-governance/13-set-up-key-vault-connection.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Set up an Azure Key Vault connection in Microsoft Foundry". Learn how to securely connect your Azure Key Vault to Foundry. Follow step-by-step instructions to manage secrets and ensure seamless integration. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/set-up-key-vault-connection). Article date: 2026-08-14. Page updated: 2026-08-17. Retrieved: 2026-09-29. Navigation: Manage and operate > Security and governance > Data protection & encryption > Store secrets in your Azure Key Vault.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

If you don't set up a Key Vault connection, Microsoft Foundry stores connection details in a Microsoft-managed Key Vault outside your subscription. To manage your own secrets, connect your Azure Key Vault to Foundry. Before you begin, review the [limitations](#limitations) for Key Vault connections.

Azure Key Vault is a cloud service for securely storing and accessing secrets. A secret is anything that you want to tightly control access to, such as API keys, passwords, certificates, or cryptographic keys. For more information, see [About Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/overview).

## Prerequisites

- An Azure subscription.
- A Foundry resource with no existing connections at the resource or project level.
- An Azure Key Vault in your subscription, or permissions to create one.
- One of the following Azure RBAC roles on your Key Vault:
  - [Key Vault Secrets Officer](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/security#key-vault-secrets-officer) (minimal permissions)
  - [Key Vault Contributor](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/security#key-vault-contributor)
  - [Key Vault Administrator](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/security#key-vault-administrator)

## Limitations

Create Azure Key Vault connections only when you need them.

If you bring your own Azure Key Vault, review these limitations:

- Limit Azure Key Vault connections to one per Foundry resource. Delete an Azure Key Vault connection only if no other connections exist at the Foundry resource or project level.
- Foundry doesn't support secret migration. Remove and recreate connections yourself.
- Deleting the underlying Azure Key Vault breaks the Foundry resource. Azure Key Vault stores secrets for connections that don't use Microsoft Entra ID. Any Foundry feature that depends on those connections stops working.
- Deleting connection secrets that your Foundry resource stores in your bring your own (BYO) Azure Key Vault can break connections to other services.

## Use a Bicep template

Deploy a Key Vault connection by using Azure Bicep. The following template creates a connection between your Foundry resource and an existing Azure Key Vault, and assigns the Key Vault Secrets Officer role to the Foundry resource's managed identity.

```bicep
/*

Set up your Key Vault connection

Select which RBAC role to assign:
1. Key Vault Administrator:  00482a5a-887f-4fb3-b363-3b7fe8e74483 - https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/security#key-vault-administrator
2. Key Vault Contributor:    f25e0fa2-a7c8-4377-a976-54943a77a395 - https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/security#key-vault-contributor
3. Key Vault Secret Officer: b86a8fe4-44ce-4948-aee5-eccb2c155cd7 - https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/security#key-vault-secrets-officer
This template defaults to using the Key Vault Secret Officer role.


Run command:
az deployment group create \
  --name AzDeploy \
  --resource-group {RESOURCE-GROUP-NAME} \
  --template-file connection-key-vault.bicep \
  --parameters aiFoundryName={Foundry-resource-name} keyVaultName={KV-resource-name}

az deployment group create --name AzDeploy --resource-group {RESOURCE-GROUP-NAME} --template-file connection-key-vault.bicep --parameters aiFoundryName={Foundry-resource-name} keyVaultName={KV-resource-name}

*/

param aiFoundryName string = '<your-account-name>'
param keyVaultName string
//param resourceGroupName string = '<your-resource-group-name>'


resource aiFoundry 'Microsoft.CognitiveServices/accounts@2025-04-01-preview' existing = {
  name: aiFoundryName
  scope: resourceGroup()
}

// Conditionally refers your existing Azure Key Vault resource
resource existingKeyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = {
  name: keyVaultName
  scope: resourceGroup()
}

resource connection 'Microsoft.CognitiveServices/accounts/connections@2025-04-01-preview' = {
  name: '${aiFoundryName}-keyvault'
  parent: aiFoundry
  properties: {
    category: 'AzureKeyVault'
    target: existingKeyVault.id
    authType: 'AccountManagedIdentity'
    isSharedToAll: true
    metadata: {
      ApiType: 'Azure'
      ResourceId: existingKeyVault.id
      location: existingKeyVault.location
    }
  }
}

// Include RBAC on Key Vault for Foundry
resource rbacAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(existingKeyVault.id, 'KeyVaultSecretsOfficer')
  scope: existingKeyVault
  properties: {
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/b86a8fe4-44ce-4948-aee5-eccb2c155cd7'
    principalId: aiFoundry.identity.principalId
  }
}

// All following connections should be created with the dependsOn property for both the key vault connection and the role assignment
```

### Parameters

| Parameter | Description |
| --- | --- |
| `aiFoundryName` | The name of your Foundry resource. |
| `keyVaultName` | The name of your existing Azure Key Vault. |

### Deploy the template

Run the following command to deploy the template:

```azurecli
az deployment group create \
  --name AzDeploy \
  --resource-group <resource-group-name> \
  --template-file connection-key-vault.bicep \
  --parameters aiFoundryName=<foundry-resource-name> keyVaultName=<keyvault-name>
```

### Verify the deployment

After deployment completes:

1. In the Foundry portal, select **Manage** in the upper-right navigation.
2. Select **Resource details** in the left pane.
3. Select the **Connected resources** tab and confirm the Azure Key Vault connection appears in the list.
4. Select the connection to view its properties and verify the Key Vault resource ID.

To verify that the RBAC role assignment is in effect, run the following command:

```azurecli
az role assignment list \
  --scope /subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.KeyVault/vaults/<keyvault-name> \
  --query "[?roleDefinitionName=='Key Vault Secrets Officer']" \
  --output table
```

### Reference

- [Microsoft.CognitiveServices/accounts/connections](https://learn.microsoft.com/en-us/azure/templates/microsoft.cognitiveservices/accounts/connections)
- [Microsoft.Authorization/roleAssignments](https://learn.microsoft.com/en-us/azure/templates/microsoft.authorization/roleassignments)
- [Key Vault Secrets Officer role](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/security#key-vault-secrets-officer)

## Key Vault connection management

### Creation

You can have only one Azure Key Vault connection per Foundry resource. Before you add a Key Vault connection, remove any other connections at the Foundry resource or project level. If the Key Vault connection category doesn't appear when you choose a connection, an existing connection might be the reason. Delete the other connections, and then try again.

When you create a Key Vault connection, the service doesn't use the managed Key Vault in Azure.

### Deletion

Before you delete an Azure Key Vault connection from Foundry, remove all other connections. After you remove all other connections at the Foundry resource and project levels, delete the Key Vault connection. Foundry doesn't support secret migration.

### Update or change

To switch from Azure Key Vault 1 to Azure Key Vault 2, delete the Azure Key Vault 1 connection, and then create the Azure Key Vault 2 connection. Follow the deletion and creation steps, and manually recreate any connection secrets.

### Key Vault secret lifecycle

When you delete connections from your managed Key Vault, the corresponding secrets are deleted. Deleting a Key Vault connection also deletes its secrets.

### Granting Foundry access to your key vault

Depending on how your key vault is provisioned, you might need to apply additional permissions. Check whether your Azure Key Vault uses role-based access control (RBAC) or access policies, and then continue.

#### Role-based access control (RBAC)

After you create the Key Vault connection, assign an appropriate RBAC role in the Azure portal. Key Vault Contributor and Key Vault Administrator are two roles that work. For minimal permissions, use the [Key Vault Secrets Officer](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/security#key-vault-secrets-officer).

#### Access policies

Similar to RBAC roles, assign the appropriate key vault access policy (if applicable) to the Foundry resource's managed identity.

## Infrastructure as code templates

As a best practice, when setting up ARM, Bicep, or Terraform templates to create resources, make sure the Azure Key Vault connection is the first connection you create, and make all other connections depend on the Key Vault connection succeeding. This order helps reduce Key Vault connection failures. If you don't follow this best practice, your templates can encounter race conditions across your connections. As a result, deployments can work sometimes and fail at other times because Foundry doesn't support secret migration.

After you create the Foundry resource and the Key Vault connection, assign the appropriate RBAC roles to the Foundry resource. Make all other connections depend on this role assignment succeeding. The same applies if your Key Vault uses access policies instead of RBAC.

### Follow this order in your infrastructure as code templates

1. Create the Foundry resource.
2. Create a Foundry project.
3. Create the Azure Key Vault connection.
4. Assign the appropriate RBAC role on the Key Vault for the Foundry resource.
5. (Optional) Validate that the RBAC role takes effect.
6. Create any other connections at the resource or project level, and set the `dependsOn` field for steps 3 and 4.

#### Deletion

For cleanup, if you automate resource deletion by using templates, follow the creation steps in reverse order:

1. Delete all connections at the Foundry resource or project level.
2. Delete the Azure Key Vault connection.
3. Delete all Foundry projects.
4. Delete the Foundry resource.

## Troubleshooting

### RBAC role assignment delays

After you assign the Key Vault Secrets Officer role, it can take up to 30 minutes for permissions to propagate. If you get permission errors immediately after role assignment, wait and retry.

### Connection not appearing

If the Key Vault connection doesn't appear in **Connected resources**:

1. Verify the deployment completed successfully.
2. Refresh the portal page.
3. Check that no other connections exist at the resource or project level. A Foundry resource supports only one Key Vault connection, and other existing connections can prevent you from adding one.

### Deployment errors

If deployment fails:

- Confirm you have Contributor or Owner role on the resource group.
- Verify the Key Vault name is correct and the vault exists in your subscription.
- Check that the Foundry resource name matches exactly.

## Related content

- [Add connections to your project](../13.1-set-up-and-configure/15-connections-add.md)
- [Azure Key Vault best practices](https://learn.microsoft.com/en-us/azure/key-vault/general/best-practices)
- [Azure Key Vault documentation](https://learn.microsoft.com/en-us/azure/key-vault/)
- [Foundry documentation](https://learn.microsoft.com/en-us/azure/ai-foundry/)
