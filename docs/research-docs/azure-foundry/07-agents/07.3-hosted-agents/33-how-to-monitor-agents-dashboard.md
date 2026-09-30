# Monitor agents with the Agent Monitoring Dashboard

| Field | Value |
| --- | --- |
| **Document Title** | Monitor agents with the Agent Monitoring Dashboard |
| **Document Location** | `docs/research-docs/azure-foundry/07-agents/07.3-hosted-agents/33-how-to-monitor-agents-dashboard.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Monitor agents with the Agent Monitoring Dashboard". Learn how to monitor operational metrics, token usage, latency, and evaluation results for AI agents in Microsoft Foundry by using the Agent Monitoring Dashboard and Application Insights. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/observability/how-to/how-to-monitor-agents-dashboard). Article date: 2026-09-03. Page updated: 2026-09-11. Retrieved: 2026-09-29. Navigation: Agents > Hosted agents > Run, test, and debug > Monitor agents in the dashboard.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

> **Important**
>
> Items marked (preview) in this article are currently in public preview. This preview is provided without a service-level agreement, and we don't recommend it for production workloads. Certain features might not be supported or might have constrained capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

Use the Agent Monitoring Dashboard in Microsoft Foundry to track operational metrics and evaluation results for your agents. This dashboard helps you understand token usage, latency, success rates, and evaluation outcomes for production traffic.

This article covers two approaches: viewing metrics in the Foundry portal and setting up continuous evaluation programmatically with the Python SDK.

## Prerequisites

- A [Foundry project](../../13-manage-and-operate/13.1-set-up-and-configure/07-create-projects.md) with at least one [agent](../01-overview.md).
- An [Application Insights resource](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) connected to your project.
- Access to the [Foundry portal](https://ai.azure.com/).
- Python 3.10 or later (required for Python SDK steps).
- Azure role-based access control (RBAC) access to the Application Insights resource. For log-based views, you also need access to the associated Log Analytics workspace. To verify access, open the Application Insights resource in the Azure portal, select **Access control (IAM)**, and confirm your account has an appropriate role. For log access, assign the [Log Analytics Reader role](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access?tabs=portal#log-analytics-reader). If those Log Analytics tables are [protected](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/protected-tables-configure) (protection level set to **Protected**), also assign the [Privileged Monitoring Data Reader role](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access?tabs=portal#privileged-monitoring-data-reader) to read that data.

## Connect Application Insights

The Agent Monitoring Dashboard reads telemetry from the Application Insights resource connected to your Foundry project. If you haven't connected Application Insights yet, follow the tracing setup steps and then return to this article.

- [How to set up tracing in Microsoft Foundry](../../09-observability/09.2-tracing/02-trace-agent-setup.md)

## View agent metrics (preview)

To view metrics for an agent in the Foundry portal:

1. Sign in to [Microsoft Foundry](https://ai.azure.com/?cid=learnDocs). Make sure the **New Foundry** toggle is on. These steps refer to **Foundry (new)**.

   ![](https://learn.microsoft.com/en-us/azure/foundry/media/version-banner/new-foundry.png)
2. In the top navigation, select **Build**, then select the agent you want to view data for.
3. Select the **Monitor** tab to view operational, evaluation, and red-teaming data for your agent.

[![Screenshot of the Agent Monitoring Dashboard in Foundry showing summary cards at the top with high-level metrics and charts below displaying evaluation scores, agent run success rates, and token usage over time.](https://learn.microsoft.com/en-us/azure/foundry/media/observability/how-to-monitor-agents-dashboard/foundry-metrics-dashboard.png)](https://learn.microsoft.com/en-us/azure/foundry/media/observability/how-to-monitor-agents-dashboard/foundry-metrics-dashboard.png#lightbox)

The dashboard is designed for quick insights and deep analysis of your agent's performance. It consists of two main areas:

- Summary cards at the top for high-level metrics.
- Charts and graphs below for granular details. These visualizations reflect data for the selected time range.

## Understand the dashboard metrics

Use these definitions to interpret the dashboard:

- **Token usage**: Token counts for agent traffic in the selected time range. High token usage might indicate verbose prompts or responses that could benefit from optimization.
- **Latency**: Response time for agent runs. Latency above 10 seconds might indicate model throttling, complex tool calls, or network issues.
- **Run success rate**: The percentage of runs that complete successfully. A rate below 95% warrants investigation into failed runs.
- **Evaluation metrics**: Scores produced by evaluators that run on sampled agent outputs. Scores vary by evaluator; review individual evaluator documentation for interpretation guidance.
- **Red teaming results**: Outcomes from scheduled red team scans, if enabled. Failed scans indicate potential security risks that require remediation.

> **Note**
>
> Monitoring data is stored in the connected Application Insights resource. Retention and billing follow your Application Insights configuration.

## Configure settings

Use the Monitor settings panel to configure telemetry, evaluations, and security checks for your agents. These settings control which charts the dashboard shows and which evaluations run.

[![Screenshot showing the Monitor Settings panel in Foundry with options for operational metrics, continuous evaluation, scheduled evaluations, red team scans, and alerts configuration.](https://learn.microsoft.com/en-us/azure/foundry/media/observability/how-to-monitor-agents-dashboard/monitor-settings-panel-new.png)](https://learn.microsoft.com/en-us/azure/foundry/media/observability/how-to-monitor-agents-dashboard/monitor-settings-panel-new.png#lightbox)

To access Monitor settings, select the gear icon on the **Monitor** tab. The following table describes each monitoring feature:

| Setting | Purpose | Configuration Options |
| --- | --- | --- |
| **Recurring evaluations (preview)** | Runs evaluations on a schedule to validate performance against benchmarks. | Use the evaluation creation wizard to create and schedule a recurring evaluation. |
| **Red team scans (preview)** | Runs adversarial tests to detect risks such as data leakage or prohibited actions. | Enable or disable Select an evaluation template and run Set a schedule |
| **Alerts (preview)** | Detects performance anomalies, evaluation failures, and security risks. | Configure alerts for latency, token usage, evaluation scores, or red team findings |

## Set up continuous evaluation

Use the Foundry portal, the Python SDK, or the .NET SDK to set up recurring evaluations for monitoring your agents.

**[Python]**

This section requires Python 3.10 or later.

```bash
pip install "azure-ai-projects>=2.0.0" python-dotenv
```

**[C#]**

```bash
dotnet add package Azure.AI.Projects
dotnet add package Azure.AI.Projects.Agents
dotnet add package Azure.AI.Extensions.OpenAI
dotnet add package Azure.Identity
```

**[JavaScript/TypeScript]**

This section requires Node.js 22 or later.

```bash
npm install @azure/ai-projects @azure/identity dotenv
```

**[Foundry portal]**

N/A

Set these environment variables with your own values:

- `AZURE_AI_PROJECT_ENDPOINT`: The Foundry project endpoint, as found on the project overview page in the Foundry portal.
- `AZURE_AI_AGENT_NAME`: The name of the agent to use for evaluation.
- `AZURE_AI_MODEL_DEPLOYMENT_NAME`: The deployment name of the model.

### Assign permissions for continuous evaluation

To enable continuous evaluation rules, assign the project managed identity the **Foundry User** role.

> **Important**
>
> The Foundry RBAC roles were recently renamed. **Foundry User**, **Foundry Owner**, **Foundry Account Owner**, and **Foundry Project Manager** were previously named Azure AI User, Azure AI Owner, Azure AI Account Owner, and Azure AI Project Manager. You might still see the previous names in some places while the rename rolls out. The role IDs and core permissions are unchanged by the rename.

1. In the Azure portal, open the resource for your Foundry project.
2. Select **Access control (IAM)**, and then select **Add**.
3. Create a role assignment for **Foundry User**.
4. For the member, select your Foundry project's managed identity.

### Create an agent

**[Python]**

```python
import os
from dotenv import load_dotenv
from azure.identity import DefaultAzureCredential
from azure.ai.projects import AIProjectClient
from azure.ai.projects.models import (
    PromptAgentDefinition,
)

