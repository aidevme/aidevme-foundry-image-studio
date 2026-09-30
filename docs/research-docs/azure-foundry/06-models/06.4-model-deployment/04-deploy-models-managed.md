# Deploy open-source models with managed compute (Preview)

| Field | Value |
| --- | --- |
| **Document Title** | Deploy open-source models with managed compute (Preview) |
| **Document Location** | `docs/research-docs/azure-foundry/06-models/06.4-model-deployment/04-deploy-models-managed.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Deploy open-source models with managed compute (Preview)". Step-by-step guide to deploy an open-source model from the Microsoft Foundry catalog onto managed compute, send inference requests, wire the deployment into a Foundry Agent, scale, monitor, and request additional quota. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/deploy-models-managed). Article date: 2026-06-01. Page updated: 2026-09-28. Retrieved: 2026-09-29. Navigation: Models > Model deployment > Deploy with managed compute (preview).
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

> **Note**
>
> Managed compute in Foundry is currently in preview. This preview is provided without a service-level agreement, and we don't recommend it for production workloads. Certain features might not be supported or might have constrained capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

Managed compute deployment (preview) in Microsoft Foundry hosts open-source models on dedicated GPU capacity. Microsoft owns the GPU topology, runtime, container image, and security patching. You choose the model, deployment template, accelerator family, and scaling behavior that fit your workload. This article walks through the end-to-end workflow for deploying an open-source model onto managed compute in Microsoft Foundry.

In this article, you learn how to:

- Choose a model in the model catalog
- Select a deployment template
- Deploy the model using the Foundry portal or Python SDK
- Perform inferencing using the OpenAI SDK
- Scale and monitor the deployment
- Request more quota

For an overview of managed compute deployment in Foundry, including model instances, deployment templates, runtimes, accelerator families, billing, and current limitations, see [Managed compute in Microsoft Foundry (Preview)](../06.3-offers-deployment-types-and-pricing/03-managed-compute-overview.md).

## Prerequisites

- An active Azure subscription. To create one, see [Create your Azure free account](https://azure.microsoft.com/free/).
- A resource group in the subscription where you have permission to create resources.
- A Microsoft Foundry account (Cognitive Services account of kind `AIServices`) and a Foundry project. To create one, see [Create a Foundry project](../../13-manage-and-operate/13.1-set-up-and-configure/07-create-projects.md).
- The following Azure role assignments on the Foundry account scope:
  - **Cognitive Services Contributor** (or **Foundry Owner** / **Foundry Account Owner**) — required to create, update, and delete managed compute deployments. See [Role-based access control for Microsoft Foundry — managed compute control-plane operations](../../13-manage-and-operate/13.3-security-and-governance/02-rbac-foundry.md#managed-compute-control-plane-operations).
  - **Foundry User** — required to call the deployment with Microsoft Entra ID from the Playground, the SDK, or REST.
- Approved **managed compute quota** for the accelerator family you plan to deploy on (A100, H100, or MI300X) in the target region. Managed compute quota is separate from Azure VM quota. See [Request more quota](#request-more-quota) at the end of this article.
- Local tools for the SDK and CLI examples:

  ```bash
  pip install "azure-mgmt-cognitiveservices==15.0.0b2" azure-identity openai requests
  az login
  ```
- Azure CLI **2.60 or later**.

> **Important**
>
> Managed compute in Foundry is in **public preview**. APIs, SKU names, and supported regions might change before general availability. Built-in content filtering isn't part of the managed compute data path in public preview. If you need request-level or response-level filtering, call the [Azure AI Content Safety APIs](https://learn.microsoft.com/en-us/azure/ai-services/content-safety/overview) directly from your application.

## Choose a model in the catalog

Managed compute deploys models from the **Hugging Face Collection** in the Foundry model catalog, served from the `azure-huggingface` registry.

For Hugging Face model availability in your project and Hugging Face-specific deployment guidance, see [Hugging Face models in Microsoft Foundry](../06.1-explore-foundry-models/04-hugging-face-models.md).

1. Sign in to [Microsoft Foundry](https://ai.azure.com/?cid=learnDocs). Make sure the **New Foundry** toggle is on. These steps refer to **Foundry (new)**.![](https://learn.microsoft.com/en-us/azure/foundry/media/version-banner/new-foundry.png)
2. Select your subscription and Foundry resource.
3. Select **Build** in the upper-right navigation, then select **Models** in the left pane.
4. Filter the catalog by **Collections**. Choose **Hugging Face**. You can also use any of the other filters to narrow down the model you want to deploy (for example, pick a model family like Qwen) or by modality or task. You can also search by model name.
5. Select a model card (for example, `nvidia-nemotron-3-nano-30b-a3b-fp8`) to open its details.

The model card shows the upstream license, the modality, supported tasks, and the deployment templates published for the model. If you plan to deploy via the Python SDK or REST instead of using the portal wizard, you'll need three values as input to the deployment call. You can find these values in the Foundry portal as follows:

- **Model ID**: the fully qualified registry asset ID for the model. Available on the **model card** in the catalog (copy from the model details pane). Example:

  ```
  azureml://registries/azure-huggingface/models/nvidia--nvidia-nemotron-3-nano-30b-a3b-fp8/versions/2
  ```
- **Deployment template ID**: identifies the runtime, accelerator family and count, and context length for the model. Available in the **deployment wizard** that opens when you select **Deploy** on the model card. Select a template and copy the Deployment template ID from the wizard. Example:

  ```
  azureml://registries/azure-huggingface/deploymenttemplates/nvidia--nvidia-nemotron-3-nano-30b-a3b-fp8--nvidia-h100/labels/latest
  ```

  > **Note**
  >
  > A model ID and a deployment template ID must be compatible; every template lists the model versions it supports. The portal wizard only shows compatible templates for the model you selected. If you deploy using code, verify that both references resolve to valid registry assets in the `azure-huggingface` registry.

  To learn more about deployment templates, see [Deployment template](../06.3-offers-deployment-types-and-pricing/03-managed-compute-overview.md#deployment-template) in the Managed compute overview article.
- **Accelerator type**: for example, `H100_80GB`, `A100_80GB`, or `MI300_192GB`. Shown next to each template in the deployment wizard.

## Deploy the model

**[ai-foundry-portal]**

1. Select **Deploy** on the model card to open the deployment wizard.
2. Specify a **Deployment name**. The deployment name is what your application passes in the `model` field at inference time — pick a stable, application-friendly name (for example, `nemotron-3-nano-30b`).
3. The deployment type (**Global Managed Compute**) is pre-selected in the deployment wizard.
4. Select the **Deployment template** that matches your workload. For example, the H100 single-accelerator template for the lowest cost at moderate context length, or a two-accelerator template if your prompts exceed the single-accelerator context limit.
5. Select the **Accelerator type**, e.g., `H100_80GB`.
6. Set **Model instances** to `1` (or higher if you've measured your workload). **Model instances** sizes the managed compute and is the `capacity` value on the deployment SKU. Each instance consumes the accelerator count defined by the template; for example, a template that specifies one H100 per instance with capacity 2 uses two H100 accelerators in total.

   > **Tip**
   >
   > Start with `capacity: 1` for a first deployment, then scale out by increasing the capacity after you measure your workload. See [Manage and scale the deployment](#manage-and-scale-the-deployment) for how to increase capacity.
7. Select the checkbox to acknowledge the cost for the deployment.
8. Select **Deploy**. Provisioning typically takes 10 to 15 minutes.

## Verify the deployment

The deployment details page updates from `Creating` to `Succeeded` when the model is live behind the Foundry endpoint. You can see details about the deployment, including the provisioning state, deployment type, and other selections you made while creating the deployment.

## Send a test request

When the deployment is ready, test it interactively in the Foundry **Playground**.

1. Select the **Playground** tab to switch to it from the deployment **Details** page.
2. Send a prompt to test the deployment.

## Monitor the deployment

Managed compute deployments emit metrics on the same Azure Monitor surface as other Foundry deployments. From the deployment details page in the Foundry portal, the **Monitor** tab shows:

- Request count grouped by HTTP status code.
- Response time percentiles (p50, p90, p99).
- For chat-completions models: input and output token counts, time-to-first-token (TTFT) percentiles, and inter-token decode time percentiles.

For deeper analysis or alerting, open the deployment in the [Azure portal](https://portal.azure.com/) and use **Metrics** under **Monitoring** to chart the same metrics, group by deployment, and configure alerts. Per-deployment billing tags are emitted automatically. Filter Cost Management by the deployment tag to attribute spend to a specific managed compute deployment. For details, see [Plan and manage costs for Microsoft Foundry](../06.3-offers-deployment-types-and-pricing/16-manage-costs.md).

## Delete the deployment

Deleting a deployment releases its accelerator allocation and stops billing immediately. To delete a deployment:

1. Go to the list of deployments in the Foundry portal.
2. Select the radio button next to your deployment name.
3. In the right pane, select **Delete**.

## Request more quota

Managed compute quota is granted per accelerator family per region through the Foundry quota process and is **separate from Azure VM quota**. Existing Azure VM quota can't be applied to a managed compute deployment.

To request more quota:

1. Select **Manage** in the upper-right navigation, and then select **Quota** in the left pane.
2. Select the **Managed compute** tab. The table lists current allocations grouped by accelerator family and region.
3. Select **Request quota** in the upper-right corner.
4. In the request form, choose the accelerator family (A100, H100, or MI300X), the target region, and the requested quota. Submit the request.

Allow up to 15 minutes for an approved quota change to propagate. Refresh the **Quota** page to verify the updated allocation. For more on quota concepts, see [Manage and increase quotas for resources](../06.2-quota-limits-and-region-availability/02-quota.md).

**[python-sdk]**

Use the following Python script to deploy the model. Replace the placeholders with your own subscription ID, resource group, Foundry account name, and deployment name.

> **Tip**
>
> Start with `capacity: 1` for a first deployment, then scale out by increasing the capacity after you measure your workload. See [Manage and scale the deployment](#manage-and-scale-the-deployment) for how to increase capacity.

```python
from azure.identity import DefaultAzureCredential
from azure.mgmt.cognitiveservices import CognitiveServicesManagementClient

