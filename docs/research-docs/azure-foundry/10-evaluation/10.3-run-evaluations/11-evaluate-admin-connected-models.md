# Use admin-connected models in cloud evaluations

| Field | Value |
| --- | --- |
| **Document Title** | Use admin-connected models in cloud evaluations |
| **Document Location** | `docs/research-docs/azure-foundry/10-evaluation/10.3-run-evaluations/11-evaluate-admin-connected-models.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Use admin-connected models in cloud evaluations". Learn how to use models connected through an enterprise AI gateway as evaluators, targets, and simulators in Microsoft Foundry cloud evaluations. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/observability/how-to/evaluate-admin-connected-models). Article date: 2026-08-04. Page updated: 2026-09-17. Retrieved: 2026-09-29. Navigation: Evaluation > Run evaluations > Run evaluations with the SDK > Use admin-connected models.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Admin-connected models are models hosted behind an enterprise AI gateway, such as [Azure API Management](../../13-manage-and-operate/13.1-set-up-and-configure/14-ai-gateway.md) or a non-Azure AI model gateway, that an administrator connects to your Foundry project. You can use an admin-connected model for cloud evaluation scenarios that accept a model deployment.

Foundry resolves the connection endpoint and authentication, including API key, managed identity, or OAuth 2.0 authentication. Your evaluation request simply references the connection and deployment and the service manages resolving the gateway endpoint resolution and authentication.

> **Important**
>
> Admin-connected models require the connected deployment to expose the OpenAI **Chat Completions API**.

> **Note**
>
> Admin-connected model support in cloud evaluation is in preview and might not be available in all regions.

## Prerequisites

- A [Foundry project](../../13-manage-and-operate/13.1-set-up-and-configure/07-create-projects.md).
- **Foundry User** role on the Foundry project.
- An administrator has created an Azure API Management or non-Azure AI model gateway connection on your Foundry resource and added the model on the **Manage** > **Resource details** > **Admin-connected models** tab. For setup instructions, see [Bring your own model to Foundry Agent Service](../../13-manage-and-operate/13.1-set-up-and-configure/14-ai-gateway.md).
- The connection name and deployment name for a model that supports the OpenAI Chat Completions API.

## Reference an admin-connected model

Use the following format anywhere a supported evaluation scenario accepts a model deployment:

```text
<connection-name>/<deployment-name>
```

The following table shows common evaluation surfaces and the field that accepts the reference:

| Scenario | Field |
| --- | --- |
| AI-assisted evaluator (judge) | `initialization_parameters.model` |
| Model target | `target.model` |
| Conversation simulation | `item_generation_params.model` |

## Use an admin-connected model as an evaluator judge model

Set `initialization_parameters.model` when you configure an AI-assisted evaluator. This example uses the admin-connected model as the judge for the coherence evaluator:

**[Python]**

```python
from azure.ai.projects.models import TestingCriterionAzureAIEvaluator

admin_connected_model = "my-apim-connection/my-model-name"

testing_criteria = [
    TestingCriterionAzureAIEvaluator(
        type="azure_ai_evaluator",
        name="coherence",
        evaluator_name="builtin.coherence",
        initialization_parameters={"model": admin_connected_model},
        data_mapping={
            "query": "{{item.query}}",
            "response": "{{item.response}}",
        },
    ),
]
```

**[C#]**

```csharp
string adminConnectedModel = "my-apim-connection/gpt-4o";

object[] testingCriteria =
[
    new
    {
        type = "azure_ai_evaluator",
        name = "coherence",
        evaluator_name = "builtin.coherence",
        initialization_parameters = new { model = adminConnectedModel },
        data_mapping = new
        {
            query = "{{item.query}}",
            response = "{{item.response}}"
        }
    }
];
```

**[JavaScript/TypeScript]**

```typescript
const adminConnectedModel = "my-apim-connection/gpt-4o";

const testingCriteria = [
    {
        type: "azure_ai_evaluator",
        name: "coherence",
        evaluator_name: "builtin.coherence",
        initialization_parameters: { model: adminConnectedModel },
        data_mapping: {
            query: "{{item.query}}",
            response: "{{item.response}}",
        },
    },
];
```

- Reference: [`TestingCriterionAzureAIEvaluator`](https://learn.microsoft.com/en-us/python/api/azure-ai-projects/azure.ai.projects.models.testingcriterionazureaievaluator) (Python)
- Reference: [OpenAI Evals API](https://platform.openai.com/docs/api-reference/evals) (`testing_criteria`, all languages)

## Use an admin-connected model as a target

Set `target.model` to send each evaluation input to the admin-connected model:

**[Python]**

```python
admin_connected_model = "my-apim-connection/my-model-name"

target = {
    "type": "azure_ai_model",
    "model": admin_connected_model,
    "sampling_params": {
        "top_p": 1.0,
        "max_completion_tokens": 2048,
    },
}
```

**[C#]**

```csharp
string adminConnectedModel = "my-apim-connection/gpt-4o";

object target = new
{
    type = "azure_ai_model",
    model = adminConnectedModel,
    sampling_params = new
    {
        top_p = 1.0f,
        max_completion_tokens = 2048
    }
};
```

**[JavaScript/TypeScript]**

```typescript
const adminConnectedModel = "my-apim-connection/gpt-4o";

const target = {
    type: "azure_ai_model",
    model: adminConnectedModel,
    sampling_params: {
        top_p: 1.0,
        max_completion_tokens: 2048,
    },
};
```

- Reference: [OpenAI Evals API](https://platform.openai.com/docs/api-reference/evals) (`data_source.target`, all languages)

Use this target with the [model target evaluation flow described in Run evaluations in the cloud](04-cloud-evaluation-targets.md#evaluate-a-model-target).

## Use other evaluation scenarios

Other model-based scenarios in [Run evaluations in the cloud by using the Microsoft Foundry SDK](02-cloud-evaluation.md) work similarly with admin-connected models. Wherever the scenario accepts a supported model deployment, replace the deployment name with `<connection-name>/<deployment-name>`. For example, conversation simulation accepts this reference in `item_generation_params.model`.

Keep the Foundry project endpoint unchanged, and don't add the gateway endpoint or credentials to the evaluation request. Foundry resolves those values from the admin-connected model connection.

> **Note**
>
> Admin-connected model isn't available for synthetic data generation.

## Related content

- [Run evaluations in the cloud by using the Microsoft Foundry SDK](02-cloud-evaluation.md)
- [Bring your own model to Foundry Agent Service](../../13-manage-and-operate/13.1-set-up-and-configure/14-ai-gateway.md)
