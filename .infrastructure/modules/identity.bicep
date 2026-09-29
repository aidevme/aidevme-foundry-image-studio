param location string
param tags object
param environmentName string

resource imageMcp 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'id-image-mcp-${environmentName}'
  location: location
  tags: tags
}

resource facade 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'id-facade-${environmentName}'
  location: location
  tags: tags
}

output imageMcpId string = imageMcp.id
output imageMcpPrincipalId string = imageMcp.properties.principalId
output facadeId string = facade.id
output facadePrincipalId string = facade.properties.principalId
