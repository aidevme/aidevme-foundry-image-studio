# Manage compliance and security in Microsoft Foundry

| Field | Value |
| --- | --- |
| **Document Title** | Manage compliance and security in Microsoft Foundry |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.2-govern-at-scale/08-how-to-manage-compliance-security.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Manage compliance and security in Microsoft Foundry". Discover how to manage compliance and secure your Microsoft Foundry assets by using guardrail policies, Microsoft Defender for Cloud, and Microsoft Purview DSPM. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/control-plane/how-to-manage-compliance-security). Article date: 2026-05-15. Page updated: 2026-08-04. Retrieved: 2026-09-29. Navigation: Manage and operate > Govern at scale > Manage compliance and security.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Learn how Microsoft Foundry Control Plane helps you manage compliance, enforce guardrail controls, and integrate security tooling such as Microsoft Defender for Cloud across subscriptions.

Use the compliance workspace tabs to reach the right surface quickly.

| Tab | Navigation | Outcome |
| --- | --- | --- |
| **Policies** | **Operate** > **Compliance** > **Policies** | Review guardrail policies, check compliance, and create or edit enforcement rules. |
| **Assets** | **Operate** > **Compliance** > **Assets** | Inspect individual model deployments, view policy violations, and jump to remediation. |
| **Guardrails** | **Operate** > **Compliance** > **Guardrails** | Compare guardrail configurations across deployments and spot coverage gaps. |
| **Security posture** | **Operate** > **Compliance** > **Security posture** | Review Defender for Cloud recommendations and manage Microsoft Purview enablement. |

## Prerequisites

- An Azure account with an active subscription. If you don't have one, create a [free Azure account, which includes a free trial subscription](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- A Foundry project. If you don't have one, [create a project](../13.1-set-up-and-configure/07-create-projects.md).

