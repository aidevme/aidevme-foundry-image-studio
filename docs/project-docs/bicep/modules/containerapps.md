# Container apps module

| Field | Value |
| --- | --- |
| **Document Title** | Container apps module |
| **Document Location** | `docs/project-docs/bicep/modules/containerapps.md` |
| **Document Description** | Describes the Bicep module `bicep/modules/containerapps.bicep`, which creates the Container Apps environment, the Image MCP server app, the facade app, and the optional worker job: parameters, resources, environment variables, outputs, security settings, the bootstrap image, and known limits. It is intended for engineers who operate or change the infrastructure templates. |
| **Version** | 1.2 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The module `bicep/modules/containerapps.bicep` creates the compute of the architecture (components C3, C6, and the worker of C11). Read this document to learn how the apps are configured, which environment variables they receive, and why they start with a placeholder image.

## Purpose

The module provides:

- A Container Apps environment that writes its logs to Log Analytics.
- The Image MCP server app with internal ingress.
- The facade app with external ingress.
- An event-driven worker job that scales with the Service Bus queue length (only when `enableAsyncJobs` is `true`).

## Parameters

| Name | Type | Default | Decorators | Description |
| --- | --- | --- | --- | --- |
| `location` | `string` | None | None | Azure region. |
| `tags` | `object` | None | None | Tags for every resource. |
| `nameSuffix` | `string` | None | None | Hyphenated name suffix for the environment name. |
| `environmentType` | `string` | None | `@allowed([ 'dev', 'test', 'prod' ])` | Used in the app and job names. |
| `logAnalyticsWorkspaceName` | `string` | None | None | Name of the existing Log Analytics workspace. |
| `appInsightsName` | `string` | None | None | Name of the existing Application Insights component. |
| `registryLoginServer` | `string` | None | None | Login server of the container registry. |
| `imageMcpIdentityId` | `string` | None | None | Resource ID of the Image MCP identity. |
| `facadeIdentityId` | `string` | None | None | Resource ID of the facade identity. |
| `enableAsyncJobs` | `bool` | None | None | Creates the worker job when `true`. |
| `settings` | `object` | None | None | Endpoints and names for the environment variables. Keys are listed below. |
| `bootstrapImage` | `string` | `'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'` | `@description('Placeholder image until the first build is pushed.')` | Image for all three workloads. `main.bicep` does not override it. |

### Keys of `settings`

`main.bicep` passes an object with these keys. The module reads them without a type check.

| Key | Source in `main.bicep` |
| --- | --- |
| `storageAccountName` | `storage.outputs.name` |
| `cosmosEndpoint` | `cosmos.outputs.endpoint` |
| `appConfigEndpoint` | `appConfig.outputs.endpoint` |
| `foundryEndpoint` | `foundry.outputs.endpoint` |
| `foundryProjectEndpoint` | `foundry.outputs.projectEndpoint` |
| `contentSafetyEndpoint` | `foundry.outputs.contentSafetyEndpoint` |
| `serviceBusNamespace` | `enableAsyncJobs ? serviceBus!.outputs.namespaceName : ''` |

## Resources

| Symbolic name | Resource type and API version | Name pattern | Key properties and why they are set |
| --- | --- | --- | --- |
| `logAnalytics` | `Microsoft.OperationalInsights/workspaces@2023-09-01` (`existing`) | From `logAnalyticsWorkspaceName` | Reads `customerId` and the shared key for the environment log configuration. |
| `appInsights` | `Microsoft.Insights/components@2020-02-02` (`existing`) | From `appInsightsName` | Reads `ConnectionString`. |
| `environment` | `Microsoft.App/managedEnvironments@2025-01-01` | `cae-<nameSuffix>` (for example `cae-dev-<token>`) | `appLogsConfiguration.destination: 'log-analytics'` with `customerId` and `sharedKey: logAnalytics.listKeys().primarySharedKey`. `workloadProfiles: [ { name: 'Consumption', workloadProfileType: 'Consumption' } ]`. No `vnetConfiguration`, so the environment is not integrated with a virtual network. |
| `imageMcp` | `Microsoft.App/containerApps@2025-01-01` | `ca-image-mcp-<environmentType>` (for example `ca-image-mcp-dev`) | User-assigned identity `imageMcpIdentityId`. Ingress `external: false`, `targetPort: 8080`, `transport: 'auto'`. Registry `registryLoginServer` with the identity. Container `image-mcp`, `image: bootstrapImage`, `cpu: json('0.5')`, `memory: '1Gi'`. `scale: { minReplicas: 1, maxReplicas: 5 }`. Tag `azd-service-name: 'image-mcp'`. |
| `facade` | `Microsoft.App/containerApps@2025-01-01` | `ca-facade-mcp-<environmentType>` (for example `ca-facade-mcp-dev`) | User-assigned identity `facadeIdentityId`. Ingress `external: true`, `targetPort: 8080`, `transport: 'auto'`. Container `facade-mcp`, same size and scale as the Image MCP app. Tag `azd-service-name: 'facade-mcp'`. |
| `worker` | `Microsoft.App/jobs@2025-01-01` | `job-image-worker-<environmentType>` (for example `job-image-worker-dev`) | Condition `enableAsyncJobs`. Identity `imageMcpIdentityId`. `triggerType: 'Event'`, `replicaTimeout: 900`, `replicaRetryLimit: 1`. `eventTriggerConfig`: `parallelism: 1`, `replicaCompletionCount: 1`, `scale` with `minExecutions: 0`, `maxExecutions: 10`, `pollingInterval: 30`, and one rule `queue-length` of type `azure-servicebus` (metadata `namespace`, `queueName: 'image-jobs'`, `messageCount: '5'`, and `identity: imageMcpIdentityId`). Container `worker`, `cpu: json('1.0')`, `memory: '2Gi'`. Tag `azd-service-name: 'image-worker'`. |

