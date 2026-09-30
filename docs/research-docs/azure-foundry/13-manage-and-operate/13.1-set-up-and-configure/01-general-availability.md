# Microsoft Foundry portal general availability overview

| Field | Value |
| --- | --- |
| **Document Title** | Microsoft Foundry portal general availability overview |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.1-set-up-and-configure/01-general-availability.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Microsoft Foundry portal general availability overview". Learn what general availability means for Microsoft Foundry, including GA scope, supported scenarios, feature readiness, and migration guidance. |
| **Version** | 1.2 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/concepts/general-availability). Article date: 2026-08-14. Page updated: 2026-09-23. Retrieved: 2026-09-29. Navigation: Manage and operate > Set up and configure > General availability overview.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

The new Microsoft Foundry portal is generally available (GA). This milestone marks a shift from pilot-focused usage to secure, reliable, enterprise-ready production usage for core scenarios.

Foundry is designed for teams that need to build, deploy, and operate AI systems at scale, with governance, security, and operational controls integrated throughout the lifecycle. Foundry unifies the end-to-end lifecycle across **Discover**, **Build**, and **Operate** so teams can move faster without trading off reliability, compliance, or operational rigor.

## Prerequisites

Before you standardize on GA features for production, make sure you:

- Understand your required scenarios across model deployment, agent development, and operations.
- Identify any current dependencies on preview-only or classic portal experiences.
- Define your organization policy for using only GA capabilities in production.
- Review migration guidance for existing Azure OpenAI and Foundry (classic) portal workloads.
- Confirm required role assignments for your teams and service identities. For role details, see [Role-based access control for Microsoft Foundry](../13.3-security-and-governance/02-rbac-foundry.md).
- Define how your organization restricts preview feature access in production environments. For guidance, see [Disable preview features in Microsoft Foundry](../13.3-security-and-governance/04-disable-preview-features.md).

## Key terms used in this article

- **GA**: Generally available features supported for production use.
- **Preview**: Features that are not yet generally available.
- **Foundry projects**: Workspace containers that organize your AI assets, deployments, and agent configurations within the new Foundry portal.
- **AOAI**: Azure OpenAI resources and workflows.

## What GA means for customers

At GA, the new Microsoft Foundry portal provides:

- **Production-ready core platform** with validated end-to-end core scenarios.
- **Enterprise capabilities for supported scenarios** including RBAC, audit logs, compliance controls, and virtual network integration. Monitoring, alerting, and some networking experiences remain in preview.
- **Governed lifecycle consistency** across the portal, APIs, SDKs, CLI, and developer tools.
- **Defined GA scope** for Foundry projects, with out-of-scope capabilities continuing in Foundry (classic) portal.

> **Note**
>
> Foundry supports API key authentication for most areas. Exceptions: evaluations, dataset tab, Content Understanding, agents, and workflows require Microsoft Entra ID authentication.

For governance-sensitive production workloads, use Microsoft Entra ID with RBAC for role-based access control. API key-based access is available, but it doesn't provide the same role-based permission granularity. For billing and cost management details, see [Plan and manage costs for Microsoft Foundry](02-planning.md).

## GA scope by project type

At GA, the new Foundry portal supports Foundry projects for core end-to-end scenarios. Not all project and resource types are supported in the new portal:

