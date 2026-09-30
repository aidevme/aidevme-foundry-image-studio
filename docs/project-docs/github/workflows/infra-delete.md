# Infrastructure delete workflow

| Field | Value |
| --- | --- |
| **Document Title** | Infrastructure delete workflow |
| **Document Location** | `docs/project-docs/github/workflows/infra-delete.md` |
| **Document Description** | Describes the Infrastructure delete GitHub Actions workflow (`infra-delete.yml`): its inputs, steps, error-handling helpers, safety features, and failure modes. It is intended for engineers who remove an Azure environment and reuse its resource names. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The workflow `.github/workflows/infra-delete.yml` deletes the Azure resources that [Infrastructure deploy](infra-deploy.md) created for one environment. It also purges soft-deleted resources so that their names can be reused. Read this document before you delete an environment. Shared concepts such as OpenID Connect (OIDC) sign-in, the GitHub environment, and repository variables are described in the [workflows overview](index.md) and are not repeated here.

> **Warning:** The workflow permanently deletes the resource group and everything in it. Purging removes soft-deleted resources without a way to restore them. Run it with `dry_run` selected first.

## Purpose and when to use it

Use the workflow to remove an environment that is no longer needed, to recover from a deployment that is stuck or half-created, or to clear soft-deleted names before a redeployment. Only `dev` is available as an environment.

## Trigger and inputs

The workflow starts only manually (`workflow_dispatch`).

| Input | Type | Default | Description |
| --- | --- | --- | --- |
| `environment` | Choice, required | `dev` | Environment to delete. `dev` is the only option. |
| `confirm` | String, required | None | Must equal the resource group name `rg-image-studio-<environment>`, for example `rg-image-studio-dev`. |
| `dry_run` | Boolean | `false` | List what exists and delete nothing. |
| `purge_soft_deleted` | Boolean | `true` | Purge soft-deleted resources after the resource group is deleted. |

## Permissions and environment

| Setting | Value |
| --- | --- |
| Token permissions | `id-token: write`, `contents: read` |
| Runner and timeout | `ubuntu-latest`, `timeout-minutes: 120` |
| GitHub environment | The selected environment. The OIDC subject is `environment:<name>`. Required reviewers must approve the job before any step runs. |
| Concurrency group | `infra-<environment>`, with `cancel-in-progress: false`. The [deploy workflow](infra-deploy.md) uses the same group. |

The workflow does not check out the repository, because it uses no repository files.

## Variables

The workflow derives these environment variables from the inputs:

| Variable | Value | Use |
| --- | --- | --- |
| `ENVIRONMENT` | The `environment` input | Name prefixes for API Management and Key Vault |
| `RESOURCE_GROUP` | `rg-image-studio-<environment>` | Confirmation, deletion, and filtering of soft-deleted resources |
| `DEPLOYMENT_NAME` | `image-studio-<environment>` | The subscription deployment to cancel and delete |
| `DRY_RUN` | The `dry_run` input | Reported in the job summary |
| `PURGE` | The `purge_soft_deleted` input | Reported in the job summary |

The steps read the repository variables `AZURE_SUBSCRIPTION_ID`, `AZURE_TENANT_ID`, and `AZURE_CLIENT_ID`. The workflow does not use `AZURE_LOCATION` or `APIM_PUBLISHER_EMAIL`.

## Error-handling helpers

The step `Define helpers` writes the file `/tmp/helpers.sh`. Every later step that changes Azure loads it with `source`. The file defines four functions and three variables (`NOT_FOUND`, `FAILURES`, and `LIST_OUT`).

| Function | Behavior |
| --- | --- |
| `try "description" command...` | Runs the command and captures its output. On success, it records the description in the job summary. If the output matches the not-found pattern, it writes a notice, records "already gone or not applicable", and continues. For any other error, it writes an error annotation, records a failure in the summary, and increments the failure counter. It never stops the step by itself. |
| `list "description" command...` | Runs a list command and stores the output in `LIST_OUT`. If the command fails, it writes an error annotation, records "Failed to list" in the summary, increments the failure counter, and leaves `LIST_OUT` empty. |
| `note` | Appends a line to the job summary. |
| `finish` | If the failure counter is greater than zero, writes an error annotation with the count and exits with status 1. Otherwise it does nothing. |

### Not-found rule

