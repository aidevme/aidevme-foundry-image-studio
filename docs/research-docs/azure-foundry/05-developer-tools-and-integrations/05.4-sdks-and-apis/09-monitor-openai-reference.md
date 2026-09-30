# Azure OpenAI monitoring data reference

| Field | Value |
| --- | --- |
| **Document Title** | Azure OpenAI monitoring data reference |
| **Document Location** | `docs/research-docs/azure-foundry/05-developer-tools-and-integrations/05.4-sdks-and-apis/09-monitor-openai-reference.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Azure OpenAI monitoring data reference". This article contains important reference material you need when you monitor Azure OpenAI in Microsoft Foundry Models by using Azure Monitor. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/openai/monitor-openai-reference). Article date: 2026-05-19. Page updated: 2026-05-19. Retrieved: 2026-09-29. Navigation: Developer tools and integrations > SDKs and APIs > Reference documentation > Azure OpenAI monitoring data reference.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

This article contains all the monitoring reference information for this service.

For details on the data you can collect for Azure OpenAI in Microsoft Foundry Models and how to use it, see [Monitor Azure OpenAI](https://learn.microsoft.com/en-us/azure/foundry-classic/openai/how-to/monitor-openai).

## Metrics

This section lists all the automatically collected platform metrics for this service. These metrics are also part of the global list of [all platform metrics supported in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-metrics/metrics-index#supported-metrics-per-resource-type).

For information on metric retention, see [Azure Monitor Metrics overview](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).

### Supported metrics for Microsoft.CognitiveServices/accounts

Monitor the most important metrics for Azure OpenAI. Later in this article, you find a longer list of all available metrics for this namespace, which contains more details on metrics in this shorter list. *Please see the following list for the most up-to-date information. The Azure team is working on refreshing the tables in the following sections.*

> **Important**
>
> Don't confuse the metrics in this section with the legacy `Latency` metric listed under **Cognitive Services - HTTP Requests** later in this article. The legacy `Latency` metric isn't designed for Azure OpenAI workloads and produces misleading results when used to diagnose Azure OpenAI latency. For Azure OpenAI latency monitoring, use **Time to Response** (`AzureOpenAITimeToResponse`), **Time to Last Byte** (`AzureOpenAITTLTInMS`), **Time Between Tokens** (`AzureOpenAINormalizedTBTInMS`), or **Normalized Time to First Byte** (`AzureOpenAINormalizedTTFTInMS`). For guidance on interpreting these metrics, see [Performance and latency](../../06-models/06.9-development-best-practices/04-latency.md).

- Azure OpenAI Requests
- Active Tokens
- Generated Completion Tokens
- Processed FineTuned Training Hours
- Processed Inference Tokens
- Processed Prompt Tokens
- Provisioned-managed Utilization V2
- Prompt Token Cache Match Rate
- Time to Response
- Time Between Tokens
- Time to Last Byte
- Normalized Time to First Byte
- Tokens per Second

You can also monitor Content Safety metrics that other related services use.

- Blocked Volume
- Harmful Volume Detected
- Potential Abusive User Count
- Safety System Event
- Total Volume Sent for Safety Check

> **Note**
>
> The **Provisioned-managed Utilization** metric is now deprecated and is no longer recommended. This metric is replaced by the **Provisioned-managed Utilization V2** metric. Tokens per Second, Time to Response, and Time Between Tokens aren't currently available for Standard deployments.

#### Quick reference: Key metrics by use case

Use this table to find the right metric for a specific monitoring goal. For end-to-end guidance on interpreting these metrics, see [Performance and latency](../../06-models/06.9-development-best-practices/04-latency.md).

| I want to monitor... | Use this metric | REST API name |
| --- | --- | --- |
| Overall response time | Time to Last Byte | `AzureOpenAITTLTInMS` |
| First-token responsiveness (streaming) | Time to Response | `AzureOpenAITimeToResponse` |
| Token generation speed | Time Between Tokens | `AzureOpenAINormalizedTBTInMS` |
| First-token efficiency normalized by prompt size | Normalized Time to First Byte | `AzureOpenAINormalizedTTFTInMS` |
| Output token volume per request | Generated Completion Tokens | `GeneratedTokens` |
| Input token volume per request | Processed Prompt Tokens | `ProcessedPromptTokens` |
| PTU capacity utilization | Provisioned-managed Utilization V2 | `AzureOpenAIProvisionedManagedUtilizationV2` |
| Request volume and errors | Azure OpenAI Requests | `AzureOpenAIRequests` |

> **Tip**
>
> Always pair a latency metric with a token count metric. A latency increase without a corresponding token increase might indicate a real issue. A latency increase with a proportional token increase is expected behavior.

> **Warning**
>
> The metrics under **Cognitive Services - HTTP Requests** later in this article are legacy Cognitive Services metrics and aren't designed for Azure OpenAI workloads. In particular, the `Latency` metric in that category isn't the same as the Azure OpenAI latency metrics (Time to Response, Time to Last Byte, Time Between Tokens, Normalized Time to First Byte). Using the legacy `Latency` metric for Azure OpenAI troubleshooting produces misleading results. Use the Azure OpenAI metrics listed in this section instead.

The following table lists the metrics available for the Microsoft.CognitiveServices/accounts resource type.

- All columns might not be present in every table.
- Some columns might be beyond the viewing area of the page. Select **Expand table** to view all available columns.

**Table headings**

- **Category** - The metrics group or classification.
- **Metric** - The metric display name as it appears in the Azure portal.
- **Name in REST API** - The metric name as referred to in the [REST API](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/rest-api-walkthrough).
- **Unit** - Unit of measure.
- **Aggregation** - The default [aggregation](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average (Avg), Minimum (Min), Maximum (Max), Total (Sum), Count.
- **Dimensions** - [Dimensions](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
- **Time Grains** - [Intervals](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity) at which the metric is sampled. For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
- **DS Export**- Whether the metric is exportable to Azure Monitor Logs via diagnostic settings. For information on exporting metrics, see [Create diagnostic settings in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

### Category: Azure OpenAI - HTTP Requests

| Metric | Name in REST API | [Advanced platform metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-advanced-platform) | Unit | Aggregation | Dimensions | Time Grains | DS Export |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Azure OpenAI AvailabilityRate** Availability percentage with the following calculation: (Total Calls - Server Errors)/Total Calls. Server Errors include any HTTP responses >=500. | `AzureOpenAIAvailabilityRate` | No | Percent | Minimum, Maximum, Average | `ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion` | PT1M | No |
| **Azure OpenAI Requests** Number of calls made to the Azure OpenAI API over a period of time. Applies to PTU, PTU-Managed and Pay-as-you-go deployments. To breakdown API requests, you can add a filter or apply splitting by the following dimensions: ModelDeploymentName, ModelName, ModelVersion, StatusCode (successful, clienterrors, server errors), IsSpillover for spillover information, ServiceTier, StreamType (Streaming vs non-streaming requests) and operation. | `AzureOpenAIRequests` | No | Count | Total (Sum) | `ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `StatusCode`, `IsSpillover`, `ServiceTierRequest`, `ServiceTierResponse` | PT1M | Yes |

