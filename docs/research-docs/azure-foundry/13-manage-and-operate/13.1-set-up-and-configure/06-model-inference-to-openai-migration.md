# Migrate from Azure AI Inference SDK to OpenAI SDK

| Field | Value |
| --- | --- |
| **Document Title** | Migrate from Azure AI Inference SDK to OpenAI SDK |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.1-set-up-and-configure/06-model-inference-to-openai-migration.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Migrate from Azure AI Inference SDK to OpenAI SDK". Migrate your app from the Azure AI Inference SDK to the OpenAI SDK for better compatibility and unified API access to Foundry Models. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/model-inference-to-openai-migration). Article date: 2026-06-04. Page updated: 2026-06-11. Retrieved: 2026-09-29. Navigation: Manage and operate > Set up and configure > Manage Foundry resources > Migrate from Azure AI Inference SDK to OpenAI SDK.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

This article provides guidance on migrating your applications from the now-retired Azure AI Inference SDK to the OpenAI SDK. The OpenAI SDK offers broader compatibility, access to the latest OpenAI features, and simplified code with unified patterns across Azure OpenAI and Foundry Models.

> **Note**
>
> The OpenAI SDK refers to the client libraries (such as the Python `openai` package or JavaScript `openai` npm package) that connect to [OpenAI v1 API endpoints](../../05-developer-tools-and-integrations/05.4-sdks-and-apis/04-api-version-lifecycle.md#api-evolution). These SDKs have their own versioning separate from the API version - for example, the Go OpenAI SDK is currently at v3, but it still connects to the OpenAI v1 API endpoints with `/openai/v1/` in the URL path.

## Benefits of migrating

Migrating to the OpenAI SDK provides several advantages:

- **Broader model support**: Works with Azure OpenAI in Foundry Models and other Foundry Models from providers like DeepSeek and Grok
- **Unified API**: Uses the same SDK libraries and clients for both OpenAI and Azure OpenAI endpoints
- **Latest features**: Access to the newest OpenAI features without waiting for Azure-specific updates
- **Simplified authentication**: Built-in support for both API key and Microsoft Entra ID authentication
- **Implicit API versioning**: The v1 API eliminates the need to frequently update `api-version` parameters

## Key differences

The following table shows the main differences between the two SDKs:

| Aspect | Azure AI Inference SDK | OpenAI SDK |
| --- | --- | --- |
| Client class | `ChatCompletionsClient` | `OpenAI` |
| Endpoint format | `https://<resource>.services.ai.azure.com/models` | `https://<resource>.openai.azure.com/openai/v1/` |
| API version | Required in URL or parameter | Not required (uses v1 API) |
| Model parameter | Optional (for multi-model endpoints) | Required (deployment name) |
| Authentication | Azure credentials only | API key or Azure credentials |

**[programming-language-python]**

## Setup

Install the OpenAI SDK:

```bash
pip install openai
```

For Microsoft Entra ID authentication, also install:

```bash
pip install azure-identity
```

## Client configuration

**[OpenAI SDK]**

With API key authentication:

```python
import os
from openai import OpenAI

client = OpenAI(
    api_key=os.getenv("AZURE_OPENAI_API_KEY"),
    base_url="https://<resource>.openai.azure.com/openai/v1/",
)
```

**[Azure AI Inference SDK]**

```python
import os
from azure.ai.inference import ChatCompletionsClient
from azure.core.credentials import AzureKeyCredential

client = ChatCompletionsClient(
    endpoint="https://<resource>.services.ai.azure.com/models",
    credential=AzureKeyCredential(os.environ["AZURE_INFERENCE_CREDENTIAL"]),
)
```

With Microsoft Entra ID authentication:

**[OpenAI SDK]**

```python
from openai import OpenAI
from azure.identity import DefaultAzureCredential, get_bearer_token_provider

token_provider = get_bearer_token_provider(
    DefaultAzureCredential(), 
    "https://ai.azure.com/.default"
)

client = OpenAI(
    base_url="https://<resource>.openai.azure.com/openai/v1/",
    api_key=token_provider,
)
```

**[Azure AI Inference SDK]**

```python
from azure.ai.inference import ChatCompletionsClient
from azure.identity import DefaultAzureCredential

client = ChatCompletionsClient(
    endpoint="https://<resource>.services.ai.azure.com/models",
    credential=DefaultAzureCredential(),
    credential_scopes=["https://cognitiveservices.azure.com/.default"],
)
```

## Chat completions

**[OpenAI SDK]**

```python
response = client.chat.completions.create(
    model="DeepSeek-V3.1",  # Required: your deployment name
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "How many languages are in the world?"}
    ]
)

print(response.choices[0].message.content)
```

**Output is as follows:**

```console
Response: As of now, it's estimated that there are about 7,000 languages spoken around the world. However, this number can vary as some languages become extinct and new ones develop. It's also important to note that the number of speakers can greatly vary between languages, with some having millions of speakers and others only a few hundred.
```

**[Azure AI Inference SDK]**

```python
from azure.ai.inference.models import SystemMessage, UserMessage

response = client.complete(
    messages=[
        SystemMessage(content="You are a helpful assistant."),
        UserMessage(content="How many languages are in the world?"),
    ],
    model="DeepSeek-V3.1"  # Optional for single-model endpoints
)

print(response.choices[0].message.content)
```

**Output is as follows:**

```console
Response: <think>Okay, the user is asking how many languages exist in the world. I need to provide a clear and accurate answer...</think>As of now, it's estimated that there are about 7,000 languages spoken around the world. However, this number can vary as some languages become extinct and new ones develop. It's also important to note that the number of speakers can greatly vary between languages, with some having millions of speakers and others only a few hundred.
```

### Streaming

**[OpenAI SDK]**

```python
stream = client.chat.completions.create(
    model="DeepSeek-V3.1",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Write a poem about Azure."}
    ],
    stream=True
)

for chunk in stream:
    if chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="")
```

**[Azure AI Inference SDK]**

```python
from azure.ai.inference.models import SystemMessage, UserMessage

response = client.complete(
    stream=True,
    messages=[
        SystemMessage(content="You are a helpful assistant."),
        UserMessage(content="Write a poem about Azure."),
    ],
    model="DeepSeek-V3.1"
)

for update in response:
    if update.choices:
        print(update.choices[0].delta.content or "", end="")
```

## Responses

The Responses API is OpenAI's stateful interface that returns a structured `output` array containing message, tool call, and reasoning items.

**[OpenAI SDK]**

```python
response = client.responses.create(
    model="DeepSeek-V3.1",  # Required: your deployment name
    input="How many languages are in the world?",
    max_output_tokens=2000,
)

print(response.output_text)
```

**[Azure AI Inference SDK]**

The Azure AI Inference SDK doesn't expose the Responses API. To call it, use the OpenAI SDK.

### Reasoning

> **Note**
>
> This information on reasoning content doesn't apply to Azure OpenAI models. Azure OpenAI reasoning models use the [reasoning summaries feature](../../06-models/06.6-develop-with-ai-models/16-reasoning.md#reasoning-summary).

Some reasoning models, like DeepSeek-R1, generate completions and include the reasoning behind them. The Responses API surfaces this as a structured `reasoning` output item whose `summary[].text` contains the model's thinking, alongside the final answer.

**[OpenAI SDK]**

```python
response = client.responses.create(
    model="DeepSeek-R1-0528",  # Required: your deployment name
    input="How many languages are in the world?",
    max_output_tokens=2000,
)

# Walk response.output for items of type "reasoning" and join summary[].text.
parts = []
for item in getattr(response, "output", None) or []:
    if getattr(item, "type", None) != "reasoning":
        continue
    for s in getattr(item, "summary", None) or []:
        text = getattr(s, "text", None)
        if text:
            parts.append(text)
reasoning_summary = "\n".join(parts).strip()

print("Thinking:", reasoning_summary)
print("Answer:", response.output_text)
```

**Output is as follows:**

```console
Thinking: Okay, the user is asking how many languages exist in the world. I need to provide a clear and accurate answer...
Answer: There are approximately 7,000 languages spoken around the world today.
```

> **Note**
>
> **Known issue:** For Foundry Models (non-Azure OpenAI models), such as DeepSeek-R1-0528, the reasoning summary text on each `reasoning` output item is populated reliably, but the reasoning token count in the response usage details (`reasoning_tokens` on the wire) currently reports `0` even when summary text is present. Don't rely on the reasoning token count for billing or quota accounting when using Foundry models. This caveat *doesn't apply to Azure OpenAI in Foundry Models*.

**[Azure AI Inference SDK]**

The Azure AI Inference SDK doesn't expose the Responses API. To get reasoning content, call the chat completions API instead. The reasoning is included in the message content wrapped in `<think>` and `</think>` tags, which you can extract with a regex match.

```python
import re
from azure.ai.inference.models import SystemMessage, UserMessage

response = client.complete(
    messages=[
        SystemMessage(content="You are a helpful assistant."),
        UserMessage(content="How many languages are in the world?"),
    ],
    model="DeepSeek-R1-0528"  # Optional for single-model endpoints
)

content = response.choices[0].message.content
match = re.match(r"<think>(.*?)</think>(.*)", content, re.DOTALL)
if match:
    print("Thinking:", match.group(1).strip())
    print("Answer: ", match.group(2).strip())
else:
    print("Response:", content)
```

**Output is as follows:**

```console
Thinking: Okay, the user is asking how many languages exist in the world. I need to provide a clear and accurate answer...
Answer:  There are approximately 7,000 languages spoken around the world today.
```

When you make multi-turn conversations, avoid sending the reasoning content in the chat history because reasoning tends to generate long explanations.

## Embeddings

**[OpenAI SDK]**

```python
from openai import OpenAI
from azure.identity import DefaultAzureCredential, get_bearer_token_provider

token_provider = get_bearer_token_provider(DefaultAzureCredential(), 
"https://ai.azure.com/.default")

client = OpenAI(
    base_url = "https://YOUR-RESOURCE-NAME.openai.azure.com/openai/v1/",
    api_key = token_provider,
)

response = client.embeddings.create(
    input = "How do I use Python in VS Code?",
    model = "text-embedding-3-large" // Use the name of your deployment
)
print(response.data[0].embedding)
```

**[Azure AI Inference SDK]**

```python
from azure.ai.inference import EmbeddingsClient
from azure.core.credentials import AzureKeyCredential

client = EmbeddingsClient(
    endpoint="https://<resource>.services.ai.azure.com/models",
    credential=AzureKeyCredential(os.environ["AZURE_INFERENCE_CREDENTIAL"]),
)

response = client.embed(
    input=["Your text string goes here"],
    model="text-embedding-3-small"
)

embedding = response.data[0].embedding
```

**[programming-language-dotnet]**

## Setup

Install the OpenAI SDK:

```dotnetcli
dotnet add package OpenAI
```

For Microsoft Entra ID authentication, also install:

```dotnetcli
dotnet add package Azure.Identity
```

## Client configuration

With API key authentication:

**[OpenAI SDK]**

```csharp
using OpenAI;
using OpenAI.Chat;
using System.ClientModel;

ChatClient client = new(
    model: "gpt-4o-mini", // Your deployment name
    credential: new ApiKeyCredential(Environment.GetEnvironmentVariable("AZURE_OPENAI_API_KEY")),
    options: new OpenAIClientOptions() { 
        Endpoint = new Uri("https://<resource>.openai.azure.com/openai/v1/")
    }
);
```

**[Azure AI Inference SDK]**

```csharp
using Azure;
using Azure.AI.Inference;

ChatCompletionsClient client = new ChatCompletionsClient(
    new Uri("https://<resource>.services.ai.azure.com/models"),
    new AzureKeyCredential(Environment.GetEnvironmentVariable("AZURE_INFERENCE_CREDENTIAL"))
);
```

With Microsoft Entra ID authentication:

**[OpenAI SDK]**

```csharp
using Azure.Identity;
using OpenAI;
using OpenAI.Chat;
using System.ClientModel.Primitives;

#pragma warning disable OPENAI001

BearerTokenPolicy tokenPolicy = new(
    new DefaultAzureCredential(),
    "https://ai.azure.com/.default"
);

ChatClient client = new(
    model: "gpt-4o-mini", // Your deployment name
    authenticationPolicy: tokenPolicy,
    options: new OpenAIClientOptions() {
        Endpoint = new Uri("https://<resource>.openai.azure.com/openai/v1/")
    }
);
```

**[Azure AI Inference SDK]**

```csharp
using Azure;
using Azure.Identity;
using Azure.AI.Inference;

ChatCompletionsClient client = new ChatCompletionsClient(
    new Uri("https://<resource>.services.ai.azure.com/models"),
    new DefaultAzureCredential()
);
```

## Chat completions

**[OpenAI SDK]**

```csharp
using OpenAI.Chat;

ChatCompletion completion = client.CompleteChat(
    new SystemChatMessage("You are a helpful assistant."),
    new UserChatMessage("What is Azure AI?")
);

Console.WriteLine(completion.Content[0].Text);
```

**[Azure AI Inference SDK]**

```csharp
using Azure.AI.Inference;

ChatCompletionsOptions requestOptions = new ChatCompletionsOptions()
{
    Messages = {
        new ChatRequestSystemMessage("You are a helpful assistant."),
        new ChatRequestUserMessage("How many languages are in the world?")
    },
    Model = "DeepSeek-V3.1", // Optional for single-model endpoints
};

Response<ChatCompletions> response = client.Complete(requestOptions);
Console.WriteLine(response.Value.Choices[0].Message.Content);
```

### Streaming

**[OpenAI SDK]**

```csharp
using OpenAI.Chat;

CollectionResult<StreamingChatCompletionUpdate> updates = client.CompleteChatStreaming(
    new SystemChatMessage("You are a helpful assistant."),
    new UserChatMessage("Write a poem about Azure.")
);

foreach (StreamingChatCompletionUpdate update in updates)
{
    foreach (ChatMessageContentPart part in update.ContentUpdate)
    {
        Console.Write(part.Text);
    }
}
```

**[Azure AI Inference SDK]**

```csharp
using Azure.AI.Inference;

ChatCompletionsOptions requestOptions = new ChatCompletionsOptions()
{
    Messages = {
        new ChatRequestSystemMessage("You are a helpful assistant."),
        new ChatRequestUserMessage("Write a poem about Azure.")
    },
    Model = "gpt-4o-mini",
};

StreamingResponse<StreamingChatCompletionsUpdate> response = client.CompleteStreaming(requestOptions);

await foreach (StreamingChatCompletionsUpdate update in response)
{
    if (update.ContentUpdate != null)
    {
        Console.Write(update.ContentUpdate);
    }
}
```

## Responses

The Responses API is OpenAI's stateful interface that returns a structured `output` array containing message, tool call, and reasoning items.

**[OpenAI SDK]**

```csharp
using OpenAI.Responses;

var responseClient = client.GetResponsesClient("DeepSeek-V3.1");
var result = await responseClient.CreateResponseAsync(new CreateResponseOptions(
    [ResponseItem.CreateUserMessageItem("How many languages are in the world?")])
    { MaxOutputTokenCount = 2000 }
);

Console.WriteLine(result.Value.GetOutputText());
```

**[Azure AI Inference SDK]**

The Azure AI Inference SDK doesn't expose the Responses API. To call it, use the OpenAI SDK.

### Reasoning

> **Note**
>
> This information on reasoning content doesn't apply to Azure OpenAI models. Azure OpenAI reasoning models use the [reasoning summaries feature](../../06-models/06.6-develop-with-ai-models/16-reasoning.md#reasoning-summary).

Some reasoning models, like DeepSeek-R1, generate completions and include the reasoning behind them. The Responses API surfaces this as a structured `reasoning` output item whose `summary[].text` contains the model's thinking, alongside the final answer.

**[OpenAI SDK]**

```csharp
using System.Text;
using OpenAI.Responses;

var responseClient = client.GetResponsesClient("DeepSeek-R1-0528");
var result = await responseClient.CreateResponseAsync(new CreateResponseOptions(
    [ResponseItem.CreateUserMessageItem("How many languages are in the world?")])
    { MaxOutputTokenCount = 2000 }
);

// Walk OutputItems for ReasoningResponseItem entries and join SummaryParts text.
var sb = new StringBuilder();
foreach (var item in result.Value.OutputItems)
{
    if (item is not ReasoningResponseItem reasoning) continue;
    foreach (var part in reasoning.SummaryParts)
    {
        if (part is ReasoningSummaryTextPart textPart && !string.IsNullOrEmpty(textPart.Text))
        {
            if (sb.Length > 0) sb.Append('\n');
            sb.Append(textPart.Text);
        }
    }
}

Console.WriteLine($"Thinking: {sb.ToString().Trim()}");
Console.WriteLine($"Answer:   {result.Value.GetOutputText()}");
```

**Output is as follows:**

```console
Thinking: Okay, the user is asking how many languages exist in the world. I need to provide a clear and accurate answer...
Answer:   There are approximately 7,000 languages spoken around the world today.
```

> **Note**
>
> **Known issue:** For Foundry Models (non-Azure OpenAI models), such as DeepSeek-R1-0528, the reasoning summary text on each `reasoning` output item is populated reliably, but the reasoning token count in the response usage details (`reasoning_tokens` on the wire) currently reports `0` even when summary text is present. Don't rely on the reasoning token count for billing or quota accounting when using Foundry models. This caveat *doesn't apply to Azure OpenAI in Foundry Models*.

**[Azure AI Inference SDK]**

The Azure AI Inference SDK doesn't expose the Responses API. To get reasoning content, call the chat completions API instead. The reasoning is included in the message content wrapped in `<think>` and `</think>` tags, which you can extract with a regex match.

```csharp
using Azure.AI.Inference;
using System.Text.RegularExpressions;

ChatCompletionsOptions requestOptions = new ChatCompletionsOptions()
{
    Messages = {
        new ChatRequestSystemMessage("You are a helpful assistant."),
        new ChatRequestUserMessage("How many languages are in the world?")
    },
    Model = "DeepSeek-R1-0528", // Optional for single-model endpoints
};

Response<ChatCompletions> response = client.Complete(requestOptions);
string content = response.Value.Choices[0].Message.Content;

Regex regex = new Regex(@"<think>(.*?)</think>(.*)", RegexOptions.Singleline);
Match match = regex.Match(content);

if (match.Success)
{
    Console.WriteLine($"Thinking: {match.Groups[1].Value.Trim()}");
    Console.WriteLine($"Answer:   {match.Groups[2].Value.Trim()}");
}
else
{
    Console.WriteLine($"Response: {content}");
}
```

**Output is as follows:**

```console
Thinking: Okay, the user is asking how many languages exist in the world. I need to provide a clear and accurate answer...
Answer:   There are approximately 7,000 languages spoken around the world today.
```

When you make multi-turn conversations, avoid sending the reasoning content in the chat history because reasoning tends to generate long explanations.

## Embeddings

**[OpenAI SDK]**

```csharp
using OpenAI;
using OpenAI.Embeddings;
using System.ClientModel;

EmbeddingClient client = new(
    "text-embedding-3-small",
    credential: new ApiKeyCredential("API-KEY"),
    options: new OpenAIClientOptions()
    {

        Endpoint = new Uri("https://YOUR-RESOURCE-NAME.openai.azure.com/openai/v1")
    }
);

string input = "This is a test";

OpenAIEmbedding embedding = client.GenerateEmbedding(input);
ReadOnlyMemory<float> vector = embedding.ToFloats();
Console.WriteLine($"Embeddings: [{string.Join(", ", vector.ToArray())}]");
```

**[Azure AI Inference SDK]**

```csharp
using Azure;
using Azure.AI.Inference;

EmbeddingsClient client = new EmbeddingsClient(
    new Uri("https://<resource>.services.ai.azure.com/models"),
    new AzureKeyCredential(Environment.GetEnvironmentVariable("AZURE_INFERENCE_CREDENTIAL"))
);

EmbeddingsOptions embeddingsOptions = new EmbeddingsOptions()
{
    Input = { "Your text string goes here" },
    Model = "text-embedding-3-small"
};

Response<EmbeddingsResult> response = client.Embed(embeddingsOptions);
ReadOnlyMemory<float> embedding = response.Value.Data[0].Embedding;
```

**[programming-language-javascript]**

## Setup

Install the OpenAI SDK:

```bash
npm install openai
```

For Microsoft Entra ID authentication, also install:

```bash
npm install @azure/identity
```

## Client configuration

With API key authentication:

**[OpenAI SDK]**

```javascript
import { OpenAI } from "openai";

const client = new OpenAI({
    baseURL: "https://<resource>.openai.azure.com/openai/v1/",
    apiKey: process.env.AZURE_OPENAI_API_KEY
});
```

**[Azure AI Inference SDK]**

```javascript
import ModelClient from "@azure-rest/ai-inference";
import { AzureKeyCredential } from "@azure/core-auth";

const client = ModelClient(
    "https://<resource>.services.ai.azure.com/models", 
    new AzureKeyCredential(process.env.AZURE_INFERENCE_CREDENTIAL)
);
```

With Microsoft Entra ID authentication:

**[OpenAI SDK]**

```javascript
import { DefaultAzureCredential, getBearerTokenProvider } from "@azure/identity";
import { OpenAI } from "openai";

const tokenProvider = getBearerTokenProvider(
    new DefaultAzureCredential(),
    'https://ai.azure.com/.default'
);

const client = new OpenAI({
    baseURL: "https://<resource>.openai.azure.com/openai/v1/",
    apiKey: tokenProvider
});
```

**[Azure AI Inference SDK]**

```javascript
import ModelClient from "@azure-rest/ai-inference";
import { DefaultAzureCredential } from "@azure/identity";

const clientOptions = { 
    credentials: { 
        scopes: ["https://cognitiveservices.azure.com/.default"] 
    } 
};

const client = ModelClient(
    "https://<resource>.services.ai.azure.com/models", 
    new DefaultAzureCredential(),
    clientOptions
);
```

## Chat completions

**[OpenAI SDK]**

```javascript
const completion = await client.chat.completions.create({
    model: "DeepSeek-V3.1", // Required: your deployment name
    messages: [
        { role: "system", content: "You are a helpful assistant." },
        { role: "user", content: "How many languages are in the world?" }
    ]
});

console.log(completion.choices[0].message.content);
```

**[Azure AI Inference SDK]**

```javascript
const response = await client.path("/chat/completions").post({
    body: {
        messages: [
            { role: "system", content: "You are a helpful assistant." },
            { role: "user", content: "How many languages are in the world?" }
        ],
        model: "DeepSeek-V3.1" // Optional for single-model endpoints
    }
});

console.log(response.body.choices[0].message.content);
```

### Streaming

**[OpenAI SDK]**

```javascript
const stream = await client.chat.completions.create({
    model: "DeepSeek-V3.1",
    messages: [
        { role: "system", content: "You are a helpful assistant." },
        { role: "user", content: "Write a poem about Azure." }
    ],
    stream: true
});

for await (const chunk of stream) {
    if (chunk.choices[0]?.delta?.content) {
        process.stdout.write(chunk.choices[0].delta.content);
    }
}
```

**[Azure AI Inference SDK]**

```javascript
const response = await client.path("/chat/completions").post({
    body: {
        messages: [
            { role: "system", content: "You are a helpful assistant." },
            { role: "user", content: "Write a poem about Azure." }
        ],
        model: "DeepSeek-V3.1",
        stream: true
    }
}).asNodeStream();

for await (const chunk of response) {
    if (chunk.choices && chunk.choices[0]?.delta?.content) {
        process.stdout.write(chunk.choices[0].delta.content);
    }
}
```

## Responses

The Responses API is OpenAI's stateful interface that returns a structured `output` array containing message, tool call, and reasoning items.

**[OpenAI SDK]**

```javascript
const response = await client.responses.create({
    model: "DeepSeek-V3.1", // Required: your deployment name
    input: "How many languages are in the world?",
    max_output_tokens: 2000,
});

console.log(response.output_text);
```

**[Azure AI Inference SDK]**

The Azure AI Inference SDK doesn't expose the Responses API. To call it, use the OpenAI SDK.

### Reasoning

> **Note**
>
> This information on reasoning content doesn't apply to Azure OpenAI models. Azure OpenAI reasoning models use the [reasoning summaries feature](../../06-models/06.6-develop-with-ai-models/16-reasoning.md#reasoning-summary).

Some reasoning models, like DeepSeek-R1, generate completions and include the reasoning behind them. The Responses API surfaces this as a structured `reasoning` output item whose `summary[].text` contains the model's thinking, alongside the final answer.

**[OpenAI SDK]**

```javascript
const response = await client.responses.create({
    model: "DeepSeek-R1-0528", // Required: your deployment name
    input: "How many languages are in the world?",
    max_output_tokens: 2000,
});

// Walk response.output for items of type "reasoning" and join summary[].text.
const parts = [];
for (const item of response?.output ?? []) {
    if (item?.type !== "reasoning") continue;
    for (const s of item?.summary ?? []) {
        if (s?.text) parts.push(s.text);
    }
}
const reasoningSummary = parts.join("\n").trim();

console.log("Thinking:", reasoningSummary);
console.log("Answer:  ", response.output_text);
```

**Output is as follows:**

```console
Thinking: Okay, the user is asking how many languages exist in the world. I need to provide a clear and accurate answer...
Answer:   There are approximately 7,000 languages spoken around the world today.
```

> **Note**
>
> **Known issue:** For Foundry Models (non-Azure OpenAI models), such as DeepSeek-R1-0528, the reasoning summary text on each `reasoning` output item is populated reliably, but the reasoning token count in the response usage details (`reasoning_tokens` on the wire) currently reports `0` even when summary text is present. Don't rely on the reasoning token count for billing or quota accounting when using Foundry models. This caveat *doesn't apply to Azure OpenAI in Foundry Models*.

**[Azure AI Inference SDK]**

The Azure AI Inference SDK doesn't expose the Responses API. To get reasoning content, call the chat completions API instead. The reasoning is included in the message content wrapped in `<think>` and `</think>` tags, which you can extract with a regex match.

```javascript
const response = await client.path("/chat/completions").post({
    body: {
        messages: [
            { role: "system", content: "You are a helpful assistant." },
            { role: "user", content: "How many languages are in the world?" }
        ],
        model: "DeepSeek-R1-0528" // Optional for single-model endpoints
    }
});

const content = response.body.choices[0].message.content;
const match = content.match(/<think>(.*?)<\/think>(.*)/s);

if (match) {
    console.log("Thinking:", match[1].trim());
    console.log("Answer:  ", match[2].trim());
} else {
    console.log("Response:", content);
}
```

**Output is as follows:**

```console
Thinking: Okay, the user is asking how many languages exist in the world. I need to provide a clear and accurate answer...
Answer:   There are approximately 7,000 languages spoken around the world today.
```

When you make multi-turn conversations, avoid sending the reasoning content in the chat history because reasoning tends to generate long explanations.

## Embeddings

**[OpenAI SDK]**

```javascript
import OpenAI from "openai";
import { getBearerTokenProvider, DefaultAzureCredential } from "@azure/identity";

const tokenProvider = getBearerTokenProvider(
    new DefaultAzureCredential(),
    'https://ai.azure.com/.default');
const client = new OpenAI({
    baseURL: "https://<resource>.openai.azure.com/openai/v1/",
    apiKey: tokenProvider
});

const embedding = await client.embeddings.create({
  model: "text-embedding-3-large", // Required: your deployment name
  input: "The quick brown fox jumped over the lazy dog",
  encoding_format: "float",
});

console.log(embedding);
```

**[Azure AI Inference SDK]**

```javascript
import ModelClient from "@azure-rest/ai-inference";
import { AzureKeyCredential } from "@azure/core-auth";

const client = ModelClient(
    "https://<resource>.services.ai.azure.com/models",
    new AzureKeyCredential(process.env.AZURE_INFERENCE_CREDENTIAL)
);

const response = await client.path("/embeddings").post({
    body: {
        input: ["Your text string goes here"],
        model: "text-embedding-3-small"
    }
});

const embedding = response.body.data[0].embedding;
```

**[programming-language-java]**

## Setup

Add the OpenAI SDK to your project. Check the [OpenAI Java GitHub repository](https://github.com/openai/openai-java) for the latest version and installation instructions.

For Microsoft Entra ID authentication, also add:

```xml
<dependency>
    <groupId>com.azure</groupId>
    <artifactId>azure-identity</artifactId>
    <version>1.18.0</version>
</dependency>
```

## Client configuration

With API key authentication:

**[OpenAI SDK]**

```java
import com.openai.client.OpenAIClient;
import com.openai.client.okhttp.OpenAIOkHttpClient;

OpenAIClient client = OpenAIOkHttpClient.builder()
    .baseUrl("https://<resource>.openai.azure.com/openai/v1/")
    .apiKey(System.getenv("AZURE_OPENAI_API_KEY"))
    .build();
```

**[Azure AI Inference SDK]**

```java
import com.azure.ai.inference.ChatCompletionsClient;
import com.azure.ai.inference.ChatCompletionsClientBuilder;
import com.azure.core.credential.AzureKeyCredential;

ChatCompletionsClient client = new ChatCompletionsClientBuilder()
    .credential(new AzureKeyCredential(System.getenv("AZURE_INFERENCE_CREDENTIAL")))
    .endpoint("https://<resource>.services.ai.azure.com/models")
    .buildClient();
```

With Microsoft Entra ID authentication:

**[OpenAI SDK]**

```java
import com.openai.client.OpenAIClient;
import com.openai.client.okhttp.OpenAIOkHttpClient;
import com.azure.identity.DefaultAzureCredential;
import com.azure.identity.DefaultAzureCredentialBuilder;

DefaultAzureCredential tokenCredential = new DefaultAzureCredentialBuilder().build();

OpenAIClient client = OpenAIOkHttpClient.builder()
    .baseUrl("https://<resource>.openai.azure.com/openai/v1/")
    .credential(BearerTokenCredential.create(
        AuthenticationUtil.getBearerTokenSupplier(
            tokenCredential, 
            "https://ai.azure.com/.default"
        )
    ))
    .build();
```

**[Azure AI Inference SDK]**

```java
import com.azure.ai.inference.ChatCompletionsClient;
import com.azure.ai.inference.ChatCompletionsClientBuilder;
import com.azure.identity.DefaultAzureCredential;
import com.azure.identity.DefaultAzureCredentialBuilder;
import com.azure.core.credential.TokenCredential;

TokenCredential credential = new DefaultAzureCredentialBuilder().build();
ChatCompletionsClient client = new ChatCompletionsClientBuilder()
    .credential(credential)
    .endpoint("https://<resource>.services.ai.azure.com/models")
    .buildClient();
```

## Chat completions

**[OpenAI SDK]**

```java
import com.openai.models.chat.completions.*;

ChatCompletionCreateParams params = ChatCompletionCreateParams.builder()
    .addSystemMessage("You are a helpful assistant.")
    .addUserMessage("How many languages are in the world?")
    .model("DeepSeek-V3.1") // Required: your deployment name
    .build();

ChatCompletion completion = client.chat().completions().create(params);
System.out.println(completion.choices().get(0).message().content());
```

**[Azure AI Inference SDK]**

```java
import com.azure.ai.inference.models.*;
import java.util.List;

List<ChatRequestMessage> messages = List.of(
    new ChatRequestSystemMessage("You are a helpful assistant."),
    new ChatRequestUserMessage("How many languages are in the world?")
);

ChatCompletionsOptions options = new ChatCompletionsOptions(messages);
options.setModel("DeepSeek-V3.1"); // Optional for single-model endpoints

ChatCompletions response = client.complete(options);
System.out.println(response.getChoices().get(0).getMessage().getContent());
```

### Streaming

**[OpenAI SDK]**

```java
import com.openai.models.chat.completions.*;
import java.util.stream.Stream;

ChatCompletionCreateParams params = ChatCompletionCreateParams.builder()
    .addSystemMessage("You are a helpful assistant.")
    .addUserMessage("Write a poem about Azure.")
    .model("DeepSeek-V3.1") // Required: your deployment name
    .build();

Stream<ChatCompletionChunk> stream = client.chat().completions().createStreaming(params);

stream.forEach(chunk -> {
    if (chunk.choices() != null && !chunk.choices().isEmpty()) {
        String content = chunk.choices().get(0).delta().content();
        if (content != null) {
            System.out.print(content);
        }
    }
});
```

**[Azure AI Inference SDK]**

```java
import com.azure.ai.inference.models.*;

List<ChatRequestMessage> messages = List.of(
    new ChatRequestSystemMessage("You are a helpful assistant."),
    new ChatRequestUserMessage("Write a poem about Azure.")
);

ChatCompletionsOptions options = new ChatCompletionsOptions(messages);
options.setModel("DeepSeek-V3.1");

IterableStream<ChatCompletions> response = client.completeStream(options);

response.forEach(update -> {
    if (update.getChoices() != null && !update.getChoices().isEmpty()) {
        String content = update.getChoices().get(0).getDelta().getContent();
        if (content != null) {
            System.out.print(content);
        }
    }
});
```

## Responses

The Responses API is OpenAI's stateful interface that returns a structured `output` array containing message, tool call, and reasoning items.

**[OpenAI SDK]**

```java
import com.openai.models.responses.Response;
import com.openai.models.responses.ResponseCreateParams;

Response response = client.responses().create(
    ResponseCreateParams.builder()
        .model("DeepSeek-V3.1") // Required: your deployment name
        .input("How many languages are in the world?")
        .maxOutputTokens(2000)
        .build()
);

System.out.println(response.outputText());
```

**[Azure AI Inference SDK]**

The Azure AI Inference SDK doesn't expose the Responses API. To call it, use the OpenAI SDK.

### Reasoning

> **Note**
>
> This information on reasoning content doesn't apply to Azure OpenAI models. Azure OpenAI reasoning models use the [reasoning summaries feature](../../06-models/06.6-develop-with-ai-models/16-reasoning.md#reasoning-summary).

Some reasoning models, like DeepSeek-R1, generate completions and include the reasoning behind them. The Responses API surfaces this as a structured `reasoning` output item whose `summary[].text` contains the model's thinking, alongside the final answer.

**[OpenAI SDK]**

```java
import com.openai.models.responses.Response;
import com.openai.models.responses.ResponseCreateParams;

Response response = client.responses().create(
    ResponseCreateParams.builder()
        .model("DeepSeek-R1-0528") // Required: your deployment name
        .input("How many languages are in the world?")
        .maxOutputTokens(2000)
        .build()
);

// Walk response.output() for items of type "reasoning" and join summary[].text.
StringBuilder sb = new StringBuilder();
response.output().stream()
    .flatMap(item -> item.reasoning().stream())
    .flatMap(reasoning -> reasoning.summary().stream())
    .forEach(summary -> {
        String text = summary.text();
        if (text != null && !text.isEmpty()) {
            if (sb.length() > 0) sb.append("\n");
            sb.append(text);
        }
    });

System.out.println("Thinking: " + sb.toString().trim());
```

**Output is as follows:**

```console
Thinking: Okay, the user is asking how many languages exist in the world. I need to provide a clear and accurate answer...
```

> **Note**
>
> **Known issue:** For Foundry Models (non-Azure OpenAI models), such as DeepSeek-R1-0528, the reasoning summary text on each `reasoning` output item is populated reliably, but the reasoning token count in the response usage details (`reasoning_tokens` on the wire) currently reports `0` even when summary text is present. Don't rely on the reasoning token count for billing or quota accounting when using Foundry models. This caveat *doesn't apply to Azure OpenAI in Foundry Models*.

**[Azure AI Inference SDK]**

The Azure AI Inference SDK doesn't expose the Responses API. To get reasoning content, call the chat completions API instead. The reasoning is included in the message content wrapped in `<think>` and `</think>` tags, which you can extract with a regex match.

```java
import com.azure.ai.inference.models.*;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

List<ChatRequestMessage> messages = List.of(
    new ChatRequestSystemMessage("You are a helpful assistant."),
    new ChatRequestUserMessage("How many languages are in the world?")
);

ChatCompletionsOptions options = new ChatCompletionsOptions(messages);
options.setModel("DeepSeek-R1-0528"); // Optional for single-model endpoints

ChatCompletions response = client.complete(options);
String content = response.getChoices().get(0).getMessage().getContent();

Pattern pattern = Pattern.compile("<think>(.*?)</think>(.*)", Pattern.DOTALL);
Matcher matcher = pattern.matcher(content);

if (matcher.find()) {
    System.out.println("Thinking: " + matcher.group(1).trim());
    System.out.println("Answer:   " + matcher.group(2).trim());
} else {
    System.out.println("Response: " + content);
}
```

**Output is as follows:**

```console
Thinking: Okay, the user is asking how many languages exist in the world. I need to provide a clear and accurate answer...
Answer:   There are approximately 7,000 languages spoken around the world today.
```

When you make multi-turn conversations, avoid sending the reasoning content in the chat history because reasoning tends to generate long explanations.

## Embeddings

**[OpenAI SDK]**

```java
package com.openai.example;

import com.openai.client.OpenAIClient;
import com.openai.client.okhttp.OpenAIOkHttpClient;
import com.openai.models.embeddings.EmbeddingCreateParams;
import com.openai.models.embeddings.EmbeddingModel;

public final class EmbeddingsExample {
    private EmbeddingsExample() {}

    public static void main(String[] args) {
        // Configures using one of:
        // - The `OPENAI_API_KEY` environment variable
        // - The `OPENAI_BASE_URL` and `AZURE_OPENAI_KEY` environment variables
        OpenAIClient client = OpenAIOkHttpClient.fromEnv();

        EmbeddingCreateParams createParams = EmbeddingCreateParams.builder()
                .input("The quick brown fox jumped over the lazy dog")
                .model(EmbeddingModel.TEXT_EMBEDDING_3_SMALL)
                .build();

        System.out.println(client.embeddings().create(createParams));
    }
}
```

**[Azure AI Inference SDK]**

```java
import com.azure.ai.inference.EmbeddingsClient;
import com.azure.ai.inference.EmbeddingsClientBuilder;
import com.azure.core.credential.AzureKeyCredential;

EmbeddingsClient client = new EmbeddingsClientBuilder()
    .credential(new AzureKeyCredential(System.getenv("AZURE_INFERENCE_CREDENTIAL")))
    .endpoint("https://<resource>.services.ai.azure.com/models")
    .buildClient();

EmbeddingsOptions embeddingsOptions = new EmbeddingsOptions(
    List.of("Your text string goes here")
);
embeddingsOptions.setModel("text-embedding-3-small");

EmbeddingsResult response = client.embed(embeddingsOptions);
List<Float> embedding = response.getData().get(0).getEmbedding();
```

**[programming-language-go]**

## Setup

Install the OpenAI SDK:

```bash
go get github.com/openai/openai-go/v3
```

For Microsoft Entra ID authentication, also install:

```bash
go get -u github.com/Azure/azure-sdk-for-go/sdk/azidentity
```

## Client configuration

With API key authentication:

**[OpenAI SDK]**

```go
import (
    "github.com/openai/openai-go/v3"
    "github.com/openai/openai-go/v3/option"
)

client := openai.NewClient(
    option.WithBaseURL("https://<resource>.openai.azure.com/openai/v1/"),
    option.WithAPIKey(os.Getenv("AZURE_OPENAI_API_KEY")),
)
```

**[Azure AI Inference SDK]**

Azure AI Inference SDK for Go uses Azure SDK patterns.

With Microsoft Entra ID authentication:

**[OpenAI SDK]**

```go
import (
    "github.com/Azure/azure-sdk-for-go/sdk/azidentity"
    "github.com/openai/openai-go/v3"
    "github.com/openai/openai-go/v3/azure"
    "github.com/openai/openai-go/v3/option"
)

tokenCredential, err := azidentity.NewDefaultAzureCredential(nil)
if err != nil {
    panic(err)
}

client := openai.NewClient(
    option.WithBaseURL("https://<resource>.openai.azure.com/openai/v1/"),
    azure.WithTokenCredential(tokenCredential),
)
```

**[Azure AI Inference SDK]**

Azure AI Inference SDK for Go supports Microsoft Entra ID through Azure SDK.

## Chat completions

**[OpenAI SDK]**

```go
import (
    "context"
    "fmt"
    "github.com/openai/openai-go/v3"
)

chatCompletion, err := client.Chat.Completions.New(context.TODO(), openai.ChatCompletionNewParams{
    Messages: []openai.ChatCompletionMessageParamUnion{
        openai.SystemMessage("You are a helpful assistant."),
        openai.UserMessage("What is Azure AI?"),
    },
    Model: "DeepSeek-V3.1", // Required: your deployment name
})

if err != nil {
    panic(err.Error())
}

fmt.Println(chatCompletion.Choices[0].Message.Content)
```

**[Azure AI Inference SDK]**

Azure AI Inference SDK for Go uses Azure SDK patterns for chat completions.

### Streaming

**[OpenAI SDK]**

```go
import (
    "context"
    "fmt"
    "github.com/openai/openai-go/v3"
)

stream := client.Chat.Completions.NewStreaming(context.TODO(), openai.ChatCompletionNewParams{
    Messages: []openai.ChatCompletionMessageParamUnion{
        openai.SystemMessage("You are a helpful assistant."),
        openai.UserMessage("Write a poem about Azure."),
    },
    Model: "DeepSeek-V3.1", // Required: your deployment name
})

for stream.Next() {
    chunk := stream.Current()
    if len(chunk.Choices) > 0 && chunk.Choices[0].Delta.Content != "" {
        fmt.Print(chunk.Choices[0].Delta.Content)
    }
}

if err := stream.Err(); err != nil {
    panic(err.Error())
}
```

**[Azure AI Inference SDK]**

Azure AI Inference SDK for Go supports streaming through Azure SDK patterns.

## Responses

The Responses API is OpenAI's stateful interface that returns a structured `output` array containing message, tool call, and reasoning items.

**[OpenAI SDK]**

```go
import (
    "context"
    "fmt"

    "github.com/openai/openai-go/v3"
    "github.com/openai/openai-go/v3/responses"
)

resp, err := client.Responses.New(context.TODO(), responses.ResponseNewParams{
    Model: "DeepSeek-V3.1", // Required: your deployment name
    Input: responses.ResponseNewParamsInputUnion{
        OfString: openai.String("How many languages are in the world?"),
    },
    MaxOutputTokens: openai.Int(2000),
})
if err != nil {
    panic(err.Error())
}

fmt.Println(resp.OutputText())
```

**[Azure AI Inference SDK]**

The Azure AI Inference SDK doesn't expose the Responses API. To call it, use the OpenAI SDK.

### Reasoning

> **Note**
>
> This information on reasoning content doesn't apply to Azure OpenAI models. Azure OpenAI reasoning models use the [reasoning summaries feature](../../06-models/06.6-develop-with-ai-models/16-reasoning.md#reasoning-summary).

Some reasoning models, like DeepSeek-R1, generate completions and include the reasoning behind them. The Responses API surfaces this as a structured `reasoning` output item whose `summary[].text` contains the model's thinking, alongside the final answer.

**[OpenAI SDK]**

```go
import (
    "context"
    "fmt"
    "strings"

    "github.com/openai/openai-go/v3"
    "github.com/openai/openai-go/v3/responses"
)

resp, err := client.Responses.New(context.TODO(), responses.ResponseNewParams{
    Model: "DeepSeek-R1-0528", // Required: your deployment name
    Input: responses.ResponseNewParamsInputUnion{
        OfString: openai.String("How many languages are in the world?"),
    },
    MaxOutputTokens: openai.Int(2000),
})
if err != nil {
    panic(err.Error())
}

// Walk resp.Output for items of type "reasoning" and join summary[].text.
var parts []string
for _, item := range resp.Output {
    if item.Type != "reasoning" {
        continue
    }
    for _, s := range item.Summary {
        if s.Text != "" {
            parts = append(parts, s.Text)
        }
    }
}
reasoningSummary := strings.TrimSpace(strings.Join(parts, "\n"))

fmt.Println("Thinking:", reasoningSummary)
fmt.Println("Answer:  ", resp.OutputText())
```

**Output is as follows:**

```console
Thinking: Okay, the user is asking how many languages exist in the world. I need to provide a clear and accurate answer...
Answer:   There are approximately 7,000 languages spoken around the world today.
```

> **Note**
>
> **Known issue:** For Foundry Models (non-Azure OpenAI models), such as DeepSeek-R1-0528, the reasoning summary text on each `reasoning` output item is populated reliably, but the reasoning token count in the response usage details (`reasoning_tokens` on the wire) currently reports `0` even when summary text is present. Don't rely on the reasoning token count for billing or quota accounting when using Foundry models. This caveat *doesn't apply to Azure OpenAI in Foundry Models*.

**[Azure AI Inference SDK]**

The Azure AI Inference SDK for Go doesn't expose the Responses API. To get reasoning content, call the chat completions API instead. The reasoning is included in the message content wrapped in `<think>` and `</think>` tags, which you can extract with a regex match.

When you make multi-turn conversations, avoid sending the reasoning content in the chat history because reasoning tends to generate long explanations.

## Embeddings

**[OpenAI SDK]**

```go
package main

import (
    "context"
    "fmt"
    "log"

    "github.com/Azure/azure-sdk-for-go/sdk/azidentity"
    "github.com/openai/openai-go/v3"
    "github.com/openai/openai-go/v3/azure"
    "github.com/openai/openai-go/v3/option"
)

func main() {
    tokenCredential, err := azidentity.NewDefaultAzureCredential(nil)
    if err != nil {
        log.Fatalf("Error creating credential:%s", err)
    }
    // Create a client with Azure OpenAI endpoint and Entra ID credentials
    client := openai.NewClient(
        option.WithBaseURL("https://YOUR-RESOURCE-NAME.openai.azure.com/openai/v1/"),
        azure.WithTokenCredential(tokenCredential),
    )

    inputText := "The quick brown fox jumped over the lazy dog"

    // Make the embedding request synchronously
    resp, err := client.Embeddings.New(context.Background(), openai.EmbeddingNewParams{
        Model: openai.EmbeddingModel("text-embedding-3-large"), // Use your deployed model name on Azure
        Input: openai.EmbeddingNewParamsInputUnion{
            OfArrayOfStrings: []string{inputText},
        },
    })
    if err != nil {
        log.Fatalf("Failed to get embedding: %s", err)
    }

    if len(resp.Data) == 0 {
        log.Fatalf("No embedding data returned.")
    }

    // Print embedding information
    embedding := resp.Data[0].Embedding
    fmt.Printf("Embedding Length: %d\n", len(embedding))
    fmt.Println("Embedding Values:")
    for _, value := range embedding {
        fmt.Printf("%f, ", value)
    }
    fmt.Println()
}
```

**[Azure AI Inference SDK]**

Azure AI Inference SDK for Go uses Azure SDK patterns for embeddings.

## Common migration patterns

### Model parameter handling

- **Azure AI Inference SDK**: The `model` parameter is optional for single-model endpoints but required for multimodel endpoints.
- **OpenAI SDK**: The `model` parameter is always required and should be set to your deployment name.

### Endpoint URL format

- **Azure AI Inference SDK**: Uses `https://<resource>.services.ai.azure.com/models`.
- **OpenAI SDK**: Uses `https://<resource>.openai.azure.com/openai/v1` (connects to the OpenAI v1 API).

### Response structure

The response structure is similar but has some differences:

- **Azure AI Inference SDK**: Returns `ChatCompletions` object with `choices[].message.content`.
- **OpenAI SDK**: Returns `ChatCompletion` object with `choices[].message.content`.

Both SDKs provide similar access patterns to response data, including:

- Message content
- Token usage
- Model information
- Finish reason

## Migration checklist

Use this checklist to ensure a smooth migration:

- Install the OpenAI SDK for your programming language
- Update authentication code (API key or Microsoft Entra ID)
- Change endpoint URLs from `.services.ai.azure.com/models` to `.openai.azure.com/openai/v1/`
- Change the credential scope from `https://cognitiveservices.azure.com/.default` to `https://ai.azure.com/.default`
- Update client initialization code
- Always specify the `model` parameter with your deployment name
- Update request method calls (`complete` → `chat.completions.create`)
- Update streaming code if applicable
- Update error handling to use OpenAI SDK exceptions
- Test all functionality thoroughly
- Update documentation and code comments

## Troubleshooting

### Authentication failures

If you experience authentication failures:

- Verify your API key is correct and isn't expired
- For Microsoft Entra ID, ensure your application has the correct permissions
- Check that the credential scope is set to `https://ai.azure.com/.default`

### Endpoint errors

If you receive endpoint errors:

- Verify the endpoint URL format includes `/openai/v1/` at the end.
- Ensure your resource name is correct.
- Check that the model deployment exists and is active.

### Model not found errors

If you receive "model not found" errors:

- Verify you're using your deployment name, not the model name.
- Check that the deployment is active in your Microsoft Foundry resource.
- Ensure the deployment name matches exactly (case-sensitive).

## Related content

- [Azure OpenAI supported programming languages](../../05-developer-tools-and-integrations/05.4-sdks-and-apis/05-supported-languages.md)
- [How to generate chat completions with Foundry Models](../../05-developer-tools-and-integrations/05.4-sdks-and-apis/04-api-version-lifecycle.md)
- [API evolution and version lifecycle](../../05-developer-tools-and-integrations/05.4-sdks-and-apis/04-api-version-lifecycle.md)
- [Switch between OpenAI and Azure OpenAI endpoints](https://learn.microsoft.com/en-us/azure/developer/ai/how-to/switching-endpoints)
