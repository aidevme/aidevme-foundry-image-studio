# API Management module

| Field | Value |
| --- | --- |
| **Document Title** | API Management module |
| **Document Location** | `docs/project-docs/bicep/modules/apim.md` |
| **Document Description** | Describes the Bicep module `bicep/modules/apim.bicep`, which creates the Azure API Management instance, the facade backend, the Image Studio API, and the Application Insights logger: parameters, resources, outputs, security settings, provisioning time, and known limits. It is intended for engineers who operate or change the infrastructure templates. |
| **Version** | 1.3 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The module `bicep/modules/apim.bicep` creates the AI gateway of the architecture (component C2). Read this document to learn what the gateway contains today and what is still missing before it can serve traffic.

## Purpose

API Management is the intended entry point for clients. It authenticates callers, applies quotas and rate limits, and meters usage per subscription ([architecture section 4](../../../aidevme-foundry-image-studio/ARCHITECTURE.md#4-logical-components)). The module creates the instance, a backend that points to the facade, an API shell, and a logger. The policy, the operations, the products, and the subscriptions are not created.

## Parameters

| Name | Type | Default | Decorators | Description |
| --- | --- | --- | --- | --- |
| `location` | `string` | None | None | Azure region. |
| `tags` | `object` | None | None | Tags for every resource. |
| `nameSuffix` | `string` | None | None | Hyphenated name suffix, `<environmentType>-<token>`. |
| `facadeFqdn` | `string` | None | None | Host name of the facade app. |
| `appInsightsName` | `string` | None | None | Name of the existing Application Insights component. |
| `publisherEmail` | `string` | None | None | Publisher e-mail address. `main.bicep` passes `apimPublisherEmail`. |
| `publisherName` | `string` | `'AIDevMe'` | None | Publisher name. `main.bicep` does not override it. |

## Resources

| Symbolic name | Resource type and API version | Name pattern | Key properties and why they are set |
| --- | --- | --- | --- |
| `appInsights` | `Microsoft.Insights/components@2020-02-02` (`existing`) | From `appInsightsName` | Source of the resource ID and the instrumentation key for the logger. |
| `apim` | `Microsoft.ApiManagement/service@2023-09-01-preview` | `apim-<nameSuffix>` (for example `apim-dev-<token>`) | `sku: { name: 'Developer', capacity: 1 }`. `identity: { type: 'SystemAssigned' }`. `publisherEmail` and `publisherName`. No virtual network settings. |
| `facadeBackend` | `Microsoft.ApiManagement/service/backends@2023-09-01-preview` | `image-studio-facade` | `protocol: 'http'`, `url: 'https://<facadeFqdn>'`. |
| `facadeApi` | `Microsoft.ApiManagement/service/apis@2023-09-01-preview` | `image-studio` | `displayName: 'Image Studio'`, `path: 'image-studio'`, `protocols: [ 'https' ]`, `subscriptionRequired: true`, `serviceUrl: 'https://<facadeFqdn>'`. |
| `logger` | `Microsoft.ApiManagement/service/loggers@2023-09-01-preview` | `appinsights` | `loggerType: 'applicationInsights'`, `resourceId: appInsights.id`, `credentials: { instrumentationKey: appInsights.properties.InstrumentationKey }`. |

## Outputs

| Output | Type | Value | Consumed by |
| --- | --- | --- | --- |
| `gatewayUrl` | `string` | `apim.properties.gatewayUrl` | The `apimGatewayUrl` output of `main.bicep` |
| `principalId` | `string` | `apim.identity.principalId` | No module |

## Security and networking

| Setting | Value | Effect |
| --- | --- | --- |
| SKU | `Developer`, capacity 1 | No service level agreement. Not for production use. |
| `identity` | System-assigned | The identity exists, but no role is assigned to it. |
| `subscriptionRequired` | `true` on the API | Callers must present a subscription key, but no product or subscription exists yet. |
| Network | No virtual network | The gateway is public. |
| Token validation | Not implemented | No policy validates a Microsoft Entra token. |

## Dependencies and consumers

- Depends on: `containerApps` (`facadeFqdn`) and `monitoring` (`appInsightsName`).
- Consumed by: no module. `main.bicep` returns `gatewayUrl`. See the [dependency diagram](../index.md#dependency-diagram).

## Conditions and flags

The module has no condition.

## Operational notes

- **Provisioning time.** [INFRASTRUCTURE.md](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md) states that an API Management instance can take 30 to 45 minutes to create, and longer for Premium and virtual network deployments. This module is the longest step of the subscription deployment after the model deployments. It has not been observed in this repository.
- **Soft delete reserves the name.** A deleted API Management instance stays soft-deleted, and a redeployment with the same name fails. The [Infrastructure delete workflow](../../github/workflows/infra-delete.md) purges it when `purge_soft_deleted` is selected.
- **Preview API version.** All four resource types use `2023-09-01-preview`. Confirm that it is available in the region.
- **Empty publisher e-mail.** `main.dev.bicepparam` reads `APIM_PUBLISHER_EMAIL` with an empty default. An empty value is not rejected at compile time. The service is expected to reject it at deployment. The exact error is not verified.
- **Logger without diagnostic.** The logger is only declared. No API or service diagnostic setting uses it, so the gateway sends no request telemetry yet. The logger also uses the instrumentation key, which conflicts with `DisableLocalAuth: true` on the component ([Monitoring module](monitoring.md#operational-notes)).
- **API shell without operations.** The API `image-studio` has no operations, so it exposes nothing until the contract is added.
- **Backend and API both hold the URL.** The `facadeBackend` resource is not referenced by the API. A policy that uses `set-backend-service` is needed to use it.
- **No role for the API Management identity.** The [RBAC module](rbac.md) assigns no role to it. The architecture (section 10.1) states that the facade trusts API Management through a validated token and the API Management identity. The facade has external ingress and no authentication in the template, so this trust is not implemented.

## Known limits

- The API policy (token validation, quotas, rate limits, metering), products, and subscriptions are not created ([overview](../index.md#not-implemented-yet)).
- The architecture open question 10 asks whether API Management supports the streamable HTTP transport that MCP uses at the chosen SKU. It is not verified.
- No virtual network integration. The `Developer` SKU is the only SKU in the template.

## Related documents

- [Bicep code overview](../index.md)
- [Container apps module](containerapps.md)
- [Monitoring module](monitoring.md)
- [Architecture, section 4: logical components](../../../aidevme-foundry-image-studio/ARCHITECTURE.md#4-logical-components)
- [Infrastructure provisioning with Bicep](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md)
- [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md)
- [Documentation index](../../../index.md)
