# Search module

| Field | Value |
| --- | --- |
| **Document Title** | Search module |
| **Document Location** | `docs/project-docs/bicep/modules/search.md` |
| **Document Description** | Describes the Bicep module `bicep/modules/search.bicep`, which creates the Azure AI Search service for the brand knowledge index: parameters, resources, outputs, security settings, the known capacity risk, and known limits. It is intended for engineers who operate or change the infrastructure templates. |
| **Version** | 1.2 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The module `bicep/modules/search.bicep` creates the search service that backs the brand knowledge of the architecture (component C9). Read this document to learn how the service is configured and why its deployment can fail in Sweden Central.

## Purpose

The service stores the Foundry IQ brand knowledge index. The templates create the empty service. The index and its content are created by a script (task `P1.7.2` of the [implementation plan](../../../aidevme-foundry-image-studio/IMPLEMENTATION.md)).

## Parameters

| Name | Type | Default | Decorators | Description |
| --- | --- | --- | --- | --- |
| `location` | `string` | None | None | Azure region. |
| `tags` | `object` | None | None | Tags for every resource. |
| `nameSuffix` | `string` | None | None | Hyphenated name suffix, `<environmentType>-<token>`. |
| `publicNetworkAccess` | `string` | None | `@allowed([ 'enabled', 'disabled' ])` | Lowercase values. `main.bicep` passes `'enabled'`. This is the only module that restricts the value, and it uses lowercase, while the other modules use `Enabled` and `Disabled`. |

## Resources

| Symbolic name | Resource type and API version | Name pattern | Key properties and why they are set |
| --- | --- | --- | --- |
| `search` | `Microsoft.Search/searchServices@2024-06-01-preview` | `srch-<nameSuffix>` (for example `srch-dev-<token>`) | `sku: { name: 'basic' }`. `identity: { type: 'SystemAssigned' }`. `replicaCount: 1` and `partitionCount: 1`. `hostingMode: 'default'`. `publicNetworkAccess` from the parameter. `disableLocalAuth: true` disables API keys. |

## Outputs

| Output | Type | Value | Consumed by |
| --- | --- | --- | --- |
| `name` | `string` | `search.name` | No module |
| `endpoint` | `string` | `'https://${search.name}.search.windows.net'` | The `searchEndpoint` output of `main.bicep` only |

The endpoint is built with the public-cloud host name suffix `search.windows.net`.

## Security and networking

| Setting | Value | Effect |
| --- | --- | --- |
| `disableLocalAuth` | `true` | API keys are disabled. Callers use Microsoft Entra authentication and Azure roles. |
| `identity` | System-assigned | The service has an identity, for example for indexers that read from Storage. No role is assigned to it. |
| `publicNetworkAccess` | `enabled` (from `main.bicep`) | Reachable from the internet, protected by Entra authentication. |

## Dependencies and consumers

- Depends on: no other module.
- Consumed by: no module. Only `main.bicep` returns the endpoint. See the [dependency diagram](../index.md#dependency-diagram).

## Conditions and flags

The module has no condition.

## Operational notes

- **Capacity risk in Sweden Central.** The architecture risk register records that Azure AI Search `basic` failed in Sweden Central with "insufficient capacity in region" on 2026-09-29, after 39 minutes, and that it blocked the whole deployment ([architecture section 21.1](../../../aidevme-foundry-image-studio/ARCHITECTURE.md#211-risks)). The cause is reported from earlier attempts and is not visible in the templates. Open question 12 asks which SKU and region to use. The search service has no dependency on other modules, so it runs in parallel with them, but the subscription deployment fails if the service fails.
- **Preview API version.** `2024-06-01-preview` is a preview API version. Confirm that it is available in the region before a deployment.
- **No roles are assigned.** With local authentication disabled, no identity can use the service until roles are assigned. The [RBAC module](rbac.md) has no assignment for the search service, not even for the deployer. The architecture expects the Foundry project identity to have `Search Index Data Reader` and `Search Service Contributor`. These assignments are missing from the template.
- **No `authOptions`.** The template does not set `authOptions`. The service accepts Entra authentication only, because `disableLocalAuth` is `true`.
- **The apps do not receive the endpoint.** `containerApps` gets no search setting.

## Known limits

- Fixed size: one replica and one partition.
- No private endpoint. Private networking is not implemented ([overview](../index.md#not-implemented-yet)).
- No index, data source, indexer, or semantic ranker configuration.

## Related documents

- [Bicep code overview](../index.md)
- [RBAC module](rbac.md)
- [Architecture, section 21: risks and open questions](../../../aidevme-foundry-image-studio/ARCHITECTURE.md#21-risks-and-open-questions)
- [Infrastructure provisioning with Bicep](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md)
- [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md)
- [Documentation index](../../../index.md)
