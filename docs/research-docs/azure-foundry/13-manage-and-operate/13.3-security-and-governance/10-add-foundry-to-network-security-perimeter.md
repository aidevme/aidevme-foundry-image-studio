# Add Microsoft Foundry to a network security perimeter

| Field | Value |
| --- | --- |
| **Document Title** | Add Microsoft Foundry to a network security perimeter |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.3-security-and-governance/10-add-foundry-to-network-security-perimeter.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Add Microsoft Foundry to a network security perimeter". Quickly learn how to associate a Microsoft Foundry resource with a network security perimeter and where to find detailed guidance for access rules, logging, and management. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/add-foundry-to-network-security-perimeter). Article date: 2026-08-17. Page updated: 2026-08-21. Retrieved: 2026-09-29. Navigation: Manage and operate > Security and governance > Network security > Network security perimeter.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Use a network security perimeter (NSP) to restrict data-plane access to your Microsoft Foundry resource and group it with other protected PaaS resources. An NSP lets you:

- Enforce inbound and outbound access rules instead of broad public exposure.
- Reduce data exfiltration risk by containing traffic within a logical boundary.
- Centrally log network access decisions across associated resources.

This article gives only the Foundry-specific pointers you need. All procedural detail for creating perimeters, defining access rules, enabling logging, and using APIs lives in existing Azure networking documentation. Follow the links in each section for the authoritative steps.

