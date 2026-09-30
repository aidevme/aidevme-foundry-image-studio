# Realtime API reference

| Field | Value |
| --- | --- |
| **Document Title** | Realtime API reference |
| **Document Location** | `docs/research-docs/azure-foundry/05-developer-tools-and-integrations/05.4-sdks-and-apis/10-realtime-audio-reference.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Realtime API reference". Reference for the Azure OpenAI Realtime API events, with notes on Azure-specific deviations from the OpenAI specification. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/openai/realtime-audio-reference). Article date: 2026-05-13. Page updated: 2026-06-05. Retrieved: 2026-09-29. Navigation: Developer tools and integrations > SDKs and APIs > Reference documentation > Realtime API reference.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

The Azure OpenAI Realtime API follows the OpenAI Realtime API specification. For the full API reference, see the [OpenAI Realtime API reference](https://developers.openai.com/api/reference/resources/realtime).

> **Note**
>
> **Azure deviation:** The accepted values for the `model` field in `input_audio_transcription` settings differ from the OpenAI reference. Azure OpenAI requires the name of the existing model deployment for the field, like `my-gpt-4o-transcribe-deployment`. See details about [Model deployment via Foundry Portal](../../06-models/06.4-model-deployment/01-deploy-foundry-models.md) or [with code](../../06-models/06.4-model-deployment/02-create-model-deployments.md).
