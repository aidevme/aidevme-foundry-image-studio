# RBAC module

| Field | Value |
| --- | --- |
| **Document Title** | RBAC module |
| **Document Location** | `docs/project-docs/bicep/modules/rbac.md` |
| **Document Description** | Describes the Bicep module `bicep/modules/rbac.bicep`, which creates the role assignments for the managed identities and the optional deployer: parameters, a table of every assignment with role definition IDs and scopes, conditions, and the assignments from the architecture that the template does not create. It is intended for engineers who operate or change the infrastructure templates. |
| **Version** | 1.3 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The module `bicep/modules/rbac.bicep` grants the data-plane and pull roles that the services need. Read this document to check which identity can do what, to add a role assignment, or to diagnose a `403` response. The design is in [architecture section 10.2](../../../aidevme-foundry-image-studio/ARCHITECTURE.md#102-rbac-least-privilege).

## Purpose

All accounts in the templates disable local authentication, so every access needs a role. This module assigns the roles to the two user-assigned identities and, when `deployerPrincipalId` is set, to the deployer. It also creates one Cosmos DB data-plane role assignment.

## Parameters

| Name | Type | Default | Decorators | Description |
| --- | --- | --- | --- | --- |
| `imageMcpPrincipalId` | `string` | None | None | Principal ID of the Image MCP identity. |
| `facadePrincipalId` | `string` | None | None | Principal ID of the facade identity. |
| `deployerPrincipalId` | `string` | `''` | None | Object ID of the deployer. When empty, the three deployer assignments are skipped. |
| `storageAccountName` | `string` | None | None | Name of the storage account. |
| `cosmosAccountName` | `string` | None | None | Name of the Cosmos DB account. |
| `keyVaultName` | `string` | None | None | Name of the Key Vault. |
| `appConfigName` | `string` | None | None | Name of the App Configuration store. |
| `foundryAccountName` | `string` | None | None | Name of the Foundry account. |
| `contentSafetyAccountName` | `string` | None | None | Name of the Content Safety account. |
| `registryName` | `string` | None | None | Name of the container registry. |
| `serviceBusNamespaceName` | `string` | `''` | None | Name of the Service Bus namespace. Empty when the flag is `false`. |
| `enableAsyncJobs` | `bool` | None | None | Creates the Service Bus assignments and the `existing` reference to the namespace. |
| `enableExternalProvider` | `bool` | None | None | Creates the Key Vault assignment. |

## Role definitions

The variable `roles` maps names to built-in role definition GUIDs. Each assignment builds its `roleDefinitionId` with `subscriptionResourceId('Microsoft.Authorization/roleDefinitions', <GUID>)`.

| Key in `roles` | Role definition ID | Role display name |
| --- | --- | --- |
| `storageBlobDataContributor` | `ba92f5b4-2d11-453d-a403-e96b0029c9fe` | Storage Blob Data Contributor |
| `storageBlobDelegator` | `db58b8e5-c6ad-4a2a-8342-4190687cbf4a` | Storage Blob Delegator |
| `keyVaultSecretsUser` | `4633458b-17de-408a-b874-0445c86b69e6` | Key Vault Secrets User |
| `appConfigDataReader` | `516239f1-63e1-43b4-ac11-4b1a5ea6e3e4` | App Configuration Data Reader |
| `appConfigDataOwner` | `5ae67dd6-50cb-40e7-96ff-dc2bfa4b606b` | App Configuration Data Owner |
| `cognitiveServicesOpenAiUser` | `5e0bd9bd-7b93-4f28-af87-19fc36ad61bd` | Cognitive Services OpenAI User |
| `cognitiveServicesUser` | `a97b65f3-24c7-4388-baec-2e87135dc908` | Cognitive Services User |
| `azureAiUser` | `53ca6127-db72-4b80-b1b0-d745d6d5456d` | Azure AI User |
| `serviceBusDataSender` | `69a216fc-b8fb-44d8-bc22-1f3c2cd27a39` | Azure Service Bus Data Sender |
| `serviceBusDataReceiver` | `4f6d3b9b-027b-4f4c-9142-0e5a2a2247e0` | Azure Service Bus Data Receiver |
| `acrPull` | `7f951dda-4ed3-4680-a7ca-43fe172d538d` | AcrPull |

> **Note:** The template stores only the GUIDs and the key names. The display names in the third column are derived from the key names and from the architecture. The mapping of each GUID to its display name was not verified with `az role definition list` for this document. Verify it with `az role definition list --name "<role name>" --query "[0].name"` before you rely on it.

## Resources

The module declares eight `existing` resources (`storage`, `cosmos`, `vault`, `appConfig`, `foundry`, `contentSafety`, `registry`, and `serviceBus`) and fifteen role assignment resources. `serviceBus` is `existing` only when `enableAsyncJobs` is `true`. The API versions are:

| Resource type | API version |
| --- | --- |
| `Microsoft.Authorization/roleAssignments` | `2022-04-01` |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments` | `2024-05-15` |
| `existing` references | The versions of the resource types in the creating modules: `Microsoft.Storage/storageAccounts@2023-05-01`, `Microsoft.DocumentDB/databaseAccounts@2024-05-15`, `Microsoft.KeyVault/vaults@2023-07-01`, `Microsoft.AppConfiguration/configurationStores@2023-03-01`, `Microsoft.CognitiveServices/accounts@2025-06-01`, `Microsoft.ContainerRegistry/registries@2023-07-01`, `Microsoft.ServiceBus/namespaces@2024-01-01` |

### Role assignments

Every assignment of the identities sets `principalType: 'ServicePrincipal'`. The three deployer assignments set no `principalType`. The name of each assignment is `guid(<scope id>, <principal ID>, <role GUID>)`. The Cosmos DB assignment uses `guid(cosmos.id, imageMcpPrincipalId, 'data-contributor')`.

| Symbolic name | Principal | Role | Role definition ID | Scope | Condition |
| --- | --- | --- | --- | --- | --- |
| `mcpBlobContributor` | Image MCP identity | Storage Blob Data Contributor | `ba92f5b4-2d11-453d-a403-e96b0029c9fe` | Storage account | None |
| `mcpBlobDelegator` | Image MCP identity | Storage Blob Delegator | `db58b8e5-c6ad-4a2a-8342-4190687cbf4a` | Storage account | None |
| `mcpModels` | Image MCP identity | Cognitive Services OpenAI User | `5e0bd9bd-7b93-4f28-af87-19fc36ad61bd` | Foundry account | None |
| `mcpSafety` | Image MCP identity | Cognitive Services User | `a97b65f3-24c7-4388-baec-2e87135dc908` | Content Safety account | None |
| `mcpConfig` | Image MCP identity | App Configuration Data Reader | `516239f1-63e1-43b4-ac11-4b1a5ea6e3e4` | App Configuration store | None |
| `mcpVault` | Image MCP identity | Key Vault Secrets User | `4633458b-17de-408a-b874-0445c86b69e6` | Key Vault | `enableExternalProvider` |
| `mcpQueueSender` | Image MCP identity | Azure Service Bus Data Sender | `69a216fc-b8fb-44d8-bc22-1f3c2cd27a39` | Service Bus namespace | `enableAsyncJobs` |
| `mcpQueueReceiver` | Image MCP identity | Azure Service Bus Data Receiver | `4f6d3b9b-027b-4f4c-9142-0e5a2a2247e0` | Service Bus namespace | `enableAsyncJobs` |
| `cosmosContributor` | Image MCP identity | Cosmos DB built-in data contributor (data plane) | `00000000-0000-0000-0000-000000000002` (Cosmos DB `sqlRoleDefinitions`) | Cosmos DB account (`scope: cosmos.id`) | None |
| `facadeAiUser` | Facade identity | Azure AI User | `53ca6127-db72-4b80-b1b0-d745d6d5456d` | Foundry account | None |
| `mcpAcrPull` | Image MCP identity | AcrPull | `7f951dda-4ed3-4680-a7ca-43fe172d538d` | Container registry | None |
| `facadeAcrPull` | Facade identity | AcrPull | `7f951dda-4ed3-4680-a7ca-43fe172d538d` | Container registry | None |
| `deployerBlob` | Deployer | Storage Blob Data Contributor | `ba92f5b4-2d11-453d-a403-e96b0029c9fe` | Storage account | `!empty(deployerPrincipalId)` |
| `deployerAiUser` | Deployer | Azure AI User | `53ca6127-db72-4b80-b1b0-d745d6d5456d` | Foundry account | `!empty(deployerPrincipalId)` |
| `deployerConfig` | Deployer | App Configuration Data Owner | `5ae67dd6-50cb-40e7-96ff-dc2bfa4b606b` | App Configuration store | `!empty(deployerPrincipalId)` |

The worker job runs with the Image MCP identity, so it uses the Service Bus roles above.

## Outputs

The module has no outputs.

## Security and networking

- The assignments are scoped to single resources, not to the resource group.
- No assignment uses `Owner`, `Contributor`, `User Access Administrator`, or `Role Based Access Control Administrator`.
- The deployer assignments exist for setup scripts in `dev`. The architecture states that they must not exist in `prod`. Leave `deployerPrincipalId` empty for `test` and `prod` (see the description of the parameter in [`main.bicep`](../main.md#parameters)).
- Network settings do not apply.

## Dependencies and consumers

- Depends on: `identity` (principal IDs), `storage`, `cosmos`, `keyVault`, `appConfig`, `foundry`, `registry` (names), and `serviceBus` (name, only when the flag is `true`).
- Consumed by: no module. Nothing depends on `rbac`, and `rbac` does not depend on `containerApps`.
- See the [dependency diagram](../index.md#dependency-diagram).

## Conditions and flags

| Flag or value | Effect |
| --- | --- |
| `enableAsyncJobs` | Adds `mcpQueueSender` and `mcpQueueReceiver`, and makes the `serviceBus` reference `existing`. |
| `enableExternalProvider` | Adds `mcpVault`. |
| `deployerPrincipalId` not empty | Adds `deployerBlob`, `deployerAiUser`, and `deployerConfig`. The value comes from the environment variable `AZURE_PRINCIPAL_ID`, which no workflow sets. |

## Operational notes

- **Assignment names must stay stable.** The name of a role assignment is a GUID from the scope, the principal, and the role. If you change any of these inputs, Azure creates a second assignment and the old one remains. A second assignment with the same principal, role, and scope but a different name fails with `RoleAssignmentExists`. Do not rename existing assignments.
- **Creating identities and assignments together.** A new identity can be invisible to Microsoft Entra ID for a short time, and the assignment can fail with `PrincipalNotFound`. Setting `principalType: 'ServicePrincipal'` avoids most of these failures. Redeploy after a short wait if it happens. This behavior has not been observed in this repository.
- **Permission to assign roles.** The deployment identity needs `User Access Administrator` (or `Owner`) on the subscription ([workflows overview](../../github/workflows/index.md#roles-of-the-deployment-identity)).
- **Propagation.** A `403` response right after a deployment can mean that the assignment has not propagated. Wait a few minutes and retry.
- **Cosmos DB scope.** The data-plane assignment is at account scope, although the architecture names the `jobs` container.
- **Foundry scope.** The Foundry roles are at account scope, although the architecture names the project (`Azure AI User`) and the model deployments (`Cognitive Services OpenAI User`).
- **Deployer principal type.** The deployer assignments set no `principalType`. Azure determines the type. If the deployer is a new service principal that is not yet replicated, the assignment can fail. This is not verified.

## Assignments in the architecture that are not in the template

| Principal | Role | Scope | Where it is described | Status |
| --- | --- | --- | --- | --- |
| Foundry project identity | `Search Index Data Reader` and `Search Service Contributor` | Azure AI Search service | [INFRASTRUCTURE.md](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md), for Foundry IQ (task `P1.7.2`) | Not in the template. The search service has no role assignment for any principal. |
| Foundry account and project identity | `Storage Blob Data Reader` | Storage account | [INFRASTRUCTURE.md](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md), when agents read `brand/` files directly | Not in the template. |
| Facade identity | `Azure AI User` on the Foundry project | Foundry project | [Architecture section 10.2](../../../aidevme-foundry-image-studio/ARCHITECTURE.md#102-rbac-least-privilege) | The template assigns the role at Foundry account scope. |
| Image MCP identity | Cosmos DB built-in data contributor on the `jobs` container | `jobs` container | Architecture section 10.2 | The template assigns the role at account scope. |
| Image MCP identity | `Cognitive Services OpenAI User` on the model deployments | Model deployments | Architecture section 10.2 | The template assigns the role at Foundry account scope. |
| Deployer | Roles on Key Vault, Azure AI Search, Cosmos DB, and the container registry | Those resources | Not described | Not in the template. Nobody can write secrets, create an index, write documents, or push images with the roles the template assigns. |
| Any identity | `Monitoring Metrics Publisher` on Application Insights | Application Insights | Not described | Not in the template, although `DisableLocalAuth` is `true` ([Monitoring module](monitoring.md#operational-notes)). |
| API Management identity | Any role | Not defined | Architecture section 10.1 (facade trusts APIM) | Not in the template. The identity has no assignment. |
| Developers | App role `ImageStudio.User` | Facade app registration | Architecture section 10.2 | Not in the template. Microsoft Entra objects are outside the Bicep code ([INFRASTRUCTURE.md](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md)). |
| Platform team | `Contributor` through PIM | Resource group | Architecture section 10.2 | Not in the template. Configure it in Microsoft Entra ID. |
| Deployment identity (GitHub Actions) | `Contributor` and `User Access Administrator` | Subscription | Architecture section 10.2, [bicep/README.md](../../../../bicep/README.md) | Created by hand, not by the template. |
| Published agent identities | Scoped app role for Image MCP | Not defined | Architecture section 10.1 | Not in the template. |

## Known limits

- Roles for the Key Vault, App Configuration, and Azure AI Search data planes are missing for the people and scripts that must load data, as listed above.
- The `principalType` of the deployer assignments is not set.
- The role definition GUIDs and display names were not verified against a subscription.

## Related documents

- [Bicep code overview](../index.md)
- [Identity module](identity.md)
- [Cosmos DB module](cosmos.md)
- [Search module](search.md)
- [Architecture, section 10: security and identity](../../../aidevme-foundry-image-studio/ARCHITECTURE.md#10-security-and-identity)
- [Infrastructure provisioning with Bicep](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md)
- [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md)
- [Documentation index](../../../index.md)
