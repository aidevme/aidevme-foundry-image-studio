# Troubleshoot authorization errors for agents published to Microsoft Copilot and Teams

| Field | Value |
| --- | --- |
| **Document Title** | Troubleshoot authorization errors for agents published to Microsoft Copilot and Teams |
| **Document Location** | `docs/research-docs/azure-foundry/07-agents/07.5-publish-and-share/04-troubleshoot-publish-copilot-authorization.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Troubleshoot authorization errors for agents published to Microsoft Copilot and Teams". Resolve authorization errors for Microsoft Foundry agents published to Microsoft Copilot and Teams. |
| **Version** | 1.0 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/troubleshoot-publish-copilot-authorization). Index: 7.6.3.2. Article date: 2026-09-29. Page updated: 2026-09-29. Last synced: 2026-09-30T07:28:53Z. Navigation: Agents > Publish and share > Troubleshooting > Authorization errors.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

This guide is for IT admins and agent developers who manage access to published agents. Use it when a user can find or open a published Microsoft Foundry agent in Microsoft Copilot or Microsoft Teams but receives an authorization or insufficient permissions error when they send a message.

## What the error means

The agent endpoint uses an authorization scheme to determine who can invoke the agent. An agent published with **Just you** in the Foundry portal or `publishScope` set to `Shared` through the REST API uses `BotServiceRbac`. With this scheme, users need an Azure role that grants permission to invoke the agent endpoint.

Store visibility and endpoint authorization are separate. A user might receive or open a link to an agent but still be unable to invoke it because they don't have the required role.

## How to fix

Choose a solution based on the intended audience:

- If everyone in the organization's tenant should be able to invoke the agent, replace `BotServiceRbac` with `BotServiceTenant`.
- If only selected users should be able to invoke the agent, assign them the **Foundry Agent Consumer** built-in role.

### Allow everyone in the tenant to invoke the agent

`BotServiceTenant` allows users in the Foundry project's tenant to invoke the agent. An endpoint can use either `BotServiceRbac` or `BotServiceTenant`, but not both. Replacing the scheme changes endpoint authorization. It doesn't change where the agent appears in the Microsoft Copilot or Teams agent store.

Complete the following steps in order. Publishing at tenant scope and Microsoft 365 admin approval are required before you patch the authorization scheme.

1. Publish the agent at tenant scope:
   - In the Foundry portal, select **People in your organization** under **Choose who can use this agent**.
   - In the REST API, set `publishScope` to `Tenant`.

   For publishing instructions, see [Publish agents to Microsoft Copilot and Microsoft Teams](01-publish-copilot.md).
2. Engage your Microsoft 365 IT admin to review and approve the agent in the [Microsoft 365 admin center](https://admin.cloud.microsoft/?#/agents/all/requested). After approval, the agent appears under **Built by your org** in the agent store.
3. Get a bearer token for the Foundry API:

   ```azurecli
   az account get-access-token \
     --resource https://ai.azure.com \
     --query accessToken \
     --output tsv
   ```
4. Get the agent and review its current `authorization_schemes`:

   ```http
   GET {{endpoint}}/agents/{{agent_name}}?api-version=v1
   Authorization: ******
   ```

   The project endpoint has the following format:

   ```
   https://<resource-name>.services.ai.azure.com/api/projects/<project-name>
   ```
5. After the tenant-scope publish request is approved, patch the agent endpoint. Retain `Entra` and any other non-Bot Service schemes that the endpoint needs. Replace `BotServiceRbac` with `BotServiceTenant`.

   The following example retains `Entra` and replaces `BotServiceRbac` with `BotServiceTenant`:

   ```http
   PATCH {{endpoint}}/agents/{{agent_name}}?api-version=v1
   Authorization: ******
   Content-Type: application/merge-patch+json

   {
     "agent_endpoint": {
       "authorization_schemes": [
         {
           "type": "Entra"
         },
         {
           "type": "BotServiceTenant"
         }
       ]
     }
   }
   ```

   > **Important**
   >
   > The PATCH request replaces the `authorization_schemes` array. Start with the schemes returned by the GET request, retain `Entra`, and replace `BotServiceRbac` with `BotServiceTenant`. Don't configure both Bot Service schemes. Omitting another existing scheme removes it from the endpoint.
6. Ask a user in the tenant to start a new conversation with the agent and send a message.

### Grant selected users access to the agent

Assign the **Foundry Agent Consumer** built-in role when the agent should remain restricted to selected users. Assign the role at one of these scopes:

- **Project scope** grants the user access to every agent endpoint in the project.
- **Agent scope** grants the user access only to the specified agent endpoint.

You need permission to create Azure role assignments at the selected scope. Use Azure CLI for project- or agent-scoped assignments.

#### Grant access to every agent in the project

Set the project scope, and assign the role to the end user's Microsoft Entra object ID:

```azurecli
PROJECT_SCOPE="/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.CognitiveServices/accounts/<account-name>/projects/<project-name>"

az role assignment create \
  --assignee-object-id "<user-object-id>" \
  --assignee-principal-type User \
  --role "eed3b665-ab3a-47b6-8f48-c9382fb1dad6" \
  --scope "$PROJECT_SCOPE"
```

#### Grant access to one agent

Set the agent scope, and assign the role to the end user's Microsoft Entra object ID:

```azurecli
AGENT_SCOPE="/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.CognitiveServices/accounts/<account-name>/projects/<project-name>/agents/<agent-name>"

az role assignment create \
  --assignee-object-id "<user-object-id>" \
  --assignee-principal-type User \
  --role "eed3b665-ab3a-47b6-8f48-c9382fb1dad6" \
  --scope "$AGENT_SCOPE"
```

The role definition ID `eed3b665-ab3a-47b6-8f48-c9382fb1dad6` identifies the **Foundry Agent Consumer** built-in role. Role assignments can take several minutes to propagate. After the assignment propagates, ask the user to start a new conversation and send a message.

## Related content

- [Troubleshoot publishing agents to Microsoft Copilot and Microsoft Teams](03-troubleshoot-publish-copilot.md)
- [Role-based access control in Microsoft Foundry](../../13-manage-and-operate/13.3-security-and-governance/02-rbac-foundry.md)
- [Configure and share your agent](../07.2-prompt-agents/05-configure-agent.md)
