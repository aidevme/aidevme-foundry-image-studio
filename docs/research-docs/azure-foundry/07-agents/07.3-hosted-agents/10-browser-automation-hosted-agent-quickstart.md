# Getting started with Browser automation tool (preview) in Hosted agents

| Field | Value |
| --- | --- |
| **Document Title** | Getting started with Browser automation tool (preview) in Hosted agents |
| **Document Location** | `docs/research-docs/azure-foundry/07-agents/07.3-hosted-agents/10-browser-automation-hosted-agent-quickstart.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Getting started with Browser automation tool (preview) in Hosted agents". Step-by-step guide to setting up and running the browser automation sample in Hosted Agents. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/browser-automation-hosted-agent-quickstart). Article date: 2026-06-11. Page updated: 2026-07-17. Retrieved: 2026-09-29. Navigation: Agents > Hosted agents > Quickstarts > Add Browser Automation with a toolbox.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

> **Important**
>
> Items marked (preview) in this article are currently in public preview. This preview is provided without a service-level agreement, and we don't recommend it for production workloads. Certain features might not be supported or might have constrained capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Prerequisites

- An Azure account with an active subscription. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn_8302daa3-997f-d193-0f14-db5b4342a668) before you begin.
- Your Azure account needs the [Owner](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#owner) or [Contributor](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#contributor) roles on a resource group.
- Azure Developer CLI. If you don't have Azure Developer CLI, see Install the [Azure Developer CLI](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd?tabs=winget-windows%2Cbrew-mac%2Cscript-linux&pivots=os-windows).
  - The `azd ai agent extension` installed (`azd extension install azure.ai.agents`). If you don't have the extension installed, when you initialize the starter template or run `azd ai agent` the extension is installed automatically.

## Step 1: Create a Playwright Workspace

To use the browser automation tool, you first need to create a [Playwright workspace](https://aka.ms/pww/docs). (If you have an existing Playwright Workspace, you can skip this step.)

1. Sign in to the [Azure portal](https://portal.azure.com/) by using the credentials for your Azure subscription.
2. From the portal Home page, search for and select [Playwright Workspaces](https://aka.ms/pww/docs/manage-workspaces).
3. Select Create and enter the following information:
   - Subscription
   - Resource group
   - Name
   - Location
4. Select Review + Create and then select Create. It takes a few minutes to create the workspace. Wait for the portal page to display Your deployment is complete before moving on.

## Step 2: Deploy the sample hosted agent

To get started with the browser automation tool in hosted agents, choose one of these samples:

- [Microsoft Agent Framework](https://github.com/microsoft-foundry/foundry-samples/tree/main/samples/python/hosted-agents/agent-framework/responses/14-browser-automation-agent)
- [Bring-your-own Framework](https://github.com/microsoft-foundry/foundry-samples/tree/main/samples/python/hosted-agents/bring-your-own/responses/browser-automation)

You can use any one of these depending on which framework you want to use to build your hosted agent.

### Step 2.1: Initialize the sample hosted agent application

1. Open a new directory and initialize the agent sample from the sample's `azure.yaml` by running one of these commands:
   - Microsoft Agent Framework:

   ```
   azd ai agent init -m "https://github.com/microsoft-foundry/foundry-samples/blob/main/samples/python/hosted-agents/agent-framework/responses/14-browser-automation-agent/azure.yaml" --deploy-mode container
   ```
   - Bring-your-own Framework:

   ```
   azd ai agent init -m "https://github.com/microsoft-foundry/foundry-samples/blob/main/samples/python/hosted-agents/bring-your-own/responses/browser-automation/azure.yaml" --deploy-mode container
   ```
2. The interactive flow prompts for the following details:
   - **App directory**: The local path to initialize the application.
   - **Agent name**: Customize the name or accept the default, `browser-automation-agent-sample-foundry`. The name should be within 1-63 characters, start and end with a letter or number, and contain only letters, numbers, and internal hyphens.
   - **Foundry project**: Select an existing Foundry project or create a new project. If you use an existing Foundry project, you must have the **Foundry Project Manager** role at project scope or another role that grants both data-plane and role-assignment permissions. For the full role matrix, see [Hosted agent permissions reference](59-hosted-agent-permissions.md).
   - **Model**: Select the default, `gpt-5.4-mini`, or another model you can access.
   - **Model version**: Select the default option.
   - **Model SKU**: Select an option with available quota that isn't Batch, usually Standard or GlobalStandard.
   - **Deployment capacity**: Select the default, 10.
   - **Deployment name**: Select the default, `gpt-5.4-mini`.

After the application is initialized successfully, you see the following message:

```console
AI agent definition added to your azd project successfully!
```

### Step 2.2: Provision the Azure resources

1. Set the environment variables to point to your Playwright Workspace
   - **Playwright Workspace resource ID**: To get the resource ID, open the Playwright Workspace resource, go to the Overview page, select JSON View, and copy the Resource ID.

   ```
   azd env set PLAYWRIGHT_SERVICE_RESOURCE_ID "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.LoadTestService/playwrightWorkspaces/<workspace-name>"
   ```
   - **Playwright Workspace service URL**: To get the service URL, open the Playwright Workspace resource and go to the Overview page. Copy the Browser endpoint (it starts with `wss://`).

   ```
   azd env set PLAYWRIGHT_SERVICE_URL "wss://<region>.api.playwright.microsoft.com/playwrightworkspaces/<workspace-id>/browsers"
   ```
2. Provision the resources defined in `azure.yaml`:

```
azd provision
```

This step takes a few minutes and creates the following resources. After provisioning, you see the following message:

```console
SUCCESS: Your application was provisioned in Azure in X minute YY seconds.
```

### Step 2.3: Deploy the agent to Foundry Agent Service

Build and deploy the agent container:

```
azd deploy
```

When the agent is deployed, you'll see the following message -

```console
SUCCESS: Your application was deployed to Azure in X minutes YY seconds.
```

### Step 3: Grant the agent access to the Playwright Workspace

The Foundry project's managed identity must have the following role on the Azure Playwright workspace:

| Role | Purpose |
| --- | --- |
| **Playwright Workspace Contributor** | Grants access to create and manage browser sessions |

1. Find the agent's identity object ID in the Foundry portal. Go to Agents, select your agent, and then select Identity.
2. Assign the role by using Azure CLI:

```azurecli
PRINCIPAL_ID="<project-managed-identity-object-id>"
PWW_RESOURCE_ID="/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.LoadTestService/playwrightWorkspaces/<workspace-name>"

az role assignment create --assignee "$PRINCIPAL_ID" --role "Playwright Workspace Contributor" --scope "$PWW_RESOURCE_ID"
```

## Step 4: Test the agent in the Foundry Playground

1. Open the [Foundry portal](https://ai.azure.com/) and sign in.
2. Select your project from Recent projects or All projects.
3. In the left navigation, select Build > Agents.
4. Select your agent, then select Open in playground.
5. Enter a prompt such as -

```
Go to the website finance.yahoo.com, search for MSFT and report the Microsoft stock price.
```

## Step 4: Clean up resources

Delete the resources when you're finished so you stop incurring charges.

```
azd down
```

azd lists the resources it deletes and prompts for confirmation. Cleanup takes about 2-5 minutes.