load_dotenv()

endpoint = os.environ["AZURE_AI_PROJECT_ENDPOINT"]

with (
    DefaultAzureCredential() as credential,
    AIProjectClient(endpoint=endpoint, credential=credential) as project_client,
    project_client.get_openai_client() as openai_client,
):
    agent = project_client.agents.create_version(
        agent_name=os.environ["AZURE_AI_AGENT_NAME"],
        definition=PromptAgentDefinition(
            model=os.environ["AZURE_AI_MODEL_DEPLOYMENT_NAME"],
            instructions="You are a helpful assistant that answers general questions",
        ),
    )
    print(f"Agent created (id: {agent.id}, name: {agent.name}, version: {agent.version})")
```

References: [AIProjectClient](https://learn.microsoft.com/en-us/python/api/azure-ai-projects/azure.ai.projects.aiprojectclient), [DefaultAzureCredential](https://learn.microsoft.com/en-us/python/api/azure-identity/azure.identity.defaultazurecredential)

**[C#]**

```csharp
using Azure.AI.Projects;
using Azure.AI.Projects.Agents;
using Azure.AI.Extensions.OpenAI;
using Azure.Identity;
using OpenAI.Evals;

var endpoint = Environment.GetEnvironmentVariable("AZURE_AI_PROJECT_ENDPOINT")
    ?? throw new InvalidOperationException("AZURE_AI_PROJECT_ENDPOINT environment variable is not set.");

