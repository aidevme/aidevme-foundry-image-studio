# Configure virtual network support for evaluation in Microsoft Foundry

| Field | Value |
| --- | --- |
| **Document Title** | Configure virtual network support for evaluation in Microsoft Foundry |
| **Document Location** | `docs/research-docs/azure-foundry/10-evaluation/02-evaluation-virtual-network.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Configure virtual network support for evaluation in Microsoft Foundry". Learn how to configure virtual network support for evaluation in Microsoft Foundry and troubleshoot network-related evaluation errors. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/concepts/evaluation-virtual-network). Article date: 2026-09-11. Page updated: 2026-09-25. Retrieved: 2026-09-29. Navigation: Evaluation > Virtual network support.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Use a virtual network (VNet) to isolate evaluation traffic in Microsoft Foundry. This article helps you choose the appropriate network setup guidance, configure evaluation-specific requirements, and resolve common network-related evaluation errors.

## Prerequisites

- A Foundry project in a [region that supports VNet evaluation](#virtual-network-region-support).
- Permissions to configure network isolation and assign Azure role-based access control (RBAC) roles.
- A VNet and a subnet that you can delegate for network injection, or permission to deploy them by using the evaluation-only setup template.

## Choose network setup guidance

Use the following table to find the networking guidance for your scenario. Return to this article for requirements and troubleshooting that are specific to evaluation.

| Goal | Guidance |
| --- | --- |
| Understand network isolation options and configure private endpoints, DNS, firewall allow lists, and public network access. | [Configure network isolation for Microsoft Foundry](../13-manage-and-operate/13.3-security-and-governance/07-configure-private-link.md) |
| Use the Microsoft-managed VNet solution for outbound network isolation. | [Configure a managed VNet for Foundry projects](../13-manage-and-operate/13.3-security-and-governance/08-managed-virtual-network.md) |
| Connect a managed VNet to on-premises or non-Azure resources. | [Access on-premises resources from a Foundry managed network](../13-manage-and-operate/13.3-security-and-governance/09-access-on-premises-resources.md) |
| Configure a full private network setup that includes Foundry Agent Service. | [Set up private networking for Foundry Agent Service](../13-manage-and-operate/13.1-set-up-and-configure/12-virtual-networks.md) |
| Understand Agent Service network architecture, traffic flow, subnet sizing, and IP allocation. | [Deep dive into Foundry Agent Service networking](../13-manage-and-operate/13.1-set-up-and-configure/13-agents-networking-deep-dive.md) |
| Use a coding agent to help plan and configure Foundry resources and networking. | [Use the Microsoft Foundry Skill in coding agents](../04-get-started/04.1-what-do-you-want-to-build/05-use-microsoft-foundry-skill.md) |

## Configure evaluation network requirements

Virtual network support for evaluation requires network injection through subnet delegation. If you only need evaluation capabilities and don't require full agent support, such as Azure Cosmos DB, Azure AI Search, or a project capability host, use the simplified [evaluation-only setup template (15a)](https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-bicep/15a-private-network-evaluation-only-setup). The template deploys a minimal network-secured environment for evaluation scenarios.

> **Important**
>
> To prevent evaluation and red teaming run failures, assign the **Foundry User** role to the project's managed identity at the Foundry resource scope during initial project setup.

> **Important**
>
> The Foundry RBAC roles were recently renamed. **Foundry User**, **Foundry Owner**, **Foundry Account Owner**, and **Foundry Project Manager** were previously named Azure AI User, Azure AI Owner, Azure AI Account Owner, and Azure AI Project Manager. You might still see the previous names in some places while the rename rolls out. The role IDs and core permissions are unchanged by the rename.

If you connect Application Insights, evaluation data is sent to it.

## Virtual network region support

You can bring your own VNet for evaluation in the following regions:

| Americas | Europe | Asia Pacific | Middle East & Africa |
| --- | --- | --- | --- |
| Brazil South | France Central | Australia East | South Africa North |
| Canada Central | Germany West Central | Japan East | UAE North |
| Canada East | Italy North | Korea Central |   |
| East US | Norway East | South India |   |
| East US 2 | Poland Central | Southeast Asia |   |
| North Central US | Spain Central |   |   |
| South Central US | Sweden Central |   |   |
| West US | Switzerland North |   |   |
| West US 2 | UK South |   |   |
| West US 3 | West Europe |   |   |

## Configure virtual network support for data generation

Synthetic data generation and trace-to-dataset generation use the same network injection through subnet delegation as evaluation. Use the [evaluation-only setup template (15a)](https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-bicep/15a-private-network-evaluation-only-setup) to deploy the required network-secured environment.

For data-generation region availability, see [Supported regions for data generation](01-evaluation-regions-limits-virtual-network.md#supported-regions-for-data-generation).

## Troubleshoot virtual network evaluation errors

### Diagnose your virtual network configuration

Run the [VNet project setup diagnostic](https://github.com/microsoft-foundry/foundry-samples/blob/main/infrastructure/infrastructure-setup-bicep/15a-private-network-evaluation-only-setup/vnet-project-setup-diagnostic/usage.md) from a machine that has private connectivity to your virtual network. The script inspects an existing Foundry project configuration and its network connectivity without running an evaluation or changing Azure resources.

Follow the usage guide to prepare the prerequisites, run the appropriate diagnostic checks, and review the generated `diagnostics.md` report. The report provides actionable findings, supporting evidence, known limitations, and remediation guidance to help you resolve configuration issues.

### Evaluation run remains in progress until it times out

An evaluation run can remain **In progress** because the network isolation setup is incomplete, required private endpoints aren't configured while public network access is disabled, or the project's managed identity doesn't have permission to update the run status.

To resolve the issue:

1. Verify that network injection and subnet delegation are configured as described in [Configure network isolation for Microsoft Foundry](../13-manage-and-operate/13.3-security-and-governance/07-configure-private-link.md). If you only need evaluation capabilities, compare your deployment with the [evaluation-only setup template (15a)](https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-bicep/15a-private-network-evaluation-only-setup).
2. If public network access is disabled, verify that the required private endpoints are configured and approved, and that private DNS resolves the resource endpoints from the network that was injected to Foundry project.
3. Ensure the Foundry project has capability host setup. We do need the capability host both at Foundry account and project level. If you didn't setup Foundry project level capability host use the bicep template [add-project-capability-host](https://github.com/microsoft-foundry/foundry-samples/blob/main/infrastructure/infrastructure-setup-bicep/15a-private-network-evaluation-only-setup/modules-network-secured/add-project-capability-host.bicep) to setup.
4. Verify that the project's managed identity has the **Foundry User** role at the Foundry resource scope.
5. For a large dataset, run an evaluation against a smaller representative subset. If the smaller run completes, reduce the dataset size or split the dataset across multiple evaluation runs.

### Evaluation run fails to start with a 403 error

The error states that network access is disabled, public network access is disabled but the evaluation service can't reach one or more required resources through the VNet.

`Error: Public access is disabled. Please configure private endpoint.`

To resolve the issue:

1. Identify the resource hostname in the error details or evaluation diagnostics.
2. Verify that network injection and subnet delegation are configured for evaluation.
3. Verify that the private endpoint for the affected resource is configured and approved.
4. Verify that private DNS resolves the hostname and that network rules allow access from within the VNet.
5. Retry the evaluation run after the network configuration changes take effect.

For other `403` errors, verify the RBAC assignments for the user who starts the run and for the project's managed identity. For more evaluation-specific issues, see [Troubleshoot evaluation and observability issues](../09-observability/02-troubleshooting.md).

### Custom DNS doesn't resolve private endpoints

If you define a [custom DNS server](https://learn.microsoft.com/en-us/azure/virtual-network/manage-virtual-network#change-dns-servers) for a virtual network, the system doesn't automatically query private DNS zones linked to that virtual network. The custom DNS settings override the name resolution order.

To enable custom DNS to resolve the private zone, use an [Azure DNS Private Resolver](https://learn.microsoft.com/en-us/azure/dns/dns-private-resolver-overview) in a virtual network linked to the private zone. For configuration guidance, see [Centralized DNS architecture](https://learn.microsoft.com/en-us/azure/dns/private-resolver-architecture#centralized-dns-architecture).

If your custom DNS server runs on an Azure virtual machine, configure a conditional forwarder for the private zone. Set the forwarder's destination to the Azure DNS IP address, `168.63.129.16`.
