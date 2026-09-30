# Quickstart: Get started with Microsoft Foundry SDK

| Field | Value |
| --- | --- |
| **Document Title** | Quickstart: Get started with Microsoft Foundry SDK |
| **Document Location** | `docs/research-docs/azure-foundry/04-get-started/04.1-what-do-you-want-to-build/03-get-started-code.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Quickstart: Get started with Microsoft Foundry SDK". Learn how to use the Microsoft Foundry SDK to build AI applications with Foundry. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/quickstarts/get-started-code). Article date: 2026-09-03. Page updated: 2026-09-04. Retrieved: 2026-09-29. Navigation: Get started > What do you want to build? > Chat with an agent in code.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

In this quickstart you'll get started using models and agents in Foundry.

**You will:**

- Generate a response from a model
- Create an agent with a defined prompt
- Have a multi-turn conversation with the agent

## Prerequisites

- A model deployed in Microsoft Foundry. If you don't have a model, first complete [Quickstart: Set up Microsoft Foundry resources](../02-quickstart-create-foundry-resources.md).

  > **Tip**
  >
  > Or, skip the deployment step and try an [instant model (preview)](../../06-models/06.3-offers-deployment-types-and-pricing/02-instant-models.md) instead. Create a project in **West US 3** to use instant access models. Instant models have no deployment, so use the model name `gpt-5-mini` wherever the samples ask for a deployment name.
- The required language runtimes, global tools, and Visual Studio Code extensions as described in [Prepare your development environment](../../05-developer-tools-and-integrations/01-install-cli-sdk.md).

## Get the code and set your values

**[Python]**

The Python samples don't read environment variables. In each file, replace these placeholder values:

- `your_project_endpoint`: [Your project endpoint](../02-quickstart-create-foundry-resources.md#get-your-project-connection-details), in the format `https://<resource-name>.services.ai.azure.com/api/projects/<project-name>`.
- `your_agent_name`: A name for your agent, such as `MyAgent`.

The samples use the `gpt-5-mini` deployment you created in [Set up Microsoft Foundry resources](../02-quickstart-create-foundry-resources.md). If you deployed a model under a different name, update the model name in the sample code.

Follow along below or get the code:

