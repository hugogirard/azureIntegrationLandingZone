param location string
param fwPrivateIP string

resource route 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'rt-firewall'
  location: location
  properties: {
    routes: [
      {
        name: 'subnet-to-fw'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: fwPrivateIP
        }
      }
    ]
  }
}

output routeTableId string = route.id
