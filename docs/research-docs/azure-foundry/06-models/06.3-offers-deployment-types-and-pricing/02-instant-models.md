# Instant access to models in Microsoft Foundry (preview)

| Field | Value |
| --- | --- |
| **Document Title** | Instant access to models in Microsoft Foundry (preview) |
| **Document Location** | `docs/research-docs/azure-foundry/06-models/06.3-offers-deployment-types-and-pricing/02-instant-models.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Instant access to models in Microsoft Foundry (preview)". Learn about instant access in Microsoft Foundry, which let you call any supported model by name without creating a deployment first. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/concepts/instant-models). Article date: 2026-07-10. Page updated: 2026-09-24. Retrieved: 2026-09-29. Navigation: Models > Offers, deployment types, and pricing > Instant access models (preview).
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Instant access to models lets you call any supported model by name — no deployment required. Create a Foundry project, start coding, and use any available model immediately.

## Prerequisites

- An Azure subscription. [Create one for free](https://azure.microsoft.com/free/).
- Sign in to [Microsoft Foundry](https://ai.azure.com/?cid=learnDocs). Make sure the **New Foundry** toggle is on. These steps refer to **Foundry (new)**.![](https://learn.microsoft.com/en-us/azure/foundry/media/version-banner/new-foundry.png)
- A Foundry project in **West US 3** (the only supported region for instant access during preview). If you need to create a project, see [Create a project](../../13-manage-and-operate/13.1-set-up-and-configure/07-create-projects.md).
- The **Foundry User** role on the project or account.

> **Important**
>
> The Foundry RBAC roles were recently renamed. **Foundry User**, **Foundry Owner**, **Foundry Account Owner**, and **Foundry Project Manager** were previously named Azure AI User, Azure AI Owner, Azure AI Account Owner, and Azure AI Project Manager. You might still see the previous names in some places while the rename rolls out. The role IDs and core permissions are unchanged by the rename.

## Start using models instantly

With instant access, the workflow is simple — use a supported instant model name in your code. No deployment needed. The same API, SDK, and client you already use for deployments works with instant access models. No second SDK, no separate client, no configuration changes.

Support for instant access continues to expand over time. The exact set changes frequently. See [Supported models](#supported-models) for ways to see the full list.

**[Python]**

For the `model` parameter, use the instant access model name, such as `"gpt-5-mini"`, instead of a deployed model name.

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

For the `model` parameter, use the instant access model name, such as `"gpt-5-mini"`, instead of a deployed model name.

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

For the `model` parameter, use the instant access model name, such as `"gpt-5-mini"`, instead of a deployed model name.

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

For the `model` parameter, use the instant access model name, such as `"gpt-5-mini"`, instead of a deployed model name.

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

For the `model` parameter, use the instant access model name, such as `"gpt-5-mini"`, instead of a deployed model name.

Also replace `YOUR-FOUNDRY-RESOURCE-NAME` with your values:

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

1. On the Home page of your project, select **Test in playground**.
2. Use the **Model** dropdown in the playground to switch among deployed and instant access models.

## Playground for instant access models

To reach the playground for instant access models, use one of these paths:

1. From **Home**, select **Test in playground**.
2. From **Home**, select **Explore models** to go to the model catalog. Or, select **Discover** > **Models**. Either path opens the catalog.
3. From the model catalog, select an instant access model to view its details.
4. From an instant access model details page, select **Open playground**.
5. From a playground, use the **Model** dropdown to switch to other instant access or deployed models.

![Diagram of navigation paths from Home to Playground, including Catalog and Model routes.](https://learn.microsoft.com/en-us/azure/foundry/concepts/media/instant-models/playground-navigation-paths-flowchart.png)

### Why instant access matters

- **Switch models by changing one string** — use any instant model name in the `model=` line, without creating or deleting deployments.
- **Same API and SDK** — the same calls work for both instant access and deployments.
- **Works with your dev tools** — instant access integrates with Foundry CLI, VS Code, and CI/CD pipelines the same way deployments do.

Deployments aren't going away. They remain the right choice when you need reserved throughput, custom content filters, data residency, or advanced enterprise configurations. Instant access simplify the getting-started experience so that deployments become something you level up to, not a gate you must pass before you can use a model.

## Supported models

New models support instant access by default when they're released. The product team considers support for additional models based on customer demand. The list grows over time, and examples of models you might see include:

- `chat-gpt-latest`
- `gpt-5.6-sol`
- `gpt-5.5`
- `gpt-5-mini`
- `gpt-5.3-codex`

To see all models that support instant access:

1. Open a project in **West US 3** in the new Foundry experience,
2. Select **Discover** in the upper-right navigation, then **Models** in the left pane.
3. In the model catalog, select **Instant** under **Deployment options** to view the available instant access models.

You can also list instant access models programmatically:

```bash
SUBSCRIPTION_ID="<your-subscription-id>"
LOCATION="westus3"

az rest --method get \
  --url "https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/providers/Microsoft.CognitiveServices/locations/$LOCATION/models?api-version=2025-06-01" \
  --output json \
