targetScope = 'subscription'

@minLength(1)
@maxLength(12)
@description('Short name of the environment, for example dev, test, or prod.')
param environmentName string

@allowed([ 'dev', 'test', 'prod' ])
param environmentType string

@description('Azure region for all resources. Decision D1 selects the region.')
param location string

@description('Object ID of the person or service principal that runs setup scripts. Leave empty in test and prod.')
param deployerPrincipalId string = ''

@description('Publisher e-mail address shown by API Management.')
param apimPublisherEmail string

param enableAsyncJobs bool = false
param enableExternalProvider bool = false

@description('Image and reasoning model deployments. See the parameter files.')
param modelDeployments array

@description('IP addresses allowed to reach Storage and Cosmos DB while public access is enabled.')
param allowedIpAddresses array = []

param tags object = {}

var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
// Names contain the environment type (dev, test, prod) and a short unique token.
// nameSuffixCompact has no hyphen, for Storage and Container Registry names.
var nameSuffix = '${environmentType}-${resourceToken}'
var nameSuffixCompact = '${environmentType}${resourceToken}'
var allTags = union(tags, {
  application: 'aidevme-foundry-image-studio'
  environment: environmentType
})

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: 'rg-image-studio-${environmentName}'
  location: location
  tags: allTags
}

module monitoring 'modules/monitoring.bicep' = {
  scope: rg
  name: 'monitoring'
  params: {
    location: location
    tags: allTags
    nameSuffix: nameSuffix
  }
}

module identity 'modules/identity.bicep' = {
  scope: rg
  name: 'identity'
  params: {
    location: location
    tags: allTags
    environmentName: environmentName
  }
}

module storage 'modules/storage.bicep' = {
  scope: rg
  name: 'storage'
  params: {
    location: location
    tags: allTags
    nameSuffixCompact: nameSuffixCompact
    allowedIpAddresses: allowedIpAddresses
    publicNetworkAccess: 'Enabled'
    logAnalyticsWorkspaceId: monitoring.outputs.logAnalyticsId
  }
}

module cosmos 'modules/cosmos.bicep' = {
  scope: rg
  name: 'cosmos'
  params: {
    location: location
    tags: allTags
    nameSuffix: nameSuffix
    allowedIpAddresses: allowedIpAddresses
    publicNetworkAccess: 'Enabled'
  }
}

module keyVault 'modules/keyvault.bicep' = {
  scope: rg
  name: 'keyvault'
  params: {
    location: location
    tags: allTags
    nameSuffix: nameSuffix
    publicNetworkAccess: 'Enabled'
  }
}

module appConfig 'modules/appconfig.bicep' = {
  scope: rg
  name: 'appconfig'
  params: {
    location: location
    tags: allTags
    nameSuffix: nameSuffix
    publicNetworkAccess: 'Enabled'
  }
}

module foundry 'modules/foundry.bicep' = {
  scope: rg
  name: 'foundry'
  params: {
    location: location
    tags: allTags
    nameSuffix: nameSuffix
    modelDeployments: modelDeployments
    publicNetworkAccess: 'Enabled'
  }
}

module search 'modules/search.bicep' = {
  scope: rg
  name: 'search'
  params: {
    location: location
    tags: allTags
    nameSuffix: nameSuffix
    publicNetworkAccess: 'enabled'
  }
}

module registry 'modules/registry.bicep' = {
  scope: rg
  name: 'registry'
  params: {
    location: location
    tags: allTags
    nameSuffixCompact: nameSuffixCompact
  }
}

module serviceBus 'modules/servicebus.bicep' = if (enableAsyncJobs) {
  scope: rg
  name: 'servicebus'
  params: {
    location: location
    tags: allTags
    nameSuffix: nameSuffix
  }
}

module containerApps 'modules/containerapps.bicep' = {
  scope: rg
  name: 'containerapps'
  params: {
    location: location
    tags: allTags
    nameSuffix: nameSuffix
    environmentType: environmentType
    logAnalyticsWorkspaceName: monitoring.outputs.logAnalyticsName
    appInsightsName: monitoring.outputs.appInsightsName
    registryLoginServer: registry.outputs.loginServer
    imageMcpIdentityId: identity.outputs.imageMcpId
    facadeIdentityId: identity.outputs.facadeId
    enableAsyncJobs: enableAsyncJobs
    settings: {
      storageAccountName: storage.outputs.name
      cosmosEndpoint: cosmos.outputs.endpoint
      appConfigEndpoint: appConfig.outputs.endpoint
      foundryEndpoint: foundry.outputs.endpoint
      foundryProjectEndpoint: foundry.outputs.projectEndpoint
      contentSafetyEndpoint: foundry.outputs.contentSafetyEndpoint
      serviceBusNamespace: enableAsyncJobs ? serviceBus!.outputs.namespaceName : ''
    }
  }
}

module apim 'modules/apim.bicep' = {
  scope: rg
  name: 'apim'
  params: {
    location: location
    tags: allTags
    nameSuffix: nameSuffix
    facadeFqdn: containerApps.outputs.facadeFqdn
    appInsightsName: monitoring.outputs.appInsightsName
    publisherEmail: apimPublisherEmail
  }
}

module rbac 'modules/rbac.bicep' = {
  scope: rg
  name: 'rbac'
  params: {
    imageMcpPrincipalId: identity.outputs.imageMcpPrincipalId
    facadePrincipalId: identity.outputs.facadePrincipalId
    deployerPrincipalId: deployerPrincipalId
    storageAccountName: storage.outputs.name
    cosmosAccountName: cosmos.outputs.accountName
    keyVaultName: keyVault.outputs.name
    appConfigName: appConfig.outputs.name
    foundryAccountName: foundry.outputs.accountName
    contentSafetyAccountName: foundry.outputs.contentSafetyAccountName
    registryName: registry.outputs.name
    serviceBusNamespaceName: enableAsyncJobs ? serviceBus!.outputs.namespaceName : ''
    enableAsyncJobs: enableAsyncJobs
    enableExternalProvider: enableExternalProvider
  }
}

output resourceGroupName string = rg.name
output apimGatewayUrl string = apim.outputs.gatewayUrl
output foundryProjectEndpoint string = foundry.outputs.projectEndpoint
output storageAccountName string = storage.outputs.name
output cosmosEndpoint string = cosmos.outputs.endpoint
output appConfigEndpoint string = appConfig.outputs.endpoint
output containerRegistryLoginServer string = registry.outputs.loginServer
output searchEndpoint string = search.outputs.endpoint
