# Data, privacy, and security for Claude models in Microsoft Foundry

| Field | Value |
| --- | --- |
| **Document Title** | Data, privacy, and security for Claude models in Microsoft Foundry |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.3-security-and-governance/23-data-privacy.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Data, privacy, and security for Claude models in Microsoft Foundry". This document details issues for data, privacy, and security for Anthropic Claude models in Microsoft Foundry. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/responsible-ai/claude-models/data-privacy). Article date: 2026-06-23. Page updated: 2026-06-29. Retrieved: 2026-09-29. Navigation: Manage and operate > Security and governance > Data, privacy, and security for Claude models in Microsoft Foundry.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

This article explains how data is processed when you use Claude models in Microsoft Foundry. Claude models in Microsoft Foundry are third-party Marketplace offerings from Anthropic. Data handling depends on the hosting option you select when deploying the Claude model.

Microsoft Foundry offers two hosting options for deploying your Claude models:

- **Hosted on Azure**
- **Hosted on Anthropic infrastructure**

For both hosting options, Anthropic is the seller and operator of Claude models in Microsoft Foundry and acts as an independent data processor for prompts and outputs associated with Claude models. Your use of the Claude models is subject to the terms of use Anthropic provides for Claude models and APIs.

## Hosted on Azure

If you choose the **Hosted on Azure** deployment option, your prompts and outputs are processed on Azure infrastructure, including request ingress, API services, and GPU inference. Data at rest is stored in the selected Azure geography and processing is scoped to applicable “Global” or “DataZone” deployment options available on Microsoft Foundry.

Automatic safeguards flag content that might be sent to Anthropic Trust & Safety for review. Anthropic personnel review customer content on an exceptions-only basis to investigate potential safety violations, subject to applicable Anthropic terms.

## Hosted on Anthropic Infrastructure

If you choose the **Hosted on Anthropic Infrastructure** deployment option, your prompts and outputs are processed on Anthropic hosted infrastructure. Data might be processed outside of Azure including outside of your selected Azure region. To learn more about the terms that govern data processing in Anthropic-hosted infrastructure, see [Anthropic's Data processing Addendum](https://www.anthropic.com/legal/data-processing-addendum) and [Anthropic's Commercial Terms of Service](https://aka.ms/anthropic_tandc).

Microsoft continues to provide Microsoft Foundry experience, Azure infrastructure, and billing services for this deployment option. Microsoft also collects billing, usage, customer contact, and transaction information for Marketplace operations. Microsoft might share such customer contact information, transaction details, and usage information with Anthropic so that Anthropic can operate, support, and communicate with customers about the model. Microsoft processes data for these services under the Microsoft Products and Services Data Protection Addendum and applicable Marketplace terms.

## Where can I learn about harmful content screening?

Claude models in Microsoft Foundry use Anthropic safety systems and safeguards, supported by Microsoft. To learn more about harmful content screening, safety review, and Anthropic-specific processing, see Anthropic’s documentation and the Anthropic terms presented during deployment.

## Related content

- [Claude Consumption Units (CCU) billing in Microsoft Foundry](../13.1-set-up-and-configure/20-claude-models-billing.md)
- [Claude models in Microsoft Foundry](../../06-models/06.5-model-support/03-claude-models.md)
- [Microsoft Products and Services Data Protection Addendum (DPA)](https://www.microsoft.com/licensing/docs/view/Microsoft-Products-and-Services-Data-Protection-Addendum-DPA)
- [Anthropic's Data processing Addendum](https://www.anthropic.com/legal/data-processing-addendum)
- [Anthropic's Commercial Terms of Service](https://aka.ms/anthropic_tandc)
