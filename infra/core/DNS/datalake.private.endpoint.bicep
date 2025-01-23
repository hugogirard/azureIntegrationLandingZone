param storageName string
param privateStorageBlobDnsZoneId string
param storageId string
param subnetId string
param location string

var privateEndpointBlobStorageName = '${storageName}-dfs-private-endpoint'

resource privateEndpointBlobStorage 'Microsoft.Network/privateEndpoints@2020-06-01' = {
  name: privateEndpointBlobStorageName
  location: location
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'MyStorageBlobPrivateLinkConnection'
        properties: {
          privateLinkServiceId: storageId
          groupIds: [
            'dfs'
          ]
        }
      }
    ]
  }
}

resource privateEndpointBlobStorageName_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-06-01' = {
  parent: privateEndpointBlobStorage
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'config1'
        properties: {
          privateDnsZoneId: privateStorageBlobDnsZoneId
        }
      }
    ]
  }
}
