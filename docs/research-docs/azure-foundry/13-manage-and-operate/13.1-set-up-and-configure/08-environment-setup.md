# Set up your environment

| Field | Value |
| --- | --- |
| **Document Title** | Set up your environment |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.1-set-up-and-configure/08-environment-setup.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Set up your environment". Learn how to set up your Foundry Agent Service environment, choose between basic and standard setup, and configure the required Azure resources and roles. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/environment-setup). Article date: 2026-08-21. Page updated: 2026-08-26. Retrieved: 2026-09-29. Navigation: Manage and operate > Set up and configure > Agent configuration > Set up your agent resources.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

In this article, you deploy the infrastructure needed to create agents with Foundry Agent Service. After completing this setup, you can create and configure agents using either the SDK of your choice or the Foundry portal.

Creating your first agent is a two-step process:

1. Set up your agent environment (this article).
2. Create and configure your agent.

### Required permissions

| Action | Required Role |
| --- | --- |
| Create an account and project | Foundry Account Owner |
| [standard setup](#choose-your-setup) Only: Assign RBAC for required resources (Cosmos DB, Search, Storage, etc.) | Role Based Access Control Administrator |
| Create and edit agents | Foundry User |
| Interact with agent endpoints (without creating or editing agents) | Foundry Agent Consumer |

> **Important**
>
> The Foundry RBAC roles were recently renamed. **Foundry User**, **Foundry Owner**, **Foundry Account Owner**, and **Foundry Project Manager** were previously named Azure AI User, Azure AI Owner, Azure AI Account Owner, and Azure AI Project Manager. You might still see the previous names in some places while the rename rolls out. The role IDs and core permissions are unchanged by the rename.

> **Note**
>
> For Hosted agents, additional permissions and RBAC configurations are required. See [Hosted agent permissions reference](../../07-agents/07.3-hosted-agents/59-hosted-agent-permissions.md) for detailed requirements.

## Set up your agent environment

To get started, you need a Microsoft Foundry resource and a Foundry project.
 Agents are created within a specific project, and each project acts as an isolated workspace. This means:

- All agents in the same project share access to the same file storage, thread storage (conversation history), and search indexes.
- Data is isolated between projects. Agents in one project cannot access resources from another. Projects are currently the unit of sharing and isolation in Foundry. See the [What is Microsoft Foundry?](../../01-what-is-microsoft-foundry/01-what-is-foundry.md) article for more information on Foundry projects.

### Prerequisites

- An Azure subscription - [Create one for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- Ensure that the individual creating the account and project has the **Foundry Account Owner** role at the subscription scope
- If configuring a [standard setup](#choose-your-setup), the same individual must also have permissions to assign roles to required resources (Cosmos DB, Azure AI Search, Azure Blob Storage). For more information on RBAC roles, specific to Agent Service, see [Agent Service RBAC roles](../13.3-security-and-governance/02-rbac-foundry.md).
  - The built-in role needed is **Role Based Access Administrator**.
  - Alternatively, having the **Owner** role at the subscription level also satisfies this requirement.
  - The key permission needed is: `Microsoft.Authorization/roleAssignments/write`

### Choose your setup

Agent Service offers three environment configuration modes to suit different needs:

- **Basic Setup**:

  This setup is compatible with OpenAI Assistants and manages agent states using the platform's built-in storage. It includes the same tools and capabilities as the Assistants API, with added support for non-OpenAI models and tools such as Azure AI Search, and Bing.
- **Standard Setup**:

  Includes everything in the basic setup and fine-grained control over your data by allowing you to use your own Azure resources. All customer data—including files, threads, and vector stores—are stored in your own Azure resources, giving you full ownership and control.
- **Standard Setup with Bring Your Own (BYO) Virtual Network**:

  Includes everything in the Standard Setup, with the added ability to operate entirely within your own virtual network. This setup supports Bring Your Own Virtual Network (BYO virtual network), allowing for strict control over data movement and helping prevent data exfiltration by keeping traffic confined to your network environment.

> **Important**
>
> **Standard setups require you to Bring Your Own (BYO) resources so that all agent data stays in your Azure tenant.**
>
> BYO resources include: Azure Storage, Azure AI Search, and Azure Cosmos DB.
>
> All data processed by Foundry Agent Service is automatically stored at rest in these resources, helping you meet compliance requirements and enterprise security standards.

### Compare setup options

> **Note**
>
> Private Network Isolation in the table below refers to Secured Agent outbound communication. Basic setup doesn't apply, and you can use Private Network Isolation for your Agents with Standard Setup only.
>
> Inbound secured communication can be applied to all of setups below, by adding a private endpoint and disabling the inbound public access for your Foundry Account.

| Use Cases | Basic Setup | Standard Setup with Public Networking | Standard Setup with Private Networking |
| --- | --- | --- | --- |
| Get started quickly without managing resources | ✅ |   |   |
| All conversation history, file, and vector stores are stored in your own resources |   | ✅ | ✅ |
| Support for Customer Managed Keys (CMK) |   | ✅ | ✅ |
| Private Network Isolation (Bring your own virtual network) |   |   | ✅ |

### Deployment options

To customize these templates, see [use your own resources](11-use-your-own-resources.md).

If you want support for Private Network Isolation, see [network-secured setup](12-virtual-networks.md) for more information on how to bring your own virtual network.

| Description and Autodeploy | Diagram (click to zoom in) |
| --- | --- |
| Deploy a basic agent setup that uses **Managed Identity** for authentication. An account and project are created. A GPT-4.1 model is deployed. A Microsoft-managed Key Vault is used by default. [![Deploy To Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazure-ai-foundry%2Ffoundry-samples%2Frefs%2Fheads%2Fmain%2Finfrastructure%2Finfrastructure-setup-bicep%2F40-basic-agent-setup%2Fazuredeploy.json) | [![An architecture diagram for basic agent setup.](https://learn.microsoft.com/en-us/azure/foundry/agents/media/quickstart/basic-setup-resources-foundry.png)](https://learn.microsoft.com/en-us/azure/foundry/agents/media/quickstart/basic-setup-resources-foundry.png#lightbox) |
| Deploy a standard agent setup that uses **Managed Identity** for authentication. An account and project are created. A GPT-4.1 model is deployed. Azure resources for storing customer data—**Azure Storage**, **Azure Cosmos DB**, and **Azure AI Search**—are automatically created if existing resources aren't provided. These resources are connected to your project to store files, threads, and vector data. A Microsoft-managed Key Vault is used by default. [![Deploy To Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazure-ai-foundry%2Ffoundry-samples%2Frefs%2Fheads%2Fmain%2Finfrastructure%2Finfrastructure-setup-bicep%2F41-standard-agent-setup%2Fazuredeploy.json) | [![An architecture diagram for standard agent setup.](https://learn.microsoft.com/en-us/azure/foundry/agents/media/quickstart/standard-agent-setup.png)](https://learn.microsoft.com/en-us/azure/foundry/agents/media/quickstart/standard-agent-setup.png#lightbox) |

### [Optional] Model selection in autodeploy template

> **Important**
>
> **Don't change the modelFormat parameter.**
>
> The templates only support deployment of Azure OpenAI models. See which Azure OpenAI models are supported in the [model support](../../07-agents/07.6-reference/01-limits-quotas-regions.md) article.

You can customize the model used by your agent by editing the model parameters in the autodeploy template. To deploy a different model, you need to update at least the `modelName` and `modelVersion` parameters.

By default, the deployment template is configured with the following values:

| Model Parameter | Default Value |
| --- | --- |
| modelName | gpt-4.1 |
| modelFormat | OpenAI (for Azure OpenAI) |
| modelVersion | 2025-04-14 |
| modelSkuName | GlobalStandard |
| modelLocation | eastus |

### Verify your deployment

After deployment completes (typically 5-10 minutes), verify that your resources were created successfully:

1. Go to the [Azure portal](https://portal.azure.com/).
2. Search for your resource group name.
3. Confirm that the following resources exist:
   - **Basic setup**: Foundry account, project, and model deployment.
   - **Standard setup**: All basic resources plus Azure Storage account, Azure Cosmos DB account, and Azure AI Search service.

> **Tip**
>
> If the deployment fails, check the **Deployments** section in your resource group for error details. Common issues include insufficient quota for the model or missing permissions.

### Troubleshooting

| Issue | Cause | Solution |
| --- | --- | --- |
| Deployment fails with quota error | Insufficient quota for GPT-4.1 in the selected region | Request a quota increase or select a different region |
| Permission denied during deployment | Missing **Role Based Access Administrator** role | Ask your subscription owner to grant you the required role |
| Resources created but agent creation fails | Project not properly connected to resources | Verify the connection in the Foundry portal under **Manage** > **Project details** > **Connected resources** |
| Model not available | Model not deployed in your region | Check [model region support](../../07-agents/07.6-reference/01-limits-quotas-regions.md) and select an available region |

### What's next?

- [Create your first agent](../../04-get-started/04.1-what-do-you-want-to-build/03-get-started-code.md)
- Explore more:
  - [Elevated-role tasks in Microsoft Foundry](../13.3-security-and-governance/03-administrator-guide.md#configure-agent-infrastructure) — role requirements for agent setup.
  - [Use your existing resources](11-use-your-own-resources.md)
  - [Network secured agent setup](12-virtual-networks.md)
