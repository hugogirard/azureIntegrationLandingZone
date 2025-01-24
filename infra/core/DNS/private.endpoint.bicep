param name string
param location string
param subnetId string
param serviceId string
param groupIds array

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2020-06-01' = {
  name: name
  location: location
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'MyStorageQueuePrivateLinkConnection'
        properties: {
          privateLinkServiceId: serviceId
          groupIds: groupIds
        }
      }
    ]
  }
}

output name string = privateEndpoint.name
output id string = privateEndpoint.id
