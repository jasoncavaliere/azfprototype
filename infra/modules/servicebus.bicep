param namespaceName string
param queueName string
param location string

resource ns 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: namespaceName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}

resource q 'Microsoft.ServiceBus/namespaces/queues@2022-10-01-preview' = {
  name: '${ns.name}/${queueName}'
  properties: {
    enablePartitioning: false
    maxDeliveryCount: 10
    lockDuration: 'PT1M'
  }
}

resource qListen 'Microsoft.ServiceBus/namespaces/queues/authorizationRules@2022-10-01-preview' = {
  name: '${ns.name}/${q.name}/listen'
  properties: {
    rights: [
      'Listen'
    ]
  }
}

@secure()
var listenKeys = listKeys(qListen.id, '2017-04-01')

output queueName string = q.name
@secure()
output queueListenConnectionString string = listenKeys.primaryConnectionString