# Migrate from GitHub Models to Microsoft Foundry Models

| Field | Value |
| --- | --- |
| **Document Title** | Migrate from GitHub Models to Microsoft Foundry Models |
| **Document Location** | `docs/research-docs/azure-foundry/06-models/06.4-model-deployment/03-quickstart-github-models.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Migrate from GitHub Models to Microsoft Foundry Models". GitHub Models was retired on July 30, 2026. Learn how to migrate your application to Microsoft Foundry Models for production-ready AI applications. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/how-to/quickstart-github-models). Article date: 2026-08-19. Page updated: 2026-08-20. Retrieved: 2026-09-29. Navigation: Models > Model deployment > Migrate from GitHub Models.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

> **Important**
>
> GitHub Models retired on July 30, 2026. The playground, model catalog, inference API, and bring your own key (BYOK) support are no longer available to any customer. For more information, see [GitHub Models](https://docs.github.com/en/github-models/) in the GitHub documentation.
>
> If your application still calls the GitHub Models inference endpoint, migrate it to Microsoft Foundry Models by following the steps in this article. GitHub Models was a separate service from GitHub Copilot and is unrelated to GitHub Copilot.

In this article, you learn how to move a generative AI application from the retired GitHub Models service to Microsoft Foundry Models by deploying a Foundry Tools resource in an Azure subscription. Both services use the same inference API, so you typically only need to change the endpoint and credentials in your code.

## Prerequisites

You need:

- An Azure subscription with a valid payment method. If you don't have an Azure subscription, create a [paid Azure account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn) to begin.
- [Foundry Models from partners and community](../06.1-explore-foundry-models/03-models-from-partners.md) require access to **Azure Marketplace**. Ensure you have the [permissions required to subscribe to model offerings](../06.1-explore-foundry-models/03-models-from-partners.md#permissions-required-to-subscribe-to-models-from-partners-and-community). [Foundry Models sold by Azure](../06.1-explore-foundry-models/01-models-sold-directly-by-azure.md) don't have this requirement.

## Migrate to Foundry Models

Unlike GitHub Models, which was free with rate limits, Foundry Models usage is billed to your Azure subscription based on the [deployment type](../06.3-offers-deployment-types-and-pricing/04-deployment-types.md) you choose.

To replace your GitHub Models endpoint and token with a Foundry Models endpoint and key:

1. Sign in to the [Foundry portal](https://ai.azure.com/) with your Azure account.

   > **Tip**
   >
   > If you land in the Foundry (classic) experience, toggle the **New Foundry** switcher in the upper-right navigation to switch to the new Foundry experience.
2. Follow the steps in [Deploy a model](01-deploy-foundry-models.md#deploy-a-model) to deploy the model of your choice, test it in the Playground, and inference the deployed model with code.
3. On the Foundry homepage, copy the **API key** and **Project endpoint**, and use them in place of the GitHub Models endpoint and personal access token in your application.
4. Verify the migration works by sending a test prompt from the Playground or from your code. If you receive a response, your model is ready to use.

> **Important**
>
> Unlike GitHub Models, where all the models were already configured, the Foundry Tools resource allows you to control which models are available in your endpoint and under which configuration. Add as many models as you plan to use before indicating them in the `model` parameter. Learn how to [add more models](02-create-model-deployments.md) to your resource.

## Use your Foundry models in the IDE

The GitHub Models playground is no longer available. To experiment with models from your editor, add your Foundry deployment to Visual Studio Code as a bring your own key (BYOK) language model:

1. In Visual Studio Code, open the model picker in the Chat view and select **Manage Language Models** (gear icon), or run the **Chat: Manage Language Models** command from the Command Palette.
2. Select **Add Models**, and then select **Azure** from the provider list.
3. Enter a group name for the models, and then enter the endpoint URL and API key that you copied from the Foundry portal.
4. Select the model from the model picker in chat.

Alternatively, select **Install Model Providers** in the Language Models editor and install the [Foundry Toolkit for VS Code](https://aka.ms/AIToolkit) extension, which adds Foundry's cloud-hosted and local models to the model picker.

For more information, see [Language models in Visual Studio Code](https://code.visualstudio.com/docs/agent-customization/language-models#_add-a-model-from-a-built-in-provider).

## Explore additional features

Foundry Models supports features that GitHub Models didn't offer:

- **[Model catalog](https://ai.azure.com/explore/models)** — Browse, compare, and evaluate models from Azure, partners, and the open-source community.
- **[Keyless authentication](../../13-manage-and-operate/13.3-security-and-governance/05-configure-entra-id.md)** — Use Microsoft Entra ID for token-based authentication without managing API keys.
- **[Content filtering](https://learn.microsoft.com/en-us/azure/foundry-classic/foundry-models/concepts/content-filter)** — Configure content safety filters for your deployments.
- **Rate limiting** — Set custom rate limits for specific models in your resource.
- **[Deployment types](../06.3-offers-deployment-types-and-pricing/04-deployment-types.md)** — Choose from multiple deployment SKUs such as pay-per-token, provisioned, and batch.

## Troubleshoot common issues

| Issue | Resolution |
| --- | --- |
| Requests to the GitHub Models endpoint fail | The GitHub Models inference API was retired on July 30, 2026. Point your application at a Foundry Models endpoint as described in this article. |
| Model not available in your region | Check the model's region availability by selecting **View availability** in the **Quick facts** section of its model card. Switch to a project in a supported region. |
| Authentication error after key swap | Verify you copied the correct key from the Foundry portal. On the Foundry homepage, copy the **API key** and **Project endpoint** to view your key and endpoint. |
| Rate limit errors after migrating | Foundry Models rate limits depend on your [deployment type](../06.3-offers-deployment-types-and-pricing/04-deployment-types.md). Scale up or choose a higher-throughput deployment. |

## Related content

- [Deploy Microsoft Foundry Models in the Foundry portal](01-deploy-foundry-models.md)
- [Create model deployments](02-create-model-deployments.md)
- [Deployment types for Foundry Models](../06.3-offers-deployment-types-and-pricing/04-deployment-types.md)
