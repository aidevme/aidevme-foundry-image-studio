# Infrastructure deploy workflow

| Field | Value |
| --- | --- |
| **Document Title** | Infrastructure deploy workflow |
| **Document Location** | `docs/project-docs/github/workflows/infra-deploy.md` |
| **Document Description** | Describes the Infrastructure deploy GitHub Actions workflow (`infra-deploy.yml`): its inputs, steps, changes in Azure, outputs, safety features, and failure modes. It is intended for engineers who deploy or preview the Azure infrastructure. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The workflow `.github/workflows/infra-deploy.yml` deploys the Bicep templates in `bicep/` to Azure at subscription scope. It can also run only the what-if preview. Read this document before you deploy an environment. Shared concepts such as OpenID Connect (OIDC) sign-in, the GitHub environment, and repository variables are described in the [workflows overview](index.md) and are not repeated here.

## Purpose and when to use it

Use the workflow to create or update the environment `dev`. Run it first with `what_if_only` selected to review the changes, and run it again without that option to deploy. Run [Infrastructure validate](infra-validate.md) beforehand to catch errors without an Azure sign-in.

## Trigger and inputs

The workflow starts only manually (`workflow_dispatch`). Merging a change does not deploy it.

| Input | Type | Default | Description |
| --- | --- | --- | --- |
| `environment` | Choice, required | `dev` | Target environment. `dev` is the only option. It selects the parameter file `bicep/main.<environment>.bicepparam`. |
| `what_if_only` | Boolean | `false` | Preview the changes without deploying. When it is `true`, the steps that recover the Key Vault, deploy, and summarize are skipped. |

## Permissions and environment

| Setting | Value |
| --- | --- |
| Token permissions | `id-token: write`, `contents: read` |
| Runner | `ubuntu-latest` |
| GitHub environment | The selected environment. The OIDC subject is `environment:<name>`. Required reviewers must approve the job before it starts, also for a preview. |
| Concurrency group | `infra-<environment>`, with `cancel-in-progress: false`. The [delete workflow](infra-delete.md) uses the same group. |

## Variables

| Variable | Source | Use |
| --- | --- | --- |
| `ENVIRONMENT` | The `environment` input | Selects the parameter file, the deployment name, and the Key Vault name prefix |
| `AZURE_LOCATION` | Repository variable | Read by the parameter file. Used as the deployment location. |
| `APIM_PUBLISHER_EMAIL` | Repository variable | Read by the parameter file |
| `AZURE_SUBSCRIPTION_ID`, `AZURE_TENANT_ID`, `AZURE_CLIENT_ID` | Repository variables | Checked in the first step and passed to `azure/login` |

## Job and steps

The workflow has one job, `deploy`. The steps run in this order.

| Step | Condition | What it checks or changes |
| --- | --- | --- |
| Check out the repository | None | Runs `actions/checkout@v4`. |
| Verify repository variables | None | Fails with an error annotation for each of the five repository variables that is empty. |
| Verify the parameter file has no placeholders | None | Fails if `bicep/main.<environment>.bicepparam` does not exist. Fails and lists the lines if the file contains text that matches `<[a-z][a-z0-9-]*>`. |
| Lint and build Bicep | None | Runs `az bicep lint` and `az bicep build` on `bicep/main.bicep`. Fails on an error. |
| Sign in to Azure (OIDC) | None | Runs `azure/login@v2`. |
| What-if | None | Runs `az deployment sub what-if` with the deployment name `image-studio-<environment>`. Prints the planned changes. It changes nothing. |
| Recover a soft-deleted Key Vault | `!inputs.what_if_only` | Lists soft-deleted Key Vaults whose names start with `kv-<environment>-`, and runs `az keyvault recover` for each one. If a recovery fails, it writes a warning and continues. |
| Deploy | `!inputs.what_if_only` | Runs `az deployment sub create` with the same name, location, template, and parameter file as the what-if. |
| Summarize outputs | `!inputs.what_if_only` | Reads the outputs of the deployment and writes them as a table to the job summary. |

The what-if step runs before the recovery and the deployment in every run, so the log always shows the planned changes first. The workflow does not pause between the what-if and the deployment. To review before deploying, run the workflow with `what_if_only` first, or add required reviewers to the environment.

## What it changes in Azure

When `what_if_only` is `false`, the `Recover a soft-deleted Key Vault` and `Deploy` steps change Azure:

- `az keyvault recover` restores a soft-deleted Key Vault so the deployment can reuse its name. A Key Vault with purge protection stays reserved after its resource group is deleted (ADR-014 in the [architecture](../../../aidevme-foundry-image-studio/ARCHITECTURE.md#172-infrastructure-as-code)).
- `az deployment sub create` creates or updates the subscription deployment `image-studio-<environment>`. The template creates the resource group `rg-image-studio-<environment>` and the resources and role assignments in it. The modules are described in the [infrastructure guide](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md).

Bicep deployments are incremental. A resource that you remove from the template stays in Azure until you delete it.

With `what_if_only` selected, the workflow changes nothing in Azure.

## Outputs and job summary

The workflow defines no job outputs. After a deployment, the `Summarize outputs` step writes this to the job summary:

```markdown
### Deployment outputs (dev)

| Output | Value |
| --- | --- |
| <output name> | <value> |
```

There is one row for each output that `main.bicep` defines. In a preview run, the summary is not written, and the result is in the log of the `What-if` step.

## Error handling

The steps use the default behavior of GitHub Actions: a failing command fails the step and stops the job. The only tolerated failure is `az keyvault recover`, which writes a warning and lets the deployment continue. If the recovery fails and the vault still exists in the deleted state, the deployment then fails with a name conflict.

## Safety features

| Feature | Effect |
| --- | --- |
| Preview option | `what_if_only` runs the checks and the what-if and skips every step that changes Azure. |
| Placeholder check | The workflow refuses to deploy while the parameter file contains `<...>` placeholders. |
| Variable check | The workflow fails early if a repository variable is missing. |
| Lint and build | A template with an error never reaches Azure. |
| Concurrency group | A deploy and a delete for the same environment never run at the same time, and a running deployment is never cancelled by a new run. |
| Environment reviewers | Required reviewers can approve the job before any step runs. |

## Run the workflow and read the result

1. Open the **Actions** tab, select **Infrastructure deploy**, and select **Run workflow**.
2. Select the environment and select **Preview the changes without deploying** for a preview. To use the GitHub CLI, run `gh workflow run infra-deploy.yml -f environment=dev -f what_if_only=true`.
3. If the environment requires reviewers, ask a reviewer to approve the run.
4. Open the run and read the `What-if` step. Confirm that the planned changes are the expected ones, in particular that no resource is deleted or replaced by accident.
5. Run the workflow again with `what_if_only` cleared to deploy.
6. When the run succeeds, open the job summary to read the deployment outputs. A red `Deploy` step means the deployment failed. Read the error message in the step log.

A successful run means the Azure deployment succeeded. It does not mean the environment works. Then run the checks in the [verification section](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md#verification) of the infrastructure guide.

## Failure modes and fixes

| Symptom | Cause | Fix |
| --- | --- | --- |
| `Repository variable <name> is not set.` | A repository variable is missing | Create it. See the [workflows overview](index.md#repository-variables). |
| `Parameter file ... does not exist.` | No file exists for the selected environment | Add `bicep/main.<environment>.bicepparam`. |
| `Replace the placeholders listed above` | The parameter file contains a `<...>` value | Replace it with a verified value. |
| `AADSTS700213`, `AADSTS7002138`, or `No subscriptions found` | Federated credential or role assignment problem | See the [troubleshooting table](index.md#troubleshooting). |
| `FlagMustBeSetForRestore` or a name conflict | A soft-deleted resource holds the name | Run the [delete workflow](infra-delete.md) with `purge_soft_deleted` selected, then deploy again. |
| Insufficient capacity for AI Search | The region has no capacity for the SKU | See the [troubleshooting table](index.md#troubleshooting). |
| `InsufficientQuota` on a model deployment | No quota for the model and SKU | Request quota or lower `capacity` in the parameter file. |
| `AuthorizationFailed` | The identity lacks a role | Grant the roles described in the [workflows overview](index.md#roles-of-the-deployment-identity). |
| The run waits in the queue | Another run holds the group `infra-<environment>` | Wait for the other run, or cancel it from the **Actions** tab. |

## Known limits

- The workflow has not been observed completing a deployment. The implementation plan states that the first deployment to `dev` had not completed when it was last updated. The behavior of the recovery, deployment, and summary steps against a real subscription is not verified.
- The `Summarize outputs` step reads the `value` field of every deployment output. Its behavior for an output without a value is not verified.
- The workflow does not start from a pull request or a push.
- Only the `dev` environment exists.
- The workflow deploys infrastructure only.

## Related documents

- [GitHub Actions workflows overview](index.md)
- [Infrastructure validate workflow](infra-validate.md)
- [Infrastructure delete workflow](infra-delete.md)
- [Infrastructure provisioning with Bicep](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md#continuous-deployment)
- [Bicep templates and one-time setup](../../../../bicep/README.md)
- [Workflow file `infra-deploy.yml`](../../../../.github/workflows/infra-deploy.yml)
- [Documentation index](../../../index.md)