A command result is treated as "already gone" when its output matches this case-insensitive pattern:

```text
NotFound|not found|does not exist|could not be found|ResourceGroupNotFound|DeletedAccountNotFound|ResourceNotFound|CanceledByUser|not in a state|cannot be cancel|already completed
```

The last four terms cover the cancel command, which fails harmlessly when the deployment is not running any more. Any other error, such as a missing permission or a locked resource, counts as a real failure. The step continues to its end so that the remaining resources are still processed, and `finish` then fails the step.

> **Note:** The pattern matches text, not error codes. An unrelated error that contains the phrase "not found" is treated as "already gone". This behavior follows from the pattern and has not been observed in a real run.

## Job and steps

The workflow has one job, `delete`. Steps with a condition that contains `!cancelled()` also run when an earlier step failed, so one failure does not block the remaining clean-up. They do not run when you cancel the run.

| Step | Condition | What it checks or changes |
| --- | --- | --- |
| Verify the confirmation text | None | Fails unless `confirm` equals `RESOURCE_GROUP` exactly. Nothing else has run at this point. |
| Verify repository variables | None | Fails with an error annotation for each of `AZURE_SUBSCRIPTION_ID`, `AZURE_TENANT_ID`, and `AZURE_CLIENT_ID` that is empty. |
| Sign in to Azure (OIDC) | None | Runs `azure/login@v2`. |
| Inspect what exists | None | Writes the header of the job summary. Reads the state of the subscription deployment (`none` if it does not exist). If the resource group exists, lists its resources in the log and in a summary table. Changes nothing. |
| Define helpers | None | Writes `/tmp/helpers.sh`. |
| Cancel a running deployment | `!inputs.dry_run` | If the deployment state is `Running` or `Accepted`, runs `az deployment sub cancel` through `try`, then waits 60 seconds. Otherwise it records that nothing needs to be cancelled. Calls `finish`. |
| Delete the resource group | `!cancelled() && !inputs.dry_run` | If the resource group exists, runs `az group delete --yes` through `try`. Otherwise it records that there is nothing to delete. Calls `finish`. |
| Purge soft-deleted Foundry and Content Safety accounts | `!cancelled() && !inputs.dry_run && inputs.purge_soft_deleted` | Lists deleted Cognitive Services accounts, keeps those whose ID contains `/resourceGroups/<RESOURCE_GROUP>/`, and runs `az cognitiveservices account purge` for each, using the location from the ID. |
| Purge soft-deleted App Configuration stores | Same as above | Lists deleted stores, keeps those in the resource group, and runs `az appconfig purge --yes` for each. |
| Purge soft-deleted API Management services | Same as above | Lists deleted services whose names start with `apim-<environment>-`, and runs `az apim deletedservice purge` for each. |
| Purge soft-deleted Key Vaults | Same as above | Lists deleted vaults whose names start with `kv-<environment>-`. For a vault with purge protection, it writes a notice and does not purge it. For any other vault, it runs `az keyvault purge`. |
| Delete the deployment record | `!cancelled() && !inputs.dry_run` | Runs `az deployment sub delete` for `DEPLOYMENT_NAME` through `try`. |

The purge steps call `finish` at their end, as do the cancel, delete, and record steps.

## What it changes in Azure

With `dry_run` cleared, the workflow changes Azure in this order:

1. Cancels the subscription deployment `image-studio-<environment>` if it is running.
2. Deletes the resource group `rg-image-studio-<environment>` and every resource in it.
3. If `purge_soft_deleted` is selected, permanently purges the soft-deleted accounts, App Configuration stores, API Management services, and Key Vaults that belong to the environment, except a Key Vault with purge protection.
4. Deletes the subscription deployment record.

