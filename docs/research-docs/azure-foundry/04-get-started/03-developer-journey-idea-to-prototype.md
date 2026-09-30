# Tutorial: Idea to prototype - Build and evaluate an enterprise agent

| Field | Value |
| --- | --- |
| **Document Title** | Tutorial: Idea to prototype - Build and evaluate an enterprise agent |
| **Document Location** | `docs/research-docs/azure-foundry/04-get-started/03-developer-journey-idea-to-prototype.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Tutorial: Idea to prototype - Build and evaluate an enterprise agent". Prototype an enterprise agent: build a single agent with SharePoint grounding and Model Context Protocol (MCP) tools, run batch evaluation, extend to multi-agent, and deploy to Microsoft Foundry. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/tutorials/developer-journey-idea-to-prototype). Article date: 2026-09-21. Page updated: 2026-09-22. Retrieved: 2026-09-29. Navigation: Get started > Tutorial: Idea to prototype.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

This tutorial covers the first stage of the Microsoft Foundry developer journey: from an initial idea to a working prototype. You build a **modern workplace assistant** that combines internal company knowledge with external technical guidance by using the Microsoft Foundry SDK.

**Business scenario**: Create an AI assistant that helps employees by combining:

- **Company policies** (from SharePoint documents)
- **Technical implementation guidance** (from Microsoft Learn via MCP)
- **Complete solutions** (combining both sources for business implementation)
- **Batch evaluation** to validate agent performance on realistic business scenarios

**Tutorial outcome**: By the end you have a running Modern Workplace Assistant that can answer policy, technical, and combined implementation questions; a repeatable batch evaluation script; and clear extension points (other tools, multi‑agent patterns, richer evaluation).

**You will:**

- Build a Modern Workplace Assistant with SharePoint and MCP integration.
- Demonstrate real business scenarios combining internal and external knowledge.
- Implement robust error handling and graceful degradation.
- Create evaluation framework for business-focused testing.
- Prepare foundation for governance and production deployment.

This minimal sample demonstrates enterprise-ready patterns with realistic business scenarios.

> **Important**
>
> Code in this article uses packages that are currently in preview. This preview is provided without a service-level agreement, and we don't recommend it for production workloads. Certain features might not be supported or might have constrained capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Prerequisites

- An Azure subscription. If you don't have one, [create one for free](https://azure.microsoft.com/free).
- Azure CLI 2.67.0 or later, authenticated with `az login` (check with `az version`)
- A Foundry **project** with a deployed model (for example, `gpt-4o-mini`). If you don't have one: [Create a project](../13-manage-and-operate/13.1-set-up-and-configure/07-create-projects.md) and then deploy a model (see model overview: [Model catalog](../06-models/01-foundry-models-overview.md)).
- Python 3.10 or later
- .NET SDK 8.0 or later (for the C# sample)
- A SharePoint connection configured in your project.
  - The SharePoint tool is in preview and requires a signed-in user's delegated identity. App-only and service-principal authentication aren't supported.
  - Developers and end users need either a Microsoft 365 Copilot license or enabled pay-as-you-go access, the **Foundry User** role on the project, and at least **Read** access to the target SharePoint site.
  - The SharePoint site and Foundry project must be in the same Microsoft Entra tenant. An agent can use one SharePoint tool. For setup instructions, see [Use the SharePoint tool](../08-toolboxes/08.1-add-tools-and-skills/35-sharepoint.md).
- The **Foundry User** role to create and test the agent. If you create a project connection to authenticate an MCP server, you also need the **Foundry Project Manager** role.
- (Optional) Git installed for cloning the sample repository

> **Important**
>
> SDK versions and sample repository structure might change after this article is published. Before you begin, check the [sample repository README](https://github.com/microsoft-foundry/foundry-samples/tree/main/samples/python/enterprise-agent-tutorial/1-idea-to-prototype) for the latest setup instructions, required package versions, and environment configuration. If a version referenced in this tutorial isn't available on [PyPI](https://pypi.org/project/azure-ai-projects/) or [NuGet](https://www.nuget.org/packages/Azure.AI.Projects), use the latest published version instead.

## Get the sample code

Instead of navigating a large repository tree, use one of these approaches:

#### Option A (clone entire samples repo)

> **Tip**
>
> Code uses **Azure AI Projects 2.x** and is incompatible with Azure AI Projects 1.x. [See the Foundry (classic) documentation](https://learn.microsoft.com/en-us/azure/foundry-classic/) for the Azure AI Projects 1.x version.

**[Python]**

```bash
git clone --depth 1 https://github.com/microsoft-foundry/foundry-samples.git
cd foundry-samples/samples/python/enterprise-agent-tutorial/1-idea-to-prototype
```

**[C#]**

```bash
git clone --depth 1 https://github.com/microsoft-foundry/foundry-samples.git
cd foundry-samples/samples/csharp/enterprise-agent-tutorial/1-idea-to-prototype
```

#### Option B (sparse checkout only this tutorial - reduced download)

**[Python]**

```bash
git clone --no-checkout https://github.com/microsoft-foundry/foundry-samples.git
cd foundry-samples
git sparse-checkout init --cone
git sparse-checkout set samples/python/enterprise-agent-tutorial/1-idea-to-prototype
git checkout
cd samples/python/enterprise-agent-tutorial/1-idea-to-prototype
```

**[C#]**

```bash
git clone --no-checkout https://github.com/microsoft-foundry/foundry-samples.git
cd foundry-samples
git sparse-checkout init --cone
git sparse-checkout set samples/csharp/enterprise-agent-tutorial/1-idea-to-prototype
git checkout
cd samples/csharp/enterprise-agent-tutorial/1-idea-to-prototype
```

#### Option C (Download ZIP of repository)

Download the repository ZIP, extract it to your local environment, and go to the tutorial folder.

> **Important**
>
> For production adoption, use a standalone repository. This tutorial uses the shared samples repo. Sparse checkout minimizes local noise.

**[Python]**

[Download the Python code now](https://github.com/microsoft-foundry/foundry-samples/tree/main/samples/python/enterprise-agent-tutorial/1-idea-to-prototype)

After you extract the ZIP, go to `samples/python/enterprise-agent-tutorial/1-idea-to-prototype`.

**[C#]**

[Download the C# code now](https://github.com/microsoft-foundry/foundry-samples/tree/main/samples/csharp/enterprise-agent-tutorial/1-idea-to-prototype)

After you extract the ZIP, go to `samples/csharp/enterprise-agent-tutorial/1-idea-to-prototype`.

The minimal structure contains only essential files:

**[Python]**

```text
enterprise-agent-tutorial/
└── 1-idea-to-prototype/
   ├── .env                             # Create this file (local environment variables)
   ├── .gitkeep
   ├── evaluate.py                      # Business evaluation framework
   ├── evaluation_results.json
   ├── main.py                          # Modern Workplace Assistant
   ├── questions.jsonl                  # Business test scenarios (4 questions)
   ├── requirements.txt                 # Python dependencies
   └── sharepoint-sample-data/          # Sample business documents for SharePoint
      ├── collaboration-standards.docx
      ├── data-governance-policy.docx
      ├── remote-work-policy.docx
      └── security-guidelines.docx
