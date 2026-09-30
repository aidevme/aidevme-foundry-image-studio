# Microsoft Foundry feature availability across cloud regions

| Field | Value |
| --- | --- |
| **Document Title** | Microsoft Foundry feature availability across cloud regions |
| **Document Location** | `docs/research-docs/azure-foundry/06-models/06.2-quota-limits-and-region-availability/08-region-support.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Microsoft Foundry feature availability across cloud regions". Find Microsoft Foundry feature availability across cloud regions, including where you can create projects and where key features are supported. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/reference/region-support). Article date: 2026-08-21. Page updated: 2026-08-25. Retrieved: 2026-09-29. Navigation: Models > Quota limits and region availability > Feature availability by region.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

[Microsoft Foundry](https://ai.azure.com/?cid=learnDocs) brings together various Azure AI capabilities that were previously only available as standalone Azure services. While Microsoft strives to make all features available in all regions where Microsoft Foundry is supported at the same time, feature availability might vary by region. In this article, you learn what Foundry features are available across cloud regions.

This article gives you:

- Regions where you can create a Foundry project.
- Links to the authoritative regional availability pages for major features.

This article doesn't include a single real-time matrix for every model and feature combination. Use the linked service-specific pages to confirm current availability before deployment.

## Foundry projects

Foundry is currently available in the following Azure regions.

- Australia East
- Brazil South
- Canada Central
- Canada East
- Central India
- Central US
- East Asia
- East US
- East US 2
- France Central
- Germany West Central
- Italy North

- Japan East
- Korea Central
- North Central US
- North Europe
- Norway East
- Qatar Central
- South Africa North
- South Central US
- South India
- Southeast Asia

- Spain Central
- Sweden Central
- Switzerland North
- UAE North
- UK South
- West Europe
- West US
- West US 3
- US Gov Virginia
- US Gov Arizona

## Foundry features

Use the following list to investigate regional availability for specific features you plan to use.

- **Foundry Models**: Model availability depends on the provider and deployment type. Region support differs between Azure OpenAI models, Foundry Models sold by Azure, and Models from partners and community. Check the following pages for details:
  - [Foundry Models sold by Azure](../06.1-explore-foundry-models/01-models-sold-directly-by-azure.md) — Azure OpenAI models and selected models from other providers, with deployment types and regional availability.
  - [Deployment types](../06.3-offers-deployment-types-and-pricing/04-deployment-types.md) — compare Global Standard, Provisioned, DataZone, and other deployment types that affect where data is processed.
  - [Foundry Models from partners and community](../06.1-explore-foundry-models/03-models-from-partners.md) — models from third-party providers available through the model catalog.
  - [Azure OpenAI quotas and limits](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/quotas-limits#regional-quota-capacity-limits) — regional quota and capacity limits for Azure OpenAI models.
- **Speech capabilities**: Azure Speech in Foundry Tools capabilities, including custom neural voice, vary in regional availability due to underlying hardware availability. [Speech service supported regions](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/regions)
- **Azure AI Content Safety**: To use the Content Safety APIs, create your Azure AI Content Safety resource in a supported region. [What is Azure AI Content Safety?](https://learn.microsoft.com/en-us/azure/ai-services/content-safety/overview#region-availability)
- **Foundry Agent Service**: Agent Service supports Azure OpenAI model deployments, but exact model and tool availability varies by region. [Agent Service region availability](../../07-agents/07.6-reference/01-limits-quotas-regions.md#supported-regions)

## How to verify region support for your workload

Use this process before you create resources:

1. Select a candidate project region from the **Foundry projects** list in this article.
2. Verify feature-specific support in the **Foundry features** list links.
3. Check available quota for a specific model and region. In the Foundry portal, go to **Manage** > **Quota** and turn on the **Show all** toggle to see all models and regions, including models you didn't deploy yet. For more information, see [Quota in Foundry Control Plane](../../13-manage-and-operate/13.2-govern-at-scale/01-overview.md#quota).
4. Confirm the final service list in [Azure global infrastructure products by region](https://azure.microsoft.com/global-infrastructure/services/).

## Foundry in sovereign clouds

### Azure Government (United States)

Available only to US government entities and their partners. For more information, see [Azure Government documentation](https://learn.microsoft.com/en-us/azure/azure-government/documentation-government-welcome) and [Compare Azure Government and global Azure](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure).

- **Foundry portal URL:**
  - [https://ai.azure.us/](https://ai.azure.us/)
- **Regions:**
  - US Gov Arizona
  - US Gov Virginia
- **Available pricing tiers:**
  - Standard. For more information, see [Foundry pricing](https://azure.microsoft.com/pricing/details/ai-foundry/).
- **Supported features:**
  - [Azure OpenAI in Foundry Models](../06.1-explore-foundry-models/02-models-sold-directly-by-azure-gov.md)
  - Foundry Tools
    - [Speech](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/regions)
    - Speech playground (preview)
    - Language playground (preview)
    - Language + [Translator](https://learn.microsoft.com/en-us/azure/ai-services/translator/reference/sovereign-clouds)
    - Vision + Document
    - Content Safety
  - Model catalog. For the list of supported models, see [Machine learning cloud parity](https://learn.microsoft.com/en-us/azure/machine-learning/reference-machine-learning-cloud-parity).
  - Templates (preview)
  - Prompt flow
  - Tracing (preview)
  - Guardrails & controls
    - Content filters
    - Profanity block list (preview)
  - Management center
- **Unsupported features in Azure Government regions:**
  - Serverless endpoints
  - Content Understanding
  - Agents playground
  - Images playground
  - Real-time audio playground
  - Healthcare playground
  - Fine-tuning
  - Azure AI Agents
  - Batch jobs
  - Azure OpenAI Evaluation
  - Deploy Web App
  - VS Code Extension

## Quick decision checklist

Before you choose a production region, confirm all answers are **Yes**:

- Is your required model available in the target region?
- Do you have enough quota in that region for your expected traffic?
- Are all dependent services (for example, Speech, Content Safety, Agent Service tools) available in that region?
- Do your compliance requirements require a sovereign cloud region?
- Have you validated availability in both docs and your portal experience for the same subscription and tenant?

When you validate availability, keep these constraints in mind:

- Azure OpenAI quotas are allocated per region, per subscription, and per model or deployment type.
- Azure Speech keys are region-specific and only work for the region where the Speech resource is created.
- The region list in this article is a documentation snapshot. Always verify against the linked service-specific and infrastructure pages before production rollout.

## Troubleshoot region mismatch issues

If a feature isn't available in your selected region:

- Use the feature-specific regional availability article linked in **Foundry features**.
- Create the required dependent resource in a supported region.
- Re-check model availability and quota limits for that region.
- For Speech workloads, confirm that your app configuration uses the same region as your Speech resource.
- If your organization requires a sovereign cloud, see [Foundry in sovereign clouds](#foundry-in-sovereign-clouds).

## Next step

- [Azure global infrastructure products by region](https://azure.microsoft.com/global-infrastructure/services/)
