# Stay informed about service health regressions

| Field | Value |
| --- | --- |
| **Document Title** | Stay informed about service health regressions |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.4-operate-and-support/02-stay-informed-service-health.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Stay informed about service health regressions". Learn how to set up Azure Service Health and Azure Monitor alerts to detect service health issues and model performance regressions such as errors, latency, and time to first token in Microsoft Foundry. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/stay-informed-service-health). Article date: 2026-06-29. Page updated: 2026-07-02. Retrieved: 2026-09-29. Navigation: Manage and operate > Operate and support > Service Health alerts.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Production workloads depend on reliable service availability and consistent model performance. This article explains how to stay informed about two kinds of problems in Microsoft Foundry: platform-level service health events such as outages and planned maintenance, and workload-level performance regressions such as an increase in errors or higher latency.

Use two complementary tools:

- **[Azure Service Health](https://learn.microsoft.com/en-us/azure/service-health/)** notifies you about service problems, planned maintenance, and health advisories that affect the Azure services and regions that your resources run in.
- **[Azure Monitor metric alerts](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview/)** notify you when metrics from your model deployments cross a threshold that you set, so you can detect regressions in your own traffic before they affect users.

## Prerequisites

- A [Foundry project](../13.1-set-up-and-configure/07-create-projects.md) with at least one model deployment.
- Permission to create alerts and action groups. To create alert rules, you need a role such as **Monitoring Contributor** on the resource group or subscription. For more information, see [Roles, permissions, and security in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/roles-permissions-security).
- An email address, SMS number, or webhook endpoint to receive notifications.

## Get notified about service health events

Azure Service Health tracks the health of the Azure services that your Foundry resources depend on. It reports service issues (outages), planned maintenance, and health advisories that might affect availability or performance.

In the **Service issues** pane of the Service Health portal, you can see a map and list of events that might affect your services, based on your subscription or tenant access.

[![Screenshot of the Service issues pane in the Azure portal, showing a map and list of events that might affect your services.](https://learn.microsoft.com/en-us/azure/foundry/how-to/media/service-health/service-health-alerts.png)](https://learn.microsoft.com/en-us/azure/foundry/how-to/media/service-health/service-health-alerts.png#lightbox)

Create a Service Health alert so you're notified automatically when a relevant event occurs:

1. Go to the [Azure portal](https://portal.azure.com/) and search for **Service Health**.
2. On the **Service Health** page, select **Health alerts** in the left menu, and then select **Add service health alert**.
3. Under **Scope**, select the subscriptions, regions, and services that host your Foundry resources. Include the **Azure OpenAI**, **Foundry Models**, and **Foundry Agent Service** services, and the regions where your model deployments run.
4. Under **Alert condition**, select the event types you want to be notified about, such as **Service issue**, **Planned maintenance**, **Health advisories**, and **Security advisories**.
5. Under **Actions**, select or create an [action group](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups) that defines who gets notified and how (for example, email, SMS, or a webhook to your incident-management system).
6. Add **Alert rule details**, such as a name and resource group, and then select **Create alert rule**.

For more information, see [Create Service Health alerts in the Azure portal](https://learn.microsoft.com/en-us/azure/service-health/alerts-activity-log-service-notifications-portal) and [Service Health overview](https://learn.microsoft.com/en-us/azure/service-health/service-health-overview).

To check the current health of an individual resource, use [Azure Resource Health](https://learn.microsoft.com/en-us/azure/service-health/resource-health-overview), which reports whether a specific resource is available and explains the cause of recent unavailability.

## Detect model performance regressions

Service Health covers platform-wide events, but it doesn't detect regressions that are specific to your workload, such as a gradual increase in errors or latency. To catch those regressions, set up Azure Monitor metric alerts on the metrics that your model deployments emit.

The following metrics are most useful for detecting performance regressions:

| Signal | Metric | What it indicates |
| --- | --- | --- |
| Errors | `ModelRequests` (split or filtered by the `StatusCode` dimension) | A rise in `4xx` or `5xx` responses, such as `429` throttling or `5xx` server errors. |
| Availability | `ModelAvailabilityRate` | A drop in the percentage of successful calls, calculated as (total calls − server errors) / total calls. |
| Latency and time to first token | `TimeToResponse` | An increase in the time taken for the first response to appear after a prompt is sent, for streaming requests. |
| Token generation speed | `NormalizedTimeBetweenTokens` | A slowdown in the model's token generation rate for streaming requests. |

For the full list of available metrics and their dimensions, see [Monitor model deployments in Microsoft Foundry Models](../../09-observability/09.1-monitoring/04-monitor-models.md).

### Create a metric alert for a regression

Create a metric alert rule to be notified when one of these metrics crosses a threshold:

1. In the [Azure portal](https://portal.azure.com/), go to the Foundry resource that hosts your model deployment.
2. Under **Monitoring** in the left menu, select **Alerts**, and then select **Create** > **Alert rule**.
3. On the **Condition** tab, select a signal such as `TimeToResponse`, `ModelAvailabilityRate`, or `ModelRequests`.
4. Set the threshold logic. For example, alert when the average `TimeToResponse` is greater than your target latency, when `ModelAvailabilityRate` drops below a target percentage, or when the count of `ModelRequests` with a `5xx` `StatusCode` exceeds your tolerance.
5. Optionally, use **Add splitting** on a dimension such as `ModelDeploymentName` or `StatusCode` so you get a separate alert per deployment or status code.
6. On the **Actions** tab, select or create an [action group](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups) to define who gets notified.
7. On the **Details** tab, name the rule and set its severity, and then create the rule.

For more information, see [Create a metric alert rule](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-metric-alert-rule) and [Azure Monitor metric alerts overview](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-metric-overview).

> **Tip**
>
> Set thresholds based on a baseline of normal traffic so you reduce false positives. Use the metrics explorer to review historical values for these metrics before you choose a threshold.

## Respond to issues and regressions

Detecting an outage or a regression is only the first step. The right mitigation depends on the kind of problem you observe. The following table isn't exhaustive; it shows a sample set of responses to common problems.

| What you observe | Likely cause | Mitigation options |
| --- | --- | --- |
| A rise in `5xx` errors and a drop in `ModelAvailabilityRate` | The service can't process requests, for example because of a backend or regional issue. | Check your Service Health and Resource Health alerts to confirm the scope of the incident. Global Standard and Data Zone deployments distribute inference processing across multiple regions, which adds resilience to single-region inference outages or capacity constraints, but they don't replace a multiregional failover plan. Because the layer that processes API requests is regional to your Azure resource, an outage in the service requires you to fail over to another region to restore operations. Design a multiregional topology in advance so you can redirect traffic quickly. |
| Sustained `429` throttling errors | Your traffic exceeds the rate limits (TPM or RPM) of your deployment, or the shared Standard capacity pool is temporarily constrained. | Retry with exponential backoff and honor the `Retry-After` header, distribute traffic across deployments or regions with an [Azure API Management AI gateway](../13.2-govern-at-scale/09-enable-ai-api-management-gateway-portal.md), or request a quota increase. For predictable throughput, move the workload to a [Provisioned Throughput managed (PTU-M)](../../06-models/06.3-offers-deployment-types-and-pricing/09-provisioned-throughput.md) deployment, which provides dedicated capacity that isn't subject to shared-pool throttling. |
| An increase in latency (`TimeToResponse` or `NormalizedTimeBetweenTokens`) | Variability in the shared Standard capacity pool, or requests processed by distant capacity. | For workloads where latency is a core requirement, use a [Provisioned Throughput (PTU)](../../06-models/06.3-offers-deployment-types-and-pricing/09-provisioned-throughput.md) deployment, which provides dedicated capacity and a latency SLA. A regional Standard deployment close to your users can also reduce network latency. Global Standard and Data Zone deployments optimize for availability rather than latency and can increase latency variability, so choose them based on your availability and data-residency needs rather than as a latency-reduction lever. |

When you fail over between regional deployments, consider these approaches:

- **Manual failover**: Keep a separate Azure OpenAI or Foundry deployment ready in a secondary region, and switch your application configuration to it when the primary deployment is unavailable.
- **Semiautomatic failover**: Front your deployments with an Azure API Management (APIM) instance that load balances across endpoints and uses the circuit-breaker pattern to route around unhealthy backends automatically.

To prepare for failover before an incident occurs, design your workload for high availability and plan a multiregional deployment.

For detailed guidance, see [High availability and resiliency for Microsoft Foundry projects and Agent Service](../13.3-security-and-governance/18-high-availability-resiliency.md#plan-for-multiregional-deployment). That article also covers configuring model deployment resiliency, using a Generative AI Gateway for load balancing and circuit breaking, and initiating a failover. For architectural guidance on gateway patterns, see [Use a gateway in front of Foundry model deployments or instances](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/guide/azure-openai-gateway-multi-backend).

## Related content

- [Monitor model deployments in Microsoft Foundry Models](../../09-observability/09.1-monitoring/04-monitor-models.md)
- [Diagnostic logging](../13.3-security-and-governance/16-diagnostic-logging.md)
- [Azure Service Health documentation](https://learn.microsoft.com/en-us/azure/service-health/)
- [Azure Monitor documentation](https://learn.microsoft.com/en-us/azure/azure-monitor/)
