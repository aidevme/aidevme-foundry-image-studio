# Manage and increase quotas for resources with Microsoft Foundry (Foundry projects)

| Field | Value |
| --- | --- |
| **Document Title** | Manage and increase quotas for resources with Microsoft Foundry (Foundry projects) |
| **Document Location** | `docs/research-docs/azure-foundry/06-models/06.2-quota-limits-and-region-availability/02-quota.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Manage and increase quotas for resources with Microsoft Foundry (Foundry projects)". Learn how to view, manage, and request increases for model deployment quotas in Microsoft Foundry, including token-per-minute and provisioned throughput allocations. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/quota). Article date: 2026-07-28. Page updated: 2026-08-13. Retrieved: 2026-09-29. Navigation: Models > Quota limits and region availability > Manage quotas for Foundry resources.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Quota provides the flexibility to actively manage the allocation of rate limits across the deployments within your subscription. Azure assigns quota per subscription, per region, and per model in units of tokens per minute (TPM). Different deployment types, such as Standard and Provisioned, have different quota mechanics. For full details on default limits and quota tiers, see [Azure OpenAI quotas and limits](06-quotas-limits.md).

This article walks through the process of managing quota for your Microsoft Foundry Models deployed in a Foundry project, including how to view current allocations and request increases.

## Prerequisites

- An Azure subscription. [Create one for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- A [Foundry project](../../13-manage-and-operate/13.1-set-up-and-configure/07-create-projects.md).
- **Cognitive Services Usages Reader** role at the subscription scope, to view quota allocations. For more information, see [Access quota and usage information](../../13-manage-and-operate/13.3-security-and-governance/02-rbac-foundry.md#access-quota-and-usage-information).
- **Owner** or **Contributor** role on the subscription, to request quota increases.
- **Cognitive Services Contributor** role combined with **Cognitive Services Usages Reader**, to edit quota allocations in the Foundry portal.

## Foundry shared quota

Foundry provides a pool of shared quota that different users across various regions can use concurrently. Depending on availability, users can temporarily access quota from the shared pool and use the quota to perform testing for a limited amount of time. The specific time duration depends on the use case. By temporarily using quota from the quota pool, you no longer need to file a support ticket for a short-term quota increase or wait for your quota request to be approved before you can proceed with your workload.

You can use the shared quota pool for testing inferencing for Foundry Models from the model catalog. Use the shared quota only for creating temporary test endpoints, not production endpoints. For endpoints in production, you should [request dedicated quota](#view-and-request-quotas-in-foundry-portal). Billing for shared quota is usage-based.

## Quota for instant access (preview)

[Instant access models](../06.3-offers-deployment-types-and-pricing/02-instant-models.md) draw from a per-model **global quota** pool that is separate from the regional quota you manage for deployments. When you create a Global Standard deployment, it reserves a portion of your global quota. Instant access models use whatever global quota remains unreserved.

You don't need to allocate or partition global quota — it's shared automatically across all instant model usage in your subscription. If instant model requests are throttled, you can request a global quota increase or create a deployment with reserved capacity.

For details on how global and regional quota interact, see [Instant access — Global quota](../06.3-offers-deployment-types-and-pricing/02-instant-models.md#how-quota-is-consumed).

## View and request quotas in Foundry portal

Use quotas to manage model quota allocation between multiple Foundry projects in the same subscription.

1. Sign in to [Microsoft Foundry](https://ai.azure.com/?cid=learnDocs). Make sure the **New Foundry** toggle is on. These steps refer to **Foundry (new)**.

   ![](https://learn.microsoft.com/en-us/azure/foundry/media/version-banner/new-foundry.png)
2. Projects help organize your work. The project you're working on appears in the upper-left corner. If you want to create a new project, select the project name, then **Create new project**.
3. Select **Manage** from the upper-right navigation.
4. Select **Quota** from the left pane to land on the **Quota** pane. The quota view has two tabs:
   - **Token per minute** — View and manage token-per-minute (TPM) quota allocations for standard deployments.
   - **Provisioned throughput unit** — View and manage provisioned throughput unit (PTU) allocations for provisioned deployments, including capacity estimation tools.
5. Select any of the deployments in the list to open its details pane on the right side. The details pane shows the deployment's current quota allocation, usage, and affiliated deployments.
6. On the deployment's details pane, go to the **Affiliated deployments using shared quota** section. Select the pencil icon in the **Actions** column of the table to edit quota allocation for the deployment and free up unused quota or increase allocation as needed.
7. Select the **Request quota** button in the upper-right corner to request increases in quota for the standard deployment type.

> **Note**
>
> After you edit a quota allocation or submit a request, allow up to 15 minutes for changes to propagate. Refresh the **Quota** page to verify the updated allocation.

## Troubleshooting

If you encounter issues when viewing or requesting quotas, try these solutions:

| Issue | Solution |
| --- | --- |
| Quota page is empty or shows no allocations | Verify that you have **Cognitive Services Usages Reader** role at the subscription level. Check that you're viewing the correct subscription in the portal. |
| **Request quota** button is disabled | Verify that you have **Owner** or **Contributor** role on the subscription. Some model and region combinations might not support quota increases. |
| Quota change not reflected after approval | Quota changes can take up to 15 minutes to propagate. Refresh the **Quota** page. If the issue persists after 24 hours, contact [Azure support](https://azure.microsoft.com/support/options/). |
| Can't find quota for a specific model | Check regional availability. Not all models are available in all regions. See [Region support](08-region-support.md). |

## Related content

- [Instant access in Microsoft Foundry (preview)](../06.3-offers-deployment-types-and-pricing/02-instant-models.md)
- [Microsoft Foundry Models quotas and limits](05-quotas-limits.md)
- [Azure OpenAI quotas and limits](06-quotas-limits.md)
- [Manage Azure OpenAI Service quota](https://learn.microsoft.com/en-us/azure/foundry-classic/openai/how-to/quota)
- [Plan to manage costs](https://learn.microsoft.com/en-us/azure/foundry-classic/how-to/costs-plan-manage)
- [Create a project](../../13-manage-and-operate/13.1-set-up-and-configure/07-create-projects.md)
