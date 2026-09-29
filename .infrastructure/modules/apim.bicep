param location string
param tags object
param nameSuffix string
param facadeFqdn string
param appInsightsName string
param publisherEmail string
param publisherName string = 'AIDevMe'

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
}

resource apim 'Microsoft.ApiManagement/service@2023-09-01-preview' = {
  name: 'apim-${nameSuffix}'
  location: location
  tags: tags
  sku: {
    name: 'Developer'
    capacity: 1
  }
  identity: { type: 'SystemAssigned' }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}

resource facadeBackend 'Microsoft.ApiManagement/service/backends@2023-09-01-preview' = {
  parent: apim
  name: 'image-studio-facade'
  properties: {
    protocol: 'http'
    url: 'https://${facadeFqdn}'
  }
}

resource facadeApi 'Microsoft.ApiManagement/service/apis@2023-09-01-preview' = {
  parent: apim
  name: 'image-studio'
  properties: {
    displayName: 'Image Studio'
    path: 'image-studio'
    protocols: [ 'https' ]
    subscriptionRequired: true
    serviceUrl: 'https://${facadeFqdn}'
  }
}

resource logger 'Microsoft.ApiManagement/service/loggers@2023-09-01-preview' = {
  parent: apim
  name: 'appinsights'
  properties: {
    loggerType: 'applicationInsights'
    resourceId: appInsights.id
    credentials: { instrumentationKey: appInsights.properties.InstrumentationKey }
  }
}

output gatewayUrl string = apim.properties.gatewayUrl
output principalId string = apim.identity.principalId
