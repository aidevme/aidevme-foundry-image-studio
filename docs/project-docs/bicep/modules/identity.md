# Identity module

| Field | Value |
| --- | --- |
| **Document Title** | Identity module |
| **Document Location** | `docs/project-docs/bicep/modules/identity.md` |
| **Document Description** | Describes the Bicep module `bicep/modules/identity.bicep`, which creates the two user-assigned managed identities of the Image MCP server and the facade: parameters, resources, outputs, consumers, and known limits. It is intended for engineers who operate or change the infrastructure templates. |
| **Version** | 1.2 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The module `bicep/modules/identity.bicep` creates the identities that the container apps use to call Azure services. Read this document to learn which identities exist, why they are created before the apps, and which outputs other modules use. The role assignments of these identities are in the [RBAC module](rbac.md).

## Purpose

The module creates one user-assigned managed identity for the Image MCP server (and the worker job) and one for the facade. Creating the identities in their own module lets `containerApps` attach them and `rbac` grant roles to them without a dependency between `containerApps` and `rbac`.

## Parameters

| Name | Type | Default | Decorators | Description |
| --- | --- | --- | --- | --- |
| `location` | `string` | None | None | Azure region of the identities. |
| `tags` | `object` | None | None | Tags for every resource. |
| `environmentName` | `string` | None | None | Environment name (for example `dev`). The module uses `environmentName`, not `environmentType`, in the identity names. |

## Resources

| Symbolic name | Resource type and API version | Name pattern | Key properties and why they are set |
| --- | --- | --- | --- |
| `imageMcp` | `Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31` | `id-image-mcp-<environmentName>` (for example `id-image-mcp-dev`) | No properties. The identity of the Image MCP server app and of the worker job. |
| `facade` | `Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31` | `id-facade-<environmentName>` (for example `id-facade-dev`) | No properties. The identity of the facade app. |

## Outputs

| Output | Type | Value | Consumed by |
| --- | --- | --- | --- |
| `imageMcpId` | `string` | `imageMcp.id` | `containerApps` (identity attachment, registry pull, and Service Bus scaler authentication) |
| `imageMcpPrincipalId` | `string` | `imageMcp.properties.principalId` | `rbac` |
| `facadeId` | `string` | `facade.id` | `containerApps` |
| `facadePrincipalId` | `string` | `facade.properties.principalId` | `rbac` |

The module does not output the client IDs of the identities.

## Security and networking

The identities carry no secret. Access is granted only by role assignments in the [RBAC module](rbac.md). Network settings do not apply.

## Dependencies and consumers

- Depends on: no other module.
- Consumed by: `containerApps` and `rbac`. See the [dependency diagram](../index.md#dependency-diagram).

## Conditions and flags

The module has no condition.

## Operational notes

- **Names contain the environment name, not a token.** The identity names are unique only inside a resource group. This is sufficient because the resource group name also contains the environment name.
- **Shared identity.** The worker job (`enableAsyncJobs`) reuses the Image MCP identity. The identity therefore needs the Service Bus roles, and the [RBAC module](rbac.md) assigns them under the same flag.
- **Replication delay.** A role assignment can fail with `PrincipalNotFound` if the identity is not yet visible to Microsoft Entra ID. The role assignments set `principalType: 'ServicePrincipal'` to reduce this risk (see [INFRASTRUCTURE.md](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md)). This behavior has not been observed here.
- **Client ID.** Application code that uses `DefaultAzureCredential` with a user-assigned identity usually needs the client ID of the identity. The templates neither output the client IDs nor set an `AZURE_CLIENT_ID` environment variable on the apps. How the services select the identity is not defined by the templates and is not verified.

## Known limits

- The identities are created without federated credentials or app roles.
- Agent identities of published Foundry agents are not managed by these templates ([architecture section 10.1](../../../aidevme-foundry-image-studio/ARCHITECTURE.md#101-identity-model)).

## Related documents

- [Bicep code overview](../index.md)
- [RBAC module](rbac.md)
- [Container apps module](containerapps.md)
- [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md)
- [Documentation index](../../../index.md)
