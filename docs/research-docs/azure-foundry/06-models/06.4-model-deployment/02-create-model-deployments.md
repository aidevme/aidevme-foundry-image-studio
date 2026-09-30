# Deploy models using Azure CLI and Bicep

| Field | Value |
| --- | --- |
| **Document Title** | Deploy models using Azure CLI and Bicep |
| **Document Location** | `docs/research-docs/azure-foundry/06-models/06.4-model-deployment/02-create-model-deployments.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Deploy models using Azure CLI and Bicep". Learn how to add and configure Microsoft Foundry Models in your Foundry resource for use in inference applications using Azure CLI and Bicep templates. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/how-to/create-model-deployments). Article date: 2026-08-13. Page updated: 2026-08-14. Retrieved: 2026-09-29. Navigation: Models > Model deployment > Deploy using code.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

In this article, you learn how to add a new model deployment to a Foundry Models endpoint. The deployment is available for inference in your Foundry resource when you specify the deployment name in your requests.

## Prerequisites

To complete this article, you need the following:

- An Azure subscription.
- A Foundry project. This project type is managed under a Foundry resource. If you don't have a Foundry project, see [Create a project for Microsoft Foundry](../../13-manage-and-operate/13.1-set-up-and-configure/07-create-projects.md).
- Azure role-based access control (RBAC) permissions to create and manage deployments. You need the **Cognitive Services Contributor** role or equivalent permissions for the Foundry resource.
- [Foundry Models from partners and community](../06.1-explore-foundry-models/03-models-from-partners.md) require access to **Azure Marketplace**. Ensure you have the [permissions required to subscribe to model offerings](../06.1-explore-foundry-models/03-models-from-partners.md#permissions-required-to-subscribe-to-models-from-partners-and-community). [Foundry Models sold by Azure](../06.1-explore-foundry-models/01-models-sold-directly-by-azure.md) don't have this requirement.
- Install the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/) (version 2.60 or later). The `az cognitiveservices` commands used in this article are part of the core CLI, so no extra extension is required.
- Some commands in this tutorial use the `jq` tool, which might not be installed on your system. For installation instructions, see [Download `jq`](https://stedolan.github.io/jq/download/).
- Identify the following information:
  - Your Azure subscription ID
  - Your Foundry resource name
  - The resource group where you deployed the Foundry resource

**[programming-language-bicep]**

- The model name, provider, version, and SKU you want to deploy. Use the Foundry portal or the Azure CLI to find this information. In this example, you deploy the following model:
  - **Model name**: `Phi-4-mini-instruct`
  - **Provider**: `Microsoft`
  - **Version**: `1`
  - **Deployment type**: Global standard

## Permissions required to subscribe to Models from partners and community

[Foundry Models from partners and community](../06.1-explore-foundry-models/03-models-from-partners.md) available for deployment (for example, Cohere models) require Azure Marketplace. Model providers define the license terms and set the price for use of their models using Azure Marketplace.

When deploying third-party models, ensure you have the following permissions in your account:

- On the Azure subscription:
  - `Microsoft.MarketplaceOrdering/agreements/offers/plans/read`
  - `Microsoft.MarketplaceOrdering/agreements/offers/plans/sign/action`
  - `Microsoft.MarketplaceOrdering/offerTypes/publishers/offers/plans/agreements/read`
  - `Microsoft.Marketplace/offerTypes/publishers/offers/plans/agreements/read`
  - `Microsoft.SaaS/register/action`
- On the resource group—to create and use the SaaS resource:
  - `Microsoft.SaaS/resources/read`
  - `Microsoft.SaaS/resources/write`

The **Owner** and **Contributor** built-in roles on the Azure subscription include these permissions. If you don't have the required permissions, ask your subscription administrator to assign you the **Contributor** role, or [create a custom role](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles) that includes the listed actions.

To verify your permissions, go to the [Azure portal](https://portal.azure.com/), open your subscription, select **Access control (IAM)** > **Check access**, and review your assigned roles.

> **Tip**
>
> `Microsoft.SaaS/register/action` is a one-time registration of the SaaS resource provider on the subscription. After registration, it doesn't need to be repeated for each deployment.

**[programming-language-cli]**

## Add the model

To add a model, first identify the model that you want to deploy. Query the available models as follows:

1. Sign in to your Azure subscription.

   ```azurecli
   az login
   ```
2. If you have more than one subscription, select the subscription where your resource is located.

   ```azurecli
   subscriptionId="<subscription-id>"
   az account set --subscription $subscriptionId
   ```
3. Set the following environment variables with the name of the Foundry resource you plan to use and resource group.

   ```azurecli
   accountName="<ai-services-resource-name>"
   resourceGroupName="<resource-group>"
   location="eastus2"
   ```
4. If you haven't created a Foundry resource yet, create one.

   ```azurecli
   az cognitiveservices account create -n $accountName -g $resourceGroupName --custom-domain $accountName --location $location --kind AIServices --sku S0
   ```

   Reference: [az cognitiveservices account](https://learn.microsoft.com/en-us/cli/azure/cognitiveservices/account)
5. Check which models are available to you and under which SKU. Each [deployment type](../06.3-offers-deployment-types-and-pricing/04-deployment-types.md) is represented by a SKU code in the CLI and ARM, and it defines how Azure infrastructure processes requests. Models might offer different deployment types. The following command lists all the model definitions available:

   ```azurecli
   az cognitiveservices account list-models \
       -n $accountName \
       -g $resourceGroupName \
   | jq '.[] | { name: .name, format: .format, version: .version, sku: .skus[0].name, capacity: .skus[0].capacity.default }'
   ```

   The output includes available models with their properties:

   ```output
   {
     "name": "Phi-4-mini-instruct",
     "format": "Microsoft",
     "version": "1",
     "sku": "GlobalStandard",
     "capacity": 1000
   }
   ```

   Reference: [az cognitiveservices account list-models](https://learn.microsoft.com/en-us/cli/azure/cognitiveservices/account#az-cognitiveservices-account-list-models)
6. Identify the model you want to deploy. You need the properties `name`, `format`, `version`, and `sku`. The property `format` indicates the provider offering the model. Depending on the type of deployment, you might also need capacity.
7. Add the model deployment to the resource. The following example adds `Phi-4-mini-instruct`:

   ```azurecli
   az cognitiveservices account deployment create \
       -n $accountName \
       -g $resourceGroupName \
       --deployment-name Phi-4-mini-instruct \
       --model-name Phi-4-mini-instruct \
       --model-version 1 \
       --model-format Microsoft \
       --sku-capacity 1 \
       --sku-name GlobalStandard
   ```

   Reference: [az cognitiveservices account deployment](https://learn.microsoft.com/en-us/cli/azure/cognitiveservices/account/deployment)
8. Verify the deployment completed successfully:

   ```azurecli
   az cognitiveservices account deployment show \
       --deployment-name Phi-4-mini-instruct \
       -n $accountName \
       -g $resourceGroupName \
   | jq '.properties.provisioningState'
   ```

   The output should display `"Succeeded"`. The model is ready to use after provisioning completes.

   Reference: [az cognitiveservices account deployment show](https://learn.microsoft.com/en-us/cli/azure/cognitiveservices/account/deployment#az-cognitiveservices-account-deployment-show)

You can deploy the same model multiple times if needed as long as you give it a different deployment name. This capability is useful if you want to test different configurations for a given model, including content filters.

**[programming-language-bicep]**

## Add the model

1. Use the template `ai-services-deployment-template.bicep` to describe model deployments:

   **ai-services-deployment-template.bicep**

   ```bicep
   @description('Name of the Azure AI services account')
   param accountName string

   @description('Name of the model to deploy')
   param modelName string

   @description('Version of the model to deploy')
   param modelVersion string

   @allowed([
     'AI21 Labs'
     'Cohere'
     'Core42'
     'DeepSeek'
     'xAI'
     'Meta'
     'Microsoft'
     'Mistral AI'
     'OpenAI'
   ])
   @description('Model provider')
   param modelPublisherFormat string

   @allowed([
       'GlobalStandard'
       'DataZoneStandard'
       'Standard'
       'GlobalProvisioned'
       'Provisioned'
   ])
   @description('Model deployment SKU name')
   param skuName string = 'GlobalStandard'

   @description('Content filter policy name')
   param contentFilterPolicyName string = 'Microsoft.DefaultV2'

   @description('Model deployment capacity')
   param capacity int = 1

   resource modelDeployment 'Microsoft.CognitiveServices/accounts/deployments@2024-04-01-preview' = {
     name: '${accountName}/${modelName}'
     sku: {
       name: skuName
       capacity: capacity
     }
     properties: {
       model: {
         format: modelPublisherFormat
         name: modelName
         version: modelVersion
       }
       raiPolicyName: contentFilterPolicyName == null ? 'Microsoft.Nill' : contentFilterPolicyName
     }
   }
   ```
2. Run the deployment:

   ```azurecli
   resourceGroupName="<resource-group-name>"
   accountName="<ai-services-resource-name>"
   modelName="Phi-4-mini-instruct"
   provider="Microsoft"
   version=1

   az deployment group create \
       --resource-group $resourceGroupName \
       --template-file ai-services-deployment-template.bicep \
       --parameters accountName=$accountName modelName=$modelName modelVersion=$version modelPublisherFormat=$provider
   ```
3. Verify the deployment completed successfully:

   ```azurecli
   az cognitiveservices account deployment show \
       --deployment-name $modelName \
       -n $accountName \
       -g $resourceGroupName \
   | jq '.properties.provisioningState'
   ```

   The output should display `"Succeeded"`.

> **Note**
>
> The remaining sections in this article are identical for both the CLI and Bicep approaches.

## Use the model

You can consume deployed models using the [Endpoints for Foundry Models](../../05-developer-tools-and-integrations/05.4-sdks-and-apis/02-endpoints.md) for the resource. When you construct your request, specify the parameter `model` and insert the model deployment name you created. You can programmatically get the URI for the inference endpoint by using the following code:

**Inference endpoint**

```azurecli
az cognitiveservices account show  -n $accountName -g $resourceGroupName | jq '.properties.endpoints["Azure OpenAI Legacy API - Latest moniker"]'
```

To make requests to the Foundry Models endpoint by using the OpenAI v1 API, call the `/openai/v1/` route on the endpoint URL, `https://<resource-name>.openai.azure.com/openai/v1/` and pass the deployment name in the `model` field of your request. The `/openai/v1/` route uses implicit versioning, so you don't pass an `api-version`.

