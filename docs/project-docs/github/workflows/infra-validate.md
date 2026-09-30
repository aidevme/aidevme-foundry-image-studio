# Infrastructure validate workflow

| Field | Value |
| --- | --- |
| **Document Title** | Infrastructure validate workflow |
| **Document Location** | `docs/project-docs/github/workflows/infra-validate.md` |
| **Document Description** | Describes the Infrastructure validate GitHub Actions workflow (`infra-validate.yml`): its inputs, jobs, steps, results, safety features, and failure modes. It is intended for engineers who check changes to the Bicep templates before a deployment. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The workflow `.github/workflows/infra-validate.yml` checks the Bicep templates in `bicep/` without deploying them. It always runs static checks, and it can preview the changes against Azure with what-if. Read this document before you run the workflow or change it. Shared concepts such as OpenID Connect (OIDC) sign-in, repository variables, and the GitHub environment are described in the [workflows overview](index.md) and are not repeated here.

## Purpose and when to use it

Run the workflow after you change a file in `bicep/` or before you run [Infrastructure deploy](infra-deploy.md). It reports syntax errors, linter findings, and unresolved placeholders in the parameter file. With what-if enabled, it also shows which resources a deployment would create, change, or delete.

The workflow changes nothing in Azure.

## Trigger and inputs

The workflow starts only manually (`workflow_dispatch`).

| Input | Type | Default | Description |
| --- | --- | --- | --- |
| `environment` | Choice, required | `dev` | Target environment. `dev` is the only option. It selects the parameter file `bicep/main.<environment>.bicepparam`. |
| `run_what_if` | Boolean | `true` | Also preview the changes against Azure with what-if. When it is `false`, the `what-if` job is skipped. |

## Permissions and environment

| Setting | Value |
| --- | --- |
| Token permissions | `id-token: write`, `contents: read` |
| Runner | `ubuntu-latest` for both jobs |
| GitHub environment | `validate` job: none. `what-if` job: the selected environment, so the OIDC subject is `environment:<name>`. |
| Concurrency group | `infra-validate-<environment>`, with `cancel-in-progress: true` |

Because the `what-if` job uses the environment, required reviewers of that environment must approve the job before it starts.

## Variables

The workflow sets these environment variables for all jobs:

| Variable | Source | Use |
| --- | --- | --- |
| `ENVIRONMENT` | The `environment` input | Selects the parameter file and names the deployment |
| `AZURE_LOCATION` | Repository variable `AZURE_LOCATION` | Read by the parameter file and used as the what-if location |
| `APIM_PUBLISHER_EMAIL` | Repository variable `APIM_PUBLISHER_EMAIL` | Read by the parameter file |

The `what-if` job also reads `AZURE_SUBSCRIPTION_ID`, `AZURE_TENANT_ID`, and `AZURE_CLIENT_ID` for the check step and for `azure/login`.

## Jobs and steps

The workflow has two jobs. The `what-if` job runs after the `validate` job succeeds.

### Job `validate`

The job has no `if:` condition and always runs. It needs no Azure sign-in.

| Step | Condition | What it does |
| --- | --- | --- |
| Check out the repository | None | Runs `actions/checkout@v4`. |
| Lint Bicep | None | Runs `az bicep lint --file bicep/main.bicep`. The step fails if the linter reports an error under the rules in `bicep/bicepconfig.json`. |
| Build Bicep | None | Runs `az bicep build --file bicep/main.bicep --stdout` and discards the output. The step fails on a compile error. |
| Build parameter file | None | Runs `az bicep build-params` on `bicep/main.<environment>.bicepparam`. For this step only, `AZURE_LOCATION` falls back to `swedencentral` and `APIM_PUBLISHER_EMAIL` to `platform@example.com` when the repository variables are empty, so the check can run before the variables exist. |
| Report unresolved placeholders | None | Searches the parameter file for text that matches `<[a-z][a-z0-9-]*>`. If it finds a match, it prints the lines and writes a warning annotation. It does not fail the job. |

### Job `what-if`

| Property | Value |
| --- | --- |
| `needs` | `validate` |
| `if` | `inputs.run_what_if` must be true |
| `environment` | The selected environment |

