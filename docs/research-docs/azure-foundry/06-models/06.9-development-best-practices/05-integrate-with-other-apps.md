# Integrate Microsoft Foundry with your applications (Microsoft or third-party services)

| Field | Value |
| --- | --- |
| **Document Title** | Integrate Microsoft Foundry with your applications (Microsoft or third-party services) |
| **Document Location** | `docs/research-docs/azure-foundry/06-models/06.9-development-best-practices/05-integrate-with-other-apps.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Integrate Microsoft Foundry with your applications (Microsoft or third-party services)". Learn how to choose a Microsoft Foundry integration pattern, retrieve endpoints, and send your first REST API request with authentication. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/integrate-with-other-apps). Article date: 2026-08-27. Page updated: 2026-08-28. Retrieved: 2026-09-29. Navigation: Models > Development best practices > Integrate with your applications.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Microsoft Foundry is a developer platform that lets you embed AI models, agents, evaluation tools, and Responsible AI capabilities into your workflows and applications. You can build complete solutions in Foundry or selectively integrate its features into your custom apps and Microsoft or partner solutions.

In this article, you learn how to choose an integration pattern and send your first REST API request to a Foundry endpoint.

## Prerequisites

- An Azure subscription. [Create one for free](https://azure.microsoft.com/free/).
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli). Run `az login`, and then run `az account show` to verify your active subscription.
- A [Foundry project](../../13-manage-and-operate/13.1-set-up-and-configure/07-create-projects.md). Note your resource endpoint (for example, `https://{resource}.services.ai.azure.com`).
- A [deployed model](../06.4-model-deployment/01-deploy-foundry-models.md) for inference calls.
- Authentication credentials: either a [Microsoft Entra ID token](../../13-manage-and-operate/13.3-security-and-governance/02-rbac-foundry.md) or an API key from the Foundry portal.

## Choose an integration pattern

Foundry supports multiple integration patterns:

- Low-code connectors for software as a service (SaaS) platforms like Power Platform
- Direct REST API integration for full control
- API gateway mediation for centralized management

The following sections describe each pattern.

### Use connector-based integration

Use this pattern when your platform natively supports built-in integration to Foundry or Azure OpenAI (for example when using Microsoft Power Platform or Logic Apps).