### Category: Azure OpenAI - Latency

| Metric | Name in REST API | [Advanced platform metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-advanced-platform) | Unit | Aggregation | Dimensions | Time Grains | DS Export |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Time Between Token** For streaming requests; model token generation rate, measured in milliseconds. Applies to PTU, PTU-managed and Pay-as-you-go deployments. | `AzureOpenAINormalizedTBTInMS` | No | MilliSeconds | Maximum, Minimum, Average | `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `ServiceTierRequest`, `ServiceTierResponse` | PT1M | Yes |
| **Normalized Time to First Byte** For streaming and non-streaming requests; time it takes for first byte of response data to be received after request is made by model, normalized by token. Applies to PTU, PTU-managed, and Pay-as-you-go deployments. | `AzureOpenAINormalizedTTFTInMS` | No | MilliSeconds | Maximum, Minimum, Average | `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `ServiceTierRequest`, `ServiceTierResponse` | PT1M | Yes |
| **Time to Response** Recommended latency (responsiveness) measure for streaming requests. Applies to PTU, PTU-managed and Pay-as-you-go deployments. Calculated as time taken for the first response to appear after a user sends a prompt, as measured by the API gateway. This number increases as the prompt size increases and/or cache hit size reduces. To breakdown time to response metric, you can add a filter or apply splitting by the following dimensions: ModelDeploymentName, ModelName, and ModelVersion. Note: this metric is an approximation as measured latency is heavily dependent on multiple factors, including concurrent calls and overall workload pattern. In addition, it does not account for any client-side latency that may exist between your client and the API endpoint. Please refer to your own logging for optimal latency tracking. | `AzureOpenAITimeToResponse` | No | MilliSeconds | Minimum, Maximum, Average | `ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `StatusCode`, `ServiceTierRequest`, `ServiceTierResponse` | PT1M | Yes |
| **Tokens Per Second** Enumerates the generation speed for a given Azure OpenAI model response. The total tokens generated is divided by the time to generate the tokens, in seconds. Applies to PTU, PTU-managed and Pay-as-you-go deployments. | `AzureOpenAITokenPerSecond` | No | Count | Maximum, Minimum, Average | `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `ServiceTierRequest`, `ServiceTierResponse` | PT1M | Yes |
| **Time to Last Byte** For streaming and non-streaming requests; time it takes for last byte of response data to be received after request is made by model. Applies to PTU, PTU-managed, and Pay-as-you-go deployments. | `AzureOpenAITTLTInMS` | No | MilliSeconds | Maximum, Minimum, Average | `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `ServiceTierRequest`, `ServiceTierResponse` | PT1M | Yes |

### Category: Azure OpenAI - Usage

| Metric | Name in REST API | [Advanced platform metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-advanced-platform) | Unit | Aggregation | Dimensions | Time Grains | DS Export |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Active Tokens** Total tokens minus cached tokens over a period of time. Applies to PTU and PTU-managed deployments. Use this metric to understand your TPS or TPM based utilization for PTUs and compare to your benchmarks for target TPS or TPM for your scenarios. To breakdown API requests, you can add a filter or apply splitting by the following dimensions: ModelDeploymentName, ModelName, and ModelVersion. | `ActiveTokens` | No | Count | Minimum, Maximum, Average, Total (Sum) | `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `ServiceTierRequest`, `ServiceTierResponse` | PT1M | Yes |
| **Audio Completion Tokens** Number of audio prompt tokens generated (output) on an OpenAI model. Applies to PTU-managed and Pay-as-you-go model deployments. | `AudioCompletionTokens` | No | Count | Total (Sum) | `ModelDeploymentName`, `ModelName`, `ModelVersion`, `Region` | PT1M | Yes |
| **Audio Prompt Tokens** Number of audio prompt tokens processed (input) on an OpenAI model. Applies to PTU-managed and Pay-as-you-go model deployments. | `AudioPromptTokens` | No | Count | Total (Sum) | `ModelDeploymentName`, `ModelName`, `ModelVersion`, `Region` | PT1M | Yes |
| **Prompt Token Cache Match Rate** Percentage of prompt tokens that hit the cache. Applies to PTU and PTU-managed deployments. | `AzureOpenAIContextTokensCacheMatchRate` | No | Percent | Minimum, Maximum, Average | `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion` | PT1M | No |
| **Provisioned-managed Utilization (deprecated)** Utilization % for a provisoned-managed deployment, calculated as (PTUs consumed / PTUs deployed) x 100. When utilization is greater than or equal to 100%, calls are throttled and error code 429 returned. To breakdown this metric, you can add a filter or apply splitting by the following dimensions: ModelDeploymentName, ModelName, ModelVersion and StreamType (Streaming vs non-streaming requests) | `AzureOpenAIProvisionedManagedUtilization` | No | Percent | Minimum, Maximum, Average | `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion` | PT1M | No |
| **Provisioned-managed Utilization V2** Utilization % for a provisoned-managed deployment, calculated as (PTUs consumed / PTUs deployed) x 100. When utilization is greater than or equal to 100%, calls are throttled and error code 429 returned. To breakdown this metric, you can add a filter or apply splitting by the following dimensions: ModelDeploymentName, ModelName, ModelVersion and StreamType (Streaming vs non-streaming requests) | `AzureOpenAIProvisionedManagedUtilizationV2` | No | Percent | Minimum, Maximum, Average | `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion` | PT1M | No |
| **Processed FineTuned Training Hours** Number of Training Hours Processed on an OpenAI FineTuned Model | `FineTunedTrainingHours` | No | Count | Total (Sum) | `ApiName`, `ModelDeploymentName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Generated Completion Tokens** Number of tokens generated (output) from an OpenAI model. Applies to PTU, PTU-managed and Pay-as-you-go deployments. To breakdown this metric, you can add a filter or apply splitting by the following dimensions: ModelDeploymentName and ModelName. | `GeneratedTokens` | No | Count | Total (Sum) | `ApiName`, `ModelDeploymentName`, `FeatureName`, `UsageChannel`, `Region`, `ModelVersion`, `ServiceTierRequest`, `ServiceTierResponse` | PT1M | Yes |
| **Processed Prompt Tokens** Number of prompt tokens processed (input) on an OpenAI model. Applies to PTU, PTU-managed and Pay-as-you-go deployments. To breakdown this metric, you can add a filter or apply splitting by the following dimensions: ModelDeploymentName and ModelName. | `ProcessedPromptTokens` | No | Count | Total (Sum) | `ApiName`, `ModelDeploymentName`, `FeatureName`, `UsageChannel`, `Region`, `ModelVersion`, `ServiceTierRequest`, `ServiceTierResponse` | PT1M | Yes |
| **Realtime API Seconds Used** RealtimeAPI number of seconds used | `RealtimeUsageTime` | No | Count | Total (Sum) | `Region`, `ModelDeploymentName` | PT1M | Yes |
| **Processed Inference Tokens** Number of inference tokens processed on an OpenAI model. Calculated as prompt tokens (input) plus generated tokens (output). Applies to PTU, PTU-managed and Pay-as-you-go deployments. To breakdown this metric, you can add a filter or apply splitting by the following dimensions: ModelDeploymentName and ModelName. | `TokenTransaction` | No | Count | Total (Sum) | `ApiName`, `ModelDeploymentName`, `FeatureName`, `UsageChannel`, `Region`, `ModelVersion`, `ServiceTierRequest`, `ServiceTierResponse` | PT1M | Yes |

### Category: Cognitive Services - HTTP Requests

| Metric | Name in REST API | [Advanced platform metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-advanced-platform) | Unit | Aggregation | Dimensions | Time Grains | DS Export |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Blocked Calls** Number of calls that exceeded rate or quota limit. Do not use for Azure OpenAI service. | `BlockedCalls` | No | Count | Total (Sum) | `ApiName`, `OperationName`, `Region`, `RatelimitKey` | PT1M | Yes |
| **Client Errors** Number of calls with client side error (HTTP response code 4xx). Do not use for Azure OpenAI service. | `ClientErrors` | No | Count | Total (Sum) | `ApiName`, `OperationName`, `Region`, `RatelimitKey` | PT1M | Yes |
| **Data In** Size of incoming data in bytes. Do not use for Azure OpenAI service. | `DataIn` | No | Bytes | Total (Sum) | `ApiName`, `OperationName`, `Region` | PT1M | Yes |
| **Data Out** Size of outgoing data in bytes. Do not use for Azure OpenAI service. | `DataOut` | No | Bytes | Total (Sum) | `ApiName`, `OperationName`, `Region` | PT1M | Yes |
| **Latency** Latency in milliseconds. Do not use for Azure OpenAI service. | `Latency` | No | MilliSeconds | Average | `ApiName`, `OperationName`, `Region`, `RatelimitKey` | PT1M | Yes |
| **Ratelimit** The current ratelimit of the ratelimit key. Do not use for Azure OpenAI service. | `Ratelimit` | No | Count | Total (Sum) | `Region`, `RatelimitKey` | PT1M | Yes |
| **Server Errors** Number of calls with service internal error (HTTP response code 5xx). Do not use for Azure OpenAI service. | `ServerErrors` | No | Count | Total (Sum) | `ApiName`, `OperationName`, `Region`, `RatelimitKey` | PT1M | Yes |
| **Successful Calls** Number of successful calls. Do not use for Azure OpenAI service. | `SuccessfulCalls` | No | Count | Total (Sum) | `ApiName`, `OperationName`, `Region`, `RatelimitKey` | PT1M | Yes |
| **Total Calls** Total number of calls. Do not use for Azure OpenAI service. | `TotalCalls` | No | Count | Total (Sum) | `ApiName`, `OperationName`, `Region`, `RatelimitKey` | PT1M | Yes |
| **Total Errors** Total number of calls with error response (HTTP response code 4xx or 5xx). Do not use for Azure OpenAI service. | `TotalErrors` | No | Count | Total (Sum) | `ApiName`, `OperationName`, `Region`, `RatelimitKey` | PT1M | Yes |
| **Total Token Calls** Total number of token calls. | `TotalTokenCalls` | No | Count | Total (Sum) | `ApiName`, `OperationName`, `Region` | PT1M | Yes |

### Category: Cognitive Services - SLI

| Metric | Name in REST API | [Advanced platform metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-advanced-platform) | Unit | Aggregation | Dimensions | Time Grains | DS Export |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **AvailabilityRate** Availability percentage with the following calculation: (Total Calls - Server Errors)/Total Calls. Server Errors include any HTTP responses >=500. Do not use for Azure OpenAI service. | `SuccessRate` | No | Percent | Minimum, Maximum, Average | `ApiName`, `OperationName`, `Region`, `RatelimitKey` | PT1M | No |

### Category: Content Understanding - Usage

| Metric | Name in REST API | [Advanced platform metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-advanced-platform) | Unit | Aggregation | Dimensions | Time Grains | DS Export |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Face Transactions** Number of API calls made to Face service | `FaceApiTransactions` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Processed Audio Minutes** Minutes of audio processed | `ProcessedAudioMinutes` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Processed Pages** Number of document pages processed | `ProcessedDocumentPages` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Processed Images** Number of images processed | `ProcessedImageCount` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Processed Video Minutes** Minutes of video processed | `ProcessedVideoMinutes` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Tokens** Number of tokens consumed | `Tokens` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |

### Category: ContentSafety - Risks&Safety

| Metric | Name in REST API | [Advanced platform metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-advanced-platform) | Unit | Aggregation | Dimensions | Time Grains | DS Export |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Harmful Volume Detected** Number of calls made to Azure OpenAI API and detected as harmful(both block model and annotate mode) by content filter applied over a period of time. You can add a filter or apply splitting by the following dimensions: ModelDeploymentName, ModelName and TextType. | `RAIHarmfulRequests` | No | Count | Total (Sum) | `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `ApiName`, `TextType`, `Category`, `Severity` | PT1M | Yes |
| **Blocked Volume** Number of calls made to Azure OpenAI API and rejected by content filter applied over a period of time. You can add a filter or apply splitting by the following dimensions: ModelDeploymentName, ModelName and TextType. | `RAIRejectedRequests` | No | Count | Total (Sum) | `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `ApiName`, `TextType`, `Category` | PT1M | Yes |
| **Safety System Event** System event for risks & safety monitoring. You can add a filter or apply splitting by the following dimension: EventType. | `RAISystemEvent` | No | Count | Average | `Region`, `EventType` | PT1M | Yes |
| **Total Volume Sent For Safety Check** Number of calls made to Azure OpenAI API and detected by content filter applied over a period of time. You can add a filter or apply splitting by the following dimensions: ModelDeploymentName, ModelName. | `RAITotalRequests` | No | Count | Total (Sum) | `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `ApiName` | PT1M | Yes |

