targetScope = 'subscription'

@minLength(4)
@maxLength(20)
@description('Resource group name for the spoke')
param spokeResourceGroupName string

@minLength(4)
@maxLength(20)
@description('Resource group name for the hub')
param hubResourceGroupName string

@secure()
param adminUsername string

@secure()
param adminPassword string

@minLength(1)
@description('Primary location for all resources')
param location string

@description('Address prefix for the virtual network that will contain the ASE v3')
param vnetASEAddressPrefix string

@description('Address prefix for the subnet that will contain the ASE v3')
param subnetASEAddressPrefix string

@description('Address prefix for the subnet that will contain the private endpoint')
param subnetPEAddressPrefix string

@description('Address prefix for the virtual network that will contain the hub')
param hubVnetAddressPrefix string

@description('Address prefix for the subnet that will contain the firewall')
param subnetFirewalladdressPrefix string

@description('Address prefix for the subnet that will contain the management firewall')
param subnetManagementFirewalladdressPrefix string

@description('Address prefix for the subnet that will contain the jumpbox')
param subnetJumpboxaddressPrefix string

@description('Address prefix for the subnet that will contain the runner')
param subnetRunneraddressPrefix string

@description('Address prefix for the subnet that will contain the Bastion')
param subnetBastionPrefix string

@description('Create a logic app and ASP plan related to it')
param createLogicApp bool

var tags = {
  SecurityControl: 'Ignore'
}

var suffix = replace(uniqueString(rgSpoke.id), '-', '')
var privateStorageFileDnsZoneName = 'privatelink.file.${environment().suffixes.storage}'
var privateStorageBlobDnsZoneName = 'privatelink.blob.${environment().suffixes.storage}'
var privateStorageQueueDnsZoneName = 'privatelink.queue.${environment().suffixes.storage}'
var privateStorageTableDnsZoneName = 'privatelink.table.${environment().suffixes.storage}'
var privateDFSDnsZoneName = 'privatelink.dfs.${environment().suffixes.storage}'

resource rgSpoke 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: spokeResourceGroupName
  location: location
}

resource rgHub 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: hubResourceGroupName
  location: location
}

// Networking and peerings (Hub and spoke)

module spokeVnet 'core/network/spoke.bicep' = {
  scope: rgSpoke
  name: 'spokeVnet'
  params: {
    location: location
    subnetASEAddressPrefix: subnetASEAddressPrefix
    subnetPEAddressPrefix: subnetPEAddressPrefix
    vnetAddressPrefix: vnetASEAddressPrefix
    routeTableId: route.outputs.routeTableId
  }
}

module hubVnet 'core/network/hub.bicep' = {
  name: 'hubVnet'
  scope: rgHub
  params: {
    location: location
    addressPrefixe: hubVnetAddressPrefix
    subnetFirewalladdressPrefix: subnetFirewalladdressPrefix
    subnetJumpboxaddressPrefix: subnetJumpboxaddressPrefix
    subnetManagementFirewalladdressPrefix: subnetManagementFirewalladdressPrefix
    subnetRunneraddressPrefix: subnetRunneraddressPrefix
    subnetBastionPrefix: subnetBastionPrefix
  }
}

module hubToSpokePeering 'core/network/peering.bicep' = {
  scope: rgHub
  name: 'hubToSpokePeering'
  params: {
    existingLocalVirtualNetworkName: hubVnet.name
    remoteVnetId: spokeVnet.outputs.vnetId
  }
}

module spokeToHubPeering 'core/network/peering.bicep' = {
  scope: rgSpoke
  name: 'spokeToHubPeering'
  params: {
    existingLocalVirtualNetworkName: spokeVnet.name
    remoteVnetId: hubVnet.outputs.vnetId
  }
}

// End Networking

module storage 'core/storage/storage.bicep' = {
  name: 'storage'
  scope: rgSpoke
  params: {
    location: location
    storageName: 'str${suffix}'
    tags: tags
  }
}