- **Power Platform**: Use the [Azure OpenAI connector](https://learn.microsoft.com/en-us/connectors/azureopenai/) in Power Apps, Power Automate, or Logic Apps.
- **Third-party platforms**: Various third-party software vendors provide prebuilt Azure OpenAI or Foundry modules for chat, image generation, and transcription.

### Call the REST API directly

Use direct REST calls when you're building your own application or when you need full control over HTTP calls. Choose between Foundry endpoint variants to access agentic or cross-model provider APIs, or use Azure OpenAI endpoint if your integration expects OpenAI v1 semantics.

- **Foundry endpoint** for stateless API integration such as model inference:

  ```REST
  POST https://{resource}.services.ai.azure.com/api/
  ```
- **Foundry project endpoint** for stateful APIs such as agent service:

  ```REST
  POST https://{resource}.services.ai.azure.com/api/projects/{projectname}/
  ```
- **OpenAI v1-compatible route** for applications that expect the OpenAI API shape:

  ```REST
  POST https://{resource}.openai.azure.com/openai/v1/
  ```

  > **Important**
  >
  > Don't use the Foundry Model Inference API (`https://<resource>.services.ai.azure.com/models` path) for new integrations. The Azure AI Inference beta SDK retired on August 26, 2026. Use the OpenAI v1-compatible route instead. For details, see the [migration guide](../../13-manage-and-operate/13.1-set-up-and-configure/06-model-inference-to-openai-migration.md).

### Route through an API gateway

To establish a single entry point across multiple model hosts, use [Azure API Management (APIM)](https://learn.microsoft.com/en-us/azure/api-management/) as an AI gateway to centralize authentication, quota governance, and routing.

1. Place APIM in front of Foundry or Azure OpenAI endpoints.
2. Apply policies for authentication, token budgets, semantic caching, and routing.

To learn more, see [API Management for AI](https://learn.microsoft.com/en-us/azure/api-management/azure-ai-foundry-api).

### Enrich data pipelines

1. Use Microsoft Fabric notebooks or pipelines to invoke models for batch or streaming enrichment.
2. Write results back to OneLake for downstream analytics and governance.

To learn more, see [Foundry in Fabric](https://learn.microsoft.com/en-us/fabric/data-science/ai-services/ai-services-overview).

## Send a REST API request

Foundry supports direct HTTP calls for scenarios where you need full control. Use the REST API when:

- Your tool doesn't have a native Foundry or Azure OpenAI connector.
- You want to embed calls in scripts, automation pipelines, or custom adapters.
- You need compatibility with OpenAI v1 for third-party SDKs or connectors.

To call the API:

1. Choose the correct endpoint shape:
   - **Foundry API** (`services.ai.azure.com`) for a model-provider agnostic schema and access to Foundry-exclusive features.
   - **OpenAI v1 compatibility** for tools expecting OpenAI request/response schema.
2. Include authentication headers:
   - `Authorization: Bearer {entra-token}` for Microsoft Entra ID authentication (recommended).
   - `api-key: {your-key}` for API key authentication.
3. Send a JSON payload with your model name and messages.

For full schema details, see:

- [Swagger for Foundry REST API](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/?view=rest-microsoft-foundry-v1-preview&preserve-view=true)
- [Swagger for OpenAI v1 compatibility](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/?view=rest-microsoft-foundry-v1&preserve-view=true)

The following examples use Microsoft Entra ID authentication. Replace the placeholder values with your own.

**[Foundry]**

Replace YOUR-FOUNDRY-RESOURCE-NAME and YOUR-PROJECT-NAME with your values. This example calls the Responses API:

```console
export AZURE_AI_AUTH_TOKEN=$(az account get-access-token --resource https://ai.azure.com --query accessToken -o tsv)
```

Verify that the command returned a token:

```console
test -n "$AZURE_AI_AUTH_TOKEN" && echo "Authentication token acquired."
```

```console
curl -X POST https://YOUR-FOUNDRY-RESOURCE-NAME.services.ai.azure.com/api/projects/YOUR-PROJECT-NAME/openai/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AZURE_AI_AUTH_TOKEN" \
-d '{
        "model": "gpt-5-mini",
        "input": "What is the size of France in square miles?"
}'
```

**[OpenAI v1]**

Replace YOUR-FOUNDRY-RESOURCE-NAME and YOUR-DEPLOYMENT-NAME with your values. This example calls the chat completions API:

```console
export AZURE_AI_AUTH_TOKEN=$(az account get-access-token --resource https://cognitiveservices.azure.com --query accessToken -o tsv)

test -n "$AZURE_AI_AUTH_TOKEN" && echo "Authentication token acquired."

curl -sS -X POST \
  "https://YOUR-FOUNDRY-RESOURCE-NAME.openai.azure.com/openai/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AZURE_AI_AUTH_TOKEN" \
  -d '{
    "model": "YOUR-DEPLOYMENT-NAME",
    "messages": [
      {"role":"system","content":"You are a helpful assistant."},
      {"role":"user","content":"What is the size of France in square miles?"}
    ]
  }'
```

A successful response returns a JSON payload:

**[Foundry]**

```json
{
  "id": "<response-id>",
  "object": "response",
  "model": "gpt-4.1-mini",
  "status": "completed",
  "output": [
    {
      "type": "message",
      "role": "assistant",
      "content": [
        {
          "type": "output_text",
          "text": "The size of France is approximately 248,573 square miles."
        }
      ],
      "status": "completed"
    }
  ],
  "usage": {
    "input_tokens": 17,
    "output_tokens": 14,
    "total_tokens": 31
  }
}
```

**[OpenAI v1]**

```json
{
  "id": "<chat-completion-id>",
  "object": "chat.completion",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "The size of France is approximately 248,573 square miles."
      },
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 27,
    "completion_tokens": 14,
    "total_tokens": 41
  }
}
```

For the full SDK reference, see the [SDK overview](../../05-developer-tools-and-integrations/05.4-sdks-and-apis/01-sdk-overview.md).

## Troubleshoot common integration issues

| Error | Cause | Resolution |
| --- | --- | --- |
| `401 Unauthorized` | Invalid or expired token/key | Regenerate your API key or refresh your Entra token. See [authentication options](../../13-manage-and-operate/13.3-security-and-governance/02-rbac-foundry.md). |
| `404 Not Found` | Wrong endpoint path or resource name | Verify your resource name and endpoint format match the patterns in [Choose an integration pattern](#choose-an-integration-pattern). |
| `429 Too Many Requests` | Rate limit exceeded | Implement retry with exponential backoff, or [increase quota](../06.2-quota-limits-and-region-availability/02-quota.md). |
| DNS resolution failure | Wrong domain | Use `services.ai.azure.com` for Foundry or `openai.azure.com` for OpenAI compatibility. |

## Related content

- [Get started with code quickstart](../../04-get-started/04.1-what-do-you-want-to-build/03-get-started-code.md)
- [Get started with Microsoft Foundry SDKs and endpoints](../../05-developer-tools-and-integrations/05.4-sdks-and-apis/01-sdk-overview.md)
- [Authentication and authorization options in Foundry](../../13-manage-and-operate/13.3-security-and-governance/02-rbac-foundry.md)
- [Import a Foundry API in API Management](https://learn.microsoft.com/en-us/azure/api-management/azure-ai-foundry-api)
- [AI gateway capabilities in Azure API Management](https://learn.microsoft.com/en-us/azure/api-management/genai-gateway-capabilities)
- [Consume Fabric data agent from Foundry Services](https://learn.microsoft.com/en-us/fabric/data-science/data-agent-foundry)
