param privateStorageFileDnsZoneName string
param privateStorageBlobDnsZoneName string
param privateStorageQueueDnsZoneName string
param privateStorageTableDnsZoneName string
param vnetName string
param vnetRgName string

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetRgName)
}

resource privateStorageFileDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateStorageFileDnsZoneName
}

resource privateStorageBlobDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateStorageBlobDnsZoneName
}

resource privateStorageQueueDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateStorageQueueDnsZoneName
}

resource privateStorageTableDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateStorageTableDnsZoneName
}

var virtualNetworkLinksSuffixFileStorageName = '${privateStorageFileDnsZoneName}-link-${vnetName}'
var virtualNetworkLinksSuffixBlobStorageName = '${privateStorageBlobDnsZoneName}-link-${vnetName}'
var virtualNetworkLinksSuffixQueueStorageName = '${privateStorageQueueDnsZoneName}-link-${vnetName}'
var virtualNetworkLinksSuffixTableStorageName = '${privateStorageTableDnsZoneName}-link-${vnetName}'

resource privateStorageFileDnsZoneName_virtualNetworkLinksSuffixFileStorage 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateStorageFileDnsZone
  name: virtualNetworkLinksSuffixFileStorageName
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

resource privateStorageBlobDnsZoneName_virtualNetworkLinksSuffixBlobStorage 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateStorageBlobDnsZone
  name: virtualNetworkLinksSuffixBlobStorageName
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

resource privateStorageQueueDnsZoneName_virtualNetworkLinksSuffixQueueStorage 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateStorageQueueDnsZone
  name: virtualNetworkLinksSuffixQueueStorageName
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

resource privateStorageTableDnsZoneName_virtualNetworkLinksSuffixTableStorage 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateStorageTableDnsZone
  name: virtualNetworkLinksSuffixTableStorageName
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}
