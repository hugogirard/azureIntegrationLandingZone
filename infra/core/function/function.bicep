param name string
param location string
param storageName string
param appInsightName string
param aspId string

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightName
}

resource function 'Microsoft.Web/sites@2024-04-01' = {
  name: name
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet-isolated'
        }
        {
          name: 'WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED'
          value: '1'
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
        // This will not work if the storage account is in a sovereign cloud or has a custom DNS.
        // https://techcommunity.microsoft.com/blog/appsonazureblog/use-managed-identity-instead-of-azurewebjobsstorage-to-connect-a-function-app-to/3657606
        {
          name: 'AzureWebJobsStorage__accountname'
          value: storageName
        }
      ]
      cors: {
        allowedOrigins: [
          'https://portal.azure.com'
        ]
      }
      use32BitWorkerProcess: false
      ftpsState: 'FtpsOnly'
      alwaysOn: true
      netFrameworkVersion: 'v8.0'
    }
    httpsOnly: true
    clientAffinityEnabled: false
    serverFarmId: aspId
  }
}

resource scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-04-01' = {
  parent: function
  name: 'scm'
  properties: {
    allow: true
  }
}

resource ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-04-01' = {
  parent: function
  name: 'ftp'
  properties: {
    allow: true
  }
}

output functionPrincipalId string = function.identity.principalId
