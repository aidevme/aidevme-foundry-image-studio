# Monitoring module

| Field | Value |
| --- | --- |
| **Document Title** | Monitoring module |
| **Document Location** | `docs/project-docs/bicep/modules/monitoring.md` |
| **Document Description** | Describes the Bicep module `bicep/modules/monitoring.bicep`, which creates the Log Analytics workspace and the Application Insights component: parameters, resources, outputs, security settings, consumers, and known limits. It is intended for engineers who operate or change the infrastructure templates. |
| **Version** | 1.2 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The module `bicep/modules/monitoring.bicep` creates the log store and the telemetry component that the other modules use. Read this document to learn what the module creates, which outputs other modules consume, and which settings affect telemetry ingestion. Naming rules and the overall module layout are described in the [Bicep code overview](../index.md).

## Purpose

The module provides:

- A Log Analytics workspace, which receives the Storage blob logs and the Container Apps environment logs.
- A workspace-based Application Insights component, which receives application telemetry and the API Management logger data.

## Parameters

| Name | Type | Default | Decorators | Description |
| --- | --- | --- | --- | --- |
| `location` | `string` | None | None | Azure region of the resources. `main.bicep` passes its `location` value. |
| `tags` | `object` | None | None | Tags for every resource. `main.bicep` passes `allTags`. |
| `nameSuffix` | `string` | None | None | Hyphenated name suffix, `<environmentType>-<token>`. |

## Resources

| Symbolic name | Resource type and API version | Name pattern | Key properties and why they are set |
| --- | --- | --- | --- |
| `logAnalytics` | `Microsoft.OperationalInsights/workspaces@2023-09-01` | `log-<nameSuffix>` (for example `log-dev-<token>`) | `sku.name: 'PerGB2018'` selects pay-per-GB pricing. `retentionInDays: 30` keeps logs for 30 days. |
| `appInsights` | `Microsoft.Insights/components@2020-02-02` | `appi-<nameSuffix>` (for example `appi-dev-<token>`) | `kind: 'web'` and `Application_Type: 'web'` select the web application type. `WorkspaceResourceId: logAnalytics.id` makes the component workspace-based. `DisableLocalAuth: true` rejects telemetry that is not authenticated with Microsoft Entra ID. |

## Outputs

| Output | Type | Value | Consumed by |
| --- | --- | --- | --- |
| `logAnalyticsId` | `string` | `logAnalytics.id` | `storage` (diagnostic setting target) |
| `logAnalyticsName` | `string` | `logAnalytics.name` | `containerApps` |
| `appInsightsId` | `string` | `appInsights.id` | No module |
| `appInsightsName` | `string` | `appInsights.name` | `containerApps`, `apim` |

The module returns no connection string and no instrumentation key. The `containerApps` and `apim` modules read them from the existing Application Insights resource by its name.

## Security and networking

| Setting | Value | Effect |
| --- | --- | --- |
| `DisableLocalAuth` (Application Insights) | `true` | Ingestion requires Microsoft Entra authentication. |
| Network access | Not set | The template sets no network access property on either resource. The service defaults apply. |

## Dependencies and consumers

- Depends on: no other module.
- Consumed by: `storage`, `containerApps`, and `apim`. See the [dependency diagram](../index.md#dependency-diagram).

## Conditions and flags

The module has no condition. `main.bicep` always deploys it.

## Operational notes

- The module is the first one that other modules need. `storage` and `containerApps` wait for it.
- **Entra authentication for telemetry.** `DisableLocalAuth: true` means that a client that sends telemetry with only the connection string or the instrumentation key is expected to be rejected. The template passes the connection string to the container apps (`APPLICATIONINSIGHTS_CONNECTION_STRING`) and the instrumentation key to the API Management logger, and it assigns no role for telemetry ingestion (for example `Monitoring Metrics Publisher`) to any identity. Whether telemetry from the container apps and from API Management arrives with this setting is not verified. [INFRASTRUCTURE.md](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md) recommends setting the value to `false` in `dev` if the OpenTelemetry exporter is not configured for Entra authentication.

## Known limits

- Retention is fixed at 30 days and is not a parameter.
- No daily cap, alert rule, or diagnostic setting for these resources is defined. The alerts described in the architecture (section 14.2) are not implemented.

## Related documents

- [Bicep code overview](../index.md)
- [Container apps module](containerapps.md)
- [Storage module](storage.md)
- [API Management module](apim.md)
- [Infrastructure provisioning with Bicep](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md)
- [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md)
- [Documentation index](../../../index.md)
