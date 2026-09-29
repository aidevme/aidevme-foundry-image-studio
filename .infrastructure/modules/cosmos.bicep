param location string
param tags object
param nameSuffix string
param allowedIpAddresses array
param publicNetworkAccess string

resource account 'Microsoft.DocumentDB/databaseAccounts@2024-05-15' = {
  name: 'cosmos-${nameSuffix}'
  location: location
  tags: tags
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    disableLocalAuth: true
    publicNetworkAccess: publicNetworkAccess
    ipRules: [for ip in allowedIpAddresses: { ipAddressOrRange: ip }]
    consistencyPolicy: { defaultConsistencyLevel: 'Session' }
    locations: [
      { locationName: location, failoverPriority: 0, isZoneRedundant: false }
    ]
    capabilities: [
      { name: 'EnableServerless' }
    ]
  }
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2024-05-15' = {
  parent: account
  name: 'image-studio'
  properties: {
    resource: { id: 'image-studio' }
  }
}

resource jobs 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2024-05-15' = {
  parent: database
  name: 'jobs'
  properties: {
    resource: {
      id: 'jobs'
      partitionKey: { paths: [ '/tenantId' ], kind: 'Hash' }
      defaultTtl: -1
      indexingPolicy: {
        indexingMode: 'consistent'
        includedPaths: [ { path: '/*' } ]
        compositeIndexes: [
          [
            { path: '/userId', order: 'ascending' }
            { path: '/createdAt', order: 'descending' }
          ]
        ]
      }
    }
  }
}

output accountName string = account.name
output endpoint string = account.properties.documentEndpoint
