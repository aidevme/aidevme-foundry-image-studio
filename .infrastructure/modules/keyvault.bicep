param location string
param tags object
param nameSuffix string
param publicNetworkAccess string

resource vault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: 'kv-${nameSuffix}'
  location: location
  tags: tags
  properties: {
    tenantId: subscription().tenantId
    sku: { family: 'A', name: 'standard' }
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 30
    enablePurgeProtection: true
    publicNetworkAccess: publicNetworkAccess
    networkAcls: { defaultAction: 'Allow', bypass: 'AzureServices' }
  }
}

output name string = vault.name
output uri string = vault.properties.vaultUri
