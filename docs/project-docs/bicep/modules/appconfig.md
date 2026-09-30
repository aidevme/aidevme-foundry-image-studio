# App Configuration module

| Field | Value |
| --- | --- |
| **Document Title** | App Configuration module |
| **Document Location** | `docs/project-docs/bicep/modules/appconfig.md` |
| **Document Description** | Describes the Bicep module `bicep/modules/appconfig.bicep`, which creates the Azure App Configuration store that holds the model routing table: parameters, resources, outputs, security settings, soft delete, and known limits. It is intended for engineers who operate or change the infrastructure templates. |
| **Version** | 1.3 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The module `bicep/modules/appconfig.bicep` creates the store for the routing table of the model router (components C7 and C15). Read this document to learn how the store is secured and why the template does not load the routing table.

## Purpose

The Image MCP server reads the tier-to-deployment routing table from this store. The table format is described in [architecture section 6.2](../../../aidevme-foundry-image-studio/ARCHITECTURE.md#62-tier-routing-table). The template creates the empty store only. A post-provisioning step loads the table so that routing changes go through pull requests and the evaluation gate (see [INFRASTRUCTURE.md](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md)).

## Parameters

| Name | Type | Default | Decorators | Description |
| --- | --- | --- | --- | --- |
| `location` | `string` | None | None | Azure region. |
| `tags` | `object` | None | None | Tags for every resource. |
| `nameSuffix` | `string` | None | None | Hyphenated name suffix, `<environmentType>-<token>`. |
| `publicNetworkAccess` | `string` | None | None | `Enabled` or `Disabled`. `main.bicep` passes `'Enabled'`. |

## Resources

| Symbolic name | Resource type and API version | Name pattern | Key properties and why they are set |
| --- | --- | --- | --- |
| `store` | `Microsoft.AppConfiguration/configurationStores@2023-03-01` | `appcs-<nameSuffix>` (for example `appcs-dev-<token>`) | `sku: { name: 'standard' }`. `disableLocalAuth: true` disables access keys. `publicNetworkAccess` from the parameter. `softDeleteRetentionInDays: 7` enables soft delete for 7 days. |

## Outputs

| Output | Type | Value | Consumed by |
| --- | --- | --- | --- |
| `name` | `string` | `store.name` | `rbac` |
| `endpoint` | `string` | `store.properties.endpoint` | `containerApps` (`APP_CONFIG_ENDPOINT`) and the `appConfigEndpoint` output of `main.bicep` |

## Security and networking

| Setting | Value | Effect |
| --- | --- | --- |
| `disableLocalAuth` | `true` | Only Microsoft Entra authentication works. Connection strings with access keys are not usable. |
| `publicNetworkAccess` | `Enabled` (from `main.bicep`) | Reachable from the internet, protected by Entra authentication. |
| `softDeleteRetentionInDays` | `7` | A deleted store is kept in a soft-deleted state for 7 days. |

## Dependencies and consumers

- Depends on: no other module.
- Consumed by: `containerApps` (endpoint) and `rbac` (store name). See the [dependency diagram](../index.md#dependency-diagram).

## Conditions and flags

The module has no condition.

## Operational notes

- **Soft delete reserves the name.** If you delete the resource group, the store name stays reserved for the retention period, and a redeployment fails with a name conflict. The [Infrastructure delete workflow](../../github/workflows/infra-delete.md) purges soft-deleted App Configuration stores when `purge_soft_deleted` is selected.
- **Loading the table.** The Image MCP identity has `App Configuration Data Reader`. Writing keys needs `App Configuration Data Owner`, which the [RBAC module](rbac.md) assigns only to `deployerPrincipalId` (empty in the workflow runs). The loader for `config/routing.yaml` is not part of the templates and is not implemented in this repository state.
- **Purge protection** is not enabled on the store.

## Known limits

- No private endpoint. Private networking is not implemented ([overview](../index.md#not-implemented-yet)).
- No configuration keys, feature flags, or Key Vault references are created.

## Related documents

- [Bicep code overview](../index.md)
- [RBAC module](rbac.md)
- [Architecture, section 6.2: tier routing table](../../../aidevme-foundry-image-studio/ARCHITECTURE.md#62-tier-routing-table)
- [Infrastructure delete workflow](../../github/workflows/infra-delete.md)
- [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md)
- [Documentation index](../../../index.md)
