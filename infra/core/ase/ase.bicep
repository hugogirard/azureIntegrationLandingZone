param aseName string
param location string
param subnetId string
param vnetId string

resource asev3 'Microsoft.Web/hostingEnvironments@2024-04-01' = {
  name: aseName
  location: location
  kind: 'ASEV3'
  properties: {
    internalLoadBalancingMode: 'Web, Publishing'
    virtualNetwork: {
      id: subnetId
    }
  }
}

resource dns 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: '${aseName}.appserviceenvironment.net'
  location: 'global'
}

resource networkLinkSpoke 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: dns
  name: 'spoke'
  location: 'global'
  properties: {
    virtualNetwork: {
      id: vnetId
    }
    registrationEnabled: false
  }
}

resource aRecordAseAll 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  parent: dns
  name: '*'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: reference('${asev3.id}/configurations/networking', '2019-08-01').internalInboundIpAddresses[0]
      }
    ]
  }
}

resource aRecordAseSCM 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  parent: dns
  name: '*.scm'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: reference('${asev3.id}/configurations/networking', '2019-08-01').internalInboundIpAddresses[0]
      }
    ]
  }
}

resource aRecordAse 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  parent: dns
  name: '@'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: reference('${asev3.id}/configurations/networking', '2019-08-01').internalInboundIpAddresses[0]
      }
    ]
  }
}

output dnsName string = dns.name
output aseId string = asev3.id
output dnsId string = dns.id