module datalake 'core/storage/datalake.bicep' = {
  scope: rgSpoke
  name: 'datalake'
  params: {
    name: 'dl${suffix}'
    location: location
  }
}

module dnsZoneDFS 'core/DNS/datalake.privatednszone.bicep' = {
  scope: rgHub
  name: 'dnsZoneDFS'
  params: {
    name: privateDFSDnsZoneName
  }
}

module datalakePrivateEndpoint 'core/DNS/datalake.private.endpoint.bicep' = {
  scope: rgSpoke
  name: 'datalakePrivateEndpoint'
  params: {
    location: location
    privateStorageBlobDnsZoneId: dnsZoneDFS.outputs.dfsZoneId
    storageId: datalake.outputs.datalakeStorageId
    storageName: datalake.outputs.datalakeName
    subnetId: spokeVnet.outputs.subnetPEId
  }
}

module privateDnsZoneStorage 'core/DNS/storage.dns.zone.bicep' = {
  name: 'dnszonestorage'
  scope: rgHub
  params: {
    privateStorageBlobDnsZoneName: privateStorageBlobDnsZoneName
    privateStorageFileDnsZoneName: privateStorageFileDnsZoneName
    privateStorageQueueDnsZoneName: privateStorageQueueDnsZoneName
    privateStorageTableDnsZoneName: privateStorageTableDnsZoneName
  }
}

module storageVirtualLink 'core/DNS/storage.virtual.link.bicep' = {
  scope: rgHub
  name: 'virtualLinkSpoke'
  params: {
    privateStorageBlobDnsZoneName: privateStorageBlobDnsZoneName
    privateStorageFileDnsZoneName: privateStorageFileDnsZoneName
    privateStorageQueueDnsZoneName: privateStorageQueueDnsZoneName
    privateStorageTableDnsZoneName: privateStorageTableDnsZoneName
    vnetName: spokeVnet.outputs.vnetName
    vnetRgName: rgSpoke.name
  }
}

module hubVirtualLink 'core/DNS/storage.virtual.link.bicep' = {
  scope: rgHub
  name: 'virtualLinkhub'
  params: {
    privateStorageBlobDnsZoneName: privateStorageBlobDnsZoneName
    privateStorageFileDnsZoneName: privateStorageFileDnsZoneName
    privateStorageQueueDnsZoneName: privateStorageQueueDnsZoneName
    privateStorageTableDnsZoneName: privateStorageTableDnsZoneName
    vnetName: hubVnet.outputs.vnetName
    vnetRgName: rgHub.name
  }
}

module storagePrivateEndpoint 'core/DNS/storage.privateEndpoint.bicep' = {
  scope: rgSpoke
  name: 'recordstorage'
  params: {
    location: location
    privateStorageBlobDnsZoneId: privateDnsZoneStorage.outputs.privateStorageBlobDnsZoneId
    privateStorageFileDnsZoneId: privateDnsZoneStorage.outputs.privateStorageFileDnsZoneId
    privateStorageQueueDnsZoneId: privateDnsZoneStorage.outputs.privateStorageQueueDnsZoneId
    privateStorageTableDnsZoneId: privateDnsZoneStorage.outputs.privateStorageTableDnsZoneId
    storageId: storage.outputs.storageId
    storageName: storage.outputs.storageName
    subnetId: spokeVnet.outputs.subnetPEId
  }
}

module ase 'core/ase/ase.bicep' = {
  scope: rgSpoke
  name: 'ase'
  params: {
    location: location
    subnetId: spokeVnet.outputs.subnetASEId
    aseName: 'ase-${suffix}'
    vnetId: spokeVnet.outputs.vnetId
  }
}

module firewall 'core/firewall/firewall.bicep' = {
  scope: rgHub
  name: 'firewall'
  params: {
    suffix: suffix
    location: location
    subnetId: hubVnet.outputs.firewallSubnetId
    managementSubnetId: hubVnet.outputs.managementFirewallSubnetId
  }
}