SUBSCRIPTION_ID  = "<your-subscription-id>"
RESOURCE_GROUP   = "<your-resource-group>"
ACCOUNT_NAME     = "<your-foundry-account>"
DEPLOYMENT_NAME  = "nemotron-3-nano-30b"

MODEL = "azureml://registries/azure-huggingface/models/nvidia--nvidia-nemotron-3-nano-30b-a3b-fp8/versions/2"
TEMPLATE = "azureml://registries/azure-huggingface/deploymenttemplates/nvidia--nvidia-nemotron-3-nano-30b-a3b-fp8--nvidia-h100/labels/latest"

client = CognitiveServicesManagementClient(
    DefaultAzureCredential(), SUBSCRIPTION_ID
)

deployment = client.managed_compute_deployments.begin_create_or_update(
    resource_group_name=RESOURCE_GROUP,
    account_name=ACCOUNT_NAME,
    deployment_name=DEPLOYMENT_NAME,
    resource={
        "sku": {"name": "GlobalManagedCompute", "capacity": 1},
        "properties": {
            "model": MODEL,
            "deploymentTemplate": TEMPLATE,
            "acceleratorType": "H100_80GB",
            "versionUpgradeOption": "OnceNewDefaultVersionAvailable",
        },
    },
).result()  # blocks until terminal state (~10–15 min)

