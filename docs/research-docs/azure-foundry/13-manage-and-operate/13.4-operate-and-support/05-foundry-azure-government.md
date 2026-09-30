# Microsoft Foundry in Azure Government

| Field | Value |
| --- | --- |
| **Document Title** | Microsoft Foundry in Azure Government |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.4-operate-and-support/05-foundry-azure-government.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Microsoft Foundry in Azure Government". Feature availability, regions, and endpoints for the Microsoft Foundry portal and platform in Azure Government (USGov Virginia and USGov Arizona). |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/concepts/foundry-azure-government). Article date: 2026-09-02. Page updated: 2026-09-04. Retrieved: 2026-09-29. Navigation: Manage and operate > Operate and support > Microsoft Foundry in Azure Government.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Microsoft Foundry is available in Azure Government for US federal, state, and local governments and their partners. Use this article to find the supported regions, endpoints, and platform features in Azure Government. For agent-specific feature availability, see [Foundry Agent Service feature availability in Azure Government](../../07-agents/07.6-reference/02-azure-government.md).

## Supported regions

Microsoft Foundry is deployed in the following Azure Government regions:

| Region | Region identifier |
| --- | --- |
| US Gov Virginia | `usgovvirginia` |
| US Gov Arizona | `usgovarizona` |

Capabilities can differ by region. See the feature tables in this article and in [Foundry Agent Service feature availability in Azure Government](../../07-agents/07.6-reference/02-azure-government.md) for specifics.

## Endpoints

Use the following endpoints to access the Foundry portal, your project, and the Azure portal in Azure Government.

### Foundry portal

```text
https://ai.azure.us/nextgen
```

### Foundry project endpoint

Replace `{resource-name}` and `{project-name}` with your values:

```text
https://{resource-name}.services.ai.azure.us/api/projects/{project-name}
```

### Azure portal

```text
https://portal.azure.us
```

## Models

For the list of Foundry Models sold directly by Azure that are available in Azure Government, see [Foundry Models sold by Azure in Azure Government](../../06-models/06.1-explore-foundry-models/02-models-sold-directly-by-azure-gov.md).

## Azure OpenAI features

| Feature | Available |
| --- | --- |
| Responses API | Yes |
| Model router | No |

## Enterprise and security features

| Feature | Available |
| --- | --- |
| Agent identity (Microsoft Entra) | Yes |
| Private networking (VNet integration) | Yes |
| Role-based access control (RBAC) | Yes |
| Network Security Perimeter (NSP) | Yes |
| Content safety and guardrails | Yes |

For more information on adding Foundry to a Network Security Perimeter, see [Add Microsoft Foundry to a network security perimeter](../13.3-security-and-governance/10-add-foundry-to-network-security-perimeter.md).

## Guardrails

| Guardrail | Available |
| --- | --- |
| Block lists | Yes |
| Jailbreak detection | Yes |
| Content Safety | Yes |
| Protected materials detection | Yes |

## Observability

| Capability | Available |
| --- | --- |
| Tracing (prompt agents) | Yes |
| Evaluations | No |
| Optimization | No |

## Foundry Agent Service

Foundry Agent Service is available in Azure Government with a subset of agent types and tools. For the full list of supported agent types, tools, and publishing options, see [Foundry Agent Service feature availability in Azure Government](../../07-agents/07.6-reference/02-azure-government.md).

## Quotas and limits

For quotas and limits that apply to Azure OpenAI models in Azure Government, see [Azure OpenAI quotas and limits in Azure Government](../../06-models/06.2-quota-limits-and-region-availability/07-quotas-limits-gov.md).

## Provisioned throughput

For fungible provisioned throughput unit (PTU) quota, model eligibility, and Azure Reservation requirements, see [Provisioned throughput in Azure Government](../../06-models/06.3-offers-deployment-types-and-pricing/10-provisioned-throughput-gov.md).

## Related content

For more information on Microsoft Foundry in Azure Government, see:

- [Foundry Agent Service feature availability in Azure Government](../../07-agents/07.6-reference/02-azure-government.md) — Agent types, tools, and publishing options
- [Foundry Models sold by Azure in Azure Government](../../06-models/06.1-explore-foundry-models/02-models-sold-directly-by-azure-gov.md) — Available models in Azure Government
- [Azure OpenAI quotas and limits in Azure Government](../../06-models/06.2-quota-limits-and-region-availability/07-quotas-limits-gov.md) — Service quotas
- [Provisioned throughput in Azure Government](../../06-models/06.3-offers-deployment-types-and-pricing/10-provisioned-throughput-gov.md) — PTU quota and payment options
- [Add Microsoft Foundry to a network security perimeter](../13.3-security-and-governance/10-add-foundry-to-network-security-perimeter.md) — NSP integration
- [Azure Government documentation](https://learn.microsoft.com/en-us/azure/azure-government/documentation-government-welcome) — Compliance certifications and onboarding
