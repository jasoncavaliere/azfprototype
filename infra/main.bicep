@description('Prefix for all resource names')
param namePrefix string = 'funcdemo'
@description('Azure region')
param location string = resourceGroup().location
@description('Service Bus queue name')
param sbQueueName string = 'inbox'

var storageName = toLower(replace('${namePrefix}st${uniqueString(resourceGroup().id)}','-',''))
var aiName = '${namePrefix}-ai'
var sbNamespace = '${namePrefix}-sb'
var planName = '${namePrefix}-fx'
var funcName = '${namePrefix}-func'

module storage './modules/storage.bicep' = {
  name: 'storage'
  params: {
    name: storageName
    location: location
  }
}

module ai './modules/appinsights.bicep' = {
  name: 'appinsights'
  params: {
    name: aiName
    location: location
  }
}

module sb './modules/servicebus.bicep' = {
  name: 'servicebus'
  params: {
    namespaceName: sbNamespace
    queueName: sbQueueName
    location: location
  }
}

module func './modules/functionapp.bicep' = {
  name: 'functionapp'
  params: {
    name: funcName
    location: location
    planName: planName
    storageAccountId: storage.outputs.id
    storageConnString: storage.outputs.connectionString
    appInsightsConnectionString: ai.outputs.connectionString
    serviceBusQueueName: sb.outputs.queueName
    serviceBusQueueSasConnectionString: sb.outputs.queueListenConnectionString
  }
}

output functionAppName string = func.outputs.name
output serviceBusQueueName string = sb.outputs.queueName