param location string
param storageId string
param storageName string
param subnetId string
param privateStorageFileDnsZoneId string
param privateStorageBlobDnsZoneId string
param privateStorageQueueDnsZoneId string
param privateStorageTableDnsZoneId string

var privateEndpointFileStorageName = '${storageName}-file-private-endpoint'
var privateEndpointBlobStorageName = '${storageName}-blob-private-endpoint'
var privateEndpointQueueStorageName = '${storageName}-queue-private-endpoint'
var privateEndpointTableStorageName = '${storageName}-table-private-endpoint'

resource privateEndpointFileStorage 'Microsoft.Network/privateEndpoints@2020-06-01' = {
  name: privateEndpointFileStorageName
  location: location
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'MyStorageQueuePrivateLinkConnection'
        properties: {
          privateLinkServiceId: storageId
          groupIds: [
            'file'
          ]
        }
      }
    ]
  }
}

resource privateEndpointBlobStorage 'Microsoft.Network/privateEndpoints@2020-06-01' = {
  name: privateEndpointBlobStorageName
  location: location
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'MyStorageQueuePrivateLinkConnection'
        properties: {
          privateLinkServiceId: storageId
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}

resource privateEndpointQueueStorage 'Microsoft.Network/privateEndpoints@2020-06-01' = {
  name: privateEndpointQueueStorageName
  location: location
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'MyStorageQueuePrivateLinkConnection'
        properties: {
          privateLinkServiceId: storageId
          groupIds: [
            'queue'
          ]
        }
      }
    ]
  }
}

resource privateEndpointTableStorage 'Microsoft.Network/privateEndpoints@2020-06-01' = {
  name: privateEndpointTableStorageName
  location: location
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'MyStorageQueuePrivateLinkConnection'
        properties: {
          privateLinkServiceId: storageId
          groupIds: [
            'table'
          ]
        }
      }
    ]
  }
}

resource privateEndpointFileStorageName_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-06-01' = {
  parent: privateEndpointFileStorage
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'config1'
        properties: {
          privateDnsZoneId: privateStorageFileDnsZoneId
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

resource privateEndpointQueueStorageName_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-06-01' = {
  parent: privateEndpointQueueStorage
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'config1'
        properties: {
          privateDnsZoneId: privateStorageQueueDnsZoneId
        }
      }
    ]
  }
}

resource privateEndpointTableStorageName_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-06-01' = {
  parent: privateEndpointTableStorage
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'config1'
        properties: {
          privateDnsZoneId: privateStorageTableDnsZoneId
        }
      }
    ]
  }
}

output privateEndpointBlobIP string = privateEndpointBlobStorageName_default.properties.privateDnsZoneConfigs[0].properties.recordSets[0].ipAddresses[0]
output privateEndpointQueueIP string = privateEndpointQueueStorageName_default.properties.privateDnsZoneConfigs[0].properties.recordSets[0].ipAddresses[0]
output privateEndpointFileIP string = privateEndpointFileStorageName_default.properties.privateDnsZoneConfigs[0].properties.recordSets[0].ipAddresses[0]
output tablePrivateIP string = privateEndpointTableStorageName_default.properties.privateDnsZoneConfigs[0].properties.recordSets[0].ipAddresses[0]
