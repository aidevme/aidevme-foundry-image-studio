# Microsoft Foundry rollout across my organization

| Field | Value |
| --- | --- |
| **Document Title** | Microsoft Foundry rollout across my organization |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.1-set-up-and-configure/02-planning.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Microsoft Foundry rollout across my organization". Learn how to plan the rollout of Microsoft Foundry across your organization, including environment setup, data isolation, and governance. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/concepts/planning). Article date: 2026-08-21. Page updated: 2026-08-25. Retrieved: 2026-09-29. Navigation: Manage and operate > Set up and configure > Plan rollout.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

A structured deployment plan helps you avoid security gaps, cost overruns, and access sprawl when you adopt Microsoft Foundry at scale. Use this guide to define workload boundaries, choose a resource topology, and establish governance for self-serve teams.

## Prerequisites

Before you begin planning, confirm that you have:

- An understanding of your organization's baseline Azure subscription and resource group organization.
- Inputs on your organization's security requirements for networking, encryption, and data isolation.
- An initial region plan based on model and feature availability. For details, see [feature availability across cloud regions](../../06-models/06.2-quota-limits-and-region-availability/08-region-support.md).
- Agreement on security requirements for networking, encryption, and data isolation in your organization.
- An inventory of the Foundry features and APIs your teams plan to use.

## Define isolation boundaries

Start with Cloud Adoption Framework decision guidance for AI platform sharing, then apply those decisions to Foundry:

