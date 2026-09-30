# Parameter file and linter configuration

| Field | Value |
| --- | --- |
| **Document Title** | Parameter file and linter configuration |
| **Document Location** | `docs/project-docs/bicep/parameters.md` |
| **Document Description** | Describes the parameter file `bicep/main.dev.bicepparam` (each parameter, the model deployments, and the environment variables it reads) and the linter configuration `bicep/bicepconfig.json`. It is intended for engineers who deploy the dev environment or add a parameter file for another environment. |
| **Version** | 1.3 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The file `bicep/main.dev.bicepparam` supplies the parameters of [`main.bicep`](main.md) for the `dev` environment. The file `bicep/bicepconfig.json` configures the Bicep linter. Read this document before you deploy `dev`, change a model deployment, or add another environment.

## Parameter file mechanism

The file starts with `using './main.bicep'`, which binds it to the template. Bicep checks the parameter names and types against the template when it compiles the file. The function `readEnvironmentVariable(name, default)` reads an environment variable of the process that runs `az`. Bicep evaluates it when it compiles the file, so the variable must be set in the same shell before you run `az bicep build-params`, `what-if`, or `create`.

### Environment variables

| Environment variable | Default | Parameter | Set by |
| --- | --- | --- | --- |
| `AZURE_LOCATION` | `''` | `location` | The workflows, from the repository variable of the same name. Locally, you export it. |
| `APIM_PUBLISHER_EMAIL` | `''` | `apimPublisherEmail` | The workflows, from the repository variable of the same name. Locally, you export it. |
| `AZURE_PRINCIPAL_ID` | `''` | `deployerPrincipalId` | No workflow sets it. Locally, export the object ID of your user to get the three setup role assignments. |

Both `AZURE_LOCATION` and `APIM_PUBLISHER_EMAIL` must be set to a non-empty value before a deployment. The empty default lets the file compile, but the deployment needs a region and a publisher e-mail address. The workflow `infra-validate.yml` substitutes `swedencentral` and `platform@example.com` for these two values for the parameter-file build only ([Infrastructure validate workflow](../github/workflows/infra-validate.md)).

## Parameters

| Parameter | Value in `main.dev.bicepparam` | Note |
| --- | --- | --- |
| `environmentName` | `'dev'` | Names the resource group `rg-image-studio-dev` and the identities. |
| `environmentType` | `'dev'` | One of `dev`, `test`, `prod`. |
| `location` | `readEnvironmentVariable('AZURE_LOCATION', '')` | Sweden Central is the primary region (ADR-010). The file does not hard-code it. |
| `apimPublisherEmail` | `readEnvironmentVariable('APIM_PUBLISHER_EMAIL', '')` | Required by API Management. |
| `deployerPrincipalId` | `readEnvironmentVariable('AZURE_PRINCIPAL_ID', '')` | Empty skips the deployer role assignments. |
| `allowedIpAddresses` | `[]` | No firewall rule. Storage and Cosmos DB are open to all addresses, protected by Microsoft Entra authentication. |
| `enableAsyncJobs` | `false` | No Service Bus and no worker job. |
| `enableExternalProvider` | `false` | No Key Vault role for the Image MCP identity. |
| `modelDeployments` | Three elements (below) | Draft, standard, and reasoning models. |
| `tags` | Not set | The template default `{}` applies. |

## Model deployments

The comment in the file states that model names, versions, and SKUs were read from the Foundry model catalog for `swedencentral` on 2026-09-29 with `az cognitiveservices model list`, and that they must be re-checked before the region changes or a version is upgraded. The workflows refuse to deploy while a `<...>` placeholder remains in the file. The file currently contains none.

| Deployment name (`name`) | Model (`model`) | Format (`format`) | Version (`version`) | SKU (`skuName`) | Capacity (`capacity`) | Tier |
| --- | --- | --- | --- | --- | --- | --- |
| `img-draft-gpt-image-1-mini` | `gpt-image-1-mini` | `OpenAI` | `2025-10-06` | `GlobalStandard` | `1` | draft |
| `img-std-gpt-image-2-5-flare` | `gpt-image-2.5-flare` | `OpenAI` | `2026-09-08` | `GlobalStandard` | `1` | standard |
| `llm-agents` | `gpt-5.4` | `OpenAI` | `2026-03-05` | `GlobalStandard` | `50` | reasoning model for the agents |

### Facts from the architecture

