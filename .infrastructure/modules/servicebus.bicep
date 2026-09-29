param location string
param tags object
param nameSuffix string

resource namespace 'Microsoft.ServiceBus/namespaces@2024-01-01' = {
  name: 'sb-${nameSuffix}'
  location: location
  tags: tags
  sku: { name: 'Standard', tier: 'Standard' }
  properties: {
    disableLocalAuth: true
    minimumTlsVersion: '1.2'
  }
}

resource jobsQueue 'Microsoft.ServiceBus/namespaces/queues@2024-01-01' = {
  parent: namespace
  name: 'image-jobs'
  properties: {
    requiresSession: true
    lockDuration: 'PT5M'
    maxDeliveryCount: 5
    deadLetteringOnMessageExpiration: true
    defaultMessageTimeToLive: 'P1D'
  }
}

output namespaceName string = namespace.name