A Key Vault with purge protection cannot be purged until its retention period ends (30 days according to [bicep/README.md](../../../../bicep/README.md#delete-an-environment)). It stays reserved, and the [deploy workflow](infra-deploy.md) recovers it during the next deployment. Purge protection cannot be turned off once it is on.

With `dry_run` selected, the workflow deletes nothing. It still needs a correct `confirm` value and a working sign-in.

## Outputs and job summary

The workflow defines no job outputs. The job summary is the result and contains, in order:

- The heading `Infrastructure delete: <environment>` and the values of `dry_run` and `purge_soft_deleted`.
- The state of the subscription deployment.
- Whether the resource group exists, with a table of its resource names and types.
- One line for each later operation: done, already gone or not applicable, no resources found, a Key Vault that was not purged, or **Failed**.

In a dry run, the summary contains only the first three items. It does not list soft-deleted resources that a purge would remove, although the comment at the top of the workflow file says the dry run lists what would be deleted.

## Safety features

| Feature | Effect |
| --- | --- |
| Typed confirmation | The run fails in its first step unless `confirm` equals the resource group name. |
| Dry run | Cancels, deletes, and purges are skipped. Only the inspection runs. |
| Environment reviewers | Required reviewers can approve the job before any step runs. |
| Concurrency group | A delete and a deploy for the same environment never run at the same time. |
| Scoped purge | Cognitive Services accounts and App Configuration stores are purged only if they belonged to the resource group. API Management services and Key Vaults are matched by the name prefixes `apim-<environment>-` and `kv-<environment>-`. |
| Purge option | Clear `purge_soft_deleted` to delete the resource group and keep the soft-deleted resources. |
| Timeout | The job stops after 120 minutes. |

## Run the workflow and read the result

1. Open the **Actions** tab, select **Infrastructure delete**, and select **Run workflow**.
2. Select the environment, type the resource group name in **confirm**, and select **Dry run**. To use the GitHub CLI, run `gh workflow run infra-delete.yml -f environment=dev -f confirm=rg-image-studio-dev -f dry_run=true`.
3. If the environment requires reviewers, ask a reviewer to approve the run.
4. Open the job summary and check the resources that the resource group contains.
5. Run the workflow again with `dry_run` cleared to delete.
6. Open the job summary. Every line must show a done or an already gone message. A line that starts with **Failed** identifies an operation to repeat or to fix manually.
7. Run the [deploy workflow](infra-deploy.md) to create the environment again.

## Failure modes and fixes

| Symptom | Cause | Fix |
| --- | --- | --- |
| `Confirmation text does not match` | The `confirm` value differs from `rg-image-studio-<environment>` | Type the exact name, in lowercase. |
| `Repository variable <name> is not set.` | A repository variable is missing | Create it. See the [workflows overview](index.md#repository-variables). |
| `AADSTS700213` or `No subscriptions found` | Federated credential or role assignment problem | See the [troubleshooting table](index.md#troubleshooting). |
| `Cancel deployment ... failed` | A real error while cancelling, for example a missing permission | Read the message, fix the cause, and run the workflow again. |
| `Delete resource group ... failed` | A lock, a missing permission, or a service that blocks deletion | Read the message, remove the cause, and run the workflow again. The run is safe to repeat. |
| `Could not list ...` | The list command failed, for example because of a missing permission | Fix the permission and run the workflow again. |
| `Purge ... failed` | The purge was rejected | Read the message. Run the workflow again, or purge the resource in the Azure portal. |
| A notice that a Key Vault has purge protection | Expected behavior | No action. The deploy workflow recovers the vault. |
| The run stops after 120 minutes | The job timeout | Check the resource group in the Azure portal and run the workflow again. |

## Known limits

- The workflow has not been observed running against a real deployment. Azure behavior that it depends on, such as the wait of 60 seconds after a cancel, the output format of the list commands, and the time a resource group needs to be deleted, is not verified.
- The workflow does not start from a pull request or a push.
- Only the `dev` environment exists.
- The not-found rule is text-based. See [Not-found rule](#not-found-rule).
- The dry run does not list soft-deleted resources.
- Key Vaults and API Management services are matched by name prefix, not by resource group. Another resource with the same prefix in the subscription is purged too.
- If the resource group was deleted outside this workflow, a soft-deleted account or store is purged only if the listed ID still contains the resource group name. This is inferred from the filter and is not verified.

## Related documents

- [GitHub Actions workflows overview](index.md)
- [Infrastructure validate workflow](infra-validate.md)
- [Infrastructure deploy workflow](infra-deploy.md)
- [Infrastructure provisioning with Bicep](../../../aidevme-foundry-image-studio/INFRASTRUCTURE.md#delete-an-environment)
- [Bicep templates and one-time setup](../../../../bicep/README.md)
- [Workflow file `infra-delete.yml`](../../../../.github/workflows/infra-delete.yml)
- [Documentation index](../../../index.md)