```

**[C#]**

```text
enterprise-agent-tutorial/
└── 1-idea-to-prototype/
   ├── ModernWorkplaceAssistant/        # Modern Workplace Assistant
   │   ├── Program.cs                   # Agent implementation with SharePoint + MCP
   │   ├── ModernWorkplaceAssistant.csproj
   │   └── .env                         # Environment variables (create this)
   ├── Evaluate/                        # Batch evaluation framework
   │   ├── Program.cs                   # Batch evaluation with built-in evaluators
   │   ├── Evaluate.csproj
   │   └── evaluation_results.json      # Example output (generated)
   ├── questions.jsonl                  # Business test scenarios
   └── README.md                        # Complete setup instructions
```

## Run the sample

Start by running the agent so you see working functionality before diving into implementation details.

### Environment setup and virtual environment

1. Install the required language runtimes, global tools, and VS Code extensions as described in [Prepare your development environment](../05-developer-tools-and-integrations/01-install-cli-sdk.md).
2. Verify that your `requirements.txt` uses these published package versions:

   ```text
   azure-ai-projects>=2.3.0
   azure-identity
   python-dotenv
   ```

Install dependencies:

**[Python]**

```bash
python -m pip install -r requirements.txt
```

**[C#]**

```bash
cd ModernWorkplaceAssistant
dotnet restore

cd ../Evaluate
dotnet restore
```

Verify the install succeeded. You see `Successfully installed azure-ai-projects-...` (Python) or `Restore completed` (.NET) with no errors.

1. Find your project endpoint on the welcome screen of the project.

   ![Screenshot of Microsoft Foundry Models welcome screen showing the endpoint URL and copy button.](https://learn.microsoft.com/en-us/azure/foundry/media/quickstarts/project-endpoint.png)
2. Configure `.env`.

   Set the environment values required for your language.

**[Python]**

Copy `.env.template` to `.env`.

**[C#]**

Create a `.env` file in the `ModernWorkplaceAssistant` directory.

**[Python]**

```dotenv
# Foundry configuration
FOUNDRY_PROJECT_ENDPOINT=https://<your-resource>.services.ai.azure.com/api/projects/<your-project>
FOUNDRY_MODEL_NAME=gpt-4o-mini

# The Microsoft Learn MCP Server (optional)
MCP_SERVER_URL=https://learn.microsoft.com/api/mcp

# SharePoint integration (optional - requires a project connection ID)
SHAREPOINT_CONNECTION_ID=/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.CognitiveServices/accounts/<foundry-account>/projects/<project>/connections/<connection-name>
```

**[C#]**

```dotenv
# Foundry configuration
FOUNDRY_PROJECT_ENDPOINT=https://<your-resource>.services.ai.azure.com/api/projects/<your-project>
FOUNDRY_MODEL_NAME=gpt-4o-mini

# SharePoint integration (optional - requires connection name)
SHAREPOINT_CONNECTION_NAME=<your-sharepoint-connection-name>

# The Microsoft Learn MCP Server (optional)
MCP_SERVER_URL=https://learn.microsoft.com/api/mcp
```

Confirm `.env` contains valid values by opening the file and verifying that `FOUNDRY_PROJECT_ENDPOINT` starts with `https://` and `FOUNDRY_MODEL_NAME` matches the name of a deployed model in your project.

For SharePoint integration, set `SHAREPOINT_CONNECTION_ID` in Python to the connection's full project connection ID. In C#, set `SHAREPOINT_CONNECTION_NAME` to the connection name.

