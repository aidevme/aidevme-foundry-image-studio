param imageMcpPrincipalId string
param facadePrincipalId string
param deployerPrincipalId string = ''
param storageAccountName string
param cosmosAccountName string
param keyVaultName string
param appConfigName string
param foundryAccountName string
param contentSafetyAccountName string
param registryName string
param serviceBusNamespaceName string = ''
param enableAsyncJobs bool
param enableExternalProvider bool

var roles = {
  storageBlobDataContributor: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  storageBlobDelegator: 'db58b8e5-c6ad-4a2a-8342-4190687cbf4a'
  keyVaultSecretsUser: '4633458b-17de-408a-b874-0445c86b69e6'
  appConfigDataReader: '516239f1-63e1-43b4-ac11-4b1a5ea6e3e4'
  appConfigDataOwner: '5ae67dd6-50cb-40e7-96ff-dc2bfa4b606b'
  cognitiveServicesOpenAiUser: '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd'
  cognitiveServicesUser: 'a97b65f3-24c7-4388-baec-2e87135dc908'
  azureAiUser: '53ca6127-db72-4b80-b1b0-d745d6d5456d'
  serviceBusDataSender: '69a216fc-b8fb-44d8-bc22-1f3c2cd27a39'
  serviceBusDataReceiver: '4f6d3b9b-027b-4f4c-9142-0e5a2a2247e0'
  acrPull: '7f951dda-4ed3-4680-a7ca-43fe172d538d'
}

resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' existing = { name: storageAccountName }
resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2024-05-15' existing = { name: cosmosAccountName }
resource vault 'Microsoft.KeyVault/vaults@2023-07-01' existing = { name: keyVaultName }
resource appConfig 'Microsoft.AppConfiguration/configurationStores@2023-03-01' existing = { name: appConfigName }
resource foundry 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = { name: foundryAccountName }
resource contentSafety 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = { name: contentSafetyAccountName }
resource registry 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = { name: registryName }
resource serviceBus 'Microsoft.ServiceBus/namespaces@2024-01-01' existing = if (enableAsyncJobs) { name: serviceBusNamespaceName }

// Image MCP server: storage
resource mcpBlobContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storage
  name: guid(storage.id, imageMcpPrincipalId, roles.storageBlobDataContributor)
  properties: {
    principalId: imageMcpPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.storageBlobDataContributor)
  }
}

resource mcpBlobDelegator 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storage
  name: guid(storage.id, imageMcpPrincipalId, roles.storageBlobDelegator)
  properties: {
    principalId: imageMcpPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.storageBlobDelegator)
  }
}

// Image MCP server: model deployments and Content Safety
resource mcpModels 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: foundry
  name: guid(foundry.id, imageMcpPrincipalId, roles.cognitiveServicesOpenAiUser)
  properties: {
    principalId: imageMcpPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.cognitiveServicesOpenAiUser)
  }
}

resource mcpSafety 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: contentSafety
  name: guid(contentSafety.id, imageMcpPrincipalId, roles.cognitiveServicesUser)
  properties: {
    principalId: imageMcpPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.cognitiveServicesUser)
  }
}

// Image MCP server: routing table
resource mcpConfig 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: appConfig
  name: guid(appConfig.id, imageMcpPrincipalId, roles.appConfigDataReader)
  properties: {
    principalId: imageMcpPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.appConfigDataReader)
  }
}

// Image MCP server: external provider key (only when enabled)
resource mcpVault 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (enableExternalProvider) {
  scope: vault
  name: guid(vault.id, imageMcpPrincipalId, roles.keyVaultSecretsUser)
  properties: {
    principalId: imageMcpPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.keyVaultSecretsUser)
  }
}

// Image MCP server: Service Bus
resource mcpQueueSender 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (enableAsyncJobs) {
  scope: serviceBus
  name: guid(serviceBus.id, imageMcpPrincipalId, roles.serviceBusDataSender)
  properties: {
    principalId: imageMcpPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.serviceBusDataSender)
  }
}

resource mcpQueueReceiver 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (enableAsyncJobs) {
  scope: serviceBus
  name: guid(serviceBus.id, imageMcpPrincipalId, roles.serviceBusDataReceiver)
  properties: {
    principalId: imageMcpPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.serviceBusDataReceiver)
  }
}

// Cosmos DB data-plane role: Built-in Data Contributor
resource cosmosContributor 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2024-05-15' = {
  parent: cosmos
  name: guid(cosmos.id, imageMcpPrincipalId, 'data-contributor')
  properties: {
    principalId: imageMcpPrincipalId
    roleDefinitionId: '${cosmos.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002'
    scope: cosmos.id
  }
}

// Facade: call the Foundry agent
resource facadeAiUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: foundry
  name: guid(foundry.id, facadePrincipalId, roles.azureAiUser)
  properties: {
    principalId: facadePrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.azureAiUser)
  }
}

// Both apps pull images from the registry
resource mcpAcrPull 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: registry
  name: guid(registry.id, imageMcpPrincipalId, roles.acrPull)
  properties: {
    principalId: imageMcpPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.acrPull)
  }
}

resource facadeAcrPull 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: registry
  name: guid(registry.id, facadePrincipalId, roles.acrPull)
  properties: {
    principalId: facadePrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.acrPull)
  }
}

// Deployer (dev setup scripts only)
resource deployerBlob 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(deployerPrincipalId)) {
  scope: storage
  name: guid(storage.id, deployerPrincipalId, roles.storageBlobDataContributor)
  properties: {
    principalId: deployerPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.storageBlobDataContributor)
  }
}

resource deployerAiUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(deployerPrincipalId)) {
  scope: foundry
  name: guid(foundry.id, deployerPrincipalId, roles.azureAiUser)
  properties: {
    principalId: deployerPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.azureAiUser)
  }
}

resource deployerConfig 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(deployerPrincipalId)) {
  scope: appConfig
  name: guid(appConfig.id, deployerPrincipalId, roles.appConfigDataOwner)
  properties: {
    principalId: deployerPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.appConfigDataOwner)
  }
}
