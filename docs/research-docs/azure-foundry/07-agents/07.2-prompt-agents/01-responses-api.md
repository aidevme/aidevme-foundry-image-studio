# Quickstart: Build agents using the Responses API

| Field | Value |
| --- | --- |
| **Document Title** | Quickstart: Build agents using the Responses API |
| **Document Location** | `docs/research-docs/azure-foundry/07-agents/07.2-prompt-agents/01-responses-api.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Quickstart: Build agents using the Responses API". Call the Responses API on a Foundry project endpoint from your own code using the Agent Framework FoundryChatClient or the OpenAI SDK. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/quickstarts/responses-api). Article date: 2026-07-07. Page updated: 2026-07-07. Retrieved: 2026-09-29. Navigation: Agents > Prompt agents > Text-based agents > Quickstarts > Use the Responses API.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

In this quickstart, you call the **Responses API** on a Foundry project endpoint from your own code to build an **ephemeral agent** — an agent whose definition (instructions, tools, model) lives in your application code instead of as a persisted resource in Foundry Agent Service. Each call constructs the agent in your process and invokes the Responses API for model inference and tool orchestration.

This pattern fits developers, ISVs, and digital natives who want their agent definitions to ship and version with the rest of their application code, rather than as an out-of-band resource that someone has to keep in sync with the app. Unlike [prompt agents](../../04-get-started/04.1-what-do-you-want-to-build/01-prompt-agent.md), there's no agent resource to create, update, or delete in Foundry — lifecycle management is replaced by calling the Responses API directly.

The Responses API is the single model and tools entry point for Foundry. You can call it on two different endpoints:

- **Foundry project endpoint** (this quickstart, recommended) — full Foundry support. Exposes Foundry models from the catalog and platform tools (file search, code interpreter, memory, web search, MCP, SharePoint, WorkIQ, Fabric IQ, and more) through a single project-scoped API surface, reached at `{project_endpoint}/openai/v1/responses`.
- **Azure OpenAI endpoint** — best latency and maximum compatibility with existing OpenAI clients. Use this when you only need OpenAI models and standard OpenAI tools and don't need Foundry-specific capabilities.

The recommended path is the [Agent Framework](https://github.com/microsoft/agent-framework), which handles authentication, tool wiring, and message orchestration for you. In Python this is `FoundryChatClient`; in .NET it's `AIProjectClient.AsAIAgent(...)`. The OpenAI SDK also works against this endpoint and is covered as an alternative in [Use the OpenAI SDK directly](#use-the-openai-sdk-directly).

If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

## When to use the ephemeral agent pattern

Use this pattern when you're hosting agent code outside of Foundry — potentially embedded in your own application — but want to access Foundry agent features like models and platform tools.

The ephemeral pattern and [hosted agents](../07.3-hosted-agents/07-quickstart-hosted-agent.md) are **additive, not alternatives**. The same Agent Framework agent code can also be packaged as a hosted agent and exposed through the Foundry Agents API — useful when you want a Foundry-managed endpoint that other apps, services, or agents can call. You can do both from one codebase: run the agent in-process where it ships with your app, and publish the same definition as a hosted agent where other callers need it.

## What the Foundry project endpoint adds on top of the OpenAI Responses API

The Responses API on a Foundry project endpoint is compatible with the OpenAI Responses API, so existing OpenAI clients work against it with minimal changes. The Foundry project endpoint adds the following on top:

- **Project-scoped data**: Files, vector stores, and other data are stored at the **project** level instead of the resource level, which gives per-project data isolation and lets you use bring-your-own resources through standard agent setup.
- **Foundry Models in addition to OpenAI**: Foundry Models sold directly by Azure (not just OpenAI models) are available through the same API.
- **Foundry-specific tools**: Platform tools like SharePoint, WorkIQ, and Fabric IQ are available alongside the standard OpenAI tools.
- **On-behalf-of (OBO) authentication for tools**: Tools can call downstream services as the signed-in user, not just as the application identity.
- **Project-level observability and governance**: Calls made through the project endpoint flow through the project's tracing, monitoring, content filters, and identity configuration without extra wiring (see [Observability and enterprise capabilities](#observability-and-enterprise-capabilities)).

Calling the **project endpoint** — not a resource-level OpenAI endpoint — is what unlocks these project-scoped capabilities.

## Prerequisites

- A model deployed in Microsoft Foundry. If you don't have a model, first complete [Quickstart: Set up Microsoft Foundry resources](../../04-get-started/02-quickstart-create-foundry-resources.md).
- The [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed and signed in (`az login`).

**[python]**

- Python 3.10 or later installed.

**[csharp]**

- [.NET 8 SDK](https://dotnet.microsoft.com/download) or later installed.

## Set environment variables

Store [your project endpoint](../../04-get-started/02-quickstart-create-foundry-resources.md#get-your-project-connection-details) and deployed model name as environment variables. The samples below read these values from the environment.

```
FOUNDRY_PROJECT_ENDPOINT=<endpoint copied from welcome screen>
FOUNDRY_MODEL=<your deployed model name>
```

## Install packages

Install the Agent Framework package with the Foundry provider:

**[python]**

```bash
pip install agent-framework-foundry aiohttp
```

**[csharp]**

```bash
dotnet add package Microsoft.Agents.AI.Foundry --prerelease
dotnet add package Azure.AI.Projects --prerelease
dotnet add package Azure.Identity
```

`Microsoft.Agents.AI.Foundry` provides the `AsAIAgent(...)` extension method on `AIProjectClient` and transitively brings in `Microsoft.Agents.AI`.

## Create an agent

Create an ephemeral agent that runs locally in your process and calls the Responses API for model inference and tool orchestration.

**[python]**

Use `FoundryChatClient` and the `Agent` class.

```python
import asyncio
import os

