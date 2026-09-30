# Manage Grounding with Bing in Microsoft Foundry and Azure

| Field | Value |
| --- | --- |
| **Document Title** | Manage Grounding with Bing in Microsoft Foundry and Azure |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.1-set-up-and-configure/18-manage-grounding-with-bing.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Manage Grounding with Bing in Microsoft Foundry and Azure". Learn how to manage Grounding with Bing in Microsoft Foundry and Azure. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/manage-grounding-with-bing). Article date: 2026-05-13. Page updated: 2026-05-18. Retrieved: 2026-09-29. Navigation: Manage and operate > Set up and configure > Connect services and tools > Manage Grounding with Bing.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Grounding with Bing enables agents to retrieve and incorporate real-time public web data into model-generated responses. It supports summarization, question answering, conversational assistance, and other scenarios by using Grounding with Bing Search or Grounding with Bing Custom Search to fill knowledge gaps.

Grounding is available across features in Foundry Agent Service and Azure AI Search. To meet compliance, privacy, or data governance requirements, you might need to disable access to these features.

As an admin, you can manage access to Grounding with Bing in the following ways:

- [Disable Grounding with Bing Search tools](#disable-grounding-with-bing-search-tools) in Foundry Agent Service.
- [Disable web search tool](#disable-web-search-tool) in Foundry Agent Service.
- [Disable web knowledge](#disable-web-knowledge) in Azure AI Search.

## Disable Grounding with Bing Search tools

You can disable Grounding with Bing Search, Grounding with Bing Custom Search, or both at the subscription or resource group level. For more information, see [Disable use of Grounding with Bing Search and Grounding with Bing Custom Search](../../08-toolboxes/08.1-add-tools-and-skills/13-bing-tools.md#disable-use-of-grounding-with-bing-search-and-grounding-with-bing-custom-search).

## Disable web search tool

You can disable the web search tool for all accounts in a subscription. For more information, see [Disable Web Search](../../08-toolboxes/08.1-add-tools-and-skills/12-web-search.md#disable-web-search).

## Disable web knowledge

You can disable Web Knowledge Source access for all search services in a subscription. For more information, see [Disable use of Web Knowledge Source](https://learn.microsoft.com/en-us/azure/search/agentic-knowledge-source-how-to-web-manage#disable-use-of-web-knowledge-source).

> **Tip**
>
> To reenable access after disabling it, follow the steps in the linked articles to reverse the policy, setting, or feature registration.

## Related content

- [Grounding with Bing Search tools for agents](../../08-toolboxes/08.1-add-tools-and-skills/13-bing-tools.md)
- [Web search tool](../../08-toolboxes/08.1-add-tools-and-skills/12-web-search.md)
- [Create a Web Knowledge Source resource](https://learn.microsoft.com/en-us/azure/search/agentic-knowledge-source-how-to-web)
