using 'main.bicep'

param hubResourceGroupName = 'rg-hub-ase'

param hubVnetAddressPrefix = '10.0.0.0/16'

param subnetFirewalladdressPrefix = '10.0.1.0/26'

param subnetManagementFirewalladdressPrefix = '10.0.2.0/24'

param subnetJumpboxaddressPrefix = '10.0.3.0/28'

param subnetRunneraddressPrefix = '10.0.4.0/28'

param subnetBastionPrefix = '10.0.5.0/26'

param location = 'canadacentral'

param spokeResourceGroupName = 'rg-spoke-ase'

param subnetASEAddressPrefix = '11.0.1.0/24'

param subnetPEAddressPrefix = '11.0.2.0/24'

param vnetASEAddressPrefix = '11.0.0.0/16'

param adminPassword = '__adminPassword__'

param adminUsername = '__adminUsername__'

// Integration stack to includes

param createLogicApp = true

param createAzureServiceBus = true

//param createAPIM = true
