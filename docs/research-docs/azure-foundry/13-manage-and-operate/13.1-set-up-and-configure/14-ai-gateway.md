# Bring your own model to Foundry Agent Service

| Field | Value |
| --- | --- |
| **Document Title** | Bring your own model to Foundry Agent Service |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.1-set-up-and-configure/14-ai-gateway.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Bring your own model to Foundry Agent Service". Connect and bring your own models hosted behind enterprise AI gateways like Azure API Management with Foundry Agent Service. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/ai-gateway). Article date: 2026-07-14. Page updated: 2026-08-28. Retrieved: 2026-09-29. Navigation: Manage and operate > Set up and configure > Agent configuration > Bring your own models with AI gateways.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Foundry Agent Service allows you to connect and use models hosted behind your AI gateways such as **Azure API Management** or other **non-Azure managed AI model gateways**. This capability, called *bring your own model*, allows you to maintain control over your model endpoints while using Foundry agent capabilities.

> **Important**
>
> For purposes of this documentation, *BYOM models* refers to third-party models that you bring to Foundry and does not include Foundry Models sold by Azure. Foundry Agent Service supports the ability to bring your own model (BYOM). If you use Foundry Agent Service to interact with BYOM models, you do so at your own risk. BYOM models are deemed to be Non-Microsoft Products under the Microsoft Product Terms and are governed by their own license terms.
>
> If you use Foundry Agent Service to interact with BYOM models, you are responsible for implementing your own responsible AI mitigations within Foundry Agent Service, such as metaprompt, content filters, or other safety systems.
>
> If you use Foundry Agent Service to interact with BYOM models, you are responsible for ensuring that use of the BYOM model complies with your data handling requirements. You are responsible for reviewing all data being shared with BYOM models and understanding third-party practices for retention and location of data. It is your responsibility to manage whether your data will flow outside of your organization's Azure compliance and geographic boundaries and any related implications when using BYOM models.

This capability enables organizations to:

- Maintain control over model endpoints behind existing enterprise infrastructure.
- Integrate securely with enterprise gateways by using existing security policies.
- Build agents that use models without exposing them publicly.
- Apply compliance and governance requirements to AI model access.

