param name string

resource privateStorageDFSDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: name
  location: 'global'
}

output dfsZoneName string = privateStorageDFSDnsZone.name
output dfsZoneId string = privateStorageDFSDnsZone.id
