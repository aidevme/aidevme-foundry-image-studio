# Update a hosted agent endpoint and agent card

| Field | Value |
| --- | --- |
| **Document Title** | Update a hosted agent endpoint and agent card |
| **Document Location** | `docs/research-docs/azure-foundry/07-agents/07.3-hosted-agents/57-update-agent-endpoint-cli.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Update a hosted agent endpoint and agent card". Patch a Microsoft Foundry hosted agent endpoint and agent card metadata with azd without creating a new hosted agent version. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/update-agent-endpoint-cli). Article date: 2026-06-15. Page updated: 2026-08-27. Retrieved: 2026-09-29. Navigation: Agents > Hosted agents > Ship to production > Update endpoint and card.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

> **Important**
>
> Items marked (preview) in this article are currently in public preview. This preview is provided without a service-level agreement, and we don't recommend it for production workloads. Certain features might not be supported or might have constrained capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

Use `azd ai agent endpoint update` to patch endpoint and card metadata on an already-deployed Microsoft Foundry agent. You can refresh consumer-facing details without cutting a new agent version.

If you use a coding agent like GitHub Copilot, the [Microsoft Foundry Skill](../../04-get-started/04.1-what-do-you-want-to-build/05-use-microsoft-foundry-skill.md) can help update endpoint metadata and agent card settings while keeping deployment changes separate.

## Prerequisites

- An existing hosted agent deployed to a Foundry project. `endpoint update` doesn't create a hosted agent.
- An azd project that has the agent declared in `azure.yaml`, or an explicit Foundry project endpoint. For more information, see [Set the azd project context](../../05-developer-tools-and-integrations/05.1-azure-developer-cli/03-cli-project-context.md).
- The [azd Foundry extensions installed](../../05-developer-tools-and-integrations/05.1-azure-developer-cli/02-install-cli-foundry-extensions.md).
- An authenticated `azd` session.

## Decide when to update metadata

Use `azd ai agent endpoint update` when you only need to refresh metadata that consumers and tooling read about the agent. This metadata includes the public endpoint, display name, description, and contact info.

Common cases include:

- You changed the public-facing display name or description on the agent card and want it reflected in the Foundry portal without redeploying.
- You moved or re-issued the public agent endpoint URL.
- You updated owner or contact metadata on the card for routing or governance.

If you changed the model, instructions, tools, code, or environment variables, don't use `endpoint update`. Those changes need a new version. Run `azd deploy` or `azd up` instead.

## Update the endpoint and card

1. Edit the `agent_endpoint` section, the `agent_card` section, or both sections in the `azure.ai.agent` service in your `azure.yaml` file.
2. Run the update command:

   ```bash
   azd ai agent endpoint update
   ```
3. In a multi-service project, pass the service name as a positional:

   ```bash
   azd ai agent endpoint update my-agent
   ```

The CLI reads the two sections from the agent service in `azure.yaml` and patches the existing agent record. The process doesn't create a new agent version, rebuild a container, or change any infrastructure.

## Verify the update

Confirm the change took effect:

```bash
azd ai agent show
```

The output reflects the new endpoint and card values. The version number is unchanged.

## Review fields updated

`endpoint update` only updates endpoint and card metadata. Use the table to decide whether your change requires a full deploy.

| Field on the `azure.ai.agent` service | Updated by `endpoint update`? |
| --- | --- |
| `agent_endpoint` | Yes |
| `agent_card` | Yes |
| `model`, `model_deployment` | No - requires `azd deploy` |
| `instructions` | No - requires `azd deploy` |
| `tools`, `toolboxes`, `skills` | No - requires `azd deploy` |
| `env` | No - requires `azd deploy` |
| Container image / entry point / runtime | No - requires `azd deploy` |

If you're not sure whether a change qualifies for `endpoint update`, run `azd ai agent doctor` afterward. It flags any divergence between `azure.yaml` and the deployed agent state.

## Related content

- [Diagnose hosted agent issues](30-agent-doctor.md) to catch `azure.yaml` versus deployed-state drift.
- [Deploy a hosted agent](49-deploy-hosted-agent.md) when you need a new agent version.
- [Author azure.yaml for hosted agents](18-author-azure-yaml.md) to understand hosted agent service fields.
