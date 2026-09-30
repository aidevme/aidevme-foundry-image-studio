# View evaluation results in the Microsoft Foundry portal

| Field | Value |
| --- | --- |
| **Document Title** | View evaluation results in the Microsoft Foundry portal |
| **Document Location** | `docs/research-docs/azure-foundry/10-evaluation/10.3-run-evaluations/15-evaluate-results.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "View evaluation results in the Microsoft Foundry portal". See and analyze AI model evaluation results in Microsoft Foundry portal. Learn to view performance metrics, compare results, and interpret evaluation data for model optimization. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/evaluate-results). Article date: 2026-09-11. Page updated: 2026-09-14. Retrieved: 2026-09-29. Navigation: Evaluation > Run evaluations > Review and analyze results > View evaluation results in the portal.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

In this article, you learn how to:

- Locate and open evaluation runs.
- View aggregate and sample-level metrics.
- Compare results across runs.
- Interpret metric categories and calculations.
- Troubleshoot missing or partial metrics.

## Prerequisites

- **Foundry User** role on the Foundry project. For more information, see [Role-based access control for Microsoft Foundry](../../13-manage-and-operate/13.3-security-and-governance/02-rbac-foundry.md).

  > **Important**
  >
  > The Foundry RBAC roles were recently renamed. **Foundry User**, **Foundry Owner**, **Foundry Account Owner**, and **Foundry Project Manager** were previously named Azure AI User, Azure AI Owner, Azure AI Account Owner, and Azure AI Project Manager. You might still see the previous names in some places while the rename rolls out. The role IDs and core permissions are unchanged by the rename.
- A completed evaluation run.
  - To run evaluations in the portal, see [Evaluate generative AI models and applications](12-evaluate-generative-ai-app.md).
  - To run evaluations from the SDK, see [Run evaluations from the SDK](02-cloud-evaluation.md) or [Evaluate your AI agents](01-evaluate-agent.md).

## See your evaluation results

1. In the [Foundry portal](https://ai.azure.com/), go to your project and select **Evaluation** from the left pane.
2. Select an evaluation run from the list to open its details page. If the run is still in progress, the status shows **Running** and updates automatically when complete.

   The details page shows:

   | Field | Description |
   | --- | --- |
   | Name | The name of the evaluation run. |
   | Target | The model or agent that was evaluated. |
   | Dataset | The test dataset used. Select the download icon to export it as a CSV file. |
   | Status | Current status of the run (**Running**, **Completed**, or **Failed**). |
   | Evaluation tokens | Tokens consumed by the evaluators during the run. |
   | Target tokens | Tokens consumed by the model or agent being evaluated. |
   | Scores | Aggregate score for each evaluator used. |

   [![Screenshot of the Evaluation page showing a list of runs with Name, Status, Target, Evaluation tokens, Target tokens, and Scores columns.](https://learn.microsoft.com/en-us/azure/foundry/media/observability/evaluation-runs.png)](https://learn.microsoft.com/en-us/azure/foundry/media/observability/evaluation-runs.png#lightbox)
3. Hover over a score cell to see token usage details and additional context.

   [![Screenshot of the Evaluation page with a score cell hovered, showing a tooltip with token usage breakdown.](https://learn.microsoft.com/en-us/azure/foundry/media/observability/evaluation-runs-hover.png)](https://learn.microsoft.com/en-us/azure/foundry/media/observability/evaluation-runs-hover.png#lightbox)
4. Select **Learn more about metrics** to see metric definitions and scoring formulas.

### Evaluation run details

Select the name of the run to view row-level results for each individual query. For each row, you can see the query, response, ground truth, evaluator score, and score explanation.

### Review model-target latency and estimated cost

For model-target evaluation runs, the run details can include target latency and estimated target inference cost. The latency summary reports median (p50) and 95th-percentile (p95) end-to-end target latency in milliseconds, along with the number of rows that contributed a usable measurement.

The cost estimate is currently available for Global Standard model deployments when the run has usable target token attribution and pricing data. If some attributed models can't be priced, the result is marked partial and the estimate includes only the models with available prices.

> **Important**
>
> Target cost is an estimate based on reported token usage and published list prices. It excludes evaluator model usage and evaluation runtime costs, and it doesn't account for negotiated pricing, commitments, or discounts. Use Azure billing data for actual charges.

For the evaluation run response fields and a JSON example, see [Review model-target latency and estimated cost](10-cloud-evaluation-results.md#review-model-target-latency-and-estimated-cost).

## Compare the evaluation results

To compare two or more runs, select the runs you want to compare and start the process.

1. Select two or more runs in the evaluation detail page.
2. Select **Compare**.

You see a side-by-side comparison view for all selected runs.

The comparison uses statistical t-testing, which gives you more sensitive and reliable results to help you make decisions. You can use different functionalities of this feature:

- **Baseline comparison**: By setting a baseline run, you can identify a reference point against which to compare the other runs. You can see how each run deviates from your chosen standard.
- **Statistical t-testing assessment**: Each cell provides the stat-sig results with different color codes. You can also hover on the cell to get the sample size and p-value.

| Legend | Definition |
| --- | --- |
| ImprovedStrong | Highly stat-sig (p&lt;=0.001) and moved in the desired direction |
| ImprovedWeak | Stat-sig (0.001&lt;p&lt;=0.05) and moved in the desired direction |
| DegradedStrong | Highly stat-sig (p&lt;=0.001) and moved in the wrong direction |
| DegradedWeak | Stat-sig (0.001&lt;p&lt;=0.05) and moved in the wrong direction |
| ChangedStrong | Highly stat-sig (p&lt;=0.001) and desired direction is neutral |
| ChangedWeak | Stat-sig (0.001&lt;p&lt;=0.05) and desired direction is neutral |
| Inconclusive | Too few examples, or p>=0.05 |

> **Note**
>
> The comparison view isn't saved. If you leave the page, you can reselect the runs and select **Compare** to regenerate the view.

## Understand the built-in evaluation metrics

Understanding the built-in metrics is essential for assessing the performance and effectiveness of your AI application. By learning about these key measurement tools, you can interpret the results, make informed decisions, and fine-tune your application to achieve optimal outcomes.

To learn more, see [Built in evaluators](../10.1-supported-evaluators/01-built-in-evaluators.md).

## Troubleshooting

| Symptom | Possible cause | Action |
| --- | --- | --- |
| Run stays pending | High service load or queued jobs | Refresh, verify quota, and resubmit if prolonged |
| Metrics missing | Not selected at creation | Rerun and select required metrics |
| All safety metrics zero | Category disabled or unsupported model | Confirm model and evaluator support in [Risk and safety evaluators](../10.1-supported-evaluators/01-built-in-evaluators.md#risk-and-safety-evaluators) |
| Groundedness unexpectedly low | Retrieval/context incomplete | Verify context construction / retrieval latency |

## Related content

- [Run evaluations from the Microsoft Foundry portal](12-evaluate-generative-ai-app.md)
- [Run batch evaluations from the SDK](02-cloud-evaluation.md)
- [Built-in evaluators](../10.1-supported-evaluators/01-built-in-evaluators.md)
- [Improve model performance with fine-tuning](../../06-models/06.8-fine-tuning/02-fine-tuning.md)
