param location string
param suffix string

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2024-01-01' = {
  name: 'srv-${suffix}'
  location: location
  sku: {
    name: 'Premium'
    tier: 'Premium'
  }
  properties: {}
}