AIProjectClient projectClient = new(new Uri(endpoint), new DefaultAzureCredential());
#pragma warning disable OPENAI001 // Suppress experimental API warning for EvaluationClient (preview)
EvaluationClient evaluationClient = projectClient.ProjectOpenAIClient.GetEvaluationClient();
#pragma warning restore OPENAI001

PromptAgentDefinition agentDefinition = new(
    model: Environment.GetEnvironmentVariable("AZURE_AI_MODEL_DEPLOYMENT_NAME"))
{
    Instructions = "You are a helpful assistant that answers general questions",
};

AgentVersion agentVersion = await projectClient.AgentAdministrationClient.CreateAgentVersionAsync(
    agentName: Environment.GetEnvironmentVariable("AZURE_AI_AGENT_NAME"),
    options: new(agentDefinition));

Console.WriteLine(
    $"Agent created (id: {agentVersion.Id}, name: {agentVersion.Name}," +
    $" version: {agentVersion.Version})");
```

References: [AIProjectClient](https://learn.microsoft.com/en-us/dotnet/api/azure.ai.projects.aiprojectclient), [DefaultAzureCredential](https://learn.microsoft.com/en-us/dotnet/api/azure.identity.defaultazurecredential)

**[JavaScript/TypeScript]**

```bash
npm install @azure/ai-projects @azure/identity dotenv
```

```javascript
import { DefaultAzureCredential } from "@azure/identity";
import { AIProjectClient } from "@azure/ai-projects";
import "dotenv/config";

const endpoint = process.env["AZURE_AI_PROJECT_ENDPOINT"] || "";

const project = new AIProjectClient(endpoint, new DefaultAzureCredential());
const openAIClient = project.getOpenAIClient();

