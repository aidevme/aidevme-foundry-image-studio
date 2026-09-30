# Foundry Models sold by Azure in Azure Government

| Field | Value |
| --- | --- |
| **Document Title** | Foundry Models sold by Azure in Azure Government |
| **Document Location** | `docs/research-docs/azure-foundry/06-models/06.1-explore-foundry-models/02-models-sold-directly-by-azure-gov.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Foundry Models sold by Azure in Azure Government". Learn about Microsoft Foundry Models sold by Azure in Azure Government, their capabilities, deployment types, and regional availability for AI applications. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure-gov). Article date: 2026-09-01. Page updated: 2026-09-01. Retrieved: 2026-09-29. Navigation: Models > Explore Foundry Models > Foundry Models sold by Azure (government).
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

This article lists a selection of Microsoft Foundry Models sold by Azure in Azure Government along with their capabilities and [deployment types, and regions of availability](../06.3-offers-deployment-types-and-pricing/05-deployment-types-gov.md).

Models sold by Azure include all Azure OpenAI models offered in Azure Government. These models are billed through your Azure subscription, covered by Azure service-level agreements, and supported by Microsoft.

To learn more about attributes of all Foundry Models sold by Azure across all clouds, see [Models sold by Azure](01-models-sold-directly-by-azure.md).

## Azure OpenAI in Microsoft Foundry models in Azure Government

Azure OpenAI is powered by a diverse set of models with different capabilities and price points. Model availability in Azure Government varies by region.

| Models | Description |
| --- | --- |
| [GPT-5.6 series](02-models-sold-directly-by-azure-gov.md#gpt-56) | **NEW** `gpt-5.6-sol`, `gpt-5.6-terra`, `gpt-5.6-luna` |
| [GPT-5.1 series](02-models-sold-directly-by-azure-gov.md#gpt-51) | `gpt-5.1` |
| [GPT-4.1 series](02-models-sold-directly-by-azure-gov.md#gpt-41-series) | gpt-4.1, gpt-4.1-mini |
| [o-series models](02-models-sold-directly-by-azure-gov.md#o-series-models) | [Reasoning models](../06.6-develop-with-ai-models/16-reasoning.md) with advanced problem solving and increased focus and capability. |
| [GPT-4o](02-models-sold-directly-by-azure-gov.md#gpt-4o) | Capable Azure OpenAI models with multimodal versions, which can accept both text and images as input. |
| [Embeddings](02-models-sold-directly-by-azure-gov.md#embeddings) | A set of models that can convert text into numerical vector form to facilitate text similarity. |

## GPT-5.6

### Region availability

| Model | Region |
| --- | --- |
| `gpt-5.6-sol` (2026-07-09) | See the [models table](#model-summary-table-and-region-availability). |
| `gpt-5.6-terra` (2026-07-09) | See the [models table](#model-summary-table-and-region-availability). |
| `gpt-5.6-luna` (2026-07-09) | See the [models table](#model-summary-table-and-region-availability). |

### Capabilities

| Model ID | Description | Context Window | Max Output Tokens | Training Data (up to) |
| --- | --- | --- | --- | --- |
| `gpt-5.6-sol` (2026-07-09) | - [Reasoning](../06.6-develop-with-ai-models/16-reasoning.md) - [Responses API](../06.6-develop-with-ai-models/02-responses.md). - Chat Completions API. - Structured outputs. - Text and image processing. - Functions, tools, and parallel tool calling. - [Computer use](https://learn.microsoft.com/en-us/azure/foundry-classic/openai/how-to/computer-use) - [Full summary of capabilities](../06.6-develop-with-ai-models/16-reasoning.md). | 1,050,000 Input: 922,000 Output: 128,000 | 128,000 | June 2026 |
| `gpt-5.6-terra` (2026-07-09) | - [Reasoning](../06.6-develop-with-ai-models/16-reasoning.md) - [Responses API](../06.6-develop-with-ai-models/02-responses.md). - Chat Completions API. - Structured outputs. - Text and image processing. - Functions, tools, and parallel tool calling. - [Computer use](https://learn.microsoft.com/en-us/azure/foundry-classic/openai/how-to/computer-use) - [Full summary of capabilities](../06.6-develop-with-ai-models/16-reasoning.md). | 1,050,000 Input: 922,000 Output: 128,000 | 128,000 | June 2026 |
| `gpt-5.6-luna` (2026-07-09) | - [Reasoning](../06.6-develop-with-ai-models/16-reasoning.md) - [Responses API](../06.6-develop-with-ai-models/02-responses.md). - Chat Completions API. - Structured outputs. - Text and image processing. - Functions, tools, and parallel tool calling. - [Computer use](https://learn.microsoft.com/en-us/azure/foundry-classic/openai/how-to/computer-use) - [Full summary of capabilities](../06.6-develop-with-ai-models/16-reasoning.md). | 1,050,000 Input: 922,000 Output: 128,000 | 128,000 | June 2026 |

## GPT-5.1

### Region availability

| Model | Region |
| --- | --- |
| `gpt-5.1` | See the [models table](#model-summary-table-and-region-availability). |

| Model ID | Description | Context Window | Max Output Tokens | Training Data (up to) |
| --- | --- | --- | --- | --- |
| `gpt-5.1` (2025-11-13) | - [Reasoning](../06.6-develop-with-ai-models/16-reasoning.md) - Chat Completions API. - [Responses API](../06.6-develop-with-ai-models/02-responses.md). - Structured outputs. - Text and image processing. - Functions, tools, and parallel tool calling. - [Full summary of capabilities](../06.6-develop-with-ai-models/16-reasoning.md). | 400,000 Input: 272,000 Output: 128,000 | 128,000 | September 30, 2024 |

> **Important**
>
> - `gpt-5.1` `reasoning_effort` defaults to `none`. When upgrading from previous reasoning models to `gpt-5.1`, keep in mind that you may need to update your code to explicitly pass a `reasoning_effort` level if you want reasoning to occur.

## GPT-4.1 series

### Region availability

| Model | Region |
| --- | --- |
| `gpt-4.1` (2025-04-14) | See the [models table](#model-summary-table-and-region-availability). |
| `gpt-4.1-mini` (2025-04-14) | See the [models table](#model-summary-table-and-region-availability). |

### Capabilities

> **Important**
>
> A known issue is affecting all GPT 4.1 series models. Large tool or function call definitions that exceed 300,000 tokens will result in failures, even though the 1 million token context limit of the models wasn't reached.
>
> The errors can vary based on API call and underlying payload characteristics.
>
> Here are the error messages for the Chat Completions API:
>
> - `Error code: 400 - {'error': {'message': "This model's maximum context length is 300000 tokens. However, your messages resulted in 350564 tokens (100 in the messages, 350464 in the functions). Please reduce the length of the messages or functions.", 'type': 'invalid_request_error', 'param': 'messages', 'code': 'context_length_exceeded'}}`
> - `Error code: 400 - {'error': {'message': "Invalid 'tools[0].function.description': string too long. Expected a string with maximum length 1048576, but got a string with length 2778531 instead.", 'type': 'invalid_request_error', 'param': 'tools[0].function.description', 'code': 'string_above_max_length'}}`
>
> Here's the error message for the Responses API:
>
> - `Error code: 500 - {'error': {'message': 'The server had an error processing your request. Sorry about that! You can retry your request, or contact us through an Azure support request at: https://go.microsoft.com/fwlink/?linkid=2213926 if you keep seeing this error. (Please include the request ID d2008353-291d-428f-adc1-defb5d9fb109 in your email.)', 'type': 'server_error', 'param': None, 'code': None}}`

| Model ID | Description | Context window | Max output tokens | Training data (up to) |
| --- | --- | --- | --- | --- |
| `gpt-4.1` (2025-04-14) | - Text and image input - Text output - Chat completions API - Responses API - Streaming - Function calling - Structured outputs (chat completions) | - 1,047,576 **(not available)** - 128,000 (standard & provisioned managed deployments) - 300,000 (batch deployments) | 32,768 | May 31, 2024 |
| `gpt-4.1-mini` (2025-04-14) | - Text and image input - Text output - Chat completions API - Responses API - Streaming - Function calling - Structured outputs (chat completions) | - 1,047,576 **(not available)** - 128,000 (standard & provisioned managed deployments) - 300,000 (batch deployments) | 32,768 | May 31, 2024 |

## o-series models

The Azure OpenAI o-series models are designed to tackle reasoning and problem-solving tasks with increased focus and capability. These models spend more time processing and understanding the user's request, making them exceptionally strong in areas like science, coding, and math, compared to previous iterations.

| Model ID | Description | Max request (tokens) | Training data (up to) |
| --- | --- | --- | --- |
| `o3-mini` (2025-01-31) | - [Enhanced reasoning abilities](../06.6-develop-with-ai-models/16-reasoning.md). - Structured outputs. - Text-only processing. - Functions and tools. | Input: 200,000 Output: 100,000 | October 2023 |

To learn more about advanced o-series models, see [Getting started with reasoning models](../06.6-develop-with-ai-models/16-reasoning.md).

### Region availability

| Model | Region |
| --- | --- |
| `o3-mini` | See the [models table](#model-summary-table-and-region-availability). |

## GPT-4o

GPT-4o integrates text and images in a single model, which enables it to handle multiple data types simultaneously. This multimodal approach enhances accuracy and responsiveness in human-computer interactions. GPT-4o matches GPT-4 Turbo in English text and coding tasks while offering superior performance in non-English language tasks and vision tasks, setting new benchmarks for AI capabilities.

| Model ID | Description | Max request (tokens) | Training data (up to) |
| --- | --- | --- | --- |
| `gpt-4o` (2024-11-20) GPT-4o (Omni) | - Structured outputs. - Text and image processing. - JSON Mode. - Parallel function calling. - Enhanced accuracy and responsiveness. - Parity with English text and coding tasks compared to GPT-4 Turbo with Vision. - Superior performance in non-English languages and in vision tasks. - Enhanced creative writing ability. | Input: 128,000 Output: 16,384 | October 2023 |

## Embeddings

`text-embedding-3-large` is the latest and most capable embedding model. You can't upgrade between embeddings models. To move from using `text-embedding-ada-002` to `text-embedding-3-large`, you need to generate new embeddings.

- `text-embedding-3-large`
- `text-embedding-3-small`
- `text-embedding-ada-002`

OpenAI reports that testing shows that both the large and small third generation embeddings models offer better average multi-language retrieval performance with the [MIRACL](https://github.com/project-miracl/miracl) benchmark. They still maintain performance for English tasks with the [MTEB](https://github.com/embeddings-benchmark/mteb) benchmark.

| Evaluation benchmark | `text-embedding-ada-002` | `text-embedding-3-small` | `text-embedding-3-large` |
| --- | --- | --- | --- |
| MIRACL average | 31.4 | 44.0 | 54.9 |
| MTEB average | 61.0 | 62.3 | 64.6 |

The third generation embeddings models support reducing the size of the embedding via a new `dimensions` parameter. Typically, larger embeddings are more expensive from a compute, memory, and storage perspective. When you can adjust the number of dimensions, you gain more control over overall cost and performance. The `dimensions` parameter isn't supported in all versions of the OpenAI 1.x Python library. To take advantage of this parameter, we recommend that you upgrade to the latest version: `pip install openai --upgrade`.

OpenAI's MTEB benchmark testing found that even when the third generation model's dimensions are reduced to less than the 1,536 dimensions of `text-embeddings-ada-002`, performance remains slightly better.

## Model summary table and region availability

### Models by deployment type

Azure OpenAI provides customers with choices on the hosting structure that fits their business and usage patterns. The service offers two main types of deployment:

- **Standard**: Has a USGov datazone deployment option, routing traffic within Azure Government to provide higher throughput.
- **Provisioned**: Also has a datazone deployment option, allowing customers to purchase and deploy provisioned throughput units across Azure Government infrastructure.

All deployments can perform the exact same inference operations, but the billing, scale, and performance are substantially different. To learn more about Azure OpenAI deployment types, see our [Deployment types guide](../06.3-offers-deployment-types-and-pricing/05-deployment-types-gov.md).

**[Data Zone Standard]**

### Data Zone Standard model availability

| **Region** | **gpt-5.6-sol**, **2026-07-09** | **gpt-5.6-terra**, **2026-07-09** | **gpt-5.6-luna**, **2026-07-09** | **gpt-5.1**, **2025-11-13** | **gpt-4.1**, **2025-04-14** | **gpt-4.1-mini**, **2025-04-14** | **o3-mini**, **2025-01-31** | **gpt-4o**, **2024-11-20** | **text-embedding-ada-002**, **2** | **text-embedding-3-large**, **1** | **text-embedding-3-small**, **1** |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| usgovarizona | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | - | ✅ | ✅ |
| usgovvirginia | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | - | ✅ | ✅ |

**[Data Zone Provisioned managed]**

### Data Zone Provisioned managed model availability

| **Region** | **gpt-5.6-sol**, **2026-07-09** | **gpt-5.6-terra**, **2026-07-09** | **gpt-5.6-luna**, **2026-07-09** | **gpt-5.1**, **2025-11-13** | **gpt-4.1**, **2025-04-14** | **gpt-4.1-mini**, **2025-04-14** | **o3-mini**, **2025-01-31** | **gpt-4o**, **2024-11-20** | **text-embedding-ada-002**, **2** | **text-embedding-3-large**, **1** | **text-embedding-3-small**, **1** |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| usgovarizona | ✅ | ✅ | ✅ | - | - | ✅ | ✅ | ✅ | - | - | - |
| usgovvirginia | ✅ | ✅ | ✅ | - | - | ✅ | ✅ | ✅ | - | - | - |

**[Standard]**

### Standard deployment model availability

| **Region** | **gpt-5.1**, **2025-11-13** | **gpt-4.1**, **2025-04-14** | **gpt-4.1-mini**, **2025-04-14** | **o3-mini**, **2025-01-31** | **gpt-4o**, **2024-11-20** | **text-embedding-ada-002**, **2** | **text-embedding-3-large**, **1** | **text-embedding-3-small**, **1** |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| usgovarizona | - | ✅ | ✅ | - | ✅ | ✅ | ✅ | ✅ |
| usgovvirginia | - | ✅ | ✅ | - | ✅ | - | - | - |

**[Provisioned managed]**

### Provisioned deployment model availability

| **Region** | **gpt-5.1**, **2025-11-13** | **gpt-4.1**, **2025-04-14** | **gpt-4.1-mini**, **2025-04-14** | **o3-mini**, **2025-01-31** | **gpt-4o**, **2024-11-20** | **text-embedding-ada-002**, **2** | **text-embedding-3-large**, **1** | **text-embedding-3-small**, **1** |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| usgovarizona | - | - | - | - | ✅ | - | - | - |
| usgovvirginia |   | - | - | - | ✅ | - | - | - |

For more information about provisioned deployments, see [Provisioned throughput in Azure Government](../06.3-offers-deployment-types-and-pricing/10-provisioned-throughput-gov.md).

### Embeddings models

These models can be used only with Embedding API requests.

> **Note**
>
> `text-embedding-3-large` is the latest and most capable embedding model. You can't upgrade between embedding models. To migrate from using `text-embedding-ada-002` to `text-embedding-3-large`, you need to generate new embeddings.

| Model ID | Max request (tokens) | Output dimensions | Training data (up to) |
| --- | --- | --- | --- |
| `text-embedding-ada-002` (version 2) | 8,192 | 1,536 | Sep 2021 |
| `text-embedding-ada-002` (version 1) | 2,046 | 1,536 | Sep 2021 |
| `text-embedding-3-large` | 8,192 | 3,072 | Sep 2021 |
| `text-embedding-3-small` | 8,192 | 1,536 | Sep 2021 |

> **Note**
>
> When you send an array of inputs for embedding, the maximum number of input items in the array per call to the embedding endpoint is 2,048.

## Model retirement

In some cases, models are retired in Azure Government earlier or later than in the commercial cloud. For the latest information on model retirements, refer to the [model retirement guide](14-model-retirements-gov.md).

## Related content

- [Model retirement and deprecation](14-model-retirements-gov.md)
- [Learn more about working with Azure OpenAI models](12-working-with-models.md)
- [Learn more about Azure OpenAI](02-models-sold-directly-by-azure-gov.md)
