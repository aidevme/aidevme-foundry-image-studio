param location string
param tags object
param nameSuffix string
param publicNetworkAccess string

resource store 'Microsoft.AppConfiguration/configurationStores@2023-03-01' = {
  name: 'appcs-${nameSuffix}'
  location: location
  tags: tags
  sku: { name: 'standard' }
  properties: {
    disableLocalAuth: true
    publicNetworkAccess: publicNetworkAccess
    softDeleteRetentionInDays: 7
  }
}

output name string = store.name
output endpoint string = store.properties.endpoint
