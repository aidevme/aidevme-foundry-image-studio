# Network isolation for a toolbox in Microsoft Foundry

| Field | Value |
| --- | --- |
| **Document Title** | Network isolation for a toolbox in Microsoft Foundry |
| **Document Location** | `docs/research-docs/azure-foundry/08-toolboxes/08.2-manage-toolbox/03-toolbox-network-isolation.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Network isolation for a toolbox in Microsoft Foundry". Understand how toolbox tool traffic flows when your Microsoft Foundry project uses network isolation, and set up a network-secured toolbox for Basic and Standard agent projects. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/toolbox-network-isolation). Article date: 2026-08-03. Page updated: 2026-08-15. Retrieved: 2026-09-29. Navigation: Toolboxes > Manage toolbox > Network isolation.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

A toolbox is a logical container for tools and doesn't deploy its own networking resources. The networking configuration of the Microsoft Foundry project that hosts the toolbox governs all network access.

When your project runs inside a virtual network (VNet) with [network isolation (private link)](../../13-manage-and-operate/13.3-security-and-governance/07-configure-private-link.md), agents reach the toolbox MCP endpoint through the project's private endpoint. Each downstream tool's traffic flows differently depending on the tool type.

Tool connectivity depends on where the downstream service is hosted. Some tools communicate with Azure resources that support private endpoints, some invoke services that run through the project's delegated subnet, and others depend on Microsoft-managed services that currently require public or backbone connectivity. Review how each tool behaves before you add it to a toolbox in a network-isolated environment.

## Network isolation support for tools in a toolbox

Network-isolated projects work best with tools that support private endpoints or VNet subnet integration. Review the support table before building a toolbox intended for regulated or highly secured environments.

The following table shows how each tool's traffic flows when your project uses network isolation. Some tools route through your VNet subnet or a private endpoint, some use public endpoints or the Microsoft backbone network, and some aren't supported in a network-isolated project.

| Tool | VNet support (traffic flow) |
| --- | --- |
| [Model Context Protocol (MCP)](../08.1-add-tools-and-skills/01-model-context-protocol.md) | ✅ Supported (through your VNet subnet). |
| [Azure AI Search](../08.1-add-tools-and-skills/28-ai-search.md) | ✅ Supported (through private endpoint). |
| [File search](../08.1-add-tools-and-skills/23-file-search.md) | ✅ Supported (through private endpoint). |
| [OpenAPI](../08.1-add-tools-and-skills/08-openapi.md) | ✅ Supported (through your VNet subnet). |
| [Agent-to-agent (A2A)](../08.1-add-tools-and-skills/09-agent-to-agent.md) | ✅ Supported (through your VNet subnet). |
| [Web search](../08.1-add-tools-and-skills/12-web-search.md) | ✅ Supported. Relies on Microsoft-managed public endpoints. |
| [Code interpreter](../08.1-add-tools-and-skills/26-code-interpreter.md) | ✅ Supported (Microsoft backbone network). |
| [Skills](../08.1-add-tools-and-skills/06-skills.md) | ✅ Supported (network behavior depends on the tools used by the skill). |
| [Fabric IQ](../08.1-add-tools-and-skills/21-fabric-iq.md) | ⚠️ Partial. Fabric IQ connectivity is provided through MCP integration. Support depends on the specific Fabric item and networking configuration. See [Restrict network access](../08.1-add-tools-and-skills/21-fabric-iq.md#restrict-network-access). |
| [Work IQ](../08.1-add-tools-and-skills/22-work-iq.md) | ❌ Not supported in network-isolated projects. |
| [Browser automation](../08.1-add-tools-and-skills/31-browser-automation.md) | ❌ Not supported. |
| [Tool search](../02-tool-search.md) | N/A |

Tools that use your VNet subnet communicate through the delegated subnet associated with the Foundry project. These tools can access resources reachable from that subnet, subject to your network security rules.

For the authoritative, tool-by-tool support matrix, see [Agent tools with network isolation](../../13-manage-and-operate/13.3-security-and-governance/07-configure-private-link.md#agent-tools-with-network-isolation). For the full list of tools and their SDK and tooling support, see [Feature support](../01-toolbox.md#feature-support).

## Set up a network-secured project

Set up network isolation at the project level, then create your toolbox in that project. You can find the infrastructure-as-code templates in the [Foundry samples infrastructure setup repository](https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-bicep) (Bicep, with a Terraform mirror). The template you choose depends on your [agent project type](../../13-manage-and-operate/13.3-security-and-governance/06-networking-options.md#bring-your-own-virtual-network-requirements).

### Configure a Basic agent project

A Basic agent project uses platform-managed data resources. To place it inside your own virtual network with private endpoints and no public egress, deploy the [`11-private-network-basic-vnet`](https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-bicep/11-private-network-basic-vnet) template. To restrict who can call the endpoint while keeping public egress, use [`10-private-network-basic`](https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-bicep/10-private-network-basic).

### Configure a Standard agent project

A Standard agent project brings your own data resources (Azure Cosmos DB, Azure Storage, and Azure AI Search). For full isolation with no public egress and bring-your-own data resources, deploy the [`15-private-network-standard-agent-setup`](https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-bicep/15-private-network-standard-agent-setup) template.

For the full template catalog and what each one provisions, see the [infrastructure setup README](https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-bicep#readme). For a step-by-step walkthrough of customizing the scaffolded infrastructure, see [Set up private networking for Foundry Agent Service](../../13-manage-and-operate/13.1-set-up-and-configure/12-virtual-networks.md).

## Related content

- [Networking options for Foundry Agent Service](../../13-manage-and-operate/13.3-security-and-governance/06-networking-options.md)
- [Set up private networking for Foundry Agent Service](../../13-manage-and-operate/13.1-set-up-and-configure/12-virtual-networks.md)
- [Configure network isolation for Microsoft Foundry](../../13-manage-and-operate/13.3-security-and-governance/07-configure-private-link.md)
- [Create and manage a toolbox](../01-toolbox.md)
