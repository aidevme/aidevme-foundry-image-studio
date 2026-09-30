param location string
param tags object
param nameSuffix string
param publicNetworkAccess string

@description('Array of { name, model, format, version, skuName, capacity }.')
param modelDeployments array

var foundryName = 'ais-${nameSuffix}'
var projectName = 'image-studio'

resource account 'Microsoft.CognitiveServices/accounts@2025-06-01' = {
  name: foundryName
  location: location
  tags: tags
  kind: 'AIServices'
  sku: { name: 'S0' }
  identity: { type: 'SystemAssigned' }
  properties: {
    customSubDomainName: foundryName
    allowProjectManagement: true
    disableLocalAuth: true
    publicNetworkAccess: publicNetworkAccess
  }
}

resource project 'Microsoft.CognitiveServices/accounts/projects@2025-06-01' = {
  parent: account
  name: projectName
  location: location
  tags: tags
  identity: { type: 'SystemAssigned' }
  properties: {
    displayName: 'AIDevMe Foundry Image Studio'
    description: 'Agents and tools for governed image generation.'
  }
}

@batchSize(1)
resource deployments 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = [for d in modelDeployments: {
  parent: account
  name: d.name
  sku: { name: d.skuName, capacity: d.capacity }
  properties: {
    model: { format: d.format, name: d.model, version: d.version }
    versionUpgradeOption: 'NoAutoUpgrade'
  }
  dependsOn: [ project ]
}]

resource contentSafety 'Microsoft.CognitiveServices/accounts@2025-06-01' = {
  name: 'cs-${nameSuffix}'
  location: location
  tags: tags
  kind: 'ContentSafety'
  sku: { name: 'S0' }
  identity: { type: 'SystemAssigned' }
  properties: {
    customSubDomainName: 'cs-${nameSuffix}'
    disableLocalAuth: true
    publicNetworkAccess: publicNetworkAccess
  }
}

output accountName string = account.name
output endpoint string = account.properties.endpoint
output projectName string = project.name
output projectEndpoint string = 'https://${account.name}.services.ai.azure.com/api/projects/${project.name}'
output contentSafetyAccountName string = contentSafety.name
output contentSafetyEndpoint string = contentSafety.properties.endpoint
