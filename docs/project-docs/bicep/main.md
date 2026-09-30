# main.bicep

| Field | Value |
| --- | --- |
| **Document Title** | main.bicep |
| **Document Location** | `docs/project-docs/bicep/main.md` |
| **Document Description** | Describes the entry point `bicep/main.bicep` of the infrastructure templates: target scope, parameters, variables, the resource group, every module call with its parameters and conditions, the outputs, and the order in which the resources are deployed. It is intended for engineers who deploy or change the templates. |
| **Version** | 1.3 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The file `bicep/main.bicep` is the only template that you deploy. It creates the resource group and calls one module for each service group. Read this document to learn which parameters the template takes, how the modules are wired together, and which outputs it returns. The parameter values for `dev` are in [Parameter file and linter configuration](parameters.md). The overview of the whole code base is in [Bicep code overview](index.md).

## Target scope

```bicep
targetScope = 'subscription'
```

The template deploys at subscription scope so that it can create the resource group. All modules use `scope: rg`, so their resources are created in that group. The deployment identity therefore needs `Contributor` and `User Access Administrator` on the subscription ([workflows overview](../github/workflows/index.md#roles-of-the-deployment-identity)).

Deploy the template with `az deployment sub create`, which needs a `--location` for the deployment metadata. The value is separate from the `location` parameter of the template.

## Parameters

| Name | Type | Default | Decorators | Description |
| --- | --- | --- | --- | --- |
| `environmentName` | `string` | None | `@minLength(1)`, `@maxLength(12)`, `@description('Short name of the environment, for example dev, test, or prod.')` | Names the resource group, the identities, and the unique token. |
| `environmentType` | `string` | None | `@allowed([ 'dev', 'test', 'prod' ])` | Used in resource names and in the `environment` tag. |
| `location` | `string` | None | `@description('Azure region for all resources. Decision D1 selects the region.')` | Region of every resource. |
| `deployerPrincipalId` | `string` | `''` | `@description('Object ID of the person or service principal that runs setup scripts. Leave empty in test and prod.')` | Adds three setup role assignments when not empty. |
| `apimPublisherEmail` | `string` | None | `@description('Publisher e-mail address shown by API Management.')` | Passed to the `apim` module as `publisherEmail`. |
| `enableAsyncJobs` | `bool` | `false` | None | Deploys Service Bus, the worker job, and their roles. |
| `enableExternalProvider` | `bool` | `false` | None | Assigns `Key Vault Secrets User` to the Image MCP identity. |
| `modelDeployments` | `array` | None | `@description('Image and reasoning model deployments. See the parameter files.')` | Model deployments. The element shape is in the [Foundry module](modules/foundry.md#element-of-modeldeployments). |
| `allowedIpAddresses` | `array` | `[]` | `@description('IP addresses allowed to reach Storage and Cosmos DB while public access is enabled.')` | Firewall rules for Storage and Cosmos DB. |
| `tags` | `object` | `{}` | None | Extra tags. Merged into `allTags`. |

`environmentName` and `environmentType` are separate parameters. In `dev` both are `dev`. A value in `environmentName` longer than 12 characters fails validation.

## Variables

| Variable | Expression | Use |
| --- | --- | --- |
| `resourceToken` | `toLower(uniqueString(subscription().id, environmentName, location))` | 13-character deterministic token. It changes when the subscription, the environment name, or the region changes. |
| `nameSuffix` | `'${environmentType}-${resourceToken}'` | Suffix for names that allow hyphens. |
| `nameSuffixCompact` | `'${environmentType}${resourceToken}'` | Suffix for Storage and Container Registry names, which do not allow hyphens. |
| `allTags` | `union(tags, { application: 'aidevme-foundry-image-studio', environment: environmentType })` | Tags on the resource group and every module. |

The comments in the file explain that names contain the environment type and a short unique token. The naming table is in [Naming conventions](index.md#naming-conventions).

## Resource group

| Symbolic name | Resource type and API version | Name | Properties |
| --- | --- | --- | --- |
| `rg` | `Microsoft.Resources/resourceGroups@2024-03-01` | `'rg-image-studio-${environmentName}'` | `location: location`, `tags: allTags` |

## Module calls

Every module call sets `scope: rg`, the deployment name shown below, and the parameters `location` and `tags` (`allTags`). The table lists the other parameters.

| Symbolic name | File | Deployment name | Condition | Other parameters |
| --- | --- | --- | --- | --- |
| `monitoring` | `modules/monitoring.bicep` | `monitoring` | None | `nameSuffix` |
| `identity` | `modules/identity.bicep` | `identity` | None | `environmentName` |
| `storage` | `modules/storage.bicep` | `storage` | None | `nameSuffixCompact`, `allowedIpAddresses`, `publicNetworkAccess: 'Enabled'`, `logAnalyticsWorkspaceId: monitoring.outputs.logAnalyticsId` |
| `cosmos` | `modules/cosmos.bicep` | `cosmos` | None | `nameSuffix`, `allowedIpAddresses`, `publicNetworkAccess: 'Enabled'` |
| `keyVault` | `modules/keyvault.bicep` | `keyvault` | None | `nameSuffix`, `publicNetworkAccess: 'Enabled'` |
| `appConfig` | `modules/appconfig.bicep` | `appconfig` | None | `nameSuffix`, `publicNetworkAccess: 'Enabled'` |
| `foundry` | `modules/foundry.bicep` | `foundry` | None | `nameSuffix`, `modelDeployments`, `publicNetworkAccess: 'Enabled'` |
| `search` | `modules/search.bicep` | `search` | None | `nameSuffix`, `publicNetworkAccess: 'enabled'` (lowercase) |
| `registry` | `modules/registry.bicep` | `registry` | None | `nameSuffixCompact` |
| `serviceBus` | `modules/servicebus.bicep` | `servicebus` | `if (enableAsyncJobs)` | `nameSuffix` |
| `containerApps` | `modules/containerapps.bicep` | `containerapps` | None | `nameSuffix`, `environmentType`, `logAnalyticsWorkspaceName`, `appInsightsName`, `registryLoginServer`, `imageMcpIdentityId`, `facadeIdentityId`, `enableAsyncJobs`, `settings` |
| `apim` | `modules/apim.bicep` | `apim` | None | `nameSuffix`, `facadeFqdn`, `appInsightsName`, `publisherEmail: apimPublisherEmail` |
| `rbac` | `modules/rbac.bicep` | `rbac` | None | Principal IDs, resource names, `deployerPrincipalId`, `enableAsyncJobs`, `enableExternalProvider` |

### Values passed between modules

| Consumer parameter | Value from |
| --- | --- |
| `storage.logAnalyticsWorkspaceId` | `monitoring.outputs.logAnalyticsId` |
| `containerApps.logAnalyticsWorkspaceName` | `monitoring.outputs.logAnalyticsName` |
| `containerApps.appInsightsName`, `apim.appInsightsName` | `monitoring.outputs.appInsightsName` |
| `containerApps.registryLoginServer` | `registry.outputs.loginServer` |
| `containerApps.imageMcpIdentityId` | `identity.outputs.imageMcpId` |
| `containerApps.facadeIdentityId` | `identity.outputs.facadeId` |
| `containerApps.settings` | `storage.outputs.name`, `cosmos.outputs.endpoint`, `appConfig.outputs.endpoint`, `foundry.outputs.endpoint`, `foundry.outputs.projectEndpoint`, `foundry.outputs.contentSafetyEndpoint`, and `enableAsyncJobs ? serviceBus!.outputs.namespaceName : ''` |
| `apim.facadeFqdn` | `containerApps.outputs.facadeFqdn` |
| `rbac.imageMcpPrincipalId` | `identity.outputs.imageMcpPrincipalId` |
| `rbac.facadePrincipalId` | `identity.outputs.facadePrincipalId` |
| `rbac.storageAccountName` | `storage.outputs.name` |
| `rbac.cosmosAccountName` | `cosmos.outputs.accountName` |
| `rbac.keyVaultName` | `keyVault.outputs.name` |
| `rbac.appConfigName` | `appConfig.outputs.name` |
| `rbac.foundryAccountName` | `foundry.outputs.accountName` |
| `rbac.contentSafetyAccountName` | `foundry.outputs.contentSafetyAccountName` |
| `rbac.registryName` | `registry.outputs.name` |
| `rbac.serviceBusNamespaceName` | `enableAsyncJobs ? serviceBus!.outputs.namespaceName : ''` |

The `!` in `serviceBus!.outputs.namespaceName` is the non-null assertion that Bicep needs to read the output of a conditional module.

### Network access is fixed in the template

`main.bicep` passes `'Enabled'` (or `'enabled'` for Azure AI Search) as a literal. No parameter or flag switches public network access off. The private networking variant described in older versions of [INFRASTRUCTURE.md](../../aidevme-foundry-image-studio/INFRASTRUCTURE.md) (`enablePrivateNetworking`) does not exist in the code.

## Outputs

| Output | Type | Value | Source module |
| --- | --- | --- | --- |
| `resourceGroupName` | `string` | `rg.name` | Resource group |
| `apimGatewayUrl` | `string` | `apim.outputs.gatewayUrl` | `apim` |
| `foundryProjectEndpoint` | `string` | `foundry.outputs.projectEndpoint` | `foundry` |
| `storageAccountName` | `string` | `storage.outputs.name` | `storage` |
| `cosmosEndpoint` | `string` | `cosmos.outputs.endpoint` | `cosmos` |
| `appConfigEndpoint` | `string` | `appConfig.outputs.endpoint` | `appConfig` |
| `containerRegistryLoginServer` | `string` | `registry.outputs.loginServer` | `registry` |
| `searchEndpoint` | `string` | `search.outputs.endpoint` | `search` |

The outputs contain names and endpoints. None contains a key or a secret. Read them after a deployment with:

```bash
az deployment sub show --name image-studio-dev --query properties.outputs
```

The deploy workflow also writes them to the job summary ([Infrastructure deploy workflow](../github/workflows/infra-deploy.md#outputs-and-job-summary)).

## Deployment order

Bicep does not deploy the modules in file order. Azure Resource Manager derives the order from the references between modules and runs independent modules in parallel. The effective order, derived from the module parameters above, is:

| Stage | Modules and resources | Waits for |
| --- | --- | --- |
| 1 | `rg` | None |
| 2 | `monitoring`, `identity`, `cosmos`, `keyVault`, `appConfig`, `foundry`, `search`, `registry`, `serviceBus` (if enabled) | `rg` |
| 3 | `storage` | `monitoring` |
| 4 | `containerApps` | `monitoring`, `registry`, `identity`, `storage`, `cosmos`, `appConfig`, `foundry`, `serviceBus` (if enabled) |
| 5 | `apim` | `containerApps`, `monitoring` |
| Parallel to stages 3 to 5 | `rbac` | `identity`, `storage`, `cosmos`, `keyVault`, `appConfig`, `foundry`, `registry`, `serviceBus` (if enabled) |

Consequences:

- `rbac` does not wait for `containerApps` or `apim`. It starts as soon as its own inputs finish, which includes the model deployments in `foundry`.
- `containerApps` does not wait for `rbac`. The apps can start before the roles exist. The placeholder image makes this safe ([Container apps module](modules/containerapps.md#operational-notes)).
- The slowest steps are the model deployments (one at a time), API Management, and Azure AI Search. The subscription deployment is complete when all of them finish.
- The search module has no dependants, so it runs alongside the others, but a failure of any module fails the deployment.

## Operational notes

- **Incremental mode.** Deployments are incremental. Removing a resource or a module call from the template does not delete the resource from Azure.
- **Deterministic names.** The token depends only on the subscription, `environmentName`, and `location`. A second deployment to the same environment updates the same resources. Changing the region creates a second set of resources with different names.
- **Empty variables.** `main.dev.bicepparam` sets `location` and `apimPublisherEmail` from environment variables with empty defaults. Compilation succeeds when they are unset. The deployment cannot succeed without a region and a publisher e-mail address.

## Known limits

- The template has no `enablePrivateNetworking` flag, no network module, and no Azure Firewall module ([overview](index.md#not-implemented-yet)).
- The optional flags do not validate combinations. For example, `enableExternalProvider` creates only a role assignment.
- The template has not completed a deployment as far as the repository shows. The implementation plan states that the first deployment to `dev` had not completed when it was last updated.

## Related documents

- [Bicep code overview](index.md)
- [Parameter file and linter configuration](parameters.md)
- [Monitoring module](modules/monitoring.md)
- [RBAC module](modules/rbac.md)
- [Infrastructure provisioning with Bicep](../../aidevme-foundry-image-studio/INFRASTRUCTURE.md)
- [Generic Document Style](../../templates/GENERIC_DOCUMENT_STYLE.md)
- [Documentation index](../../index.md)
