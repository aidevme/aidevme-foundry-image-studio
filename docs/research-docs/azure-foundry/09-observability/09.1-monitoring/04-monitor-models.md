# Monitor model deployments in Microsoft Foundry Models

| Field | Value |
| --- | --- |
| **Document Title** | Monitor model deployments in Microsoft Foundry Models |
| **Document Location** | `docs/research-docs/azure-foundry/09-observability/09.1-monitoring/04-monitor-models.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Monitor model deployments in Microsoft Foundry Models". Learn how to use Azure Monitor tools like Log Analytics to capture and analyze metrics and data logs for Foundry Models. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/how-to/monitor-models). Article date: 2026-09-08. Page updated: 2026-09-08. Retrieved: 2026-09-29. Navigation: Observability > Monitoring > Monitor model deployments.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

> **Important**
>
> Items marked (preview) in this article are currently in public preview. This preview is provided without a service-level agreement, and we don't recommend it for production workloads. Certain features might not be supported or might have constrained capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

This article explains how to use Azure Monitor metrics and logs to track availability, performance, and usage for model deployments in Foundry Models. Azure Monitor automatically collects and aggregates metrics and logs from your Foundry Models deployments, so you can view real-time performance data and set up alerts for issues.

## Prerequisites

To use monitoring capabilities for model deployments in Foundry Models, you need the following:

- A [Microsoft Foundry resource](../../04-get-started/04.1-what-do-you-want-to-build/03-get-started-code.md).

  > **Tip**
  >
  > If you're using serverless API endpoints and you want to take advantage of monitoring capabilities explained in this article, [migrate your serverless API endpoints to Foundry Models](https://learn.microsoft.com/en-us/azure/foundry-classic/foundry-models/how-to/quickstart-ai-project).
- At least one model deployment.
- To view metrics: at least the user needs the [Monitoring Reader](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#monitoring-reader) role on the resource.
- To configure diagnostic settings: the user needs the [Monitoring Contributor](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#monitoring-contributor) role (or equivalent) on the resource.

## Metrics

Azure Monitor collects metrics from Foundry Models automatically. *No configuration is required*. These metrics are:

- Stored in the Azure Monitor time-series metrics database.
- Lightweight and capable of supporting near real-time alerting.
- Used to track the performance of a resource over time.

### View metrics

Azure Monitor metrics can be queried using multiple tools, including:

#### Foundry portal

You can view metrics within the Foundry portal. To view them, follow these steps:

1. Go to the [Foundry portal](https://ai.azure.com/?cid=learnDocs).
2. Under **My assets** in the sidebar menu, select **Models + endpoints**, and then select the name of the deployment you want to see metrics about.
3. Select the **Metrics** tab.
4. You can access an overview of common metrics that might be of interest. For cost-related metrics, select the **Azure Cost Management** link, which provides access to detailed post-consumption cost metrics in the **Cost analysis** section located in the Azure portal.

   [![Screenshot showing the metrics displayed for model deployments in Foundry portal.](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/media/monitor-models/deployment-metrics.png)](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/media/monitor-models/deployment-metrics.png#lightbox)

   Cost data in the Azure portal displays actual post-consumption charges for model consumption, including other AI resources within Foundry. For a full list of AI resources, see [Build with customizable APIs and models](https://azure.microsoft.com/products/ai-services#tabs-pill-bar-oc14f0_tab0). There's approximately a five- hour delay from the billing event to when it can be viewed in Azure portal cost analysis.

   > **Important**
   >
   > The **Azure Cost Management** link provides a direct link within the Azure portal, allowing users to access detailed cost metrics for deployed AI models. This deep link integrates with the Azure Cost Analysis service view, offering transparent and actionable insights into model-level costs.
   >
   > The deep link directs users to the Cost Analysis view in the Azure portal, providing a one-click experience to view deployments per resource, including input/output token cost/consumption. To view cost data, you need at least *read* access for an Azure account. For information about assigning access to Cost Management data, see [Assign access to data](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/assign-access-acm-data).
5. You can view and analyze metrics with Azure Monitor [metrics explorer](#metrics-explorer) to further slice and filter your model deployment metrics.

   [![Screenshot showing the option to open model deployment metrics in Azure Monitor.](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/media/monitor-models/deployment-metrics-azmonitor.png)](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/media/monitor-models/deployment-metrics-azmonitor.png#lightbox)

#### Metrics explorer

Metrics explorer is a tool in the Azure portal that allows you to view and analyze metrics for Azure resources. For more information, see [Analyze metrics with Azure Monitor metrics explorer](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/analyze-metrics).

To use Azure Monitor, follow these steps:

1. Go to the [Azure portal](https://portal.azure.com/).
2. Type and select **Monitor** on the search box.
3. Select **Metrics** in the sidebar menu.
4. On **Select scope**, select the resources you want to monitor. You can either select one resource or select a resource group or subscription. If that's the case, ensure you select **Resource types** as **Foundry Tools**.
5. The metrics explorer appears. Select the [metrics](#metrics-reference) that you want to explore. The following example shows the number of requests made to the model deployments in the resource.

   [![Screenshot showing how to add a new metric to the chart.](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/media/monitor-models/azmon-add-metric.png)](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/media/monitor-models/azmon-add-metric.png#lightbox)

   > **Important**
   >
   > Metrics in the **Azure OpenAI** category contain metrics for Azure OpenAI models in the resource. The **Models** category contains all the models available in the resource, including Azure OpenAI, DeepSeek, and Phi. We recommend switching to this new set of metrics.
6. You can add as many metrics as needed to either the same chart or to a new chart.
7. If you need, you can filter metrics by any of their available dimensions.

   [![Screenshot showing how to apply a filter to a metric.](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/media/monitor-models/azmon-add-filter.png)](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/media/monitor-models/azmon-add-filter.png#lightbox)
8. It's useful to break down specific metrics by some of the dimensions. The following example shows how to break down the number of requests made to the resource by model by using the option **Add splitting**:

   [![Screenshot showing how to split the metric by a given dimension.](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/media/monitor-models/azmon-add-splitting.png)](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/media/monitor-models/azmon-add-splitting.png#lightbox)
9. You can save your dashboards at any time to avoid having to configure them each time.

#### Other tools

Tools that allow more complex visualization include:

- [Workbooks](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview): customizable reports that you can create in the Azure portal. Workbooks can include text, metrics, and log queries.
- [Grafana](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/grafana-plugin): an open platform tool that excels in operational dashboards. You can use Grafana to create dashboards that include data from multiple sources other than Azure Monitor.
- [Power BI](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-powerbi): a business analytics service that provides interactive visualizations across various data sources. You can configure Power BI to automatically import log data from Azure Monitor to take advantage of these visualizations.

### Metrics reference

The following categories of metrics are available:

#### Models - Requests

| Metric | Internal name | Unit | Aggregation | Dimensions |
| --- | --- | --- | --- | --- |
| **Model Availability Rate** Availability percentage with the following calculation: (Total Calls - Server Errors)/Total Calls. Server Errors include any HTTP responses >=500. | `ModelAvailabilityRate` | Percent | Minimum, Maximum, Average | `ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion` |
| **Model Requests** Number of calls made to the model inference API over a period of time. | `ModelRequests` | Count | Total (Sum) | `ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `StatusCode` |