from agent_framework import Agent
from agent_framework.foundry import FoundryChatClient
from azure.identity import AzureCliCredential

async def main() -> None:
    agent = Agent(
        client=FoundryChatClient(
            project_endpoint=os.environ["FOUNDRY_PROJECT_ENDPOINT"],
            model=os.environ["FOUNDRY_MODEL"],
            credential=AzureCliCredential(),
        ),
        instructions="You are a helpful assistant.",
    )

    result = await agent.run("What is the capital of France?")
    print(f"Agent: {result}")

if __name__ == "__main__":
    asyncio.run(main())
```

The output prints the agent's response. Because the agent is ephemeral, no definition is persisted to the service — it exists only for the lifetime of the Python process.

**[csharp]**

Use `AIProjectClient.AsAIAgent(...)` from the Microsoft Agent Framework to wrap the Foundry project endpoint as an `AIAgent`.

```csharp
using Azure.AI.Projects;
using Azure.Identity;
using Microsoft.Agents.AI;

string endpoint = Environment.GetEnvironmentVariable("FOUNDRY_PROJECT_ENDPOINT")
    ?? throw new InvalidOperationException("FOUNDRY_PROJECT_ENDPOINT is not set.");
string deploymentName = Environment.GetEnvironmentVariable("FOUNDRY_MODEL")
    ?? throw new InvalidOperationException("FOUNDRY_MODEL is not set.");

AIAgent agent =
    new AIProjectClient(new Uri(endpoint), new DefaultAzureCredential())
    .AsAIAgent(
        model: deploymentName,
        instructions: "You are a helpful assistant.",
        name: "Assistant");

Console.WriteLine($"Agent: {await agent.RunAsync("What is the capital of France?")}");
```

The output prints the agent's response. Because the agent is ephemeral, no definition is persisted to the service — it exists only for the lifetime of the process.

## Add function tools

Define local function tools and pass them to the agent. The agent automatically calls these tools when needed during a conversation.

**[python]**

Define local function tools using the `@tool` decorator.

```python
import asyncio
import os
from random import randint
from typing import Annotated

from agent_framework import Agent, tool
from agent_framework.foundry import FoundryChatClient
from azure.identity import AzureCliCredential
from pydantic import Field

@tool(approval_mode="never_require")
def get_weather(
    location: Annotated[str, Field(description="The location to get the weather for.")],
) -> str:
    """Get the weather for a given location."""
    conditions = ["sunny", "cloudy", "rainy", "stormy"]
    return f"The weather in {location} is {conditions[randint(0, 3)]} with a high of {randint(10, 30)}°C."

async def main() -> None:
    agent = Agent(
        client=FoundryChatClient(
            project_endpoint=os.environ["FOUNDRY_PROJECT_ENDPOINT"],
            model=os.environ["FOUNDRY_MODEL"],
            credential=AzureCliCredential(),
        ),
        instructions="You are a helpful weather agent.",
        tools=get_weather,
    )

    result = await agent.run("What's the weather like in Seattle?")
    print(f"Agent: {result}")

if __name__ == "__main__":
    asyncio.run(main())
```

The agent uses the Responses API to determine when to call the `get_weather` function, executes it locally, and returns the result in natural language.

**[csharp]**

Define a local method, decorate it with `[Description]` attributes, and wrap it with `AIFunctionFactory.Create(...)`.

```csharp
using System.ComponentModel;
using Azure.AI.Projects;
using Azure.Identity;
using Microsoft.Agents.AI;
using Microsoft.Extensions.AI;

