# Monitor agent health and performance across your fleet

| Field | Value |
| --- | --- |
| **Document Title** | Monitor agent health and performance across your fleet |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.2-govern-at-scale/02-monitoring-across-fleet.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Monitor agent health and performance across your fleet". Track agent health, compliance, performance trends, and cost efficiency across your AI fleet by using Microsoft Foundry Control Plane monitoring. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/control-plane/monitoring-across-fleet). Article date: 2026-05-12. Page updated: 2026-08-13. Retrieved: 2026-09-29. Navigation: Manage and operate > Govern at scale > Govern agents > Monitor fleet health and performance.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

As your organization scales from isolated copilots to autonomous multi-agent fleets, maintaining visibility and control becomes critical. Microsoft Foundry Control Plane provides a unified command center where you can monitor all agents, models, and tools across your enterprise from build to production.

Fleet monitoring serves multiple roles:

- *Team managers* gain oversight of agent operations and team productivity.
- *Administrators* enforce governance policies and track compliance posture.
- *Cost managers* optimize spending and identify resource inefficiencies.
- *Security teams* monitor for prohibited behaviors and policy violations.

This article shows you how to use Foundry Control Plane capabilities to track agent health, performance, compliance, and cost efficiency at scale. By using centralized monitoring, you can identify problems early, optimize resource consumption, and help ensure that your AI systems operate safely and reliably.

## Prerequisites

- An Azure account with an active subscription. If you don't have one, create a [free Azure account, which includes a free trial subscription](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- A Foundry project. If you don't have one, [create a project](../13.1-set-up-and-configure/07-create-projects.md).

