# Disable creation of classic agents and assistants

| Field | Value |
| --- | --- |
| **Document Title** | Disable creation of classic agents and assistants |
| **Document Location** | `docs/research-docs/azure-foundry/07-agents/07.2-prompt-agents/14-disable-classic-agents.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Disable creation of classic agents and assistants". Learn how to disable and re-enable creating classic agents and assistants on an Azure OpenAI account by setting a resource tag. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/disable-classic-agents). Article date: 2026-05-27. Page updated: 2026-06-02. Retrieved: 2026-09-29. Navigation: Agents > Prompt agents > Text-based agents > Migrate > Disable creation of classic agents.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

You can disable creating or updating classic agents and assistants on an Azure OpenAI account by setting the `MS-AOAI-Feature-Assistants` tag to `Disabled`. This tag opts the account out of the Assistants API surface while leaving other model and inference features unchanged.

## Prerequisites

- The [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed.
- You're signed in to Azure with `az login`.
- **Owner** or **Contributor** access on the target subscription or resource group.

## Disable assistants and classic agents

To disable creation, set the `MS-AOAI-Feature-Assistants` tag to `Disabled` on the Azure OpenAI account.

**[Azure CLI]**

```bash
# CLI — single account
az resource tag --tags MS-AOAI-Feature-Assistants=Disabled \
    --ids /subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.CognitiveServices/accounts/<account>
```

**[Bicep]**

```bicep
// Bicep — single account
resource aoai 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: 'my-foundry-account'
  // ...
  tags: {
    'MS-AOAI-Feature-Assistants': 'Disabled'
  }
}
```

## Re-enable assistants and classic agents

To re-enable creation, set the same tag to `Enabled`.

**[Azure CLI]**

```bash
# CLI — single account
az resource tag --tags MS-AOAI-Feature-Assistants=Enabled \
    --ids /subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.CognitiveServices/accounts/<account>
```

**[Bicep]**

```bicep
// Bicep — single account
resource aoai 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: 'my-foundry-account'
  // ...
  tags: {
    'MS-AOAI-Feature-Assistants': 'Enabled'
  }
}
```

## What gets disabled

When the tag is set to `Disabled`, the following Assistants API operations are blocked on the account:

- Create assistant
- Update assistant
- Create agent
- Update agent
- Create thread
- Create run
- Create thread and run
- Create assistant file

Existing assistants, threads, and files remain in place, but they can't be modified and no new ones can be created until the tag is set back to `Enabled`.

## Related content

- [Migrate to the new Foundry Agent Service](12-migrate.md)