| jq -r '(.value // .models // .)[]
  | select((.model.capabilities.instant // "false" | tostring | ascii_downcase) == "true")
  | .model.name' \
| sort -u
```

> **Note**
>
> During the preview, instant access models are available in projects in **West US 3** only.
>
> Some instant access models might appear in the list even if your subscription has no quota for them. For more information, see [Quotas and limits for Foundry Models](../06.2-quota-limits-and-region-availability/05-quotas-limits.md).

## When to use instant access vs. deployments

| Scenario | Recommended approach |
| --- | --- |
| Getting started, prototyping, or experimentation | Instant access |
| Using the latest model immediately after release | Instant access |
| Need reserved capacity or [predictable throughput](04-deployment-types.md) | Deployment |
| Require [provisioned throughput (PTU)](09-provisioned-throughput.md) | Deployment |
| Need [data residency](04-deployment-types.md) in a specific region | Deployment |
| Custom [content filtering](../../12-trust-and-safety/12.1-guardrails-and-controls/01-guardrails-overview.md) policies per model | Deployment |
| Custom [guardrails](../../12-trust-and-safety/12.1-guardrails-and-controls/01-guardrails-overview.md) per model | Deployment |
| Endpoint-specific configuration (for example, version locks per endpoint) | Deployment |
| Fine-grained [quota](../06.2-quota-limits-and-region-availability/02-quota.md) partitioning across teams | Deployment |
| [Fine-tuned models](../06.8-fine-tuning/07-fine-tune-cli.md) | Deployment |

Instant access and deployments can coexist in the same project. You can start with instant access model and create a deployment later as your requirements evolve.

## Model versions

By default, instant access uses the latest evergreen version of a model. To pin to a specific version, append the version date to the model name as a hyphenated suffix:

| What you pass as `model` | Behavior |
| --- | --- |
| `model-name` | Routes to the latest version |
| `model-name-2025-04-01` | Routes to that specific version |

Version pinning is opt-in. If your application requires stability, include the version suffix. Otherwise, you always get the latest version automatically.

## How quota is consumed

Instant access draws from a per-model **global quota** pool assigned to your subscription. This quota is separate from the regional quota used by standard deployments.

- You don't allocate or partition global quota — it's shared automatically across all instant model usage in your subscription.
- Global Standard deployments reserve a portion of your global quota. Instant access models use whatever capacity remains.
- Other deployment types (Regional Standard, Provisioned) use separate regional quota and don't affect your instant model capacity.
- If instant model requests are throttled, you can request a quota increase or create a deployment with reserved capacity.

For more details on how global and regional quotas interact, see [Manage and increase quotas](../06.2-quota-limits-and-region-availability/02-quota.md).

## Enterprise controls

| Capability | How it works |
| --- | --- |
| Block specific models or providers | Azure Policy definitions apply to instant access the same way they apply to deployments |
| Pin to a model version | Append the version suffix to the model name (see [Model versions](#model-versions)) |
| Disable instant access entirely | Administrators can turn off instant access at the subscription level through Azure Policy |

To remove instant access from an account, configure the settings through Bicep or ARM REST.

**[REST API]**

Update your account with:

```http
PATCH https://management.azure.com/subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.CognitiveServices/accounts/{account}?api-version=2026-01-15-preview
Authorization: Bearer {arm_token}
Content-Type: application/json
```

Use this request body to effectively shut off instant model access:

```json
{
  "properties": {
    "instant": {
      "raiPolicyName": "Microsoft.DefaultV2",
      "modelAllowList": []
    }
  }
}
```

**[Bicep]**

Update your existing account resource with an `instant` block:

```bicep
resource account 'Microsoft.CognitiveServices/accounts@2026-01-15-preview' = {
  name: accountName
  location: location
  kind: 'AIServices'
  sku: {
    name: 'S0'
  }
  // Keep your existing account properties and add instant settings.
  properties: {
    instant: {
      raiPolicyName: 'Microsoft.DefaultV2'
      modelAllowList: []
    }
  }
}
```

> **Important**
>
> All instant access models use default [guardrails](../../12-trust-and-safety/12.1-guardrails-and-controls/01-guardrails-overview.md) and content filters. However, you can't configure custom guardrails or Responsible AI (RAI) policies on a per-model basis for instant access. You can set a default RAI policy at the account level through the API, but that policy applies uniformly to all instant access models. If you need different content filtering policies for individual models, use a deployment.

## Deployment name collisions

New deployments can't use a name that matches an existing model name. If you have an existing deployment whose name collides with a model name, the deployment takes precedence and instant model access for that model name is unavailable in that project.

## Limitations during preview

- Available in **West US 3** only.
- Fine-tuned models aren't supported. To use a fine-tuned model, create a deployment.
- [Guardrails](../../12-trust-and-safety/12.1-guardrails-and-controls/01-guardrails-overview.md), custom RAI policies, and content filters aren't configurable for instant access.
- Only the models listed in [Supported models](#supported-models) are eligible.

## Related content

- [Deployment overview for Microsoft Foundry Models](01-deployments-overview.md)
- [Deployment types for Microsoft Foundry Models](04-deployment-types.md)
- [Manage quotas for Foundry resources](../06.2-quota-limits-and-region-availability/02-quota.md)
- [Microsoft Foundry quickstart](../../04-get-started/04.1-what-do-you-want-to-build/03-get-started-code.md)