- [Define AI platform sharing boundaries](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/platform/ai-platform-sharing-isolation-colocation#1-define-ai-platform-sharing-boundaries)

While every situation is unique, for the common organization we recommend the following sequence:

1. Define nonnegotiable sharing boundaries across business units, data domains, product ownership, and environment tiers.
2. Set a prod policy that defaults to isolation, unless a documented exception allows colocation.
3. Set an exploration policy that defaults to colocation for faster experimentation, unless compliance or validation requires isolation.
4. Assign ownership for each boundary, including security, cost, and incident response ownership.

## Identify capability and access requirements

Determine which Foundry features and APIs each workload requires before you finalize your topology.

> **Note**
>
> Not all Foundry APIs support the full variety of authentication modes, storage encryption levels, and project-level isolation. Some of the Foundry Tools APIs can require role assignments at the parent Foundry resource scope.

For co-located use cases that share one Foundry resource, use Foundry projects as isolated workspaces for each use case. For example, teams experimenting with an idea can create a project to organize coherent assets without repeating infrastructure setup for security, model deployments and tool access.

Most newer, agent-centric Foundry APIs support project-scope permissioning. Some traditional Foundry Tools APIs (former Azure AI Services), such as speech-to-text, still require parent resource-scope access. Plan boundaries and RBAC so all required capabilities are accessible at your intended access-management scope.

| Capability area | Organize by project | Project-level RBAC isolation | Bring your own storage | Networking / encryption support | Planning implication |
| --- | --- | --- | --- | --- | --- |
| Agent capabilities (agents, responses, evaluations, datasets, indexes, files, and playground assets) | Yes | Yes | Yes | Limited in basic setup (managed storage). For full coverage, use 'standard'. | Good fit for project-per-use-case segmentation in shared environments. |
| Fine-tune training | No (default project only) | No | Partial (inputs only) | Yes | If each team needs independent fine-tuning, use separate Foundry resources. Fine-tuned deployments are shared and consumable across projects within a resource. |
| OpenAI image, video, batch | No | No | Partial (only Batch) | Yes | Use an isolated workload setup, and if managed storage is required, validate RBAC constraints early. |
| Content Understanding | Yes | No | Yes | Yes | If strict per-use-case access isolation is required, prefer separate Foundry resources. |
| Speech | Yes (fine-tune) | No | Yes | Limited in basic setup (managed storage). | For full CMK encryption coverage, use BYO Storage. |
| Language | Yes (fine-tune) | No | Yes | Limited in basic setup (managed storage). | For full CMK encryption coverage, use BYO Storage. |
| Translator | No | No | No | Yes | Use separate Foundry resource if isolation is a must. |

> **Important**
>
> Confirm your exact capability mix before rollout. If a required API only works at Foundry resource scope, assign roles at that scope or isolate workloads into separate Foundry resources.

## Choose Foundry resource topology

After you define boundaries and capability needs, choose topology per environment.

| Decision path | Recommended Foundry setup | Best fit | Main tradeoff |
| --- | --- | --- | --- |
| Co-located workloads | One Foundry resource with multiple projects (typically one project per use case) | Experimentation-heavy environments, early prototypes, and teams that benefit from shared deployments and shared connected data or tools | Shared blast radius for production incidents, quota exhaustion, and misconfiguration |
| Fully isolated workloads | One Foundry resource per production workload boundary (often with one primary project per workload) | Production workloads that require strict operational containment, independent access control, and independent quota or cost boundaries | Self-serve enablement harder with more resources to manage and higher setup overhead |

> **Tip**
>
> For production, treat isolation as the default. Use colocation as a deliberate exception only when workload boundaries, data requirements, and risk acceptance are aligned.

![Screenshot of a diagram showing Foundry resource.](https://learn.microsoft.com/en-us/azure/foundry/media/planning/foundry-resource.png)

## Plan your security baseline

Use this reference table as a checklist for security design decisions.

| Area | What to decide | Start with |
| --- | --- | --- |
| Identity and access | Define admin, project manager, and project user personas. Map each persona to least-privilege roles and Microsoft Entra ID groups. | [Role-based access control in Foundry](../13.3-security-and-governance/02-rbac-foundry.md) |
| Networking | Choose the network model per environment. Use managed virtual network for a more secure, straightforward setup. Use bring-your-own (BYO) virtual network for advanced network control and custom routing requirements. Validate private DNS and endpoint approval flow before production. | [Configure managed virtual network](../13.3-security-and-governance/08-managed-virtual-network.md), [Configure private link for Foundry](../13.3-security-and-governance/07-configure-private-link.md), and [Network-secured setup (BYO virtual network)](12-virtual-networks.md) |
| Data protection and keys | Decide whether Microsoft-managed keys meet policy requirements or whether customer-managed keys are required. | [Customer-managed keys in Foundry](../13.3-security-and-governance/11-customer-managed-keys.md) |
| Authentication model | Prefer Microsoft Entra ID and RBAC for people and services. Use API keys only where role granularity isn't required. | [Role-based access control in Foundry](../13.3-security-and-governance/02-rbac-foundry.md) |

## Plan model, region, and capacity strategy

For each workload, define:

- Model families and deployment types required by the use case.
- Data processing requirements (for example, global or regional constraints).
- Throughput and latency targets for interactive and batch scenarios.
- Quota and provisioned capacity requirements for steady-state and peak loads.

Use these references:

- [Models sold directly by Azure](../../06-models/06.1-explore-foundry-models/01-models-sold-directly-by-azure.md)
- [Models from partners](../../06-models/06.1-explore-foundry-models/03-models-from-partners.md)
- [Quota in Foundry](../../06-models/06.2-quota-limits-and-region-availability/02-quota.md)
- [Quotas and limits for Foundry models](../../06-models/06.2-quota-limits-and-region-availability/05-quotas-limits.md)

## Plan connectivity and data integration

For each workload, identify external dependencies and connection patterns:

- Data sources and data stores.
- Internal APIs and line-of-business systems.
- Non-Azure SaaS tools required by agents or orchestration flows.
- Networking requirements, including private endpoints, DNS resolution, egress controls, and whether managed network or BYO virtual network is required.

Use [Add connections in Foundry](15-connections-add.md) to standardize connection setup.

Connections can be created at both the parent Foundry resource-level and child project-level dependent on desired isolation scope. Connections configured at the parent level are available to all projects.

![Screenshot of a diagram showing Foundry project connectivity and integration with other Azure services.](https://learn.microsoft.com/en-us/azure/foundry/media/planning/connectivity.png)

## Plan automation and operations

Define how teams create and manage resources consistently across environments.

- Use infrastructure as code to provision core resources and policy defaults.
- Standardize deployment pipelines for projects, connections, model deployments, and configuration changes.
- Define rollback and incident response procedures for model and policy changes.

For automation patterns and starter implementations, use:

- [Quickstart: Deploy a Microsoft Foundry resource by using a Bicep file](03-create-resource-template.md)
- [Terraform on Azure](https://learn.microsoft.com/en-us/azure/developer/terraform/overview)
- [Security configurations samples](https://github.com/microsoft-foundry/foundry-samples/tree/main/samples)

The sample templates include end-to-end patterns for common security scenarios, such as private networking, customer-managed keys, and role-based access control.

## Define self-serve guardrails

Enable self-serve only within clear constraints:

- Define which roles can create projects, deploy models, and connect external tools.
- Apply policy controls for model deployment and runtime behavior including which model providers, and which tool connections are allowed.
- Set cost controls and budget alerts for shared and isolated environments.
- Enforce trace logging into central observability across Microsoft Foundry, Microsoft Copilot Studio and Microsoft 365.

Use these references:

- [Model deployment policy in Foundry](../13.3-security-and-governance/14-model-deployment-policy.md)
- [Manage costs in Foundry](../../06-models/06.3-offers-deployment-types-and-pricing/16-manage-costs.md)
- [Agent 365 integration](../../07-agents/07.1-concepts/03-agent-365-integration.md)

## Assign ownership and governance

Treat this step as the transition from provisioned infrastructure to operational developer usage.

Most organizations already manage access through precreated Microsoft Entra ID groups. Map those groups to Foundry roles at the required scope, then validate both management and development access paths.

Foundry separates access across:

- **Control plane RBAC actions** for resource management.
- **Data plane RBAC actions** for development workloads.

> **Important**
>
> Management roles such as Owner or Contributor aren't sufficient for all development scenarios. For example, a user can manage resources but still need data plane roles to chat with an agent in Foundry.

For role mapping guidance and required role combinations, see [Role-based access control in Foundry](../13.3-security-and-governance/02-rbac-foundry.md).

After onboarding your user groups, consider establishing or expanding governance dashboards to track Foundry usage, reliability, lineage, and compliance:

- [Monitoring across fleets in Foundry](../13.2-govern-at-scale/02-monitoring-across-fleet.md)
- [Agent 365 integration](../../07-agents/07.1-concepts/03-agent-365-integration.md)
- [Microsoft Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction)
- [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/overview)

## Sample platform deployment

The IT organization at Contoso needs to support multiple teams while balancing two priorities:

- Rapid innovation, where developers can rigorously test the latest AI technologies using non-production data.
- Fully isolated dev/test and prod environments for proven use cases that receive funding for operationalization.

The diagram shows how Contoso co-locates a shared exploration Foundry instance for innovation, available to all teams, with limited capacity and pre-connected data and tools. The sample backlog reflects common enterprise functions such as customer support, employee helpdesk, finance operations, procurement, and sales. Historically, only a handful of use cases progress to proven feasibility or secure funding for a dev/test rollout. From those, an even smaller subset advances to prod. The sample also shows two related sales use cases that stay co-located through exploration and dev/test because they share the same CRM data, user personas, and connected systems. As use cases mature, teams are assigned environments with progressively stronger isolation, culminating in full prod-grade separation where needed.

[![Diagram showing Contoso use cases moving from a shared exploration Foundry environment into isolated or co-located dev/test environments, and then into isolated prod environments for a smaller number of workloads.](https://learn.microsoft.com/en-us/azure/foundry/media/planning/sample-platform-deployment.svg)](https://learn.microsoft.com/en-us/azure/foundry/media/planning/sample-platform-deployment.svg#lightbox)

## Learn more

- Secure the Foundry environment
  - Authentication and RBAC: [Role-based access control in Foundry](../13.3-security-and-governance/02-rbac-foundry.md)
  - Networking: [Use a virtual network with Foundry](../13.3-security-and-governance/07-configure-private-link.md)
  - Customer-managed keys (CMK): [Customer-managed keys in Foundry](../13.3-security-and-governance/11-customer-managed-keys.md)
  - Example infrastructure: [templates repository with sample infrastructure templates](https://github.com/microsoft-foundry/foundry-samples/tree/main/samples)
  - [Recover or purge deleted Foundry resources](https://learn.microsoft.com/en-us/azure/ai-services/recover-purge-resources?toc=/azure/ai-foundry/toc.json&bc=/azure/ai-foundry/breadcrumb/toc.json)
- Establish connectivity with other Azure services
  - Overview of connections: [Add a new connection in Foundry](15-connections-add.md)

## Next step

[Create a project in Foundry](07-create-projects.md)