[Get the code](https://github.com/microsoft-foundry/foundry-samples/tree/main/samples/python/quickstart)

**[C#]**

The C# samples don't read environment variables. In each file, replace these placeholder values:

- `your_project_endpoint`: [Your project endpoint](../02-quickstart-create-foundry-resources.md#get-your-project-connection-details), in the format `https://<resource-name>.services.ai.azure.com/api/projects/<project-name>`.
- `your_agent_name`: A name for your agent, such as `MyAgent`.

The samples use the `gpt-5-mini` deployment you created in [Set up Microsoft Foundry resources](../02-quickstart-create-foundry-resources.md). If you deployed a model under a different name, update the model name in the sample code.

Follow along below or get the code:

[Get the code](https://github.com/microsoft-foundry/foundry-samples/tree/main/samples/csharp/quickstart)

**[TypeScript]**

The TypeScript samples don't read environment variables. In each file, replace these values with [your project endpoint](../02-quickstart-create-foundry-resources.md#get-your-project-connection-details) and an agent name such as `MyAgent`:

```typescript
const FOUNDRY_PROJECT_ENDPOINT = "https://<resource-name>.services.ai.azure.com/api/projects/<project-name>";
const FOUNDRY_AGENT_NAME = "MyAgent";
```

The samples use the `gpt-5-mini` deployment you created in [Set up Microsoft Foundry resources](../02-quickstart-create-foundry-resources.md). If you deployed a model under a different name, update the model name in the sample code.

Follow along below or get the code:

[Get the code](https://github.com/microsoft-foundry/foundry-samples/tree/main/samples/typescript/quickstart/)

**[Java]**

The Java samples don't read environment variables. In each file, replace these values with [your project endpoint](../02-quickstart-create-foundry-resources.md#get-your-project-connection-details) and an agent name such as `MyAgent`:

```java
String foundryProjectEndpoint = "https://<resource-name>.services.ai.azure.com/api/projects/<project-name>";
String foundryAgentName = "MyAgent";
```

The samples use the `gpt-5-mini` deployment you created in [Set up Microsoft Foundry resources](../02-quickstart-create-foundry-resources.md). If you deployed a model under a different name, update the model name in the sample code.

Follow along below or get the code:

[Get the code](https://github.com/microsoft-foundry/foundry-samples/tree/main/samples/java/quickstart/)

**[REST API]**

1. In each request URL, replace `YOUR-FOUNDRY-RESOURCE-NAME` and `YOUR-PROJECT-NAME` with the values from [your project endpoint](../02-quickstart-create-foundry-resources.md#get-your-project-connection-details), which has the form `https://<resource-name>.services.ai.azure.com/api/projects/<project-name>`.
2. The chat-with-agent request reads the agent name from an environment variable:

   ```
   FOUNDRY_AGENT_NAME=MyAgent
   ```

The samples use the `gpt-5-mini` deployment you created in [Set up Microsoft Foundry resources](../02-quickstart-create-foundry-resources.md). If you deployed a model under a different name, update the `model` value in the request body.

Follow along below or get the code:

[Get the code](https://github.com/microsoft-foundry/foundry-samples/tree/main/samples/REST/quickstart).

**[Foundry portal]**

No code is necessary when using the Foundry portal.

## Install and authenticate

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

## Chat with a model

Interacting with a model is the basic building block of AI applications. Send an input and receive a response from the model:

**[Python]**

```python
from azure.identity import DefaultAzureCredential
from azure.ai.projects import AIProjectClient

# Format: "https://resource_name.services.ai.azure.com/api/projects/project_name"
FOUNDRY_PROJECT_ENDPOINT = "your_project_endpoint"

# Create project and openai clients to call Foundry API
project = AIProjectClient(
    endpoint=FOUNDRY_PROJECT_ENDPOINT,
    credential=DefaultAzureCredential(),
)
openai = project.get_openai_client()

# Run a responses API call
response = openai.responses.create(
    model="gpt-5-mini",  # supports all Foundry direct models
    input="What is the size of France in square miles?",
)
if not response.output_text or not response.output_text.strip():
    raise RuntimeError("Response output text was empty.")

print(f"Response output: {response.output_text}")
```

**[C#]**

```csharp
using Azure.Identity;
using Azure.AI.Projects;
using Azure.AI.Extensions.OpenAI;
using OpenAI.Responses;

#pragma warning disable OPENAI001

// Format: "https://resource_name.services.ai.azure.com/api/projects/project_name"
var foundryProjectEndpoint = "your_project_endpoint";

// Create project client to call Foundry API
AIProjectClient projectClient = new(
    endpoint: new Uri(foundryProjectEndpoint),
    tokenProvider: new DefaultAzureCredential());

// Run a responses API call
ProjectResponsesClient responseClient = projectClient.ProjectOpenAIClient.GetProjectResponsesClientForModel(
    "gpt-5-mini"); // supports all Foundry direct models
ResponseResult response = await responseClient.CreateResponseAsync(
    "What is the size of France in square miles?");
string outputText = response.GetOutputText();
if (string.IsNullOrWhiteSpace(outputText))
{
    throw new InvalidOperationException("Response output text was empty.");
}

Console.WriteLine(outputText);
```

**[TypeScript]**

```typescript
import { DefaultAzureCredential } from "@azure/identity";
import { AIProjectClient } from "@azure/ai-projects";

// Format: "https://resource_name.services.ai.azure.com/api/projects/project_name"
const FOUNDRY_PROJECT_ENDPOINT = "your_project_endpoint";

async function main(): Promise<void> {
    // Create project and openai clients to call Foundry API
    const project = new AIProjectClient(FOUNDRY_PROJECT_ENDPOINT, new DefaultAzureCredential());
    const openai = project.getOpenAIClient();

    // Run a responses API call
    const response = await openai.responses.create({
        model: "gpt-5-mini",
        input: "What is the size of France in square miles?",
    });
    console.log(`Response output: ${response.output_text}`);
}

main().catch(console.error);
```

**[Java]**

```java
package com.azure.ai.foundry.samples;

import com.azure.ai.agents.AgentsClientBuilder;
import com.azure.ai.agents.ResponsesClient;
import com.azure.identity.DefaultAzureCredentialBuilder;
import com.openai.models.responses.Response;
import com.openai.models.responses.ResponseCreateParams;

public class CreateResponse {
    public static void main(String[] args) {
        // Format: "https://resource_name.services.ai.azure.com/api/projects/project_name"
        String foundryProjectEndpoint = "your_project_endpoint";

        // Create responses client to call Foundry API
        ResponsesClient responsesClient = new AgentsClientBuilder()
                .credential(new DefaultAzureCredentialBuilder().build())
                .endpoint(foundryProjectEndpoint)
                .buildResponsesClient();

        // Run a responses API call
        ResponseCreateParams responseRequest = new ResponseCreateParams.Builder()
                .input("What is the size of France in square miles?")
                .model("gpt-5-mini")
                .build();
        Response response = responsesClient.getResponseService().create(responseRequest);
        System.out.println(response.output());
    }
}
```

**[REST API]**

Replace `YOUR-FOUNDRY-RESOURCE-NAME` with your values:

```console
curl -X POST https://YOUR-FOUNDRY-RESOURCE-NAME.services.ai.azure.com/api/projects/YOUR-PROJECT-NAME/openai/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AZURE_AI_AUTH_TOKEN" \
-d '{
        "model": "gpt-5-mini",
        "input": "What is the size of France in square miles?"
}'
```

**[Foundry portal]**

1. After the model deploys, you're automatically moved from **Home** to the **Build** section. Your new model is selected and ready for you to try out.

   > **Tip**
   >
   > If you skipped deployment, select **Test in playground** from the home page. Select the instant access model you want to use, such as `gpt-5-mini`. (During preview, these instant access models are available only for projects in **West US3**.)
2. Start chatting with your model, for example, "Write me a poem about flowers."

After running the code, you see a model-generated response in the console (for example, a short poem or answer to your prompt). This confirms your project endpoint, authentication, and model deployment are working correctly.

> **Tip**
>
> Code uses **Azure AI Projects 2.x** and is incompatible with Azure AI Projects 1.x. [See the Foundry (classic) documentation](https://learn.microsoft.com/en-us/azure/foundry-classic/) for the Azure AI Projects 1.x version.

## Create an agent

Create an agent using your deployed model.

An agent defines core behavior. Once created, it ensures consistent responses in user interactions without repeating instructions each time. You can update or delete agents anytime.

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

**[Foundry portal]**

Now create an agent and interact with it.

1. Still in the **Build** section, select **Agents** in the left pane.
2. Select **Create agent** and give it a name, such as "MyAgent".

The output confirms the agent was created. For SDK tabs, you see the agent name and ID printed to the console.

> **Tip**
>
> Code uses **Azure AI Projects 2.x** and is incompatible with Azure AI Projects 1.x. [See the Foundry (classic) documentation](https://learn.microsoft.com/en-us/azure/foundry-classic/) for the Azure AI Projects 1.x version.

## Chat with an agent

Use the previously created agent named "MyAgent" to interact by asking a question and a related follow-up. The conversation maintains history across these interactions.

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

Replace `YOUR-FOUNDRY-RESOURCE-NAME` with your values:

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

**[Foundry portal]**

Interact with your agent.

1. Add instructions, such as, "You are a helpful writing assistant."
2. Start chatting with your agent, for example, "Write a poem about the sun."
3. Follow up with "How about a haiku?"

You see the agent's responses to both prompts. The follow-up response demonstrates that the agent maintains conversation history across turns.

> **Tip**
>
> Code uses **Azure AI Projects 2.x** and is incompatible with Azure AI Projects 1.x. [See the Foundry (classic) documentation](https://learn.microsoft.com/en-us/azure/foundry-classic/) for the Azure AI Projects 1.x version.

## Clean up resources

If you no longer need any of the resources you created, delete the resource group associated with your project.

- In the [Azure portal](https://portal.azure.com/), select the resource group, and then select **Delete**. Confirm that you want to delete the resource group.

## Next step

[Idea to prototype - Build and evaluate an enterprise agent](../03-developer-journey-idea-to-prototype.md)
