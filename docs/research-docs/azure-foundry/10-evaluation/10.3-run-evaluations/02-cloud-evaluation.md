# Introduction to cloud evaluation with Microsoft Foundry SDK

| Field | Value |
| --- | --- |
| **Document Title** | Introduction to cloud evaluation with Microsoft Foundry SDK |
| **Document Location** | `docs/research-docs/azure-foundry/10-evaluation/10.3-run-evaluations/02-cloud-evaluation.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Introduction to cloud evaluation with Microsoft Foundry SDK". Set up the Microsoft Foundry SDK and choose a cloud evaluation workflow for datasets, targets, interactions, conversations, or synthetic data. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/observability/how-to/cloud-evaluation). Article date: 2026-08-31. Page updated: 2026-09-07. Retrieved: 2026-09-29. Navigation: Evaluation > Run evaluations > Run evaluations with the SDK > Introduction to cloud evaluation.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Use cloud evaluations to test generative AI applications at scale without managing local compute. This article sets up the shared SDK client and helps you choose a workflow for predeployment or production evaluation.

## Prerequisites

- A [Foundry project](../../13-manage-and-operate/13.1-set-up-and-configure/07-create-projects.md).
- An Azure OpenAI deployment with a GPT model that supports chat completion, such as `gpt-5-mini`.
- The **Foundry User** role on the Foundry project.

  > **Important**
  >
  > The Foundry RBAC roles were recently renamed. **Foundry User**, **Foundry Owner**, **Foundry Account Owner**, and **Foundry Project Manager** were previously named Azure AI User, Azure AI Owner, Azure AI Account Owner, and Azure AI Project Manager. You might still see the previous names in some places while the rename rolls out. The role IDs and core permissions are unchanged by the rename.
- Optionally, [your own storage account](../01-evaluation-regions-limits-virtual-network.md#bring-your-own-storage) for evaluation data.

Some evaluation features have regional restrictions. Review the [supported regions](../10.1-supported-evaluators/05-risk-safety-evaluators.md#foundry-project-configuration-and-region-support) before you begin.

## Set up the SDK client

Install the SDK for your language. Set these shared environment variables:

- `AZURE_AI_PROJECT_ENDPOINT`: Your Foundry project endpoint, for example, `https://<account_name>.services.ai.azure.com/api/projects/<project_name>`.
- `AZURE_AI_MODEL_DEPLOYMENT_NAME`: The model deployment used by AI-assisted evaluators.
- `DATASET_NAME` and `DATASET_VERSION`: Optional values for reusable datasets.

Authenticate with `DefaultAzureCredential`, create the project client, and get the OpenAI client used by the evaluation API.

**[Python]**

```bash
pip install "azure-ai-projects>=2.2.0"
```

```python
import os
from azure.identity import DefaultAzureCredential
from azure.ai.projects import AIProjectClient
from azure.ai.projects.models import TestingCriterionAzureAIEvaluator
from openai.types.eval_create_params import DataSourceConfigCustom
from openai.types.evals.create_eval_jsonl_run_data_source_param import (
    CreateEvalJSONLRunDataSourceParam,
    SourceFileContent,
    SourceFileContentContent,
    SourceFileID,
)

endpoint = os.environ["AZURE_AI_PROJECT_ENDPOINT"]
model_deployment_name = os.environ.get(
    "AZURE_AI_MODEL_DEPLOYMENT_NAME", ""
)
dataset_name = os.environ.get("DATASET_NAME", "")
dataset_version = os.environ.get("DATASET_VERSION", "1")

project_client = AIProjectClient(
    endpoint=endpoint,
    credential=DefaultAzureCredential(),
)
openai_client = project_client.get_openai_client()
```

