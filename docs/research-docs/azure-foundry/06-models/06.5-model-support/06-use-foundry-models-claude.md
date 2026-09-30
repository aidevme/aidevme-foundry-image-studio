# Deploy and use Claude models in Microsoft Foundry

| Field | Value |
| --- | --- |
| **Document Title** | Deploy and use Claude models in Microsoft Foundry |
| **Document Location** | `docs/research-docs/azure-foundry/06-models/06.5-model-support/06-use-foundry-models-claude.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Deploy and use Claude models in Microsoft Foundry". Deploy Claude models in Microsoft Foundry and integrate powerful AI into your applications. Discover how to use Claude Mythos, Fable, Opus, Sonnet, and Haiku. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/how-to/use-foundry-models-claude). Article date: 2026-09-21. Page updated: 2026-09-22. Retrieved: 2026-09-29. Navigation: Models > Model support > Anthropic > Deploy and use Claude models.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Anthropic's Claude models bring advanced conversational AI capabilities to Microsoft Foundry, enabling you to build intelligent applications with state-of-the-art language understanding and generation. Claude models excel at complex reasoning, code generation, and multimodal tasks including image analysis.

In this article, you learn how to:

- Deploy Claude models in Microsoft Foundry
- Authenticate by using Microsoft Entra ID or API keys
- Call the Claude Messages API from Python, JavaScript, or REST

For available models, model versions, and capabilities, see [Claude models in Microsoft Foundry](03-claude-models.md). For default quota by subscription type, see [Claude model quotas and rate limits](04-claude-models-quotas-limits.md).

> **Important**
>
> Items marked (preview) in this article are currently in public preview. This preview is provided without a service-level agreement, and we don't recommend it for production workloads. Certain features might not be supported or might have constrained capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Prerequisites

- An Azure subscription with a valid payment method. If you don't have an Azure subscription, create a [paid Azure account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn). See [subscription type and region support](#subscription-type-and-region-support) for more details.
- Access to Microsoft Foundry with appropriate permissions to create and manage resources.
- A [Microsoft Foundry project](../../13-manage-and-operate/13.1-set-up-and-configure/07-create-projects.md) created in a supported deployment location. All Claude models (Hosted on Azure and Hosted on Anthropic infrastructure) support Global Standard deployments. The Hosted on Azure versions of some Claude models are also available for Data Zone Standard (US) deployment. For the exact Azure regions where Claude models are available for deployment, see [Region availability by deployment type](../06.1-explore-foundry-models/03-models-from-partners.md#region-availability-by-deployment-type).
- [Foundry Models from partners and community](../06.1-explore-foundry-models/03-models-from-partners.md) require access to **Azure Marketplace** to create subscriptions. Ensure that you have the [permissions required to subscribe to model offerings](../06.1-explore-foundry-models/03-models-from-partners.md#permissions-required-to-subscribe-to-models-from-partners-and-community).
- **Contributor** or **Owner** role on the resource group to deploy models. For more information, see [Azure RBAC roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles).

## Subscription type and region support

To use Claude models in Microsoft Foundry, you must have a paid Azure subscription with a billing account in a country or region where Anthropic offers the models for purchase. For a list of common subscription-related errors, see [Common error messages and solutions](https://learn.microsoft.com/en-us/marketplace/purchase-saas-offer-in-azure-portal#common-error-messages-and-solutions). The following subscription types are currently not supported:

- Enterprise Accounts located in South Korea
- Cloud Solution Provider subscriptions
- Azure subscriptions that don't have an active pay-as-you-go billing method (for example, student, free trial, or startup credit–based accounts)
- Sponsored subscriptions that only use Azure credits. ***Note**: If you have an account with a credit card on file, the credit card will be charged instead of Azure Credits.*

For a list of supported regions, see [supported geographic locations](https://learn.microsoft.com/en-us/partner-center/marketplace-offers/marketplace-geo-availability-currencies?tabs=g--h--i--j--k#supported-geographic-locations). Note that, Anthropic's "Supported Regions Policy" may apply for the availability in your region, check [supported regions](https://aka.ms/supported_anthropic_regions) for details.

## Use the Claude on Foundry starter kit

To deploy Claude models in Microsoft Foundry using infrastructure-as-code tools, see [Deploy Claude models in Microsoft Foundry using Bicep or Terraform](https://learn.microsoft.com/en-us/azure/developer/ai/how-to/deploy-claude-foundry?context=/azure/foundry/context/context). The article is based on the [Claude on Foundry starter kit](https://github.com/Azure-Samples/claude#readme), and it covers how to provision a Foundry account and project, deploy your chosen Claude model, and configure authentication with Microsoft Entra ID or API keys using Bicep or Terraform automation.

## Deploy Claude models

Deploy a Claude model by following these steps in the Foundry portal:

1. Sign in to [Microsoft Foundry](https://ai.azure.com/?cid=learnDocs). Make sure the **New Foundry** toggle is on. These steps refer to **Foundry (new)**.

   ![](https://learn.microsoft.com/en-us/azure/foundry/media/version-banner/new-foundry.png)
2. From the Foundry portal homepage, select **Discover** in the upper-right navigation, and then select **Models** in the left pane.
3. Select a Claude model and review its details in the model card. If the model is available in both versions, you land on the **Hosted on Azure** (version 2) version of the model by default. You can confirm the version that's open by looking for the **Hosted on** information in the **Quick facts** pane of the model card.

   > **Tip**
   >
   > If your selected Claude model is available in both versions, the model card contains a link that takes you to the alternate version of the model.
4. Select **Deploy** > **Custom settings** to customize your deployment.
5. Read the Azure Marketplace terms, select an industry, and select **Agree and Proceed** to accept the terms to subscribe to Azure Marketplace.
6. If both versions are available, the deployment page has the **Model version** set to version **2: Hosted on Azure** by default. Change this selection to **1: Hosted on Anthropic infrastructure**, if desired.

   > **Note**
   >
   > If you select the **Deploy** > **Default settings** option, your deployment is automatically set to version **2: Hosted on Azure**.
7. Configure other deployment settings:
   - By default, the deployment uses the model name. You can modify this name before deploying. During inference, use the deployment name in the `model` parameter to route requests to this particular deployment.
   - Select the **Region scope**: **Global** (available for all Claude models and versions) or **Data Zone** (if available for your model and version combination).
8. Select **Deploy** to create your deployment.
9. When the deployment completes, you land on the [Foundry Playgrounds](../../05-developer-tools-and-integrations/02-concept-playgrounds.md) where you can interactively test the model. Your project and resource must be in one of the supported regions of deployment for the model.
10. Select the **Details** tab to verify your deployment details and check that the deployment status shows **Succeeded**.

## Call the Claude Messages API

After you deploy a Claude model, interact with it to generate text responses:

- Use the [Anthropic SDKs](https://docs.claude.com/en/api/client-sdks) and the Claude APIs, such as:
  - [Messages API](https://docs.claude.com/en/api/messages): Send a structured list of input messages with text or image content. The model generates the next message in the conversation.
  - [Token Count API](https://docs.claude.com/en/api/messages-count-tokens): Count the number of tokens in a message.

To learn more about the supported APIs, see [Claude models in Microsoft Foundry](03-claude-models.md).

### Send messages with authentication

The following examples show how to send requests to Claude Sonnet 4.6 using Microsoft Entra ID or API key authentication. To work with your deployed model, you need:

- Your base URL, which is of the form `https://<resource name>.services.ai.azure.com/anthropic`.
- Your target URI from your deployment details, which is of the form `https://<resource name>.services.ai.azure.com/anthropic/v1/messages`.
- Microsoft Entra ID for keyless authentication or your deployment's API key for API authentication.
- Deployment name you chose during deployment creation. This name can be different from the model ID.

