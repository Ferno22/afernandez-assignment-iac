@sys.description('The Web App name.')
@minLength(3)
@maxLength(24)
param appServiceAppName1 string = 'afernandez-assignment-pr'
@sys.description('The App Service Plan name.')
@minLength(3)
@maxLength(24)
param appServicePlanName1 string = 'afernandez-assignment-pr'
@sys.description('The Web App name.')
@minLength(3)
@maxLength(24)
param appServiceAppName2 string = 'afernandez-assignment-dv'
@sys.description('The App Service Plan name.')
@minLength(3)
@maxLength(24)
param appServicePlanName2 string = 'afernandez-assignment-dv'
@sys.description('The Storage Account name.')
@minLength(3)
@maxLength(24)
param storageAccountName string = 'afernandezstorage'
@allowed([
  'nonprod'
  'prod'
  ])
param environmentType string = 'nonprod'
param location string = resourceGroup().location

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'  

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
    name: storageAccountName
    location: location
    sku: {
      name: storageAccountSkuName
    }
    kind: 'StorageV2'
    properties: {
      accessTier: 'Hot'
    }
  }

module appService1 'modules/appStuff.bicep' = if (environmentType == 'prod') {
  name: 'appService1'
  params: { 
    location: location
    appServiceAppName: appServiceAppName1
    appServicePlanName: appServicePlanName1
    environmentType: environmentType
  }
}

module appService2 'modules/appStuff.bicep' = if (environmentType == 'nonprod') {
  name: 'appService2'
  params: { 
    location: location
    appServiceAppName: appServiceAppName2
    appServicePlanName: appServicePlanName2
    environmentType: environmentType
  }
}

  output appServiceAppHostName string = (environmentType == 'prod') ? appService1.outputs.appServiceAppHostName : appService2.outputs.appServiceAppHostName

    