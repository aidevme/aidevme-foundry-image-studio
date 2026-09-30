# Quickstart: Create a prompt agent

| Field | Value |
| --- | --- |
| **Document Title** | Quickstart: Create a prompt agent |
| **Document Location** | `docs/research-docs/azure-foundry/04-get-started/04.1-what-do-you-want-to-build/01-prompt-agent.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Quickstart: Create a prompt agent". Learn how to create a prompt agent in Foundry Agent Service using the Microsoft Foundry SDK, then have a multi-turn conversation with the agent you create. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/quickstarts/prompt-agent). Article date: 2026-09-09. Page updated: 2026-09-24. Retrieved: 2026-09-29. Navigation: Get started > What do you want to build? > Build a prompt agent.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

In this quickstart, you create a prompt agent in Foundry Agent Service and have a conversation with it. A prompt agent is a declaratively defined agent that combines a model from the Foundry model catalog, instructions, tools, and natural language prompts to drive behavior.

> **Tip**
>
> For a managed real-time voice experience, use a [voice-based prompt agent](02-prompt-voice-agent.md). Voice-based prompt agents use Voice Live for spoken conversations and don't require you to host the voice orchestration code.

If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

## Prerequisites

- A model deployed in Microsoft Foundry. If you don't have a model, first complete [Quickstart: Set up Microsoft Foundry resources](../02-quickstart-create-foundry-resources.md).
- The required language runtimes, global tools, and Visual Studio Code extensions as described in [Prepare your development environment](../../05-developer-tools-and-integrations/01-install-cli-sdk.md).

## Get your project endpoint

Copy [your project endpoint](../02-quickstart-create-foundry-resources.md#get-your-project-connection-details) from the welcome screen in the Foundry portal.

The code samples in this quickstart declare their values as constants at the top of each file. Before you run a sample, replace these placeholders:

- `your_project_endpoint`: Your project endpoint, in the format `https://<resource-name>.services.ai.azure.com/api/projects/<project-name>`.
- `your_agent_name`: A name for your agent, such as `MyAgent`.

## Install packages and authenticate

Make sure you install the correct version of the packages as shown here.

**[Python]**

1. Install the current version of `azure-ai-projects`. This version uses the **Foundry projects (new) API**. The samples authenticate by using `DefaultAzureCredential`, which comes from `azure-identity`.

   ```
   pip install "azure-ai-projects>=2.3.0" azure-identity
   ```
2. Sign in using the CLI `az login` command to authenticate before running your Python scripts.

