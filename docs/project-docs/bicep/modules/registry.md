# Registry module

| Field | Value |
| --- | --- |
| **Document Title** | Registry module |
| **Document Location** | `docs/project-docs/bicep/modules/registry.md` |
| **Document Description** | Describes the Bicep module `bicep/modules/registry.bicep`, which creates the Azure Container Registry for the service images: parameters, resources, outputs, security settings, and known limits. It is intended for engineers who operate or change the infrastructure templates. |
| **Version** | 1.2 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The module `bicep/modules/registry.bicep` creates the registry from which the container apps pull their images. Read this document to learn how the registry is secured and how image pulls are authorized.

## Purpose

The registry stores the images of the Image MCP server, the facade, and the worker. The container apps pull images with their managed identities and the `AcrPull` role, not with an admin user.

## Parameters

| Name | Type | Default | Decorators | Description |
| --- | --- | --- | --- | --- |
| `location` | `string` | None | None | Azure region. |
| `tags` | `object` | None | None | Tags for every resource. |
| `nameSuffixCompact` | `string` | None | `@minLength(8)` | Name suffix without a hyphen, `<environmentType><token>`. |

The module has no `publicNetworkAccess` parameter.

## Resources

| Symbolic name | Resource type and API version | Name pattern | Key properties and why they are set |
| --- | --- | --- | --- |
| `registry` | `Microsoft.ContainerRegistry/registries@2023-07-01` | `cr<nameSuffixCompact>` (for example `crdev<token>`) | `sku: { name: 'Standard' }`. `adminUserEnabled: false` disables the shared admin credential. |

## Outputs

| Output | Type | Value | Consumed by |
| --- | --- | --- | --- |
| `name` | `string` | `registry.name` | `rbac` |
| `loginServer` | `string` | `registry.properties.loginServer` | `containerApps` (registry configuration of the apps and the job) and the `containerRegistryLoginServer` output of `main.bicep` |

## Security and networking

| Setting | Value | Effect |
| --- | --- | --- |
| `adminUserEnabled` | `false` | No username and password. Access needs Microsoft Entra authentication and a role such as `AcrPull`. |
| Network access | Not set | The registry has public access. The template sets no network rule set. |
| Anonymous pull | Not set | The service default applies. |

## Dependencies and consumers

- Depends on: no other module.
- Consumed by: `containerApps` (login server) and `rbac` (registry name). See the [dependency diagram](../index.md#dependency-diagram).

## Conditions and flags

The module has no condition.

## Operational notes

- **Pull authorization.** The [RBAC module](rbac.md) assigns `AcrPull` on the registry to both identities. `containerApps` and `rbac` have no dependency on each other, so the role assignments can complete after the apps are created. The apps start with a public placeholder image, so provisioning does not need the pull to work ([Container apps module](containerapps.md#operational-notes)).
- **Push access.** No identity has a push role, and the deployer receives no registry role. Pushing the first images needs a role such as `AcrPush`, which the templates do not assign, or another mechanism that this repository has not implemented.
- **Premium for private networking.** [INFRASTRUCTURE.md](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md) states that private endpoints need the `Premium` SKU. The template uses `Standard`.

## Known limits

- No geo-replication, content trust, or retention policy.
- No private endpoint. Private networking is not implemented ([overview](../index.md#not-implemented-yet)).
- No image is built or pushed by the templates or by a workflow.

## Related documents

- [Bicep code overview](../index.md)
- [Container apps module](containerapps.md)
- [RBAC module](rbac.md)
- [Infrastructure provisioning with Bicep](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md)
- [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md)
- [Documentation index](../../../index.md)
