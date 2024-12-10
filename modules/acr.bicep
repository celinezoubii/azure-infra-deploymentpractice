param name string
param location string
param acrAdminUserEnabled bool

resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' = {
  name: name
  location: location
  sku: {
    name: 'Basic' // Use Basic as the SKU
  }
  properties: {
    adminUserEnabled: acrAdminUserEnabled
  }
}

output registryName string = acr.name
output registryUrl string = acr.properties.loginServer
output registryUsername string = listCredentials(acr.id, '2021-09-01').username
output registryPassword string = listCredentials(acr.id, '2021-09-01').passwords[0].value
