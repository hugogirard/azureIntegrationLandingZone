param dnsZoneName string
param vnetName string
param vnetRgName string

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetRgName)
}

resource dnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: dnsZoneName
}

var virtualNetworkLinksSuffixFileStorageName = '${dnsZoneName}-link-${vnetName}'

resource privateStorageDFSDnsZoneName_virtualNetworkLinksSuffixDFSStorage 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: dnsZone
  name: virtualNetworkLinksSuffixFileStorageName
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}
