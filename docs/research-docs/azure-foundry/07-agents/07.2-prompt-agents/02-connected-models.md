# Use connected Foundry models in Foundry Agent Service

| Field | Value |
| --- | --- |
| **Document Title** | Use connected Foundry models in Foundry Agent Service |
| **Document Location** | `docs/research-docs/azure-foundry/07-agents/07.2-prompt-agents/02-connected-models.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Use connected Foundry models in Foundry Agent Service". Connect to Foundry models hosted in another Foundry resource and use them in your agents without copying or redeploying the models. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/connected-models). Article date: 2026-06-11. Page updated: 2026-06-26. Retrieved: 2026-09-29. Navigation: Agents > Prompt agents > Text-based agents > Build > Use connected Foundry models.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Foundry Agent Service lets your agents call models hosted in another Foundry resource without copying or redeploying them. This capability is part of the broader *bring your own model* experience. For third-party models and the full set of options, see [Bring your own model with the AI Gateway](../../13-manage-and-operate/13.1-set-up-and-configure/14-ai-gateway.md).

This article focuses on connecting to **Foundry models** in another Foundry resource.

> **Note**
>
> Classic agents used capability hosts to reach models in another resource. The new Foundry Agent Service doesn't use capability hosts for this scenario. To use a model from another Foundry resource, create a model connection as described in this article.

## Choose a connection type

There are two ways to connect to models in another Foundry resource:

- **Other source** — Connect directly to another Foundry resource using its project endpoint.
- **Azure API Management** — Connect to a Foundry resource that sits behind an Azure API Management (APIM) instance.

Use **Other source** when you want a quick, direct connection and don't need the additional controls that APIM provides. This article focuses on this option.

Use **Azure API Management** when you already have an APIM instance in front of your Foundry resource, or when you want APIM capabilities beyond connectivity, such as:

- Load balancing across backends
- Throttling and rate limiting
- Governance and guardrails

## Configure a connection

You can create a connection from the Foundry portal or with the Azure CLI.

### Other source

#### Use the Foundry portal

For step-by-step instructions, see [Create a model connection](../../13-manage-and-operate/13.1-set-up-and-configure/14-ai-gateway.md#create-a-model-connection). Provide the following values:

- **Connection details**
  - **Connection type**: Other source
  - **Connection name**: A name of your choice.
  - **Base URL**: `{azure-openai-endpoint}` — find the Azure OpenAI endpoint on the **Overview** page of the Foundry resource you want to connect to.
- **Authentication**: Choose **API key** or **OAuth 2.0** and provide the required details.
  - If using OAuth 2.0, use `https://login.microsoftonline.com/{tenant-id}/oauth2/v2.0/token` for token url and `https://ai.azure.com/.default` for scope
- **Model**: Add at least one model and provide the following values:
  - **Name**: The deployment name of the model.
  - **Display name**: The name shown in the model picker. You can reuse the deployment name.
- **Advanced**: No additional configuration required.

#### Use the Azure CLI

You can also create and manage connections from the Azure CLI for automation and CI/CD scenarios. Use the [model gateway connection Bicep template](https://github.com/microsoft-foundry/foundry-samples/blob/main/infrastructure/infrastructure-setup-bicep/01-connections/foundry-modelgateway-connection-apikey.bicep).

Provide the following parameters:

- **connectionName** — Name of the new model gateway connection to create on the local project. This name appears in the Foundry portal.
- **localAccountName** — Name of the local Foundry (AIServices) account where the connection is created.
- **localProjectName** — Name of the project under the local account that the connection is attached to.
- **remoteAccountName** — Name of the remote Foundry (AIServices) account whose model deployments are invoked through this connection. The connection target URL and API key are derived from this account.
- **remoteAccountResourceGroup** — Resource group of the remote Foundry account.

**Models to connect**

Specify the model deployments on the remote account that you want to expose through the connection. The Bicep template includes a `staticModels` array with sample entries that you can update for your scenario.

**Run the deployment**

Run `az deployment group create` as shown in the Bicep template.

### Azure API Management

For step-by-step instructions, see [Create a model connection](../../13-manage-and-operate/13.1-set-up-and-configure/14-ai-gateway.md#create-a-model-connection).

## Use a connected model in an agent

After you create the connection, the connected models appear in the model picker in the agents playground, and you can select them when you author a prompt agent.

When you create agents in code, reference the connected model using the format `<connection-name>/<model-name>`. For an end-to-end example, see [Create a prompt agent with the model connection](../../13-manage-and-operate/13.1-set-up-and-configure/14-ai-gateway.md#create-a-prompt-agent-with-the-model-connection).

## Considerations

- A connection to another Foundry resource doesn't automatically grant access to every model in that resource. You must explicitly add each model you want to expose, which gives you precise control over what's available to your agents.
- Connections are created at the **resource** scope, so they're available to every project in the resource.

## Known limitations

The following tools aren't supported with connected models:

- [Browser Automation (preview)](../../08-toolboxes/08.1-add-tools-and-skills/31-browser-automation.md)
- [Bing grounding](../../08-toolboxes/08.1-add-tools-and-skills/13-bing-tools.md)
- [SharePoint (preview)](../../08-toolboxes/08.1-add-tools-and-skills/35-sharepoint.md)
- [Memory Search (preview)](../../08-toolboxes/08.1-add-tools-and-skills/39-memory-usage.md#use-memories-via-an-agent-tool)
- [Microsoft Fabric (preview)](../../08-toolboxes/08.1-add-tools-and-skills/34-fabric.md)

## Related content

- [Bring your own model with the AI Gateway](../../13-manage-and-operate/13.1-set-up-and-configure/14-ai-gateway.md)
- [Create a model connection](../../13-manage-and-operate/13.1-set-up-and-configure/14-ai-gateway.md#create-a-model-connection)
- [What is Microsoft Foundry Agent Service?](../01-overview.md)
