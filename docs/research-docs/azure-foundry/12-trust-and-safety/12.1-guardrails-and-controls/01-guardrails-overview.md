# Guardrails and controls overview in Microsoft Foundry

| Field | Value |
| --- | --- |
| **Document Title** | Guardrails and controls overview in Microsoft Foundry |
| **Document Location** | `docs/research-docs/azure-foundry/12-trust-and-safety/12.1-guardrails-and-controls/01-guardrails-overview.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Guardrails and controls overview in Microsoft Foundry". Learn about safety and security guardrails that can be applied to models and agents in Microsoft Foundry, including risks, intervention points, and response actions. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/guardrails/guardrails-overview). Article date: 2026-07-31. Page updated: 2026-08-18. Retrieved: 2026-09-29. Navigation: Trust and safety > Guardrails and controls > Overview.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Microsoft Foundry provides safety and security guardrails that you can apply to core models and agents. Agent guardrails are in preview. Guardrails consist of a set of controls. The controls define a risk to be detected, intervention points to scan for the risk, and the response action to take in the model or agent when the risk is detected.

A **guardrail** is a named collection of **controls**. Variations in API configurations and application design might affect completions and thus filtering behavior.

Risks are flagged by classification models designed to detect harmful content. Four intervention points are supported:

- **User input** — The prompt sent to a model or agent.
- **Tool call** (Preview) — The action and data the agent proposes to send to a tool. Agents only.
- **Tool response** (Preview) — The content returned from a tool to the agent. Agents only.
- **Output** — The final completion returned to the user.

For more information about intervention points, see [Intervention points and controls](09-intervention-points.md).

In addition to content safety controls, hosted agents support **network egress controls (preview)**, which govern the outbound connections an agent makes so it reaches only the destinations you allow. You configure egress controls in the same guardrail (RAI policy) and they apply only to hosted agents. To learn how to author and apply egress rules, see [Add guardrails to a hosted agent](../../07-agents/07.3-hosted-agents/51-add-hosted-agent-guardrails.md#network-egress-controls-preview).

> **Note**
>
> Guardrails leverage classification models from [Azure AI Content Safety](https://azure.microsoft.com/products/cognitive-services/ai-content-safety) to detect harmful content across supported risk categories.

> **Important**
>
> The guardrail system applies to all [Foundry Models sold by Azure](../../06-models/06.1-explore-foundry-models/01-models-sold-directly-by-azure.md), except for prompts and completions processed by audio transcription models. For more information, see [Audio models](../../06-models/06.1-explore-foundry-models/01-models-sold-directly-by-azure.md#audio-models). The guardrail system currently applies only to agents developed in the [Foundry Agent Service](https://learn.microsoft.com/en-us/azure/ai-foundry/agents/overview), not to other agents registered in the Foundry Control Plane.

## Prerequisites

- An Azure subscription. [Create one for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- A [Microsoft Foundry project](../../13-manage-and-operate/13.1-set-up-and-configure/07-create-projects.md).
- At least one model deployment in your project.
- Foundry Account Owner role.

  > **Important**
  >
  > The Foundry RBAC roles were recently renamed. **Foundry User**, **Foundry Owner**, **Foundry Account Owner**, and **Foundry Project Manager** were previously named Azure AI User, Azure AI Owner, Azure AI Account Owner, and Azure AI Project Manager. You might still see the previous names in some places while the rename rolls out. The role IDs and core permissions are unchanged by the rename.
  - Access to a role that allows you to create a Foundry resource, such as **Foundry Account Owner** or **Foundry Owner** on the subscription or resource group. For more information about permissions, see [Role-based access control for Microsoft Foundry](../../13-manage-and-operate/13.3-security-and-governance/02-rbac-foundry.md#permissions-for-each-built-in-role).

    > **Important**
    >
    > The Foundry RBAC roles were recently renamed. **Foundry User**, **Foundry Owner**, **Foundry Account Owner**, and **Foundry Project Manager** were previously named Azure AI User, Azure AI Owner, Azure AI Account Owner, and Azure AI Project Manager. You might still see the previous names in some places while the rename rolls out. The role IDs and core permissions are unchanged by the rename.

## Guardrails for agents vs models

An individual Foundry guardrail can be applied to one or many models and one or many agents in a project. Some controls within a guardrail may not be relevant to models because the risk, intervention point, or action is specific to agentic behavior or tool calls. Those controls aren't run on models using that guardrail.

Some risks in Preview aren't yet supported for agents. When controls involving those risks are added to a guardrail and the guardrail is applied to an agent, those controls don't take effect for that agent. They still apply to models that use the same guardrail.

### Risk applicability

The following table summarizes which risks are applicable to models and agents:

| Risk | Applicable to Models | Applicable to Agents (Preview) |
| --- | --- | --- |
| [Hate](03-content-filter-severity-levels.md#harm-category-descriptions) | ✅ | ✅ |
| [Sexual](03-content-filter-severity-levels.md#harm-category-descriptions) | ✅ | ✅ |
| [Self-harm](03-content-filter-severity-levels.md#harm-category-descriptions) | ✅ | ✅ |
| [Violence](03-content-filter-severity-levels.md#harm-category-descriptions) | ✅ | ✅ |
| [User prompt attacks](04-content-filter-prompt-shields.md#examples-1) | ✅ | ✅ |
| [Indirect attacks](04-content-filter-prompt-shields.md#examples-1) | ✅ | ✅ |
| [Spotlighting (Preview)](04-content-filter-prompt-shields.md#spotlighting-preview) | ✅ | ❌ |
| [Protected material for code](https://learn.microsoft.com/en-us/azure/ai-services/content-safety/quickstart-protected-material-code?pivots=programming-language-foundry-portal) | ✅ | ✅ |
| [Protected material for text](08-content-filter-protected-material.md) | ✅ | ✅ |
| [Groundedness (Preview)](06-content-filter-groundedness.md) | ✅ | ❌ |
| [Personally identifiable information (Preview)](05-content-filter-personal-information.md) | ✅ | ✅ |
| [Task Adherence (Preview)](07-task-adherence.md) | ✅ | ✅ |

### Severity levels

For content risks (Hate, Sexual, Self-harm, Violence), each control uses a severity level threshold that determines which content is flagged:

| Severity level | Behavior |
| --- | --- |
| **Off** | Detection is disabled for this risk. Only available for approved customers, see [content filters](https://learn.microsoft.com/en-us/azure/foundry-classic/foundry-models/how-to/configure-content-filters) |
| **Low** | Flags content at low severity and above. Least restrictive. |
| **Medium** | Flags content at medium severity and above. |
| **High** | Flags only the most severe content. Most restrictive. |

For a detailed breakdown of what each severity level detects, see [Content filtering categories](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/content-filter?tabs=warning%2Cpython-new#risk-categories).

For Models sold by Azure, only customers who have been approved for modified Guardrails can turn them off. Apply for modified Guardrails via this form: [Limited Access Review: Modified Guardrails](https://ncv.microsoft.com/uEfCgnITdR). For Azure Government customers, apply for modified Guardrails via this form: [Azure Government - Request Modified Content Filtering](https://aka.ms/AOAIGovModifyContentFilter).

### Intervention point applicability

The following table summarizes which intervention points are applicable to models and agents:

| Intervention Point | Applicable to Models | Applicable to Agents (Preview) |
| --- | --- | --- |
| User input | ✅ | ✅ |
| Tool call | ❌ | ✅ (Preview) |
| Tool response | ❌ | ✅ (Preview) |
| Output | ✅ | ✅ |

> **Important**
>
> Risks are detected in an agent based on the guardrail it's assigned, not the guardrail of its underlying model. The agentic guardrail fully overrides the model's guardrail.

#### Example: Guardrail override behavior

Consider this scenario:

- A model deployment has a control with Violence detection set to **High** for user input and output
- An agent using that model has a control with Violence detection set to **Low** for user input and output. The agent has no controls for Violence detection at all for tool calls and responses

### Action applicability

When a control detects a risk, it can take one of two actions. The following table summarizes which actions are applicable to models and agents:

| Action | Applicable to Models | Applicable to Agents (Preview) |
| --- | --- | --- |
| Annotate | ✅ | ❌ |
| Annotate and block | ✅ | ✅ |

### Guardrail inheritance and override

> **Important**
>
> Risks are detected in an agent based on the guardrail it's assigned, not the guardrail of its underlying model. The agentic guardrail fully overrides the model's guardrail.

**Example scenario:**

- A model deployment has a control with Violence detection set to **High** for user input and output
- An agent using that model has a control with Violence detection set to **Low** for user input and output. The agent has no controls for Violence detection at all for tool calls and responses|

**Expected behavior for Violence detection in that agent:**

Given the configuration above, here's how Violence detection works at each stage:

- User queries to the agent are scanned for Violence at a **Low** level
- Tool calls generated internally to the agent by its underlying model, including the content then sent to that tool during the tool call's execution, will **not** be scanned for Violence
- The response back from the tool will **not** be scanned for Violence
- The final output returned to the user in response to their original query are scanned for Violence at a **Low** level

## Default guardrails

By default, models are assigned the **Microsoft.DefaultV2** guardrail. For more information about what controls are included, see [Content filtering](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/content-filter?tabs=warning%2Cpython-new).

Default guardrail assignment for agents follows these rules:

- If you assign a custom guardrail to an agent, that guardrail is used.
- If no custom guardrail is assigned, the agent inherits the guardrail of its underlying model deployment.
- An agent only uses the **Microsoft.DefaultV2** guardrail if its model deployment uses that guardrail, or if you explicitly assign it.

> **Note**
>
> For example, if no custom guardrails are specified for an agent and that agent uses a GPT-4o mini deployment with a guardrail named "MyCustomGuardrails," the agent also uses "MyCustomGuardrails" until you assign a different guardrail.

## Troubleshooting

### Guardrail not applying to agent

**Symptom:** Agent behavior doesn't match assigned guardrail configuration.

**Causes:**

- Guardrail contains controls with preview risks not yet supported for agents (Spotlighting, Groundedness)
- Agent using model's guardrail instead of assigned guardrail

**Solution:**

- Verify assigned guardrail using Azure AI Foundry portal or SDK
- Check that guardrail controls don't rely on agent-unsupported risks
- Explicitly assign guardrail to agent to override model defaults

### Content flagged unexpectedly

**Symptom:** Legitimate content blocked by guardrail.

**Causes:**

- Severity level set too restrictively (High blocking)
- Classification model detected edge-case pattern

**Solution:**

- Review severity level settings for affected risk category
- Test with different severity levels to find appropriate threshold
- For persistent false positives, contact Azure Support to review classification

### Tool calls not being scanned

**Symptom:** Harmful content passes through tool calls/responses.

**Causes:**

- Tool call and tool response intervention points not configured in guardrail
- Using preview features that may not be fully enabled

**Solution:**

- Verify guardrail includes controls for tool call and tool response intervention points
- Ensure Foundry Agent Service preview features are enabled for your project

## Next steps

- [Configure guardrails and controls](02-how-to-create-guardrails.md)
- [Learn about intervention points and controls](09-intervention-points.md)
- [Understand content filtering in Azure OpenAI](https://learn.microsoft.com/en-us/azure/foundry-classic/foundry-models/concepts/content-filter)
- [Configure content filters for Azure OpenAI](https://learn.microsoft.com/en-us/azure/foundry-classic/openai/how-to/content-filters)