| Step | Condition | What it does |
| --- | --- | --- |
| Check out the repository | None | Runs `actions/checkout@v4`. |
| Verify repository variables | None | Checks that `AZURE_SUBSCRIPTION_ID`, `AZURE_TENANT_ID`, `AZURE_CLIENT_ID`, `AZURE_LOCATION`, and `APIM_PUBLISHER_EMAIL` are not empty. It writes an error annotation for each missing variable and fails the step if one is missing. |
| Sign in to Azure (OIDC) | None | Runs `azure/login@v2` with the client, tenant, and subscription IDs. |
| What-if | None | Runs `az deployment sub what-if` with the deployment name `image-studio-<environment>`, the location from `AZURE_LOCATION`, `bicep/main.bicep`, and the parameter file. |

## What it changes in Azure

Nothing. The what-if command computes the difference between the template and the current state and prints it. It does not create a deployment.

## Outputs and job summary

The workflow does not define job outputs and does not write to the job summary. The result is in the step logs:

- The `Report unresolved placeholders` step prints the matching lines and shows a warning annotation on the run page.
- The `What-if` step prints the planned changes for each resource, marked as create, modify, delete, or no change.

## Error handling

The steps use the default behavior of GitHub Actions: a failing command fails the step, the job stops, and the `what-if` job does not start. The only exception is the placeholder check, which warns but does not fail.

## Safety features

| Feature | Effect |
| --- | --- |
| Read-only commands | No step creates, changes, or deletes an Azure resource. |
| Environment reviewers | Required reviewers can approve the `what-if` job before it signs in to Azure. |
| Variable check | The `what-if` job fails early, with a clear message, if a repository variable is missing. |
| Concurrency group | A new run for the same environment cancels the older validate run. |

## Run the workflow and read the result

1. Open the **Actions** tab, select **Infrastructure validate**, and select **Run workflow**. To use the GitHub CLI instead, run `gh workflow run infra-validate.yml -f environment=dev -f run_what_if=true`.
2. Select the run, and wait for the `validate` job to finish. A green job means the templates lint and compile.
3. Open the `Report unresolved placeholders` step. If a warning annotation is present, replace the listed placeholders before you deploy.
4. If the `what-if` job runs, approve it when the environment requires reviewers. Then open the `What-if` step and review the planned changes.

## Failure modes and fixes

| Symptom | Cause | Fix |
| --- | --- | --- |
| `Lint Bicep` fails | The linter reports a rule violation | Fix the reported line in `bicep/`, or adjust `bicepconfig.json` if the rule is wrong for the project. |
| `Build Bicep` fails with a `BCP` error | Syntax or type error | Fix the reported line. |
| `Build parameter file` fails | The parameter file does not match `main.bicep`, or the file for the selected environment does not exist | Correct the parameter names and values, or add `bicep/main.<environment>.bicepparam`. |
| Warning about unresolved placeholders | The parameter file contains a `<...>` value | Replace it with a verified value. The deploy workflow refuses to run while placeholders remain. |
| `Repository variable <name> is not set.` | A repository variable is missing | Create it. See the [workflows overview](index.md#repository-variables). |
| `AADSTS700213` or `No subscriptions found` at sign-in | Missing or mismatched federated credential, or missing role assignments | See the [troubleshooting table](index.md#troubleshooting). |

## Known limits

- The workflow has not been observed running against a real deployment. Its what-if output on a real subscription is not verified.
- The workflow does not start from a pull request or a push. The proposed pull request workflow is described in the Testing section of the [implementation plan](../../../aidevme-foundry-image-studio/IMPLEMENTATION.md).
- The `Report unresolved placeholders` step warns only. It does not stop the run.
- The `Build parameter file` step uses fallback values for the region and e-mail address, so a missing repository variable is detected only in the `what-if` job.
- Only the `dev` environment exists.

## Related documents

- [GitHub Actions workflows overview](index.md)
- [Infrastructure deploy workflow](infra-deploy.md)
- [Infrastructure delete workflow](infra-delete.md)
- [Bicep templates and one-time setup](../../../../bicep/README.md)
- [Workflow file `infra-validate.yml`](../../../../.github/workflows/infra-validate.yml)
- [Documentation index](../../../index.md)