The variable `commonEnv` defines the environment variables of the apps and the job.

### Environment variables

| Variable | Value |
| --- | --- |
| `APPLICATIONINSIGHTS_CONNECTION_STRING` | `appInsights.properties.ConnectionString` |
| `STORAGE_ACCOUNT_NAME` | `settings.storageAccountName` |
| `COSMOS_ENDPOINT` | `settings.cosmosEndpoint` |
| `APP_CONFIG_ENDPOINT` | `settings.appConfigEndpoint` |
| `FOUNDRY_ENDPOINT` | `settings.foundryEndpoint` |
| `FOUNDRY_PROJECT_ENDPOINT` | `settings.foundryProjectEndpoint` |
| `CONTENT_SAFETY_ENDPOINT` | `settings.contentSafetyEndpoint` |
| `SERVICE_BUS_NAMESPACE` (worker only) | `settings.serviceBusNamespace` |

The variables carry endpoints and names. The template sets no secret variable. The template sets no `AZURE_CLIENT_ID` and no variable for Key Vault or Azure AI Search.

## Outputs

| Output | Type | Value | Consumed by |
| --- | --- | --- | --- |
| `facadeFqdn` | `string` | `facade.properties.configuration.ingress.fqdn` | `apim` (backend URL and API service URL) |
| `imageMcpFqdn` | `string` | `imageMcp.properties.configuration.ingress.fqdn` | No module |

## Security and networking

| Setting | Value | Effect |
| --- | --- | --- |
| Identities | User-assigned, one per app | The apps access Azure services with roles from the [RBAC module](rbac.md). |
| Registry access | Identity-based (`registries[].identity`) | No registry password. The identity needs `AcrPull`. |
| Image MCP ingress | `external: false` | Reachable only from inside the Container Apps environment. |
| Facade ingress | `external: true` | The facade has a public FQDN. The template adds no authentication to it. Direct access to the FQDN bypasses API Management. |
| Environment network | No virtual network | The environment is public. The architecture target is an internal environment (section 10.3). |
| Log shared key | Read with `listKeys()` in the template | The key is passed to the environment resource and is not written to an output. |

## Dependencies and consumers

- Depends on: `monitoring` (workspace and component names), `registry` (login server), `identity` (identity IDs), `storage`, `cosmos`, `appConfig`, and `foundry` (endpoints), and `serviceBus` (namespace name, only when the flag is `true`).
- Consumed by: `apim` (`facadeFqdn`).
- `containerApps` and `rbac` do not depend on each other. See the [dependency diagram](../index.md#dependency-diagram).

## Conditions and flags

Only the `worker` job depends on `enableAsyncJobs`. The apps and the environment are always created. The `settings.serviceBusNamespace` value is an empty string when the flag is `false`.

## Operational notes

- **Bootstrap image.** All three workloads start with the public placeholder image `mcr.microsoft.com/azuredocs/containerapps-helloworld:latest`, because the service images do not exist yet. This lets provisioning finish without a pull from the private registry. The tags `azd-service-name` remain from the design that used Azure Developer CLI. `azd` is not used (ADR-011), and no workflow builds or pushes images. How the placeholder is replaced is not implemented.
- **Port mismatch risk.** The apps declare `targetPort: 8080`. Microsoft Container Apps quickstarts use the placeholder image with port 80. Whether the placeholder becomes healthy on port 8080 is not verified. If revisions fail to become ready, check the target port first.
- **Managed identity and SDKs.** The apps use user-assigned identities. A client library usually needs the client ID of a user-assigned identity. The template supplies none ([Identity module](identity.md#operational-notes)).
- **Registry pull timing.** `AcrPull` is assigned by `rbac`, which runs in parallel with this module. This does not matter while the placeholder image is used. When a real image from the registry is deployed later, a pull can fail until the role assignment has propagated.
- **Scaling.** Both apps keep at least one replica (`minReplicas: 1`), so they incur charges continuously. The worker scales from zero.
- **Session queue.** The queue requires sessions. The scaler rule counts messages in the queue. The behavior of the scaler with a session queue is not verified.
- **Telemetry.** The connection string is passed to the apps. See the [Monitoring module](monitoring.md#operational-notes) for the `DisableLocalAuth` effect.
- **Name length.** App and job names contain `environmentType` (at most 4 characters), so they stay short. The service limits for these names are not verified in this document.

## Known limits

- Probes, secrets, Dapr, custom domains, and authentication settings are not configured.
- The environment has one workload profile, `Consumption`.
- The facade is public. The API Management gateway is not the only entry point.
- Private networking is not implemented ([overview](../index.md#not-implemented-yet)).
- The worker job has never been deployed. The flag is `false` in every parameter file.

## Related documents

- [Bicep code overview](../index.md)
- [Identity module](identity.md)
- [Registry module](registry.md)
- [Service Bus module](servicebus.md)
- [API Management module](apim.md)
- [RBAC module](rbac.md)
- [Architecture, section 10.3: network](../../../aidevme-foundry-image-studio/ARCHITECTURE.md#103-network)
- [Infrastructure provisioning with Bicep](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md)
- [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md)
- [Documentation index](../../../index.md)
