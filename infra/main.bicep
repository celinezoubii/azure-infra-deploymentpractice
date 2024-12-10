// Input parameters
param name string
param location string
param containerRegistryImageName string
param containerRegistryImageVersion string

// Deploy Azure Container Registry (ACR)
module acrModule '../modules/acr.bicep' = {
  name: 'acrDeployment'
  params: {
    name: '${name}-acr'
    location: location
    acrAdminUserEnabled: true
  }
}

// Deploy Azure Service Plan
module appServicePlanModule '../modules/appServicePlan.bicep' = {
  name: 'appServicePlanDeployment'
  params: {
    name: '${name}-appServicePlan'
    location: location
    sku: {
      capacity: 1
      family: 'B'
      name: 'B1'
      size: 'B1'
      tier: 'Basic'
      kind: 'Linux'
      reserved: true
    }
  }
}

// Deploy Azure Web App
module webAppModule '../modules/webApp.bicep' = {
  name: 'webAppDeployment'
  params: {
    name: '${name}-webApp'
    location: location
    kind: 'app'
    serverFarmResourceId: appServicePlanModule.outputs.resourceId
    siteConfig: {
      linuxFxVersion: 'DOCKER|${acrModule.outputs.registryName}.azurecr.io/${containerRegistryImageName}:${containerRegistryImageVersion}'
      appCommandLine: ''
      appSettingsKeyValuePairs: {
        WEBSITES_ENABLE_APP_SERVICE_STORAGE: false
        DOCKER_REGISTRY_SERVER_URL: acrModule.outputs.registryUrl
        DOCKER_REGISTRY_SERVER_USERNAME: acrModule.outputs.registryUsername
        DOCKER_REGISTRY_SERVER_PASSWORD: acrModule.outputs.registryPassword
      }
    }
  }
}
