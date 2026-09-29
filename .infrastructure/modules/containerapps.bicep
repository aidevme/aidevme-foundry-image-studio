param location string
param tags object
param nameSuffix string
@allowed([ 'dev', 'test', 'prod' ])
param environmentType string
param logAnalyticsWorkspaceName string
param appInsightsName string
param registryLoginServer string
param imageMcpIdentityId string
param facadeIdentityId string
param enableAsyncJobs bool
param settings object

@description('Placeholder image until the first build is pushed.')
param bootstrapImage string = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
}

resource environment 'Microsoft.App/managedEnvironments@2025-01-01' = {
  name: 'cae-${nameSuffix}'
  location: location
  tags: tags
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalytics.properties.customerId
        sharedKey: logAnalytics.listKeys().primarySharedKey
      }
    }
    workloadProfiles: [
      { name: 'Consumption', workloadProfileType: 'Consumption' }
    ]
  }
}

var commonEnv = [
  { name: 'APPLICATIONINSIGHTS_CONNECTION_STRING', value: appInsights.properties.ConnectionString }
  { name: 'STORAGE_ACCOUNT_NAME', value: settings.storageAccountName }
  { name: 'COSMOS_ENDPOINT', value: settings.cosmosEndpoint }
  { name: 'APP_CONFIG_ENDPOINT', value: settings.appConfigEndpoint }
  { name: 'FOUNDRY_ENDPOINT', value: settings.foundryEndpoint }
  { name: 'FOUNDRY_PROJECT_ENDPOINT', value: settings.foundryProjectEndpoint }
  { name: 'CONTENT_SAFETY_ENDPOINT', value: settings.contentSafetyEndpoint }
]

resource imageMcp 'Microsoft.App/containerApps@2025-01-01' = {
  name: 'ca-image-mcp-${environmentType}'
  location: location
  tags: union(tags, { 'azd-service-name': 'image-mcp' })
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: { '${imageMcpIdentityId}': {} }
  }
  properties: {
    managedEnvironmentId: environment.id
    workloadProfileName: 'Consumption'
    configuration: {
      ingress: { external: false, targetPort: 8080, transport: 'auto' }
      registries: [ { server: registryLoginServer, identity: imageMcpIdentityId } ]
    }
    template: {
      containers: [
        {
          name: 'image-mcp'
          image: bootstrapImage
          resources: { cpu: json('0.5'), memory: '1Gi' }
          env: commonEnv
        }
      ]
      scale: { minReplicas: 1, maxReplicas: 5 }
    }
  }
}

resource facade 'Microsoft.App/containerApps@2025-01-01' = {
  name: 'ca-facade-mcp-${environmentType}'
  location: location
  tags: union(tags, { 'azd-service-name': 'facade-mcp' })
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: { '${facadeIdentityId}': {} }
  }
  properties: {
    managedEnvironmentId: environment.id
    workloadProfileName: 'Consumption'
    configuration: {
      ingress: { external: true, targetPort: 8080, transport: 'auto' }
      registries: [ { server: registryLoginServer, identity: facadeIdentityId } ]
    }
    template: {
      containers: [
        {
          name: 'facade-mcp'
          image: bootstrapImage
          resources: { cpu: json('0.5'), memory: '1Gi' }
          env: commonEnv
        }
      ]
      scale: { minReplicas: 1, maxReplicas: 5 }
    }
  }
}

resource worker 'Microsoft.App/jobs@2025-01-01' = if (enableAsyncJobs) {
  name: 'job-image-worker-${environmentType}'
  location: location
  tags: union(tags, { 'azd-service-name': 'image-worker' })
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: { '${imageMcpIdentityId}': {} }
  }
  properties: {
    environmentId: environment.id
    workloadProfileName: 'Consumption'
    configuration: {
      triggerType: 'Event'
      replicaTimeout: 900
      replicaRetryLimit: 1
      registries: [ { server: registryLoginServer, identity: imageMcpIdentityId } ]
      eventTriggerConfig: {
        parallelism: 1
        replicaCompletionCount: 1
        scale: {
          minExecutions: 0
          maxExecutions: 10
          pollingInterval: 30
          rules: [
            {
              name: 'queue-length'
              type: 'azure-servicebus'
              metadata: {
                namespace: settings.serviceBusNamespace
                queueName: 'image-jobs'
                messageCount: '5'
              }
              identity: imageMcpIdentityId
            }
          ]
        }
      }
    }
    template: {
      containers: [
        {
          name: 'worker'
          image: bootstrapImage
          resources: { cpu: json('1.0'), memory: '2Gi' }
          env: concat(commonEnv, [
            { name: 'SERVICE_BUS_NAMESPACE', value: settings.serviceBusNamespace }
          ])
        }
      ]
    }
  }
}

output facadeFqdn string = facade.properties.configuration.ingress.fqdn
output imageMcpFqdn string = imageMcp.properties.configuration.ingress.fqdn
