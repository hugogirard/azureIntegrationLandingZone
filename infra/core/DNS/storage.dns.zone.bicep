param privateStorageFileDnsZoneName string
param privateStorageBlobDnsZoneName string
param privateStorageQueueDnsZoneName string
param privateStorageTableDnsZoneName string

resource privateStorageFileDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateStorageFileDnsZoneName
  location: 'global'
}

resource privateStorageBlobDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateStorageBlobDnsZoneName
  location: 'global'
}

resource privateStorageQueueDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateStorageQueueDnsZoneName
  location: 'global'
}

resource privateStorageTableDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateStorageTableDnsZoneName
  location: 'global'
}

output privateStorageFileDnsZoneId string = privateStorageFileDnsZone.id
output privateStorageBlobDnsZoneId string = privateStorageBlobDnsZone.id
output privateStorageQueueDnsZoneId string = privateStorageQueueDnsZone.id
output privateStorageTableDnsZoneId string = privateStorageTableDnsZone.id

output privateStorageFileDnsZoneName string = privateStorageFileDnsZone.name
output privateStorageBlobDnsZoneName string = privateStorageBlobDnsZone.name
output privateStorageQueueDnsZoneName string = privateStorageQueueDnsZone.name
output privateStorageTableDnsZoneName string = privateStorageTableDnsZone.name
