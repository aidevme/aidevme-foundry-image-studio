# Infrastructure provisioning with Bicep

| Field | Value |
| --- | --- |
| **Document Title** | Infrastructure provisioning with Bicep |
| **Document Location** | `docs/aidevme-foundry-image-studio/INFRASTRUCTURE.md` |
| **Document Description** | Explains how to provision every Azure service that AIDevMe Foundry Image Studio needs by using Bicep and Azure Developer CLI, including the module layout, the code for each module, the deployment procedure, and the steps that Bicep cannot perform. It is intended for the engineers who build and operate the environments. |
| **Version** | 2.2 |
| **Last Updated On** | 2026-09-29 |

## Introduction

This document describes how to provision the Azure resources listed in [ARCHITECTURE.md](ARCHITECTURE.md) (§4, §10, §17) with Bicep. It supports tasks `P0.3.1` to `P0.3.6`, `P1.5.5`, `P1.9.3`, `P1.10.1`, `P2.1.1`, `P2.8.1`, and `P4.1` to `P4.4` in the [implementation plan](IMPLEMENTATION.md).

Read this document to create an environment, to add a resource to the templates, or to diagnose a failed deployment.

> **Important:** The Bicep code in this document is implemented in `.infrastructure/` and compiles and lints without errors. The public-network `dev` variant is what is implemented: the virtual network, private endpoints, and firewall modules described below are not implemented yet. The templates have not been deployed. Resource API versions, model names and versions, SKU names, and role identifiers change over time. Verify them as described in [Verification status](#verification-status) before you deploy.

## Scope

### What Bicep provisions

Bicep provisions all Azure Resource Manager (ARM) resources: the Foundry resource and project, model deployments, storage, databases, messaging, compute, gateway, monitoring, networking, identities, and role assignments.

### What Bicep does not provision

| Item | Reason | How it is handled |
| --- | --- | --- |
| Agent definitions (`agents/*/agent.yaml`) | Data-plane objects, not ARM resources | Deployment script that uses the Foundry SDK (task `P1.8.2`) |
| Toolbox registration | Data-plane object | Script that applies `toolboxes/image-studio.yaml` (task `P1.6.1`) |
| Foundry IQ knowledge index and its content | Data-plane objects | Script that indexes `brand/` (task `P1.7.2`) |
| Entra ID app registration and app role `ImageStudio.User` | Microsoft Entra objects, not ARM resources | Azure CLI script, or the Microsoft Graph Bicep extension (see [Entra ID objects](#entra-id-objects)) |
| GitHub OIDC federation | Entra object | Azure CLI script (see [Continuous deployment](#continuous-deployment)) |
| Model access approval and quota | Requests to Microsoft | Manual steps (task `P0.4.1`, `P0.4.2`) |

## Services to provision

The templates provision the services below. The phase column shows when each service is first required, and the flag column shows the Bicep parameter that controls optional services.

| Service | Purpose | Phase | Module | Flag |
| --- | --- | --- | --- | --- |
| Resource group | Container for the environment | 0 | `main.bicep` | None |
| Log Analytics workspace | Log store | 0 | `monitoring.bicep` | None |
| Application Insights | Traces and metrics | 0 | `monitoring.bicep` | None |
| User-assigned managed identities | Identity for the facade and the Image MCP server | 0 | `identity.bicep` | None |
| Storage account | Assets, inputs, brand files, icon cache | 0 | `storage.bicep` | None |
| Cosmos DB account | Job store | 0 | `cosmos.bicep` | None |
| Key Vault | External provider key | 0 | `keyvault.bicep` | None |
| App Configuration | Routing table | 0 | `appconfig.bicep` | None |
| Content Safety | Prompt and output moderation | 0 | `foundry.bicep` | None |
| Foundry resource, project, model deployments | Agents and image models | 0 | `foundry.bicep` | None |
| Azure AI Search | Foundry IQ brand knowledge | 1 | `search.bicep` | None |
| Container Registry | Container images | 1 | `registry.bicep` | None |
| Container Apps environment and apps | Image MCP server and facade | 1 | `containerapps.bicep` | None |
| API Management | AI gateway | 1 | `apim.bicep` | None |
| Service Bus namespace and queue | Asynchronous jobs | 2 | `servicebus.bicep` | `enableAsyncJobs` |
| Container Apps job | Worker | 2 | `containerapps.bicep` | `enableAsyncJobs` |
| Virtual network, private endpoints, private DNS | Private networking | 4 (and `test`) | `network.bicep` | `enablePrivateNetworking` |
| Azure Firewall | Egress control | 4 | `firewall.bicep` | `enableExternalProvider` |

## Prerequisites

### Accounts and permissions

| Requirement | Detail |
| --- | --- |
| Azure subscription | A subscription per environment is recommended. At minimum, one resource group per environment. |
| Deployment role | `Contributor` and `User Access Administrator` (or `Owner`) on the subscription or resource group. The templates create role assignments, which requires the second role. |
| Entra ID permission | Permission to create app registrations (for the Entra ID objects). |
| Model access | Approved access for every model that needs limited-access approval (`P0.4.1`). |
| Quota | Sufficient quota per model deployment in the chosen region (`P0.4.2`). |

### Tools

Install these tools on the workstation or in the CI runner.

| Tool | Use | Check |
| --- | --- | --- |
| Azure CLI (`az`) | Authentication and deployment | `az version` |
| Bicep CLI | Compile and lint templates | `az bicep version` |
| Azure Developer CLI (`azd`) | Environment orchestration | `azd version` |
| Visual Studio Code with the Bicep extension | Authoring | Extension is installed |

Install or update Bicep through the Azure CLI:

```bash
az bicep install
az bicep upgrade
```

### Resource providers

Register the providers once per subscription. Registration can take several minutes.

```bash
az provider register --namespace Microsoft.CognitiveServices
az provider register --namespace Microsoft.Storage
az provider register --namespace Microsoft.DocumentDB
az provider register --namespace Microsoft.KeyVault
az provider register --namespace Microsoft.AppConfiguration
az provider register --namespace Microsoft.Search
az provider register --namespace Microsoft.ContainerRegistry
az provider register --namespace Microsoft.App
az provider register --namespace Microsoft.ApiManagement
az provider register --namespace Microsoft.ServiceBus
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace Microsoft.Insights
az provider register --namespace Microsoft.Network
az provider show --namespace Microsoft.CognitiveServices --query registrationState
```

The last command must return `"Registered"`.

## Repository layout

Infrastructure code lives in `.infrastructure/` (the architecture, §17.2 and §18, names the folder `infra/`; the repository uses `.infrastructure/` instead). GitHub Actions runs workflows only from `.github/workflows/`, so the deployment workflows are stored there and reference the templates in `.infrastructure/`.

```text
azure.yaml                          # azd project definition (not created yet)
.github/workflows/
├── infra-validate.yml              # pull request: lint, build, what-if
└── infra-deploy.yml                # manual run only: deploy
.infrastructure/
├── main.bicep                      # subscription-scope entry point
├── main.dev.bicepparam             # parameters per environment
├── main.test.bicepparam
├── main.prod.bicepparam
├── bicepconfig.json                # linter rules
└── modules/
    ├── monitoring.bicep
    ├── identity.bicep
    ├── storage.bicep
    ├── cosmos.bicep
    ├── keyvault.bicep
    ├── appconfig.bicep
    ├── foundry.bicep               # Foundry resource, project, model deployments, Content Safety
    ├── search.bicep
    ├── registry.bicep
    ├── containerapps.bicep         # environment, apps, worker job
    ├── servicebus.bicep
    ├── apim.bicep
    ├── network.bicep               # VNet, private endpoints, private DNS
    ├── firewall.bicep
    └── rbac.bicep                  # role assignments
```

## Design conventions

Apply these rules to every module.

1. **Identity first.** Disable key-based and local authentication wherever the service allows it. Services authenticate with managed identities and data-plane RBAC (§10.1).
2. **One module per service group.** A module has typed parameters, and it returns only the outputs that other modules need (resource identifiers, names, endpoints, principal identifiers).
3. **No secrets in outputs or parameter files.** Do not output keys or connection strings.
4. **Deterministic names.** Build names from an abbreviation, the environment name, and a `uniqueString` token so that global names (storage, Key Vault, Cosmos DB) do not collide.
5. **Tags on every resource.** Use the tags `environment`, `application`, and `owner`.
6. **Pinned model versions.** Set `versionUpgradeOption` to `NoAutoUpgrade` (§6.4, ADR-006).
7. **Optional services use flags.** A boolean parameter switches a service on, so `dev` stays small and `test` and `prod` add asynchronous jobs and private networking.
8. **Secure defaults, then relax for `dev`.** Modules default to the secure setting (for example, public network access disabled), and the `dev` parameter file relaxes a setting only when it is required, for example an IP allowlist.
9. **API versions are explicit.** Every resource declares an API version. Update versions deliberately, and run a `what-if` after each update.

### Naming

Every environment-specific resource name contains the environment type (`dev`, `test`, or `prod`) and a 13-character unique token. The token is `toLower(uniqueString(subscription().id, environmentName, location))`. It is the same for every deployment to the same subscription, environment, and region.

`main.bicep` builds two suffixes:

```bicep
var nameSuffix = '${environmentType}-${resourceToken}'        // for example dev-abc123def4567
var nameSuffixCompact = '${environmentType}${resourceToken}'  // for example devabc123def4567
```

Storage accounts and container registries do not allow hyphens, so they use the compact suffix. All other services use the hyphenated suffix. The longest suffix (`prod-` plus the token, 18 characters) keeps every name within its service limit, for example 20 characters for a storage account (limit 24) and 21 for a Key Vault (limit 24).

| Resource | Name pattern | Example for `dev` |
| --- | --- | --- |
| Resource group | `rg-image-studio-<env>` | `rg-image-studio-dev` |
| Log Analytics workspace | `log-<env>-<token>` | `log-dev-<token>` |
| Application Insights | `appi-<env>-<token>` | `appi-dev-<token>` |
| Managed identities | `id-image-mcp-<env>`, `id-facade-<env>` | `id-image-mcp-dev` |
| Storage account | `st<env><token>` | `stdev<token>` |
| Cosmos DB account | `cosmos-<env>-<token>` | `cosmos-dev-<token>` |
| Key Vault | `kv-<env>-<token>` | `kv-dev-<token>` |
| App Configuration | `appcs-<env>-<token>` | `appcs-dev-<token>` |
| Foundry resource | `ais-<env>-<token>` | `ais-dev-<token>` |
| Content Safety | `cs-<env>-<token>` | `cs-dev-<token>` |
| Azure AI Search | `srch-<env>-<token>` | `srch-dev-<token>` |
| Container Registry | `cr<env><token>` | `crdev<token>` |
| Container Apps environment | `cae-<env>-<token>` | `cae-dev-<token>` |
| Container apps | `ca-image-mcp-<env>`, `ca-facade-mcp-<env>` | `ca-image-mcp-dev` |
| Container Apps job | `job-image-worker-<env>` | `job-image-worker-dev` |
| Service Bus namespace | `sb-<env>-<token>` | `sb-dev-<token>` |
| API Management | `apim-<env>-<token>` | `apim-dev-<token>` |

Names inside a service (Foundry project `image-studio`, Cosmos DB database `image-studio` and container `jobs`, queue `image-jobs`, and the model deployment names) do not contain the environment, because they are already scoped to an environment-specific parent resource.

> **Note:** The module code samples later in this document were written before the naming change and use a `resourceToken` parameter. The files in `.infrastructure/modules/` are the source of truth. They use `nameSuffix` (and `nameSuffixCompact` for Storage and Container Registry).

## Entry point: `main.bicep`

The template runs at subscription scope, so it can create the resource group.

```bicep
targetScope = 'subscription'

@minLength(1)
@maxLength(12)
@description('Short name of the environment, for example dev, test, or prod.')
param environmentName string

@allowed([ 'dev', 'test', 'prod' ])
param environmentType string

@description('Azure region for all resources. Decision D1 selects the region.')
param location string

@description('Object ID of the person or service principal that runs the deployment. Used for data-plane access during setup.')
param deployerPrincipalId string = ''

param enableAsyncJobs bool = false
param enablePrivateNetworking bool = false
param enableExternalProvider bool = false

@description('Image and reasoning model deployments. See the parameter files.')
param modelDeployments array

@description('IP addresses allowed to reach services while public access is enabled (dev only).')
param allowedIpAddresses array = []

param tags object = {}

var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var allTags = union(tags, {
  application: 'aidevme-foundry-image-studio'
  environment: environmentType
})

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: 'rg-image-studio-${environmentName}'
  location: location
  tags: allTags
}

module monitoring 'modules/monitoring.bicep' = {
  scope: rg
  name: 'monitoring'
  params: {
    location: location
    tags: allTags
    resourceToken: resourceToken
  }
}

module identity 'modules/identity.bicep' = {
  scope: rg
  name: 'identity'
  params: {
    location: location
    tags: allTags
    environmentName: environmentName
  }
}

module network 'modules/network.bicep' = if (enablePrivateNetworking) {
  scope: rg
  name: 'network'
  params: {
    location: location
    tags: allTags
    environmentName: environmentName
  }
}

module storage 'modules/storage.bicep' = {
  scope: rg
  name: 'storage'
  params: {
    location: location
    tags: allTags
    resourceToken: resourceToken
    allowedIpAddresses: allowedIpAddresses
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    logAnalyticsWorkspaceId: monitoring.outputs.logAnalyticsId
  }
}

module cosmos 'modules/cosmos.bicep' = {
  scope: rg
  name: 'cosmos'
  params: {
    location: location
    tags: allTags
    resourceToken: resourceToken
    allowedIpAddresses: allowedIpAddresses
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
  }
}

module keyVault 'modules/keyvault.bicep' = {
  scope: rg
  name: 'keyvault'
  params: {
    location: location
    tags: allTags
    resourceToken: resourceToken
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
  }
}

module appConfig 'modules/appconfig.bicep' = {
  scope: rg
  name: 'appconfig'
  params: {
    location: location
    tags: allTags
    resourceToken: resourceToken
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
  }
}

module foundry 'modules/foundry.bicep' = {
  scope: rg
  name: 'foundry'
  params: {
    location: location
    tags: allTags
    resourceToken: resourceToken
    modelDeployments: modelDeployments
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
  }
}

module search 'modules/search.bicep' = {
  scope: rg
  name: 'search'
  params: {
    location: location
    tags: allTags
    resourceToken: resourceToken
    publicNetworkAccess: enablePrivateNetworking ? 'disabled' : 'enabled'
  }
}

module registry 'modules/registry.bicep' = {
  scope: rg
  name: 'registry'
  params: {
    location: location
    tags: allTags
    resourceToken: resourceToken
  }
}

module serviceBus 'modules/servicebus.bicep' = if (enableAsyncJobs) {
  scope: rg
  name: 'servicebus'
  params: {
    location: location
    tags: allTags
    resourceToken: resourceToken
  }
}

module containerApps 'modules/containerapps.bicep' = {
  scope: rg
  name: 'containerapps'
  params: {
    location: location
    tags: allTags
    resourceToken: resourceToken
    logAnalyticsWorkspaceName: monitoring.outputs.logAnalyticsName
    appInsightsConnectionString: monitoring.outputs.appInsightsConnectionString
    registryLoginServer: registry.outputs.loginServer
    imageMcpIdentityId: identity.outputs.imageMcpId
    facadeIdentityId: identity.outputs.facadeId
    enableAsyncJobs: enableAsyncJobs
    infrastructureSubnetId: enablePrivateNetworking ? network.outputs.containerAppsSubnetId : ''
    settings: {
      storageAccountName: storage.outputs.name
      cosmosEndpoint: cosmos.outputs.endpoint
      appConfigEndpoint: appConfig.outputs.endpoint
      foundryEndpoint: foundry.outputs.endpoint
      foundryProjectEndpoint: foundry.outputs.projectEndpoint
      contentSafetyEndpoint: foundry.outputs.contentSafetyEndpoint
      serviceBusNamespace: enableAsyncJobs ? serviceBus.outputs.namespaceName : ''
    }
  }
}

module apim 'modules/apim.bicep' = {
  scope: rg
  name: 'apim'
  params: {
    location: location
    tags: allTags
    resourceToken: resourceToken
    facadeFqdn: containerApps.outputs.facadeFqdn
    appInsightsId: monitoring.outputs.appInsightsId
    appInsightsInstrumentationKey: monitoring.outputs.appInsightsInstrumentationKey
    virtualNetworkType: enablePrivateNetworking ? 'Internal' : 'None'
    subnetId: enablePrivateNetworking ? network.outputs.apimSubnetId : ''
  }
}

module rbac 'modules/rbac.bicep' = {
  scope: rg
  name: 'rbac'
  params: {
    imageMcpPrincipalId: identity.outputs.imageMcpPrincipalId
    facadePrincipalId: identity.outputs.facadePrincipalId
    deployerPrincipalId: deployerPrincipalId
    storageAccountName: storage.outputs.name
    cosmosAccountName: cosmos.outputs.accountName
    keyVaultName: keyVault.outputs.name
    appConfigName: appConfig.outputs.name
    foundryAccountName: foundry.outputs.accountName
    foundryProjectName: foundry.outputs.projectName
    contentSafetyAccountName: foundry.outputs.contentSafetyAccountName
    searchServiceName: search.outputs.name
    registryName: registry.outputs.name
    serviceBusNamespaceName: enableAsyncJobs ? serviceBus.outputs.namespaceName : ''
    enableAsyncJobs: enableAsyncJobs
    enableExternalProvider: enableExternalProvider
  }
}

output resourceGroupName string = rg.name
output apimGatewayUrl string = apim.outputs.gatewayUrl
output foundryProjectEndpoint string = foundry.outputs.projectEndpoint
output storageAccountName string = storage.outputs.name
output cosmosEndpoint string = cosmos.outputs.endpoint
output appConfigEndpoint string = appConfig.outputs.endpoint
output containerRegistryLoginServer string = registry.outputs.loginServer
```

> **Note:** A circular dependency exists between `containerApps` (which needs identity identifiers) and `rbac` (which needs the same identities). The identities are created first in `identity.bicep`, so both modules depend on `identity` but not on each other. Keep it that way.

## Modules

Each subsection shows the Bicep code for one module and explains the decisions.

### `monitoring.bicep`

```bicep
param location string
param tags object
param resourceToken string

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'log-${resourceToken}'
  location: location
  tags: tags
  properties: {
    sku: { name: 'PerGB2018' }
    retentionInDays: 30
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-${resourceToken}'
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id
    DisableLocalAuth: true
  }
}

output logAnalyticsId string = logAnalytics.id
output logAnalyticsName string = logAnalytics.name
output appInsightsId string = appInsights.id
output appInsightsConnectionString string = appInsights.properties.ConnectionString
output appInsightsInstrumentationKey string = appInsights.properties.InstrumentationKey
```

`DisableLocalAuth: true` requires clients to send telemetry with Entra authentication. If the OpenTelemetry exporter is not configured for it, set the value to `false` in `dev` only.

### `identity.bicep`

```bicep
param location string
param tags object
param environmentName string

resource imageMcp 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'id-image-mcp-${environmentName}'
  location: location
  tags: tags
}

resource facade 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'id-facade-${environmentName}'
  location: location
  tags: tags
}

output imageMcpId string = imageMcp.id
output imageMcpPrincipalId string = imageMcp.properties.principalId
output imageMcpClientId string = imageMcp.properties.clientId
output facadeId string = facade.id
output facadePrincipalId string = facade.properties.principalId
output facadeClientId string = facade.properties.clientId
```

The identities exist before the Container Apps, so role assignments can be created without a circular dependency. The worker job reuses the Image MCP identity.

### `storage.bicep`

```bicep
param location string
param tags object
param resourceToken string
param allowedIpAddresses array
param publicNetworkAccess string
param logAnalyticsWorkspaceId string

resource account 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: 'st${resourceToken}'
  location: location
  tags: tags
  sku: { name: 'Standard_ZRS' }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    defaultToOAuthAuthentication: true
    supportsHttpsTrafficOnly: true
    publicNetworkAccess: publicNetworkAccess
    networkAcls: {
      defaultAction: publicNetworkAccess == 'Enabled' && !empty(allowedIpAddresses) ? 'Deny' : 'Allow'
      bypass: 'AzureServices'
      ipRules: [for ip in allowedIpAddresses: { value: ip, action: 'Allow' }]
    }
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: account
  name: 'default'
  properties: {
    deleteRetentionPolicy: { enabled: true, days: 7 }
    containerDeleteRetentionPolicy: { enabled: true, days: 7 }
  }
}

var containers = [ 'assets', 'inputs', 'brand', 'icons' ]

resource blobContainers 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = [for name in containers: {
  parent: blobService
  name: name
  properties: { publicAccess: 'None' }
}]

resource lifecycle 'Microsoft.Storage/storageAccounts/managementPolicies@2023-05-01' = {
  parent: account
  name: 'default'
  properties: {
    policy: {
      rules: [
        {
          name: 'delete-inputs-after-7-days'
          enabled: true
          type: 'Lifecycle'
          definition: {
            filters: { blobTypes: [ 'blockBlob' ], prefixMatch: [ 'inputs/' ] }
            actions: { baseBlob: { delete: { daysAfterModificationGreaterThan: 7 } } }
          }
        }
        {
          name: 'cool-assets-after-30-days'
          enabled: true
          type: 'Lifecycle'
          definition: {
            filters: { blobTypes: [ 'blockBlob' ], prefixMatch: [ 'assets/' ] }
            actions: { baseBlob: { tierToCool: { daysAfterModificationGreaterThan: 30 } } }
          }
        }
      ]
    }
  }
}

resource diagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'send-to-log-analytics'
  scope: blobService
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      { categoryGroup: 'allLogs', enabled: true }
    ]
  }
}

output name string = account.name
output id string = account.id
```

The settings implement §9.1: private containers, a seven-day retention for `inputs/`, cool tier for `assets/` after 30 days, and no account keys. Because `allowSharedKeyAccess` is `false`, the Image MCP server creates user-delegation SAS URLs with its identity (roles `Storage Blob Data Contributor` and `Storage Blob Delegator`). Tools that rely on account keys, including the Azure portal's default key-based access, fail. Use Entra authentication.

### `cosmos.bicep`

```bicep
param location string
param tags object
param resourceToken string
param allowedIpAddresses array
param publicNetworkAccess string

resource account 'Microsoft.DocumentDB/databaseAccounts@2024-05-15' = {
  name: 'cosmos-${resourceToken}'
  location: location
  tags: tags
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    disableLocalAuth: true
    publicNetworkAccess: publicNetworkAccess
    ipRules: [for ip in allowedIpAddresses: { ipAddressOrRange: ip }]
    consistencyPolicy: { defaultConsistencyLevel: 'Session' }
    locations: [
      { locationName: location, failoverPriority: 0, isZoneRedundant: false }
    ]
    capabilities: [
      { name: 'EnableServerless' }
    ]
  }
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2024-05-15' = {
  parent: account
  name: 'image-studio'
  properties: {
    resource: { id: 'image-studio' }
  }
}

resource jobs 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2024-05-15' = {
  parent: database
  name: 'jobs'
  properties: {
    resource: {
      id: 'jobs'
      partitionKey: { paths: [ '/tenantId' ], kind: 'Hash' }
      defaultTtl: -1
      indexingPolicy: {
        indexingMode: 'consistent'
        includedPaths: [ { path: '/*' } ]
        compositeIndexes: [
          [
            { path: '/userId', order: 'ascending' }
            { path: '/createdAt', order: 'descending' }
          ]
        ]
      }
    }
  }
}

output accountName string = account.name
output endpoint string = account.properties.documentEndpoint
```

The container implements §9.2 and the composite index from gap G-4 (`/userId` and `/createdAt`) that `list_recent_visuals` needs. `defaultTtl: -1` enables per-item time to live, so individual records can set `ttl` (§9.2). Serverless mode suits `dev` and low volume. For `prod`, replace `EnableServerless` with provisioned throughput or autoscale after you measure the load. Cosmos DB does not allow switching an existing account between serverless and provisioned, so decide before you create the `prod` account.

### `keyvault.bicep`

```bicep
param location string
param tags object
param resourceToken string
param publicNetworkAccess string

resource vault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: 'kv-${resourceToken}'
  location: location
  tags: tags
  properties: {
    tenantId: subscription().tenantId
    sku: { family: 'A', name: 'standard' }
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 30
    enablePurgeProtection: true
    publicNetworkAccess: publicNetworkAccess
    networkAcls: { defaultAction: 'Allow', bypass: 'AzureServices' }
  }
}

output name string = vault.name
output uri string = vault.properties.vaultUri
```

The vault stores only the external provider key (ADR-004), so it is empty until a tenant enables that provider. With purge protection on, a deleted vault name stays reserved for 30 days. Use a new token or wait when you recreate an environment.

### `appconfig.bicep`

```bicep
param location string
param tags object
param resourceToken string
param publicNetworkAccess string

resource store 'Microsoft.AppConfiguration/configurationStores@2023-03-01' = {
  name: 'appcs-${resourceToken}'
  location: location
  tags: tags
  sku: { name: 'standard' }
  properties: {
    disableLocalAuth: true
    publicNetworkAccess: publicNetworkAccess
    softDeleteRetentionInDays: 7
  }
}

output name string = store.name
output endpoint string = store.properties.endpoint
```

The store holds the routing table from `config/routing.yaml` (task `P1.2.2`). Load the table with a post-provision step (see [After provisioning](#after-provisioning)), not with Bicep, so that routing changes go through pull requests and the evaluation gate rather than through infrastructure deployments.

### `foundry.bicep`

This module creates the Foundry resource, the project, the model deployments, and Content Safety.

```bicep
param location string
param tags object
param resourceToken string
param publicNetworkAccess string

@description('Array of { name, model, format, version, skuName, capacity }.')
param modelDeployments array

var foundryName = 'ais-${resourceToken}'
var projectName = 'image-studio'

resource account 'Microsoft.CognitiveServices/accounts@2025-06-01' = {
  name: foundryName
  location: location
  tags: tags
  kind: 'AIServices'
  sku: { name: 'S0' }
  identity: { type: 'SystemAssigned' }
  properties: {
    customSubDomainName: foundryName
    allowProjectManagement: true
    disableLocalAuth: true
    publicNetworkAccess: publicNetworkAccess
  }
}

resource project 'Microsoft.CognitiveServices/accounts/projects@2025-06-01' = {
  parent: account
  name: projectName
  location: location
  tags: tags
  identity: { type: 'SystemAssigned' }
  properties: {
    displayName: 'AIDevMe Foundry Image Studio'
    description: 'Agents and tools for governed image generation.'
  }
}

@batchSize(1)
resource deployments 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = [for d in modelDeployments: {
  parent: account
  name: d.name
  sku: { name: d.skuName, capacity: d.capacity }
  properties: {
    model: { format: d.format, name: d.model, version: d.version }
    versionUpgradeOption: 'NoAutoUpgrade'
  }
  dependsOn: [ project ]
}]

resource contentSafety 'Microsoft.CognitiveServices/accounts@2025-06-01' = {
  name: 'cs-${resourceToken}'
  location: location
  tags: tags
  kind: 'ContentSafety'
  sku: { name: 'S0' }
  identity: { type: 'SystemAssigned' }
  properties: {
    customSubDomainName: 'cs-${resourceToken}'
    disableLocalAuth: true
    publicNetworkAccess: publicNetworkAccess
  }
}

output accountName string = account.name
output endpoint string = account.properties.endpoint
output projectName string = project.name
output projectEndpoint string = 'https://${account.name}.services.ai.azure.com/api/projects/${project.name}'
output contentSafetyAccountName string = contentSafety.name
output contentSafetyEndpoint string = contentSafety.properties.endpoint
```

Points to note:

- `@batchSize(1)` serializes the deployments. Creating several deployments on one account in parallel commonly fails with a conflict error.
- `versionUpgradeOption: 'NoAutoUpgrade'` implements ADR-006. In `prod`, always set a pinned model `version`.
- Deployment names follow the architecture: `img-draft-gpt-image-1-mini`, `img-std-gpt-image-2-5-flare`, `img-prec-gpt-image-2-5-sunburst`, `img-fb-gpt-image-2`, `img-alt-mai-image`. Agent instructions never mention these names (ADR-002).
- Model availability, the `format` value for each model family (in particular for MAI-Image), the `skuName` (`GlobalStandard`, `DataZoneStandard`, or `Standard`), and the capacity depend on the region and subscription. Verify each value in the Foundry model catalog before deployment.
- The `projectEndpoint` output follows the current endpoint pattern. Confirm it in the portal after the first deployment.
- The Foundry resource also hosts the reasoning and vision model deployment that the agents and the critic need. Add it to `modelDeployments`.

### `search.bicep`

```bicep
param location string
param tags object
param resourceToken string
@allowed([ 'enabled', 'disabled' ])
param publicNetworkAccess string

resource search 'Microsoft.Search/searchServices@2024-06-01-preview' = {
  name: 'srch-${resourceToken}'
  location: location
  tags: tags
  sku: { name: 'basic' }
  identity: { type: 'SystemAssigned' }
  properties: {
    replicaCount: 1
    partitionCount: 1
    hostingMode: 'default'
    publicNetworkAccess: publicNetworkAccess
    disableLocalAuth: true
    authOptions: null
  }
}

output name string = search.name
output endpoint string = 'https://${search.name}.search.windows.net'
```

The `basic` tier supports private endpoints and role-based access. The `free` tier does not, so do not use it beyond a quick test. When the Foundry project connects to this service (task `P1.7.2`), the project identity needs the `Search Index Data Reader` and `Search Service Contributor` roles. The `rbac.bicep` module grants them.

### `registry.bicep`

```bicep
param location string
param tags object
param resourceToken string

resource registry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: 'cr${resourceToken}'
  location: location
  tags: tags
  sku: { name: 'Standard' }
  properties: {
    adminUserEnabled: false
    anonymousPullEnabled: false
  }
}

output name string = registry.name
output loginServer string = registry.properties.loginServer
```

`prod` with private endpoints needs the `Premium` SKU. The container apps pull images with their managed identity (role `AcrPull`), and the admin user stays disabled.

### `servicebus.bicep`

```bicep
param location string
param tags object
param resourceToken string

resource namespace 'Microsoft.ServiceBus/namespaces@2024-01-01' = {
  name: 'sb-${resourceToken}'
  location: location
  tags: tags
  sku: { name: 'Standard', tier: 'Standard' }
  properties: {
    disableLocalAuth: true
    minimumTlsVersion: '1.2'
  }
}

resource jobsQueue 'Microsoft.ServiceBus/namespaces/queues@2024-01-01' = {
  parent: namespace
  name: 'image-jobs'
  properties: {
    requiresSession: true
    lockDuration: 'PT5M'
    maxDeliveryCount: 5
    deadLetteringOnMessageExpiration: true
    defaultMessageTimeToLive: 'P1D'
  }
}

output namespaceName string = namespace.name
```

`requiresSession: true` provides the per-job sessions in §4 (component C11). Dead-lettered messages stay in the queue's dead-letter sub-queue, which the alert in §14.2 monitors. Private endpoints for Service Bus require the `Premium` SKU. Change the SKU for `prod` when `enablePrivateNetworking` is `true`.

### `containerapps.bicep`

```bicep
param location string
param tags object
param resourceToken string
param logAnalyticsWorkspaceName string
param appInsightsConnectionString string
param registryLoginServer string
param imageMcpIdentityId string
param facadeIdentityId string
param enableAsyncJobs bool
@description('Empty when private networking is disabled.')
param infrastructureSubnetId string = ''
param settings object

@description('Placeholder image until the first build is pushed.')
param bootstrapImage string = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource environment 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: 'cae-${resourceToken}'
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
    vnetConfiguration: empty(infrastructureSubnetId) ? null : {
      infrastructureSubnetId: infrastructureSubnetId
      internal: true
    }
    workloadProfiles: [
      { name: 'Consumption', workloadProfileType: 'Consumption' }
    ]
  }
}

var commonEnv = [
  { name: 'APPLICATIONINSIGHTS_CONNECTION_STRING', value: appInsightsConnectionString }
  { name: 'STORAGE_ACCOUNT_NAME', value: settings.storageAccountName }
  { name: 'COSMOS_ENDPOINT', value: settings.cosmosEndpoint }
  { name: 'APP_CONFIG_ENDPOINT', value: settings.appConfigEndpoint }
  { name: 'FOUNDRY_ENDPOINT', value: settings.foundryEndpoint }
  { name: 'FOUNDRY_PROJECT_ENDPOINT', value: settings.foundryProjectEndpoint }
  { name: 'CONTENT_SAFETY_ENDPOINT', value: settings.contentSafetyEndpoint }
]

resource imageMcp 'Microsoft.App/containerApps@2024-03-01' = {
  name: 'ca-image-mcp'
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

resource facade 'Microsoft.App/containerApps@2024-03-01' = {
  name: 'ca-facade-mcp'
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

resource worker 'Microsoft.App/jobs@2024-03-01' = if (enableAsyncJobs) {
  name: 'job-image-worker'
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
```

Points to note:

- **Bootstrap image.** The first deployment uses a placeholder image, because the service images do not exist yet. `azd deploy` then replaces the image for each service that carries the `azd-service-name` tag.
- **Ingress.** The Image MCP server is internal (`external: false`) because only agents call it. The facade uses external ingress in `dev`. In `prod`, the environment is internal and APIM is the only public entry (§10.3).
- **Registry access.** Both apps pull images with their identities. The `rbac.bicep` module grants `AcrPull`. On the very first deployment, an image pull with the identity can fail until the role assignment propagates. Deploy the placeholder image first, as shown, so this does not block provisioning.
- **Environment variables.** Only endpoints and names are configured. No secret is set.
- **Port and health.** The port `8080` is a convention that the services must follow. Add liveness and readiness probes when the services exist.
- **Worker scaling.** The KEDA rule scales the worker with the queue length, as in §8.2.

### `apim.bicep`

```bicep
param location string
param tags object
param resourceToken string
param facadeFqdn string
param appInsightsId string
@secure()
param appInsightsInstrumentationKey string
@allowed([ 'None', 'Internal' ])
param virtualNetworkType string
param subnetId string = ''
param publisherEmail string = 'platform@example.com'
param publisherName string = 'AIDevMe'

resource apim 'Microsoft.ApiManagement/service@2023-09-01-preview' = {
  name: 'apim-${resourceToken}'
  location: location
  tags: tags
  sku: {
    name: virtualNetworkType == 'None' ? 'Developer' : 'Premium'
    capacity: 1
  }
  identity: { type: 'SystemAssigned' }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
    virtualNetworkType: virtualNetworkType
    virtualNetworkConfiguration: virtualNetworkType == 'None' ? null : { subnetResourceId: subnetId }
  }
}

resource facadeBackend 'Microsoft.ApiManagement/service/backends@2023-09-01-preview' = {
  parent: apim
  name: 'image-studio-facade'
  properties: {
    protocol: 'http'
    url: 'https://${facadeFqdn}'
  }
}

resource facadeApi 'Microsoft.ApiManagement/service/apis@2023-09-01-preview' = {
  parent: apim
  name: 'image-studio'
  properties: {
    displayName: 'Image Studio'
    path: 'image-studio'
    protocols: [ 'https' ]
    subscriptionRequired: true
    serviceUrl: 'https://${facadeFqdn}'
  }
}

resource logger 'Microsoft.ApiManagement/service/loggers@2023-09-01-preview' = {
  parent: apim
  name: 'appinsights'
  properties: {
    loggerType: 'applicationInsights'
    resourceId: appInsightsId
    credentials: { instrumentationKey: appInsightsInstrumentationKey }
  }
}

output gatewayUrl string = apim.properties.gatewayUrl
output principalId string = apim.identity.principalId
```

Points to note:

- **SKU.** `Developer` has no service level agreement and suits `dev` only. `test` and `prod` use a SKU that supports virtual network integration. Confirm the current SKU names, in particular the v2 tiers that the architecture mentions ("internal or Premium v2"), because they change.
- **Policies.** The API policy that validates the Entra token, applies quotas and rate limits, and meters usage per subscription is an XML document. Store it in `.infrastructure/policies/image-studio.xml`, and attach it with a `Microsoft.ApiManagement/service/apis/policies` resource that uses `loadTextContent`. Write the policy in task `P1.10.2`.
- **Products and subscriptions.** Create one product per consumer group (`P1.10.1`) with `products` and `subscriptions` resources after the API contract is stable.
- **Provisioning time.** An API Management instance can take 30 to 45 minutes to create, and Premium and virtual network deployments take longer. Deploy it separately from the fast modules when you iterate.

### `network.bicep`

Deploy this module only when `enablePrivateNetworking` is `true` (for `test` and `prod`). It provides the virtual network, subnets, private DNS zones, and private endpoints (task `P4.1`).

```bicep
param location string
param tags object
param environmentName string

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: 'vnet-image-studio-${environmentName}'
  location: location
  tags: tags
  properties: {
    addressSpace: { addressPrefixes: [ '10.20.0.0/16' ] }
    subnets: [
      {
        name: 'snet-containerapps'
        properties: {
          addressPrefix: '10.20.0.0/23'
          delegations: [
            { name: 'containerapps', properties: { serviceName: 'Microsoft.App/environments' } }
          ]
        }
      }
      {
        name: 'snet-apim'
        properties: { addressPrefix: '10.20.2.0/27' }
      }
      {
        name: 'snet-private-endpoints'
        properties: { addressPrefix: '10.20.3.0/24' }
      }
    ]
  }
}

output vnetId string = vnet.id
output containerAppsSubnetId string = vnet.properties.subnets[0].id
output apimSubnetId string = vnet.properties.subnets[1].id
output privateEndpointSubnetId string = vnet.properties.subnets[2].id
```

Add the private DNS zones and private endpoints in a reusable child module, and call it once for each service. The table lists the private link group and DNS zone for each service.

| Service | Group ID | Private DNS zone |
| --- | --- | --- |
| Storage (blob) | `blob` | `privatelink.blob.core.windows.net` |
| Cosmos DB (SQL) | `Sql` | `privatelink.documents.azure.com` |
| Key Vault | `vault` | `privatelink.vaultcore.azure.net` |
| App Configuration | `configurationStores` | `privatelink.azconfig.io` |
| Foundry and Content Safety | `account` | `privatelink.cognitiveservices.azure.com`, `privatelink.openai.azure.com`, `privatelink.services.ai.azure.com` |
| Azure AI Search | `searchService` | `privatelink.search.windows.net` |
| Service Bus | `namespace` | `privatelink.servicebus.windows.net` |
| Container Registry | `registry` | `privatelink.azurecr.io` |

Verify the zone names against the current Azure private endpoint DNS documentation. A missing zone causes name-resolution failures that look like connectivity failures. The Foundry Agent Service standard setup with a bring-your-own virtual network (task `P4.2`) needs an additional delegated subnet and capability host configuration. Follow the current Foundry documentation for it, because the requirements are specific and change.

### `rbac.bicep`

This module assigns the roles from §10.2.

```bicep
param imageMcpPrincipalId string
param facadePrincipalId string
param deployerPrincipalId string = ''
param storageAccountName string
param cosmosAccountName string
param keyVaultName string
param appConfigName string
param foundryAccountName string
param foundryProjectName string
param contentSafetyAccountName string
param searchServiceName string
param registryName string
param serviceBusNamespaceName string = ''
param enableAsyncJobs bool
param enableExternalProvider bool

var roles = {
  storageBlobDataContributor: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  storageBlobDelegator: 'db58b8e5-c6ad-4a2a-8342-4190687cbf4a'
  keyVaultSecretsUser: '4633458b-17de-408a-b874-0445c86b69e6'
  appConfigDataReader: '516239f1-63e1-43b4-ac11-4b1a5ea6e3e4'
  cognitiveServicesOpenAiUser: '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd'
  cognitiveServicesUser: 'a97b65f3-24c7-4388-baec-2e87135dc908'
  azureAiUser: '53ca6127-db72-4b80-b1b0-d745d6d5456d'
  serviceBusDataSender: '69a216fc-b8fb-44d8-bc22-1f3c2cd27a39'
  serviceBusDataReceiver: '4f6d3b9b-027b-4f4c-9142-0e5a2a2247e0'
  acrPull: '7f951dda-4ed3-4680-a7ca-43fe172d538d'
}

resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' existing = { name: storageAccountName }
resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2024-05-15' existing = { name: cosmosAccountName }
resource vault 'Microsoft.KeyVault/vaults@2023-07-01' existing = { name: keyVaultName }
resource appConfig 'Microsoft.AppConfiguration/configurationStores@2023-03-01' existing = { name: appConfigName }
resource foundry 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = { name: foundryAccountName }
resource contentSafety 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = { name: contentSafetyAccountName }
resource registry 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = { name: registryName }
resource serviceBus 'Microsoft.ServiceBus/namespaces@2024-01-01' existing = if (enableAsyncJobs) { name: serviceBusNamespaceName }

// Image MCP server: storage
resource mcpBlobContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storage
  name: guid(storage.id, imageMcpPrincipalId, roles.storageBlobDataContributor)
  properties: {
    principalId: imageMcpPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.storageBlobDataContributor)
  }
}

resource mcpBlobDelegator 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storage
  name: guid(storage.id, imageMcpPrincipalId, roles.storageBlobDelegator)
  properties: {
    principalId: imageMcpPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.storageBlobDelegator)
  }
}

// Image MCP server: model deployments and Content Safety
resource mcpModels 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: foundry
  name: guid(foundry.id, imageMcpPrincipalId, roles.cognitiveServicesOpenAiUser)
  properties: {
    principalId: imageMcpPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.cognitiveServicesOpenAiUser)
  }
}

resource mcpSafety 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: contentSafety
  name: guid(contentSafety.id, imageMcpPrincipalId, roles.cognitiveServicesUser)
  properties: {
    principalId: imageMcpPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.cognitiveServicesUser)
  }
}

// Image MCP server: routing table
resource mcpConfig 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: appConfig
  name: guid(appConfig.id, imageMcpPrincipalId, roles.appConfigDataReader)
  properties: {
    principalId: imageMcpPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.appConfigDataReader)
  }
}

// Image MCP server: external provider key (only when enabled)
resource mcpVault 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (enableExternalProvider) {
  scope: vault
  name: guid(vault.id, imageMcpPrincipalId, roles.keyVaultSecretsUser)
  properties: {
    principalId: imageMcpPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.keyVaultSecretsUser)
  }
}

// Image MCP server: Service Bus
resource mcpQueueSender 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (enableAsyncJobs) {
  scope: serviceBus
  name: guid(serviceBus.id, imageMcpPrincipalId, roles.serviceBusDataSender)
  properties: {
    principalId: imageMcpPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.serviceBusDataSender)
  }
}

resource mcpQueueReceiver 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (enableAsyncJobs) {
  scope: serviceBus
  name: guid(serviceBus.id, imageMcpPrincipalId, roles.serviceBusDataReceiver)
  properties: {
    principalId: imageMcpPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.serviceBusDataReceiver)
  }
}

// Cosmos DB data-plane role: Built-in Data Contributor
resource cosmosContributor 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2024-05-15' = {
  parent: cosmos
  name: guid(cosmos.id, imageMcpPrincipalId, 'data-contributor')
  properties: {
    principalId: imageMcpPrincipalId
    roleDefinitionId: '${cosmos.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002'
    scope: cosmos.id
  }
}

// Facade: call the Foundry agent
resource facadeAiUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: foundry
  name: guid(foundry.id, facadePrincipalId, roles.azureAiUser)
  properties: {
    principalId: facadePrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.azureAiUser)
  }
}

// Both apps pull images from the registry
resource mcpAcrPull 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: registry
  name: guid(registry.id, imageMcpPrincipalId, roles.acrPull)
  properties: {
    principalId: imageMcpPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.acrPull)
  }
}

resource facadeAcrPull 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: registry
  name: guid(registry.id, facadePrincipalId, roles.acrPull)
  properties: {
    principalId: facadePrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roles.acrPull)
  }
}
```

The module above omits the following assignments for brevity. Add them in the same pattern.

| Principal | Role | Scope | Condition |
| --- | --- | --- | --- |
| Foundry project identity | `Search Index Data Reader`, `Search Service Contributor` | Azure AI Search service | Always (Foundry IQ, task `P1.7.2`) |
| Foundry account and project identity | `Storage Blob Data Reader` | Storage account | When agents read `brand/` files directly |
| Deployer (`deployerPrincipalId`) | `Storage Blob Data Contributor`, `Azure AI User`, `App Configuration Data Owner` | Storage, Foundry, App Configuration | `dev` only, for setup scripts. Remove in `prod`. |
| Platform team | `Contributor` through PIM | Resource group | Not in Bicep. Configure in Entra ID. |

Role assignment names must be a GUID that is stable across deployments, so build them with `guid()` from the scope, the principal, and the role. Changing these inputs creates a duplicate assignment. Role identifiers here are the built-in role IDs at the time of writing. Verify them with `az role definition list --name "<role name>" --query "[0].name"`.

The identities created in `identity.bicep` may not be visible to Entra ID immediately, and a role assignment can fail with `PrincipalNotFound`. Setting `principalType: 'ServicePrincipal'` avoids most of these failures.

## Parameter files

Use one `.bicepparam` file per environment. The `dev` environment is small and public. `test` and `prod` add asynchronous jobs and private networking.

`.infrastructure/main.dev.bicepparam`:

```bicep
using './main.bicep'

param environmentName = 'dev'
param environmentType = 'dev'
param location = '<region-from-decision-D1>'
param deployerPrincipalId = readEnvironmentVariable('AZURE_PRINCIPAL_ID', '')
param allowedIpAddresses = []
param enableAsyncJobs = false
param enablePrivateNetworking = false
param enableExternalProvider = false

param modelDeployments = [
  {
    name: 'img-draft-gpt-image-1-mini'
    model: 'gpt-image-1-mini'
    format: 'OpenAI'
    version: '<pinned-version>'
    skuName: 'GlobalStandard'
    capacity: 1
  }
  {
    name: 'img-std-gpt-image-2-5-flare'
    model: 'gpt-image-2.5-flare'
    format: 'OpenAI'
    version: '<pinned-version>'
    skuName: 'GlobalStandard'
    capacity: 1
  }
  {
    name: 'llm-agents'
    model: '<reasoning-and-vision-model>'
    format: 'OpenAI'
    version: '<pinned-version>'
    skuName: 'GlobalStandard'
    capacity: 50
  }
]
```

For `test` and `prod`, set `enableAsyncJobs` and `enablePrivateNetworking` to `true`, and add these deployments from §6.2:

| Deployment name | Model | Tier |
| --- | --- | --- |
| `img-prec-gpt-image-2-5-sunburst` | `gpt-image-2.5-sunburst` | precision |
| `img-fb-gpt-image-2` | `gpt-image-2` | fallback |
| `img-alt-mai-image` | MAI-Image (verify the model name and `format`) | alternative |

The `dev` environment needs only the draft and standard deployments (§17.1). Replace every `<...>` placeholder with a verified value. The architecture states that model versions and availability change, so read them from the Foundry model catalog for your region on the day of deployment. The `capacity` value is in thousands of tokens per minute for text models. For image models, check the unit in the catalog, because it differs from text models.

### Environment differences

| Setting | `dev` | `test` | `prod` |
| --- | --- | --- | --- |
| Network | Public, IP-restricted | Private endpoints | Private endpoints, internal APIM |
| Model tiers | Draft, standard | All | All, pinned versions |
| `enableAsyncJobs` | `false` | `true` | `true` |
| `enablePrivateNetworking` | `false` | `true` | `true` |
| APIM SKU | Developer | Premium (or a v2 SKU) | Premium (or a v2 SKU) |
| Container Registry SKU | Standard | Premium | Premium |
| Service Bus SKU | Standard | Premium | Premium |
| Cosmos DB mode | Serverless | Serverless or autoscale | Autoscale or provisioned |
| Deployer role assignments | Yes | No | No |

## Azure Developer CLI project

`azure.yaml` at the repository root ties the infrastructure to the services.

```yaml
name: aidevme-foundry-image-studio
metadata:
  template: aidevme-foundry-image-studio@0.1.0

infra:
  provider: bicep
  path: .infrastructure
  module: main

services:
  image-mcp:
    project: ./src/image-mcp
    language: ts
    host: containerapp
    docker:
      path: ./Dockerfile
  facade-mcp:
    project: ./src/facade-mcp
    language: ts
    host: containerapp
    docker:
      path: ./Dockerfile
```

Notes:

- The service names must match the `azd-service-name` tags in `containerapps.bicep`.
- `language: ts` follows the recommended runtime in decision D2. Change it to match the decision.
- Add `image-worker` under `services` when you enable asynchronous jobs. Because the worker is a Container Apps job, check the current `azd` support for the `containerapp` host with jobs, or deploy the worker image with an `az containerapp job update` step in a hook.
- The `infra.module` value `main` selects `.infrastructure/main.bicep`. `azd` reads the `main.<environment>.bicepparam` file through the environment name if you name the file `main.parameters.json`. If you keep `.bicepparam` files, set the `AZURE_ENV_NAME` variable and select the file explicitly (see the deployment commands). Check the current `azd` behavior for `.bicepparam` support.

## Deployment procedure

You can deploy with `azd` (recommended, because it also builds and deploys the services) or directly with the Azure CLI (useful for infrastructure only).

### Before the first deployment

1. Sign in and select the subscription.

   ```bash
   az login
   az account set --subscription "<subscription-id-or-name>"
   ```

2. Register the resource providers ([Resource providers](#resource-providers)).
3. Confirm model access and quota for the region ([Prerequisites](#prerequisites)).
4. Replace every `<...>` placeholder in the parameter file.
5. Lint and compile the templates. Both commands must finish without errors.

   ```bash
   az bicep lint --file .infrastructure/main.bicep
   az bicep build --file .infrastructure/main.bicep --stdout > /dev/null
   ```

### Preview the changes

The `what-if` operation shows what a deployment would change without applying it. Run it before every deployment.

```bash
az deployment sub what-if \
  --location <region> \
  --template-file .infrastructure/main.bicep \
  --parameters .infrastructure/main.dev.bicepparam
```

Check that the output contains only the expected creations, and no unexpected deletions or replacements.

### Deploy with Azure CLI

```bash
az deployment sub create \
  --name image-studio-dev \
  --location <region> \
  --template-file .infrastructure/main.bicep \
  --parameters .infrastructure/main.dev.bicepparam
```

The command prints the outputs when it finishes. Read them again later:

```bash
az deployment sub show --name image-studio-dev --query properties.outputs
```

### Deploy with Azure Developer CLI

```bash
azd auth login
azd env new dev
azd env set AZURE_LOCATION <region>
azd env set AZURE_PRINCIPAL_ID $(az ad signed-in-user show --query id -o tsv)
azd provision          # infrastructure only
azd deploy             # build and deploy the services
azd up                 # provision and deploy in one step
```

`azd up` is the acceptance check for phase 0 (`P0.3.6`): it must complete from a clean subscription.

### Deployment order and timing

Resource Manager resolves dependencies from module outputs. The table shows the effective order and typical duration. Durations are estimates.

| Order | Resources | Typical duration |
| --- | --- | --- |
| 1 | Resource group, Log Analytics, Application Insights, identities, network | Minutes |
| 2 | Storage, Cosmos DB, Key Vault, App Configuration, Container Registry | Minutes |
| 3 | Foundry resource, project, model deployments, Content Safety, AI Search | Minutes per model deployment (they run one at a time) |
| 4 | Service Bus, Container Apps environment and apps | Minutes |
| 5 | API Management | 30 to 45 minutes or more |
| 6 | Role assignments | Seconds, but can fail if identities are not yet visible |

### After provisioning

Complete these steps. Bicep does not do them.

1. **Build and push the service images.** Run `azd deploy`, or build and push the images to the registry, so that the placeholder image is replaced.
2. **Load the routing table** into App Configuration from `config/routing.yaml` (task `P1.2.2`).
3. **Create the Entra ID objects** ([Entra ID objects](#entra-id-objects)).
4. **Deploy the agents** with the deployment script (task `P1.8.2`), and register the toolbox (task `P1.6.1`).
5. **Index the brand content** in Foundry IQ (task `P1.7.2`).
6. **Attach the APIM policy, products, and subscriptions** (tasks `P1.10.1`, `P1.10.2`).
7. **Run the smoke tests** ([Verification](#verification)).

### Entra ID objects

Create the facade app registration and its `ImageStudio.User` app role before you configure APIM token validation (task `P1.10.3`). Use the Azure CLI:

```bash
az ad app create --display-name "image-studio-facade-dev" --sign-in-audience AzureADMyOrg
```

Then add the app role and an Application ID URI to the manifest, and assign the role to the users or groups that may call the API. The Microsoft Graph Bicep extension can also manage these objects, but it is still a separate extension with its own limitations, so verify its current status before you rely on it. Keep the app registration outside the resource templates unless you standardize on that extension.

## Continuous deployment

Two GitHub Actions workflows deploy the templates. They are stored in `.github/workflows/` because GitHub runs workflows only from that folder. Sign-in uses OpenID Connect (OIDC) federation, so the repository stores no Azure credentials.

| Workflow | Trigger | Steps |
| --- | --- | --- |
| [infra-validate.yml](../../.github/workflows/infra-validate.yml) | Pull request that changes `.infrastructure/**` | Lint, build, build the parameter file, report unresolved placeholders, and run what-if (skipped for fork pull requests and when Azure sign-in is not configured) |
| [infra-deploy.yml](../../.github/workflows/infra-deploy.yml) | Manual run only | Verify repository variables, refuse to run while placeholders remain, lint, build, sign in, what-if, deploy, and write the deployment outputs to the job summary |

### Repository variables

The workflows read the Azure subscription and the other non-secret settings from repository variables (**Settings → Secrets and variables → Actions → Variables**).

| Variable | Purpose |
| --- | --- |
| `AZURE_SUBSCRIPTION_ID` | Target Azure subscription |
| `AZURE_TENANT_ID` | Microsoft Entra tenant |
| `AZURE_CLIENT_ID` | Application (client) ID of the deployment app registration |
| `AZURE_LOCATION` | Azure region (decision D1) |
| `APIM_PUBLISHER_EMAIL` | Publisher e-mail address for API Management |

### One-time setup

Create the deployment app registration, one federated credential for each token subject that the workflows use (`environment:dev` for the deploy workflow and `pull_request` for the validate workflow), and the role assignments. The commands are in [.infrastructure/README.md](../../.infrastructure/README.md#2-deployment-identity-with-oidc-federation). Then create the GitHub environment `dev`, and add required reviewers to it to implement the manual approval step in §17.3.

Because `main.bicep` creates the resource group at subscription scope, the deployment identity needs `Contributor` and `User Access Administrator` at the subscription. To narrow the scope, create the resource group beforehand, change the template to resource-group scope, and record the decision as an ADR.

### Run a deployment

Run **Infrastructure deploy** from the **Actions** tab, and select the environment. Select **Preview the changes without deploying** to run only the what-if. The workflow never runs on its own, so merging a change does not deploy it.

Only the `dev` environment exists. To add `test` or `prod`, add a `main.<environment>.bicepparam` file, add the environment to the `options` list in `infra-deploy.yml`, create a matching GitHub environment, and add its federated credential.

## Verification

Run these checks after each environment deployment.

1. **Resources exist.**

   ```bash
   az resource list --resource-group rg-image-studio-dev --output table
   ```

2. **Model deployments answer.** List them, and send one test request per deployment.

   ```bash
   az cognitiveservices account deployment list \
     --resource-group rg-image-studio-dev --name <foundry-account-name> --output table
   ```

   Each deployment must show a `Succeeded` provisioning state.

3. **Identity access works.** From an Image MCP container, obtain a token and read the App Configuration store, write a test blob, and write a test Cosmos DB item. A `403` response means a role assignment is missing or has not propagated. Wait a few minutes and retry.
4. **Authentication is enforced.** A request to the facade through APIM without a token must return `401`.
5. **Local authentication is off.** A request that uses a storage account key, a Cosmos DB key, or a Foundry API key must fail.
6. **Telemetry arrives.** A test request must appear in Application Insights with one trace across the hops (task `P1.12.1`).
7. **Private environments only.** From outside the virtual network, the data-plane endpoints of Storage, Cosmos DB, Key Vault, Service Bus, and Foundry must not resolve to public addresses or accept connections.

## Operations

### Change a resource

Edit the module, run the linter and `what-if`, and deploy through a pull request. Bicep deployments are incremental by default, so resources that you remove from the template stay in Azure unless you delete them.

### Upgrade a model version

1. Add the new version as a separate deployment in `test` with a distinct name.
2. Run the evaluation gate (§14.3).
3. Change the routing table through a pull request. Do not change the deployment name in place, because the router refers to it.
4. Keep the previous deployment for at least one release as a rollback target (§6.4).

### Change quota

A capacity change in the parameter file changes the deployment. Some models reject capacity changes below the current usage. Request quota increases in the Azure portal, and record them in `docs/runbooks/model-access.md`.

### Delete an environment

```bash
azd down --purge
```

The `--purge` flag also purges soft-deleted Key Vault, App Configuration, and Foundry (Cognitive Services) resources. Without it, the soft-deleted names stay reserved, and recreating the environment fails with a name conflict. Key Vault with purge protection cannot be purged until the retention period ends. Do not delete `prod` this way.

### Cost

Charges start as soon as the resources exist. The largest fixed costs are API Management (Premium), Azure AI Search, Container Registry (Premium), Service Bus (Premium), and Container Apps with a minimum replica count above zero. Model usage is billed per request. Delete idle `dev` and `test` environments, or scale them down. Check current prices on the Azure pricing pages.

## Troubleshooting

| Symptom | Likely cause | Action |
| --- | --- | --- |
| `InvalidTemplate` or a `BCP` error during build | Syntax or type error | Run `az bicep lint` and fix the reported line. |
| `LocationNotAvailableForResourceType` | The service or model is not offered in the region | Choose a supported region (decision D1), or a different model or SKU. |
| `InsufficientQuota` on a model deployment | No quota for the model and SKU | Request quota, or lower `capacity`. |
| `Conflict` while creating model deployments | Parallel deployments on one account | Keep `@batchSize(1)` on the deployment loop. |
| `FlagMustBeSetForRestore` or a name conflict | A soft-deleted resource with the same name | Purge it, or use a new `environmentName`. |
| `RoleAssignmentExists` | The assignment already exists with a different name | Delete the old assignment, or keep the `guid()` inputs unchanged. |
| `PrincipalNotFound` on a role assignment | Identity not yet replicated | Set `principalType`, and redeploy after a short wait. |
| `AuthorizationFailed` | The deployer lacks a role | Grant `Contributor` and `User Access Administrator` at the scope. |
| Container app cannot pull the image | `AcrPull` not yet effective, or wrong registry identity | Confirm the role assignment, and restart the revision. |
| `403` from Storage with a valid identity | Missing data-plane role, or `allowSharedKeyAccess` is `false` and the client uses a key | Assign the data-plane role, and use Entra authentication. |
| Cosmos DB `Forbidden` with a valid identity | Data-plane role missing (control-plane roles do not apply) | Create the `sqlRoleAssignments` resource. |
| Deployment appears stuck on API Management | Normal provisioning time | Wait, and monitor with `az deployment sub show`. |
| Private endpoint resolves to a public address | Missing private DNS zone or virtual network link | Add the zone and link it to the virtual network. |

## Verification status

The following statements about this document could not be verified in the authoring environment, and each needs a check before the first deployment.

- No template in this document has been compiled or deployed. Run `az bicep lint`, `az bicep build`, and `what-if` on the final files.
- Resource API versions are given as they were known at the time of writing. Confirm that each version exists and is supported in your region, for example with `az provider show --namespace <provider> --query "resourceTypes[?resourceType=='<type>'].apiVersions"`.
- The `Microsoft.CognitiveServices/accounts/projects` resource, the `allowProjectManagement` property, and the project endpoint pattern were written from general knowledge of the current Foundry resource model. Confirm them against the Foundry documentation.
- Model names, `format` values, versions, SKU names, and capacity units for the image models (including MAI-Image) are placeholders or assumptions.
- The built-in role identifiers in `rbac.bicep` are the commonly published identifiers. Confirm them with `az role definition list`.
- The API Management SKU names for VNet-integrated tiers, the Foundry standard agent setup with a bring-your-own virtual network, `azd` support for `.bicepparam` files and for Container Apps jobs, and the Microsoft Graph Bicep extension change often. Confirm the current behavior in their documentation.
- Private DNS zone names and the group identifier for each private endpoint were listed from memory. Confirm them in the Azure private endpoint DNS documentation.

## Related documents

- [Architecture](ARCHITECTURE.md): the design that these templates implement (§4, §10, §17)
- [Implementation plan](IMPLEMENTATION.md): the tasks that use these templates (Phase 0 to Phase 4)
- [Generic Document Style](../templates/GENERIC_DOCUMENT_STYLE.md)
- [Documentation index](../index.md)
