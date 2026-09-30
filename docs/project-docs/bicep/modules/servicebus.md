# Service Bus module

| Field | Value |
| --- | --- |
| **Document Title** | Service Bus module |
| **Document Location** | `docs/project-docs/bicep/modules/servicebus.md` |
| **Document Description** | Describes the Bicep module `bicep/modules/servicebus.bicep`, which creates the Azure Service Bus namespace and the `image-jobs` queue for asynchronous image jobs: parameters, resources, outputs, security settings, the controlling flag, and known limits. It is intended for engineers who operate or change the infrastructure templates. |
| **Version** | 1.2 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The module `bicep/modules/servicebus.bicep` creates the job queue of the architecture (component C11). Read this document to learn the queue settings and how the module is switched on. The module is optional and is deployed only when `enableAsyncJobs` is `true`.

## Purpose

The queue carries asynchronous and batch image jobs from the Image MCP server to the worker job. The flow is described in [architecture section 8.2](../../../aidevme-foundry-image-studio/ARCHITECTURE.md).

## Parameters

| Name | Type | Default | Decorators | Description |
| --- | --- | --- | --- | --- |
| `location` | `string` | None | None | Azure region. |
| `tags` | `object` | None | None | Tags for every resource. |
| `nameSuffix` | `string` | None | None | Hyphenated name suffix, `<environmentType>-<token>`. |

## Resources

| Symbolic name | Resource type and API version | Name pattern | Key properties and why they are set |
| --- | --- | --- | --- |
| `namespace` | `Microsoft.ServiceBus/namespaces@2024-01-01` | `sb-<nameSuffix>` (for example `sb-dev-<token>`) | `sku: { name: 'Standard', tier: 'Standard' }`. `disableLocalAuth: true` disables shared access keys. `minimumTlsVersion: '1.2'`. |
| `jobsQueue` | `Microsoft.ServiceBus/namespaces/queues@2024-01-01` | `image-jobs` | `requiresSession: true` gives every job its own session. `lockDuration: 'PT5M'` (5 minutes). `maxDeliveryCount: 5`. `deadLetteringOnMessageExpiration: true`. `defaultMessageTimeToLive: 'P1D'` (1 day). |

## Outputs

| Output | Type | Value | Consumed by |
| --- | --- | --- | --- |
| `namespaceName` | `string` | `namespace.name` | `containerApps` (`SERVICE_BUS_NAMESPACE` and the scaler rule) and `rbac` (existing-resource reference), both only when the flag is `true` |

## Security and networking

| Setting | Value | Effect |
| --- | --- | --- |
| `disableLocalAuth` | `true` | Shared access signatures and keys are disabled. Senders and receivers use Microsoft Entra authentication and the data roles. |
| `minimumTlsVersion` | `1.2` | Clients need TLS 1.2 or later. |
| Network access | Not set | The service default applies. |

## Dependencies and consumers

- Depends on: no other module.
- Consumed by: `containerApps` and `rbac`, in both cases only when `enableAsyncJobs` is `true`. See the [dependency diagram](../index.md#dependency-diagram).

## Conditions and flags

`main.bicep` declares the module with `if (enableAsyncJobs)`. The flag defaults to `false` and is `false` in `main.dev.bicepparam`. When the flag is `true`, the following also happen:

- `containerApps` creates the worker job `job-image-worker-<environmentType>`.
- `rbac` assigns `Azure Service Bus Data Sender` and `Azure Service Bus Data Receiver` on the namespace to the Image MCP identity.

`main.bicep` reads the output with the non-null assertion `serviceBus!.outputs.namespaceName` inside a conditional expression, and passes an empty string when the flag is `false`.

## Operational notes

- **Sessions.** Every message must carry a session ID, because `requiresSession` is `true`. A sender that omits it fails.
- **Lock and job timeouts.** The message lock lasts 5 minutes, while the worker job allows a replica 900 seconds (15 minutes) to run ([Container apps module](containerapps.md)). A job that runs longer than the lock must renew the lock. How the worker handles this is not implemented in this repository state.
- **Dead letters.** Expired messages and messages that fail 5 times go to the dead-letter sub-queue. The alert on that queue described in the architecture (section 14.2) is not implemented.
- **Premium for private endpoints.** [INFRASTRUCTURE.md](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md) states that private endpoints for Service Bus need the `Premium` SKU. The template uses `Standard`.
- **Turning the flag off.** Bicep deployments are incremental, so setting the flag to `false` after it was `true` does not delete the namespace.

## Known limits

- One queue. No topics, subscriptions, or duplicate-detection settings.
- No private endpoint. Private networking is not implemented ([overview](../index.md#not-implemented-yet)).
- The module has never been deployed. The flag is `false` in every parameter file in the repository.

## Related documents

- [Bicep code overview](../index.md)
- [Container apps module](containerapps.md)
- [RBAC module](rbac.md)
- [Infrastructure provisioning with Bicep](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md)
- [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md)
- [Documentation index](../../../index.md)