> **Tip**
>
> To get your **tenant ID**, run:
>
> ```bash
> # Get tenant ID
> az account show --query tenantId -o tsv
> ```
>
> To get your **project endpoint**, open your project in the [Foundry portal](https://ai.azure.com/) and copy the value shown there.

### Run agent and evaluation

**[Python]**

```bash
python main.py
python evaluate.py
```

**[C#]**

```bash
cd ModernWorkplaceAssistant
dotnet restore
dotnet run

cd ../Evaluate
dotnet restore
dotnet run
```

### Expected output (agent first run)

Successful run with SharePoint:

```text
🤖 Creating Modern Workplace Assistant...
✅ SharePoint tool configured successfully
✅ Agent created successfully (name: Modern Workplace Assistant, version: 1)
```

Graceful degradation without SharePoint:

**[Python]**

```text
📁 SharePoint integration skipped (SHAREPOINT_CONNECTION_ID not set)
✅ Agent created successfully (name: Modern Workplace Assistant, version: 1)
```

**[C#]**

```text
📁 SharePoint integration skipped (SHAREPOINT_CONNECTION_NAME not set)
✅ Agent created successfully (name: Modern Workplace Assistant, version: 1)
```

Now that you have a working agent, the next sections explain how it works. You don't need to take any action while reading these sections—they're for explanation.

## Set up sample SharePoint business documents

1. Go to your SharePoint site (configured in the connection).
2. Create document library "Company Policies" (or use existing "Documents").
3. Upload the four sample Word documents provided in the `sharepoint-sample-data` folder:
   - `remote-work-policy.docx`
   - `security-guidelines.docx`
   - `collaboration-standards.docx`
   - `data-governance-policy.docx`
4. Verify that four documents appear in the library before proceeding.

### Sample structure

```text
📁 Company Policies/
├── remote-work-policy.docx      # VPN, MFA, device requirements
├── security-guidelines.docx     # Azure security standards
├── collaboration-standards.docx # Teams, SharePoint usage
└── data-governance-policy.docx  # Data classification, retention
```

## Understand the assistant implementation

> **Note**
>
> This section is for reference only — no action needed. It explains the code you already ran.

This section explains the core code in `main.py` (Python) or `ModernWorkplaceAssistant/Program.cs` (C#). You already ran the agent. After reading it, you can:

- Add new internal and external data tools.
- Extend dynamic instructions.
- Introduce multi-agent orchestration.
- Enhance observability and diagnostics.

The code breaks down into the following main sections, ordered as they appear in the full sample code:

1. [Configure imports and authentication](#imports-and-authentication-setup)
2. [Configure authentication to Azure](#configure-authentication-in-azure)
3. [Configure the SharePoint tool](#create-the-sharepoint-tool-for-the-agent)
4. [Configure MCP tool](#create-the-mcp-tool-for-the-agent)
5. [Create the agent and connect the tools](#create-the-agent-and-connect-the-tools)
6. [Converse with the agent](#converse-with-the-agent)

> **Important**
>
> Code in this article uses packages that are currently in preview. This preview is provided without a service-level agreement, and we don't recommend it for production workloads. Certain features might not be supported or might have constrained capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

### Imports and authentication setup

The code uses several client libraries from the Microsoft Foundry SDK to create a robust enterprise agent.

**[Python]**

```python
import os
import time
from azure.ai.projects import AIProjectClient
from azure.ai.projects.models import (
    PromptAgentDefinition,
    SharepointPreviewTool,
    SharepointGroundingToolParameters,
    ToolProjectConnection,
    MCPTool,
)
from azure.identity import DefaultAzureCredential
from dotenv import load_dotenv
from openai.types.responses.response_input_param import (
    McpApprovalResponse,
)
```

**[C#]**

```csharp
using System;
using System.ClientModel;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Azure.AI.Projects;
using Azure.AI.Projects.OpenAI;
using Azure.Identity;
using DotNetEnv;
using OpenAI.Responses;
```

### Configure authentication in Azure

Before you create your agent, set up authentication to the Foundry.

**[Python]**

```python
with (
    DefaultAzureCredential() as credential,
    AIProjectClient(endpoint=endpoint, credential=credential) as project_client,
    project_client.get_openai_client() as openai_client,
):
    print(f"✅ Connected to Foundry: {endpoint}")
```

**[C#]**

```csharp
var credential = new DefaultAzureCredential();

projectClient = new AIProjectClient(new Uri(projectEndpoint), credential);
Console.WriteLine($"✅ Connected to Azure AI Foundry: {projectEndpoint}");
```

### Create the SharePoint tool for the agent

The agent uses SharePoint and can access company policy and procedure documents stored there. Set up the connection to SharePoint in your code.

**[Python]**

```python
sharepoint_connection_id = os.environ.get("SHAREPOINT_CONNECTION_ID")
sharepoint_tool = None

if sharepoint_connection_id:
    print("📁 Configuring SharePoint integration...")
    print(f"   Connection ID: {sharepoint_connection_id}")

    try:
        sharepoint_tool = SharepointPreviewTool(
            sharepoint_grounding_preview=SharepointGroundingToolParameters(
                project_connections=[
                    ToolProjectConnection(
                        project_connection_id=sharepoint_connection_id
                    )
                ]
            )
        )
        print("✅ SharePoint tool configured successfully")
    except Exception as e:
        print(f"⚠️  SharePoint tool unavailable: {e}")
        print("   Agent will operate without SharePoint access")
        sharepoint_tool = None
else:
    print("📁 SharePoint integration skipped (SHAREPOINT_CONNECTION_ID not set)")
```

**[C#]**

```csharp
// Resolve connection name to connection ID via the Connections API
AIProjectConnection sharepointConnection = await projectClient.Connections.GetConnectionAsync(
    sharePointConnectionName, includeCredentials: false);

SharePointGroundingToolOptions sharepointToolOption = new()
{
    ProjectConnections = { new ToolProjectConnection(projectConnectionId: sharepointConnection.Id) }
};
sharepointTool = new SharepointAgentTool(sharepointToolOption);
Console.WriteLine($"✅ SharePoint tool configured successfully");
```

### Create the MCP tool for the agent

.NET SDK support for the MCP tool is currently in preview.

**[Python]**

```python
mcp_server_url = os.environ.get("MCP_SERVER_URL")
mcp_tool = None

if mcp_server_url:
    print("📚 Configuring Microsoft Learn MCP integration...")
    print(f"   Server URL: {mcp_server_url}")

    try:
        mcp_tool = MCPTool(
            server_url=mcp_server_url,
            server_label="Microsoft_Learn_Documentation",
            require_approval="always",
        )
        print("✅ MCP tool configured successfully")
    except Exception as e:
        print(f"⚠️  MCP tool unavailable: {e}")
        print("   Agent will operate without Microsoft Learn access")
        mcp_tool = None
else:
    print("📚 MCP integration skipped (MCP_SERVER_URL not set)")
```

**[C#]**

```csharp
// MCP (Model Context Protocol) enables agents to access external data sources
// like Microsoft Learn documentation. The approval flow is handled in ChatWithAssistantAsync.
McpTool? mcpTool = null;

if (!string.IsNullOrEmpty(mcpServerUrl))
{
    Console.WriteLine($"📚 Configuring Microsoft Learn MCP integration...");
    Console.WriteLine($"   Server URL: {mcpServerUrl}");

    try
    {
        // Create MCP tool for Microsoft Learn documentation access
        // server_label must match pattern: ^[a-zA-Z0-9_]+$ (alphanumeric and underscores only)
        mcpTool = new McpTool("Microsoft_Learn_Documentation", new Uri(mcpServerUrl));
        Console.WriteLine($"✅ MCP tool configured successfully");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"⚠️  MCP tool unavailable: {ex.Message}");
        Console.WriteLine($"   Agent will operate without Microsoft Learn access");
    }
}
else
{
    Console.WriteLine($"📚 MCP integration skipped (MCP_SERVER_URL not set)");
}
```

### Create the agent and connect the tools

Create the agent and connect the SharePoint and MCP tools.

**[Python]**

```python
print(f"🛠️  Creating agent with model: {os.environ['FOUNDRY_MODEL_NAME']}")

tools = []
if sharepoint_tool:
    tools.append(sharepoint_tool)
    print("   ✓ SharePoint tool added")
if mcp_tool:
    tools.append(mcp_tool)
    print("   ✓ MCP tool added")

print(f"   Total tools: {len(tools)}")

agent = project_client.agents.create_version(
    agent_name="Modern Workplace Assistant",
    definition=PromptAgentDefinition(
        model=os.environ["FOUNDRY_MODEL_NAME"],
        instructions=instructions,
        tools=tools if tools else None,
    ),
)

print(f"✅ Agent created successfully (name: {agent.name}, version: {agent.version})")
```

**[C#]**

```csharp
// Create the agent using the v2 SDK with PromptAgentDefinition
Console.WriteLine($"🛠️  Creating agent with model: {modelDeploymentName}");

var agentDefinition = new PromptAgentDefinition(modelDeploymentName)
{
    Instructions = instructions
};

// Add tools to the agent definition
if (sharepointTool != null)
{
    agentDefinition.Tools.Add(sharepointTool);
    Console.WriteLine($"   ✓ SharePoint tool added");
}

if (mcpTool != null)
{
    agentDefinition.Tools.Add(mcpTool);
    Console.WriteLine($"   ✓ MCP tool added");
}

Console.WriteLine($"   Total tools: {agentDefinition.Tools.Count}");

// Create agent version
AgentVersion agentVersion = await projectClient.Agents.CreateAgentVersionAsync(
    agentName: agentName,
    options: new(agentDefinition));

// Create a response client bound to this agent for conversations
responseClient = projectClient.OpenAI
    .GetProjectResponsesClientForAgent(agentVersion);

Console.WriteLine($"✅ Agent created successfully: {agentVersion.Name} (version {agentVersion.Version})");
return agentVersion;
```

### Converse with the agent

Finally, implement an interactive loop to converse with the agent.

**[Python]**

```python
print("🤖 AGENT RESPONSE:")
response, status = create_agent_response(agent, scenario["question"], openai_client)
```

**[C#]**

```csharp
Console.WriteLine("🤖 ASSISTANT RESPONSE:");
var (response, status) = await ChatWithAssistantAsync(scenario.Question);
```

### Expected output from agent sample code

When you run the agent, you see output similar to the following example. The output shows successful tool configuration and agent responses to business scenarios:

```bash
✅ Connected to Foundry
🚀 Foundry - Modern Workplace Assistant
Tutorial 1: Building Enterprise Agents with Microsoft Foundry SDK
======================================================================
🤖 Creating Modern Workplace Assistant...
📁 Configuring SharePoint integration...
   Connection ID: /subscriptions/.../connections/ContosoCorpPoliciesProcedures
✅ SharePoint tool configured successfully
📚 Configuring Microsoft Learn MCP integration...
   Server URL: https://learn.microsoft.com/api/mcp
✅ MCP tool configured successfully
🛠️  Creating agent with model: gpt-4o-mini
   ✓ SharePoint tool added
   ✓ MCP tool added
   Total tools: 2
✅ Agent created successfully (name: Modern Workplace Assistant, version: 1)

======================================================================
🏢 MODERN WORKPLACE ASSISTANT - BUSINESS SCENARIO DEMONSTRATION
======================================================================
This demonstration shows how AI agents solve real business problems
using the Microsoft Foundry SDK.
======================================================================

📊 SCENARIO 1/3: 📋 Company Policy Question (SharePoint Only)
--------------------------------------------------
❓ QUESTION: What is Contosoʹs remote work policy?
🎯 BUSINESS CONTEXT: Employee needs to understand company-specific remote work requirements
🎓 LEARNING POINT: SharePoint tool retrieves internal company policies
--------------------------------------------------
🤖 AGENT RESPONSE:
✅ SUCCESS: Contosoʹs remote work policy, effective January 2024, outlines the following key points:

### Overview
Contoso Corp supports flexible work arrangements, including remote work, to enhance employee productivity and work-life balance.

### Eligibility
- **Full-time Employees**: Must have completed a 90...
   📏 Full response: 1530 characters
📈 STATUS: completed
--------------------------------------------------

📊 SCENARIO 2/3: 📚 Technical Documentation Question (MCP Only)
--------------------------------------------------
❓ QUESTION: According to Microsoft Learn, what is the correct way to implement Microsoft Entra Conditional Access policies? Please include reference links to the official documentation.
🎯 BUSINESS CONTEXT: IT administrator needs authoritative Microsoft technical guidance
🎓 LEARNING POINT: MCP tool accesses Microsoft Learn for official documentation with links
--------------------------------------------------
🤖 AGENT RESPONSE:
✅ SUCCESS: To implement Microsoft Entra Conditional Access policies correctly, follow these key steps outlined in the Microsoft Learn documentation:

### 1. Understanding Conditional Access
Conditional Access policies act as "if-then" statements that enforce organizational access controls based on various signals. Th...
   📏 Full response: 2459 characters
📈 STATUS: completed
--------------------------------------------------

📊 SCENARIO 3/3: 🔄 Combined Implementation Question (SharePoint + MCP)
--------------------------------------------------
❓ QUESTION: Based on our companyʹs remote work security policy, how should I configure my Azure environment to comply? Please include links to Microsoft documentation showing how to implement each requirement.
🎯 BUSINESS CONTEXT: Need to map company policy to technical implementation with official guidance
🎓 LEARNING POINT: Both tools work together: SharePoint for policy + MCP for implementation docs
--------------------------------------------------
🤖 AGENT RESPONSE:
✅ SUCCESS: To configure your Azure environment in compliance with Contoso Corpʹs remote work security policy, you need to focus on several key areas, including enabling Multi-Factor Authentication (MFA), utilizing Azure Security Center, and implementing proper access management. Below are specific steps and li...
   📏 Full response: 3436 characters
📈 STATUS: completed
--------------------------------------------------

✅ DEMONSTRATION COMPLETED!
🎓 Key Learning Outcomes:
   * Microsoft Foundry SDK usage for enterprise AI
   * Conversation management via the Responses API
   * Real business value through AI assistance
   * Foundation for governance and monitoring (Tutorials 2-3)

🎯 Try interactive mode? (y/n): n

🎉 Sample completed successfully!
📚 This foundation supports Tutorial 2 (Governance) and Tutorial 3 (Production)
🔗 Next: Add evaluation metrics, monitoring, and production deployment
```

## Evaluate the assistant with batch evaluation

The evaluation framework tests realistic business scenarios by using the **batch evaluation** capability of the Microsoft Foundry SDK. Instead of a custom local approach, this pattern uses the built-in evaluators (`builtin.violence`, `builtin.fluency`, `builtin.task_adherence`) and the `openai_client.evals` API to run scalable, repeatable evaluations in the cloud.

The Python cloud evaluation requires the **Foundry User** role, a deployed GPT model that supports chat completions, and a region that supports the evaluators you select. Review [supported regions](../10-evaluation/10.1-supported-evaluators/05-risk-safety-evaluators.md#foundry-project-configuration-and-region-support) before you continue.

This evaluation framework demonstrates:

- **Agent targeting**: The evaluation runs queries directly against your agent by using `azure_ai_target_completions`.
- **Built-in evaluators**: Safety (violence detection), quality (fluency), and task adherence metrics.
- **Cloud-based execution**: Eliminates local compute requirements and supports CI/CD integration.
- **Structured results**: Pass/fail labels, scores, and reasoning for each test case.

The code breaks down into the following main sections:

1. [Configure the evaluation](#configure-the-evaluation).
2. [Run the batch evaluation](#run-the-batch-evaluation).
3. [Retrieve evaluation results](#retrieve-evaluation-results).

> **Tip**
>
> For detailed guidance on batch evaluations, see [Run evaluations in the cloud](../10-evaluation/10.3-run-evaluations/02-cloud-evaluation.md). To find a comprehensive list of built-in evaluators available in Foundry, see [Observability in generative AI](../09-observability/01-observability.md).

> **Note**
>
> The C# sample uses a local batch evaluation approach with `ProjectResponsesClient` instead of the cloud `openai_client.evals` API shown in Python. It sends queries to the agent, checks responses against expected keywords, and writes results to `evaluation_results.json`. See the [C# Evaluations SDK sample](https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/ai/Azure.AI.Projects/samples/Evaluations) for cloud evaluation patterns in C#.

### Configure the evaluation

First, create an evaluation object that defines your data schema and testing criteria. The evaluation uses built-in evaluators for violence detection, fluency, and task adherence.

In Python, use the OpenAI client directly. In C#, get an `EvaluationClient` from the project client:

**[Python]**

```python
load_dotenv()
endpoint = os.environ["FOUNDRY_PROJECT_ENDPOINT"]
model_deployment_name = os.environ.get("FOUNDRY_MODEL_NAME", "gpt-4o-mini")

with (
    DefaultAzureCredential() as credential,
    AIProjectClient(endpoint=endpoint, credential=credential) as project_client,
    project_client.get_openai_client() as openai_client,
):
    # Create or retrieve the agent to evaluate
    agent = project_client.agents.create_version(
        agent_name="Modern Workplace Assistant",
        definition=PromptAgentDefinition(
            model=model_deployment_name,
            instructions="You are a helpful Modern Workplace Assistant that answers questions about company policies and technical guidance.",
        ),
    )
    print(f"Agent created (id: {agent.id}, name: {agent.name}, version: {agent.version})")

    # Define the data schema for evaluation
    data_source_config = DataSourceConfigCustom(
        type="custom",
        item_schema={
            "type": "object",
            "properties": {"query": {"type": "string"}},
            "required": ["query"]
        },
        include_sample_schema=True,
    )

    # Define testing criteria with built-in evaluators
    testing_criteria = [
        {
            "type": "azure_ai_evaluator",
            "name": "violence_detection",
            "evaluator_name": "builtin.violence",
            "data_mapping": {"query": "{{item.query}}", "response": "{{sample.output_text}}"},
        },
        {
            "type": "azure_ai_evaluator",
            "name": "fluency",
            "evaluator_name": "builtin.fluency",
            "initialization_parameters": {"deployment_name": f"{model_deployment_name}"},
            "data_mapping": {"query": "{{item.query}}", "response": "{{sample.output_text}}"},
        },
        {
            "type": "azure_ai_evaluator",
            "name": "task_adherence",
            "evaluator_name": "builtin.task_adherence",
            "initialization_parameters": {"deployment_name": f"{model_deployment_name}"},
            "data_mapping": {"query": "{{item.query}}", "response": "{{sample.output_items}}"},
        },
    ]

    # Create the evaluation object
    eval_object = openai_client.evals.create(
        name="Agent Evaluation",
        data_source_config=data_source_config,
        testing_criteria=testing_criteria,
    )
    print(f"Evaluation created (id: {eval_object.id}, name: {eval_object.name})")
```

**[C#]**

```csharp
var questions = File.ReadAllLines(GetFile("questions.jsonl"))
    .Select(line => JsonSerializer.Deserialize<JsonElement>(line))
    .ToList();
```

The `testing_criteria` array specifies which evaluators to run:

- `builtin.violence`: Detects violent or harmful content in responses.
- `builtin.fluency`: Assesses response quality and readability (requires a model deployment).
- `builtin.task_adherence`: Evaluates whether the agent followed instructions correctly.

### Run the batch evaluation

Create an evaluation run that targets your agent. The `azure_ai_target_completions` data source sends queries to your agent and captures responses for evaluation:

**[Python]**

```python
# Define the data source for the evaluation run
data_source = {
    "type": "azure_ai_target_completions",
    "source": {
        "type": "file_content",
        "content": [
            {"item": {"query": "What is Contoso's remote work policy?"}},
            {"item": {"query": "What are the security requirements for remote employees?"}},
            {"item": {"query": "According to Microsoft Learn, how do I configure Azure AD Conditional Access?"}},
            {"item": {"query": "Based on our company policy, how should I configure Azure security to comply?"}},
        ],
    },
    "input_messages": {
        "type": "template",
        "template": [
            {"type": "message", "role": "user", "content": {"type": "input_text", "text": "{{item.query}}"}}
        ],
    },
    "target": {
        "type": "azure_ai_agent",
        "name": agent.name,
        "version": agent.version,
    },
}

# Create and submit the evaluation run
agent_eval_run: Union[RunCreateResponse, RunRetrieveResponse] = openai_client.evals.runs.create(
    eval_id=eval_object.id,
    name=f"Evaluation Run for Agent {agent.name}",
    data_source=data_source,
)
print(f"Evaluation run created (id: {agent_eval_run.id})")
```

**[C#]**

```csharp
// NOTE: This code is a non-runnable snippet of the larger sample code from which it is taken.
var results = new List<object>();

Console.WriteLine($"Running {questions.Count} evaluation questions...\n");

for (int i = 0; i < questions.Count; i++)
{
    var q = questions[i];
    var question = q.GetProperty("question").GetString()!;
    
    string[] expectedKeywords = Array.Empty<string>();
    if (q.TryGetProperty("expected_keywords", out var keywordsElem))
    {
        expectedKeywords = keywordsElem.EnumerateArray()
            .Select(e => e.GetString()!)
            .ToArray();
    }

    Console.WriteLine($"Question {i + 1}/{questions.Count}: {question}");

    // Create a conversation to maintain state
    ProjectConversation conversation = await client.OpenAI.Conversations.CreateProjectConversationAsync();

    // Get OpenAI client from the agents client
    ProjectResponsesClient responseClient = client.OpenAI.GetProjectResponsesClientForAgent(agent, conversation.Id);

    // Create the user message item
    List<ResponseItem> items = [ResponseItem.CreateUserMessageItem(question)];

    string response = "";
    try
    {
        // Create response from the agent
        ResponseResult openAIResponse = await responseClient.CreateResponseAsync(items);
        response = openAIResponse.GetOutputText();
    }
    catch (Exception ex)
    {
        Console.WriteLine($"   ⚠️  Error: {ex.Message}");
        response = "";
    }

    bool passed = response.Length > 50;
    if (expectedKeywords.Length > 0)
    {
        passed = passed && expectedKeywords.Any(k => response.Contains(k, StringComparison.OrdinalIgnoreCase));
    }

    Console.WriteLine($"   Status: {(passed ? "✅ PASS" : "❌ FAIL")}");
    Console.WriteLine($"   Response length: {response.Length} characters\n");

    results.Add(new
    {
        question,
        response,
        passed,
        response_length = response.Length
    });
}
```

The `data_source` configuration:

- **type**: `azure_ai_target_completions` routes queries through your agent
- **source**: Inline content with test queries (you can also use a dataset file ID)
- **input_messages**: Template that formats each query for the agent
- **target**: Specifies the agent name and version to evaluate

### Retrieve evaluation results

Poll the evaluation run until it finishes, and then retrieve the detailed output items.

**[Python]**

```python
# Poll until the evaluation run completes
while agent_eval_run.status not in ["completed", "failed"]:
    agent_eval_run = openai_client.evals.runs.retrieve(
        run_id=agent_eval_run.id,
        eval_id=eval_object.id
    )
    print(f"Waiting for eval run to complete... current status: {agent_eval_run.status}")
    time.sleep(5)

if agent_eval_run.status == "completed":
    print("\n✓ Evaluation run completed successfully!")
    print(f"Result Counts: {agent_eval_run.result_counts}")

    # Retrieve detailed output items
    output_items = list(
        openai_client.evals.runs.output_items.list(
            run_id=agent_eval_run.id,
            eval_id=eval_object.id
        )
    )
    print(f"\nOUTPUT ITEMS (Total: {len(output_items)})")
    print(f"{'-'*60}")
    pprint(output_items)
    print(f"{'-'*60}")
    print(f"Eval Run Report URL: {agent_eval_run.report_url}")
else:
    print("\n✗ Evaluation run failed.")

# Cleanup
openai_client.evals.delete(eval_id=eval_object.id)
print("Evaluation deleted")

project_client.agents.delete(agent_name=agent.name)
print("Agent deleted")
```

**[C#]**

```csharp
// NOTE: This code is a non-runnable snippet of the larger sample code from which it is taken.
var summary = new
{
    total_questions = questions.Count,
    passed = results.Count(r => ((dynamic)r).passed),
    failed = results.Count(r => !((dynamic)r).passed),
    results
};

var json = JsonSerializer.Serialize(summary, new JsonSerializerOptions { WriteIndented = true });
File.WriteAllText("evaluation_results.json", json);

Console.WriteLine($"📊 Evaluation Complete:");
Console.WriteLine($"   Total: {summary.total_questions}");
Console.WriteLine($"   Passed: {summary.passed}");
Console.WriteLine($"   Failed: {summary.failed}");
Console.WriteLine($"\n📄 Results saved to evaluation_results.json");
```

Before you review individual output items, confirm that the evaluation run completes and `Result Counts` shows `errored: 0`. If the run fails, verify your role, selected region, deployed model, and evaluator support.

Each output item includes:

- **Label**: Binary pass or fail result
- **Score**: Numeric score on the evaluator's scale
- **Reason**: Explanation of why the score was assigned (for LLM-based evaluators)

### Expected output from batch evaluation (evaluate.py)

When you run the evaluation script, you see output similar to the following example. The output shows the evaluation object creation, run submission, and results retrieval:

```bash
python evaluate.py
Agent created (name: Modern_Workplace_Assistant, version: 1)
Evaluation created (id: eval_xyz789, name: Agent Evaluation)
Evaluation run created (id: run_def456)
Waiting for eval run to complete... current status: running
Waiting for eval run to complete... current status: running

✓ Evaluation run completed successfully!
Result Counts: {'passed': 2, 'failed': 0, 'errored': 0}

OUTPUT ITEMS (Total: 2)
------------------------------------------------------------
[OutputItem(id='item_1', 
            sample={'query': 'What is the largest city in France?', 
                    'output_text': 'The largest city in France is Paris...'},
            results=[{'name': 'violence_detection', 'passed': True, 'score': 0},
                     {'name': 'fluency', 'passed': True, 'score': 4, 
                      'reason': 'Response is clear and well-structured'},
                     {'name': 'task_adherence', 'passed': True, 'score': 5}]),
 OutputItem(id='item_2', ...)]
------------------------------------------------------------
Eval Run Report URL: https://ai.azure.com/...
Evaluation deleted
Agent deleted
```

### Understanding evaluation results

Batch evaluations provide structured results that you can view in the Foundry portal or retrieve programmatically. Each output item includes:

| Field | Description |
| --- | --- |
| **Label** | Binary "pass" or "fail" based on the threshold |
| **Score** | Numeric score (scale depends on evaluator type) |
| **Threshold** | The cutoff value that determines pass/fail |
| **Reason** | LLM-generated explanation for the score (when applicable) |

**Score scales by evaluator type:**

- **Quality evaluators** (fluency, coherence): 1-5 scale
- **Safety evaluators** (violence, self-harm): 0-7 severity scale (lower is safer)
- **Task evaluators** (task_adherence): 1-5 scale

You can also view detailed results in the Foundry portal by selecting **Evaluation** from your project and selecting the evaluation run. The portal provides visualizations, filtering, and export options.

> **Tip**
>
> For production scenarios, consider running evaluations as part of your CI/CD pipeline. See [How to run an evaluation in Azure DevOps](../10-evaluation/10.5-evaluations-in-ci-cd-pipelines/02-evaluation-azure-devops.md), and [Continuously evaluate your AI agents](../07-agents/07.3-hosted-agents/33-how-to-monitor-agents-dashboard.md) for integration patterns.

## Troubleshooting

| Symptom | Cause | Resolution |
| --- | --- | --- |
| `DefaultAzureCredential` authentication error | Azure CLI session expired or not signed in | Run `az login` and retry |
| `Model deployment not found` | Model name in `.env` doesn't match a deployment in your project | Open your project in the Foundry portal, check **Deployments**, and update `FOUNDRY_MODEL_NAME` in `.env` |
| SharePoint integration is skipped | The SharePoint environment variable isn't set | In Python, set `SHAREPOINT_CONNECTION_ID` to the full project connection ID. In C#, set `SHAREPOINT_CONNECTION_NAME` to the connection name. |
| `SharePoint tool configured` but agent can't find documents | Documents aren't uploaded, the connection is incorrect, or the signed-in user lacks access | Verify the documents are in the configured library, the connection targets that library, and the signed-in user has **Read** access. Use delegated user authentication in the same Microsoft Entra tenant as the Foundry project. |
| MCP tool timeout or connection error | Microsoft Learn MCP server is unreachable | Verify `MCP_SERVER_URL` is set to `https://learn.microsoft.com/api/mcp` and that your network allows outbound HTTPS |
| MCP project connection creation is denied | The account lacks the required project role | Assign the **Foundry Project Manager** role to create the connection, then retry. |
| Cloud evaluation can't start or an evaluator isn't supported | The project region, model, or evaluator combination isn't supported | Verify that your project region supports the evaluator and that the deployed GPT model supports chat completions. |
| `403 Forbidden` on SharePoint | Insufficient permissions on the SharePoint site | Confirm your signed-in identity has at least **Read** access to the SharePoint document library and the **Foundry User** role on the project. |

## Summary

You now have:

- A working single-agent prototype grounded in internal and external knowledge.
- A repeatable evaluation script demonstrating enterprise validation patterns.
- A clear upgrade path: more tools, multi-agent orchestration, richer evaluation, deployment.

These patterns reduce prototype-to-production friction: you can add data sources, enforce governance, and integrate monitoring without rewriting core logic.

## Next steps

This tutorial demonstrates **Stage 1** of the developer journey - from idea to prototype. This minimal sample provides the foundation for enterprise AI development. To continue your journey, explore the next stages:

### Suggested additional enhancements

- Add more data sources ([Azure AI Search](../08-toolboxes/08.1-add-tools-and-skills/28-ai-search.md), [other sources](../13-manage-and-operate/13.1-set-up-and-configure/15-connections-add.md)).
- Implement advanced evaluation methods ([AI-assisted evaluation](../10-evaluation/10.3-run-evaluations/01-evaluate-agent.md)).
- Create [custom tools](../08-toolboxes/08.1-add-tools-and-skills/05-private-tool-catalog.md) for business-specific operations.
- Add [conversation memory and personalization](https://learn.microsoft.com/en-us/azure/cosmos-db/gen-ai/azure-agent-service).

### Stage 2: Prototype to production

- [Implement safety assessment with red-team testing](../10-evaluation/10.4-ai-red-teaming/03-run-scans-ai-red-teaming-agent.md).
- [Create comprehensive evaluation datasets with quality metrics](../06-models/06.8-fine-tuning/08-data-generation.md).
- [Apply organization-wide governance policies and model comparison](../13-manage-and-operate/13.3-security-and-governance/14-model-deployment-policy.md).
- [Configure fleet monitoring, CI/CD integration, and production deployment endpoints](../06-models/06.3-offers-deployment-types-and-pricing/04-deployment-types.md).

### Stage 3: Production to adoption

- [Collect trace data and user feedback from production deployments](../09-observability/09.2-tracing/06-trace-agent-framework.md).
- [Fine-tune models and generate evaluation insights for continuous improvement](../06-models/06.8-fine-tuning/02-fine-tuning.md).
- [Integrate Azure API Management gateway with continuous quality monitoring](../13-manage-and-operate/13.2-govern-at-scale/09-enable-ai-api-management-gateway-portal.md).
- [Implement fleet governance, compliance controls, and cost optimization](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/ai/platform/governance).

## Clean up resources

When you no longer need them, delete the resources you created in this tutorial:

1. **Delete the agent**: The agent is automatically deleted at the end of `main.py` (Python) or `Program.cs` (C#). If you interrupted the run, delete it manually from the **Agents** page in the Foundry portal.
2. **Delete the evaluation run**: In the Foundry portal, go to **Evaluation**, select the evaluation run, and delete it.
3. **Remove SharePoint sample documents**: If you uploaded the sample `.docx` files to a production SharePoint site, remove them from the document library.
4. **(Optional) Delete the Foundry project**: If you created a project only for this tutorial, delete it from the Foundry portal to remove all associated resources.

## Related content

- [Foundry Agent Service overview](../07-agents/01-overview.md)
- [SharePoint tool documentation](../08-toolboxes/08.1-add-tools-and-skills/35-sharepoint.md)
- [MCP tool integration](../08-toolboxes/08.1-add-tools-and-skills/01-model-context-protocol.md).
- [Multi-agent patterns](../08-toolboxes/08.1-add-tools-and-skills/09-agent-to-agent.md).
