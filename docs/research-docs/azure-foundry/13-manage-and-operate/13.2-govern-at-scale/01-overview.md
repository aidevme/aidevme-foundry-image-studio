# What is Microsoft Foundry Control Plane?

| Field | Value |
| --- | --- |
| **Document Title** | What is Microsoft Foundry Control Plane? |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.2-govern-at-scale/01-overview.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "What is Microsoft Foundry Control Plane?". Learn how Microsoft Foundry Control Plane provides unified visibility, governance, and control for AI agents, models, and tools across your enterprise. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/control-plane/overview). Article date: 2026-05-06. Page updated: 2026-08-13. Retrieved: 2026-09-29. Navigation: Manage and operate > Govern at scale > Overview.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Microsoft Foundry Control Plane is a unified management interface that provides visibility, governance, and control for AI agents, models, and tools across your Foundry enterprise. Foundry Control Plane centralizes management for your AI agent fleet, from build to production.

As your organization evolves from isolated copilots to autonomous multi-agent fleets, you need unified oversight. Foundry Control Plane provides the centralized management that you need to scale reliably.

This article is intended for enterprise administrators and AI developers who manage AI agents across multiple projects. You learn what Foundry Control Plane offers, including fleet management, observability, compliance enforcement, and security capabilities.

## Prerequisites

To explore Foundry Control Plane, you need:

- An Azure account with an active subscription. If you don't have one, create a [free Azure account, which includes a free trial subscription](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- A Foundry project. If you don't have one, [create a project](../13.1-set-up-and-configure/07-create-projects.md).

- An [AI gateway configured](09-enable-ai-api-management-gateway-portal.md) for advanced governance features.
- Appropriate Azure role-based access control (RBAC) permissions for your subscription.

## When to use Foundry Control Plane

Consider using Foundry Control Plane when your organization:

- Manages multiple AI agents across different projects or teams.
- Requires centralized compliance visibility and policy enforcement across an AI fleet.
- Integrates Microsoft Defender and Microsoft Purview for AI governance and threat protection.
- Operates agents from multiple platforms, including Foundry, Microsoft, and non-Microsoft sources.
- Needs to track cost, token usage, and resource consumption across an entire AI environment.

Without Foundry Control Plane, you manage agents, models, and compliance through individual Azure portal blades and separate per-project views. Foundry Control Plane adds cross-project visibility, unified compliance enforcement, and integrated security signals in a single interface.

## Foundry Control Plane capabilities

Foundry Control Plane consolidates *inventory, observability, compliance, and security* into one role-aware interface. It integrates with Microsoft security and governance systems (Microsoft Defender, Microsoft Purview, Microsoft Entra) to provide governance at scale.

The following diagram shows how Foundry Control Plane provides unified fleet visibility with agents, models, and tools listed across projects in a subscription.

