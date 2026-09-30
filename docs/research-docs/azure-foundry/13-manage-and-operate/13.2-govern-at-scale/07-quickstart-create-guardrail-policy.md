# Quickstart: Create a guardrail policy

| Field | Value |
| --- | --- |
| **Document Title** | Quickstart: Create a guardrail policy |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.2-govern-at-scale/07-quickstart-create-guardrail-policy.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Quickstart: Create a guardrail policy". Learn how to create a guardrail policy for model deployments in Microsoft Foundry so that you can govern the usage of guardrail controls across your subscription. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/control-plane/quickstart-create-guardrail-policy). Article date: 2026-05-06. Page updated: 2026-07-13. Retrieved: 2026-09-29. Navigation: Manage and operate > Govern at scale > Govern models > Apply a guardrail policy for models.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

In this quickstart, you create a policy in Microsoft Foundry to govern the use of guardrail controls for model deployments across your subscription.

If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn) before you begin.

## Prerequisites

- An Azure account with an active subscription. If you don't have one, create a [free Azure account, which includes a free trial subscription](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- A Foundry project. If you don't have one, [create a project](../13.1-set-up-and-configure/07-create-projects.md).

- The [Owner](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#owner) or [Resource Policy Contributor](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#resource-policy-contributor) role at the subscription or resource group level. For more information, see the [overview of Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-policy-and-azure-rbac).

> **Note**
>
> This capability is available only in the [Microsoft Foundry (new) portal](../../01-what-is-microsoft-foundry/01-what-is-foundry.md).

## Create the guardrail policy

1. Sign in to [Microsoft Foundry](https://ai.azure.com/?cid=learnDocs). Make sure the **New Foundry** toggle is on. These steps refer to **Foundry (new)**.

   ![](https://learn.microsoft.com/en-us/azure/foundry/media/version-banner/new-foundry.png)
2. On the toolbar, select **Operate**.
3. On the left pane, select **Compliance**.
4. Select **Create policy**.

   [![Screenshot of the Compliance pane of Foundry Control Plane.](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/quickstart-create-a-guardrail-policy/compliance-tab.png)](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/quickstart-create-a-guardrail-policy/compliance-tab.png#lightbox)
5. Select the controls to add to the policy. Guardrail controls include content safety, prompt injection, and protected materials. These controls represent the minimum settings required for a model deployment to be considered compliant with the policy.

   As you configure each control, select **Add control** to add it to the policy.

   [![Screenshot of the area for adding controls.](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/quickstart-create-a-guardrail-policy/create-new-policy.png)](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/quickstart-create-a-guardrail-policy/create-new-policy.png#lightbox)
6. Select **Next** to move to scope selection. You can scope your policy to a single subscription or a resource group.

   Select a scope, select the subscription or resource group that you want the policy to apply to, and then choose **Select**.

   [![Screenshot of the area for selecting a scope.](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/quickstart-create-a-guardrail-policy/select-scope.png)](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/quickstart-create-a-guardrail-policy/select-scope.png#lightbox)
7. Select **Next** to add exceptions to the policy. The exception options depend on your scope selection:
   - If you scoped to a *subscription*, you can create exceptions for entire resource groups or individual model deployments within that subscription.
   - If you scoped to a *resource group*, you can create exceptions only for individual model deployments.

   [![Screenshot of the area for configuring exceptions.](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/quickstart-create-a-guardrail-policy/select-exception.png)](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/quickstart-create-a-guardrail-policy/select-exception.png#lightbox)
8. Select **Next** to move to the review stage. Enter a name for your policy and review the scope, exceptions, and controls. When you're ready, select **Submit** to create the policy.

   [![Screenshot of the area for reviewing and submitting a guardrail policy.](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/quickstart-create-a-guardrail-policy/submit-policy.png)](https://learn.microsoft.com/en-us/azure/foundry/control-plane/media/quickstart-create-a-guardrail-policy/submit-policy.png#lightbox)

## Verify your policy

After you submit your policy, verify that it was created successfully:

1. On the **Compliance** pane, select the **Policies** tab.
2. Locate your newly created policy in the policy list.
3. Check that the policy name, scope, and status are correct.

> **Note**
>
> It takes some time for Azure Policy to perform a compliance scan. Initial compliance results might not appear immediately after policy creation. After the scan completes, return to the **Compliance** pane to review compliance status for your model deployments.

## Clean up resources

If you no longer need the guardrail policy, you can delete it:

1. On the **Compliance** pane, select the **Policies** tab.
2. Select the policy that you want to remove.
3. Select **Delete policy**, and then confirm the deletion.

> **Note**
>
> Deleting a policy in the Foundry portal also removes the associated policy assignment in Azure Policy.

## Related content

- [Manage compliance and security in Microsoft Foundry](08-how-to-manage-compliance-security.md)
- [What is Microsoft Foundry Control Plane?](01-overview.md)
- [Enforce token limits for models](06-how-to-enforce-limits-models.md)