print(f"State: {deployment.properties.provisioning_state}")
print(f"ID:    {deployment.id}")
```

## Verify the deployment

After the deployment is created, confirm that it is healthy before sending traffic.

```python
d = client.managed_compute_deployments.get(
    resource_group_name=RESOURCE_GROUP,
    account_name=ACCOUNT_NAME,
    deployment_name=DEPLOYMENT_NAME,
)

print(f"State:        {d.properties.provisioning_state}")    # expect: Succeeded
print(f"Model:        {d.properties.model}")
print(f"Template:     {d.properties.deployment_template}")
print(f"Accelerator:  {d.properties.accelerator_type}")
print(f"Capacity:     {d.sku.capacity}")
```

Look for:

- `provisioningState: Succeeded` means the deployment is live.
- `acceleratorType` matches the value you requested.
- `sku.capacity` matches the number of instances you requested.

If `provisioningState` is `Failed`, see [Troubleshooting](#troubleshooting).

## Send a test request

Managed compute deployments are reachable through the unified Foundry endpoint at:

```
https://<account>.services.ai.azure.com/openai/v1/
```

The `model` field in the request body takes the **deployment name** you specified, not the model ID.

**[OpenAI SDK (Microsoft Entra ID)]**

```python
from azure.identity import DefaultAzureCredential, get_bearer_token_provider
from openai import OpenAI