const agent = await project.agents.createVersion(
  process.env["AZURE_AI_AGENT_NAME"] || "",
  {
    kind: "prompt",
    model: process.env["AZURE_AI_MODEL_DEPLOYMENT_NAME"] || "",
    instructions: "You are a helpful assistant that answers general questions",
  },
);
console.log(
  `Agent created (id: ${agent.id}, name: ${agent.name}, version: ${agent.version})`,
);
```

References: [AIProjectClient class](https://learn.microsoft.com/en-us/javascript/api/@azure/ai-projects/aiprojectclient), [DefaultAzureCredential class](https://learn.microsoft.com/en-us/javascript/api/@azure/identity/defaultazurecredential)

**[Foundry portal]**

1. Open the [Foundry portal](https://ai.azure.com/) and go to your project.
2. On the **Build** page, select **Agents**.
3. Use the agent creation wizard to create an agent.

### Create a recurring evaluation

Configure recurring evaluations in one of two ways:

- **Scheduled evaluation** runs on a fixed schedule.
- **Continuous evaluation** samples live traffic as it occurs.

**[Python]**

```python
from azure.ai.projects.models import (
    EvaluationRule,
    ContinuousEvaluationRuleAction,
    EvaluationRuleFilter,
    EvaluationRuleEventType,
)

data_source_config = {"type": "azure_ai_source", "scenario": "responses"}
testing_criteria = [
    {"type": "azure_ai_evaluator", "name": "violence_detection", "evaluator_name": "builtin.violence"}
]
eval_object = openai_client.evals.create(
    name="Continuous Evaluation",
    data_source_config=data_source_config,  # type: ignore
    testing_criteria=testing_criteria,  # type: ignore
)
print(f"Evaluation created (id: {eval_object.id}, name: {eval_object.name})")

// Create scheduled recurring evaluation by creating the schedule.

trace_source: dict = {
    "type": "agent_filter",
    "agent_name": agent_name,
    "start_time": start_time,
    "end_time": end_time,
    "max_traces": args.max_traces
}

eval_run_object = {
    "eval_id": eval_object.id,
    "name": "trace_eval_with_smart_filter",
    "data_source": {
        "type": "azure_ai_trace_data_source_preview",
        "trace_source": trace_source,
    },
}

print("Creating Schedule for agent trace evaluation")

schedule = Schedule(
    display_name="Agent Trace Evaluation Eval Run Schedule",
    enabled=True,
    trigger=RecurrenceTrigger(interval=1, schedule=DailyRecurrenceSchedule(hours=[9])),  # Every day at 9 AM
    task=EvaluationScheduleTask(eval_id=eval_object.id, eval_run=eval_run_object),
)
schedule_response = project_client.beta.schedules.create_or_update(
    schedule_id="agent-trace-eval-run-schedule-9am", schedule=schedule
)

print(f"Schedule created for agent trace evaluation: {schedule_response.schedule_id}")

// Create continuous recurring evaluation by creating evaluation rule.

continuous_eval_rule = project_client.evaluation_rules.create_or_update(
    id="my-continuous-eval-rule",
    evaluation_rule=EvaluationRule(
        display_name="My Continuous Eval Rule",
        description="An eval rule that runs on agent response completions",
        action=ContinuousEvaluationRuleAction(eval_id=eval_object.id, max_hourly_runs=100),
        event_type=EvaluationRuleEventType.RESPONSE_COMPLETED,
        filter=EvaluationRuleFilter(agent_name=agent.name),
        enabled=True,
    ),
)
print(
    f"Continuous Evaluation Rule created (id: {continuous_eval_rule.id}, name: {continuous_eval_rule.display_name})"
)
```

References: [Schedule](https://learn.microsoft.com/en-us/python/api/azure-ai-projects/azure.ai.projects.models.schedule), [EvaluationRuleEventType](https://learn.microsoft.com/en-us/python/api/azure-ai-projects/azure.ai.projects.models.evaluationruleeventtype), [EvaluationRule](https://learn.microsoft.com/en-us/python/api/azure-ai-projects/azure.ai.projects.models.evaluationrule)

**[C#]**

```csharp
using System.ClientModel;
using System.Text.Json;
using Azure.AI.Projects;

// Build the evaluation configuration
BinaryData evaluationConfig = BinaryData.FromObjectAsJson(new
{
    name = "Continuous Evaluation",
    data_source_config = new { type = "azure_ai_source", scenario = "responses" },
    testing_criteria = new[]
    {
        new
        {
            type = "azure_ai_evaluator",
            name = "violence_detection",
            evaluator_name = "builtin.violence",
        },
    }
});

