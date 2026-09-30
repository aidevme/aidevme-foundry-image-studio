# Pricing for voice-based agents

| Field | Value |
| --- | --- |
| **Document Title** | Pricing for voice-based agents |
| **Document Location** | `docs/research-docs/azure-foundry/07-agents/07.2-prompt-agents/22-voice-agent-pricing.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Pricing for voice-based agents". Understand what drives cost for a voice-based agent in Microsoft Foundry, including audio tokens, model hosting, avatars, and stored recordings. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/voice-agent-pricing). Article date: 2026-08-31. Page updated: 2026-09-24. Retrieved: 2026-09-29. Navigation: Agents > Prompt agents > Voice-first agents > Build > Pricing.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

A voice-based agent bills differently from a text agent because audio, not text, is the main input and output. A single minute of conversation produces far more tokens than a minute of typing, and the way you host the model changes which meter the usage lands on.

This article explains what drives cost for a voice agent and how to see usage before your invoice arrives. For current rates, see [Microsoft Foundry pricing](https://azure.microsoft.com/pricing/details/ai-foundry/).

> **Important**
>
> Items marked (preview) in this article are currently in public preview. This preview is provided without a service-level agreement, and we don't recommend it for production workloads. Certain features might not be supported or might have constrained capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## What drives cost

Five things determine what a voice agent costs:

| Factor | Effect |
| --- | --- |
| Audio tokens | Both caller audio and agent speech are tokenized. Audio tokens typically outnumber text tokens in a voice session by a wide margin. |
| Model hosting | `managed` models are billed through the service. `self_deployed` models are billed through your own Foundry model deployment. |
| Session length | Cost scales with connected conversation time, because audio is consumed and produced continuously. |
| Tools | Tool calls add model turns, and server-side tools such as toolboxes and MCP servers bill through their own resources. |
| Optional features | Avatars add video synthesis. Setting `store` to `true` adds storage for transcripts and audio. |

## Choose between managed and self-deployed models

`model_type` determines where model usage is billed:

- `managed`: the service hosts the model. Usage is billed as part of the voice agent.
- `self_deployed`: the agent uses your own Foundry model deployment. Model usage is billed against that deployment, under the terms of the deployment type you chose, such as standard or provisioned throughput.

Self-deployed models let you apply existing capacity commitments to voice traffic. Managed models avoid deployment management. Neither choice changes the agent's behavior; it changes which resource carries the charge.

## Reduce cost

Most cost reduction for voice agents comes from making the agent talk less and think less:

- **Cap response length.** Set `max_output_tokens` on the agent definition. Long spoken answers cost more and are also worse voice design.
- **Write short instructions.** Instructions are resent as context on every turn, so instruction length multiplies across the conversation.
- **Prefer static interim responses.** A `static_interim_response` fills latency gaps without a model call. An `llm_interim_response` adds a model call on every trigger.
- **End calls deliberately.** Attach the `end_conversation` system tool so completed calls release the session instead of running until timeout.
- **Turn off storage when you don't need it.** `store` defaults to `false`. Enable it for the conversations you actually intend to review.
- **Scope tools.** Every attached tool adds tokens to each turn's context, whether or not the model calls it.

For general cost management guidance, see [Plan and manage costs for Microsoft Foundry](../../06-models/06.3-offers-deployment-types-and-pricing/16-manage-costs.md).

## See usage before the invoice

Voice agent traces carry per-turn token usage and estimated-cost attributes, so you can attribute spend to specific conversations while you're still developing.

Estimated cost appears on both the turn span and the session root span, split into a managed component and a self-deployed component under `microsoft.foundry.voice.estimated_cost.*`, with avatar cost reported separately on the root span.

> **Important**
>
> These attributes are estimates for analysis and tuning. They aren't commerce or invoice records. Use Microsoft Cost Management for billing.

For token usage on stored conversations, read the conversation's `usage` field after the session completes. See [Voice agent tracing, monitoring, and evaluation](21-voice-agent-observability.md).

## Related content

- [Configure a voice agent](15-configure-voice-agent.md)
- [Voice agent tracing, monitoring, and evaluation](21-voice-agent-observability.md)
- [Plan and manage costs for Microsoft Foundry](../../06-models/06.3-offers-deployment-types-and-pricing/16-manage-costs.md)
- [Quickstart: Create a voice-based prompt agent](../../04-get-started/04.1-what-do-you-want-to-build/02-prompt-voice-agent.md)
