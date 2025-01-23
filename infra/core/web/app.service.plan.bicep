param suffix string
param location string
param aseId string

resource asp 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: 'asp-${suffix}'
  location: location
  properties: {
    hostingEnvironmentProfile: {
      id: aseId
    }
    zoneRedundant: false
  }
  sku: {
    name: 'I1V2'
    tier: 'IsolatedV2'
  }
}

output aspId string = asp.id