[Description("Get the weather for a given location.")]
static string GetWeather(
    [Description("The location to get the weather for.")] string location)
{
    string[] conditions = ["sunny", "cloudy", "rainy", "stormy"];
    Random rng = Random.Shared;
    return $"The weather in {location} is {conditions[rng.Next(conditions.Length)]} with a high of {rng.Next(10, 31)}°C.";
}

AITool weatherTool = AIFunctionFactory.Create(GetWeather);

string endpoint = Environment.GetEnvironmentVariable("FOUNDRY_PROJECT_ENDPOINT")
    ?? throw new InvalidOperationException("FOUNDRY_PROJECT_ENDPOINT is not set.");
string deploymentName = Environment.GetEnvironmentVariable("FOUNDRY_MODEL")
    ?? throw new InvalidOperationException("FOUNDRY_MODEL is not set.");

AIAgent agent =
    new AIProjectClient(new Uri(endpoint), new DefaultAzureCredential())
    .AsAIAgent(
        model: deploymentName,
        instructions: "You are a helpful weather agent.",
        name: "WeatherAssistant",
        tools: [weatherTool]);

Console.WriteLine($"Agent: {await agent.RunAsync("What's the weather like in Seattle?")}");
```

The agent uses the Responses API to determine when to call `GetWeather`, executes it locally, and returns the result in natural language.

## Use the web search tool

The Responses API on the Foundry project endpoint provides built-in hosted tools like web search. Give your agent access to web search without any local implementation.

**[python]**

Use `FoundryChatClient.get_web_search_tool()`:

```python
import asyncio
import os

from agent_framework import Agent
from agent_framework.foundry import FoundryChatClient
from azure.identity import AzureCliCredential

async def main() -> None:
    agent = Agent(
        client=FoundryChatClient(
            project_endpoint=os.environ["FOUNDRY_PROJECT_ENDPOINT"],
            model=os.environ["FOUNDRY_MODEL"],
            credential=AzureCliCredential(),
        ),
        instructions="You are a research assistant. Use web search to find current information.",
        tools=[
            FoundryChatClient.get_web_search_tool(),
        ],
    )

    result = await agent.run("What are the latest updates to Microsoft Foundry?")
    print(f"Agent: {result}")

if __name__ == "__main__":
    asyncio.run(main())
```

The web search tool executes server-side through the Foundry project Responses API. You can combine it with local function tools to give your agent both web access and custom code capabilities:

```python
agent = Agent(
    client=FoundryChatClient(
        project_endpoint=os.environ["FOUNDRY_PROJECT_ENDPOINT"],
        model=os.environ["FOUNDRY_MODEL"],
        credential=AzureCliCredential(),
    ),
    instructions="You are a helpful assistant with web and weather capabilities.",
    tools=[
        FoundryChatClient.get_web_search_tool(),
        get_weather,  # Local function tool defined with @tool
    ],
)
```

**[csharp]**

Pass `new HostedWebSearchTool()` in the `tools` list:

```csharp
using Azure.AI.Projects;
using Azure.Identity;
using Microsoft.Agents.AI;
using Microsoft.Extensions.AI;

string endpoint = Environment.GetEnvironmentVariable("FOUNDRY_PROJECT_ENDPOINT")
    ?? throw new InvalidOperationException("FOUNDRY_PROJECT_ENDPOINT is not set.");
string deploymentName = Environment.GetEnvironmentVariable("FOUNDRY_MODEL")
    ?? throw new InvalidOperationException("FOUNDRY_MODEL is not set.");

AIAgent agent =
    new AIProjectClient(new Uri(endpoint), new DefaultAzureCredential())
    .AsAIAgent(
        model: deploymentName,
        instructions: "You are a research assistant. Use web search to find current information.",
        name: "ResearchAssistant",
        tools: [new HostedWebSearchTool()]);

Console.WriteLine($"Agent: {await agent.RunAsync("What are the latest updates to Microsoft Foundry?")}");
```

The web search tool executes server-side through the Foundry project Responses API. You can combine it with local function tools to give your agent both web access and custom code capabilities:

```csharp
AIAgent agent =
    new AIProjectClient(new Uri(endpoint), new DefaultAzureCredential())
    .AsAIAgent(
        model: deploymentName,
        instructions: "You are a helpful assistant with web and weather capabilities.",
        name: "Assistant",
        tools: [new HostedWebSearchTool(), weatherTool]);
```

## Stream responses

Receive responses as they generate instead of waiting for the full message.

**[python]**

Use the `stream=True` parameter:

```python
import asyncio
import os

from agent_framework import Agent
from agent_framework.foundry import FoundryChatClient
from azure.identity import AzureCliCredential

async def main() -> None:
    agent = Agent(
        client=FoundryChatClient(
            project_endpoint=os.environ["FOUNDRY_PROJECT_ENDPOINT"],
            model=os.environ["FOUNDRY_MODEL"],
            credential=AzureCliCredential(),
        ),
        instructions="You are a helpful assistant.",
    )

    print("Agent: ", end="", flush=True)
    async for chunk in agent.run("Tell me a fun fact.", stream=True):
        if chunk.text:
            print(chunk.text, end="", flush=True)
    print()

if __name__ == "__main__":
    asyncio.run(main())
```

**[csharp]**

Call `RunStreamingAsync` and iterate the `AgentResponseUpdate` stream:

```csharp
using Azure.AI.Projects;
using Azure.Identity;
using Microsoft.Agents.AI;

string endpoint = Environment.GetEnvironmentVariable("FOUNDRY_PROJECT_ENDPOINT")
    ?? throw new InvalidOperationException("FOUNDRY_PROJECT_ENDPOINT is not set.");
string deploymentName = Environment.GetEnvironmentVariable("FOUNDRY_MODEL")
    ?? throw new InvalidOperationException("FOUNDRY_MODEL is not set.");

AIAgent agent =
    new AIProjectClient(new Uri(endpoint), new DefaultAzureCredential())
    .AsAIAgent(
        model: deploymentName,
        instructions: "You are a helpful assistant.",
        name: "Assistant");

Console.Write("Agent: ");
await foreach (AgentResponseUpdate update in agent.RunStreamingAsync("Tell me a fun fact."))
{
    Console.Write(update);
}
Console.WriteLine();
```

Streaming output appears incrementally in the console as the model generates each token.

## Observability and enterprise capabilities

Ephemeral doesn't mean unmanaged. Because calls go through the project endpoint, they inherit the project's enterprise configuration without extra wiring:

- **Tracing and monitoring**: Requests, tool invocations, and token usage flow into Foundry observability for the project.
- **Content filters and governance**: Project-level content filters and responsible AI policies apply to every call.
- **Identity and access**: Calls authenticate against the project's identity configuration; OBO-enabled tools can act as the signed-in user.

The ephemeral pattern isn't a reduced-capability tier — you get the same Foundry models, tools, observability, and governance whether you run the agent in-process or [package the same code as a hosted agent](../07.3-hosted-agents/07-quickstart-hosted-agent.md). The choice is about the deployment shape, not the feature set.

## Use the OpenAI SDK directly

Because the Foundry project Responses API is OpenAI-compatible, you can also call it directly from the OpenAI SDK by pointing the client at the project endpoint (`{project_endpoint}/openai/v1/responses`). Use this path only if you already have OpenAI SDK code or need lower-level control over the request and response shapes. New code should prefer the Agent Framework, which handles authentication, tool wiring, and orchestration for you.

For SDK samples, see:

**[python]**

[Foundry Responses samples (azure-ai-projects)](https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/ai/azure-ai-projects/samples/responses)

**[csharp]**

[Azure.AI.OpenAI samples](https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/openai/Azure.AI.OpenAI/tests/Samples)

## Clean up resources

Because Agent Framework agents created here are ephemeral, no service-side cleanup is needed. The agent exists only in your local process. If you created Foundry resources you no longer need, delete them in the [Foundry portal](https://ai.azure.com/).

## Related content

**Go deeper on this pattern**

- [Agent Framework on GitHub](https://github.com/microsoft/agent-framework)

**[python]**

- [Foundry provider samples (Python)](https://github.com/microsoft/agent-framework/tree/main/python/samples/02-agents/providers/foundry)
- [Foundry project Responses API samples (OpenAI SDK)](https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/ai/azure-ai-projects/samples/responses)

**[csharp]**

- [Agents with Foundry samples (.NET)](https://github.com/microsoft/agent-framework/tree/main/dotnet/samples/02-agents/AgentProviders/foundry)

**Package the same agent code as a hosted agent**

- [Quickstart: Deploy your first hosted agent](../07.3-hosted-agents/07-quickstart-hosted-agent.md)
- [Quickstart: Create a prompt agent](../../04-get-started/04.1-what-do-you-want-to-build/01-prompt-agent.md)
- [What is Foundry Agent Service?](../01-overview.md)
