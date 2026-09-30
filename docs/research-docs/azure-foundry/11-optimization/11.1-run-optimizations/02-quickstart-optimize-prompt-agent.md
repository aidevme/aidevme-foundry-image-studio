# Quickstart: Optimize a prompt agent (preview)

| Field | Value |
| --- | --- |
| **Document Title** | Quickstart: Optimize a prompt agent (preview) |
| **Document Location** | `docs/research-docs/azure-foundry/11-optimization/11.1-run-optimizations/02-quickstart-optimize-prompt-agent.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Quickstart: Optimize a prompt agent (preview)". Optimize a prompt agent's instructions, function-calling tool descriptions, and model selection in the Foundry portal. |
| **Version** | 1.2 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/quickstarts/quickstart-optimize-prompt-agent). Article date: 2026-08-07. Page updated: 2026-08-19. Retrieved: 2026-09-29. Navigation: Agents > Prompt agents > Text-based agents > Build > Optimize a prompt agent.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

> **Important**
>
> Agent Optimizer is currently in preview. This preview is provided without a service-level agreement, and we don't recommend it for production workloads. Certain features might not be supported or might have constrained capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

In this quickstart, use the optimization wizard in the Foundry portal to improve a prompt agent's instructions, function-calling tool descriptions, and model selection. Select an agent version, dataset, and evaluators, run the optimizer, and compare the generated candidates with the baseline.

If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

## Prerequisites

Before you begin, you need:

- A Microsoft Foundry project with a deployed prompt agent. To create one, see [Quickstart: Create a prompt agent](../../04-get-started/04.1-what-do-you-want-to-build/01-prompt-agent.md).
- An evaluation model and a supported optimization model deployed in the project. For supported models, see [Models](../01-agent-optimizer-overview.md#models).
- A dataset source: agent traces, an evaluation dataset registered in the project, or a JSONL dataset to upload. The dataset must use the column names required by the selected evaluators because the wizard doesn't support column mapping.

## Open the optimization wizard

[![Screenshot of the Optimize tab for a prompt agent, with the Create optimization run button highlighted.](https://learn.microsoft.com/en-us/azure/foundry/agents/media/quickstart/optimize-prompt-entry.png)](https://learn.microsoft.com/en-us/azure/foundry/agents/media/quickstart/optimize-prompt-entry.png#lightbox)

1. Go to the [Foundry portal](https://ai.azure.com/) and open your project.
2. Select **Agents**, and then select the prompt agent you want to optimize.
3. Select the **Optimize** tab.
4. Select **Create optimization run**.

## Select the optimization target

The target defines the prompt-agent version and candidate models to evaluate.

[![Screenshot of the Target step with controls for the agent version, optimization model, maximum candidates, evaluation model, and model comparison.](https://learn.microsoft.com/en-us/azure/foundry/agents/media/quickstart/optimize-prompt-target.png)](https://learn.microsoft.com/en-us/azure/foundry/agents/media/quickstart/optimize-prompt-target.png#lightbox)

1. In the **Target** step, select the agent version to use as the baseline. The latest version is selected by default.
2. Select the optimization model, maximum number of candidates, and evaluation model.
3. To evaluate candidates across multiple model deployments, turn on **Compare across models**, and then select the models to include.
4. Continue to the **Dataset** step.

The optimizer can generate candidates that improve the agent's instructions, function-calling tool descriptions, or model selection. Other tool types aren't supported for tool-description optimization.

> **Important**
>
> A prompt agent's function-calling tools execute on the client side. The optimizer can improve the tool and parameter descriptions that guide function calls, but it can't execute or evaluate the tools during tool-description optimization.

## Select an evaluation dataset

The optimizer uses the same dataset to score the baseline and each generated candidate.

1. In the **Dataset** step, choose one of these options:
   - Generate a dataset from agent traces.
   - Select an existing dataset registered in the project.
   - Upload a new dataset from your device.
2. Preview the dataset and confirm that it contains the columns required by your evaluators.
3. Continue to the **Criteria** step.

Use representative tasks, including common requests, edge cases, and behaviors you want the optimizer to preserve or improve.

## Select evaluation criteria

Evaluators define how the optimizer scores each response.

1. In the **Criteria** step, select one or more evaluators:
   - Select built-in evaluators and configure any required parameters.
   - Select an existing custom evaluator.
   - Create a custom rubric evaluator, and then select it.
2. Confirm that each evaluator is compatible with the dataset schema.
3. Continue to the **Review** step.

## Review and submit the run

[![Screenshot of the Review step summarizing the optimization target, dataset, criteria, and Submit button.](https://learn.microsoft.com/en-us/azure/foundry/agents/media/quickstart/optimize-prompt-submit.png)](https://learn.microsoft.com/en-us/azure/foundry/agents/media/quickstart/optimize-prompt-submit.png#lightbox)

1. On the **Review** step, verify the agent and version, dataset, evaluators, evaluator configurations, and candidate models.

   > **Note**
   >
   > The estimated cost is a modeled range, not a spending limit or final charge. Review the calculation inputs, pricing assumptions, and exclusions before you submit the job. For details, see [Agent optimizer cost estimates and token usage](../02-agent-optimizer-costs.md).

   The summary shows **Minimum**, **Estimated**, and **Maximum** values. Expand **Cost breakdown (estimated)** to review the estimated calls and cost for **Running your agent**, **Scoring responses**, and **Generating improvements**.
2. Select **Submit**.
3. Wait for the optimization run to finish. The run appears in the **Optimization runs** list with its current status.

Run time depends on the dataset size, number of candidates, and selected models.

## Compare the results

1. When the run succeeds, select it under **Optimization runs**.
2. Compare each candidate's score with the baseline score.
3. Review the before-and-after instruction changes.
4. Inspect the per-evaluator scores and, if you selected multiple models, compare the results for each model.
5. Select the candidate that provides a meaningful quality improvement without an unacceptable increase in token usage or cost.

The completed run's **Token usage** view groups measured input, output, and total tokens by phase and model. It reports token counts rather than a final currency charge. A missing model or usage value means that the usage wasn't attributed or measured, not that it was free. For details, see [Post-run measured token usage](../02-agent-optimizer-costs.md#post-run-measured-token-usage).

If every candidate scores lower than the baseline, keep the current agent. Revise the dataset, evaluators, or optimization settings before you run the optimizer again.

## Promote a candidate

Promote the selected candidate to create a new version of the prompt agent.

1. On the completed run page, select **Promote candidate**.
2. In **Promote candidate as new agent version**, select the candidate to promote.
3. Review the current active version and the selected candidate's score improvement over the baseline.
4. Select **Promote to agent version**.

The promotion creates a new agent version with the candidate's optimized configuration. If the agent is pinned to a specific version, the new version doesn't receive traffic until you set it as the active version in the agent's details.

## What you learned

In this quickstart, you:

- Started a prompt-agent optimization run in the Foundry portal.
- Selected a dataset, evaluators, and candidate models.
- Compared optimized candidates with the prompt-agent baseline.
- Promoted the selected candidate to a new prompt-agent version.

## Related content

- [Agent optimizer overview](../01-agent-optimizer-overview.md)
- [Agent optimizer cost estimates and token usage](../02-agent-optimizer-costs.md)
- [Quickstart: Optimize a hosted agent](03-quickstart-optimize-hosted-agent.md)
- [Convert agent traces into evaluation datasets](../../09-observability/09.2-tracing/08-traces-to-dataset.md)
