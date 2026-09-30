# Claude model quotas and rate limits

| Field | Value |
| --- | --- |
| **Document Title** | Claude model quotas and rate limits |
| **Document Location** | `docs/research-docs/azure-foundry/06-models/06.5-model-support/04-claude-models-quotas-limits.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Claude model quotas and rate limits". Learn how Claude model quotas and rate limits work in Microsoft Foundry, including RPM, ITPM, OTPM, prompt caching, and default subscription limits. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/concepts/claude-models-quotas-limits). Article date: 2026-09-21. Page updated: 2026-09-22. Retrieved: 2026-09-29. Navigation: Models > Model support > Anthropic > Quotas and rate limits.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Claude model quotas and rate limits in Microsoft Foundry determine how much traffic each model can process. This reference explains how deployments share quota, how prompt caching affects token accounting, and which default limits apply to each Azure subscription type.

## Claude quota scope

Microsoft Foundry manages Claude model quota at the subscription level. Resources and regions share quota instead of receiving separate allocations.

- All Global Standard deployments of the same model and version in a subscription draw from one shared quota pool across all regions.
- All Data Zone Standard deployments of the same model and version in a subscription draw from a shared quota pool within each data zone, such as the US data zone.

For general quota management guidance, see [Microsoft Foundry Models quotas and limits](../06.2-quota-limits-and-region-availability/05-quotas-limits.md).

## Rate-limit measurements

Claude models use the following rate-limit measurements for each model:

- **Requests per minute (RPM)** measures the number of requests.
- **Uncached input tokens per minute (ITPM)** measures input tokens that aren't read from a prompt cache.
- **Output tokens per minute (OTPM)** measures tokens that the model generates.

### Cache-aware ITPM

For most Claude models, only uncached input tokens count toward ITPM limits. These tokens include:

- **Input tokens**: Tokens in the request after the last cache breakpoint (uncached input).
- **Cache creation input tokens**: Tokens written to either the 5-minute or 1-hour prompt cache.

> **Tip**
>
> The *total input tokens* is the sum of **Input tokens**, **Cache creation input tokens**, and **Cache read input tokens** (the tokens read from cache). However, the *Cache read input tokens* don't count towards ITPM. **OTPM** also doesn't count towards ITPM.

For more information about rate limits and prompt caching, see [Rate limits in the Claude API documentation](https://platform.claude.com/docs/en/api/rate-limits#rate-limits).

## Default rate limits by subscription type

Your Azure subscription type determines your default rate limits. The **Version 2: Hosted on Azure** and **Version 1: Hosted on Anthropic infrastructure** columns indicate whether each model and deployment type combination supports quota allocation. **Yes** means the combination supports quota allocation, but its default numeric limit might be zero. **N/A** means the combination doesn't support quota allocation for that deployment type. The RPM, ITPM, and OTPM columns show the default capacity.

**[Pay-as-you-go]**

#### Pay-as-you-go

| Model | Deployment type | Version 2: Hosted on Azure | Version 1: Hosted on Anthropic infrastructure | RPM | ITPM | OTPM |
| --- | --- | --- | --- | --- | --- | --- |
| claude-fable-5-1 | Global Standard | N/A | Yes | 0 | 0 | 0 |
| claude-fable-5 | Global Standard | N/A | Yes | 0 | 0 | 0 |
| claude-opus-5-5 | Global Standard | Yes | Yes | 40 | 40,000 | 8,000 |
| claude-opus-5-5 | Data Zone Standard (US) | Yes | N/A | 40 | 40,000 | 8,000 |
| claude-opus-5 | Global Standard | Yes | Yes | 40 | 40,000 | 8,000 |
| claude-opus-5 | Data Zone Standard (US) | Yes | N/A | 40 | 40,000 | 8,000 |
| claude-opus-4-8 | Global Standard | Yes | Yes | 40 | 40,000 | 8,000 |
| claude-opus-4-8 | Data Zone Standard (US) | Yes | N/A | 40 | 40,000 | 8,000 |
| claude-opus-4-7 | Global Standard | N/A | Yes | 40 | 40,000 | 8,000 |
| claude-opus-4-6 | Global Standard | N/A | Yes | 40 | 40,000 | 8,000 |
| claude-opus-4-5 | Global Standard | N/A | Yes | 40 | 40,000 | 8,000 |
| claude-sonnet-5-5 | Global Standard | Yes | Yes | 40 | 40,000 | 8,000 |
| claude-sonnet-5-5 | Data Zone Standard (US) | Yes | N/A | 40 | 40,000 | 8,000 |
| claude-sonnet-5 | Global Standard | Yes | Yes | 40 | 40,000 | 8,000 |
| claude-sonnet-5 | Data Zone Standard (US) | Yes | N/A | 40 | 40,000 | 8,000 |
| claude-sonnet-4-6 | Global Standard | N/A | Yes | 80 | 80,000 | 16,000 |
| claude-sonnet-4-5 | Global Standard | N/A | Yes | 80 | 80,000 | 16,000 |
| claude-haiku-4-5 | Global Standard | Yes | Yes | 80 | 80,000 | 16,000 |

**[Enterprise and MCA-E]**

#### Enterprise and MCA-E

| Model | Deployment type | Version 2: Hosted on Azure | Version 1: Hosted on Anthropic infrastructure | RPM | ITPM | OTPM |
| --- | --- | --- | --- | --- | --- | --- |
| claude-fable-5-1 | Global Standard | N/A | Yes | 4,000 | 4,000,000 | 800,000 |
| claude-fable-5 | Global Standard | N/A | Yes | 4,000 | 4,000,000 | 800,000 |
| claude-opus-5-5 | Global Standard | Yes | Yes | 10,000 | 10,000,000 | 2,000,000 |
| claude-opus-5-5 | Data Zone Standard (US) | Yes | N/A | 10,000 | 10,000,000 | 2,000,000 |
| claude-opus-5 | Global Standard | Yes | Yes | 10,000 | 10,000,000 | 2,000,000 |
| claude-opus-5 | Data Zone Standard (US) | Yes | N/A | 10,000 | 10,000,000 | 2,000,000 |
| claude-opus-4-8 | Global Standard | Yes | Yes | 10,000 | 10,000,000 | 2,000,000 |
| claude-opus-4-8 | Data Zone Standard (US) | Yes | N/A | 10,000 | 10,000,000 | 2,000,000 |
| claude-opus-4-7 | Global Standard | N/A | Yes | 10,000 | 10,000,000 | 2,000,000 |
| claude-opus-4-6 | Global Standard | N/A | Yes | 10,000 | 10,000,000 | 2,000,000 |
| claude-opus-4-5 | Global Standard | N/A | Yes | 10,000 | 10,000,000 | 2,000,000 |
| claude-sonnet-5-5 | Global Standard | Yes | Yes | 10,000 | 10,000,000 | 2,000,000 |
| claude-sonnet-5-5 | Data Zone Standard (US) | Yes | N/A | 10,000 | 10,000,000 | 2,000,000 |
| claude-sonnet-5 | Global Standard | Yes | Yes | 10,000 | 10,000,000 | 2,000,000 |
| claude-sonnet-5 | Data Zone Standard (US) | Yes | N/A | 10,000 | 10,000,000 | 2,000,000 |
| claude-sonnet-4-6 | Global Standard | N/A | Yes | 10,000 | 10,000,000 | 2,000,000 |
| claude-sonnet-4-5 | Global Standard | N/A | Yes | 10,000 | 10,000,000 | 2,000,000 |
| claude-haiku-4-5 | Global Standard | Yes | Yes | 10,000 | 10,000,000 | 2,000,000 |

**[Free Trial]**

#### Free Trial

| Model | Deployment type | Version 2: Hosted on Azure | Version 1: Hosted on Anthropic infrastructure | RPM | ITPM | OTPM |
| --- | --- | --- | --- | --- | --- | --- |
| claude-fable-5-1 | Global Standard | N/A | Yes | 0 | 0 | 0 |
| claude-fable-5 | Global Standard | N/A | Yes | 0 | 0 | 0 |
| claude-opus-5-5 | Global Standard | Yes | Yes | 0 | 0 | 0 |
| claude-opus-5-5 | Data Zone Standard (US) | Yes | N/A | 0 | 0 | 0 |
| claude-opus-5 | Global Standard | Yes | Yes | 0 | 0 | 0 |
| claude-opus-5 | Data Zone Standard (US) | Yes | N/A | 0 | 0 | 0 |
| claude-opus-4-8 | Global Standard | Yes | Yes | 0 | 0 | 0 |
| claude-opus-4-8 | Data Zone Standard (US) | Yes | N/A | 0 | 0 | 0 |
| claude-opus-4-7 | Global Standard | N/A | Yes | 0 | 0 | 0 |
| claude-opus-4-6 | Global Standard | N/A | Yes | 0 | 0 | 0 |
| claude-opus-4-5 | Global Standard | N/A | Yes | 0 | 0 | 0 |
| claude-sonnet-5-5 | Global Standard | Yes | Yes | 0 | 0 | 0 |
| claude-sonnet-5-5 | Data Zone Standard (US) | Yes | N/A | 0 | 0 | 0 |
| claude-sonnet-5 | Global Standard | Yes | Yes | 0 | 0 | 0 |
| claude-sonnet-5 | Data Zone Standard (US) | Yes | N/A | 0 | 0 | 0 |
| claude-sonnet-4-6 | Global Standard | N/A | Yes | 0 | 0 | 0 |
| claude-sonnet-4-5 | Global Standard | N/A | Yes | 0 | 0 | 0 |
| claude-haiku-4-5 | Global Standard | Yes | Yes | 0 | 0 | 0 |

## Quota checks and requests for increase

The **Quota** page in the Foundry portal shows the quota available to your subscription.

To request quota beyond the default limits, submit the [quota increase request form](https://aka.ms/oai/stuquotarequest). Quota increase requests are evaluated individually and aren't guaranteed to be approved.

## Rate-limit error handling

When an application exceeds a rate limit, the API returns an HTTP 429 response. Implement exponential backoff, reduce request frequency or token usage, and request more quota when the default limits don't meet your workload requirements.

For other errors you might encounter when you deploy or call Claude models, see [Troubleshoot Claude model deployments](06-use-foundry-models-claude.md#troubleshooting).

## Related content

- [Overview: Claude models in Microsoft Foundry](03-claude-models.md)
- [Deploy and use Claude models in Microsoft Foundry](06-use-foundry-models-claude.md)
- [Claude Consumption Units billing in Microsoft Foundry](../../13-manage-and-operate/13.1-set-up-and-configure/20-claude-models-billing.md)
- [Microsoft Foundry Models quotas and limits](../06.2-quota-limits-and-region-availability/05-quotas-limits.md)
