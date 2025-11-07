param name string
param location string

resource stg 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: name
  location: location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
  }
}

@secure()
var key = listKeys(stg.id, '2023-01-01').keys[0].value
var conn = 'DefaultEndpointsProtocol=https;AccountName=${stg.name};AccountKey=${key};EndpointSuffix=${environment().suffixes.storage}'

output id string = stg.id
@secure()
output connectionString string = conn