
param location string = resourceGroup().location
param appServiceAppName string
param appServicePlanName string
param runtimeStack string
param startupCommand string

var appServicePlanSkuName = 'B1'

resource appServicePlan 'Microsoft.Web/serverFarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: appServicePlanSkuName
  }
  kind: 'linux'
}
resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
name: appServiceAppName
location: location
properties: {
  serverFarmId: appServicePlan.id
  httpsOnly: true
  siteConfig: {
    linuxFxVersion: runtimeStack
    appCommandLine: startupCommand
  }
  }
}

output appServiceAppHostName string = appServiceApp.properties.defaultHostName