#### Models - Latency

| Metric | Internal name | Unit | Aggregation | Dimensions |
| --- | --- | --- | --- | --- |
| **Time To Response** Recommended latency (responsiveness) measure for streaming requests. Applies to [PTU and PTU-managed](https://learn.microsoft.com/en-us/azure/ai-foundry/foundry-models/concepts/deployment-types) deployments. Calculated as time taken for the first response to appear after a user sends a prompt, as measured by the API gateway. This number increases as the prompt size increases and/or cache hit size reduces. This metric is an approximation because measured latency depends on multiple factors, including concurrent calls and overall workload pattern. It doesn't account for any client-side latency between your client and the API endpoint. Refer to your own logging for optimal latency tracking. | `TimeToResponse` | Milliseconds | Maximum, Minimum, Average | `ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `StatusCode` |
| **Normalized Time Between Tokens** For streaming requests; model token generation rate, measured in milliseconds. Applies to [PTU and PTU-managed](https://learn.microsoft.com/en-us/azure/ai-foundry/foundry-models/concepts/deployment-types) deployments. | `NormalizedTimeBetweenTokens` | Milliseconds | Maximum, Minimum, Average | `ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion` |

#### Models - Usage

| Metric | Internal name | Unit | Aggregation | Dimensions |
| --- | --- | --- | --- | --- |
| **Input Tokens** Number of prompt tokens processed (input) on a model. Applies to PTU, PTU-managed and standard deployments. | `InputTokens` | Count | Total (Sum) | `ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion` |
| **Output Tokens** Number of tokens generated (output) from a model. Applies to PTU, PTU-managed and standard deployments. | `OutputTokens` | Count | Total (Sum) | `ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion` |
| **Total Tokens** Number of inference tokens processed on a model. Calculated as prompt tokens (input) plus generated tokens (output). Applies to PTU, PTU-managed and standard deployments. | `TotalTokens` | Count | Total (Sum) | `ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion` |
| **Tokens Cache Match Rate** Percentage of prompt tokens that hit the cache. Applies to PTU and PTU-managed deployments. | `TokensCacheMatchRate` | Percentage | Average | `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion` |
| **Provisioned Utilization** Utilization percentage for a provisioned-managed deployment, calculated as (PTUs consumed / PTUs deployed) x 100. When utilization is greater than or equal to 100%, calls are throttled and error code 429 is returned. | `ProvisionedUtilization` | Percentage | Average | `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion` |
| **Provisioned Consumed Tokens** Total tokens minus cached tokens over a period of time. Applies to PTU and PTU-managed deployments. | `ProvisionedConsumedTokens` | Count | Total (Sum) | `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion` |
| **Audio Input Tokens** Number of audio prompt tokens processed (input) on a model. Applies to PTU-managed model deployments. | `AudioInputTokens` | Count | Total (Sum) | `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion` |
| **Audio Output Tokens** Number of audio prompt tokens generated (output) on a model. Applies to PTU-managed model deployments. | `AudioOutputTokens` | Count | Total (Sum) | `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion` |

## Logs

Resource logs provide insight into operations that were done by an Azure resource. Logs are generated automatically, but you must route them to Azure Monitor logs to save or query by [configuring a diagnostic setting](#configure-diagnostic-settings). Logs are organized in categories. When you create a diagnostic setting, you specify which categories of logs to collect.

The following log categories are available for Foundry Models:

| Category | Description |
| --- | --- |
| **RequestResponse** | Logs for every inference request and response, including status codes and latency. |
| **Trace** | Detailed trace logs for debugging model inference calls. |
| **Audit** | Administrative operations such as deployments, configuration changes, and access control events. |

For more information about all available log categories, see [Azure Monitor resource log categories](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/resource-logs-categories).

## Configure diagnostic settings

All of the metrics are exportable with diagnostic settings in Azure Monitor. To analyze logs and metrics data with Azure Monitor Log Analytics queries, you can configure diagnostic settings for your Foundry Tools resource. Perform this operation on each resource.

![Screenshot showing how to configure diagnostic logging in a resource.png](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/media/monitor-models/azmon-diagnostic.png)

To configure diagnostic settings for your Foundry resource:

1. Go to the [Azure portal](https://portal.azure.com/) and locate your Foundry resource.
2. Under **Monitoring** in the sidebar menu, select **Diagnostic settings**.
3. Select **Add diagnostic setting**.
4. Enter a name for the diagnostic setting.
5. Under **Logs**, select the [log categories](#logs) you want to collect (for example, **RequestResponseLogs**).
6. Under **Metrics**, select **AllMetrics** to export metrics.
7. Under **Destination details**, select **Send to Log Analytics workspace** and choose a workspace in your subscription.
8. Select **Save**.

> **Note**
>
> There's a cost for collecting data in a Log Analytics workspace, so only collect the categories you require for each service. The data volume for resource logs varies significantly between services.

## Query logs with KQL

After you [configure diagnostic settings](#configure-diagnostic-settings) to send metrics to Log Analytics, you can query and analyze log data by using the Kusto query language (KQL).

To query metrics, follow these steps:

1. Go to the [Azure portal](https://portal.azure.com/).
2. Locate the Foundry resource you want to query.
3. Under **Monitoring** in the sidebar menu, select **Logs**. If the query window options populate, close the window.
4. A new query tab will populate. Select the **Sample mode** drop-down and select **KQL mode**.
5. To examine the Azure Metrics, type a custom query or copy and paste the following query:

   ```kusto
   AzureMetrics
   | take 100
   | project TimeGenerated, MetricName, Total, Count, Maximum, Minimum, Average, TimeGrain, UnitName
   ```
6. Select **Run**

   > **Note**
   >
   > When you select **Monitoring** > **Logs** in the menu for your resource, Log Analytics opens with the query scope set to the current resource. The visible log queries include data from that specific resource only. To run a query that includes data from other resources or data from other Azure services, select **Logs** from the **Azure Monitor** menu in the Azure portal. For more information, see [Log query scope and time range in Azure Monitor Log Analytics](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/scope).

## Troubleshooting

| Issue | Possible cause | Resolution |
| --- | --- | --- |
| Metrics not appearing in metrics explorer | The resource type filter might not be set correctly. | Ensure **Resource types** is set to **Foundry Tools** in the scope selector. |
| No log data in Log Analytics | Diagnostic settings aren't configured, or data hasn't arrived yet. | [Configure diagnostic settings](#configure-diagnostic-settings) and wait up to 15 minutes for data to appear. |
| Metrics show zero values | The model deployment might not have received traffic in the selected time range. | Adjust the time range in metrics explorer, or verify the deployment is receiving requests. |
| Cost data not visible in Microsoft Cost Management | Missing permissions or billing delay. | Ensure you have at least *read* access to the Azure account. Cost data can take up to five hours to appear. |
| 429 errors on model calls | Provisioned utilization is at or above 100%. | Check the **Provisioned Utilization** metric and scale up PTUs, or reduce request volume. |

## Next steps

- [Set up metric alerts for Azure resources](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-metric-overview)
- [Create Azure Monitor workbooks](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview)
- [Learn about deployment types in Foundry Models](../../06-models/06.3-offers-deployment-types-and-pricing/04-deployment-types.md)
- [Azure Monitor overview](https://learn.microsoft.com/en-us/azure/azure-monitor/overview)