For advanced features and capabilities of Claude models, see [Claude models in Microsoft Foundry](03-claude-models.md).

**[Python]**

#### Use Microsoft Entra ID authentication

For Messages API endpoints, use your base URL with Microsoft Entra ID authentication.

1. **Install the Azure Identity client library**: Install this library to use the `DefaultAzureCredential`. Authorization is easiest when you use `DefaultAzureCredential` because it finds the best credential to use in its running environment.

   ```bash
   pip install azure-identity
   ```

   Set the values of the client ID, tenant ID, and client secret of the Microsoft Entra ID application as environment variables: `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_CLIENT_SECRET`.

   ```bash
   export AZURE_CLIENT_ID="<AZURE_CLIENT_ID>"
   export AZURE_TENANT_ID="<AZURE_TENANT_ID>"
   export AZURE_CLIENT_SECRET="<AZURE_CLIENT_SECRET>"
   ```
2. **Install dependencies**: Install the Anthropic SDK by using pip (requires Python 3.8 or later).

   ```bash
   pip install -U "anthropic"
   ```
3. **Run a basic code sample** to complete the following tasks:
   1. Create a client with the Anthropic SDK, using Microsoft Entra ID authentication.
   2. Make a basic call to the Messages API. The call is synchronous.

   ```python
   from anthropic import AnthropicFoundry
   from azure.identity import DefaultAzureCredential, get_bearer_token_provider

   baseURL = "https://<resource-name>.services.ai.azure.com/anthropic" # Your base URL. Replace <resource-name> with your resource name
   deploymentName = "claude-sonnet-4-6" # Replace with your deployment name

   # Create token provider for Entra ID authentication
   tokenProvider = get_bearer_token_provider(
       DefaultAzureCredential(), "https://ai.azure.com/.default"
   )

   # Create client with Entra ID authentication
   client = AnthropicFoundry(
       azure_ad_token_provider=tokenProvider,
       base_url=baseURL
   )

   # Send request
   message = client.messages.create(
       model=deploymentName,
       messages=[
           {"role": "user", "content": "What are 3 things to visit in Seattle?"}
       ],
       max_tokens=1048,
       temperature=1,
       thinking={"type":"adaptive"},
       output_config={"effort": "max"},
       stream=False
   )

   print(message.content)
   ```

   **Expected output:** A JSON response containing the model's text completion with three Seattle recommendations.

   **Reference:** [Anthropic Client SDK](https://docs.claude.com/en/api/client-sdks), [DefaultAzureCredential](https://learn.microsoft.com/en-us/python/api/azure-identity/azure.identity.defaultazurecredential)

#### Use API key authentication

> **Important**
>
> Claude **Mythos 5-1**, **Mythos 5**, and **Mythos Preview** support Microsoft Entra ID authentication only.

For Messages API endpoints, use your base URL and API key to authenticate against the service.

1. **Install dependencies**: Install the Anthropic SDK by using pip (requires Python 3.8 or later):

   ```bash
   pip install -U "anthropic"
   ```
2. **Run a basic code sample** to complete the following tasks:
   1. Create a client with the Anthropic SDK by passing your API key to the SDK's configuration. This authentication method lets you interact seamlessly with the service.
   2. Make a basic call to the Messages API. The call is synchronous.

   ```python
   from anthropic import AnthropicFoundry

   baseURL = "https://<resource-name>.services.ai.azure.com/anthropic" # Your base URL. Replace <resource-name> with your resource name
   deploymentName = "claude-sonnet-4-6" # Replace with your deployment name
   apiKey = "YOUR_API_KEY" # Replace YOUR_API_KEY with your API key

   # Create client with API key authentication
   client = AnthropicFoundry(
       api_key=apiKey,
       base_url=baseURL
   )

   # Send request
   message = client.messages.create(
       model=deploymentName,
       messages=[
           {"role": "user", "content": "What are 3 things to visit in Seattle?"}
       ],
       max_tokens=1048,
       temperature=1,
       thinking={"type":"adaptive"},
       output_config={"effort": "max"},
       stream=False
   )

   print(message.content)
   ```

   **Expected output:** A JSON response containing the model's text completion with three Seattle recommendations.

   **Reference:** [Anthropic Client SDK](https://docs.claude.com/en/api/client-sdks)

**[JavaScript]**

#### Use Microsoft Entra ID authentication

For Messages API endpoints, use your base URL with Microsoft Entra ID authentication.

1. **Install the Azure Identity client library**: Install the `@azure/identity` package to use the `DefaultAzureCredential`. Authorization is easiest when you use `DefaultAzureCredential` because it finds the best credential to use in its running environment.

   ```bash
   npm install @azure/identity
   ```

   Set the values of the client ID, tenant ID, and client secret of the Microsoft Entra ID application as environment variables: `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_CLIENT_SECRET`.

   ```bash
   export AZURE_CLIENT_ID="<AZURE_CLIENT_ID>"
   export AZURE_TENANT_ID="<AZURE_TENANT_ID>"
   export AZURE_CLIENT_SECRET="<AZURE_CLIENT_SECRET>"
   ```
2. **Install dependencies**
   1. Install [Node.js](https://nodejs.org/) 20 LTS or later ([non-EOL](https://endoflife.date/nodejs)) versions.
   2. Copy the following lines of text and save them as a file `package.json` inside your folder.

      ```json
      {
        "type": "module",
        "dependencies": {
          "@anthropic-ai/foundry-sdk": "latest",
          "@azure/identity": "latest"
        }
      }
      ```
   3. Open a terminal window in this folder and run `npm install`.
   4. For each of the code snippets that follow, copy the content into a file `sample.js` and run with `node sample.js`.
3. **Run a basic code sample** to complete the following tasks:
   1. Creates a client with the Anthropic SDK, using Microsoft Entra ID authentication.
   2. Makes a basic call to the Messages API. The call is synchronous.

   ```javascript
   import AnthropicFoundry from '@anthropic-ai/foundry-sdk';
   import { getBearerTokenProvider, DefaultAzureCredential } from "@azure/identity";

   const baseURL = "https://<resource-name>.services.ai.azure.com/anthropic"; // Your base URL. Replace <resource-name> with your resource name
   const deploymentName = "claude-sonnet-4-6" // Replace with your deployment name

   // Create token provider for Entra ID authentication
   const tokenProvider = getBearerTokenProvider(
       new DefaultAzureCredential(),
       'https://ai.azure.com/.default');

   // Create client with Entra ID authentication
   const client = new AnthropicFoundry({
       azureADTokenProvider: tokenProvider,
       baseURL: baseURL,
       apiVersion: "2023-06-01"
   });

   // Send request
   const message = await client.messages.create({
       model: deploymentName,
       messages: [{ role: "user", content: "What are 3 things to visit in Seattle?" }],
       max_tokens: 1048,
       temperature: 1,
       thinking: {"type": "adaptive"},
       output_config: {"effort": "max"},
       stream: false
   });
   console.log(message);
   ```

   **Expected output:** A JSON response containing the model's text completion with three Seattle recommendations.

   **Reference:** [Anthropic Client SDK](https://docs.claude.com/en/api/client-sdks), [DefaultAzureCredential](https://learn.microsoft.com/en-us/javascript/api/@azure/identity/defaultazurecredential)

#### Use API key authentication

> **Important**
>
> Claude **Mythos 5-1**, **Mythos 5**, and **Mythos Preview** support Microsoft Entra ID authentication only.

For Messages API endpoints, use your base URL and API key to authenticate against the service.

1. **Install dependencies**
   1. Install [Node.js](https://nodejs.org/) 20 LTS or later ([non-EOL](https://endoflife.date/nodejs)) versions.
   2. Copy the following lines of text and save them as a file `package.json` inside your folder.

      ```json
      {
        "type": "module",
        "dependencies": {
          "@anthropic-ai/foundry-sdk": "latest"
        }
      }
      ```
   3. Open a terminal window in this folder and run `npm install`.
   4. For each of the code snippets that follow, copy the content into a file `sample.js` and run with `node sample.js`.
2. **Run a basic code sample.** This sample completes the following tasks:
   1. Creates a client with the Anthropic SDK by passing your API key to the SDK's configuration. This authentication method lets you interact seamlessly with the service.
   2. Makes a basic call to the Messages API. The call is synchronous.

   ```javascript
   import AnthropicFoundry from '@anthropic-ai/foundry-sdk';

   const baseURL = "https://<resource-name>.services.ai.azure.com/anthropic"; // Your base URL. Replace <resource-name> with your resource name
   const deploymentName = "claude-sonnet-4-6" // Replace with your deployment name
   const apiKey = "<your-api-key>"; // Your API key

   // Create client with API key
   const client = new AnthropicFoundry({
       apiKey: apiKey,
       baseURL: baseURL,
       apiVersion: "2023-06-01"
   });

   // Send request
   const message = await client.messages.create({
       model: deploymentName,
       messages: [{ role: "user", content: "What are 3 things to visit in Seattle?" }],
       max_tokens: 1048,
       temperature: 1,
       thinking: {"type": "adaptive"},
       output_config: {"effort": "max"},
       stream: false
   });
   console.log(message);
   ```

   **Expected output:** A JSON response containing the model's text completion with three Seattle recommendations.

   **Reference:** [AnthropicFoundry SDK](https://docs.claude.com/en/api/client-sdks)

For a list of supported runtimes, see [Requirements to use Anthropic TypeScript API Library](https://github.com/anthropics/anthropic-sdk-typescript#requirements).

**[REST API]**

#### Use Microsoft Entra ID authentication

For Messages API endpoints, use the deployed model's endpoint URI `https://<resource-name>.services.ai.azure.com/anthropic/v1/messages` with Microsoft Entra ID authentication.

If you configure the resource with Microsoft Entra ID support, pass your token in the Authorization header with the format `Bearer $AZURE_AUTH_TOKEN`. Use scope `https://ai.azure.com/.default`. Using Microsoft Entra ID might require additional configuration in your resource to grant access. For more information, see [Configure authentication with Microsoft Entra ID](https://learn.microsoft.com/en-us/azure/ai-foundry/foundry-models/how-to/configure-entra-id?tabs=rest#use-microsoft-entra-id-in-your-code).

1. Export your Microsoft Entra ID token to an environment variable:

   If you're using bash:

   ```bash
   export AZURE_AUTH_TOKEN="<your-entra-id-key>"
   ```

   If you're in PowerShell:

   ```powershell
   $Env:AZURE_AUTH_TOKEN = "<your-entra-id-key>"
   ```

   If you're using Windows command prompt:

   ```
   set AZURE_AUTH_TOKEN = <your-entra-id-key>
   ```
2. Run the following cURL command. For cURL, use your deployment's target URI `https://<resource-name>.services.ai.azure.com/anthropic/v1/messages`.

   ```sh
   curl -X POST https://<resource-name>.services.ai.azure.com/anthropic/v1/messages \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer $AZURE_AUTH_TOKEN" \
     -H "anthropic-version: 2023-06-01" \
     -d '{
       "messages": [
         {
           "role": "user", "content": "You are a helpful assistant."
         },
         {
           "role": "user", "content": "What are 3 things to visit in Seattle?"
         }
       ],
       "max_tokens": 1048,
       "temperature": 1,
       "model": "claude-sonnet-4-6",
       "thinking": {"type":"adaptive"},
       "output_config": {"effort": "max"},
       "stream": false
       }'
   ```

   **Expected output:** A JSON response containing the model's text completion with three Seattle recommendations.

   **Reference:** [Claude Messages API](https://docs.claude.com/en/api/messages)

#### Use API key authentication

> **Important**
>
> Claude **Mythos 5** and **Mythos Preview** support Microsoft Entra ID authentication only.

For Messages API endpoints, use the deployed model's endpoint URI `https://<resource-name>.services.ai.azure.com/anthropic/v1/messages` and API key to authenticate against the service.

1. Export your API key to an environment variable:

   If you're using bash:

   ```bash
   export AZURE_API_KEY="<your-api-key>"
   ```

   If you're in PowerShell:

   ```powershell
   $Env:AZURE_API_KEY = "<your-api-key>"
   ```

   If you're using Windows command prompt:

   ```
   set AZURE_API_KEY = <your-api-key>
   ```
2. Run the following cURL command:

   ```sh
   curl -X POST https://<resource-name>.services.ai.azure.com/anthropic/v1/messages \
     -H "Content-Type: application/json" \
     -H "x-api-key: $AZURE_API_KEY" \
     -H "anthropic-version: 2023-06-01" \
     -d '{
       "messages": [
         {
           "role": "user", "content": "You are a helpful assistant."
         },
         {
           "role": "user", "content": "What are 3 things to visit in Seattle?"
         }
       ],
       "max_tokens": 1048,
       "temperature": 1,
       "model": "claude-sonnet-4-6",
       "thinking": {"type":"adaptive"},
       "output_config": {"effort": "max"},
       "stream": false
       }'
   ```

   **Expected output:** A JSON response containing the model's text completion with three Seattle recommendations.

   **Reference:** [Claude Messages API](https://docs.claude.com/en/api/messages)

## Troubleshooting

The following table lists common errors when you work with Claude models in Foundry and their solutions:

| Error | Cause | Solution |
| --- | --- | --- |
| 401 Unauthorized | Invalid or expired API key, or incorrect Entra ID token scope. | Verify your API key is correct. For Entra ID, confirm you use scope `https://ai.azure.com/.default`. |
| 403 Forbidden | Insufficient permissions on the resource or subscription. | Verify you have **Contributor** or **Owner** role on the resource group. For Entra ID, ensure the **Cognitive Services User** role is assigned. |
| 404 Not Found | Incorrect endpoint URL or deployment name. | Confirm your base URL follows the pattern `https://<resource-name>.services.ai.azure.com/anthropic` and the deployment name matches your configuration. |
| 429 Too Many Requests | Rate limit exceeded for your subscription tier. | Implement exponential backoff with retry logic. Consider reducing request frequency or requesting a [quota increase](https://aka.ms/oai/stuquotarequest). |
| Data retention required (400 `invalid_request_error`) | The model is an Anthropic-designated [Covered Model](https://support.claude.com/en/articles/15425695-covered-models) that requires data retention, but your subscription has zero data retention (ZDR) enabled. The upstream Anthropic message says your "organization or workspace must have data retention enabled," but in Foundry this setting applies to your **subscription**. | Anthropic independently manages data retention for Claude on Azure, so Microsoft can't change this setting for you. To use the model, either work directly with Anthropic to disable ZDR for your subscription, or create a new subscription (as data retention is enabled by default on new subscriptions) and deploy the model there. For background, see [Data retention practices for Covered Models](https://support.claude.com/en/articles/15425996-data-retention-practices-for-covered-models). |
| Subscription eligibility error | Your Azure subscription type or billing region isn't supported, or your subscription tier has a default quota of 0 for the model. | Confirm your subscription has an active pay-as-you-go billing method and a supported billing country/region. See [Subscription type and region support](#subscription-type-and-region-support). For tier-specific default limits, see [Claude model quotas and rate limits](04-claude-models-quotas-limits.md). |
| Region not available | Deployment attempted in an unsupported region. | Deploy to the supported Azure regions for the specific Claude models you're using. For the exact Azure regions where the models are available, see [Region availability by deployment type](../06.1-explore-foundry-models/03-models-from-partners.md#region-availability-by-deployment-type). |
| Requests to Claude Sonnet 4.5 fail when including the `context-1m-2025-08-07` beta header and requesting greater than 200K tokens | The 1M context beta on Claude Sonnet 4.5 was retired on April 30, 2026. Starting May 1, 2026, requests greater than 200K tokens with the `context-1m-2025-08-07` beta header are rejected. | Remove the `context-1m-2025-08-07` beta header from your requests. For workloads that require 1M context, migrate to **Claude Sonnet 4.6** (where 1M context is generally available) or to **Claude Opus 4.6** or **Claude Opus 5** for higher-intelligence workloads. Requests with 200K tokens or fewer to Claude Sonnet 4.5 remain unaffected, even with the header present. |

## Related content

- [Claude models in Microsoft Foundry](03-claude-models.md)
- [Data, privacy, and security for Claude models in Microsoft Foundry (preview)](../../13-manage-and-operate/13.3-security-and-governance/23-data-privacy.md)
- [Claude Consumption Units (CCU) billing in Microsoft Foundry](../../13-manage-and-operate/13.1-set-up-and-configure/20-claude-models-billing.md)
- [Deploy Claude models in Microsoft Foundry using Bicep or Terraform](https://learn.microsoft.com/en-us/azure/developer/ai/how-to/deploy-claude-foundry?context=/azure/foundry/context/context)
- [How to generate text responses with Microsoft Foundry Models](../06.6-develop-with-ai-models/03-generate-responses.md)
- [Explore Microsoft Foundry Models](https://learn.microsoft.com/en-us/azure/foundry-classic/concepts/foundry-models-overview)
- [Claude Docs: Claude in Microsoft Foundry](https://docs.claude.com/en/docs/build-with-claude/claude-in-microsoft-foundry)
