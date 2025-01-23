param location string
param vnetAddressPrefix string
param subnetASEAddressPrefix string
param subnetPEAddressPrefix string
param routeTableId string

resource nsgAse 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-ase'
  location: location
  properties: {
    securityRules: [
      {
        name: 'SSL_WEB_443'
        properties: {
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
          priority: 100
        }
      }
    ]
  }
}

resource nsgPe 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-pe'
  location: location
  properties: {
    securityRules: []
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'vnet-ase'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: 'snet-ase'
        properties: {
          addressPrefix: subnetASEAddressPrefix
          delegations: [
            {
              name: 'Microsoft.Web.hostingEnvironments'
              properties: {
                serviceName: 'Microsoft.Web/hostingEnvironments'
              }
            }
          ]
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          networkSecurityGroup: {
            id: nsgAse.id
          }
          routeTable: {
            id: routeTableId
          }
        }
      }
      {
        name: 'snet-pe'
        properties: {
          addressPrefix: subnetPEAddressPrefix
          networkSecurityGroup: {
            id: nsgPe.id
          }
          privateLinkServiceNetworkPolicies: 'Enabled'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

output vnetName string = vnet.name
output vnetId string = vnet.id
output subnetASEId string = vnet.properties.subnets[0].id
output subnetPEId string = vnet.properties.subnets[1].id