[![Diagram that shows a Foundry resource inside a network security perimeter boundary, with inbound rules filtering external traffic and outbound rules controlling egress to external services.](https://learn.microsoft.com/en-us/azure/foundry/media/how-to/network/network-security-perimeter-diagram.png)](https://learn.microsoft.com/en-us/azure/foundry/media/how-to/network/network-security-perimeter-diagram.png#lightbox)

The diagram shows a Foundry resource inside an NSP boundary. Inbound access rules filter traffic from external sources, and outbound access rules control egress to services outside the perimeter.

## Prerequisites

- An Azure subscription where you can create and manage network security perimeter resources. At minimum, use an account with the **Owner**, **Contributor**, or **Network Contributor** role (or a custom role with equivalent permissions).
- A Foundry resource.
- A network security perimeter (NSP) and profile.
- If you use Azure CLI automation, Azure CLI 2.75.0 or later.
- If you want to query access logs, a Log Analytics workspace.

For the full set of required actions and permissions (profiles, associations, access rules, diagnostic settings), see [Azure RBAC permissions required for network security perimeter](https://learn.microsoft.com/en-us/azure/private-link/network-security-perimeter-role-based-access-control-requirements).

## Verify your setup (Azure CLI)

Run this command to verify that the `nsp` Azure CLI extension is available and that you can query NSP metadata.

```azurecli
az extension add --name nsp --upgrade
az network perimeter associable-resource-type list --location <region> --output table
```

Replace `<region>` with the Azure region of your Foundry resource. The command returns a list of resource types that you can associate with an NSP. Look for `Microsoft.CognitiveServices/accounts` in the output to confirm that Foundry resources support NSP association. If you see an authentication error, sign in by using `az login` and try again.

Reference: [az network perimeter associable-resource-type list](https://learn.microsoft.com/en-us/cli/azure/network/perimeter/associable-resource-type)

## Associate your Foundry resource

### Associate in the portal

1. Open the Azure portal and go to your Network security perimeter resource.
2. Select **Associated resources** (or **Resources** depending on the UI iteration) > **Add / Associate**.
3. Choose the target profile, pick your Foundry resource, set access mode (start with Transition, formerly Learning), and confirm.

For portal screenshots and a detailed walkthrough, see [Assign an Azure OpenAI account to a network security perimeter](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/how-to/network-security-perimeter#assign-an-azure-openai-account-to-a-network-security-perimeter). The same portal flow applies to Foundry resources.

### Associate with Azure CLI

```azurecli
az network perimeter association create \
             --name MyAssociation \
             --perimeter-name MyPerimeter \
             --resource-group MyResourceGroup \
             --access-mode Learning \
             --private-link-resource "{id:<FOUNDRY_RESOURCE_ARM_ID>}" \
             --profile "{id:<NSP_PROFILE_ARM_ID>}"
```

This command associates your Foundry resource with a profile in Transition mode so you can review access logs before you enforce access rules. The CLI value for this mode is `Learning`.

Reference: [az network perimeter association create](https://learn.microsoft.com/en-us/cli/azure/network/perimeter/association#az-network-perimeter-association-create)

For CLI (for automation) and full creation steps, see the NSP quickstarts (CLI or PowerShell):

- [Create a network security perimeter (CLI)](https://learn.microsoft.com/en-us/azure/private-link/create-network-security-perimeter-cli)
- [Create a network security perimeter (PowerShell)](https://learn.microsoft.com/en-us/azure/private-link/create-network-security-perimeter-powershell)

Verify the association by running:

```azurecli
az network perimeter association show \
             --name MyAssociation \
             --perimeter-name MyPerimeter \
             --resource-group MyResourceGroup
```

Confirm the output shows your Foundry resource with the expected access mode. After association, traffic evaluation begins per the selected access mode.

## Choose an access mode

A network security perimeter supports three access modes:

- **Transition** (formerly Learning): Evaluates and logs access without blocking traffic, so you can observe potential denies. The Azure CLI value for this mode is `Learning`.
- **Enforced**: Applies inbound and outbound rules and blocks traffic that no rule allows.
- **Audit**: Logs access decisions for auditing.

Start in Transition mode to observe potential denies. Switch to Enforced mode once you define the required inbound and outbound rules. For more details, see [NSP access modes](https://learn.microsoft.com/en-us/azure/private-link/network-security-perimeter-concepts).

## Understand `publicNetworkAccess` interaction

- Transition mode: `publicNetworkAccess` still governs exposure while you assess logs.
- Enforced mode: NSP rules take precedence; `publicNetworkAccess` is effectively overridden by allowed inbound rules.

## Change access mode

In the portal, locate the association entry for your Foundry resource and choose **Change access mode**. For automation, use `az network perimeter association update`.

Reference: [az network perimeter association update](https://learn.microsoft.com/en-us/cli/azure/network/perimeter/association#az-network-perimeter-association-update)

## Enable logging

Configure diagnostic settings on the NSP resource to send `allLogs` to Log Analytics, Storage, or Event Hubs.

For detailed steps, see [Diagnostic logs for Network Security Perimeter](https://learn.microsoft.com/en-us/azure/private-link/network-security-perimeter-diagnostic-logs).

> **Important**
>
> To help ensure full NSP compliance for diagnostic logging, use Microsoft Entra ID authentication for requests to customer-owned log destinations (Log Analytics workspace, Storage account, or Event Hub).

## Interpret logs

Query the `NSPAccessLogs` table in your Log Analytics workspace to validate allow and deny decisions. Use the logs to finalize required sources or destinations before enforcing.

For examples of log fields you can filter on, such as `MatchedRule` or `Profile`, see [Add an Azure OpenAI service to a network security perimeter](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/how-to/network-security-perimeter#enable-logging-network-access).

## Define access rules

Within the profile, choose:

- Inbound rules: IP ranges or subscription (managed identity) sources.
- Outbound rules: FQDN destinations needed beyond co-located perimeter resources.

Rule creation steps (portal screenshots, CLI parameters, examples):

- [A walkthrough of configuring inbound and outbound rules](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/how-to/network-security-perimeter#add-an-access-rule-for-your-azure-openai-service) using Azure OpenAI NSP (which applies to Foundry data‑plane scenarios).
- Azure CLI reference (access rules): [az network perimeter profile access-rule](https://learn.microsoft.com/en-us/cli/azure/network/perimeter/profile/access-rule)

Implicit trust: Resources inside the same NSP can reach each other when requests are authenticated through managed identity or role assignment. You need explicit rules only for external sources, destinations, or API key patterns.

### Inbound rules

Choose IP range (CIDR) or subscription scope. Prefer subscription and managed identity for internal service‑to‑service traffic. Use IP range only when identity‑based access isn't feasible.

### Outbound rules

List only required FQDNs (principle of least privilege). Keep dependent Azure services in the same NSP to minimize outbound allow entries.

Example FQDNs you might need in Foundry outbound rules (verify for your scenario):

- `*.openai.azure.com` — model endpoints
- `*.blob.core.windows.net` — storage
- `*.search.windows.net` — search indexes

> **Note**
>
> This list is illustrative, not authoritative. Confirm the exact FQDNs required for your scenario. The list depends on which Foundry features and dependent services you use.

## Validate before enforcement

1. Stay in Transition mode initially; review access logs for denies affecting required traffic.
2. Add or refine inbound and outbound rules.
3. Switch to Enforced mode.
4. Open [Microsoft Foundry](https://ai.azure.com/?cid=learnDocs) and perform a model deployment or chat test. Success indicates required traffic is permitted.
5. If blocked, revert to Transition mode or add rules and retry.

## Troubleshooting

- If the portal experience doesn't show your Foundry resource as associable, confirm that Foundry is supported for NSP association in your region and review the supported resource types: [Network security perimeter concepts](https://learn.microsoft.com/en-us/azure/private-link/network-security-perimeter-concepts).
- If you don't see logs after enabling diagnostics, confirm that you selected `allLogs` and that your destination is supported: [Diagnostic logs for Network Security Perimeter](https://learn.microsoft.com/en-us/azure/private-link/network-security-perimeter-diagnostic-logs).
- If Transition mode looks correct but Enforced mode blocks access, return to Transition mode and add the minimum inbound and outbound rules needed for your scenario: [Azure OpenAI NSP guidance](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/how-to/network-security-perimeter).
- If your managed identity can't reach co-located resources, verify that both resources are in the same NSP and that role assignments are correct.
- If logs don't appear immediately after you enable diagnostics, allow up to 15 minutes for diagnostic data to propagate to your Log Analytics workspace.

## Review limitations and considerations

- NSP governs data-plane traffic. Control-plane (management) operations might still succeed unless separately restricted.
- Use a managed identity (system or user-assigned) with appropriate role assignments for any data source access (for example Azure Blob Storage used for batch inputs/outputs).
- Co-locate dependent services (Azure OpenAI, Azure Storage, Azure AI Search, and so on) in the same NSP when you need mutual access with minimal outbound allow rules.
- For diagnostic log export to customer-owned destinations (Log Analytics, Storage, Event Hub), use Microsoft Entra ID authentication for full perimeter coverage of logging traffic.

For more information, see [Network security perimeter concepts](https://learn.microsoft.com/en-us/azure/private-link/network-security-perimeter-concepts).

## View and manage your configuration

Use REST or CLI to audit and reconcile:

- REST reference (perimeter core): [Network security perimeter REST API](https://learn.microsoft.com/en-us/rest/api/network-security-perimeter/)
- (Example) Profile and association operations (CLI): [Azure CLI network perimeter commands](https://learn.microsoft.com/en-us/cli/azure/network/perimeter)

Use API version `2024-10-01` or the latest version shown in the REST reference when scripting. Always confirm the current API version in the reference before scripting.

## Related content

- [Role-based access control for Foundry](02-rbac-foundry.md)
- [Network security perimeter concepts](https://learn.microsoft.com/en-us/azure/private-link/network-security-perimeter-concepts)
- [Azure OpenAI NSP article](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/how-to/network-security-perimeter)
- [Azure CLI network perimeter reference](https://learn.microsoft.com/en-us/cli/azure/network/perimeter)
- [What is Foundry Agent Service?](../../07-agents/01-overview.md)