- Any agents that you want to use. Be sure to use the latest agent versions for full support of compliance features.
- Appropriate permissions based on the tasks that you want to perform:
  - **To view compliance status and guardrail policies**: No special permissions are required beyond project access.
  - **To create or edit guardrail policies**: You must be an [Owner](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#owner) or [Resource Policy Contributor](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#resource-policy-contributor) at the Azure subscription or resource group level. See the [overview of Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-policy-and-azure-rbac).
  - **To enable Defender for Cloud**: You need the Security Admin role or the Owner role for a subscription so that you can turn on Defender plans and agentless protections.
  - **To configure Microsoft Purview integration**: You need the Foundry Account Owner role.

    > **Important**
    >
    > The Foundry RBAC roles were recently renamed. **Foundry User**, **Foundry Owner**, **Foundry Account Owner**, and **Foundry Project Manager** were previously named Azure AI User, Azure AI Owner, Azure AI Account Owner, and Azure AI Project Manager. You might still see the previous names in some places while the rename rolls out. The role IDs and core permissions are unchanged by the rename.

> **Note**
>
> This capability is available only in the Foundry (new) portal. Look for ![](https://learn.microsoft.com/en-us/azure/foundry/media/version-banner/new-foundry.png) in the portal banner to confirm you're using Foundry (new).

## AI risks and defense-in-depth overview

Building AI workloads introduces unique security challenges. Key risks include:

- **Prompt injection**: Malicious inputs crafted to manipulate model behavior or bypass safety controls.
- **Sensitive data leakage**: Models inadvertently exposing confidential information in responses.
- **Model misuse**: Unauthorized or abusive use of AI capabilities that violates organizational policies.

Microsoft Foundry, Defender for Cloud, and Microsoft Purview address these risks in combination:

- **Foundry guardrails**: Content filters, prompt shields, and abuse detection protect managed inference endpoints at the model layer.
- **Defender for Cloud**: Security posture recommendations identify misconfigurations, and threat protection for Foundry Tools detects jailbreak and user input attacks.
- **Microsoft Purview**: Auditing, sensitive information type (SIT) classification, and Data Security Posture Management (DSPM) for AI provide visibility and governance over prompt and response data.

> **Note**
>
> Microsoft Purview Data Security Policies require Microsoft Entra ID user-context tokens to attach policies to user interactions.

## Create, review, and manage guardrail policies

You can use guardrail policies to mandate minimum guardrail controls for your model deployments across a subscription or within a resource group. Guardrail controls include content filtering, abuse monitoring, and other safety measures that help protect your model deployments from generating harmful content or being misused.

To learn more about guardrail policies, see [Guardrails and controls overview in Microsoft Foundry](../../12-trust-and-safety/12.1-guardrails-and-controls/01-guardrails-overview.md).

Most users don't have permission to create guardrail policies because they need the appropriate Azure role-based access control (RBAC) roles for Azure Policy. See the [overview of Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-policy-and-azure-rbac). Most users in Foundry can still view the compliance status of individual guardrail policies and model deployments.

> **Tip**
>
> Access the compliance workspace by selecting **Operate** on the toolbar, and then selecting **Compliance** on the left pane. Use the subscription and project filters to scope your view before you switch tabs.

### View and fix compliance violations

Determine whether any model deployments don't comply with organizational guardrail policies. To assess compliance status and address issues, follow these steps:

1. Select the **Policies** tab. Review all applicable guardrail policies within your subscription and project.

   To expand the scope beyond a single project, adjust the project filter to **All projects** for an overview of the entire subscription. You can also switch subscriptions.
2. Identify any noncompliant guardrail policy by locating policies that have a **Violations detected** value in the **Policy Compliance** column.
3. Select a guardrail policy. On the information pane that appears, select an asset to compare its guardrail settings with the requirements that the guardrail policy specifies.
4. To update the guardrail configuration of a noncompliant asset, select **Fix now**. This selection opens the model deployment's guardrail configuration pane, where you can adjust settings to meet the guardrail policy requirements.

   After you save your changes, the compliance status is updated within a few minutes.

You can also review compliance status by asset rather than by guardrail policy:

1. Select the **Assets** tab by using the **Policy/Assets** toggle.
2. Review model deployments within the chosen subscription and project.
3. Examine any assets marked as **Violations detected** in the **Policy Compliance** column. Select these rows to access further details. Assets might appear multiple times if they're subject to several guardrail policies.
4. On the information pane, review the governing guardrail policies and the specifics of any noncompliant guardrail policy.
5. Select **View in Build** to modify the guardrail configuration and bring the model deployment into compliance. Review all relevant guardrail policies for each asset to ensure that you make all necessary adjustments to achieve full compliance.

### Create a guardrail policy

1. In the compliance workspace, select **Create new policy**.
2. Choose and configure controls, such as content filters, prompt shields, or abuse detection. Select **Add control** after you configure each control.
3. Select **Next** to set the policy scope. The scope determines which resources the policy applies to. Choose a subscription to apply the policy broadly, or choose a specific resource group for targeted governance.
4. Select **Next** to add exceptions for model deployments or, if the policy is scoped to a subscription, resource groups. You can exclude specific model deployments or resource groups from the policy requirements. Use exceptions for testing environments or legacy deployments that can't meet new requirements.
5. Select **Next** when you finish adding exceptions.
6. Enter a descriptive policy name. This name appears in the compliance dashboard.
7. Select **Create** to finalize your guardrail policy.
8. Allow up to 30 minutes for the guardrail policy to appear in the Foundry portal. Compliance results appear after Azure Policy completes its scan. The duration of the scan varies by scope size and resources.

After you create the guardrail policy, it's listed on the **Policies** tab. The compliance status is updated automatically as Azure Policy evaluates your resources.

### Edit a guardrail policy

1. In the compliance workspace, select the **Policies** tab. Locate and select the guardrail policy that you want to edit.
2. On the pane that shows guardrail policy details, select **Edit policy**.
3. Modify the controls, scope, or exceptions as needed.
4. Select **Save** to apply your changes.
5. Wait up to 30 minutes for the updated guardrail policy to take effect. Compliance results are updated after Azure Policy reevaluates your resources.

## Review guardrails across your subscription

When you monitor your model deployments for compliance, review and compare the guardrail controls for your assets throughout a project or subscription. Even if the controls aren't directly linked to guardrail policy compliance, this process helps you spot gaps in guardrail policy assignments, like missing controls. You can also uncover potential risks that might go unnoticed, such as subscriptions that lack content filtering entirely.

To review guardrails across your subscription:

1. In the compliance workspace, select the **Guardrails** tab.
2. Check that your scope is correct by reviewing and adjusting the subscription and project dropdown lists as needed.
3. Examine the configurations across your projects by using column sorting to quickly find problems. For example, you can see which filters are disabled.
4. If you find a problem, choose one of these options:
   - Update individual deployments:
     1. On the toolbar, select **Build**.
     2. In the relevant project, select **Guardrails**.
     3. Update existing guardrail settings or add new ones for your model deployments.
   - Create a guardrail policy for enforcement:
     1. In the compliance workspace, select the **Policies** tab.
     2. Create a new guardrail policy to enforce guardrail requirements across all deployments.

## Set up security recommendations and alerts

Defender for Cloud provides security posture gaps and recommendations for remediation. Your security posture represents the overall security status of your Azure resources, including potential vulnerabilities, misconfigurations, and recommended improvements. Defender assesses your resources and workloads against built-in and custom security standards.

To get security posture recommendations from Defender for Cloud, [enable it on your Azure subscription](https://learn.microsoft.com/en-us/azure/defender-for-cloud/connect-azure-subscription). To get threat protection alerts for jailbreak attacks based on risk detection in Foundry for user input attacks, [enable threat protection for Foundry Tools](https://learn.microsoft.com/en-us/azure/defender-for-cloud/ai-onboarding). Jailbreak attacks attempt to bypass AI safety measures by using carefully crafted prompts. Foundry detects these attack patterns in user input.

Recommendations and alerts cover AI workloads built on Foundry's managed inference endpoints. Detections for jailbreak and prompt attacks appear as Defender alerts and can be correlated with Microsoft Purview Audit records of AI interactions to support investigation and governance.

To review Defender security recommendations, follow these steps:

1. In the compliance workspace, select the **Security posture** tab.
2. [Enable Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/connect-azure-subscription) for your subscription if you need to do so.
3. View recommendations in the **Microsoft Defender for Cloud** section, including the affected resource and the associated risk level. Recommendations might include enabling more security features, fixing misconfigurations, or addressing potential vulnerabilities in your AI deployments.
4. Select a recommendation to view details, and select links to take remediation action in the Azure portal.

## Enable enterprise-grade data security and compliance for Foundry with Microsoft Purview

When a Foundry admin enables Microsoft Purview on their Azure subscription, AI interaction data from all applications and agents in that subscription flows into Microsoft Purview for centralized compliance, governance, and AI data posture management. This integration supports key data security and compliance scenarios, such as:

- Microsoft Purview Audit
- Sensitive information type (SIT) classification
- Analytics and reporting through Microsoft Purview Data Security Posture Management (DSPM) for AI
- Microsoft Purview Insider Risk Management
- Microsoft Purview Communication Compliance
- Microsoft Purview Data Lifecycle Management
- Microsoft Purview eDiscovery

This capability helps your organization manage and monitor AI-generated data in alignment with enterprise policies and regulatory requirements. Keep these considerations in mind:

- Microsoft Purview Data Security Policies apply to interactions that use Microsoft Entra ID user-context authentication against Foundry's managed inference endpoint (`/chat/completions`). To learn more, see [AzureUserSecurityContext](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/azureopenai/chat?view=rest-microsoft-foundry-v1&preserve-view=true).
- For all other authentication scenarios, user interactions are visible in Microsoft Purview Audit and DSPM for AI activity explorer classifications, but aren't enforced by data security policies.
- Microsoft Purview Audit is included as part of the Microsoft Purview license for Foundry services. For setup of data security policies in Microsoft Purview by your enterprise security admins, billing is based on [pay-as-you-go](https://azure.microsoft.com/pricing/details/purview/) meters or an Agent 365 subscription. If pay-as-you-go billing isn't set up and the tenant doesn't have an Agent 365 subscription, only Purview Audit is supported. Learn more about [Microsoft Purview](https://learn.microsoft.com/en-us/Office365/ServiceDescriptions/microsoft-365-service-descriptions/microsoft-365-tenantlevel-services-licensing-guidance/microsoft-purview-service-description#microsoft-purview-for-agentic-workloads).
- Integration with Microsoft Purview for the preceding features in Foundry doesn't yet support network isolation.

This feature requires a Microsoft Purview license in the tenant. To learn about Microsoft Purview, see [Microsoft Purview data security and compliance protections for generative AI apps](https://learn.microsoft.com/en-us/purview/ai-microsoft-purview).

### Enable Microsoft Purview in Foundry

To enable Microsoft Purview, you need the **Azure AI Account Owner** role.

When you turn on the integration, interaction data from Foundry applications and agents is sent to your tenant's Microsoft Purview account, and data security policies that your tenant's security admins create in Purview are enforced in Foundry. This integration lets your organization:

- Monitor sensitive data flowing through AI agents.
- Detect risky user interactions and insider threats.
- Enforce Data Loss Prevention (DLP) policies and compliance standards.

To enable Microsoft Purview in Foundry:

1. On the toolbar, select **Operate**.
2. On the left pane, select **Compliance**.
3. Select the **Data security and governance** tab.
4. At the top of the tab, use the subscription dropdown to select the Azure subscription.
5. Turn on the **Powered by Microsoft Purview** toggle.
6. Select the **Data security and governance** tab.

> **Note**
>
> The toggle takes effect only if Microsoft Purview is present in the tenant. Billing happens in Purview and is based on pay-as-you-go (PAYG) meters and the policies created in Purview. If PAYG billing isn't set up in Purview, only Microsoft Purview Audit integration is supported.

Repeat the preceding steps for other Azure subscriptions, as appropriate. For more information, select **About Microsoft Purview** on the tab, or **Go to Microsoft Purview** to open the Microsoft Purview portal.

## Related content

- [Elevated-role tasks in Microsoft Foundry](../13.3-security-and-governance/03-administrator-guide.md#manage-compliance-and-monitoring) — role requirements for compliance and monitoring tasks.
- [What is Azure Policy?](https://learn.microsoft.com/en-us/azure/governance/policy/overview)
- [Microsoft Defender for Cloud documentation](https://learn.microsoft.com/en-us/azure/defender-for-cloud/)