These facts come from [architecture sections 6.1 and 15](../../aidevme-foundry-image-studio/ARCHITECTURE.md#61-image-model-catalog-foundry-sold-directly-by-azure). They were observed on 2026-09-29 and are not re-verified in this document.

- Every image model is offered only with the `GlobalStandard` SKU. No `DataZoneStandard` or `Standard` option exists for them (ADR-010, risk R-8).
- Sweden Central offers all image models and MAI-Image. The `gpt-image` models are also offered in East US 2 and West US 3.
- The versions in the table match the versions verified in Sweden Central: `gpt-image-1-mini` 2025-10-06, `gpt-image-2.5-flare` 2026-09-08, and `gpt-5.4` 2026-03-05.
- Observed default quota (Sweden Central, `GlobalStandard`): `gpt-image-1-mini` 4, `gpt-image-2.5-flare` 2, `gpt-image-2.5-sunburst` 2, `gpt-image-2` 2, and `gpt-5.4` 1000. The capacities in the file (1, 1, and 50) are below these quotas.
- The unit of `capacity` for the image models is not verified. [INFRASTRUCTURE.md](../../aidevme-foundry-image-studio/INFRASTRUCTURE.md) states that it is thousands of tokens per minute for text models and that the unit for image models must be checked in the catalog.
- It is not confirmed that `gpt-5.4` accepts image input for the critic step (open question 11).

### Deployments the routing table names but `dev` does not create

The routing table in [architecture section 6.2](../../aidevme-foundry-image-studio/ARCHITECTURE.md#62-tier-routing-table) refers to `img-prec-gpt-image-2-5-sunburst`, `img-fb-gpt-image-2`, and `img-alt-mai-image`. The `dev` file does not create them, in line with the `dev` scope of draft and standard tiers only (architecture section 17.1). In `dev`, the standard tier has no fallback deployment. The MAI-Image model, its version, and its `format` (`Microsoft` according to the architecture) are not decided (open question 13).

## Change a model deployment

1. Read the current catalog for your region, for example with `az cognitiveservices model list`, and note the model name, version, format, and SKU.
2. Add a new element to `modelDeployments` with a new `name`. Do not change the model or the version of an existing name.
3. Run the [Infrastructure validate workflow](../github/workflows/infra-validate.md) or the local checks in [Bicep code overview](index.md#lint-build-and-preview).
4. Run a what-if and confirm that only the new deployment is created.
5. Update the routing table through a pull request, as described in [INFRASTRUCTURE.md](../../aidevme-foundry-image-studio/INFRASTRUCTURE.md).

## Linter configuration

`bicep/bicepconfig.json` enables the `core` analyzer and sets five rules. Other rules keep the Bicep default level.

| Rule | Level | Effect |
| --- | --- | --- |
| `no-unused-params` | `error` | An unused parameter fails the lint. |
| `no-unused-vars` | `error` | An unused variable fails the lint. |
| `outputs-should-not-contain-secrets` | `error` | An output that exposes a secret fails the lint. |
| `secure-secrets-in-params` | `error` | A parameter that looks like a secret must be `@secure()`. |
| `use-recent-api-versions` | `off` | The linter does not report older API versions. The templates pin the versions deliberately (design convention 9 in [INFRASTRUCTURE.md](../../aidevme-foundry-image-studio/INFRASTRUCTURE.md)). The reason for switching the rule off is inferred from that convention, not stated in the file. |

The workflows run `az bicep lint --file bicep/main.bicep` and fail on an error under these rules. The Bicep default levels of the other rules are not reproduced here.

## Add a parameter file for another environment

1. Copy `bicep/main.dev.bicepparam` to `bicep/main.<environment>.bicepparam`.
2. Set `environmentName` and `environmentType` (`test` or `prod`).
3. Set `deployerPrincipalId` to an empty string, or remove the environment variable.
4. Replace the `modelDeployments` array with the models for the environment and verify each value in the model catalog.
5. Follow the remaining steps in [Add an environment](index.md#add-an-environment).

## Known limits

- Only the `dev` file exists.
- The file holds no secret and must not hold one. Use environment variables or a key store for sensitive values.
- The values were read once, on 2026-09-29. Model versions, quota, and availability change.

## Related documents

- [Bicep code overview](index.md)
- [main.bicep](main.md)
- [Foundry module](modules/foundry.md)
- [Infrastructure validate workflow](../github/workflows/infra-validate.md)
- [Infrastructure provisioning with Bicep](../../aidevme-foundry-image-studio/INFRASTRUCTURE.md)
- [Generic Document Style](../../templates/GENERIC_DOCUMENT_STYLE.md)
- [Documentation index](../../index.md)
