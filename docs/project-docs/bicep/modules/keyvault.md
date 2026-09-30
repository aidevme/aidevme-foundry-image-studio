# Key Vault module

| Field | Value |
| --- | --- |
| **Document Title** | Key Vault module |
| **Document Location** | `docs/project-docs/bicep/modules/keyvault.md` |
| **Document Description** | Describes the Bicep module `bicep/modules/keyvault.bicep`, which creates the Azure Key Vault for the external provider key: parameters, resources, outputs, security settings, soft delete and purge protection, and known limits. It is intended for engineers who operate or change the infrastructure templates. |
| **Version** | 1.3 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The module `bicep/modules/keyvault.bicep` creates the vault for secrets. Read this document before you delete and recreate an environment, because purge protection keeps the vault name reserved.

## Purpose

The vault stores only the API key of the optional external image provider (decision ADR-004 in the [architecture](../../../aidevme-foundry-image-studio/ARCHITECTURE.md#20-architecture-decision-records)). The vault is created in every environment, and it stays empty until a tenant enables that provider.

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
| `vault` | `Microsoft.KeyVault/vaults@2023-07-01` | `kv-<nameSuffix>` (for example `kv-dev-<token>`) | `tenantId: subscription().tenantId`. `sku: { family: 'A', name: 'standard' }`. `enableRbacAuthorization: true` uses Azure RBAC instead of access policies. `enableSoftDelete: true` with `softDeleteRetentionInDays: 30`. `enablePurgeProtection: true`. `publicNetworkAccess` from the parameter. `networkAcls: { defaultAction: 'Allow', bypass: 'AzureServices' }`. |

## Outputs

| Output | Type | Value | Consumed by |
| --- | --- | --- | --- |
| `name` | `string` | `vault.name` | `rbac` |
| `uri` | `string` | `vault.properties.vaultUri` | No module |

## Security and networking

| Setting | Value | Effect |
| --- | --- | --- |
| `enableRbacAuthorization` | `true` | Access is controlled only by Azure RBAC role assignments. |
| `enableSoftDelete` and `softDeleteRetentionInDays` | `true`, 30 | A deleted vault or secret can be recovered for 30 days. |
| `enablePurgeProtection` | `true` | A deleted vault cannot be purged during the retention period. Purge protection cannot be turned off once it is on. |
| `publicNetworkAccess` | `Enabled` (from `main.bicep`) | Reachable from the internet, protected by Entra authentication. |
| `networkAcls.defaultAction` | `Allow` | The firewall does not restrict addresses. |

## Dependencies and consumers

- Depends on: no other module.
- Consumed by: `rbac` (vault name). No other module uses the vault URI. See the [dependency diagram](../index.md#dependency-diagram).

## Conditions and flags

The module has no condition. The flag `enableExternalProvider` does not affect this module. It only controls whether `rbac` assigns `Key Vault Secrets User` to the Image MCP identity.

## Operational notes

- **Purge protection reserves the name.** After you delete the resource group, the soft-deleted vault keeps its name for 30 days and cannot be purged. A new deployment with the same name fails with a name conflict unless the vault is recovered. The deploy workflow runs `az keyvault recover` for soft-deleted vaults whose names start with `kv-<environment>-` before it deploys ([Infrastructure deploy workflow](../../github/workflows/infra-deploy.md)). The name is deterministic, so recreating an environment in the same subscription and region uses the same name. The design decision is ADR-014, which is marked "Accepted, to be revisited" for `dev` and `test`.
- **Nobody can write secrets after deployment.** The templates assign no vault role to the deployer, and the Image MCP identity receives only `Key Vault Secrets User` (read). A person who stores the external provider key needs a role such as `Key Vault Secrets Officer`, which the templates do not assign.
- **Purge protection and retention are one-way settings.** The values in the template apply from the first deployment. Whether the retention period can be changed later is not verified here.

## Known limits

- No private endpoint and no IP allowlist. Private networking is not implemented ([overview](../index.md#not-implemented-yet)).
- No secrets, keys, or certificates are created by the template.
- Diagnostic logging for the vault is not configured.

## Related documents

- [Bicep code overview](../index.md)
- [RBAC module](rbac.md)
- [Infrastructure deploy workflow](../../github/workflows/infra-deploy.md)
- [Infrastructure delete workflow](../../github/workflows/infra-delete.md)
- [Architecture, section 17.2: infrastructure as code](../../../aidevme-foundry-image-studio/ARCHITECTURE.md#172-infrastructure-as-code)
- [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md)
- [Documentation index](../../../index.md)
