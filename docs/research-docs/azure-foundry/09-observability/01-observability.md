# Observability in generative AI

| Field | Value |
| --- | --- |
| **Document Title** | Observability in generative AI |
| **Document Location** | `docs/research-docs/azure-foundry/09-observability/01-observability.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Observability in generative AI". Learn how Microsoft Foundry enables safe, high-quality generative AI through systematic evaluation and observability tools. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/concepts/observability). Article date: 2026-07-31. Page updated: 2026-08-26. Retrieved: 2026-09-29. Navigation: Observability > Overview.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

The AI application lifecycle requires robust evaluation frameworks to ensure AI systems deliver accurate, relevant, and reliable outputs. Without rigorous assessment, AI systems risk generating responses that are inaccurate, inconsistent, poorly grounded, or potentially harmful. Observability enables teams to measure and improve both the quality and safety of AI outputs throughout the development lifecycle - from model selection through production monitoring.

## What is observability?

AI observability refers to the ability to monitor, understand, and troubleshoot AI systems throughout their lifecycle. You can trace, evaluate, integrate automated quality gates into CI/CD pipelines, and collect signals such as evaluation metrics, logs, traces, and model outputs to gain visibility into performance, quality, safety, and operational health.

## Core observability capabilities

Microsoft Foundry provides three core capabilities that work together to deliver comprehensive observability across the AI application lifecycle:

### Evaluation

Evaluators measure the quality, safety, and reliability of AI responses throughout development. Microsoft Foundry provides built-in evaluators including general-purpose quality metrics (coherence, fluency), RAG-specific metrics (groundedness, relevance), safety and security (hate/unfairness, violence, protected materials), and agent-specific metrics (tool call accuracy, task completion), among others. You can also build custom evaluators tailored to your domain-specific requirements.

For a complete list of built-in evaluators, see [Built-in evaluators reference](../10-evaluation/10.1-supported-evaluators/01-built-in-evaluators.md).

### Monitoring

Production monitoring ensures your deployed AI applications maintain quality and performance in real-world conditions. Integrated with Azure Monitor Application Insights, Microsoft Foundry delivers real-time dashboards tracking operational metrics, token consumption, latency, error rates, and quality scores. You can set up alerts when outputs fail quality thresholds or produce harmful content, enabling rapid issue resolution.

For details on setting up production monitoring, see [Monitor agents dashboard](../07-agents/07.3-hosted-agents/33-how-to-monitor-agents-dashboard.md).

### Tracing

Distributed tracing captures the execution flow of AI applications, providing visibility into LLM calls, tool invocations, agent decisions, and inter-service dependencies. Built on OpenTelemetry standards and integrated with Azure Monitor Application Insights, tracing enables debugging complex agent behaviors, identifying performance bottlenecks, and understanding multi-step reasoning chains. Microsoft Foundry supports tracing for popular frameworks including LangChain, LangGraph, the OpenAI Agents SDK, and the Microsoft Agent Framework.

For guidance on implementing tracing, see [Trace agent overview](09.2-tracing/01-trace-agent-concept.md).

## What are evaluators?

Evaluators are specialized tools that measure the quality, safety, and reliability of AI responses throughout the development lifecycle.

For a complete list of built-in evaluators, see [Built-in evaluators reference](../10-evaluation/10.1-supported-evaluators/01-built-in-evaluators.md).

Evaluators integrate into each stage of the AI lifecycle to ensure reliability, safety, and effectiveness.

[![Diagram of AI application lifecycle, showing model selection, building an AI application, and operationalizing.](https://learn.microsoft.com/en-us/azure/foundry/media/evaluations/lifecycle.png)](https://learn.microsoft.com/en-us/azure/foundry/media/evaluations/lifecycle.png#lightbox)

## The three stages of AI application lifecycle evaluation

### Base model selection

Select the right foundation model by comparing quality, task performance, ethical considerations, and safety profiles across different models.

**Tools available**: [Microsoft Foundry benchmark](../06-models/06.1-explore-foundry-models/05-model-benchmarks.md) for comparing models on public datasets or your own data, and the Azure AI Evaluation SDK for [testing specific model endpoints](https://github.com/Azure-Samples/azureai-samples/blob/main/scenarios/evaluate/Supported_Evaluation_Targets/Evaluate_Base_Model_Endpoint/Evaluate_Base_Model_Endpoint.ipynb).

### Pre-production evaluation

Before deployment, thorough testing ensures your AI agent or application is production-ready. This stage validates performance through evaluation datasets, identifies edge cases, assesses robustness, and measures key metrics including task adherence, groundedness, relevance, and safety. For building production-ready agents with multi-turn conversations, tool calling, and state management, see [Foundry Agent Service](../07-agents/01-overview.md).

[![Diagram of Pre-production evaluation for models and applications with the six steps.](https://learn.microsoft.com/en-us/azure/foundry/media/evaluations/evaluation-models-diagram.png)](https://learn.microsoft.com/en-us/azure/foundry/media/evaluations/evaluation-models-diagram.png#lightbox)

**Evaluation tools and approaches:**

- **Bring your own data**: Evaluate AI applications using your own data with quality, safety, or [custom evaluators](../10-evaluation/10.1-supported-evaluators/09-custom-evaluators.md). Use the [Foundry portal](../10-evaluation/10.3-run-evaluations/12-evaluate-generative-ai-app.md) evaluation wizard or [Foundry SDK](../10-evaluation/10.3-run-evaluations/02-cloud-evaluation.md) and [view results in the Foundry portal](../10-evaluation/10.3-run-evaluations/15-evaluate-results.md).
- **AI red teaming agent**: The [AI red teaming agent](../10-evaluation/10.4-ai-red-teaming/02-run-ai-red-teaming-cloud.md) simulates complex attacks using Microsoft's PyRIT framework to identify safety and security vulnerabilities before deployment. Best used with human-in-the-loop processes.

### Post-production monitoring

After deployment, [continuous monitoring](../07-agents/07.3-hosted-agents/33-how-to-monitor-agents-dashboard.md) ensures your AI application maintains quality in real-world conditions:

- **Operational metrics**: Regular measurement of key AI agent operational metrics
- **Continuous evaluation**: Quality and safety evaluation of production traffic at a sampled rate
- **Scheduled evaluation**: Scheduled quality and safety evaluation using test datasets to detect system drift
- **Scheduled red teaming**: Scheduled adversarial testing to probe for safety and security vulnerabilities
- **Azure Monitor alerts**: Notifications when outputs fail quality thresholds or produce harmful content

Integrated with Azure Monitor Application Insights, the Foundry Observability dashboard delivers real-time insights into performance, safety, and quality metrics, enabling rapid issue resolution and maintaining user trust.

## Evaluation quick reference

| Purpose | Process | Parameters, guidance, and samples |
| --- | --- | --- |
| How to set up tracing? | Configure distributed tracing | [Trace overview](09.2-tracing/01-trace-agent-concept.md) [Trace with Agents SDK](09.2-tracing/02-trace-agent-setup.md) |
| What are you evaluating for? | Identify or build relevant evaluators | [Built-in evaluators](../10-evaluation/10.1-supported-evaluators/01-built-in-evaluators.md) [Custom evaluators](../10-evaluation/10.1-supported-evaluators/09-custom-evaluators.md) [Python SDK samples](https://github.com/Azure/azure-sdk-for-python/blob/main/sdk/ai/azure-ai-projects/samples/evaluations/README.md) [C# SDK samples](https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/ai/Azure.AI.Projects/tests/Samples/Evaluation) |
| What data should you use? | Upload or generate relevant dataset | [Select data source](../10-evaluation/10.3-run-evaluations/12-evaluate-generative-ai-app.md#step-3-select-data-source) |
| How to run evaluations? | Run evaluation | [Agent evaluation runs](../10-evaluation/10.3-run-evaluations/01-evaluate-agent.md) [Remote cloud run](../10-evaluation/10.3-run-evaluations/02-cloud-evaluation.md) |
| How did my model/AI application perform? | Analyze results | [View evaluation results](../10-evaluation/10.3-run-evaluations/15-evaluate-results.md) [Cluster analysis](../10-evaluation/10.3-run-evaluations/16-cluster-analysis.md) |
| How can I improve? | Analyze results and optimize agents | Analyze evaluation failures with [cluster analysis](../10-evaluation/10.3-run-evaluations/16-cluster-analysis.md). Optimize agents and [re-evaluate](../10-evaluation/10.3-run-evaluations/01-evaluate-agent.md). Review [evaluation results](../10-evaluation/10.3-run-evaluations/15-evaluate-results.md). |

## Region support, rate limits, and virtual network support

To learn which regions support AI-assisted evaluators, the rate limits that apply to evaluation runs, and how to configure virtual network support for network isolation, see [region support, rate limits, and virtual network support for evaluation](../10-evaluation/01-evaluation-regions-limits-virtual-network.md).

## Pricing

Observability features such as risk and safety evaluations and evaluations in the agent playground are billed based on consumption as listed in the [Azure pricing page](https://azure.microsoft.com/pricing/details/foundryobservability/).

> **Important**
>
> Evaluations in the agents playground are enabled by default for all Foundry projects and are included in consumption-based billing. To turn off playground evaluations, select metrics in the upper right of the agents playground and unselect all evaluators.
>
> [![Screenshot of the Foundry portal showing agents playground with the metrics selected.](https://learn.microsoft.com/en-us/azure/foundry/media/observability/agent-playground-evaluation-metrics.png)](https://learn.microsoft.com/en-us/azure/foundry/media/observability/agent-playground-evaluation-metrics.png#lightbox)

## Related content

- [Built-in evaluators reference](../10-evaluation/10.1-supported-evaluators/01-built-in-evaluators.md)
- [Virtual network support for evaluation](../10-evaluation/01-evaluation-regions-limits-virtual-network.md)
- [Foundry control plane](../13-manage-and-operate/13.2-govern-at-scale/01-overview.md)
- [Evaluate generative AI apps by using Foundry](../10-evaluation/10.3-run-evaluations/12-evaluate-generative-ai-app.md)
- [See evaluation results in the Foundry portal](../10-evaluation/10.3-run-evaluations/15-evaluate-results.md)
- [Foundry Transparency Note](../10-evaluation/03-safety-evaluations-transparency-note.md)