- **Foundry projects**: Supported at GA for defined core scenarios across model deployment, agent development, and operations. Some capabilities remain in preview, as shown in the [feature readiness table](#feature-readiness-at-ga).
- **Standalone Azure OpenAI resources**: Not supported in the new Foundry portal. Continue using Foundry (classic) portal, or upgrade to a Foundry project. For upgrade guidance, see [Upgrade Azure OpenAI to Microsoft Foundry](05-upgrade-azure-openai.md).
- **Hub-based projects (classic)**: Not supported in the new Foundry portal. For migration guidance, see [Migrate from hub-based to Foundry projects](https://learn.microsoft.com/en-us/azure/foundry-classic/how-to/migrate-project).

Confirm that your target regions support the models and features you need. For region details, see [Feature availability across cloud regions](../../06-models/06.2-quota-limits-and-region-availability/08-region-support.md).

For scenarios not yet available in the new Foundry portal, you can continue to use Foundry (classic) portal to maintain continuity while capabilities evolve.

## Core scenarios at GA

Core GA coverage includes:

- **Model core flows**: Discover models, deploy models, run inference, manage deployments, and transition to agent-based workflows.
- **Agent development**: Build agents and integrate evaluations, tracing, monitoring, red teaming, and fine-tuning where supported.
- **Operate experiences**: Manage agents and assets, enforce policies, and manage quota and administration features where supported.

## Feature readiness at GA

The following table summarizes feature readiness. Most core capabilities across Home, Discover, and Build are GA. Several Build and Operate capabilities remain in preview.

Statuses describe the named portal experience. Check each linked feature article for component-level and regional availability.

| Area | Feature | Status |
| --- | --- | --- |
| Home | All | GA |
| Discover | Overview | GA |
| Discover | Model | GA |
| Discover | [Instant Access Models](../../06-models/06.3-offers-deployment-types-and-pricing/02-instant-models.md) | Preview |
| Discover | [Model leaderboards](../../06-models/06.1-explore-foundry-models/05-model-benchmarks.md) | Preview |
| Discover | Tools | GA |
| Discover | [Solution Templates](../../04-get-started/04.1-what-do-you-want-to-build/07-ai-template-get-started.md) | GA |
| Discover | Search | GA |
| Discover | [Foundry Playgrounds](../../05-developer-tools-and-integrations/02-concept-playgrounds.md) — Model, Agents, and Images playgrounds | GA |
| Discover | Foundry Playgrounds — Video playground | Preview |
| Build | [Agents](../../07-agents/01-overview.md) (core) | GA |
| Build | Agents — Voice Live | Preview |
| Build | Agents — traces in agent builder | Preview |
| Build | [Publish agents to Microsoft Copilot and Teams](../../07-agents/07.5-publish-and-share/01-publish-copilot.md) | GA |
| Build | [Routines](../../07-agents/07.1-concepts/05-routines.md) | GA |
| Build | [Agent optimizer](../../11-optimization/01-agent-optimizer-overview.md) | Limited preview |
| Build | [Workflows](../../07-agents/07.1-concepts/06-workflow.md) | Preview. Foundry is retiring workflows on December 1, 2026. Use Microsoft Agent Framework for new development. |
| Build | [Models](../../06-models/01-foundry-models-overview.md) | GA (managed compute is a Preview deployment type; see [Managed compute in Microsoft Foundry](../../06-models/06.3-offers-deployment-types-and-pricing/03-managed-compute-overview.md)) |
| Build | [Tracing](../../09-observability/09.2-tracing/01-trace-agent-concept.md) (including Trace Replay) | GA for prompt and hosted agents; Preview for workflow and external agents. |
| Build | Tracing VNet | Preview |
| Build | [Convert traces to evaluation datasets](../../09-observability/09.2-tracing/08-traces-to-dataset.md) | Preview |
| Build | Optimization (cluster analysis) | Preview |
| Build | [Fine-tuning](../../06-models/06.8-fine-tuning/02-fine-tuning.md) | GA |
| Build | Tools | GA (check label on individual tools in the catalog to determine if they are GA or Preview) |
| Build | [Toolboxes](../../08-toolboxes/01-toolbox.md) | GA |
| Build | [Knowledge (Foundry IQ)](../../08-toolboxes/08.1-add-tools-and-skills/14-what-is-foundry-iq.md) | Partial GA (API-level GA; portal access remains Preview) |
| Build | Data (core) | GA |
| Build | Data — stored completions | Preview |
| Build | [Evaluations](../../10-evaluation/10.3-run-evaluations/12-evaluate-generative-ai-app.md) | GA (some evaluators and features are Preview; check individual evaluator labels) |
| Build | [Memory](../../08-toolboxes/08.1-add-tools-and-skills/38-what-is-memory.md) | Preview |
| Build | [Guardrails](../../12-trust-and-safety/12.1-guardrails-and-controls/01-guardrails-overview.md) — Models | GA |
| Build | [Guardrails](../../12-trust-and-safety/12.1-guardrails-and-controls/01-guardrails-overview.md) — Agents | Preview |
| Build | Guardrails — Controls and intervention | Preview |
| Build | [Monitoring](../../09-observability/01-observability.md) | Preview |
| Build | [Red teaming](../../12-trust-and-safety/12.1-guardrails-and-controls/16-red-teaming.md) | GA |
| Build | AI services speech playgrounds | GA |
| Operate | Overview | Preview |
| Operate | Assets | Preview |
| Operate | Compliance | Preview |
| Manage | [Quota](../../06-models/06.2-quota-limits-and-region-availability/02-quota.md) | GA |
| Manage | AI Gateway | Preview |
| Manage | Project and resource details | GA |
| Docs | All | GA |

## Unsupported at GA

The following items are out of scope at GA for the new Foundry portal and require the classic portal:

- Standalone Azure OpenAI or other single-service resources that aren't connected to a Foundry project.
- Assistant creation and authoring in the new Foundry portal.
- Listing AOAI evaluation files as datasets for upgrade workflows.
- Audio playground.
- AI service fine-tuning (for example, Speech or Vision custom model training). Model fine-tuning through Foundry projects is GA; see the [feature readiness table](#feature-readiness-at-ga).
- Content Understanding.
- Prebuilt prompts in video playground.
- Adding data directly from the Data tab (users can add data during agent creation workflows).

## FAQ

### What does general availability mean for Microsoft Foundry?

GA means the new Foundry portal is supported for production use for defined core scenarios in Foundry projects, with validated end-to-end experiences, enterprise support readiness, and operational reliability.

### Which projects are supported at GA?

At GA, the new Foundry portal supports Foundry projects with end-to-end coverage for core scenarios. Other resource types can continue in the Foundry (classic) portal where needed.

### Are all Foundry features GA?

No. GA covers validated core experiences and required enterprise features. Some capabilities remain in public preview.

### How do I disable preview features?

Use your organization controls to limit production environments to general availability supported capabilities, and validate current feature status before rollout decisions. For guidance on hiding preview features with tags or blocking them with custom RBAC roles, see [Disable preview features in Microsoft Foundry](../13.3-security-and-governance/04-disable-preview-features.md).

### What is the experience for existing Azure OpenAI users?

If you have existing Azure OpenAI resources, you can continue to use classic portal for unsupported workflows while you plan your upgrade to Foundry projects.

For upgrade guidance, see [Upgrade Azure OpenAI to Microsoft Foundry](05-upgrade-azure-openai.md).

For project migration guidance, see [Migrate from hub-based to Foundry projects (classic)](https://learn.microsoft.com/en-us/azure/foundry-classic/how-to/migrate-project).

### Are assistants supported in Foundry projects?

The new Foundry portal supports Agents v2. Existing assistants and v1 agents aren't supported in the new Foundry portal. To use or edit assistants, continue using Foundry (classic) portal until assistant upgrade is available.

### Can customers use Foundry GA through APIs and developer tools?

Yes. Foundry provides support across portal, APIs, SDKs, and CLI for GA-supported scenarios.

To get started, see [Microsoft Foundry SDKs](../../05-developer-tools-and-integrations/05.4-sdks-and-apis/01-sdk-overview.md) and [Microsoft Foundry API](https://ai.azure.com/api-reference/).

### Is GA the final state of Microsoft Foundry?

No. GA is a production milestone, not an endpoint. Microsoft continues to expand workflow authoring, operations, and governance capabilities based on customer feedback and production usage.

## Validate GA-only usage

Before production rollout, validate the following:

- Required scenarios in your workload map to capabilities marked **GA** in this article.
- Dependencies on **Preview** features are documented and approved for nonproduction use only.
- Role assignments and authentication model are aligned to your governance policy, especially where API keys are used.
- Target-region model and feature availability are confirmed in [Feature availability across cloud regions](../../06-models/06.2-quota-limits-and-region-availability/08-region-support.md).
- Teams supporting migration scenarios have a documented path between the new Foundry portal and Foundry (classic) portal workflows.

## Common rollout pitfalls

- Treating Preview features as production dependencies without explicit approval. Check the [feature readiness table](#feature-readiness-at-ga) for current status.
- Assuming API key authentication provides the same governance granularity as Entra ID with RBAC. See [Role-based access control for Microsoft Foundry](../13.3-security-and-governance/02-rbac-foundry.md) for proper configuration.
- Skipping region availability validation for required models and services. See [Feature availability across cloud regions](../../06-models/06.2-quota-limits-and-region-availability/08-region-support.md).
- Migrating assistants or AOAI workflows without a documented fallback path in Foundry (classic) portal. See [Migrate to the new Foundry Agent Service](../../07-agents/07.2-prompt-agents/12-migrate.md).
- Assuming all GA features work behind a virtual network. Some features, including Traces and Workflow Agents, don't yet fully support network isolation. For Hosted Agents, a private Azure Container Registry is supported only for Foundry projects created after June 25, 2026; projects created before that date require public access to the registry. If your workload requires private networking, review the feature limitations table in [How to configure network isolation for Microsoft Foundry](../13.3-security-and-governance/07-configure-private-link.md#foundry-feature-limitations).
- Building new production dependencies on Workflows. Foundry is retiring workflows on December 1, 2026. Use Microsoft Agent Framework for new development, and see the migration guide in [Build a workflow in Microsoft Foundry](../../07-agents/07.1-concepts/06-workflow.md#migration-guide) if you have existing workflows.

## Next steps

- [What is Microsoft Foundry?](../../01-what-is-microsoft-foundry/01-what-is-foundry.md)
- [Upgrade Azure OpenAI to Microsoft Foundry](05-upgrade-azure-openai.md)
- [Migrate from hub-based to Foundry projects](https://learn.microsoft.com/en-us/azure/foundry-classic/how-to/migrate-project)
- [Microsoft Foundry SDKs](../../05-developer-tools-and-integrations/05.4-sdks-and-apis/01-sdk-overview.md)
- [Microsoft Foundry rollout across my organization](02-planning.md)
- [Role-based access control for Microsoft Foundry](../13.3-security-and-governance/02-rbac-foundry.md)
- [How to configure network isolation for Microsoft Foundry](../13.3-security-and-governance/07-configure-private-link.md)
- [Feature availability across cloud regions](../../06-models/06.2-quota-limits-and-region-availability/08-region-support.md)
