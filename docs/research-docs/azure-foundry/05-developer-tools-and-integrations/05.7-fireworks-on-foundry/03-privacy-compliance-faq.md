# Fireworks on Microsoft Foundry privacy and compliance FAQ

| Field | Value |
| --- | --- |
| **Document Title** | Fireworks on Microsoft Foundry privacy and compliance FAQ |
| **Document Location** | `docs/research-docs/azure-foundry/05-developer-tools-and-integrations/05.7-fireworks-on-foundry/03-privacy-compliance-faq.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Fireworks on Microsoft Foundry privacy and compliance FAQ". Answers to questions about the terms, privacy, data residency, and compliance of Fireworks on Microsoft Foundry. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/fireworks/privacy-compliance-faq). Article date: 2026-09-24. Page updated: 2026-09-29. Retrieved: 2026-09-29. Navigation: Developer tools and integrations > Fireworks on Foundry > Privacy and compliance FAQ.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

## What is the Fireworks on Foundry service?

*Fireworks on Foundry* is a first-party consumption service. It’s a Microsoft online service that's available as an Azure meter. Fireworks AI provides a high-performance inferencing engine for running optimized open-source and custom AI models. The *Fireworks on Foundry* service is a Microsoft service that enables customers to perform inference and model optimization in Microsoft Foundry using Fireworks AI's ("**Fireworks**") proprietary inference engine and GPU infrastructure.

The open-source models available via the service are ***not*** designated as “Foundry Models sold by Azure.” Foundry Models Sold by Azure are AI models designated [here](../../06-models/06.1-explore-foundry-models/01-models-sold-directly-by-azure.md).

## What terms and conditions govern the use of the Fireworks on Foundry service?

Microsoft’s Product Terms and Data Protection Addendum (“**DPA**”) govern the use of the service, with the ***limited exception*** that this service does not comply with SOC 1 Type 2 and has not obtained PCI, HITRUST, or FedRAMP certifications. While the *Fireworks on Foundry* service is a Microsoft service, the underlying models that are made available via the service are Non-Microsoft Products (as defined in the Product Terms) and non-Fireworks products i.e., they are third-party branded software or product. The underlying models are made available under separate model licensing terms (e.g., MIT license) that are identified under the “License” tab on the Microsoft Foundry portal when accessing the *Fireworks on Foundry* service.

For clarity, the model providers ***do not*** get access to Customer Data via the Fireworks on Foundry service and are not involved in any data handling or processing undertaken by the service. Microsoft and Fireworks do not make representations regarding model quality, safety, or performance. Customers are responsible for evaluating model suitability.

Customers can access Fireworks’ compliance certifications and audit reports at [https://trust.fireworks.ai/](https://trust.fireworks.ai/).

## Do customers require a separate BAA with Fireworks when accessing the Fireworks on Foundry service?

No, customers don't require a separate BAA with Fireworks when using the Fireworks on Foundry service. Since Fireworks acts as a Microsoft subprocessor for this service, Microsoft's privacy and data protection commitments flow down to Fireworks through Microsoft's subprocessor arrangements. Accordingly, customers aren't required to enter into a separate BAA with Fireworks to use the service. For more information, review the applicable Product Terms, DPA, and any service-specific documentation.

## Does customer data travel outside of Azure when using the Fireworks on Foundry service? Why? What data processing terms apply?

Yes, customer data travels outside Microsoft facilities because Fireworks runs inferencing for this service on Fireworks’ GPUs. However, since Fireworks is a Microsoft subprocessor, any processing of customer data continues to be governed by Microsoft’s Product Terms and DPA, and any documented exceptions.

## Where is the customer data stored? Do Foundry’s DataZone commitments apply?

When using the Fireworks on Foundry service the customer data is stored at rest in the region chosen by the customer when deploying a model via the service. Currently, the Fireworks on Foundry service is available in the US and all Foundry DataZone deployments are pinned to the US regions.

## Do customers need to opt in when using the Fireworks on Foundry service?

Yes, customers can choose to opt in on the Microsoft Foundry portal to use the Fireworks on Foundry service. To learn more, see [enable Fireworks on Foundry for your subscription](01-enable-fireworks-models.md#enable-fireworks-on-foundry).

## Does Fireworks apply a Responsible AI evaluation process and/or a digital safety standard to the models it makes available under the Fireworks on Foundry service?

Fireworks holds ISO 42001 certification for its AI management system. ISO 42001 is a management-system standard covering governance process for how Fireworks develops and operates AI systems. It is not an evaluation of the behaviour of the models served. The certificate and its scope statement are available in the Fireworks Trust Center.
