# Cosmos DB module

| Field | Value |
| --- | --- |
| **Document Title** | Cosmos DB module |
| **Document Location** | `docs/project-docs/bicep/modules/cosmos.md` |
| **Document Description** | Describes the Bicep module `bicep/modules/cosmos.bicep`, which creates the serverless Azure Cosmos DB account, the `image-studio` database, and the `jobs` container: parameters, resources, outputs, security settings, and known limits. It is intended for engineers who operate or change the infrastructure templates. |
| **Version** | 1.2 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The module `bicep/modules/cosmos.bicep` creates the job store of the architecture (component C13). Read this document to learn the container settings, why the account is serverless, and how data-plane access works.

## Purpose

The account stores job records, audit data, and evaluation data. The record shape is described in [architecture section 9.2](../../../aidevme-foundry-image-studio/ARCHITECTURE.md).

## Parameters

| Name | Type | Default | Decorators | Description |
| --- | --- | --- | --- | --- |
| `location` | `string` | None | None | Azure region. |
| `tags` | `object` | None | None | Tags for every resource. |
| `nameSuffix` | `string` | None | None | Hyphenated name suffix, `<environmentType>-<token>`. |
| `allowedIpAddresses` | `array` | None | None | IP addresses or ranges for the account firewall. |
| `publicNetworkAccess` | `string` | None | None | `Enabled` or `Disabled`. `main.bicep` passes `'Enabled'`. |

## Resources

| Symbolic name | Resource type and API version | Name pattern | Key properties and why they are set |
| --- | --- | --- | --- |
| `account` | `Microsoft.DocumentDB/databaseAccounts@2024-05-15` | `cosmos-<nameSuffix>` (for example `cosmos-dev-<token>`) | `kind: 'GlobalDocumentDB'` (NoSQL API). `databaseAccountOfferType: 'Standard'`. `disableLocalAuth: true` disables keys. `publicNetworkAccess` from the parameter. `ipRules` has one `ipAddressOrRange` for each address. `consistencyPolicy.defaultConsistencyLevel: 'Session'`. One location with `failoverPriority: 0` and `isZoneRedundant: false`. `capabilities: [ { name: 'EnableServerless' } ]` selects serverless mode. |
| `database` | `Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2024-05-15` | `image-studio` | `resource.id: 'image-studio'`. |
| `jobs` | `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2024-05-15` | `jobs` | Partition key path `/tenantId` (`kind: 'Hash'`). `defaultTtl: -1` enables per-item time to live without a default expiry. Indexing mode `consistent`, included path `/*`, and one composite index on `/userId` (ascending) and `/createdAt` (descending), which the `list_recent_visuals` query needs. |

## Outputs

| Output | Type | Value | Consumed by |
| --- | --- | --- | --- |
| `accountName` | `string` | `account.name` | `rbac` |
| `endpoint` | `string` | `account.properties.documentEndpoint` | `containerApps` (`COSMOS_ENDPOINT`) and the `cosmosEndpoint` output of `main.bicep` |

## Security and networking

| Setting | Value | Effect |
| --- | --- | --- |
| `disableLocalAuth` | `true` | Account keys and resource tokens from keys do not work. Clients use Microsoft Entra authentication and Cosmos DB data-plane roles. |
| `publicNetworkAccess` | `Enabled` (from `main.bicep`) | Reachable from the internet. With an empty `allowedIpAddresses` list, the account has no IP restriction. |
| TLS version | Not set | The template sets no minimum TLS version. |
| Backup | Not set | The service default applies. The architecture (section 15) records the default periodic backup and states that continuous backup for `prod` is an open question. |

## Dependencies and consumers

- Depends on: no other module.
- Consumed by: `containerApps` (endpoint) and `rbac` (account name). See the [dependency diagram](../index.md#dependency-diagram).

## Conditions and flags

The module has no condition.

## Operational notes

- **Serverless cannot be changed later.** [INFRASTRUCTURE.md](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md) states that Cosmos DB does not allow switching an existing account between serverless and provisioned throughput. Decide before you create the `prod` account. For `prod`, replace `EnableServerless` with provisioned or autoscale throughput after the load is measured. This statement is taken from that document and not re-verified here.
- **Data-plane access needs a Cosmos DB role assignment.** Azure RBAC roles on the account do not grant data access. The [RBAC module](rbac.md) creates a `sqlRoleAssignments` resource with the built-in data contributor definition `00000000-0000-0000-0000-000000000002`, scoped to the whole account, not to the `jobs` container.
- **Partition key version.** The template sets `kind: 'Hash'` and no `version`. The partition key version that Cosmos DB then applies is not verified.
- **Changing the partition key or the account mode replaces data.** Do not change `/tenantId` or `EnableServerless` on an existing account without a migration plan.
- **Time to live.** `defaultTtl: -1` only enables the feature. A record expires only when it has its own `ttl` value.

## Known limits

- One region, no zone redundancy (`isZoneRedundant: false`), and no automatic failover configuration.
- No private endpoint. Private networking is not implemented ([overview](../index.md#not-implemented-yet)).
- No stored procedures, triggers, or additional containers. The template creates only the `jobs` container.

## Related documents

- [Bicep code overview](../index.md)
- [RBAC module](rbac.md)
- [Architecture, section 9.2: job record](../../../aidevme-foundry-image-studio/ARCHITECTURE.md)
- [Infrastructure provisioning with Bicep](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md)
- [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md)
- [Documentation index](../../../index.md)
