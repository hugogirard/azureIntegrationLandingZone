param storageName string
param objectId string

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageName
}

var roleIdMapping = {
  'Storage Blob Data Contributor': 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(roleIdMapping['Storage Blob Data Contributor'], objectId, storage.id)
  scope: storage
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      roleIdMapping['Storage Blob Data Contributor']
    ) // Storage Blob Data Contributor
    principalId: objectId
    principalType: 'ServicePrincipal'
  }
}
