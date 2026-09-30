# bicep

Bicep templates that provision the Azure resources for AIDevMe Foundry Image Studio. The templates are documented file by file in [docs/project-docs/bicep/](../docs/project-docs/bicep/index.md). The design guide is in [INFRASTRUCTURE.md](../docs/aidevme-foundry-image-studio/INFRASTRUCTURE.md).

## Layout

```text
bicep/
├── main.bicep              # subscription-scope entry point
├── main.dev.bicepparam     # parameters for the dev environment
├── bicepconfig.json        # linter rules
└── modules/                # one module per service group
```

The GitHub Actions workflows that deploy these templates are in [.github/workflows/](../.github/workflows/), because GitHub runs workflows only from that folder:

| Workflow | Trigger | Action |
| --- | --- | --- |
| [infra-validate.yml](../.github/workflows/infra-validate.yml) | Manual run only | Lint, build, placeholder check, and an optional what-if |
| [infra-deploy.yml](../.github/workflows/infra-deploy.yml) | Manual run only | Lint, build, what-if, and deploy |
| [infra-delete.yml](../.github/workflows/infra-delete.yml) | Manual run only | Cancel a running deployment, delete the resource group, and purge soft-deleted resources |

## One-time setup

### 1. Repository variables

Create these variables in **Settings → Secrets and variables → Actions → Variables**.

| Variable | Value |
| --- | --- |
| `AZURE_SUBSCRIPTION_ID` | Azure subscription ID (already set) |
| `AZURE_TENANT_ID` | Microsoft Entra tenant ID |
| `AZURE_CLIENT_ID` | Application (client) ID of the deployment app registration |
| `AZURE_LOCATION` | Azure region, for example the region chosen in decision D1 |
| `APIM_PUBLISHER_EMAIL` | Publisher e-mail address for API Management |

None of these values is a secret. Sign-in uses OpenID Connect (OIDC), so the repository stores no credentials.

### 2. Deployment identity with OIDC federation

Create an app registration, one federated credential per GitHub environment, and the role assignments. In the Azure portal: **Microsoft Entra ID → App registrations → New registration**, then **Certificates & secrets → Federated credentials**.

This repository uses **immutable OIDC subject claims**, so the subject contains numeric IDs instead of names. Read the IDs and the subject prefix with:

```bash
gh api repos/<owner>/aidevme-foundry-image-studio --jq '{repo_id: .id, owner_id: .owner.id}'
gh api repos/<owner>/aidevme-foundry-image-studio/actions/oidc/customization/sub
```

Then create one credential per environment. The subject is case-sensitive, and the environment name must match the name in the workflow (lowercase `dev`):

```bash
az ad app federated-credential create --id <app-id> --parameters '{
  "name": "github-env-dev",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:<owner>@<owner-id>/aidevme-foundry-image-studio@<repo-id>:environment:dev",
  "audiences": ["api://AzureADTokenExchange"]
}'
az role assignment create --assignee <app-id> --role Contributor --scope /subscriptions/<subscription-id>
az role assignment create --assignee <app-id> --role "User Access Administrator" --scope /subscriptions/<subscription-id>
```

All three workflows run manually and use the GitHub environment of the selected name, so their token subject is `environment:<name>`. Add one credential for each environment (`test`, `prod`) when you create it. No `pull_request` or branch credential is needed. The templates run at subscription scope and create role assignments, so the identity needs both roles. Narrow the scope if you create the resource group beforehand.

If a sign-in fails with `AADSTS700213`, the error shows the subject that GitHub sent. Compare it character by character with the credential's subject.

### 3. GitHub environment (recommended)

Create an environment named `dev` under **Settings → Environments**. Add required reviewers to it if you want a manual approval before each deployment.

### 4. Check the model deployments

`main.dev.bicepparam` contains the model names, versions, and SKUs that were read from the Foundry model catalog for `swedencentral` on 2026-09-29. Check them again if you change the region or upgrade a version ([parameter file document](../docs/project-docs/bicep/parameters.md)). The deploy workflow refuses to run while a `<...>` placeholder remains in the file.

## Deploy

Run **Infrastructure deploy** from the **Actions** tab, and select the environment. Select **Preview the changes without deploying** to run only the what-if. The workflow never runs on its own.

## Delete an environment

Run **Infrastructure delete** from the **Actions** tab.

1. Select the environment.
2. Type the resource group name to confirm (for `dev`: `rg-image-studio-dev`).
3. Select **Dry run** first to list what would be deleted, and delete nothing.

The workflow cancels a deployment that is still running, deletes the resource group, purges soft-deleted Foundry, Content Safety, App Configuration and API Management resources so their names can be reused, and deletes the deployment record. A Key Vault with purge protection cannot be purged for 30 days. The deploy workflow recovers it automatically the next time you deploy.

## Run locally

```bash
export AZURE_LOCATION=<region>
export APIM_PUBLISHER_EMAIL=<address>
az login
az account set --subscription <subscription-id>
az bicep lint --file bicep/main.bicep
az deployment sub what-if --location "$AZURE_LOCATION" \
  --template-file bicep/main.bicep \
  --parameters bicep/main.dev.bicepparam
```

## Current limits

- Only the `dev` environment exists. It uses public network access, so private endpoints and the virtual network are not implemented yet (Phase 4).
- API Management uses the `Developer` SKU, which has no service level agreement.
- The API Management policy, products, and subscriptions are not created yet.
- The container apps start with a placeholder image until the service images are built and deployed.
- The Bicep templates compile and lint cleanly. They have not been deployed, so resource properties, model names, and role identifiers still need verification against your subscription.