### Category: ContentSafety - Usage

| Metric | Name in REST API | [Advanced platform metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-advanced-platform) | Unit | Aggregation | Dimensions | Time Grains | DS Export |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Call Count for Image Moderation** Number of calls for image moderation. | `ContentSafetyImageAnalyzeRequestCount` | No | Count | Total (Sum) | `ApiVersion` | PT1M | Yes |
| **Call Count for Text Moderation** Number of calls for text moderation. | `ContentSafetyTextAnalyzeRequestCount` | No | Count | Total (Sum) | `ApiVersion` | PT1M | Yes |

### Category: Language - Jobs

| Metric | Name in REST API | [Advanced platform metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-advanced-platform) | Unit | Aggregation | Dimensions | Time Grains | DS Export |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Job Duration (Preview)** Note: this value depends heavily on the input size, number of documents and task's complexity. This is an aggregate value across all job tasks. | `JobDuration` | No | MilliSeconds | Minimum, Maximum, Average | `JobStatus`, `JobType` | PT1M | Yes |

### Category: Model Router

| Metric | Name in REST API | [Advanced platform metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-advanced-platform) | Unit | Aggregation | Dimensions | Time Grains | DS Export |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Model Router Fallback Count** Number of requests that required fallback to an alternative model. | `ModelRouterFallbackCount` | No | Count | Total (Sum) | `ModelDeploymentName`, `ModelName`, `Region`, `RouterMode` | PT1M | Yes |
| **Model Router Latency** Time taken by model router to make a routing decision. | `ModelRouterLatency` | No | MilliSeconds | Minimum, Maximum, Average | `ModelDeploymentName`, `ModelName`, `Region`, `RouterMode` | PT1M | Yes |
| **Model Router Requests** Total number of requests processed by model router. | `ModelRouterRequests` | No | Count | Total (Sum) | `ModelDeploymentName`, `ModelName`, `Region`, `RouterMode` | PT1M | Yes |
| **Model Router Source Model Fallback** Number of requests where the first attempted model failed, causing a fallback to another model. | `ModelRouterSourceModelFallback` | No | Count | Total (Sum) | `ModelDeploymentName`, `ModelName`, `Region`, `RouterMode`, `SourceModelName` | PT1M | Yes |
| **Model Router Successful Requests** Number of requests successfully routed without error. | `ModelRouterSuccessfulRequests` | No | Count | Total (Sum) | `ModelDeploymentName`, `ModelName`, `Region`, `RouterMode` | PT1M | Yes |

