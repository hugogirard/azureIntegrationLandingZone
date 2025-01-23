param name string
param location string

resource datalake 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: name
  location: location
  properties: {
    allowBlobPublicAccess: false
    publicNetworkAccess: 'Disabled'
    isHnsEnabled: true
    isSftpEnabled: false
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      ipRules: []
    }
    largeFileSharesState: 'Enabled'
  }
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource fileservice 'Microsoft.Storage/storageAccounts/fileServices@2023-05-01' = {
  parent: datalake
  name: 'default'
  properties: {}
}

output datalakeName string = datalake.name
output datalakeStorageId string = datalake.id