[![Diagram that shows the AI gateway architecture with flows from Agent Service to your gateway and models behind it.](https://learn.microsoft.com/en-us/azure/foundry/agents/media/ai-gateway/gateway.png)](https://learn.microsoft.com/en-us/azure/foundry/agents/media/ai-gateway/gateway.png#lightbox)

In this article, you create a gateway connection to your AI model endpoint, deploy a prompt agent that routes requests through the gateway, and verify the end-to-end flow.

## Prerequisites

- An Azure subscription. [Create one for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- A [Microsoft Foundry project](07-create-projects.md).
- Access credentials for your enterprise AI gateway, such as an API Management subscription key, an API key for another non-Azure AI model gateway, or credentials for an OAuth 2.0 provider using client credentials.
- To manage connections through the command line:
  - [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) version 2.67 or later.
  - [Python 3.10 or later](https://www.python.org/downloads/).
  - The `azure-ai-projects` SDK package (version 2.0.0 or later). For installation steps, see the [quickstart](../../04-get-started/04.1-what-do-you-want-to-build/03-get-started-code.md).

### Required permissions

You need the following role assignments:

| Resource | Required role |
| --- | --- |
| Foundry project | **Foundry User** or higher |
| Resource group (for connection deployment) | **Contributor** |

> **Important**
>
> The Foundry RBAC roles were recently renamed. **Foundry User**, **Foundry Owner**, **Foundry Account Owner**, and **Foundry Project Manager** were previously named Azure AI User, Azure AI Owner, Azure AI Account Owner, and Azure AI Project Manager. You might still see the previous names in some places while the rename rolls out. The role IDs and core permissions are unchanged by the rename.

## Configure the base URL correctly

When you enter **Base URL** in the connection wizard, provide the gateway base path only. Foundry appends the request route based on the model protocol.

| Protocol style | Full endpoint example | Base URL to enter in Foundry |
| --- | --- | --- |
| Azure OpenAI (deployment-based) | `https://<your-ai-services-account>.services.ai.azure.com/openai/deployments/<deployment-name>/chat/completions?api-version=2024-10-21` | `https://<your-ai-services-account>.services.ai.azure.com/openai` |
| OpenAI-compatible v1 API | `https://<your-ai-services-account>.services.ai.azure.com/openai/v1/chat/completions` | `https://<your-ai-services-account>.services.ai.azure.com/openai/v1` |

Current behavior:

- Foundry appends `chat/completions` for OpenAI-compatible chat models.
- For deployment-based routing, Foundry adds `deployments/{deployment-name}` when the connection is configured to use a deployment path.

Example:

If **Base URL** is `https://<your-ai-services-account>.services.ai.azure.com/openai/v1`, Foundry calls `https://<your-ai-services-account>.services.ai.azure.com/openai/v1/chat/completions`.

## Choose the correct API key and header

If you select **API key** authentication, use the key source and header format that match your topology:

| Connection pattern | API key to provide | API key header name |
| --- | --- | --- |
| Direct model endpoint in a Foundry project (without API Management or another gateway) | Use the project API key for your Foundry project endpoint. | `api-key` |
| Azure API Management gateway | In the Azure portal, open your API Management resource, then go to **APIs** > **Subscriptions** > your project subscription, and copy the subscription key. | Use the header expected by your API Management policy or API definition. |
| External gateway (non-Azure) | Use the API key issued by that gateway provider. | Use the header required by the gateway documentation. |

**[foundry-portal]**

## Create a model connection

Use the Foundry portal to create a connection to your model.

You can choose models behind either an existing Azure API Management resource or a non-Azure AI model gateway. By using these steps, you can add several models implementing the OpenAI chat completions API.

To add a model connection in the Foundry portal:

**[API Management]**

1. Sign in to [Microsoft Foundry](https://ai.azure.com/).
2. Select **Manage**, and then select **Resource details**.
3. Select the **Admin-connected models** tab, and then select **Add**. ![Screenshot of external models in the Foundry portal.](https://learn.microsoft.com/en-us/azure/foundry/agents/media/ai-gateway/add-model-connection.png)

   The **Add model connection** wizard opens.
4. On the **Connection Type** page, select **Azure API Management**, select an existing **Azure API Management** resource, and then enter the **Base URL** for the gateway that exposes your models. The models must implement the OpenAI-compatible chat completions API.

   ![Screenshot of selecting an API Management resource in the Foundry portal.](https://learn.microsoft.com/en-us/azure/foundry/agents/media/ai-gateway/add-api-management-model.png)
5. On the **Authentication** page, select an option to authenticate to API Management.

   Select either **API key** such as an API Management subscription key, or **Managed Identity** if one is configured in your Foundry project.
   - **API key**: Enter the key in the **API key** field. In **API key header name**, enter the header that carries the key, such as `Authorization`. In **API key header value**, enter the scheme for the header value, such as `{api_key}` or `Bearer {api_key}`.
   - **Managed Identity**: In **Audience**, enter the target service for the managed identity token, such as `https://cognitiveservices.azure.com/`. For required API Management setup, see [Configure managed identity authentication for API Management](#configure-managed-identity-authentication-for-api-management).
6. On the **Model configuration** page, configure at least one model that appears in Foundry for use with agents.
   1. Select **+ Add model**.
   2. In **Name**, enter the model name used in API calls. For Microsoft Foundry models, use the deployment name.
   3. In **Display name**, enter the name to show in the Foundry portal.
   4. Optionally, in **Version**, enter a version to append to the model name in API calls.
   5. Select **Save**.

   Repeat the preceding steps to add more models to the connection if needed.

   ![Screenshot of the Model configuration page in the Add model connection wizard.](https://learn.microsoft.com/en-us/azure/foundry/agents/media/ai-gateway/add-model-configuration.png)
7. On the **Advanced** page, optionally do the following steps:
   1. Enter an **API version** if required by your model deployments.
   2. Enable the **Include deployment name in URL path** setting if your gateway exposes the chat completions API on an Azure OpenAI-style path that includes the deployment name (for example, `/deployments/{deploymentName}/chat/completions`). Leave the setting disabled if your gateway uses an OpenAI-style path without the deployment name (for example, `/chat/completions`) and relies on other routing mechanisms to direct requests to the correct model deployment.
   3. Select **+ Add header** to add a static header that should be included in requests to the gateway. Repeat to add multiple headers if needed.

   ![Screenshot of the Advanced page in the Add model connection wizard.](https://learn.microsoft.com/en-us/azure/foundry/agents/media/ai-gateway/add-model-advanced.png)
8. Select **Add**.

### Configure managed identity authentication for API Management

To configure **Managed Identity** authentication to API Management, complete the following setup in Azure:

1. Enable managed identity on the Foundry project resource.
   1. In the [Azure portal](https://portal.azure.com/), go to your Foundry resource.
   2. Go to **Projects** > select your project > **Identity**.
   3. Enable either:
      - **System assigned** managed identity, or
      - **User assigned** managed identity.
   4. For token validation in API Management, get the application (client) ID of the managed identity.
      1. First, get the managed identity *object ID* from the managed identity configuration in your project.
      2. Search that object ID in Microsoft Entra ID enterprise applications to locate the corresponding application (client) ID.
2. Validate the managed identity token in API Management.

   In your API Management inbound policy, use the [validate-azure-ad-token](https://learn.microsoft.com/en-us/azure/api-management/validate-azure-ad-token-policy) policy to enforce token validation for requests from Microsoft Foundry.
   - Set the `audience` element to the same value you configured in the Foundry connection **Audience** field.
   - Configure the managed identity app ID in `client-application-ids`.

   Example:

   ```xml
   <validate-azure-ad-token tenant-id="{{your-tenant-id}}" header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized">
      <client-application-ids>
         <application-id>{{managed-identity-client-id}}</application-id>
      </client-application-ids>
      <audiences>
         <audience>{{audience-configured-in-foundry-connection}}</audience>
      </audiences>
   </validate-azure-ad-token>
   ```

**[Other source]**

1. Sign in to [Microsoft Foundry](https://ai.azure.com/).
2. Select **Manage**, and then select **Resource details**.
3. Select the **Admin-connected models** tab, and then select **Add**. ![Screenshot of external models in the Foundry portal.](https://learn.microsoft.com/en-us/azure/foundry/agents/media/ai-gateway/add-model-connection.png)

   The **Add model connection** wizard opens.
4. On the **Connection Type** page, select **Other source** to connect to a self-hosted, non-Azure hosted, or custom solution.
   1. Enter a **Connection name** of your choice.
   2. In **Base URL**, enter a URL to the gateway for your model endpoints. The URL can include a specific path if needed.

   ![Screenshot of selecting another model source in the Foundry portal.](https://learn.microsoft.com/en-us/azure/foundry/agents/media/ai-gateway/add-other-model.png)
5. On the **Authentication** page, select either **API key** or **OAuth 2.0** to authenticate to the gateway.
   - **API key**: Enter the key in the **API key** field. In **API key header name**, enter the header that carries the key, such as `Authorization`. In **API key header value**, enter the scheme for the header value, such as `{api_key}` or `Bearer {api_key}`.
   - **OAuth 2.0**: Enter details from an app registered in the identity provider, such as client ID, client secret, token URL endpoint, and default scope.

   ![Screenshot of the Authentication page in the Add model connection wizard.](https://learn.microsoft.com/en-us/azure/foundry/agents/media/ai-gateway/add-model-authentication.png)
6. On the **Model configuration** page, configure at least one model that appears in Foundry for use with agents.
   1. Select **+ Add model**.
   2. In **Name**, enter the model name used in API calls. For Microsoft Foundry models, use the deployment name.
   3. In **Display name**, enter the name to show in the Foundry portal.
   4. Optionally, in **Version**, enter a version to append to the model name in API calls.
   5. Select **Save**.

   Repeat the preceding steps to add more models to the connection if needed.

   ![Screenshot of the Model configuration page in the Add model connection wizard.](https://learn.microsoft.com/en-us/azure/foundry/agents/media/ai-gateway/add-model-configuration.png)
7. On the **Advanced** page, optionally do the following steps:
   1. Enter an **API version** if required by your model deployments.
   2. Enable the **Include deployment name in URL path** setting if your gateway exposes the chat completions API on an Azure OpenAI-style path that includes the deployment name (for example, `/deployments/{deploymentName}/chat/completions`). Leave the setting disabled if your gateway uses an OpenAI-style path without the deployment name (for example, `/chat/completions`) and relies on other routing mechanisms to direct requests to the correct model deployment.
   3. Select **+ Add header** to add a static header that should be included in requests to the gateway. Repeat to add multiple headers if needed.

   ![Screenshot of the Advanced page in the Add model connection wizard.](https://learn.microsoft.com/en-us/azure/foundry/agents/media/ai-gateway/add-model-advanced.png)
8. Select **Add**.

The connection is created and appears in the list on the **Admin-connected models** tab.

### Admin-connected model deployments

Foundry automatically deploys models you add through a connection, so you can use them in your projects.

- Each model you add in the connection wizard corresponds to a *deployment* in Foundry.
- You can select an admin-connected deployment when configuring an agent's model. Foundry automatically routes requests from agents to these deployments through the connected gateway.

**[azure-cli]**

## Create a model connection

Use the Azure CLI to create a connection to models behind your AI gateway.

Agent Service supports two connection types: **API Management** connections and **Model Gateway** connections.

Choose the connection type that matches your gateway:

| Connection type | Use when | Category value |
| --- | --- | --- |
| **API Management** | You already use Azure API Management for model routing and want intelligent API Management defaults. | `ApiManagement` |
| **Model Gateway** | You use OpenAI, MuleSoft, or a custom gateway and need static or dynamic model discovery. | `ModelGateway` |

For detailed connection specifications, see the [connection samples on GitHub](https://github.com/microsoft-foundry/foundry-samples/blob/main/infrastructure/infrastructure-setup-bicep/01-connections/apim-and-modelgateway-integration-guide.md).

### Deploy the connection

1. Clone or download the [Foundry samples repository](https://github.com/microsoft-foundry/foundry-samples) and locate the Bicep template for your connection type under `infrastructure/infrastructure-setup-bicep/01-connections/`. The directory contains separate Bicep files and parameter files for API Management and Model Gateway connections.
2. Deploy the connection by running `az deployment group create` with your resource group, the Bicep template file, and the corresponding parameters file. Replace the placeholder values in the parameters file with your gateway endpoint URL and credentials before deploying. For the full command reference, see [az deployment group create](https://learn.microsoft.com/en-us/cli/azure/deployment/group#az-deployment-group-create).

   > **Tip**
   >
   > A successful deployment returns `provisioningState: Succeeded` in the command output.
3. Verify the connection in the Foundry portal. Go to the [Foundry portal](https://ai.azure.com/), select **Manage**, select **Resource details**, and then select the **Admin-connected models** tab. The new connection appears in the list with the models you configured.

## Create a prompt agent with the model connection

After creating the connection, create and run a prompt agent that uses models behind your gateway. The key difference from a standard agent is the model deployment name format: `<connection-name>/<model-name>`.

1. Set the following environment variables:

   | Variable | Value | Example |
   | --- | --- | --- |
   | `FOUNDRY_PROJECT_ENDPOINT` | Your project endpoint URL | `https://<your-ai-services-account>.services.ai.azure.com/api/projects/<project-name>` |
   | `FOUNDRY_MODEL_DEPLOYMENT_NAME` | `<connection-name>/<model-name>` | `my-apim-connection/gpt-4o` |
2. Initialize an `AIProjectClient` with your endpoint and `DefaultAzureCredential`, then call `agents.create_version()` with a `PromptAgentDefinition`. Set the `model` parameter to the `FOUNDRY_MODEL_DEPLOYMENT_NAME` value.

   A successful call returns an agent object with its `id`, `name`, and `version` fields populated.
3. Get the OpenAI client with `project.get_openai_client()`, create a conversation with `conversations.create()`, and send a request with `responses.create()`. Pass the agent reference in `extra_body` as `{"agent_reference": {"name": agent.name, "type": "agent_reference"}}`.

   A successful response returns the model's reply text, confirming the agent is routing through your gateway.

   > **Note**
   >
   > If the response fails with a `model not found` error, verify the `FOUNDRY_MODEL_DEPLOYMENT_NAME` value uses the format `<connection-name>/<model-name>`.
4. Clean up by deleting the conversation and agent version when testing is complete.

For a complete working example, see the [agent SDK samples on GitHub](https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/ai/azure-ai-projects/samples/agents). For API details, see [AIProjectClient](https://learn.microsoft.com/en-us/python/api/azure-ai-projects/azure.ai.projects.aiprojectclient) and [PromptAgentDefinition](https://learn.microsoft.com/en-us/python/api/azure-ai-projects/azure.ai.projects.models.promptagentdefinition).

## Verify the deployment

After deploying your agent, confirm that the full pipeline works correctly:

1. **Check connection status** — In the Foundry portal, select **Manage**, select **Resource details**, and then select the **Admin-connected models** tab. Verify the connection appears in the list. If it's missing, check the gateway endpoint URL and credentials.
2. **Send a test prompt** — Use the SDK to create a conversation and send a request as described in the previous section. A successful response returns the model's reply text, confirming the agent can reach the model through your gateway.
3. **Review gateway logs** — Confirm requests are routed correctly. For API Management, check **API Management analytics** in the Azure portal. For other gateways, review your gateway's request logging. You should see incoming requests from the Agent Service endpoint.

> **Tip**
>
> If any step fails, see the [Troubleshoot common issues](#troubleshoot-common-issues) section for resolution steps.

**[azure-cli]**

## Connection type details

This section provides reference details about each connection type and their configuration options.

### API Management connection

API Management connections provide intelligent defaults and follow API Management standard conventions:

| Setting | Default value |
| --- | --- |
| List Deployments endpoint | `/deployments` |
| Get Deployment endpoint | `/deployments/{deploymentName}` |
| Provider | `AzureOpenAI` |

Configuration priority:

1. Explicit metadata values (highest priority).
2. API Management standard defaults (fallback).

Authentication methods:

- **API Key** — Standard subscription key authentication.
- **Microsoft Entra ID** — Enterprise identity integration.

### Model Gateway connection

Model Gateway connections provide a unified interface for connecting to various AI model providers. These connections support both static and dynamic model discovery:

- **Static discovery** — Models are predefined in the connection metadata. Best for fixed deployments and enterprise-approved model lists.
- **Dynamic discovery** — Models are discovered at runtime using API endpoints. Best for frequently changing deployments and provider-managed catalogs.

Supported authentication types are API key and OAuth 2.0. API keys are stored securely and referenced through the credential system.

## Troubleshoot common issues

| Issue | Resolution |
| --- | --- |
| Connection shows **Inactive** status | Verify the gateway endpoint URL is reachable and authentication credentials are valid. |
| Agent returns `model not found` error | Confirm the `FOUNDRY_MODEL_DEPLOYMENT_NAME` value uses the correct format: `<connection-name>/<model-name>`. |
| Timeout errors from the gateway | Check that your gateway endpoints are accessible from the Agent Service network. For private networks, see the network isolation guidance in the Limitations section. |
| Authentication failures | For API Management, verify your subscription key. For Model Gateway, verify the API key or OAuth 2.0 configuration. |

### Enable Application Insights logging in API Management

1. In the Azure portal, go to your API Management resource.
2. Select **Monitoring** > **Application Insights**.
3. Select **+ Add**.
4. Select your Application Insights resource, and then select **Create**.
5. Select **APIs** > **All APIs** > **Settings**.
6. Find **Diagnostic Logs** for Application Insights, and enable it.
7. Set sampling to `100%` for testing.
8. Set **Always log errors** to **Yes**.
9. Set verbosity to **Information**.
10. Select **Save**.
11. Send a few test calls to your API Management endpoint.

### See logs

In Application Insights, open **Logs** and run these queries.

Incoming requests:

```kusto
requests
| order by timestamp desc
| take 100
```

API Management backend calls:

```kusto
dependencies
| project timestamp, name, target, data, resultCode, duration
| order by timestamp desc
```

Exceptions:

```kusto
exceptions
| order by timestamp desc
```

Custom or API Management traces:

```kusto
traces
| order by timestamp desc
```

### For detailed API Management gateway logs

You can also send gateway diagnostics to Log Analytics for deeper gateway-level investigation.

1. In API Management, select **Monitoring** > **Diagnostic settings**.
2. Select **Add diagnostic setting**.
3. Send logs to a **Log Analytics workspace**.

Then run:

```kusto
ApiManagementGatewayLogs
| order by TimeGenerated desc
| take 100
```

Application Insights is best for request and dependency tracing. `ApiManagementGatewayLogs` is best for detailed gateway-level diagnostics.

## Supported configurations

- Only prompt agents in the Agent SDK support this feature.
- The Response API isn't supported at present.
- Supported agent tools: Code Interpreter, Functions, File Search, OpenAPI, Foundry IQ, SharePoint Grounding, Fabric Data Agent, MCP, and Browser Automation.
- Supported networking configurations:
  - Public networking is supported for both API Management and self-hosted gateways.
  - For full network isolation:
    - **API Management as your AI gateway**: Deploy Foundry and API Management together using [this GitHub template](https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-bicep/16-private-network-standard-agent-apim-setup).
    - **Self-hosted gateway**: Ensure your gateway endpoints are accessible inside the virtual network used by Agent Service.

## Related content

- [Foundry Agent Service overview](../../07-agents/01-overview.md)
- [Agent environment setup](08-environment-setup.md)
- [Create a Foundry project](07-create-projects.md)
- [Agent SDK samples on GitHub](https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/ai/azure-ai-projects/samples/agents)
- [API Management and model gateway integration guide](https://github.com/microsoft-foundry/foundry-samples/blob/main/infrastructure/infrastructure-setup-bicep/01-connections/apim-and-modelgateway-integration-guide.md)
- [Enforce token limits with AI Gateway](https://learn.microsoft.com/en-us/azure/ai-foundry/configuration/enable-ai-api-management-gateway-portal)