// Create the evaluation object
using BinaryContent evaluationContent = BinaryContent.Create(evaluationConfig);
ClientResult evaluationResult = await evaluationClient.CreateEvaluationAsync(evaluationContent);

using JsonDocument evalDoc = JsonDocument.Parse(
    evaluationResult.GetRawResponse().Content);
string evaluationId = evalDoc.RootElement.GetProperty("id").GetString()!;
string evaluationName = evalDoc.RootElement.GetProperty("name").GetString()!;
Console.WriteLine($"Evaluation created (id: {evaluationId}, name: {evaluationName})");

// Create scheduled recurring evaluation by creating the schedule.


var runObject = BinaryData.FromObjectAsJson(new
    {
        eval_id = evaluationId,
        name = evaluationName,
        data_source = new
        {
            type = "azure_ai_trace_data_source_preview",
            trace_source = new
            {
                type: "agent_filter",
                agent_name: agent_name,
                start_time: start_time,
                end_time: end_time,
                max_traces: args.max_traces
            }
        }
    });

RecurrenceTrigger trigger = new(interval: 1, new DailyRecurrenceSchedule(hours: [9]));
EvaluationScheduleTask scheduleTask = new(evalId: evaluationId, evalRun: runObject);
ProjectsSchedule schedule = new(enabled: true, trigger: trigger, task: scheduleTask)
{
    DisplayName = "Agent Eval Run Schedule"
};
ProjectsSchedule scheduleResponse = projectClient.Schedules.CreateOrUpdate(id: "agent-eval-run-schedule-9am", resource: schedule);

// Create continuous recurring evaluation by creating evaluation rule.

ContinuousEvaluationRuleAction continuousAction = new(evaluationId)
{
    MaxHourlyRuns = 100,
};
EvaluationRule continuousRule = new(
    action: continuousAction,
    eventType: EvaluationRuleEventType.ResponseCompleted,
    enabled: true)
{
    Filter = new EvaluationRuleFilter(agentName: agentVersion.Name),
    DisplayName = "My Continuous Eval Rule",
    Description = "An eval rule that runs on agent response completions",
};

EvaluationRule continuousEvalRule = await projectClient.EvaluationRules.CreateOrUpdateAsync(
    id: "my-continuous-eval-rule",
    evaluationRule: continuousRule);

Console.WriteLine(
    $"Continuous Evaluation Rule created" +
    $" (id: {continuousEvalRule.Id}, name: {continuousEvalRule.DisplayName})");
```

References: [EvaluationScheduleTask](https://learn.microsoft.com/en-us/dotnet/api/azure.ai.projects.evaluation.evaluationscheduletask), [EvaluationRuleEventType](https://learn.microsoft.com/en-us/dotnet/api/azure.ai.projects.evaluation.evaluationruleeventtype), [EvaluationRule](https://learn.microsoft.com/en-us/dotnet/api/azure.ai.projects.evaluation.evaluationrule)

**[JavaScript/TypeScript]**

> **Note**
>
> The JavaScript/TypeScript SDK currently supports continuous evaluation rules. For scheduled evaluations that run on a fixed recurrence, use the Foundry portal instead.

```javascript
const dataSourceConfig = { type: "azure_ai_source", scenario: "responses" };
const testingCriteria = [
  {
    type: "azure_ai_evaluator",
    name: "violence_detection",
    evaluator_name: "builtin.violence",
  },
];

const evalObject = await openAIClient.evals.create({
  name: "Continuous Evaluation",
  data_source_config: dataSourceConfig,
  testing_criteria: testingCriteria,
});
console.log(
  `Evaluation created (id: ${evalObject.id}, name: ${evalObject.name})`,
);

