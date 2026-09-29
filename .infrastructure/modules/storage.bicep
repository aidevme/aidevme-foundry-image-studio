param location string
param tags object
@minLength(8)
param nameSuffixCompact string
param allowedIpAddresses array
param publicNetworkAccess string
param logAnalyticsWorkspaceId string

resource account 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: 'st${nameSuffixCompact}'
  location: location
  tags: tags
  sku: { name: 'Standard_ZRS' }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    defaultToOAuthAuthentication: true
    supportsHttpsTrafficOnly: true
    publicNetworkAccess: publicNetworkAccess
    networkAcls: {
      defaultAction: publicNetworkAccess == 'Enabled' && !empty(allowedIpAddresses) ? 'Deny' : 'Allow'
      bypass: 'AzureServices'
      ipRules: [for ip in allowedIpAddresses: { value: ip, action: 'Allow' }]
    }
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: account
  name: 'default'
  properties: {
    deleteRetentionPolicy: { enabled: true, days: 7 }
    containerDeleteRetentionPolicy: { enabled: true, days: 7 }
  }
}

var containers = [ 'assets', 'inputs', 'brand', 'icons' ]

resource blobContainers 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = [for name in containers: {
  parent: blobService
  name: name
  properties: { publicAccess: 'None' }
}]

resource lifecycle 'Microsoft.Storage/storageAccounts/managementPolicies@2023-05-01' = {
  parent: account
  name: 'default'
  properties: {
    policy: {
      rules: [
        {
          name: 'delete-inputs-after-7-days'
          enabled: true
          type: 'Lifecycle'
          definition: {
            filters: { blobTypes: [ 'blockBlob' ], prefixMatch: [ 'inputs/' ] }
            actions: { baseBlob: { delete: { daysAfterModificationGreaterThan: 7 } } }
          }
        }
        {
          name: 'cool-assets-after-30-days'
          enabled: true
          type: 'Lifecycle'
          definition: {
            filters: { blobTypes: [ 'blockBlob' ], prefixMatch: [ 'assets/' ] }
            actions: { baseBlob: { tierToCool: { daysAfterModificationGreaterThan: 30 } } }
          }
        }
      ]
    }
  }
}

resource diagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'send-to-log-analytics'
  scope: blobService
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      { categoryGroup: 'allLogs', enabled: true }
    ]
  }
}

output name string = account.name
output id string = account.id