See the [Azure OpenAI v1 API reference](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/azureopenai/models/) for all supported operations.

**Inference keys**

```azurecli
az cognitiveservices account keys list  -n $accountName -g $resourceGroupName
```

## Manage deployments

Use the CLI to view all available deployments:

1. Run the following command to see all the active deployments:

   ```azurecli
   az cognitiveservices account deployment list -n $accountName -g $resourceGroupName
   ```

   Reference: [az cognitiveservices account deployment list](https://learn.microsoft.com/en-us/cli/azure/cognitiveservices/account/deployment#az-cognitiveservices-account-deployment-list)
2. Run the following command to see the details of a given deployment:

   ```azurecli
   az cognitiveservices account deployment show \
       --deployment-name "Phi-4-mini-instruct" \
       -n $accountName \
       -g $resourceGroupName
   ```

   Reference: [az cognitiveservices account deployment show](https://learn.microsoft.com/en-us/cli/azure/cognitiveservices/account/deployment#az-cognitiveservices-account-deployment-show)
3. Run the following command to delete a given deployment:

   ```azurecli
   az cognitiveservices account deployment delete \
       --deployment-name "Phi-4-mini-instruct" \
       -n $accountName \
       -g $resourceGroupName
   ```

   Reference: [az cognitiveservices account deployment delete](https://learn.microsoft.com/en-us/cli/azure/cognitiveservices/account/deployment#az-cognitiveservices-account-deployment-delete)

## Troubleshooting

| Error | Cause | Resolution |
| --- | --- | --- |
| **Quota exceeded** | Your subscription reached the deployment quota for the selected SKU or region. | Check your quota in the Foundry portal or request an increase through Azure support. |
| **Authorization failed** | The identity used doesn't have the required RBAC role. | Assign the **Cognitive Services Contributor** role on the Foundry resource. |
| **Model not available** | The model isn't available in your region or subscription. | Run `az cognitiveservices account list-models` to check available models and regions. |
| **Command not recognized** | Your Azure CLI is out of date. | Update to version 2.60 or later with `az upgrade`. The `az cognitiveservices` commands are part of the core CLI and don't require a separate extension. |

## Related content

- [Elevated-role tasks in Microsoft Foundry](../../13-manage-and-operate/13.3-security-and-governance/03-administrator-guide.md#deploy-and-manage-models) — role requirements for model deployment and quota management.
- [Generate text responses with Foundry Models](../06.6-develop-with-ai-models/03-generate-responses.md)
- [Deployment types in Foundry Models](../06.3-offers-deployment-types-and-pricing/04-deployment-types.md)
- [Instant access to models in Microsoft Foundry (preview)](../06.3-offers-deployment-types-and-pricing/02-instant-models.md)
- [Deploy Foundry Models to managed compute](01-deploy-foundry-models.md)
- [Quotas and limits for Foundry Models](../06.2-quota-limits-and-region-availability/05-quotas-limits.md)
