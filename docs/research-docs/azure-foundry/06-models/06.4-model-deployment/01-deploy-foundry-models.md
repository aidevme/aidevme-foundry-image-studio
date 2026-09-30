# Deploy Microsoft Foundry Models in the Foundry portal

| Field | Value |
| --- | --- |
| **Document Title** | Deploy Microsoft Foundry Models in the Foundry portal |
| **Document Location** | `docs/research-docs/azure-foundry/06-models/06.4-model-deployment/01-deploy-foundry-models.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Deploy Microsoft Foundry Models in the Foundry portal". Learn how to deploy Microsoft Foundry Models in the Foundry portal for AI inference applications and integration into your projects. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/how-to/deploy-foundry-models). Article date: 2026-07-28. Page updated: 2026-07-28. Retrieved: 2026-09-29. Navigation: Models > Model deployment > Deploy in the portal.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

In this article, you learn how to use the Foundry portal to deploy a Foundry Model in a Foundry resource for inference. Foundry Models include models such as Azure OpenAI models, Meta Llama models, and more. After you deploy a Foundry Model, you can interact with it in the Foundry Playground and use it from code.

This article uses a Foundry Model from partners and community `Llama-4-Scout-17B-16E-Instruct` for illustration. Models from partners and community require that you subscribe to Azure Marketplace before deployment. On the other hand, Foundry Models sold by Azure, such as Azure OpenAI in Foundry Models, don't have this requirement. For more information about Foundry Models, including the regions where they're available for deployment, see [Foundry Models sold by Azure](../06.1-explore-foundry-models/01-models-sold-directly-by-azure.md) and [Foundry Models from partners and community](../06.1-explore-foundry-models/03-models-from-partners.md).

## Prerequisites

To complete this article, you need:

- An Azure subscription with a valid payment method. If you don't have an Azure subscription, create a [paid Azure account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn) to begin.
- The **Cognitive Services Contributor** role or equivalent permissions on the Foundry resource to create and manage deployments. For more information, see [Azure RBAC roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles).
- A [Microsoft Foundry project](../../13-manage-and-operate/13.1-set-up-and-configure/07-create-projects.md). This kind of project is managed under a Foundry resource.
- [Foundry Models from partners and community](../06.1-explore-foundry-models/03-models-from-partners.md) require access to **Azure Marketplace** to create subscriptions. Ensure you have the [permissions required to subscribe to model offerings](../06.1-explore-foundry-models/03-models-from-partners.md#permissions-required-to-subscribe-to-models-from-partners-and-community). [Foundry Models sold by Azure](../06.1-explore-foundry-models/01-models-sold-directly-by-azure.md) don't have this requirement.

## Deploy a model

Deploy a model by following these steps in the Foundry portal:

1. Sign in to [Microsoft Foundry](https://ai.azure.com/?cid=learnDocs). Make sure the **New Foundry** toggle is on. These steps refer to **Foundry (new)**.

   ![](https://learn.microsoft.com/en-us/azure/foundry/media/version-banner/new-foundry.png)
2. From the Foundry portal homepage, select **Discover** in the upper-right navigation, then **Models** in the left pane.
3. Select a model and review its details in the model card. This article uses `Llama-4-Scout-17B-16E-Instruct` for illustration.
4. Select **Deploy** > **Custom settings** to customize your deployment. Alternatively, you can use the default deployment settings by selecting **Deploy** > **Default settings**.
5. For [Foundry Models from partners and community](../06.1-explore-foundry-models/03-models-from-partners.md), you need to subscribe to Azure Marketplace. This requirement applies to `Llama-4-Scout-17B-16E-Instruct`, for example. Read the terms of use and select **Agree and Proceed** to accept the terms.

   > **Note**
   >
   > For [Foundry Models sold by Azure](../06.1-explore-foundry-models/01-models-sold-directly-by-azure.md), such as the Azure OpenAI model `gpt-4o-mini`, you don't subscribe to Azure Marketplace.
6. Configure the deployment settings:
   - By default, the deployment uses the model name. You can modify this name before deploying.
   - During inference, the deployment name is used in the `model` parameter to route requests to this particular deployment.

   Select **Deploy** to create your deployment.

   > **Tip**
   >
   > Each model supports different deployment types, providing different data residency or throughput guarantees. See [deployment types](../06.3-offers-deployment-types-and-pricing/04-deployment-types.md) for more details. In this example, the model supports the Global Standard deployment type.
7. When the deployment completes, you land on the [Foundry Playgrounds](../../05-developer-tools-and-integrations/02-concept-playgrounds.md) where you can interactively test the model. Your project and resource must be in one of the supported regions of deployment for the model. Verify that the deployment status shows **Succeeded** in your deployment list.

## Manage models

You can manage the existing model deployments in the resource by using the Foundry portal.

1. Select **Build** in the upper-right navigation.
2. Select **Models** in the left pane to see the list of deployments in the resource.

From a deployment's detail page, you can view endpoint details and keys, adjust deployment settings, or delete a deployment that you no longer need.

## Test the deployment in the playground

You can interact with the new model in the Foundry portal by using the playground. The playground is a web-based interface that lets you interact with the model in real-time. Use the playground to test the model with different prompts and see the model's responses.

1. From the list of deployments, select the **Llama-4-Scout-17B-16E-Instruct** deployment to open the playground page.
2. Type your prompt and see the outputs.
3. Select the **Code** tab to see details about how to access the model deployment programmatically.

## Use the model with code

To run inference on the deployed model, see the following examples:

- To use the **Responses API with Foundry Models sold by Azure**, such as Microsoft AI, DeepSeek, and Grok models, see [How to generate text responses with Microsoft Foundry Models](../06.6-develop-with-ai-models/03-generate-responses.md).
- To use the **Responses API with OpenAI models**, see [Getting started with the responses API](../06.6-develop-with-ai-models/02-responses.md).
- To use the **Chat completions API with models sold by partners**, such as the Llama model deployed in this article, see [Model support for chat completions](../../05-developer-tools-and-integrations/05.4-sdks-and-apis/04-api-version-lifecycle.md#model-support).

## Regional availability and quota limits of a model

For Foundry Models, the default quota varies by model and region. Certain models might only be available in some regions. For more information on availability and quota limits, see [Azure OpenAI in Microsoft Foundry Models quotas and limits](../06.2-quota-limits-and-region-availability/06-quotas-limits.md) and [Microsoft Foundry Models quotas and limits](../06.2-quota-limits-and-region-availability/05-quotas-limits.md).

## Quota for deploying and running inference on a model

For Foundry Models, deploying and running inference consume quota that Azure assigns to your subscription on a per-region, per-model basis in units of Tokens-per-Minute (TPM). When you sign up for Foundry, you receive default quota for most of the available models. Then, you assign TPM to each deployment as you create it, which reduces the available quota for that model. You can continue to create deployments and assign them TPMs until you reach your quota limit.

When you reach your quota limit, you can only create new deployments of that model if you:

- Request more quota by submitting a [quota increase form](https://aka.ms/oai/stuquotarequest).
- Adjust the allocated quota on other model deployments in the Foundry portal, to free up tokens for new deployments.

For more information about quota, see [Microsoft Foundry Models quotas and limits](../06.2-quota-limits-and-region-availability/05-quotas-limits.md) and [Manage Azure OpenAI quota](https://learn.microsoft.com/en-us/azure/foundry-classic/openai/how-to/quota?tabs=rest).

## Troubleshooting

| Issue | Resolution |
| --- | --- |
| Quota exceeded | [Request more quota](https://aka.ms/oai/stuquotarequest) or reallocate TPM from existing deployments. |
| Region not supported | Check [regional availability](../06.2-quota-limits-and-region-availability/05-quotas-limits.md) and deploy in a supported region. |
| Marketplace subscription error | Verify you have the [required permissions](../06.1-explore-foundry-models/03-models-from-partners.md#permissions-required-to-subscribe-to-models-from-partners-and-community) to subscribe to Azure Marketplace offerings. |
| Deployment status shows **Failed** | Confirm that the model is available in your selected region and that you have sufficient quota. |

## Related content

- [Elevated-role tasks in Microsoft Foundry](../../13-manage-and-operate/13.3-security-and-governance/03-administrator-guide.md#deploy-and-manage-models) — role requirements for model deployment.
- [How to generate text responses with Microsoft Foundry Models](../06.6-develop-with-ai-models/03-generate-responses.md)
- [Deployment types for Foundry Models](../06.3-offers-deployment-types-and-pricing/04-deployment-types.md)
- [Instant access to models in Microsoft Foundry (preview)](../06.3-offers-deployment-types-and-pricing/02-instant-models.md)
- [Deploy models using Azure CLI and Bicep](02-create-model-deployments.md)
- [Azure OpenAI supported programming languages](../../05-developer-tools-and-integrations/05.4-sdks-and-apis/05-supported-languages.md)