### Category: Models - HTTP Requests

| Metric | Name in REST API | [Advanced platform metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-advanced-platform) | Unit | Aggregation | Dimensions | Time Grains | DS Export |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Model Availability Rate** Availability percentage with the following calculation: (Total Calls - Server Errors)/Total Calls. Server Errors include any HTTP responses >=500. | `ModelAvailabilityRate` | No | Percent | Minimum, Maximum, Average | `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion` | PT1M | No |
| **Model Requests** Number of calls made to the model API over a period of time. Applies to PTU, PTU-Managed and Pay-as-you-go deployments. | `ModelRequests` | No | Count | Total (Sum) | `ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `StatusCode`, `IsSpillover`, `ServiceTierRequest`, `ServiceTierResponse` | PT1M | Yes |

### Category: Models - Latency

| Metric | Name in REST API | [Advanced platform metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-advanced-platform) | Unit | Aggregation | Dimensions | Time Grains | DS Export |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Time Between Tokens** Model token generation rate, measured in milliseconds. Applies to PTU and PTU-managed deployments. For non-streaming requests, this value is an estimate. | `NormalizedTimeBetweenTokens` | No | MilliSeconds | Maximum, Minimum, Average | `ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion` | PT1M | Yes |
| **Normalized Time to First Byte** Time it takes for first byte of response data to be received after request is made by model, normalized by token. Applies to PTU, PTU-managed, and Pay-as-you-go deployments. For non-streaming requests, this value is an estimate. | `NormalizedTimeToFirstToken` | No | MilliSeconds | Maximum, Minimum, Average | `ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion` | PT1M | Yes |
| **Time to Last Byte** Time it takes for last byte of response data to be received after request is made by model. Applies to PTU, PTU-managed, and Pay-as-you-go deployments. For non-streaming requests, this value is an estimate. | `TimeToLastByte` | No | MilliSeconds | Maximum, Minimum, Average | `ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion` | PT1M | Yes |
| **Time to Response** Recommended latency (responsiveness) measure. Applies to PTU and PTU-managed deployments. Calculated as time taken for the first response to appear after a user sends a prompt, as measured by the API gateway. This number increases as the prompt size increases and/or cache hit size reduces. To breakdown time to response metric, you can add a filter or apply splitting by the following dimensions: ModelDeploymentName, ModelName, and ModelVersion. Note: this metric is an approximation as measured latency is heavily dependent on multiple factors, including concurrent calls and overall workload pattern. In addition, it does not account for any client-side latency that may exist between your client and the API endpoint. For non-streaming requests, this value is an estimate. Please refer to your own logging for optimal latency tracking. | `TimeToResponse` | No | MilliSeconds | Minimum, Maximum, Average | `ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `StatusCode` | PT1M | Yes |
| **Tokens Per Second** Enumerates the generation speed for a given model response. The total tokens generated is divided by the time to generate the tokens, in seconds. Applies to PTU and PTU-managed deployments. For non-streaming requests, this value is an estimate. | `TokensPerSecond` | No | Count | Maximum, Minimum, Average | `ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion` | PT1M | Yes |