// Create a continuous evaluation rule that runs on agent response
// completions
const continuousEvalRule = await project.evaluationRules.createOrUpdate(
  "my-continuous-eval-rule",
  {
    displayName: "My Continuous Eval Rule",
    description: "An eval rule that runs on agent response completions",
    action: {
      type: "continuousEvaluation",
      evalId: evalObject.id,
      maxHourlyRuns: 100,
    },
    eventType: "responseCompleted",
    filter: { agentName: agent.name },
    enabled: true,
  },
);
console.log(
  `Continuous Evaluation Rule created (id: ${continuousEvalRule.id}, ` +
    `name: ${continuousEvalRule.displayName})`,
);
```

References: [evaluationRules.createOrUpdate](https://learn.microsoft.com/en-us/javascript/api/@azure/ai-projects/aiprojectclient)

**[Foundry portal]**

1. Open the [Foundry portal](https://ai.azure.com/) and go to your project.
2. On **Build**, select the **Evaluations** tab.
3. Select the **Recurring Configs** subtab to view your recurring evaluation configurations.

   [![Screenshot of the recurring configurations in Foundry showing list of recurring configurations created for your agents.](https://learn.microsoft.com/en-us/azure/foundry/media/observability/how-to-monitor-agents-dashboard/monitor-recurring-configuration-list-view.png)](https://learn.microsoft.com/en-us/azure/foundry/media/observability/how-to-monitor-agents-dashboard/monitor-recurring-configuration-list-view.png#lightbox)
4. Select **Create** to open the recurring evaluation creation wizard.
5. Select the agents that you want to monitor.
6. Select the evaluation turn level.
7. Choose a recurring evaluation type:
   - **Scheduled evaluation** runs on a fixed schedule.
   - **Continuous evaluation** samples live traffic as it occurs.
8. Select a data source available for your evaluation type, such as **Live traffic** for agent traces or **Dataset** for a golden dataset.
9. For **Live traffic**, optionally select **Random** or [**Intelligent sampling**](../../10-evaluation/10.3-run-evaluations/05-cloud-evaluation-deployed-interactions.md#intelligent-sampling). Then set the maximum number of traces or runs available for the selected evaluation type.

[![Screenshot of creating recurring evaluation configuration in Foundry with various options.](https://learn.microsoft.com/en-us/azure/foundry/media/observability/how-to-monitor-agents-dashboard/monitor-recurring-create-wizard.png)](https://learn.microsoft.com/en-us/azure/foundry/media/observability/how-to-monitor-agents-dashboard/monitor-recurring-create-wizard.png#lightbox)

## Verify continuous evaluation results

1. Generate agent traffic (for example, run your app or test the agent in the portal).
2. In the Foundry portal, open the agent and select **Monitor**.
3. Review evaluation-related charts for the selected time range.

If the setup is successful, the evaluation-related charts display scores for your selected time range, and the evaluation runs list shows entries with status **Completed**.

You can also list recent evaluation runs and open the report URL:

**[Python]**

```python
eval_run_list = openai_client.evals.runs.list(
    eval_id=eval_object.id,
    order="desc",
    limit=10,
)

if len(eval_run_list.data) > 0 and eval_run_list.data[0].report_url:
    print(f"Report URL: {eval_run_list.data[0].report_url}")
```

**[C#]**

```csharp
using System.Text.Json;
using System.ClientModel;

// List recent evaluation runs using a protocol method
ClientResult runsResult = await evaluationClient.GetEvaluationRunsAsync(
    evaluationId, null, null, null, null, new());

using JsonDocument runsDoc = JsonDocument.Parse(
    runsResult.GetRawResponse().Content);
var runs = runsDoc.RootElement.GetProperty("data");

if (runs.GetArrayLength() > 0)
{
    var firstRun = runs[0];
    if (firstRun.TryGetProperty("report_url", out JsonElement reportUrlElement))
    {
        Console.WriteLine($"Report URL: {reportUrlElement.GetString()}");
    }
}
```

**[JavaScript/TypeScript]**

```javascript
const evalRunList = await openAIClient.evals.runs.list(evalObject.id, {
    order: "desc",
    limit: 10,
});

