# Foundry module

| Field | Value |
| --- | --- |
| **Document Title** | Foundry module |
| **Document Location** | `docs/project-docs/bicep/modules/foundry.md` |
| **Document Description** | Describes the Bicep module `bicep/modules/foundry.bicep`, which creates the Microsoft Foundry resource, the `image-studio` project, the model deployments, and the Azure AI Content Safety account: parameters, resources, the `modelDeployments` element shape, outputs, security settings, and known limits. It is intended for engineers who operate or change the infrastructure templates. |
| **Version** | 1.3 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The module `bicep/modules/foundry.bicep` creates the AI services of the architecture (components C4, C5, C8, and C14). Read this document to learn how model deployments are declared, which properties are fixed, and which operational risks apply. The values of the deployments for `dev` are in the [parameter file document](../parameters.md#model-deployments).

## Purpose

The module provides:

- A Microsoft Foundry resource (Azure AI Services account) that hosts the agents and the model deployments.
- A project `image-studio` under that resource.
- One model deployment for each element of the `modelDeployments` array.
- A separate Azure AI Content Safety account for prompt and output moderation.

## Parameters

| Name | Type | Default | Decorators | Description |
| --- | --- | --- | --- | --- |
| `location` | `string` | None | None | Azure region of both accounts and the project. |
| `tags` | `object` | None | None | Tags for every resource. |
| `nameSuffix` | `string` | None | None | Hyphenated name suffix, `<environmentType>-<token>`. |
| `publicNetworkAccess` | `string` | None | None | `Enabled` or `Disabled`. `main.bicep` passes `'Enabled'`. Applies to both accounts. |
| `modelDeployments` | `array` | None | `@description('Array of { name, model, format, version, skuName, capacity }.')` | Model deployments to create. |

The module declares two variables: `foundryName` (`'ais-${nameSuffix}'`) and `projectName` (`'image-studio'`).

### Element of `modelDeployments`

The template reads six properties of each element without a type check. A missing property fails at deployment.

| Property | Used for | Example (from `main.dev.bicepparam`) |
| --- | --- | --- |
| `name` | Deployment name, which is the resource name. The routing table refers to this name. | `img-std-gpt-image-2-5-flare` |
| `model` | `properties.model.name` | `gpt-image-2.5-flare` |
| `format` | `properties.model.format` | `OpenAI` |
| `version` | `properties.model.version` | `2026-09-08` |
| `skuName` | `sku.name` | `GlobalStandard` |
| `capacity` | `sku.capacity` | `1` |

## Resources

| Symbolic name | Resource type and API version | Name pattern | Key properties and why they are set |
| --- | --- | --- | --- |
| `account` | `Microsoft.CognitiveServices/accounts@2025-06-01` | `ais-<nameSuffix>` (for example `ais-dev-<token>`) | `kind: 'AIServices'`. `sku: { name: 'S0' }`. `identity: { type: 'SystemAssigned' }`. `customSubDomainName` equals the account name, which Microsoft Entra authentication needs. `allowProjectManagement: true` allows child projects. `disableLocalAuth: true` disables API keys. `publicNetworkAccess` from the parameter. |
| `project` | `Microsoft.CognitiveServices/accounts/projects@2025-06-01` | `image-studio` | Child of `account`. `location` and `tags` as the account. `identity: { type: 'SystemAssigned' }`. `displayName: 'AIDevMe Foundry Image Studio'`. `description: 'Agents and tools for governed image generation.'` |
| `deployments` (loop, `@batchSize(1)`) | `Microsoft.CognitiveServices/accounts/deployments@2025-06-01` | `d.name` | Child of `account`. `sku: { name: d.skuName, capacity: d.capacity }`. `properties.model` from `d.format`, `d.model`, `d.version`. `versionUpgradeOption: 'NoAutoUpgrade'` pins the version (ADR-006). `dependsOn: [ project ]` starts deployments after the project exists. |
| `contentSafety` | `Microsoft.CognitiveServices/accounts@2025-06-01` | `cs-<nameSuffix>` (for example `cs-dev-<token>`) | `kind: 'ContentSafety'`. `sku: { name: 'S0' }`. `identity: { type: 'SystemAssigned' }`. `customSubDomainName: 'cs-${nameSuffix}'`. `disableLocalAuth: true`. `publicNetworkAccess` from the parameter. |

## Outputs

| Output | Type | Value | Consumed by |
| --- | --- | --- | --- |
| `accountName` | `string` | `account.name` | `rbac` |
| `endpoint` | `string` | `account.properties.endpoint` | `containerApps` (`FOUNDRY_ENDPOINT`) |
| `projectName` | `string` | `project.name` | No module |
| `projectEndpoint` | `string` | `'https://${account.name}.services.ai.azure.com/api/projects/${project.name}'` | `containerApps` (`FOUNDRY_PROJECT_ENDPOINT`) and the `foundryProjectEndpoint` output of `main.bicep` |
| `contentSafetyAccountName` | `string` | `contentSafety.name` | `rbac` |
| `contentSafetyEndpoint` | `string` | `contentSafety.properties.endpoint` | `containerApps` (`CONTENT_SAFETY_ENDPOINT`) |

The `projectEndpoint` value is built from a fixed pattern and is not read from the resource. [INFRASTRUCTURE.md](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md) advises confirming the pattern in the portal after the first deployment. It has not been confirmed.

## Security and networking

| Setting | Value | Effect |
| --- | --- | --- |
| `disableLocalAuth` | `true` on both accounts | No API keys. Callers use Microsoft Entra authentication and roles. |
| `identity` | System-assigned on both accounts and on the project | Each resource has its own identity. The templates assign no roles to them. |
| `publicNetworkAccess` | `Enabled` (from `main.bicep`) | Reachable from the internet, protected by Entra authentication. |
| `versionUpgradeOption` | `NoAutoUpgrade` | A deployment never moves to a new model version by itself. |

## Dependencies and consumers

- Depends on: no other module.
- Consumed by: `containerApps` (three endpoints) and `rbac` (two account names). See the [dependency diagram](../index.md#dependency-diagram).

## Conditions and flags

The module has no condition. The set of model deployments is controlled only by the `modelDeployments` parameter.

## Operational notes

- **`@batchSize(1)` serializes the deployments.** [INFRASTRUCTURE.md](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md) states that creating several deployments on one account in parallel commonly fails with a conflict error. The total time is the sum of the deployment times. Keep the decorator.
- **Model facts change.** Model names, versions, `format` values, SKUs, and capacity depend on the region and the subscription. Read them from the model catalog on the day of deployment (`az cognitiveservices model list`). The values in `main.dev.bicepparam` were read on 2026-09-29 for Sweden Central ([architecture section 6.1](../../../aidevme-foundry-image-studio/ARCHITECTURE.md#61-image-model-catalog-foundry-sold-directly-by-azure)).
- **`GlobalStandard` only.** The architecture records that the image models are offered only with the `GlobalStandard` SKU, so processing outside the EU cannot be excluded (risk R-8, ADR-010).
- **Quota.** The observed default quota on 2026-09-29 is low (architecture section 15). A capacity above the quota fails with `InsufficientQuota`. The unit of `capacity` for image models is not verified.
- **Slow creation.** The architecture risk register records Foundry and Content Safety accounts that stayed in `Creating` for over 45 minutes on 2026-09-29. Allow long timeouts.
- **Soft delete reserves the names.** A deleted Foundry or Content Safety account stays soft-deleted, and a redeployment with the same name fails (`FlagMustBeSetForRestore` or a name conflict). The [Infrastructure delete workflow](../../github/workflows/infra-delete.md) purges these accounts.
- **`dependsOn: [ project ]`.** The template contains no comment that explains this dependency. The reason is not verified.
- **Changing a deployment.** A change to `model`, `version`, or `skuName` of an existing deployment name can be rejected by the service. Add a new deployment with a new name instead, and change the routing table, as described in [INFRASTRUCTURE.md](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md).
- **Reasoning model.** The reasoning model `llm-agents` is an element of the same array. The architecture states that it is unconfirmed whether the chosen model accepts image input (open question 11).

## Known limits

- The `dev` parameter file deploys only the draft (`gpt-image-1-mini`), standard (`gpt-image-2.5-flare`), and reasoning (`gpt-5.4`) deployments. The precision, fallback, and alternative deployments of the routing table are not deployed.
- No private endpoint and no bring-your-own virtual network. Private networking is not implemented ([overview](../index.md#not-implemented-yet)).
- No content filter policy (`raiPolicyName`) is set on the deployments.
- No capability host or agent definition is created. Agents are data-plane objects that a script deploys.

## Related documents

- [Bicep code overview](../index.md)
- [Parameter file and linter configuration](../parameters.md)
- [RBAC module](rbac.md)
- [Container apps module](containerapps.md)
- [Architecture, section 6: model strategy](../../../aidevme-foundry-image-studio/ARCHITECTURE.md#6-model-strategy)
- [Infrastructure provisioning with Bicep](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md)
- [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md)
- [Documentation index](../../../index.md)