[![Diagram that depicts Foundry Control Plane unified fleet visibility with agents, models, and tools listed across projects in a subscription.](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/overview/control-plane-overall.png)](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/overview/control-plane-overall.png#lightbox)

Foundry Control Plane supports the following tasks.

### Manage your multi-platform agent fleet

- Track key performance indicators such as active agents, run completion, compliance posture, cost efficiency, and prohibited behaviors across [supported agent platforms](03-how-to-manage-agents.md#supported-agent-platforms).
- Use deep links to evaluation and monitoring experiences for rapid debugging, diagnosis, and remediation.
- Visualize fleet health through dashboards that surface trends and anomalies.

### Monitor and improve agent performance

- Correlate alerts, evaluation results, and trace data to identify problems quickly.
- [Continuously evaluate](../../07-agents/07.3-hosted-agents/33-how-to-monitor-agents-dashboard.md#set-up-continuous-evaluation) agent performance, quality, and risk dimensions. Risk dimensions might include [task adherence, intent resolution, tool call success](../../10-evaluation/10.1-supported-evaluators/06-agent-evaluators.md), [groundedness](../../10-evaluation/10.1-supported-evaluators/04-rag-evaluators.md), sensitive data leakage, and exposure to jailbreak and cross-domain prompt injection attacks (XPIAs).
- Use the [AI Red Teaming Agent](../../10-evaluation/10.4-ai-red-teaming/01-ai-red-teaming-agent.md) and [cluster analysis](../../10-evaluation/10.3-run-evaluations/16-cluster-analysis.md) for automated vulnerability probing and error root-cause discovery.
- View recommendations for prompt refinements, model version upgrades, and configuration changes.

### Enforce compliance guardrails

- Define enterprise-wide guardrail policies for safety, compliance, and quality.
- Apply bulk remediation to correct noncompliant configurations across your fleet.

### Secure agents

- Schedule automated red-teaming scans and drift monitoring for ongoing agent testing.
- View Defender and Microsoft Purview alerts directly on the Foundry Control Plane dashboard.
- Track rate limits, token usage, and cost anomalies to prevent inefficiency or abuse.

## Key features

> **Important**
>
> Items marked (preview) in this article are currently in public preview. This preview is provided without a service-level agreement, and we don't recommend it for production workloads. Certain features might not be supported or might have constrained capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

You access the capabilities described previously through panes by selecting **Operate** on the upper-right toolbar of the Foundry workspace. From **Operate**, you can monitor, govern, and optimize every agent, model, and deployment within your subscription. Project-scoped settings, such as **Quota** and **AI Gateway**, are on the **Manage** toolbar button instead. You can currently access these features through the Foundry portal only.

Each pane within **Operate** is designed around a specific job. These panes help various roles, from builders to administrators, manage AI systems at scale.

[![Screenshot that shows the Operate toolbar button and the Overview pane in the Foundry workspace.](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/overview/control-plane-operate.png)](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/overview/control-plane-operate.png#lightbox)

### Overview

Use the **Overview** pane to understand fleet health, performance, and compliance at a glance.

[![Animation of the Overview pane that displays trend-based health scores, alert summaries, and aggregated compliance metrics for a fleet.](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/overview/control-plane-overview.gif)](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/overview/control-plane-overview.gif#lightbox)

This pane provides a high-level snapshot of your AI resources by aggregating key operational and compliance metrics in one view. You can:

- View key statistics such as active agents, cost trends, run completion rate, and prevented behaviors.
- Drill into anomalies or cost spikes through contextual charts and direct links to inventory, observability, or policy information.
- Identify potential risks early by using trend-based health scores and alert summaries.

### Assets

Use the **Assets** pane to track, analyze, and manage every agent, model, and tool from one place.

[![Screenshot of an agent inventory table with filters and sort options applied to display metadata and health indicators for AI assets.](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/overview/assets-view.png)](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/overview/assets-view.png#lightbox)

This pane provides a unified, searchable table of all AI assets across projects within a subscription. It brings together critical metadata and health indicators, so you can assess and act on your AI resources efficiently. You can:

- Filter and sort by key attributes such as version, tags, health score (percentage), cost, alerts, and token usage to locate assets quickly.
- Drill down from any entry in the agent inventory table into the [Evaluation](../../07-agents/07.3-hosted-agents/33-how-to-monitor-agents-dashboard.md#set-up-continuous-evaluation) or [Monitoring](../../07-agents/07.3-hosted-agents/33-how-to-monitor-agents-dashboard.md) tab for pre-deployment and post-deployment insights.
- Surface inline recommendations to refine prompts, upgrade models, or optimize configurations based on performance and cost signals.
- Correlate runtime logs with evaluation results to uncover root causes of errors or performance degradation.
- Visualize drift, latency, and error clusters across runs or builds to detect emerging issues early.
- Integrate with the [AI Red Teaming Agent](../../10-evaluation/10.4-ai-red-teaming/01-ai-red-teaming-agent.md) to automate vulnerability probing, regression testing, and issue reproduction.
- Observe and modify model and agent guardrails.

### Compliance

Use the **Compliance** pane to govern your AI systems and enforce the right guardrails.

[![Screenshot of the Compliance pane that shows options to define, apply, and monitor AI compliance policies with Azure Policy, Microsoft Defender, and Microsoft Purview integrations.](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/overview/compliance.png)](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/overview/compliance.png#lightbox)

The **Compliance** pane lets you define, apply, and continuously monitor guardrails and compliance policies across your AI resources. It provides a unified interface to operationalize responsible AI principles while helping to ensure enterprise-grade safety and regulatory alignment. You can:

- Define and enforce protections through deep integrations with Azure Policy, Defender, and Microsoft Purview. These integrations help ensure that identity, data, and threat safeguards work in concert.
- Apply versioned policies and track assignments to maintain full auditability and traceability across agents and environments.
- Monitor compliance posture in real time, so that you can surface noncompliant assets and enable bulk remediation directly from Foundry Control Plane.

Policy management in Foundry enables administrators and developers alike to embed quality and safety requirements into the development and deployment lifecycle. These policies help ensure that all models operate safely and adhere to organizational and regulatory standards.

### Quota

Use the **Quota** pane, on the **Manage** toolbar button, to view, adjust, and request quotas.

[![Screenshot of the Quota pane in the Manage section that shows model deployments, their quota usage, and usage patterns with options to adjust or request additional quotas.](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/overview/quota-view.png)](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/overview/quota-view.png#lightbox)

The **Quota** pane shows your model deployments and how much quota each deployment consumes. It gives insights into usage patterns and helps you manage resources effectively.

By default, the quota view displays only models with active deployments. Turn on the **Show all** toggle to see the full list of available models and regions, including models you haven't deployed yet. Use **Show all** to explore available quota before you create a deployment, or to check which regions have capacity for a specific model.

For more information, see [Manage and increase quotas for resources](../../06-models/06.2-quota-limits-and-region-availability/02-quota.md).

### Project and resource management

Use the **Manage** toolbar button to view and administer the project you're working in and its parent Foundry resource.

**Manage** is scoped to your current selection, which is a key difference from **Operate**. To act on a different project, switch projects first by using the project name dropdown in the upper left.

From **Manage**, administrators and power users can:

- Review project configuration on the **Project details** pane, including the resource ID, endpoint, subscription, and location.
- Review parent resource configuration on the **Resource details** pane, and open the resource in the Azure portal.
- Add or remove users on the **Users** tab, to define granular access levels aligned with organizational roles.
- Attach or manage connected resources, such as storage accounts and Foundry Tools, on the **Connected resources** tab, so that projects remain properly provisioned.
- Add projects to the parent resource, and review every project the resource contains, on the **Projects** tab of **Resource details**.
- Configure quota and AI Gateway for the resource.

## Get started with Foundry Control Plane

Foundry Control Plane is available in the [Foundry portal](https://ai.azure.com/). To start using Foundry Control Plane, explore these resources:

- [Configure an AI gateway](09-enable-ai-api-management-gateway-portal.md): Enable advanced governance features in your Foundry projects.
- [Configure monitoring for your agent fleet](02-monitoring-across-fleet.md): Enable metrics and diagnostic information with observability features.
- [Discover agents in your subscription](03-how-to-manage-agents.md): See which agents are available and manage them centrally.
- [Register custom agents](04-register-custom-agent.md): Bring external agents into the Foundry Control Plane registry.
- [Apply a guardrail policy for models](07-quickstart-create-guardrail-policy.md): Create and assign guardrail policies to enforce safety standards across model deployments.

## Related content

- [Manage agents at scale](03-how-to-manage-agents.md): Track and manage agents from supported platforms in one unified view.
- [Manage compliance and security in Microsoft Foundry](08-how-to-manage-compliance-security.md): Enforce responsible AI policies, integrate Defender and Microsoft Purview signals, and respond to compliance alerts.
- [Enforce token limits](06-how-to-enforce-limits-models.md): Set and manage token-based rate limits for model deployments.
- [Govern agent infrastructure as a Microsoft Entra administrator](05-govern-agent-infrastructure-entra-admin.md): Manage agent identity and access from an Entra admin perspective.
