param name string
param planName string
param location string
param storageAccountId string
@secure() param storageConnString string
@secure() param appInsightsConnectionString string
param serviceBusQueueName string
@secure() param serviceBusQueueSasConnectionString string

resource plan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: planName
  location: location
  sku: { name: 'FC1', tier: 'FlexConsumption' }
  kind: 'functionapp'
}

resource func 'Microsoft.Web/sites@2023-12-01' = {
  name: name
  location: location
  kind: 'functionapp,linux'
  identity: { type: 'SystemAssigned' }
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      linuxFxVersion: 'DOTNET-ISOLATED|8.0'
      appSettings: [
        { name: 'FUNCTIONS_EXTENSION_VERSION', value: '~4' }
        { name: 'FUNCTIONS_WORKER_RUNTIME', value: 'dotnet-isolated' }
        { name: 'AzureWebJobsStorage', value: storageConnString }
        { name: 'APPLICATIONINSIGHTS_CONNECTION_STRING', value: appInsightsConnectionString }
        { name: 'ServiceBusConnection', value: serviceBusQueueSasConnectionString }
        { name: 'ServiceBusQueueName', value: serviceBusQueueName }
        { name: 'WEBSITE_RUN_FROM_PACKAGE', value: '1' }
      ]
    }
    httpsOnly: true
  }
}

output name string = func.name