module route 'core/network/route.table.bicep' = {
  scope: rgSpoke
  name: 'route'
  params: {
    location: location
    fwPrivateIP: firewall.outputs.privateIP
  }
}

module jumpbox 'core/compute/jumpbox.bicep' = {
  scope: rgHub
  name: 'jumpbox'
  params: {
    location: location
    adminPassword: adminPassword
    adminUsername: adminUsername
    subnetId: hubVnet.outputs.jumpboxSubnetId
  }
}

module aRecordDFSDNS 'core/DNS/storage.record.bicep' = {
  scope: rgHub
  name: 'aRecordDFSDNS'
  params: {
    name: jumpbox.outputs.jumpboxName
    dnsName: privateDnsZoneStorage.outputs.privateStorageBlobDnsZoneName
    privateEndpointIP: jumpbox.outputs.privateJumpboxIp
  }
}

module aRecordJumpboxASE 'core/ase/record.dns.bicep' = {
  scope: rgSpoke
  name: 'aRecordJumpboxASE'
  params: {
    dnsZoneName: ase.outputs.dnsName
    privateIpRecord: jumpbox.outputs.privateJumpboxIp
    recordName: jumpbox.outputs.jumpboxName
  }
}

module runner 'core/compute/runner.bicep' = {
  scope: rgHub
  name: 'runner'
  params: {
    location: location
    adminPassword: adminPassword
    adminUsername: adminUsername
    subnetId: hubVnet.outputs.runnerSubnetId
  }
}

module aRecordRunnerASE 'core/ase/record.dns.bicep' = {
  scope: rgSpoke
  name: 'aRecordRunnerASE'
  params: {
    dnsZoneName: ase.outputs.dnsName
    privateIpRecord: runner.outputs.privateIps
    recordName: runner.outputs.vmName
  }
}

module hubDFSLinkStorage 'core/DNS/datalake.privatednszone.bicep' = {
  scope: rgHub
  name: 'hubDFSLinkStorage'
  params: {
    name: dnsZoneDFS.outputs.dfsZoneName
  }
}

module privateEndpointDatalake 'core/DNS/datalake.private.endpoint.bicep' = {
  scope: rgSpoke
  name: 'privateEndpointDatalake'
  params: {
    location: location
    privateStorageBlobDnsZoneId: hubDFSLinkStorage.outputs.dfsZoneId
    storageId: datalake.outputs.datalakeStorageId
    storageName: datalake.outputs.datalakeName
    subnetId: spokeVnet.outputs.subnetPEId
  }
}

module logging 'core/monitoring/appinsight.bicep' = {
  scope: rgSpoke
  name: 'logging'
  params: {
    suffix: suffix
    location: location
  }
}

module asp 'core/web/app.service.plan.bicep' = {
  scope: rgSpoke
  name: 'asp'
  params: {
    suffix: suffix
    location: location
    aseId: ase.outputs.aseId
  }
}

module logicApp 'core/web/logicapp.bicep' = if (createLogicApp) {
  scope: rgSpoke
  name: 'logicapp'
  params: {
    name: 'lga-${suffix}'
    location: location
    appInsightName: logging.outputs.appInsightsName
    aspId: asp.outputs.aspId
    storageAccountName: storage.outputs.storageName
  }
}

// module function 'core/function/function.bicep' = {
//   scope: rgSpoke
//   name: 'function'
//   params: {
//     name: 'func-${suffix}'
//     location: location
//     appInsightName: logging.outputs.appInsightsName
//     aspId: asp.outputs.aspId
//     storageName: storage.outputs.storageName
//   }
// }

// module rbacFunction 'core/function/rbac.bicep' = {
//   scope: rgSpoke
//   name: 'rbacFunction'
//   params: {
//     objectId: function.outputs.functionPrincipalId
//     storageName: storage.outputs.storageName
//   }
// }