ACCOUNT_NAME    = "<your-foundry-account>"
DEPLOYMENT_NAME = "nemotron-3-nano-30b"

token_provider = get_bearer_token_provider(
    DefaultAzureCredential(),
    "https://cognitiveservices.azure.com/.default",
)

client = OpenAI(
    base_url=f"https://{ACCOUNT_NAME}.services.ai.azure.com/openai/v1",
    api_key="placeholder",  # required by OpenAI SDK; overridden by Authorization header
    default_headers={"Authorization": f"Bearer {token_provider()}"},
)

resp = client.chat.completions.create(
    model=DEPLOYMENT_NAME,
    messages=[{"role": "user", "content": "What is the capital of France?"}],
)

print(resp.choices[0].message.content)
```

Calling the deployment with Microsoft Entra ID requires the **Azure AI User** role on the Foundry account.

**[OpenAI SDK (API key)]**

```python
from azure.identity import DefaultAzureCredential
from azure.mgmt.cognitiveservices import CognitiveServicesManagementClient
from openai import OpenAI

SUBSCRIPTION_ID = "<your-subscription-id>"
RESOURCE_GROUP  = "<your-resource-group>"
ACCOUNT_NAME    = "<your-foundry-account>"
DEPLOYMENT_NAME = "nemotron-3-nano-30b"

mgmt = CognitiveServicesManagementClient(
    DefaultAzureCredential(), SUBSCRIPTION_ID
)
api_key = mgmt.accounts.list_keys(RESOURCE_GROUP, ACCOUNT_NAME).key1

client = OpenAI(
    base_url=f"https://{ACCOUNT_NAME}.services.ai.azure.com/openai/v1",
    api_key=api_key,
)

resp = client.chat.completions.create(
    model=DEPLOYMENT_NAME,
    messages=[{"role": "user", "content": "What is the capital of France?"}],
)

print(resp.choices[0].message.content)
```

## Manage and scale the deployment

Because managed compute deployments are model-centric, you scale deployments by changing the number of model instances, not by sizing a node.

### Change capacity

```python
d = client.managed_compute_deployments.get(
    RESOURCE_GROUP, ACCOUNT_NAME, DEPLOYMENT_NAME
)
d.sku.capacity = 3

