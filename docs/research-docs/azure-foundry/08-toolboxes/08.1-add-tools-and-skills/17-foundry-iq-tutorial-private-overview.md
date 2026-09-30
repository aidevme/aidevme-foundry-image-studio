# Tutorial: Deploy private agentic retrieval for Foundry IQ

| Field | Value |
| --- | --- |
| **Document Title** | Tutorial: Deploy private agentic retrieval for Foundry IQ |
| **Document Location** | `docs/research-docs/azure-foundry/08-toolboxes/08.1-add-tools-and-skills/17-foundry-iq-tutorial-private-overview.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Tutorial: Deploy private agentic retrieval for Foundry IQ". Review the tutorial scope and end-to-end architecture for private agentic retrieval. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/foundry-iq-tutorial-private-overview). Article date: 2026-07-13. Page updated: 2026-09-17. Retrieved: 2026-09-29. Navigation: Toolboxes > Add tools and skills > Microsoft IQ > Foundry IQ > Tutorial: Deploy private agentic retrieval > Overview.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

> **Important**
>
> Features, capabilities, or properties marked (preview) aren't covered by a service-level agreement, aren't recommended for production workloads, and might change or be constrained before they become generally available. The [Azure AI Search preview terms](https://learn.microsoft.com/en-us/azure/search/search-preview-terms) apply to all preview functionality, whether it's standalone or part of a generally available feature.

This three-part tutorial series describes how to deploy an end-to-end private agentic retrieval architecture for Foundry IQ by using Microsoft Foundry and Azure AI Search. It explains how inbound connectivity, outbound dependencies, and retrieval runtime fit together across the deployment.

In this tutorial, you:

- Establish inbound private connectivity between Foundry and Azure AI Search.
- Configure outbound private dependencies from Azure AI Search.
- Validate end-to-end retrieval with a knowledge source, knowledge base, project connection, and agent.

## What is private agentic retrieval?

Private agentic retrieval is a pattern where an agent retrieves knowledge over private network paths instead of public endpoints. In this tutorial, the agent-to-Search path and the Search-to-Storage path stay on private endpoints, shared private links, and private DNS zones. The Search-to-Foundry embedding dependency is also configured for private outbound access, but the ingestion-time embedding call currently still relies on the Foundry trusted-service bypass.

> **Tip**
>
> This tutorial is the private network version of [Tutorial: Build an end-to-end agentic retrieval solution using Azure AI Search](https://learn.microsoft.com/en-us/azure/search/agentic-retrieval-how-to-create-pipeline). Both tutorials use managed identities and role-based access, but this version emphasizes private connectivity and adds inbound and outbound validation at each step.

## Services in this tutorial

The deployment provisions the following services. You interact with each service differently throughout this tutorial.

| Service | Role |
| --- | --- |
| Foundry (resource and project) | Orchestrates the agent runtime and hosts the project connection, the agent, and a GPT-5 family model that powers the agent. In part three, you also deploy the `text-embedding-3-large` embedding model that Azure AI Search uses to vectorize content. |
| Azure AI Search | Ingests and vectorizes your private blob content into a knowledge source, and then serves agentic retrieval through a knowledge base and its MCP endpoint. Makes a private outbound call to Azure Blob Storage for content access. For the Foundry embedding dependency, this tutorial uses the `openai_account` shared private link for the target resource, and the ingestion-time embedding call currently also relies on the trusted-service bypass. |
| Azure Blob Storage | Stores the source documents that the knowledge source ingests and indexes for agentic retrieval. |
| Azure Cosmos DB | Stores agent state for the standard agent setup, including messages, conversation history, and agent metadata. The deployment provisions it automatically, and you don't configure or use it directly. |

## Parts in this tutorial

The following table shows what you accomplish in each part, the components involved, and how to confirm success before moving to the next part.

| Part | Outcome | Components | Success criteria |
| --- | --- | --- | --- |
| 1 - Inbound | A private request path from Foundry to Azure AI Search. | Virtual network and subnets Private endpoints Private DNS zones Foundry and Azure AI Search private access settings | From your in-VNet client, the Foundry and Azure AI Search endpoints resolve to private IP addresses and accept connections on TCP 443. |
| 2 - Outbound | Private dependency paths from Azure AI Search to Azure Blob Storage and Foundry. | Shared private links Target-side approvals Managed identities Dependency RBAC for Azure Blob Storage and Foundry | The Azure Blob Storage and Foundry shared private links report an `Approved` state, and the Azure AI Search managed identity holds its assigned blob and model roles. |
| 3 - Retrieval validation | An agent that returns grounded answers over the private retrieval path. | Knowledge source Knowledge base Project connection Agent configuration | The validation prompt returns an answer grounded in your blob content, with citations to the source documents. |

## Next step

[Set up private inbound connectivity](18-foundry-iq-tutorial-private-inbound.md)
