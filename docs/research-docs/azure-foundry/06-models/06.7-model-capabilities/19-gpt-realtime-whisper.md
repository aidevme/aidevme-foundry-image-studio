# GPT Realtime Transcribe overview

| Field | Value |
| --- | --- |
| **Document Title** | GPT Realtime Transcribe overview |
| **Document Location** | `docs/research-docs/azure-foundry/06-models/06.7-model-capabilities/19-gpt-realtime-whisper.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "GPT Realtime Transcribe overview". Learn about GPT Realtime Transcribe, a streaming transcription model for low-latency real-time captioning and monitoring of live audio. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/openai/concepts/gpt-realtime-whisper). Article date: 2026-05-07. Page updated: 2026-07-30. Retrieved: 2026-09-29. Navigation: Models > Model capabilities > Realtime API > GPT Realtime Transcribe.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

GPT Realtime Transcribe is a streaming transcription model that converts live audio to text in real time. You can use it alongside speech-to-speech and translation models to provide continuous input transcription for audio streams.

> **Note**
>
> GPT Realtime Transcribe is a Realtime API model. For offline file transcription via `POST /v1/audio/transcriptions`, use `gpt-transcribe`.

Realtime transcription uses a persistent streaming session, not one-request-per-file upload. Choose Realtime API when you need low-latency transcript updates while audio is still in progress.

> **Note**
>
> GPT Realtime Whisper is a Realtime API model. For offline file transcription via `POST /v1/audio/transcriptions`, use `gpt-transcribe`.

Realtime transcription uses a persistent streaming session, not one-request-per-file upload. Choose Realtime API when you need low-latency transcript updates while audio is still in progress.

## Key capabilities

- **Streaming transcription**: Transcribes live audio as it arrives, without waiting for the utterance to complete.
- **Low latency**: Designed for real-time scenarios where delays aren't acceptable, such as live captions or quality monitoring.
- **Parallel operation**: Runs alongside other realtime models (such as GPT Realtime Translate) to provide source-language transcription in parallel with translation.

## When to use GPT Realtime Transcribe

Use GPT Realtime Transcribe when you need:

- Live captions and subtitles for ongoing audio streams.
- Transcription for monitoring, moderation, or analytics workflows.
- Original-language speech captured alongside live translation experiences.
- Text visibility into spoken input while other models process the audio.

## Example use cases

- **Live event captioning**: Provide real-time captions in the speaker's original language during conferences, webinars, or broadcasts.
- **Compliance and quality review**: Capture the original conversation as text for regulatory compliance, quality assurance, or analytics.
- **Multilingual pipelines**: Pair with GPT Realtime Translate to deliver both translated output and a source-language transcript in a single workflow.

## Get started

You can access GPT Realtime Transcribe through the Realtime API. The connection and usage patterns are the same as for other realtime models:

- [Use the GPT Realtime API via WebSockets](15-realtime-audio-websockets.md)
- [Use the GPT Realtime API via WebRTC](14-realtime-audio-webrtc.md)

Use the same quickstart code patterns, and set your deployment name to the model deployment you created for `gpt-realtime-whisper`.

## Language support guidance

GPT Realtime Transcribe is designed for multilingual transcription. Accuracy can vary by language, audio quality, and speaking conditions.

- Provide an ISO-639-1 language hint (for example, `en`) when available.
- Validate transcription quality with production-like audio before rollout.
- For broader language and locale references, see [Language and voice support for the Speech service](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/language-support).

## Deployment and availability

You can deploy GPT Realtime Transcribe as a Global Standard (pay-as-you-go) deployment in Microsoft Foundry. Deploy the model from the [model catalog](https://ai.azure.com/).

For current region support, see [Region availability for Foundry Models sold by Azure](../06.2-quota-limits-and-region-availability/01-models-sold-directly-by-azure-region-availability.md).

## Pricing

`gpt-realtime-whisper` is priced hourly. For current rates, see the **Audio Models** section on the [Azure OpenAI pricing page](https://azure.microsoft.com/pricing/details/cognitive-services/openai-service/).