client.managed_compute_deployments.begin_create_or_update(
    resource_group_name=RESOURCE_GROUP,
    account_name=ACCOUNT_NAME,
    deployment_name=DEPLOYMENT_NAME,
    resource=d,
).result()
```

### Pick up runtime and model updates

Setting `versionUpgradeOption` to `OnceNewDefaultVersionAvailable` on the deployment opts the deployment into picking up new default model and runtime versions when Microsoft publishes them. Runtime patches and CVE fixes are applied to live customer deployments automatically; you don't redeploy the model to pick them up.

## Monitor the deployment

Managed compute deployments emit metrics on the same Azure Monitor surface as other Foundry deployments. For deeper analysis or alerting, open the deployment in the [Azure portal](https://portal.azure.com/) and use **Metrics** under **Monitoring** to chart metrics such as:

- Request count grouped by HTTP status code.
- Response time percentiles (p50, p90, p99).
- For chat-completions models: input and output token counts, time-to-first-token (TTFT) percentiles, and inter-token decode time percentiles.

You can also group by deployment and configure alerts. Per-deployment billing tags are emitted automatically. Filter Cost Management by the deployment tag to attribute spend to a specific managed compute deployment. For details, see [Plan and manage costs for Microsoft Foundry](../06.3-offers-deployment-types-and-pricing/16-manage-costs.md).

## Delete the deployment

Deleting a deployment releases its accelerator allocation and stops billing immediately. To delete a deployment:

```python
client.managed_compute_deployments.begin_delete(
    resource_group_name=RESOURCE_GROUP,
    account_name=ACCOUNT_NAME,
    deployment_name=DEPLOYMENT_NAME,
).result()
```

## Access control summary

| Action | Minimum role |
| --- | --- |
| Create, update, or delete a managed compute deployment | Cognitive Services Contributor (or Foundry Owner / Foundry Account Owner) on the Foundry account |
| Read a deployment or list deployments | Cognitive Services User, Foundry User, Foundry Project Manager, or any of the roles above |
| Call the deployment with Microsoft Entra ID | Foundry User on the Foundry account |
| Call the deployment with an API key | The account key (no Azure role required for the call itself; key retrieval requires read access) |

For the full Azure resource provider operation list, the role-to-permission matrix, and the comparison with standard deployments, see [Role-based access control for Microsoft Foundry — managed compute control-plane operations](../../13-manage-and-operate/13.3-security-and-governance/02-rbac-foundry.md#managed-compute-control-plane-operations).

## Troubleshooting

### `provisioningState: Failed`

Confirm that the requested accelerator family has approved quota in the target region, and that the chosen deployment template lists that accelerator family. A mismatched model and deployment template, for example, a template that was published for a different model version, is a common cause. Verify both references resolve to valid registry assets in the `azure-huggingface` registry.

### "Quota exceeded" on create

The Foundry account doesn't have enough managed compute quota in the region for the requested accelerator family. [Request more quota](#request-more-quota). Azure VM quota doesn't apply to managed compute.

### "Insufficient capacity" in the region

The region returned no capacity for the requested accelerator family. Try a different family (for example, deploy on MI300X instead of H100), pick a template with fewer accelerators per instance, or target a different region. Larger-memory families such as MI300X often have capacity for models that don't fit on A100.

### 404 from the `/openai/v1/` route

If a chat-completion request to `https://<account>.services.ai.azure.com/openai/v1/chat/completions` returns 404, verify that:

- The deployment name in the request body matches the deployment you created.
- The deployment's `provisioningState` is `Succeeded`.
- The model's runtime exposes chat completions. Some runtimes (for example, TEI for embeddings) don't expose the chat completions route; use the route documented on the model card instead.

### Deployment stuck in `Creating` for longer than 20 minutes

Some larger models take longer than the typical 10–15 minutes to come up. If `provisioningState` is still `Creating` after 20 minutes, check the deployment details page in the Foundry portal for an operation status message, and confirm that the underlying region hasn't degraded. If the deployment stays in `Creating` past 30 minutes with no operation message, delete it and retry. Provisioning is idempotent on the deployment name.

## Related content

- [Managed compute in Microsoft Foundry](../06.3-offers-deployment-types-and-pricing/03-managed-compute-overview.md)
- [Deployment overview for Microsoft Foundry Models](../06.3-offers-deployment-types-and-pricing/01-deployments-overview.md)
- [Role-based access control for Microsoft Foundry](../../13-manage-and-operate/13.3-security-and-governance/02-rbac-foundry.md)
- [Plan and manage costs for Microsoft Foundry](../06.3-offers-deployment-types-and-pricing/16-manage-costs.md)
- [Manage and increase quotas for resources](../06.2-quota-limits-and-region-availability/02-quota.md)
- [Configure private link for Microsoft Foundry](../../13-manage-and-operate/13.3-security-and-governance/07-configure-private-link.md)
