param name string
param location string
param sku object

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: name
  location: location
  sku: sku
  properties: {
    reserved: true
  }
}

output resourceId string = appServicePlan.id
