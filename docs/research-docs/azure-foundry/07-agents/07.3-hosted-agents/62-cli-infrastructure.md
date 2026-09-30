# Hosted agent infrastructure with the Azure Developer CLI

| Field | Value |
| --- | --- |
| **Document Title** | Hosted agent infrastructure with the Azure Developer CLI |
| **Document Location** | `docs/research-docs/azure-foundry/07-agents/07.3-hosted-agents/62-cli-infrastructure.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Hosted agent infrastructure with the Azure Developer CLI". Understand the optional Bicep infrastructure that azd can scaffold for a hosted agent project: provisioned resources, project structure, parameters, and customization. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/cli-infrastructure). Article date: 2026-06-15. Page updated: 2026-09-25. Retrieved: 2026-09-29. Navigation: Agents > Hosted agents > Reference > Infrastructure (Bicep).
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

> **Important**
>
> Items marked (preview) in this article are currently in public preview. This preview is provided without a service-level agreement, and we don't recommend it for production workloads. Certain features might not be supported or might have constrained capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

When you run `azd ai agent init --infra` or `azd ai agent init --infra=bicep`, the Azure Developer CLI (`azd`) scaffolds an `infra/` directory into your project that contains Bicep templates. These templates define the Azure resources your hosted agent needs from the services declared in `azure.yaml`. Running `azd provision` deploys the templates to create the infrastructure. This article explains what those templates provision and how to customize them.

## What gets provisioned

By default, `azd ai agent init` doesn't create infrastructure-as-code files. Use `--infra` or `--infra=bicep` to add Bicep infrastructure. Use `--infra=terraform` to add Terraform infrastructure and set `infra.provider: terraform`.

When you add Bicep infrastructure, the templates are based on the [azd-ai-starter-basic](https://github.com/Azure-Samples/azd-ai-starter-basic) repository and create the following Azure resources:

| Resource | Purpose |
| --- | --- |
| Resource group | Organizes all resources. Named `rg-<agent-name>`. |
| AI Services account | The Microsoft Foundry account. |
| Foundry project | Hosts the agent and AI capabilities. |
| Model deployments | The models the agent uses, for example `gpt-4.1-mini`. |
| Azure Container Registry | Stores the agent container images. |
| Application Insights | Agent performance monitoring and telemetry. |
| Log Analytics workspace | Centralized log collection. |
| Managed identity | The project's system-assigned identity that authenticates the agent identity blueprint to Microsoft Entra ID and holds platform role assignments. |

The templates create more resources conditionally, based on the services and dependencies declared in `azure.yaml`:

- Agent capability settings -- declare the Azure resources that hold agent state, vector data, and files. Set them when you need agents to use storage you own.
- Grounding with Bing or Grounding with Bing Custom Search -- for the web search tool.
- Azure AI Search -- for search grounding.
- Azure Storage -- for file operations.

## Project structure

```
infra/
|-- main.bicep                 # Main deployment template (subscription-scoped)
|-- main.parameters.json       # Parameter bindings to azd environment variables
|-- abbreviations.json         # Naming convention abbreviations
\-- core/
    |-- ai/                    # Foundry account, project, and connections
    |-- host/                  # Container registry
    |-- monitor/               # Application Insights and Log Analytics
    |-- search/                # Azure AI Search (conditional)
    \-- storage/               # Azure Storage (conditional)
```

## How parameters flow

The `main.parameters.json` file maps `azd` environment variables to Bicep parameters:

```json
{
  "environmentName": { "value": "${AZURE_ENV_NAME}" },
  "location": { "value": "${AZURE_LOCATION}" },
  "aiFoundryResourceName": { "value": "${AZURE_AI_ACCOUNT_NAME}" },
  "aiProjectDeploymentsJson": { "value": "${AI_PROJECT_DEPLOYMENTS=[]}" }
}
```

During `azd provision`, `azd` resolves these `${VAR}` references from the environment (`.azure/<env>/.env`) and passes them to the Bicep deployment. Outputs from the deployment, such as the Foundry project endpoint, model deployment name, and container registry endpoint, are written back to the environment for use by `azd deploy`, `azd ai agent run`, and the `azd ai` resource commands.

## Existing resources

The Bicep templates support connecting to existing Azure resources instead of creating new ones. This is useful when your team already has shared infrastructure.

| Existing resource | Environment variables to set |
| --- | --- |
| AI Services account | `AZURE_AI_ACCOUNT_NAME` |
| Container Registry | `AZURE_CONTAINER_REGISTRY_RESOURCE_ID` and `AZURE_CONTAINER_REGISTRY_ENDPOINT` |
| Application Insights | `APPLICATIONINSIGHTS_CONNECTION_STRING` and `APPLICATIONINSIGHTS_RESOURCE_ID` |

Set these variables with `azd env set` before you run `azd provision`.

## Customize the infrastructure

The `infra/` directory is standard `azd` infrastructure, so you have full control over it. To add or change resources:

1. Edit `infra/main.bicep` or add new modules under `infra/core/`.
2. Add new parameters to `main.parameters.json` with `${VAR}` bindings.
3. Set the corresponding `azd` environment variables with `azd env set`.
4. Run `azd provision` to apply the changes.

Changes to the Bicep files persist across deployments.

## Region restrictions

The `main.bicep` template restricts `location` to regions where hosted agents are supported. If you need to deploy to a region that isn't in the allowed list, update the `@allowed` decorator in `main.bicep`.

## Related content

- [azure.yaml reference for hosted agents](60-azure-yaml-reference.md)
- [Deploy a hosted agent](49-deploy-hosted-agent.md)
- [azd-ai-starter-basic repository](https://github.com/Azure-Samples/azd-ai-starter-basic)