**[C#]**

1. Install packages:

   Add NuGet packages using the .NET CLI in the integrated terminal: These packages use the **Foundry projects (new) API**.

   ```bash
   dotnet add package Azure.AI.Projects
   dotnet add package Azure.AI.Projects.Agents
   dotnet add package Azure.AI.Extensions.OpenAI
   dotnet add package Azure.Identity
   ```
2. Sign in using the CLI `az login` command to authenticate before running your C# scripts.

**[TypeScript]**

1. Install the current version of `@azure/ai-projects`. This version uses the **Foundry projects (new) API**.:

   ```bash
   npm install @azure/ai-projects @azure/identity
   ```
2. Sign in using the CLI `az login` command to authenticate before running your TypeScript scripts.

**[Java]**

```xml
<dependency>
    <groupId>com.azure</groupId>
    <artifactId>azure-ai-agents</artifactId>
    <version>2.2.0</version>
</dependency>
<dependency>
    <groupId>com.azure</groupId>
    <artifactId>azure-core</artifactId>
    <version>1.57.0</version>
</dependency>
<dependency>
    <groupId>com.azure</groupId>
    <artifactId>azure-identity</artifactId>
    <version>1.18.1</version>
</dependency>
```

1. Sign in using the CLI `az login` command to authenticate before running your Java scripts.

**[REST API]**

1. Sign in using the CLI `az login` command to authenticate before running the next command.
2. Get a temporary access token. It will expire in 60-90 minutes, you'll need to refresh after that.

   ```azurecli
   az account get-access-token --scope https://ai.azure.com/.default
   ```
3. Save the results as the environment variable `AZURE_AI_AUTH_TOKEN`.

**[Foundry portal]**

No installation is necessary to use the Foundry portal.

> **Tip**
>
> Code uses **Azure AI Projects 2.x** and is incompatible with Azure AI Projects 1.x. [See the Foundry (classic) documentation](https://learn.microsoft.com/en-us/azure/foundry-classic/) for the Azure AI Projects 1.x version.

## Create a prompt agent

Create a prompt agent using your deployed model. The agent uses a `PromptAgentDefinition` with instructions that define the agent's behavior. You can update or delete agents anytime.

**[Python]**

```python
from azure.identity import DefaultAzureCredential
from azure.ai.projects import AIProjectClient
from azure.ai.projects.models import PromptAgentDefinition

# Format: "https://resource_name.services.ai.azure.com/api/projects/project_name"
FOUNDRY_PROJECT_ENDPOINT = "your_project_endpoint"
FOUNDRY_AGENT_NAME = "your-agent-name"

# Create project client to call Foundry API
project = AIProjectClient(
    endpoint=FOUNDRY_PROJECT_ENDPOINT,
    credential=DefaultAzureCredential(),
)

# Create an agent with a model and instructions
agent = project.agents.create_version(
    agent_name=FOUNDRY_AGENT_NAME,
    definition=PromptAgentDefinition(
        model="gpt-5-mini",  # supports all Foundry direct models
        instructions="You are a helpful assistant that answers general questions",
    ),
)
print(f"Agent created (id: {agent.id}, name: {agent.name}, version: {agent.version})")
```

**[C#]**

```csharp
using Azure.Identity;
using Azure.AI.Projects;
using Azure.AI.Projects.Agents;
using Azure.AI.Extensions.OpenAI;

// Format: "https://resource_name.services.ai.azure.com/api/projects/project_name"
var foundryProjectEndpoint = "your_project_endpoint";
var foundryAgentName = "your-agent-name";

// Create project client to call Foundry API
AIProjectClient projectClient = new(
    endpoint: new Uri(foundryProjectEndpoint),
    tokenProvider: new DefaultAzureCredential());

// Create an agent with a model and instructions
ProjectsAgentDefinition agentDefinition = new DeclarativeAgentDefinition("gpt-5-mini") // supports all Foundry direct models
{
    Instructions = "You are a helpful assistant that answers general questions",
};

ProjectsAgentVersion agent = projectClient.AgentAdministrationClient.CreateAgentVersion(
    foundryAgentName,
    options: new(agentDefinition));
Console.WriteLine($"Agent created (id: {agent.Id}, name: {agent.Name}, version: {agent.Version})");
```

**[TypeScript]**

```typescript
import { DefaultAzureCredential } from "@azure/identity";
import { AIProjectClient } from "@azure/ai-projects";

// Format: "https://resource_name.services.ai.azure.com/api/projects/project_name"
const FOUNDRY_PROJECT_ENDPOINT = "your_project_endpoint";
const FOUNDRY_AGENT_NAME = "your_agent_name";

async function main(): Promise<void> {
    // Create project client to call Foundry API
    const project = new AIProjectClient(FOUNDRY_PROJECT_ENDPOINT, new DefaultAzureCredential());

    // Create an agent with a model and instructions
    const agent = await project.agents.createVersion(FOUNDRY_AGENT_NAME, {
        kind: "prompt",
        model: "gpt-5-mini", //supports all Foundry direct models
        instructions: "You are a helpful assistant that answers general questions",
    });
    console.log(`Agent created (id: ${agent.id}, name: ${agent.name}, version: ${agent.version})`);
}

main().catch(console.error);
```

**[Java]**

```java
package com.azure.ai.foundry.samples;

import com.azure.ai.agents.AgentsClient;
import com.azure.ai.agents.AgentsClientBuilder;
import com.azure.ai.agents.models.AgentVersionDetails;
import com.azure.ai.agents.models.PromptAgentDefinition;
import com.azure.identity.DefaultAzureCredentialBuilder;

public class CreateAgent {
    public static void main(String[] args) {
        // Format: "https://resource_name.services.ai.azure.com/api/projects/project_name"
        String foundryProjectEndpoint = "your_project_endpoint";
        String foundryAgentName = "your-agent-name";

        // Create agents client to call Foundry API
        AgentsClient agentsClient = new AgentsClientBuilder()
                .credential(new DefaultAzureCredentialBuilder().build())
                .endpoint(foundryProjectEndpoint)
                .buildAgentsClient();

        // Create an agent with a model and instructions
        PromptAgentDefinition request = new PromptAgentDefinition("gpt-5-mini") // supports all Foundry direct models
                .setInstructions("You are a helpful assistant that answers general questions");
        AgentVersionDetails agent = agentsClient.createAgentVersion(foundryAgentName, request);

        System.out.println("Agent ID: " + agent.getId());
        System.out.println("Agent Name: " + agent.getName());
        System.out.println("Agent Version: " + agent.getVersion());
    }
}
```

**[REST API]**

Replace `YOUR-FOUNDRY-RESOURCE-NAME` with your values:

```console
curl -X POST https://YOUR-FOUNDRY-RESOURCE-NAME.services.ai.azure.com/api/projects/YOUR-PROJECT-NAME/agents?api-version=v1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AZURE_AI_AUTH_TOKEN" \
  -d '{
    "name": "MyAgent",
    "definition": {
      "kind": "prompt",
      "model": "gpt-5-mini",
      "instructions": "You are a helpful assistant that answers general questions"
    }
  }'
```

The output confirms the agent was created. You see the agent name and ID printed to the console.

## Chat with the agent

Use the agent you created to interact by asking a question and a related follow-up. The conversation maintains history across these interactions.

**[Python]**

```python
from azure.identity import DefaultAzureCredential
from azure.ai.projects import AIProjectClient
from azure.ai.projects.models import PromptAgentDefinition

# Format: "https://resource_name.services.ai.azure.com/api/projects/project_name"
FOUNDRY_PROJECT_ENDPOINT = "your_project_endpoint"
FOUNDRY_AGENT_NAME = "your-agent-name"

# Create project and openai clients to call Foundry API
project = AIProjectClient(
    endpoint=FOUNDRY_PROJECT_ENDPOINT,
    credential=DefaultAzureCredential(),
)

# Create the agent (or a new version, if it already exists)
project.agents.create_version(
    agent_name=FOUNDRY_AGENT_NAME,
    definition=PromptAgentDefinition(
        model="gpt-5-mini",
        instructions="You are a helpful assistant that answers general questions",
    ),
)

# Get an OpenAI client pre-bound to the specified agent
openai = project.get_openai_client(agent_name=FOUNDRY_AGENT_NAME)

# Create a conversation for multi-turn chat
conversation = openai.conversations.create()

# Chat with the agent to answer questions
response = openai.responses.create(
    conversation=conversation.id,
    input="What is the size of France in square miles?",
)
print(response.output_text)

# Ask a follow-up question in the same conversation
response = openai.responses.create(
    conversation=conversation.id,
    input="And what is the capital city?",
)
print(response.output_text)
```

**[C#]**

```csharp
using Azure.Identity;
using Azure.AI.Projects;
using Azure.AI.Projects.Agents;
using Azure.AI.Extensions.OpenAI;
using OpenAI.Responses;

#pragma warning disable OPENAI001

// Format: "https://resource_name.services.ai.azure.com/api/projects/project_name"
var foundryProjectEndpoint = "your_project_endpoint";
var foundryAgentName = "your-agent-name";

// Create project client to call Foundry API
AIProjectClient projectClient = new(
    endpoint: new Uri(foundryProjectEndpoint),
    tokenProvider: new DefaultAzureCredential());

// Create the agent (or a new version, if it already exists)
ProjectsAgentDefinition agentDefinition = new DeclarativeAgentDefinition("gpt-5-mini") // supports all Foundry direct models
{
    Instructions = "You are a helpful assistant that answers general questions",
};
projectClient.AgentAdministrationClient.CreateAgentVersion(
    foundryAgentName,
    options: new(agentDefinition));

// Create a conversation for multi-turn chat
ProjectConversation conversation = projectClient.ProjectOpenAIClient.GetProjectConversationsClient().CreateProjectConversation();

// Chat with the agent to answer questions
ProjectResponsesClient responsesClient = projectClient.ProjectOpenAIClient.GetProjectResponsesClientForAgent(
    defaultAgent: foundryAgentName,
    defaultConversationId: conversation.Id);
ResponseResult response = responsesClient.CreateResponse("What is the size of France in square miles?");
Console.WriteLine(response.GetOutputText());

// Ask a follow-up question in the same conversation
response = responsesClient.CreateResponse("And what is the capital city?");
Console.WriteLine(response.GetOutputText());
```

**[TypeScript]**

```typescript
import { DefaultAzureCredential } from "@azure/identity";
import { AIProjectClient } from "@azure/ai-projects";

// Format: "https://resource_name.services.ai.azure.com/api/projects/project_name"
const FOUNDRY_PROJECT_ENDPOINT = "your_project_endpoint";
const FOUNDRY_AGENT_NAME = "your-agent-name";

async function createAgentVersion(projectEndpoint: string, agentName: string): Promise<void> {
    const credential = new DefaultAzureCredential();
    const token = await credential.getToken("https://ai.azure.com/.default");
    if (!token) {
        throw new Error("Failed to acquire a Foundry access token");
    }

    const response = await fetch(
        `${projectEndpoint.replace(/\/$/, "")}/agents/${encodeURIComponent(agentName)}/versions?api-version=v1`,
        {
            method: "POST",
            headers: {
                "Authorization": ["Bearer", token.token].join(" "),
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
                definition: {
                    kind: "prompt",
                    model: "gpt-5-mini", //supports all Foundry direct models
                    instructions: "You are a helpful assistant that answers general questions",
                },
            }),
        },
    );
    if (!response.ok) {
        throw new Error(`Failed to create agent version: ${response.status} ${await response.text()}`);
    }
}

async function main(): Promise<void> {
    // Create project and openai clients to call Foundry API
    const project = new AIProjectClient(FOUNDRY_PROJECT_ENDPOINT, new DefaultAzureCredential());

    // Create the agent (or a new version, if it already exists)
    await createAgentVersion(FOUNDRY_PROJECT_ENDPOINT, FOUNDRY_AGENT_NAME);

    const openai = project.getOpenAIClient({
        azureConfig: { allowPreview: true, agentName: FOUNDRY_AGENT_NAME },
    });

    // Create a conversation for multi-turn chat
    const conversation = await openai.conversations.create();

    // Chat with the agent to answer questions
    const response = await openai.responses.create({
        conversation: conversation.id,
        input: "What is the size of France in square miles?",
    });
    console.log(response.output_text);

    // Ask a follow-up question in the same conversation
    const response2 = await openai.responses.create({
        conversation: conversation.id,
        input: "And what is the capital city?",
    });
    console.log(response2.output_text);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
```

**[Java]**

```java
package com.azure.ai.foundry.samples;

import com.azure.ai.agents.AgentsClient;
import com.azure.ai.agents.AgentsClientBuilder;
import com.azure.ai.agents.models.PromptAgentDefinition;
import com.azure.identity.DefaultAzureCredentialBuilder;
import com.openai.client.OpenAIClient;
import com.openai.models.conversations.Conversation;
import com.openai.models.responses.Response;
import com.openai.models.responses.ResponseCreateParams;

public class ChatWithAgent {
    public static void main(String[] args) {
        // Format: "https://resource_name.services.ai.azure.com/api/projects/project_name"
        String foundryProjectEndpoint = "your_project_endpoint";
        String foundryAgentName = "your-agent-name";
        
        AgentsClientBuilder builder = new AgentsClientBuilder()
                .credential(new DefaultAzureCredentialBuilder().build())
                .endpoint(foundryProjectEndpoint);

        // Create the agent (or a new version, if it already exists)
        AgentsClient agentsClient = builder.buildAgentsClient();
        PromptAgentDefinition agentDefinition = new PromptAgentDefinition("gpt-5-mini") // supports all Foundry direct models
                .setInstructions("You are a helpful assistant that answers general questions");
        agentsClient.createAgentVersion(foundryAgentName, agentDefinition);

        // Create an OpenAI client bound to the agent endpoint
        OpenAIClient openai = builder.buildAgentScopedOpenAIClient(foundryAgentName);

        // Create a conversation for multi-turn chat
        Conversation conversation = openai.conversations().create();

        // Chat with the agent to answer questions
        Response response = openai.responses().create(
            ResponseCreateParams.builder()
                .conversation(conversation.id())
                .input("What is the size of France in square miles?")
                .build());
        printResponse(response);

        // Ask a follow-up question in the same conversation
        Response followUp = openai.responses().create(
            ResponseCreateParams.builder()
                .conversation(conversation.id())
                .input("And what is the capital city?")
                .build());
        printResponse(followUp);
    }

    private static void printResponse(Response response) {
        response.output().forEach(item -> item.message().ifPresent(message ->
            message.content().forEach(content -> content.outputText().ifPresent(
                text -> System.out.println(text.text())))));
    }
}
```

**[REST API]**

Replace `YOUR-FOUNDRY-RESOURCE-NAME` with your values, and set the `FOUNDRY_AGENT_NAME` environment variable to the agent name you used:

```console
# Generate a response using the agent

curl -X POST "https://YOUR-FOUNDRY-RESOURCE-NAME.services.ai.azure.com/api/projects/YOUR-PROJECT-NAME/agents/${FOUNDRY_AGENT_NAME}/endpoint/protocols/openai/responses?api-version=v1" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AZURE_AI_AUTH_TOKEN" \
  -d '{
    "input": [{"role": "user", "content": "What is the size of France in square miles?"}]
  }'

# Optional Step: Create a conversation to use with the agent
curl -X POST "https://YOUR-FOUNDRY-RESOURCE-NAME.services.ai.azure.com/api/projects/YOUR-PROJECT-NAME/agents/${FOUNDRY_AGENT_NAME}/endpoint/protocols/openai/conversations?api-version=v1" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AZURE_AI_AUTH_TOKEN" \
  -d '{
    "items": [
      {
        "type": "message",
        "role": "user",
        "content": [
          {
            "type": "input_text",
            "text": "What is the size of France in square miles?"
          }
        ]
      }
    ]
  }'

# Lets say Conversation ID created is conv_123456789. Use this in the next step

#Optional Step: Ask a follow-up question in the same conversation
curl -X POST "https://YOUR-FOUNDRY-RESOURCE-NAME.services.ai.azure.com/api/projects/YOUR-PROJECT-NAME/agents/${FOUNDRY_AGENT_NAME}/endpoint/protocols/openai/responses?api-version=v1" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AZURE_AI_AUTH_TOKEN" \
  -d '{
    "conversation": "<CONVERSATION_ID>",
    "input": [{"role": "user", "content": "And what is the capital?"}]
  }'
```

You see the agent's responses to both prompts. The follow-up response demonstrates that the agent maintains conversation history across turns.

## Clean up resources

If you no longer need any of the resources you created, delete the resource group associated with your project.

- In the [Azure portal](https://portal.azure.com/), select the resource group, and then select **Delete**. Confirm that you want to delete the resource group.

## Related content

- [Agent development lifecycle](../../07-agents/07.1-concepts/01-development-lifecycle.md)
- [What is Foundry Agent Service?](../../07-agents/01-overview.md)
- [Use tools with agents](../../08-toolboxes/08.1-add-tools-and-skills/01-model-context-protocol.md)
- [Quickstart: Deploy your first hosted agent](../../07-agents/07.3-hosted-agents/07-quickstart-hosted-agent.md)