### Category: Models - Usage

| Metric | Name in REST API | [Advanced platform metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-advanced-platform) | Unit | Aggregation | Dimensions | Time Grains | DS Export |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Annotated Pages** Total number of pages processed with annotations. Applies to PTU, PTU-Managed and Pay-as-you-go deployments. | `AnnotatedPages` | No | Count | Total (Sum) | `ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion` | PT1M | Yes |
| **Audio Input Tokens** Number of audio prompt tokens processed (input) on an OpenAI model. Applies to PTU-managed model deployments. | `AudioInputTokens` | No | Count | Total (Sum) | `ModelDeploymentName`, `ModelName`, `ModelVersion`, `Region` | PT1M | Yes |
| **Audio Output Tokens** Number of audio prompt tokens generated (output) on an OpenAI model. Applies to PTU-managed model deployments. | `AudioOutputTokens` | No | Count | Total (Sum) | `ModelDeploymentName`, `ModelName`, `ModelVersion`, `Region` | PT1M | Yes |
| **Prompt tokens read from cache** Total number of tokens read from the cache. Applies to Anthropic model deployments. Surfaced in response usage section as `cache_read_input_tokens` | `cacheReadInputTokens` | No | Count | Total (Sum) | `ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `ContextLength` | PT1M | Yes |
| **Prompt tokens written to cache (1 hour TTL)** The number of prompt tokens used to create the 1 hour entry. Applies to Anthropic model deployments. Surfaced in response usage section as `cache_creation.ephemeral_1h_input_tokens` | `ephemeral1hInputTokens` | No | Count | Total (Sum) | `ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `ContextLength` | PT1M | Yes |
| **Prompt tokens written to cache (5 minute TTL)** The number of prompt tokens used to create the 5 minute cache entry. Applies to Anthropic model deployments. Surfaced in response usage section as `cache_creation.ephemeral_5m_input_tokens` | `ephemeral5mInputTokens` | No | Count | Total (Sum) | `ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `ContextLength` | PT1M | Yes |
| **Generated Images** Total number of images generated. Applies to PTU, PTU-Managed and Pay-as-you-go deployments. | `GeneratedImages` | No | Count | Total (Sum) | `ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion` | PT1M | Yes |
| **Input Tokens** Number of prompt tokens processed (input) on a model. Applies to PTU, PTU-Managed and Pay-as-you-go deployments. | `InputTokens` | No | Count | Total (Sum) | `ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion` | PT1M | Yes |
| **Output Tokens** Number of tokens generated (output) from an OpenAI model. Applies to PTU, PTU-Managed and Pay-as-you-go deployments. | `OutputTokens` | No | Count | Total (Sum) | `ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion` | PT1M | Yes |
| **Provisioned Utilization** Utilization % for a provisoned-managed deployment, calculated as (PTUs consumed / PTUs deployed) x 100. When utilization is greater than or equal to 100%, calls are throttled and error code 429 returned. | `ProvisionedUtilization` | No | Percent | Minimum, Maximum, Average | `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion` | PT1M | No |
| **Total Pages** Total number of pages processed. Applies to PTU, PTU-Managed and Pay-as-you-go deployments. | `TotalPages` | No | Count | Total (Sum) | `ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion` | PT1M | Yes |
| **Total Tokens** Number of inference tokens processed on a model. Calculated as prompt tokens (input) plus generated tokens (output). Applies to PTU, PTU-Managed and Pay-as-you-go deployments. | `TotalTokens` | No | Count | Total (Sum) | `ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion` | PT1M | Yes |

### Category: SpeechServices - Usage

| Metric | Name in REST API | [Advanced platform metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-advanced-platform) | Unit | Aggregation | Dimensions | Time Grains | DS Export |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Audio Seconds Batch Transcribed** Batch number of seconds transcribed | `AudioSecondsBatchTranscribed` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Audio Seconds Batch Whisper Transcribed** Batch whisper number of seconds transcribed | `AudioSecondsBatchWhisperTranscribed` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Audio Seconds Fast Transcribed** Fast number of seconds transcribed | `AudioSecondsFastTranscribed` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Audio Seconds Fast Whisper Transcribed** Fast whisper number of seconds transcribed | `AudioSecondsFastWhisperTranscribed` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Audio Seconds Transcribed** Number of seconds transcribed | `AudioSecondsTranscribed` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Audio Seconds Translated** Number of seconds translated | `AudioSecondsTranslated` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Avatar Model Hosting Seconds** Number of Seconds. | `AvatarModelHostingSeconds` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Avatar Model Training Seconds** Number of Seconds. | `AvatarModelTrainingSeconds` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Speech Model Hosting Hours** Number of speech model hosting hours | `SpeechModelHostingHours` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Synthesized Characters** Number of Characters. | `SynthesizedCharacters` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Video Seconds Synthesized** Number of seconds synthesized | `VideoSecondsSynthesized` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Voice Live Audio Input Tokens** Number of audio input tokens, excluding cached tokens. | `VoiceLiveAudioInputTokens` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Voice Live Audio Output Tokens** Number of audio output tokens. | `VoiceLiveAudioOutputTokens` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Voice Live Cached Audio Input Tokens** Number of cached audio input tokens. | `VoiceLiveCachedAudioInputTokens` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Voice Live Cached Text Input Tokens** Number of cached text input tokens. | `VoiceLiveCachedTextInputTokens` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Voice Live Text Input Tokens** Number of text input tokens, excluding cached tokens. | `VoiceLiveTextInputTokens` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Voice Live Text Output Tokens** Number of text output tokens. | `VoiceLiveTextOutputTokens` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Voice Model Hosting Hours** Number of Hours. | `VoiceModelHostingHours` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Voice Model Training Minutes** Number of Minutes. | `VoiceModelTrainingMinutes` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |

### Category: Translator Services - Usage

| Metric | Name in REST API | [Advanced platform metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-advanced-platform) | Unit | Aggregation | Dimensions | Time Grains | DS Export |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Document Characters Translated** Number of characters in document translation request. | `DocumentCharactersTranslated` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Document Custom Characters Translated** Number of characters in custom document translation request. | `DocumentCustomCharactersTranslated` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Document Sync Characters Translated** Number of characters in document translation (synchronous) request. | `OneDocumentCharactersTranslated` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Document Sync Custom Characters Translated** Number of characters in custom document translation (synchronous) request. | `OneDocumentCustomCharactersTranslated` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Text Characters Translated** Number of characters in incoming text translation request. | `TextCharactersTranslated` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Text Custom Characters Translated** Number of characters in incoming custom text translation request. | `TextCustomCharactersTranslated` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Text Trained Characters** Number of characters trained using text translation. | `TextTrainedCharacters` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Translator Pro App Seconds** Number of seconds of Translator Pro App usage. | `TranslatorProAppSeconds` | No | Seconds | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |

### Category: Usage

| Metric | Name in REST API | [Advanced platform metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-advanced-platform) | Unit | Aggregation | Dimensions | Time Grains | DS Export |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Computer Vision Transactions** Number of Computer Vision Transactions | `ComputerVisionTransactions` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Custom Vision Training Time** Custom Vision training time | `CustomVisionTrainingTime` | No | Seconds | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Custom Vision Transactions** Number of Custom Vision prediction transactions | `CustomVisionTransactions` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Face Images Trained** Number of images trained. 1,000 images trained per transaction. | `FaceImagesTrained` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Faces Stored** Number of faces stored, prorated daily. The number of faces stored is reported daily. | `FacesStored` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Face Transactions** Number of API calls made to Face service | `FaceTransactions` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Images Stored** Number of Custom Vision images stored. | `ImagesStored` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Learned Events** Number of Learned Events. | `LearnedEvents` | No | Count | Total (Sum) | `IsMatchBaseline`, `Mode`, `RunId` | PT1M | Yes |
| **LUIS Speech Requests** Number of LUIS speech to intent understanding requests | `LUISSpeechRequests` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **LUIS Text Requests** Number of LUIS text requests | `LUISTextRequests` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Matched Rewards** Number of Matched Rewards. | `MatchedRewards` | No | Count | Total (Sum) | `Mode`, `RunId` | PT1M | Yes |
| **Non Activated Events** Number of skipped events. | `NonActivatedEvents` | No | Count | Total (Sum) | `Mode`, `RunId` | PT1M | Yes |
| **Observed Rewards** Number of Observed Rewards. | `ObservedRewards` | No | Count | Total (Sum) | `Mode`, `RunId` | PT1M | Yes |
| **Processed Characters** Number of Characters processed by Immersive Reader. | `ProcessedCharacters` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Processed Health Text Records** Number of health text records processed | `ProcessedHealthTextRecords` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Processed Images** Number of images processed | `ProcessedImages` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Processed Pages** Number of pages processed | `ProcessedPages` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Processed Text Records** Count of Text Records. | `ProcessedTextRecords` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **QA Text Records** Number of text records processed | `QuestionAnsweringTextRecords` | No | Count | Total (Sum) | `ApiName`, `FeatureName`, `UsageChannel`, `Region` | PT1M | Yes |
| **Total Events** Number of events. | `TotalEvents` | No | Count | Total (Sum) | `Mode`, `RunId` | PT1M | Yes |
| **Total Transactions (Deprecated)** Total number of transactions. | `TotalTransactions` | No | Count | Total (Sum) | &lt;none> | PT1M | Yes |

## Metric dimensions

For information about what metric dimensions are, see [Multi-dimensional metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/data-platform-metrics#multi-dimensional-metrics).

This service has the following dimensions associated with its metrics.

- ApiName
- FeatureName
- ModelDeploymentName
- ModelName
- ModelVersion
- OperationName
- Region
- StatusCode
- StreamType
- UsageChannel

## Resource logs

This section lists the types of resource logs you can collect for this service. The section pulls from the list of [all resource logs category types supported in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs-schema).

### Supported resource logs for Microsoft.CognitiveServices/accounts

| Category | Costs to export | Log table | [Supports basic log plan](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans) | [Supports ingestion-time transformation](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-collection-transformations) | Example queries |
| --- | --- | --- | --- | --- | --- |
| Audit | No | [AzureDiagnostics](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/azurediagnostics) Logs from multiple Azure resources. | No | No |   |
| AzureOpenAIRequestUsage | Yes | [AzureDiagnostics](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/azurediagnostics) Logs from multiple Azure resources. | No | No |   |
| ManagedNetworkEvent | Yes | [AzureDiagnostics](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/azurediagnostics) Logs from multiple Azure resources. | No | No |   |
| RequestResponse | No | [AzureDiagnostics](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/azurediagnostics) Logs from multiple Azure resources. | No | No |   |
| Trace | No | [AzureDiagnostics](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/azurediagnostics) Logs from multiple Azure resources. | No | No |   |

## Azure Monitor Logs tables

This section lists the Azure Monitor Logs tables relevant to this service, which are available for query by Log Analytics using Kusto queries. The tables contain resource log data and possibly more depending on what is collected and routed to them.

### Azure OpenAI microsoft.cognitiveservices/accounts

- [AzureActivity](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/azureactivity#columns)
- [AzureMetrics](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/azuremetrics#columns)
- [AzureDiagnostics](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/azurediagnostics#columns)

## Activity log

The linked table lists the operations that can be recorded in the activity log for this service. These operations are a subset of [all the possible resource provider operations in the activity log](https://learn.microsoft.com/en-us/azure/role-based-access-control/resource-provider-operations).

For more information on the schema of activity log entries, see [Activity Log schema](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/activity-log-schema).

- [AI + machine learning resource provider operations](https://learn.microsoft.com/en-us/azure/role-based-access-control/resource-provider-operations#microsoftsearch)

## Related content

- For a description of monitoring Azure OpenAI, see [Monitor Azure OpenAI](https://learn.microsoft.com/en-us/azure/foundry-classic/openai/how-to/monitor-openai).
- For details on monitoring Azure resources, see [Monitor Azure resources with Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/monitor-azure-resource).
