# Evaluation datasets in Microsoft Foundry

| Field | Value |
| --- | --- |
| **Document Title** | Evaluation datasets in Microsoft Foundry |
| **Document Location** | `docs/research-docs/azure-foundry/10-evaluation/10.2-evaluation-datasets/01-evaluation-datasets.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Evaluation datasets in Microsoft Foundry". Learn how evaluation datasets are structured, how to prepare them, and how Microsoft Foundry uses them in evaluation runs. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/observability/how-to/evaluation-datasets). Article date: 2026-08-26. Page updated: 2026-09-02. Retrieved: 2026-09-29. Navigation: Evaluation > Evaluation datasets > Overview.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

An evaluation dataset is a reusable collection of test cases for measuring model or agent quality. Evaluation datasets typically use JSONL, with one JSON object per line. This article explains when to use a reusable dataset, how evaluation data is organized, and the available ways to prepare it.

## Do you need an evaluation dataset?

Create a dataset when you want a stable test set that you can rerun against different model, prompt, or agent versions. Reusable datasets work well for regression testing, CI/CD quality gates, and comparisons across evaluation runs.

You don't always need a dataset. If your Foundry agent already has responses or your application emits traces to Application Insights, you can evaluate that data where it exists. See [Evaluate interactions by response ID](../10.3-run-evaluations/05-cloud-evaluation-deployed-interactions.md#evaluate-interactions-by-response-id) and [Evaluate traces](../10.3-run-evaluations/05-cloud-evaluation-deployed-interactions.md#evaluate-traces-preview).

## How Foundry uses evaluation data

In a JSONL dataset, the `messages` field represents model or agent interactions. Each message identifies a role and its content.

If your dataset contains completed responses, Foundry evaluates those responses directly. If you run the evaluation against a model or agent, Foundry generates a new response for each input and evaluates that response. Any response already stored in the dataset is ignored.

For example, consider a user who can't sign in. The agent asks which error appears, the user says their password is rejected, and the agent recommends a password reset. Turn-level evaluation scores an individual agent response, such as the password-reset guidance, by using preceding messages as context. Conversation-level evaluation scores the complete interaction.

The `evaluation_level` setting on the run controls the scoring granularity. The dataset and selected evaluators must support that level. For details, see [Choose an evaluation level](../10.3-run-evaluations/07-cloud-evaluation-conversations.md#choose-an-evaluation-level). For standard columns and examples, see [Evaluation dataset schema](02-evaluation-dataset-schema.md).

## Choose how to prepare evaluation data

| Situation | Recommended approach |
| --- | --- |
| **You have curated evaluation data** | Upload it as a versioned Foundry dataset or provide a small dataset inline. See [Prepare input data](../10.3-run-evaluations/03-cloud-evaluation-datasets.md#prepare-input-data). |
| **You want to review and reuse generated test cases before running an evaluation** | [Generate a synthetic evaluation dataset](03-evaluation-dataset-synthetic.md) from an agent definition, inline prompt, or reference file. |
| **You want a reusable dataset based on production traffic** | [Convert traces into a dataset](../../09-observability/09.2-tracing/08-traces-to-dataset.md). |
| **You want to test simulated multi-turn scenarios** | [Generate a simulation seed dataset](03-evaluation-dataset-synthetic.md#generate-a-simulation-seed-dataset-sdk) or author test case scenarios as JSONL, and then [simulate conversations](../10.3-run-evaluations/09-cloud-evaluation-simulate-conversations.md). |
| **You have Foundry response IDs** | [Evaluate interactions by response ID](../10.3-run-evaluations/05-cloud-evaluation-deployed-interactions.md#evaluate-interactions-by-response-id) without creating a dataset. |
| **You want to evaluate existing Application Insights traces** | [Evaluate traces](../10.3-run-evaluations/05-cloud-evaluation-deployed-interactions.md#evaluate-traces-preview) without creating a dataset. |
| **You want to generate queries, invoke a target, and evaluate its responses in one workflow** | [Generate synthetic queries](../10.3-run-evaluations/06-cloud-evaluation-synthetic-data.md#generate-synthetic-queries) during the evaluation run. Foundry saves the generated queries as a dataset for reuse. |

## Next step

[Review the evaluation dataset schema](02-evaluation-dataset-schema.md)

## Related content

- [Run evaluations from the SDK](../10.3-run-evaluations/02-cloud-evaluation.md)
- [Generate a synthetic evaluation dataset](03-evaluation-dataset-synthetic.md)
- [Convert agent traces into evaluation datasets](../../09-observability/09.2-tracing/08-traces-to-dataset.md)
- [Evaluate your agent](../10.3-run-evaluations/01-evaluate-agent.md)
