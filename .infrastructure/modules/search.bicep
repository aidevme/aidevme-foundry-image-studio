param location string
param tags object
param nameSuffix string

@allowed([ 'enabled', 'disabled' ])
param publicNetworkAccess string

resource search 'Microsoft.Search/searchServices@2024-06-01-preview' = {
  name: 'srch-${nameSuffix}'
  location: location
  tags: tags
  sku: { name: 'basic' }
  identity: { type: 'SystemAssigned' }
  properties: {
    replicaCount: 1
    partitionCount: 1
    hostingMode: 'default'
    publicNetworkAccess: publicNetworkAccess
    disableLocalAuth: true
  }
}

output name string = search.name
output endpoint string = 'https://${search.name}.search.windows.net'
