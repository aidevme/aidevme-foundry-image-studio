# Azure OpenAI image and audio REST API reference (2024-10-21)

| Field | Value |
| --- | --- |
| **Document Title** | Azure OpenAI image and audio REST API reference (2024-10-21) |
| **Document Location** | `docs/research-docs/azure-foundry/05-developer-tools-and-integrations/05.4-sdks-and-apis/07-reference.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Azure OpenAI image and audio REST API reference (2024-10-21)". Reference for the Azure OpenAI image generation and audio (speech) REST API operations in the 2024-10-21 GA release. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/openai/reference). Article date: 2026-05-19. Page updated: 2026-06-24. Retrieved: 2026-09-29. Navigation: Developer tools and integrations > SDKs and APIs > Azure OpenAI > Previous versions > 2024-10-21 image and audio reference.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

This article documents the image generation and audio (speech) data plane inference REST API operations for Azure OpenAI in the `2024-10-21` GA release. For chat completions, embeddings, completions, and all other operations, see the [official Azure OpenAI REST API reference](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/azureopenai/chat?view=rest-microsoft-foundry-2024-10-21&preserve-view=true).

## API specs

Managing and interacting with Azure OpenAI models and resources is divided across three primary API surfaces:

- Control plane
- Data plane - authoring
- Data plane - inference

Each API surface/specification encapsulates a different set of Azure OpenAI capabilities. Each API has its own unique set of preview and stable/generally available (GA) API releases. Preview releases currently tend to follow a monthly cadence.

> **Important**
>
> There is now a new preview inference API. Learn more in our [API lifecycle guide](04-api-version-lifecycle.md#api-evolution).

| API | Latest preview release | Latest GA release | Specifications | Description |
| --- | --- | --- | --- | --- |
| **Control plane** | `2025-07-01-preview` | [`2025-06-01`](https://learn.microsoft.com/en-us/rest/api/microsoftfoundry/accountmanagement/operation-groups?view=rest-microsoftfoundry-accountmanagement-2025-06-01&preserve-view=true) | [Spec files](https://github.com/Azure/azure-rest-api-specs/blob/main/specification/cognitiveservices/resource-manager/Microsoft.CognitiveServices/stable/2025-06-01/cognitiveservices.json) | The control plane API is used for operations like [creating resources](https://learn.microsoft.com/en-us/rest/api/microsoftfoundry/accountmanagement/accounts/create?view=rest-microsoftfoundry-accountmanagement-2025-06-01&tabs=HTTP&preserve-view=true), [model deployment](https://learn.microsoft.com/en-us/rest/api/microsoftfoundry/accountmanagement/deployments/create-or-update?view=rest-microsoftfoundry-accountmanagement-2025-06-01&tabs=HTTP&preserve-view=true), and other higher level resource management tasks. The control plane also governs what is possible to do with capabilities like Azure Resource Manager, Bicep, Terraform, and Azure CLI. |
| **Data plane** | [`v1 preview`](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/azureopenai/chat?view=rest-microsoft-foundry-v1-preview&preserve-view=true) | [`v1`](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/azureopenai/chat?view=rest-microsoft-foundry-v1&preserve-view=true) | [Spec files](https://github.com/Azure/azure-rest-api-specs/tree/main/specification/ai/data-plane/OpenAI.v1) | The data plane API controls inference and authoring operations. |

## Authentication

Azure OpenAI provides two methods for authentication. You can use either API Keys or Microsoft Entra ID.

- **API Key authentication**: For this type of authentication, all API requests must include the API Key in the `api-key` HTTP header. The [Quickstart](../../06-models/06.6-develop-with-ai-models/02-responses.md) provides guidance for how to make calls with this type of authentication.
- **Microsoft Entra ID authentication**: You can authenticate an API call using a Microsoft Entra token. Authentication tokens are included in a request as the `Authorization` header. The token provided must be preceded by `Bearer`, for example `Bearer YOUR_AUTH_TOKEN`. You can read our how-to guide on [authenticating with Microsoft Entra ID](https://learn.microsoft.com/en-us/azure/foundry-classic/openai/how-to/managed-identity).

### REST API versioning

The service APIs are versioned using the `api-version` query parameter. All versions follow the YYYY-MM-DD date structure. For example:

```http
POST https://YOUR_RESOURCE_NAME.openai.azure.com/openai/deployments/YOUR_DEPLOYMENT_NAME/chat/completions?api-version=2024-06-01
```

## Data plane inference

The rest of this article covers the image and audio operations in the GA release of the Azure OpenAI data plane inference specification, `2024-10-21`.

For the preview image and audio operations, see the [preview image and audio REST API reference](08-reference-preview.md).

## Transcriptions - Create

```HTTP
POST https://{endpoint}/openai/deployments/{deployment-id}/audio/transcriptions?api-version=2024-10-21
```

Transcribes audio into the input language.

### URI Parameters

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| endpoint | path | Yes | string url | Supported Azure OpenAI endpoints (protocol and hostname, for example: `https://aoairesource.openai.azure.com`. Replace "aoairesource" with your Azure OpenAI resource name). https://{your-resource-name}.openai.azure.com |
| deployment-id | path | Yes | string | Deployment ID of the speech to text model. For information about supported models, see [/azure/ai-foundry/openai/concepts/models#audio-models]. |
| api-version | query | Yes | string | API version |

### Request Header

| Name | Required | Type | Description |
| --- | --- | --- | --- |
| api-key | True | string | Provide Azure OpenAI API key here |

### Request Body

**Content-Type**: multipart/form-data

| Name | Type | Description | Required | Default |
| --- | --- | --- | --- | --- |
| file | string | The audio file object to transcribe. | Yes |   |
| prompt | string | An optional text to guide the model's style or continue a previous audio segment. The prompt should match the audio language. | No |   |
| response_format | [audioResponseFormat](#audioresponseformat) | Defines the format of the output. | No |   |
| temperature | number | The sampling temperature, between 0 and 1. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. If set to 0, the model will use log probability to automatically increase the temperature until certain thresholds are hit. | No | 0 |
| language | string | The language of the input audio. Supplying the input language in ISO-639-1 format will improve accuracy and latency. | No |   |

### Responses

**Status Code:** 200

**Description**: OK

| **Content-Type** | **Type** | **Description** |
| --- | --- | --- |
| application/json | [audioResponse](#audioresponse) or [audioVerboseResponse](#audioverboseresponse) |   |
| text/plain | string | Transcribed text in the output format (when response_format was one of text, vtt or srt). |

### Examples

### Example

Gets transcribed text and associated metadata from provided spoken audio data.

```HTTP
POST https://{endpoint}/openai/deployments/{deployment-id}/audio/transcriptions?api-version=2024-10-21
```

**Responses**: Status Code: 200

```json
{
  "body": {
    "text": "A structured object when requesting json or verbose_json"
  }
}
```

### Example

Gets transcribed text and associated metadata from provided spoken audio data.

```HTTP
POST https://{endpoint}/openai/deployments/{deployment-id}/audio/transcriptions?api-version=2024-10-21

"---multipart-boundary\nContent-Disposition: form-data; name=\"file\"; filename=\"file.wav\"\nContent-Type: application/octet-stream\n\nRIFF..audio.data.omitted\n---multipart-boundary--"
```

**Responses**: Status Code: 200

```json
{
  "type": "string",
  "example": "plain text when requesting text, srt, or vtt"
}
```

## Translations - Create

```HTTP
POST https://{endpoint}/openai/deployments/{deployment-id}/audio/translations?api-version=2024-10-21
```

Transcribes and translates input audio into English text.

### URI Parameters

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| endpoint | path | Yes | string url | Supported Azure OpenAI endpoints (protocol and hostname, for example: `https://aoairesource.openai.azure.com`. Replace "aoairesource" with your Azure OpenAI resource name). https://{your-resource-name}.openai.azure.com |
| deployment-id | path | Yes | string | Deployment ID of the transcription model which was deployed. For information about supported models, see [/azure/ai-foundry/openai/concepts/models#audio-models]. |
| api-version | query | Yes | string | API version |

### Request Header

| Name | Required | Type | Description |
| --- | --- | --- | --- |
| api-key | True | string | Provide Azure OpenAI API key here |

### Request Body

**Content-Type**: multipart/form-data

| Name | Type | Description | Required | Default |
| --- | --- | --- | --- | --- |
| file | string | The audio file to translate. | Yes |   |
| prompt | string | An optional text to guide the model's style or continue a previous audio segment. The prompt should be in English. | No |   |
| response_format | [audioResponseFormat](#audioresponseformat) | Defines the format of the output. | No |   |
| temperature | number | The sampling temperature, between 0 and 1. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. If set to 0, the model will use log probability to automatically increase the temperature until certain thresholds are hit. | No | 0 |

### Responses

**Status Code:** 200

**Description**: OK

| **Content-Type** | **Type** | **Description** |
| --- | --- | --- |
| application/json | [audioResponse](#audioresponse) or [audioVerboseResponse](#audioverboseresponse) |   |
| text/plain | string | Transcribed text in the output format (when response_format was one of text, vtt or srt). |

### Examples

### Example

Gets English language transcribed text and associated metadata from provided spoken audio data.

```HTTP
POST https://{endpoint}/openai/deployments/{deployment-id}/audio/translations?api-version=2024-10-21

"---multipart-boundary\nContent-Disposition: form-data; name=\"file\"; filename=\"file.wav\"\nContent-Type: application/octet-stream\n\nRIFF..audio.data.omitted\n---multipart-boundary--"
```

**Responses**: Status Code: 200

```json
{
  "body": {
    "text": "A structured object when requesting json or verbose_json"
  }
}
```

### Example

Gets English language transcribed text and associated metadata from provided spoken audio data.

```HTTP
POST https://{endpoint}/openai/deployments/{deployment-id}/audio/translations?api-version=2024-10-21

"---multipart-boundary\nContent-Disposition: form-data; name=\"file\"; filename=\"file.wav\"\nContent-Type: application/octet-stream\n\nRIFF..audio.data.omitted\n---multipart-boundary--"
```

**Responses**: Status Code: 200

```json
{
  "type": "string",
  "example": "plain text when requesting text, srt, or vtt"
}
```

## Image generation

```HTTP
POST https://{endpoint}/openai/deployments/{deployment-id}/images/generations?api-version=2024-10-21
```

Generates a batch of images from a text caption on a given dall-e model deployment

### URI Parameters

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| endpoint | path | Yes | string url | Supported Azure OpenAI endpoints (protocol and hostname, for example: `https://aoairesource.openai.azure.com`. Replace "aoairesource" with your Azure OpenAI resource name). https://{your-resource-name}.openai.azure.com |
| deployment-id | path | Yes | string | Deployment ID of the dall-e model which was deployed. |
| api-version | query | Yes | string | API version |

### Request Header

| Name | Required | Type | Description |
| --- | --- | --- | --- |
| api-key | True | string | Provide Azure OpenAI API key here |

### Request Body

**Content-Type**: application/json

| Name | Type | Description | Required | Default |
| --- | --- | --- | --- | --- |
| prompt | string | A text description of the desired image(s). The maximum length is 4,000 characters. | Yes |   |
| n | integer | The number of images to generate. | No | 1 |
| size | [imageSize](#imagesize) | The size of the generated images. | No | 1024x1024 |
| response_format | [imagesResponseFormat](#imagesresponseformat) | The format in which the generated images are returned. | No | url |
| user | string | A unique identifier representing your end-user, which can help to monitor and detect abuse. | No |   |
| quality | [imageQuality](#imagequality) | The quality of the image that will be generated. | No | standard |
| style | [imageStyle](#imagestyle) | The style of the generated images. | No | vivid |

### Responses

**Status Code:** 200

**Description**: Ok

| **Content-Type** | **Type** | **Description** |
| --- | --- | --- |
| application/json | [generateImagesResponse](#generateimagesresponse) |   |

**Status Code:** default

**Description**: An error occurred.

| **Content-Type** | **Type** | **Description** |
| --- | --- | --- |
| application/json | [dalleErrorResponse](#dalleerrorresponse) |   |

### Examples

### Example

Creates images given a prompt.

```HTTP
POST https://{endpoint}/openai/deployments/{deployment-id}/images/generations?api-version=2024-10-21

{
 "prompt": "In the style of WordArt, Microsoft Clippy wearing a cowboy hat.",
 "n": 1,
 "style": "natural",
 "quality": "standard"
}
```

**Responses**: Status Code: 200

```json
{
  "body": {
    "created": 1698342300,
    "data": [
      {
        "revised_prompt": "A vivid, natural representation of Microsoft Clippy wearing a cowboy hat.",
        "prompt_filter_results": {
          "sexual": {
            "severity": "safe",
            "filtered": false
          },
          "violence": {
            "severity": "safe",
            "filtered": false
          },
          "hate": {
            "severity": "safe",
            "filtered": false
          },
          "self_harm": {
            "severity": "safe",
            "filtered": false
          },
          "profanity": {
            "detected": false,
            "filtered": false
          }
        },
        "url": "https://dalletipusw2.blob.core.windows.net/private/images/e5451cc6-b1ad-4747-bd46-b89a3a3b8bc3/generated_00.png?se=2023-10-27T17%3A45%3A09Z&...",
        "content_filter_results": {
          "sexual": {
            "severity": "safe",
            "filtered": false
          },
          "violence": {
            "severity": "safe",
            "filtered": false
          },
          "hate": {
            "severity": "safe",
            "filtered": false
          },
          "self_harm": {
            "severity": "safe",
            "filtered": false
          }
        }
      }
    ]
  }
}
```

## Components

For the schema definitions used by chat, completions, embeddings, and other text operations, see the [Azure OpenAI REST API reference](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/azureopenai/chat?view=rest-microsoft-foundry-v1&preserve-view=true). The following schemas support the image and audio operations on this page.

### innerErrorCode

Error codes for the inner error object.

**Description**: Error codes for the inner error object.

**Type**: string

**Default**:

**Enum Name**: InnerErrorCode

**Enum Values**:

| Value | Description |
| --- | --- |
| ResponsibleAIPolicyViolation | The prompt violated one of more content filter rules. |

### dalleErrorResponse

| Name | Type | Description | Required | Default |
| --- | --- | --- | --- | --- |
| error | [dalleError](#dalleerror) |   | No |   |

### dalleError

| Name | Type | Description | Required | Default |
| --- | --- | --- | --- | --- |
| param | string |   | No |   |
| type | string |   | No |   |
| inner_error | [dalleInnerError](#dalleinnererror) | Inner error with additional details. | No |   |

### dalleInnerError

Inner error with additional details.

| Name | Type | Description | Required | Default |
| --- | --- | --- | --- | --- |
| code | [innerErrorCode](#innererrorcode) | Error codes for the inner error object. | No |   |
| content_filter_results | [dalleFilterResults](#dallefilterresults) | Information about the content filtering category (hate, sexual, violence, self_harm), if it has been detected, as well as the severity level (very_low, low, medium, high-scale that determines the intensity and risk level of harmful content) and if it has been filtered or not. Information about jailbreak content and profanity, if it has been detected, and if it has been filtered or not. And information about customer blocklist, if it has been filtered and its id. | No |   |
| revised_prompt | string | The prompt that was used to generate the image, if there was any revision to the prompt. | No |   |

### contentFilterSeverityResult

| Name | Type | Description | Required | Default |
| --- | --- | --- | --- | --- |
| filtered | boolean |   | Yes |   |
| severity | string |   | No |   |

### contentFilterDetectedResult

| Name | Type | Description | Required | Default |
| --- | --- | --- | --- | --- |
| filtered | boolean |   | Yes |   |
| detected | boolean |   | No |   |

### dalleFilterResults

Information about the content filtering category (hate, sexual, violence, self_harm), if it has been detected, as well as the severity level (very_low, low, medium, high-scale that determines the intensity and risk level of harmful content) and if it has been filtered or not. Information about jailbreak content and profanity, if it has been detected, and if it has been filtered or not. And information about customer blocklist, if it has been filtered and its id.

| Name | Type | Description | Required | Default |
| --- | --- | --- | --- | --- |
| sexual | [contentFilterSeverityResult](#contentfilterseverityresult) |   | No |   |
| violence | [contentFilterSeverityResult](#contentfilterseverityresult) |   | No |   |
| hate | [contentFilterSeverityResult](#contentfilterseverityresult) |   | No |   |
| self_harm | [contentFilterSeverityResult](#contentfilterseverityresult) |   | No |   |
| profanity | [contentFilterDetectedResult](#contentfilterdetectedresult) |   | No |   |
| jailbreak | [contentFilterDetectedResult](#contentfilterdetectedresult) |   | No |   |

### audioResponse

Translation or transcription response when response_format was json

| Name | Type | Description | Required | Default |
| --- | --- | --- | --- | --- |
| text | string | Translated or transcribed text. | Yes |   |

### audioVerboseResponse

Translation or transcription response when response_format was verbose_json

| Name | Type | Description | Required | Default |
| --- | --- | --- | --- | --- |
| text | string | Translated or transcribed text. | Yes |   |
| task | string | Type of audio task. | No |   |
| language | string | Language. | No |   |
| duration | number | Duration. | No |   |
| segments | array |   | No |   |

### audioResponseFormat

Defines the format of the output.

**Description**: Defines the format of the output.

**Type**: string

**Default**:

**Enum Values**:

- json
- text
- srt
- verbose_json
- vtt

### imageQuality

The quality of the image that will be generated.

**Description**: The quality of the image that will be generated.

**Type**: string

**Default**: standard

**Enum Name**: Quality

**Enum Values**:

| Value | Description |
| --- | --- |
| standard | Standard quality creates images with standard quality. |
| hd | HD quality creates images with finer details and greater consistency across the image. |

### imagesResponseFormat

The format in which the generated images are returned.

**Description**: The format in which the generated images are returned.

**Type**: string

**Default**: url

**Enum Name**: ImagesResponseFormat

**Enum Values**:

| Value | Description |
| --- | --- |
| url | The URL that provides temporary access to download the generated images. |
| b64_json | The generated images are returned as base64 encoded string. |

### imageSize

The size of the generated images.

**Description**: The size of the generated images.

**Type**: string

**Default**: 1024x1024

**Enum Name**: Size

**Enum Values**:

| Value | Description |
| --- | --- |
| 1792x1024 | The desired size of the generated image is 1792x1024 pixels. |
| 1024x1792 | The desired size of the generated image is 1024x1792 pixels. |
| 1024x1024 | The desired size of the generated image is 1024x1024 pixels. |

### imageStyle

The style of the generated images.

**Description**: The style of the generated images.

**Type**: string

**Default**: vivid

**Enum Name**: Style

**Enum Values**:

| Value | Description |
| --- | --- |
| vivid | Vivid creates images that are hyper-realistic and dramatic. |
| natural | Natural creates images that are more natural and less hyper-realistic. |

### generateImagesResponse

| Name | Type | Description | Required | Default |
| --- | --- | --- | --- | --- |
| created | integer | The unix timestamp when the operation was created. | Yes |   |
| data | array | The result data of the operation, if successful | Yes |   |

## Next steps

Learn about [models and fine-tuning with the REST API](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/azureopenai/fine-tuning?view=rest-microsoft-foundry-2025-04-01-preview&preserve-view=true). Learn more about the [underlying models that power Azure OpenAI](../../06-models/06.1-explore-foundry-models/01-models-sold-directly-by-azure.md).
