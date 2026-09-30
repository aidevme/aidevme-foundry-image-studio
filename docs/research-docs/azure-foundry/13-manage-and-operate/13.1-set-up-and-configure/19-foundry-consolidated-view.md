# Consolidated view for Foundry Tools in the Azure portal

| Field | Value |
| --- | --- |
| **Document Title** | Consolidated view for Foundry Tools in the Azure portal |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.1-set-up-and-configure/19-foundry-consolidated-view.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Consolidated view for Foundry Tools in the Azure portal". Discover how the Foundry consolidated view in the Azure portal simplifies AI workload management with cost, usage, and quota insights in one place. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/concepts/foundry-consolidated-view). Article date: 2026-09-18. Page updated: 2026-09-18. Retrieved: 2026-09-29. Navigation: Manage and operate > Set up and configure > Consolidated view in Azure portal.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

The consolidated view for Foundry Tools in the Azure portal shows key insights about your AI workloads, including costs, usage, and quota utilization for resources you use with Microsoft Foundry. Instead of switching between tools, you see in one place how your AI resources perform, what they cost, and whether you're nearing usage limits.

## Prerequisites

- An Azure account that you can use to sign in to the [Azure portal](https://portal.azure.com/).
- At least **Reader** access to the subscription or resource group that contains the resources you want to monitor.
- To view costs in the consolidated view: the [Foundry User role](../13.3-security-and-governance/02-rbac-foundry.md#built-in-roles) on your Foundry resource and the [Cost Management Reader role](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/management-and-governance#cost-management-reader) at the resource group or subscription level.

  > **Important**
  >
  > The Foundry RBAC roles were recently renamed. **Foundry User**, **Foundry Owner**, **Foundry Account Owner**, and **Foundry Project Manager** were previously named Azure AI User, Azure AI Owner, Azure AI Account Owner, and Azure AI Project Manager. You might still see the previous names in some places while the rename rolls out. The role IDs and core permissions are unchanged by the rename.
- To view quota usage at subscription scope: the **Cognitive Services Usages Reader** role (recommended) or the **Reader** role. For more information, see [Role-based access control for Azure OpenAI in Microsoft Foundry Models](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/how-to/role-based-access-control).

## Open the consolidated view

1. Sign in to the [Azure portal](https://portal.azure.com/).
2. Open the [consolidated view for Foundry Tools](https://portal.azure.com/#view/Microsoft_Azure_ProjectOxford/CognitiveServicesHub/%7E/overview).
3. On the page, select the subscription and other scope controls as needed.

When the page loads successfully, you see dashboard tiles for costs, usage, quota, alerts, and resource breakdown.

## Key features

- **Alerts and service health**

  View key alerts for your AI resources so you can investigate and fix problems without leaving the dashboard.
- **Accumulated costs**

  View your costs over time by subscription or resource type. Identify trends, track experiments, and drill into **Cost management** for deeper analysis.
- **Active resources by cost**

  See which active resources drive the most spend. Use this information to optimize usage and clean up idle resources quickly.
- **Model utilization**

  Track AI model usage over time. Spot peaks, dips, and usage patterns across your projects to make better scaling decisions.
- **Resource breakdown by type**

  Understand which Foundry Tools you use most (for example, Azure OpenAI, Azure Speech in Foundry Tools, and Azure Language in Foundry Tools). This understanding helps with cost allocation and planning for future workloads.
- **Quota utilization**

  Monitor quota usage by model and region (for example, **gpt-4o: 9,500 of 10,000 TPM in West US**). Stay ahead of capacity problems with quick links to **Quota management** for requesting increases.

## Why use the consolidated view?

- **Faster visibility**: Check cost, quota (for example, **72% of regional limit**), and resource usage (for example, **1.3M tokens/hour**) at a glance.
- **Built-in governance**: Spot early warning signs such as **quota usage >80%** or **day-over-day cost increases >15%** before they become blockers.
- **Lightweight experience**: No new resource types or setup steps required; the view aggregates **existing subscriptions and resources only**.

## Visual layout of the consolidated view

The dashboard shows tiles for each visibility area:

- **Top row**: Alerts, active resources by cost, and accumulated costs.
- **Middle row**: Model utilization over time.
- **Bottom row**: Resource breakdown by type and quota utilization.

[![Screenshot of a dashboard with tiles for alerts, resource costs, model utilization, resource breakdown, and quota utilization.](https://learn.microsoft.com/en-us/azure/foundry/media/ai-foundry-consolidated-view/consolidated-view-dashboard.png)](https://learn.microsoft.com/en-us/azure/foundry/media/ai-foundry-consolidated-view/consolidated-view-dashboard.png#lightbox)

## What you can do next

- Open **Cost analysis** from the dashboard to analyze costs.
- Request quota increases in **Quota management** when you reach limits.
- Use utilization insights to decide where to scale, pause, or reallocate resources.
- Keep AI projects running smoothly by acting on alerts.

## Related content

- [Plan and manage costs for Microsoft Foundry](../../06-models/06.3-offers-deployment-types-and-pricing/16-manage-costs.md)
- [Role-based access control for Microsoft Foundry](../13.3-security-and-governance/02-rbac-foundry.md)
- [Quickstart: Start using Cost analysis](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/quick-acm-cost-analysis)
- [Manage quota in Microsoft Foundry](../../06-models/06.2-quota-limits-and-region-availability/02-quota.md)
- [Manage Azure OpenAI in Microsoft Foundry Models quota](../../06-models/06.2-quota-limits-and-region-availability/03-quota.md)
