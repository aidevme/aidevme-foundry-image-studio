# .infrastructure

Bicep templates that provision the Azure resources for AIDevMe Foundry Image Studio. The full guide is in [INFRASTRUCTURE.md](../docs/aidevme-foundry-image-studio/INFRASTRUCTURE.md).

## Layout

```text
.infrastructure/
├── main.bicep              # subscription-scope entry point
├── main.dev.bicepparam     # parameters for the dev environment
├── bicepconfig.json        # linter rules
└── modules/                # one module per service group
```

The GitHub Actions workflows that deploy these templates are in [.github/workflows/](../.github/workflows/), because GitHub runs workflows only from that folder:

| Workflow | Trigger | Action |
| --- | --- | --- |
| [infra-validate.yml](../.github/workflows/infra-validate.yml) | Pull request that changes `.infrastructure/**` | Lint, build, placeholder check, and what-if |
| [infra-deploy.yml](../.github/workflows/infra-deploy.yml) | Manual run only | Lint, build, what-if, and deploy |

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

```bash
az ad app create --display-name "gh-image-studio-deploy"
az ad sp create --id <app-id>
az ad app federated-credential create --id <app-id> --parameters '{
  "name": "github-main",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:<owner>/aidevme-foundry-image-studio:ref:refs/heads/main",
  "audiences": ["api://AzureADTokenExchange"]
}'
az ad app federated-credential create --id <app-id> --parameters '{
  "name": "github-env-dev",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:<owner>/aidevme-foundry-image-studio:environment:dev",
  "audiences": ["api://AzureADTokenExchange"]
}'
az ad app federated-credential create --id <app-id> --parameters '{
  "name": "github-pull-request",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:<owner>/aidevme-foundry-image-studio:pull_request",
  "audiences": ["api://AzureADTokenExchange"]
}'
az role assignment create --assignee <app-id> --role Contributor --scope /subscriptions/<subscription-id>
az role assignment create --assignee <app-id> --role "User Access Administrator" --scope /subscriptions/<subscription-id>
```

The deploy job runs in the GitHub environment `dev`, so its token subject is `environment:dev`. The validate job runs on pull requests, so its subject is `pull_request`. Each subject needs its own federated credential. The templates run at subscription scope and create role assignments, so the identity needs both roles. Narrow the scope if you create the resource group beforehand.

### 3. GitHub environment (recommended)

Create an environment named `dev` under **Settings → Environments**. Add required reviewers to it if you want a manual approval before each deployment.

### 4. Replace the placeholders

`main.dev.bicepparam` contains `<...>` placeholders for model versions and the reasoning model. Replace them with values from the Foundry model catalog for your region. The deploy workflow refuses to run while placeholders remain.

## Deploy

Run **Infrastructure deploy** from the **Actions** tab, and select the environment. Select **Preview the changes without deploying** to run only the what-if. The workflow never runs on its own.

## Run locally

```bash
export AZURE_LOCATION=<region>
export APIM_PUBLISHER_EMAIL=<address>
az login
az account set --subscription <subscription-id>
az bicep lint --file .infrastructure/main.bicep
az deployment sub what-if --location "$AZURE_LOCATION" \
  --template-file .infrastructure/main.bicep \
  --parameters .infrastructure/main.dev.bicepparam
```

## Current limits

- Only the `dev` environment exists. It uses public network access, so private endpoints and the virtual network are not implemented yet (Phase 4).
- API Management uses the `Developer` SKU, which has no service level agreement.
- The API Management policy, products, and subscriptions are not created yet.
- The container apps start with a placeholder image until the service images are built and deployed.
- The Bicep templates compile and lint cleanly. They have not been deployed, so resource properties, model names, and role identifiers still need verification against your subscription.