if (evalRunList.data.length > 0 && evalRunList.data[0].report_url) {
    console.log(`Report URL: ${evalRunList.data[0].report_url}`);
}
```

**[Foundry portal]**

1. On **Build**, select the **Evaluations** tab.
2. Select the **Recurring Configs** subtab.
3. Select the recurring evaluation that you want to review.

## Use custom evaluators for continuous evaluations

In addition to first-party evaluators, you can bring your own evaluators for continuous evaluations. To set up custom evaluators, follow the steps in [Custom evaluators (preview)](../../10-evaluation/10.1-supported-evaluators/09-custom-evaluators.md).

To add custom evaluators to continuous evaluations:

1. From the **Monitor** tab, select **Settings**.
2. Select the **Continuous evaluation** tab.
3. Select **Add evaluator(s)**.
4. Choose the custom evaluators you want to include.

## Full sample code

To view the full sample code, see:

- [Continuous evaluation sample (Python)](https://github.com/Azure/azure-sdk-for-python/blob/main/sdk/ai/azure-ai-projects/samples/evaluations/sample_continuous_evaluation_rule.py).
- [Scheduled evaluation and Schedule AI red teaming evaluation sample (Python)](https://github.com/Azure/azure-sdk-for-python/blob/main/sdk/ai/azure-ai-projects/samples/evaluations/sample_scheduled_evaluations.py).

## Troubleshooting

| Issue | Cause | Resolution |
| --- | --- | --- |
| Dashboard charts are empty | No recent traffic, time range excludes data, or ingestion delay | Generate new agent traffic, expand the time range, and refresh after a few minutes. |
| You see authorization errors | Missing RBAC permissions on Application Insights or Log Analytics | Confirm access in **Access control (IAM)** for the connected resources. For log access, assign the [Log Analytics Reader role](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access?tabs=portal#log-analytics-reader). If the tables are [protected](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/protected-tables-configure), also assign [Privileged Monitoring Data Reader](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access?tabs=portal#privileged-monitoring-data-reader). |
| Continuous evaluation results don't appear | Continuous evaluation isn't enabled or rule creation failed | Confirm that your rule is enabled and that agent traffic is flowing. If you use the Python SDK setup, confirm the project managed identity has the **Foundry User** role. |
| Evaluation runs are skipped | Hourly run limit reached | Increase `max_hourly_runs` in the evaluation rule configuration or wait for the next hour. The default limit is 100 runs per hour. |

## Monitor and set up continuous evaluation for custom agents

Foundry can serve as a centralized location for your agent monitoring, even for agents not running on the platform. Within Foundry control plane, you can onboard agents running elsewhere via AI Gateway. You can then instrument your agent to send traces to the same Application Insights instance as your Foundry project. This setup enables continuous evaluations and tracking of metrics like error rate for agents not running in Foundry.

## Set up monitoring for your custom agents

1. Onboard your custom agent to Foundry using the instructions in [Register and manage custom agents](../../13-manage-and-operate/13.2-govern-at-scale/04-register-custom-agent.md).
2. Instrument your agent to comply with the [semantic conventions for generative AI solutions in the OpenTelemetry standard](https://opentelemetry.io/docs/specs/semconv/gen-ai/).
3. Configure your agent to send telemetry to the same Application Insights instance as your Foundry project to enable continuous evaluation features.
4. In Foundry Control Plane, go to the **Asset** page and select your agent.
5. Select the **Monitor** tab to view your metrics and charts.
6. Set up continuous evaluations using the methods outlined in [Configure settings](#configure-settings).

## Related content

- [Agent tracing overview](../../09-observability/09.2-tracing/01-trace-agent-concept.md)
- [Run AI Red Teaming Agent in the cloud](../../10-evaluation/10.4-ai-red-teaming/02-run-ai-red-teaming-cloud.md)
- [Set up tracing in Microsoft Foundry](../../09-observability/09.2-tracing/02-trace-agent-setup.md)
- [Tracing integrations](../../09-observability/09.2-tracing/06-trace-agent-framework.md)
