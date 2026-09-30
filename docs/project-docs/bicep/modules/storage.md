# Storage module

| Field | Value |
| --- | --- |
| **Document Title** | Storage module |
| **Document Location** | `docs/project-docs/bicep/modules/storage.md` |
| **Document Description** | Describes the Bicep module `bicep/modules/storage.bicep`, which creates the storage account, its blob containers, lifecycle rules, and diagnostic setting: parameters, resources, outputs, security settings, and known limits. It is intended for engineers who operate or change the infrastructure templates. |
| **Version** | 1.2 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The module `bicep/modules/storage.bicep` creates the asset store of the architecture (component C12). Read this document to learn how the account is secured, which containers and lifecycle rules exist, and why clients cannot use account keys.

## Purpose

The storage account holds generated images, input images, brand files, and the icon cache. The Image MCP server writes to it and hands out user-delegation shared access signature (SAS) URLs. The blob layout is described in [architecture section 9.1](../../../aidevme-foundry-image-studio/ARCHITECTURE.md).

## Parameters

| Name | Type | Default | Decorators | Description |
| --- | --- | --- | --- | --- |
| `location` | `string` | None | None | Azure region. |
| `tags` | `object` | None | None | Tags for every resource. |
| `nameSuffixCompact` | `string` | None | `@minLength(8)` | Name suffix without a hyphen, `<environmentType><token>`. |
| `allowedIpAddresses` | `array` | None | None | IP addresses or ranges for the firewall rules. |
| `publicNetworkAccess` | `string` | None | None | `Enabled` or `Disabled`. The module does not restrict the values. `main.bicep` passes `'Enabled'`. |
| `logAnalyticsWorkspaceId` | `string` | None | None | Resource ID of the Log Analytics workspace that receives the blob logs. |

## Resources

| Symbolic name | Resource type and API version | Name pattern | Key properties and why they are set |
| --- | --- | --- | --- |
| `account` | `Microsoft.Storage/storageAccounts@2023-05-01` | `st<nameSuffixCompact>` (for example `stdev<token>`) | `sku.name: 'Standard_ZRS'` (zone-redundant). `kind: 'StorageV2'`. `minimumTlsVersion: 'TLS1_2'`. `allowBlobPublicAccess: false`. `allowSharedKeyAccess: false`. `defaultToOAuthAuthentication: true`. `supportsHttpsTrafficOnly: true`. `publicNetworkAccess` from the parameter. `networkAcls.bypass: 'AzureServices'`. `networkAcls.ipRules` has one `Allow` rule for each address in `allowedIpAddresses`. |
| `blobService` | `Microsoft.Storage/storageAccounts/blobServices@2023-05-01` | `default` | `deleteRetentionPolicy` (7 days) and `containerDeleteRetentionPolicy` (7 days) enable soft delete for blobs and containers. |
| `blobContainers` (loop) | `Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01` | `assets`, `inputs`, `brand`, `icons` | `publicAccess: 'None'` on every container. |
| `lifecycle` | `Microsoft.Storage/storageAccounts/managementPolicies@2023-05-01` | `default` | Rule `delete-inputs-after-7-days`: deletes block blobs with the prefix `inputs/` 7 days after modification. Rule `cool-assets-after-30-days`: moves block blobs with the prefix `assets/` to the cool tier 30 days after modification. |
| `diagnostics` | `Microsoft.Insights/diagnosticSettings@2021-05-01-preview` | `send-to-log-analytics` | Scope is `blobService`. Sends the log category group `allLogs` to the Log Analytics workspace. |

The `networkAcls.defaultAction` expression is `publicNetworkAccess == 'Enabled' && !empty(allowedIpAddresses) ? 'Deny' : 'Allow'`. The firewall denies by default only when public access is enabled and at least one address is given.

## Outputs

| Output | Type | Value | Consumed by |
| --- | --- | --- | --- |
| `name` | `string` | `account.name` | `containerApps` (`STORAGE_ACCOUNT_NAME`), `rbac`, and the `storageAccountName` output of `main.bicep` |
| `id` | `string` | `account.id` | No module |

## Security and networking

| Setting | Value | Effect |
| --- | --- | --- |
| `allowSharedKeyAccess` | `false` | Account keys and account-key SAS are rejected. Only Microsoft Entra authentication and user-delegation SAS work. |
| `defaultToOAuthAuthentication` | `true` | Tools default to Entra authentication. |
| `minimumTlsVersion` | `TLS1_2` | Clients need TLS 1.2 or later. |
| `allowBlobPublicAccess` | `false`, with `publicAccess: 'None'` on each container | No anonymous access. |
| `publicNetworkAccess` | `Enabled` (from `main.bicep`) | Reachable from the internet, protected by Entra authentication and, when addresses are given, by the firewall. |
| Soft delete | 7 days for blobs and for containers | Deleted data can be restored for 7 days. |

## Dependencies and consumers

- Depends on: `monitoring` (`logAnalyticsId`).
- Consumed by: `containerApps` and `rbac`. See the [dependency diagram](../index.md#dependency-diagram).

## Conditions and flags

The module has no condition. Setting `allowedIpAddresses` in the parameter file switches the firewall default to `Deny`.

## Operational notes

- **Shared key access is disabled.** Clients that need a SAS URL must request a user-delegation key with the identity of the caller. The Image MCP identity has `Storage Blob Data Contributor` and `Storage Blob Delegator` for this purpose (see the [RBAC module](rbac.md)). Tools that rely on account keys, including the default key-based access of the Azure portal, fail. Use Entra authentication.
- **The firewall is open in `dev` today.** `main.dev.bicepparam` sets `allowedIpAddresses = []`, so `defaultAction` is `Allow`. The architecture describes `dev` as "Public, IP-restricted"; the parameter file does not restrict it yet.
- **Blob logs can grow.** The diagnostic setting sends `allLogs` for the blob service. Check the ingestion cost in Log Analytics.
- **`publicNetworkAccess` is a plain string.** A value other than `Enabled` or `Disabled` fails at deployment, not at compile time.
- **No private endpoint.** Private networking is not implemented ([overview](../index.md#not-implemented-yet)).

## Known limits

- Blob versioning, immutability policies, and customer-managed keys are not configured.
- The lifecycle rules apply to block blobs only and use the modification time.
- The zone-redundant SKU `Standard_ZRS` must be available in the chosen region. This is not verified for the region of the project.

## Related documents

- [Bicep code overview](../index.md)
- [Monitoring module](monitoring.md)
- [RBAC module](rbac.md)
- [Architecture, section 9: data architecture](../../../aidevme-foundry-image-studio/ARCHITECTURE.md)
- [Infrastructure provisioning with Bicep](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md)
- [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md)
- [Documentation index](../../../index.md)
