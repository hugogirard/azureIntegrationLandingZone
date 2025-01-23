param dnsZoneName string
param recordName string
param privateIpRecord string

resource dns 'Microsoft.Network/privateDnsZones@2024-06-01' existing = {
  name: dnsZoneName
}

resource aRecordAse 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  parent: dns
  name: recordName
  properties: {
    ttl: 10
    aRecords: [
      {
        ipv4Address: privateIpRecord
      }
    ]
  }
}