- The following permissions:
  - Read access to the project and subscription that you want to view data for
  - [Log Analytics Reader](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/monitor#log-analytics-reader) role or higher on the Application Insights resource that's associated with your agent
  - [Cost Management Reader](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/management-and-governance#cost-management-reader) role

> **Note**
>
> This capability is available only in the Foundry (new) portal. Look for ![](https://learn.microsoft.com/en-us/azure/foundry/media/version-banner/new-foundry.png) in the portal banner to confirm you're using Foundry (new).

## How monitoring works

Foundry Control Plane discovers all the agents that you can access. It uses the Application Insights resources that host your agents to help you monitor and diagnose those agents.

Foundry Control Plane supports:

- Foundry agents, including [prompt-based agents](../../07-agents/01-overview.md), [workflows](../../07-agents/07.1-concepts/06-workflow.md), and [hosted agents](../../07-agents/07.3-hosted-agents/01-hosted-agents.md).
- [Azure SRE Agent](https://learn.microsoft.com/en-us/azure/sre-agent/).
- [Azure Logic Apps agent loops](https://learn.microsoft.com/en-us/azure/logic-apps/agent-workflows-concepts).
- [Custom agents](04-register-custom-agent.md) registered manually.

Because Foundry Control Plane aggregates information across resources within the subscription, different users might see different agents listed, depending on their access.

Foundry Control Plane aggregates logs and metrics available across each Application Insights resource that's connected to each agent.

[![Architecture diagram that shows how Foundry Control Plane uses Application Insights to collect logs and metrics across resources.](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/monitoring-across-fleet/observability-app-insights-architecture.png)](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/monitoring-across-fleet/observability-app-insights-architecture.png#lightbox)

Foundry Control Plane requires agents to log diagnostic information by following OpenTelemetry standards with [semantic conventions for Generative AI](https://opentelemetry.io/docs/specs/semconv/gen-ai/) applications. You don't need to configure Application Insights on each resource, but doing so is strongly recommended. When Control Plane has this data, it can provide:

- **Fleet health metrics**: Track active agents, run completion rates, and error trends across your entire fleet.
- **Cost and performance tracking**: Monitor token usage, budget consumption, and resource efficiency across all agents.
- **Anomaly detection**: Identify cost spikes, performance degradation, and emerging issues through trend analysis.
- **Drill-down analysis**: Move from fleet-level metrics to individual agent traces and logs for detailed investigation.

> **Important**
>
> Agents running on resources without Application Insights don't have health metrics, cost tracking, or drill-down traces.

## Configure monitoring

Follow these steps for each project where you want to configure monitoring:

1. Sign in to [Microsoft Foundry](https://ai.azure.com/?cid=learnDocs). Make sure the **New Foundry** toggle is on. These steps refer to **Foundry (new)**.

   ![](https://learn.microsoft.com/en-us/azure/foundry/media/version-banner/new-foundry.png)
2. On the toolbar, select **Manage**.
3. On the left pane, select **Project details**.
4. Select the **Connected resources** tab.
5. Verify that there's an associated resource for the category **AppInsights**.

   [![Screenshot of the Project details pane that shows how to verify if a project has an associated Application Insights resource.](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/register-custom-agent/verify-app-insights.png)](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/register-custom-agent/verify-app-insights.png#lightbox)
6. If there's no associated resource, add one by selecting **Add connection** and then selecting **Application Insights**.

   > **Tip**
   >
   > You can send traces to either different Application Insights resources or to the same resource, depending on your governance and security requirements.

Your project is now configured for observability and tracing. To verify that monitoring is active, go to **Operate** > **Overview** in the Foundry portal, select your project from the dropdown list, and confirm that agent metrics appear in the dashboard. Metrics might take a few minutes to populate after initial configuration.

## View metrics

You can view aggregated metrics for all agents within a selected project by using Foundry. The **Overview** pane provides insights into fleet health, compliance, and performance trends.

1. Sign in to [Microsoft Foundry](https://ai.azure.com/?cid=learnDocs). Make sure the **New Foundry** toggle is on. These steps refer to **Foundry (new)**.

   ![](https://learn.microsoft.com/en-us/azure/foundry/media/version-banner/new-foundry.png)
2. On the toolbar, select **Operate**.
3. Review the metrics displayed on the **Overview** pane, which shows common metrics and insights for all discovered agents within the subscription by default.

   [![Animation of the Overview pane that displays trend-based health scores, alert summaries, and aggregated compliance metrics for a fleet.](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/overview/control-plane-overview.gif)](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/overview/control-plane-overview.gif#lightbox)
4. From the project dropdown list, select a project to scope the metrics, if necessary.
5. Select a date range by using the date selectors in the upper-right corner.

The **Overview** pane shows fleet-level health scores, alert summaries, active agent counts, error rates, and compliance metrics for the selected time range. Use this view to quickly assess the operational state of your fleet and identify areas that need attention.

## View individual agent metrics

You can view all your assets under a specific project, along with top-level metrics, from Foundry.

1. Sign in to [Microsoft Foundry](https://ai.azure.com/?cid=learnDocs). Make sure the **New Foundry** toggle is on. These steps refer to **Foundry (new)**.

   ![](https://learn.microsoft.com/en-us/azure/foundry/media/version-banner/new-foundry.png)
2. On the toolbar, select **Operate**.
3. On the left pane, select **Assets**.
4. Select the **Agents** tab.

   [![Screenshot of the Agents tab that shows all registered agents with top-level metrics.](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/monitoring-across-fleet/agents-tab-overview-metrics.png)](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/monitoring-across-fleet/agents-tab-overview-metrics.png#lightbox)

   The tab shows the details of agents discovered within the subscription. To learn about these details, see [Agent inventory](03-how-to-manage-agents.md#agent-inventory).
5. To view more granular information on the performance of an individual agent, select an agent. The pane that appears provides quick insights into the selected agent's health and recent activity. Use it to identify problems and take corrective actions.

   [![Screenshot of the Foundry pane that shows details of a selected agent.](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/monitoring-across-fleet/agent-details.png)](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/monitoring-across-fleet/agent-details.png#lightbox)

   The pane contains these sections:
   - **Active alerts**: View policy, security, and evaluation alerts grouped by severity and take action.
   - **Activity**: See key metrics such as error rate over time, total run information, and information on token usage.

To learn more about how to manage individual agents, see [Manage agents at scale](03-how-to-manage-agents.md).

## Troubleshoot monitoring

If you don't see expected metrics or agents in the dashboard, check the following common causes:

- **Agents don't appear in the Assets pane**: Verify that you have read access to the subscription and project where the agents are deployed. Different users see different agents depending on their access level.
- **Metrics are empty or missing**: Confirm that the Application Insights resource is connected to the project (see [Configure monitoring](#configure-monitoring)). Metrics can take several minutes to populate after the initial connection.
- **Health metrics or traces aren't available for a specific agent**: The agent might be running on a resource without Application Insights configured. Connect an Application Insights resource to the agent's project to enable health data and drill-down traces.
- **Cost data doesn't appear**: Verify that you have the [Cost Management Reader](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/management-and-governance#cost-management-reader) role on the subscription.

## Related content

- [What is Microsoft Foundry Control Plane?](01-overview.md)
- [Manage agents at scale](03-how-to-manage-agents.md)
- [Register and manage custom agents](04-register-custom-agent.md)