Reference: [`AIProjectClient`](https://learn.microsoft.com/en-us/python/api/azure-ai-projects/azure.ai.projects.aiprojectclient), [`DefaultAzureCredential`](https://learn.microsoft.com/en-us/python/api/azure-identity/azure.identity.defaultazurecredential)

**[C#]**

```dotnetcli
dotnet add package Azure.AI.Projects --prerelease
dotnet add package Azure.Identity
```

```csharp
using System.ClientModel;
using System.Collections.Generic;
using System.Text.Json;
using Azure.AI.Extensions.OpenAI;
using Azure.AI.Projects;
using Azure.Identity;
using OpenAI.Evals;
using OpenAI.Responses;

#pragma warning disable OPENAI001

static string GetString(ClientResult result, string propertyName)
{
  using JsonDocument document = JsonDocument.Parse(
    result.GetRawResponse().Content.ToMemory());
  return document.RootElement.GetProperty(propertyName).GetString()
    ?? throw new InvalidOperationException(
      $"The response doesn't contain {propertyName}.");
}

var projectEndpoint = Environment.GetEnvironmentVariable(
  "AZURE_AI_PROJECT_ENDPOINT")
  ?? throw new InvalidOperationException(
    "AZURE_AI_PROJECT_ENDPOINT isn't set.");
var modelDeploymentName = Environment.GetEnvironmentVariable(
  "AZURE_AI_MODEL_DEPLOYMENT_NAME")
  ?? throw new InvalidOperationException(
    "AZURE_AI_MODEL_DEPLOYMENT_NAME isn't set.");
var datasetName = Environment.GetEnvironmentVariable("DATASET_NAME")
  ?? "evaluation-data";
var datasetVersion = Environment.GetEnvironmentVariable("DATASET_VERSION")
  ?? "1";

AIProjectClient projectClient = new(
  endpoint: new Uri(projectEndpoint),
  tokenProvider: new DefaultAzureCredential());
EvaluationClient evaluationClient = projectClient.ProjectOpenAIClient
  .GetEvaluationClient();
```

Reference: [`AIProjectClient`](https://learn.microsoft.com/en-us/dotnet/api/azure.ai.projects.aiprojectclient), [`DefaultAzureCredential`](https://learn.microsoft.com/en-us/dotnet/api/azure.identity.defaultazurecredential), and [`EvaluationClient`](https://github.com/openai/openai-dotnet/blob/main/OpenAI/src/Custom/Evals/EvaluationClient.Protocol.cs)

**[JavaScript/TypeScript]**

```bash
npm install @azure/ai-projects @azure/identity dotenv
```

```javascript
import { AIProjectClient } from "@azure/ai-projects";
import { DefaultAzureCredential } from "@azure/identity";
import "dotenv/config";

const projectEndpoint = process.env["AZURE_AI_PROJECT_ENDPOINT"] || "";
const modelDeploymentName =
  process.env["AZURE_AI_MODEL_DEPLOYMENT_NAME"] || "";
const datasetName = process.env["DATASET_NAME"] || "";
const datasetVersion = process.env["DATASET_VERSION"] || "1";

const projectClient = new AIProjectClient(
  projectEndpoint,
  new DefaultAzureCredential(),
);
const openaiClient = projectClient.getOpenAIClient();
```

Reference: [AIProjectClient class](https://learn.microsoft.com/en-us/javascript/api/@azure/ai-projects/aiprojectclient)

To use a model connected through admin connections as a target, judge model, or conversation simulator, see [Use admin-connected models in cloud evaluations](11-evaluate-admin-connected-models.md).

## Understand the evaluation workflow

A cloud evaluation has three steps:

1. Define the data shape and the evaluators that score it.
2. Create the evaluation with the evaluation client.
3. Start a run, poll until it completes, and retrieve the scored results.

Cloud evaluation results are stored in your Foundry project. You can retrieve them through the SDK, review them in the portal, or route them to Application Insights when it's connected.

## Choose evaluators

Evaluators bind to fields in your data through column mappings. Dataset workflows expose item fields, while target-generated workflows also expose the model or agent output through the sample schema.

Review the [built-in evaluators](../10.1-supported-evaluators/01-built-in-evaluators.md) and [custom evaluators](../10.1-supported-evaluators/09-custom-evaluators.md) before you configure testing criteria.

## Choose your starting point

| Evaluation unit | Starting point | Workflow |
| --- | --- | --- |
| Individual turn | You have JSONL or CSV test data with a query and response. | [Evaluate query-response datasets](03-cloud-evaluation-datasets.md) |
| Individual turn | You have queries and want a model or agent to generate responses. | [Evaluate model and agent responses](04-cloud-evaluation-targets.md) |
| Individual turn | You have stored responses or traces from individual interactions with a deployed model or agent. | [Evaluate deployed model and agent interactions](05-cloud-evaluation-deployed-interactions.md) |
| Individual turn | You need to generate synthetic queries. | [Generate synthetic queries](06-cloud-evaluation-synthetic-data.md#generate-synthetic-queries) |
| Complete conversation | You have a dataset of complete conversations. | [Evaluate conversation datasets](07-cloud-evaluation-conversations.md) |
| Complete conversation | You have traces that capture complete conversations with a deployed model or agent. | [Evaluate deployed model and agent conversations](08-cloud-evaluation-deployed-conversations.md) |
| Complete conversation | You need to generate and evaluate simulated agent conversations. | [Simulate agent conversations](09-cloud-evaluation-simulate-conversations.md) |
| Any evaluation unit | You need to poll, interpret, cancel, or troubleshoot a run. | [Get evaluation results](10-cloud-evaluation-results.md) |

For adversarial safety testing, use [AI red teaming](../10.4-ai-red-teaming/02-run-ai-red-teaming-cloud.md). To create a standalone dataset, see [Generate a synthetic evaluation dataset](../10.2-evaluation-datasets/03-evaluation-dataset-synthetic.md).

## Related content

- [Get cloud evaluation results](10-cloud-evaluation-results.md)
- [View evaluation results in the Foundry portal](15-evaluate-results.md)
- [Set up continuous evaluation](../../07-agents/07.3-hosted-agents/33-how-to-monitor-agents-dashboard.md#set-up-continuous-evaluation)
- [Complete Python SDK evaluation samples](https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/ai/azure-ai-projects/samples/evaluations)
- [.NET evaluation samples](https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/ai/Azure.AI.Projects/samples/Evaluations)
- [REST API reference](https://ai.azure.com/api-reference)
