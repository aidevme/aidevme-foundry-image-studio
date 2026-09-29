param location string
param tags object
@minLength(8)
param nameSuffixCompact string

resource registry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: 'cr${nameSuffixCompact}'
  location: location
  tags: tags
  sku: { name: 'Standard' }
  properties: {
    adminUserEnabled: false
  }
}

output name string = registry.name
output loginServer string = registry.properties.loginServer
