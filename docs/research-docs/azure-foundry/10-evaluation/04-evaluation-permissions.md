# Set up permissions for Microsoft Foundry evaluation workflows

| Field | Value |
| --- | --- |
| **Document Title** | Set up permissions for Microsoft Foundry evaluation workflows |
| **Document Location** | `docs/research-docs/azure-foundry/10-evaluation/04-evaluation-permissions.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Set up permissions for Microsoft Foundry evaluation workflows". Find and assign the Azure roles required to run evaluations, evaluate traces, use your own storage, and set up scheduled or continuous evaluation in Microsoft Foundry. |
| **Version** | 1.0 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/observability/how-to/evaluation-permissions). Index: 10.1. Article date: 2026-09-29. Page updated: 2026-09-30. Last synced: 2026-09-30T07:28:53Z. Navigation: Evaluation > Permissions for evaluation workflows.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Use this article to find the roles required for your Microsoft Foundry evaluation workflow. You don't need every role listed here. Start with the common evaluation role, and then add roles only if your workflow uses scheduled or continuous evaluation, traces, or your own storage account.

> **Tip**
>
> For most portal and SDK evaluation workflows, your signed-in account needs the **Foundry User** role on the Foundry project. The extra roles in this article apply to specific workflows and resources.

> **Important**
>
> The Foundry RBAC roles were recently renamed. **Foundry User**, **Foundry Owner**, **Foundry Account Owner**, and **Foundry Project Manager** were previously named Azure AI User, Azure AI Owner, Azure AI Account Owner, and Azure AI Project Manager. You might still see the previous names in some places while the rename rolls out. The role IDs and core permissions are unchanged by the rename.

## Before you begin

To [assign Azure roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal), you need `Microsoft.Authorization/roleAssignments/write` permission at the target scope. For example, the **Role Based Access Control Administrator** and **User Access Administrator** roles include this permission. If you can't create role assignments, send the relevant rows from this article to your administrator.

Evaluation workflows can use more than one identity:

- **Your identity** is the account that you use to sign in to the Foundry portal, Azure Developer CLI, or SDK.
- **An application identity** is the workload identity or service principal that runs evaluations in an application or CI/CD pipeline.
- **The project managed identity** is the identity that Foundry uses to access connected resources, such as traces or storage.

## Find the roles for your workflow

First, assign the role in this table for the evaluation task you want to perform.

| I want to | Assign the role to | Role | Assign at |
| --- | --- | --- | --- |
| Create continuous or scheduled evaluation rules | The project managed identity | **Foundry User** | The Foundry resource or project used for the evaluation rule |
| Run or review portal or SDK evaluations, including agent, synthetic dataset, admin-connected model, and benchmark workflows | Your identity or application identity | **Foundry User**, or a role with equivalent permissions | The Foundry resource or project that contains the evaluation |
| Run evaluations in CI/CD | The workload identity or service principal used by the pipeline | **Foundry User**, or a role with equivalent permissions | The Foundry resource or project that contains the evaluation |
| Run agent evaluations with the Azure Developer CLI | Your identity | **Foundry User** | The Foundry resource |

Evaluation jobs use Microsoft Entra ID. If an evaluation invokes a model deployment, assign **Foundry User** at the Foundry account scope. A project-only role assignment doesn't authorize model inference. For more information, see [Deployment type-specific permissions](../13-manage-and-operate/13.3-security-and-governance/02-rbac-foundry.md#deployment-typespecific-permissions).

For the permissions included in Foundry roles and guidance for custom roles, see [Role-based access control for Microsoft Foundry](../13-manage-and-operate/13.3-security-and-governance/02-rbac-foundry.md).

## Add permissions for trace-based workflows

Use this section if you run one-time, continuous, or scheduled evaluations over Application Insights traces, create a dataset from traces, or view log-based monitoring data.

The identity that submits a trace evaluation or trace-based dataset job first needs the **Foundry User** role from [Find the roles for your workflow](#find-the-roles-for-your-workflow). Then assign the following roles:

| I want to | Assign the role to | Role | Assign at |
| --- | --- | --- | --- |
| Run trace evaluations or create datasets from traces | The project managed identity | **Reader** | The connected Application Insights resource |
| Read protected trace tables during evaluation or dataset generation | The project managed identity | **Privileged Monitoring Data Reader**, in addition to **Reader** | The connected Application Insights resource |
| View traces or log-based monitoring data | Your identity | **Log Analytics Reader** | The connected Application Insights resource and, for workspace-scoped queries, its linked Log Analytics workspace |
| View protected trace content | Your identity | **Privileged Monitoring Data Reader**, in addition to **Log Analytics Reader** | The Application Insights resource for resource-scoped queries or the Log Analytics workspace for workspace-scoped queries |

Trace evaluation and dataset generation use a resource-context query against the connected Application Insights resource. The [Reader role](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/general#reader) provides the resource read permission required for this query.

If the linked Log Analytics workspace is configured to [**Require workspace permissions**](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#access-control-mode), also assign **Log Analytics Reader** to the project managed identity on that workspace. For protected tables, assign **Privileged Monitoring Data Reader** on the workspace too. If the workspace uses [DataActionsOnly mode](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access#dataactionsonly-mode), use **Log Analytics Data Reader** instead of a control-plane reader role.

For information about protected trace content, see [Protect sensitive content in traces](../09-observability/09.2-tracing/10-traces-sensitive-content.md).

## Add permissions for your own storage account

Use this section only if your Foundry project connects to your own Azure Storage account by using Microsoft Entra ID authentication.

| Assign the role to | Role | Assign at |
| --- | --- | --- |
| The project managed identity | **Storage Blob Data Contributor** | The storage account connected to the Foundry project |

This role lets the evaluation service read and write datasets and evaluation results in blob storage. If the connection uses an account key instead, this managed-identity role isn't used. Microsoft recommends Microsoft Entra ID authentication for granular access control.

For storage and network requirements, see [Bring your own storage](01-evaluation-regions-limits-virtual-network.md#bring-your-own-storage).

## Verify your setup

After you assign the roles:

1. In the Azure portal, open each resource where you assigned a role.
2. Select **Access control (IAM)** > **Check access**.
3. Search for the user, application identity, or project managed identity.
4. Confirm that the expected role appears at the required scope.
5. Wait several minutes for new role assignments to take effect, and then retry the workflow.

If an evaluation still fails with `401 Unauthorized` or `403 Forbidden`, see [Troubleshoot evaluation and observability issues](../09-observability/02-troubleshooting.md).

## Next steps

- To run an evaluation with an SDK, see [Introduction to cloud evaluation](10.3-run-evaluations/02-cloud-evaluation.md).
- To evaluate an agent, see [Evaluate your AI agents](10.3-run-evaluations/01-evaluate-agent.md).
- To evaluate production telemetry, see [Evaluate model and agent traces](10.3-run-evaluations/05-cloud-evaluation-deployed-interactions.md).
- To create reusable evaluation data from production traffic, see [Convert agent traces into evaluation datasets](../09-observability/09.2-tracing/08-traces-to-dataset.md).
- To evaluate production traffic on a schedule, see [Monitor agents and set up continuous evaluation](../07-agents/07.3-hosted-agents/33-how-to-monitor-agents-dashboard.md).
