# Enforce token limits for models

| Field | Value |
| --- | --- |
| **Document Title** | Enforce token limits for models |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.2-govern-at-scale/06-how-to-enforce-limits-models.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Enforce token limits for models". Use Foundry Control Plane integration with AI Gateway to apply limits for model inference, including token limits. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/control-plane/how-to-enforce-limits-models). Article date: 2026-07-15. Page updated: 2026-08-13. Retrieved: 2026-09-29. Navigation: Manage and operate > Govern at scale > Govern models > Enforce token limits.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Microsoft Foundry Control Plane enforces tokens-per-minute (TPM) rate limits and total token quotas for model deployments at the project scope. This enforcement prevents runaway token consumption and aligns usage with organizational guardrails. Foundry Control Plane integrates with AI Gateway to provide advanced policy enforcement for models.

This article explains how to configure token rate limiting and token quotas.

## Prerequisites

- An Azure account with an active subscription. If you don't have one, create a [free Azure account, which includes a free trial subscription](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- A Foundry resource with AI Gateway configured. [Learn more about how to enable AI Gateway for a Foundry resource](09-enable-ai-api-management-gateway-portal.md).
- A Foundry project with a deployed model added to the configured AI Gateway. To enable AI Gateway for a project, you need the **API Management Service Contributor** role (or **Owner**) on the Azure API Management resource.

## Understand AI Gateway

When you use AI Gateway with Foundry Control Plane to provide advanced policy enforcement for models, the gateway sits between clients and model deployments. It makes all requests flow through the API Management instance that's associated with it.

Limits apply at the project level. That is, each project can have its own TPM and quota settings.

[![Diagram of the logical flow of client requests passing through Azure API Management as an AI gateway before reaching model deployments within a project.](https://learn.microsoft.com/en-us/azure/foundry/media/enable-ai-api-management-gateway-portal/gateway-architecture-diagram.png)](https://learn.microsoft.com/en-us/azure/foundry/media/enable-ai-api-management-gateway-portal/gateway-architecture-diagram.png#lightbox)

Use AI Gateway for:

- Multiple-team token containment (prevent one project from monopolizing capacity).
- Cost control by capping aggregate usage.
- Compliance boundaries for regulated workloads (enforce predictable usage ceilings).

## Configure token limits

You can configure token limits for specific model deployments within your projects:

1. Sign in to [Microsoft Foundry](https://ai.azure.com/?cid=learnDocs). Make sure the **New Foundry** toggle is on. These steps refer to **Foundry (new)**.

   ![](https://learn.microsoft.com/en-us/azure/foundry/media/version-banner/new-foundry.png)
2. Select **Manage** > **AI Gateway**.
3. In the **AI Gateway** list, select the gateway that you want to use.
4. On the gateway details pane that appears, select **Token management**.
5. Select **+ Set limit** to create a new limit for a model deployment.
6. Select the project and deployment that you want to restrict, and enter a value for **Limit (Token-per-minute)**.
7. Select **Create** to save your changes.

[![Screenshot of the project settings pane that shows input boxes for tokens per minute and total token quota limits.](https://learn.microsoft.com/en-us/azure/foundry/media/enable-ai-api-management-gateway-portal/set-token-limits.png)](https://learn.microsoft.com/en-us/azure/foundry/media/enable-ai-api-management-gateway-portal/set-token-limits.png#lightbox)

## Understand quota windows

Token limits have two complementary enforcement dimensions:

- **TPM rate limit**: Limits token consumption to a configured maximum per minute. When requests exceed the TPM limit, the caller receives a `429 Too Many Requests` response status code.
- **Total token quota**: Limits token consumption to a configured maximum per quota period (for example, hourly, daily, weekly, monthly, or yearly). When requests exceed the quota, the caller receives a `403 Forbidden` response status code.

If you send many requests concurrently, token consumption can temporarily exceed the configured limits until responses are processed.

Adjusting a quota or TPM value affects subsequent enforcement decisions.

For more information, see [AI gateway in Azure API Management](https://learn.microsoft.com/en-us/azure/api-management/genai-gateway-capabilities) and [Limit large language model API token usage](https://learn.microsoft.com/en-us/azure/api-management/llm-token-limit-policy).

## Verify enforcement

1. Send test requests to a model deployment endpoint by using the project's gateway URL and key.
2. Gradually increase request frequency until the TPM limit triggers.
3. Track cumulative tokens until the quota triggers.
4. Validate that:
   - `429 Too Many Requests` (rate-limited response) is returned when requests exceed the TPM limit.
   - `403 Forbidden` (quota error) is returned when requests exhaust the quota.

## Adjust limits

1. Return to the project's **AI Gateway** settings.
2. Modify TPM or quota values.
3. Save the changes. New limits apply immediately to subsequent requests.

## Troubleshoot

| Problem | Possible cause | Action |
| --- | --- | --- |
| API Management instance doesn't appear | Provisioning delay | Refresh after a few minutes. |
| Limits aren't enforced | Misconfiguration or project not linked | Reopen settings and confirm that the enforcement toggle is on. Confirm that AI Gateway is enabled for the project and that correct limits are configured. |
| Latency is high after enablement | API Management cold start or region mismatch | Check API Management region versus resource region. Call the model directly and compare the result with the call proxied through AI Gateway to identify if performance problems are related to the gateway. |

If the **AI Gateway** pane is slow, retry after a brief interval.

## Related content

- [AI gateway in Azure API Management](https://learn.microsoft.com/en-us/azure/api-management/genai-gateway-capabilities)
- [What is Azure API Management?](https://learn.microsoft.com/en-us/azure/api-management/api-management-key-concepts)
- [Limit large language model API token usage](https://learn.microsoft.com/en-us/azure/api-management/llm-token-limit-policy)
- [How to use role-based access control in Azure API Management](https://learn.microsoft.com/en-us/azure/api-management/api-management-role-based-access-control)
- [Role-based access control for Microsoft Foundry](../13.3-security-and-governance/02-rbac-foundry.md)
