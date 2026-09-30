# Register external agents for observability and evaluation (preview)

| Field | Value |
| --- | --- |
| **Document Title** | Register external agents for observability and evaluation (preview) |
| **Document Location** | `docs/research-docs/azure-foundry/09-observability/09.2-tracing/07-register-external-agent.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Register external agents for observability and evaluation (preview)". Register third-party agents running on any host in Microsoft Foundry for tracing and evaluation, without migrating the runtime or provisioning an AI Gateway. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/register-external-agent). Article date: 2026-08-17. Page updated: 2026-09-14. Retrieved: 2026-09-29. Navigation: Observability > Tracing > Register external agents (preview).
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

> **Important**
>
> Items marked (preview) in this article are currently in public preview. This preview is provided without a service-level agreement, and we don't recommend it for production workloads. Certain features might not be supported or might have constrained capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

> **Important**
>
> When you use external agents with other Microsoft products and services, you must read all relevant documentation for such products and services and understand related risks and compliance considerations.
>
> If you use external agents with any third-party servers, agents, code, or non-Azure Direct models ("Third-Party Systems"), you do so at your own risk. Third-Party Systems are Non-Microsoft Products under the Microsoft Product Terms and are governed by their own third-party license terms. You're responsible for any usage and associated costs.
>
> We recommend reviewing all data being shared with and received from Third-Party Systems and being cognizant of third-party practices for handling, sharing, retention, and location of data. Similarly, if you connect to or integrate with non-Foundry Microsoft services and features, it is important to review their data practices. It is your responsibility to manage whether your data will flow outside of your organization’s compliance and geographic boundaries and any related implications, and that appropriate permissions, boundaries, and approvals are provisioned.
>
> You're responsible for carefully reviewing and testing applications you build in the context of your specific use cases and making all appropriate decisions and customizations. This includes implementing your own responsible AI mitigations, such as metaprompts, content filters, or other safety systems, and ensuring your applications meet appropriate quality, reliability, security, and trustworthiness standards. See the [Foundry Agent Service transparency note](11-trace-data.md).

Microsoft Foundry Agent Service lets you register agents that run outside Foundry, on any cloud, on-premises, or other host, so you can use Foundry's trace view and evaluation experiences. Foundry stores only registration metadata for these agents. It doesn't host, proxy, or invoke the runtime.

External agents differ from [Control Plane custom agents](../../13-manage-and-operate/13.2-govern-at-scale/04-register-custom-agent.md), which route traffic through an AI Gateway. With external agents, your agent keeps its existing endpoint and shares only OpenTelemetry telemetry. No AI Gateway is required.

In this article, you learn how to:

- Instrument an external agent to emit OpenTelemetry spans to Application Insights.
- Register the agent in Foundry as an `external` agent.
- Verify traces in the Foundry portal.
- Run a trace-based evaluation over the agent's collected telemetry.

The following diagram shows the data flow: your external agent emits OpenTelemetry spans with a `gen_ai.agent.id` attribute to an Application Insights resource connected to your Foundry project. A separate registration call creates the agent record in Foundry. The Foundry portal then matches traces by agent ID and displays them in the agent trace view.

[![Diagram that shows the data flow for external agent observability. The external agent emits OpenTelemetry spans to Application Insights, which connects to the Foundry portal trace view. A separate registration call creates the agent record in the Foundry project.](https://learn.microsoft.com/en-us/azure/foundry/agents/media/register-external/architecture.svg)](https://learn.microsoft.com/en-us/azure/foundry/agents/media/register-external/architecture.svg#lightbox)

> **Important**
>
> External agents are in preview. Create and update requests require the `Foundry-Features: ExternalAgents=V1Preview` header. SDK callers enable this by constructing `AIProjectClient` with `allow_preview=True`.

## Prerequisites

- A [Foundry project](../../13-manage-and-operate/13.1-set-up-and-configure/07-create-projects.md) with an [Application Insights resource connected](02-trace-agent-setup.md#connect-application-insights-to-your-foundry-project).
- An agent running outside Foundry that can emit OpenTelemetry spans to that Application Insights resource.
- Python 3.11 or later.
- **Foundry User** role on the project.
- **Reader** role or **Monitoring Reader** role on the connected Application Insights resource to view traces.

  > **Important**
  >
  > The Foundry RBAC roles were recently renamed. **Foundry User**, **Foundry Owner**, **Foundry Account Owner**, and **Foundry Project Manager** were previously named Azure AI User, Azure AI Owner, Azure AI Account Owner, and Azure AI Project Manager. You might still see the previous names in some places while the rename rolls out. The role IDs and core permissions are unchanged by the rename.
- `DefaultAzureCredential` configured. Sign in with `az login` or set up a managed identity or service principal.
- *(For evaluation only)* An Azure OpenAI deployment with a GPT model that supports chat completion (for example, `gpt-5-mini`).

## Instrument the external agent with OpenTelemetry

Before you register the agent in Foundry, configure it to export OpenTelemetry spans to the Application Insights resource connected to your Foundry project. Each span must carry the `gen_ai.agent.id` attribute so Foundry can attribute the span to the correct agent registration.

### Install the Microsoft OpenTelemetry package

```bash
pip install "microsoft-opentelemetry[langchain]"
```

### Configure the exporter

Run this code once during agent startup, before any framework imports that should be instrumented:

```python
import os

os.environ.setdefault("AZURE_EXPERIMENTAL_ENABLE_GENAI_TRACING", "true")
os.environ.setdefault("OTEL_SEMCONV_STABILITY_OPT_IN", "gen_ai_latest_experimental")
os.environ.setdefault("OTEL_INSTRUMENTATION_GENAI_CAPTURE_MESSAGE_CONTENT", "SPAN_AND_EVENT")

from microsoft.opentelemetry import use_microsoft_opentelemetry

# Human-readable name for the agent
AGENT_NAME = os.environ.get("AGENT_NAME", "weather-agent")
# Unique ID emitted as gen_ai.agent.id on every span.
# Foundry matches traces to registrations by this value.
OTEL_AGENT_ID = os.environ.get("OTEL_AGENT_ID", f"{AGENT_NAME}-v1")

use_microsoft_opentelemetry(
    enable_azure_monitor=True,
    azure_monitor_connection_string=os.environ["APPLICATIONINSIGHTS_CONNECTION_STRING"],
    sampling_ratio=1.0,
    instrumentation_options={
        "fastapi": {"enabled": False},
        "langchain": {
            "enabled": True,
            "agent_id": OTEL_AGENT_ID,
            "agent_name": AGENT_NAME,
        },
    },
)
```

Set the `APPLICATIONINSIGHTS_CONNECTION_STRING` environment variable on the host where the agent runs. Use the connection string from the Application Insights resource linked to your Foundry project. To find the connection string, open the [Foundry portal](https://ai.azure.com/), navigate to your project, and select **Manage** > **Project details** > **Connected resources**. Select the Application Insights resource to view its connection string. Alternatively, open the Application Insights resource directly in the Azure portal and copy the connection string from the **Overview** page.

After configuration, subsequent OpenTelemetry spans from your agent framework automatically flow to Application Insights. Each span must set the `gen_ai.agent.id` attribute to the value you choose as `otel_agent_id` during registration.

If your agent framework doesn't set this attribute automatically, add it manually:

```python
from opentelemetry import trace

tracer = trace.get_tracer(__name__)

with tracer.start_as_current_span("agent-run") as span:
    span.set_attribute("gen_ai.agent.id", "travel-planner-agent-v1")
    # ... your agent logic ...
```

> **Tip**
>
> For framework-specific auto-instrumentation (LangChain, LangGraph), the [Microsoft OpenTelemetry distro for Python](https://github.com/microsoft/opentelemetry-distro-python) can set `gen_ai.agent.id` automatically via `instrumentation_options`. For .NET and JavaScript, see the [.NET distro](https://github.com/microsoft/opentelemetry-distro-dotnet) and [JavaScript distro](https://github.com/microsoft/opentelemetry-distro-javascript). For general guidance, see [Configure tracing for AI agent frameworks](06-trace-agent-framework.md).

## Register the external agent in Foundry

After the agent emits spans to Application Insights, register it in Foundry so those spans appear in the Foundry trace view scoped to the agent. Registering creates a named record in Foundry that links incoming traces (matched by `gen_ai.agent.id`) to the Foundry agent experience. Without this registration, traces still flow into Application Insights but don't appear in the Foundry agent trace view, and you can't run trace-based evaluations scoped to the agent.

### Install the SDK

```bash
pip install azure-ai-projects>=2.3.0 azure-identity>=1.17.0
```

### Create the registration

**[Foundry portal]**

You can create a registration in the [Foundry portal](https://ai.azure.com/) by:

1. Opening your project and selecting **Build** > **Agents** > **New agent**.
2. Selecting **Link external agent**.
3. In the window that appears, entering the agent name, description, and the OpenTelemetry ID.

   [![Screenshot showing the button to link an external agent.](https://learn.microsoft.com/en-us/azure/foundry/agents/media/register-external/foundry-button.png)](https://learn.microsoft.com/en-us/azure/foundry/agents/media/register-external/foundry-button.png#lightbox)

**[Python SDK]**

Set the `FOUNDRY_PROJECT_ENDPOINT` environment variable to your project endpoint. You can find this value on the project's **Overview** page in the Foundry portal.

```python
import os
from azure.ai.projects import AIProjectClient
from azure.ai.projects.models import ExternalAgentDefinition
from azure.identity import DefaultAzureCredential

endpoint = os.environ["FOUNDRY_PROJECT_ENDPOINT"]

# Create the project client with preview features enabled.
project = AIProjectClient(
    endpoint=endpoint,
    credential=DefaultAzureCredential(),
    allow_preview=True,
)

# Register the externally hosted agent.
agent = project.agents.create_version(
    agent_name="travel-planner-agent",
    description="Travel planning agent hosted externally.",
    definition=ExternalAgentDefinition(
        # Set explicitly when the running agent emits a gen_ai.agent.id
        # value that differs from the Foundry agent name.
        otel_agent_id="travel-planner-agent-v1",
    ),
)

print(f"Registered external agent: {agent.name}")
print(f"Resolved otel_agent_id: {agent.versions.latest.definition.otel_agent_id}")
```

```output
Registered external agent: travel-planner-agent
Resolved otel_agent_id: travel-planner-agent-v1
```

> **Note**
>
> The `otel_agent_id` parameter is optional and defaults to the agent `name`. Set it explicitly only when the running agent already emits a stable `gen_ai.agent.id` value that differs from the Foundry agent name.

The `create_version()` method atomically creates the agent record and its first registration revision when called with a new name. External agents are versionless from the user's perspective. Edits to `otel_agent_id` create a new internal revision under the same name.

**[C# SDK]**

Set the `FOUNDRY_PROJECT_ENDPOINT` environment variable to your project endpoint. External agent support ships in the prerelease package, so install it with `dotnet add package Azure.AI.Projects.Agents --prerelease` and `dotnet add package Azure.Identity`.

```csharp
#pragma warning disable AAIP001
using System;
using Azure.AI.Projects.Agents;
using Azure.Identity;

var endpoint = Environment.GetEnvironmentVariable("FOUNDRY_PROJECT_ENDPOINT");

// External agents are in preview. The AAIP001 pragma opts in to the preview surface.
AgentAdministrationClient agentsClient = new(
    endpoint: new Uri(endpoint),
    tokenProvider: new DefaultAzureCredential());

// Register the externally hosted agent.
ExternalAgentDefinition definition = new()
{
    // Set explicitly when the running agent emits a gen_ai.agent.id
    // that differs from the Foundry agent name.
    OtelAgentId = "travel-planner-agent-v1",
};
ProjectsAgentVersionCreationOptions options = new(definition)
{
    Description = "Travel planning agent hosted externally.",
};
ProjectsAgentVersion agent = agentsClient.CreateAgentVersion(
    agentName: "travel-planner-agent",
    options: options,
    // Create and update requests require the ExternalAgents preview feature.
    foundryFeatures: "ExternalAgents=V1Preview");

Console.WriteLine($"Registered external agent: {agent.Name}");
```

```output
Registered external agent: travel-planner-agent
```

**[JavaScript/TypeScript SDK]**

Set the `FOUNDRY_PROJECT_ENDPOINT` environment variable to your project endpoint. Find this value on the project's **Overview** page in the Foundry portal.

Install the required packages:

```bash
npm install @azure/ai-projects @azure/identity
```

```typescript
import { AIProjectClient } from "@azure/ai-projects";
import { DefaultAzureCredential } from "@azure/identity";

const projectEndpoint =
  process.env["FOUNDRY_PROJECT_ENDPOINT"] || "<project endpoint>";

const project = new AIProjectClient(
  projectEndpoint,
  new DefaultAzureCredential(),
);

const agentName = "travel-planner-agent";
// Set explicitly when the running agent emits a gen_ai.agent.id value
// that differs from the Foundry agent name.
const otelAgentId = "travel-planner-agent-v1";

// Register the externally hosted agent. External agents are a preview
// feature, so the `ExternalAgents=V1Preview` opt-in is required.
const agent = await project.agents.createVersion(
  agentName,
  {
    kind: "external",
    otel_agent_id: otelAgentId,
  },
  {
    foundryFeatures: "ExternalAgents=V1Preview",
    description: "Travel planning agent hosted externally.",
  },
);

console.log(`Registered external agent: ${agent.name}`);
console.log(`Resolved otel_agent_id: ${otelAgentId}`);
```

```output
Registered external agent: travel-planner-agent
Resolved otel_agent_id: travel-planner-agent-v1
```

> **Note**
>
> The `otel_agent_id` field is optional and defaults to the agent `name`. Set it explicitly only when the running agent already emits a stable `gen_ai.agent.id` value that differs from the Foundry agent name.

The `createVersion()` method atomically creates the agent record and its first registration revision when called with a new name. External agents are versionless from the user's perspective. Edits to `otel_agent_id` create a new internal revision under the same name.

Reference: [AIProjectClient](https://learn.microsoft.com/en-us/javascript/api/overview/azure/ai-projects-readme)

## Verify traces in the Foundry portal

After the agent sends traffic and spans ingest into Application Insights (typically 2–5 minutes), verify that traces appear in the Foundry portal:

1. Open the [Foundry portal](https://ai.azure.com/).
2. Navigate to your project.
3. Select **Agents** from the left pane.
4. Select the external agent name (for example, **travel-planner-agent**).
5. Select the **Traces** tab to view spans attributed to this agent.

Traces are matched by `gen_ai.agent.id = <otel_agent_id>` from the Application Insights resource connected to the project. You can view inputs, outputs, tool calls, and latency for each span.

## Run a trace-based evaluation

After traces flow into Application Insights, you can run evaluations directly over those traces. No separate dataset construction is required. Foundry resolves traces by matching `(project, agent_id)` over a lookback window.

> **Note**
>
> Trace-based evaluations use the OpenAI-compatible `evals` API (`project.get_openai_client().evals`). The native `project.evaluations` surface doesn't yet support trace-based evaluation.

### Resolve the agent's otel_agent_id

To get the agent's ID for traces, use the following:

**[Foundry portal]**

Open the external agent in the Foundry portal to view its traces. To retrieve the resolved `otel_agent_id` in code, use one of the SDK tabs.

**[Python SDK]**

```python
# Retrieve the registered agent and its resolved otel_agent_id.
agent = project.agents.get(agent_name="travel-planner-agent")
otel_agent_id = agent.versions.latest.definition.otel_agent_id
```

**[C# SDK]**

```csharp
#pragma warning disable AAIP001
// Retrieve the registered agent and its resolved otel_agent_id.
ProjectsAgentRecord agent = agentsClient.GetAgent("travel-planner-agent");
if (agent.Versions.Latest.Definition is not ExternalAgentDefinition definition)
{
    throw new InvalidOperationException("Expected an external agent definition.");
}

string otelAgentId = definition.OtelAgentId;
```

**[JavaScript/TypeScript SDK]**

```typescript
// Retrieve the registered agent and its resolved otel_agent_id.
const agent = await project.agents.get("travel-planner-agent");
const definition = agent.versions.latest.definition;
if (definition.kind !== "external") {
  throw new Error(
    `Expected an external agent definition, got "${definition.kind}".`,
  );
}
const otelAgentId = definition.otel_agent_id;
```

### Create and run the evaluation

Use the `otel_agent_id` to run a trace evaluation over the agent's collected telemetry. External agents support trace-based evaluation of individual interactions. You can also evaluate multi-turn conversations by conversation ID when the agent emits a stable `gen_ai.conversation.id` and the required message attributes on its `invoke_agent` spans.

For walkthroughs that show how to create an evaluation, configure testing criteria, and interpret results, see:

- [Evaluate individual interactions from deployed models and agents](../../10-evaluation/10.3-run-evaluations/05-cloud-evaluation-deployed-interactions.md#evaluate-traces-preview).
- [Evaluate deployed model and agent conversations](../../10-evaluation/10.3-run-evaluations/08-cloud-evaluation-deployed-conversations.md).

## Manage external agents

Use the same SDK methods to list, retrieve, and delete external agents.

### List external agents

**[Foundry portal]**

In the Foundry portal, select **Build** > **Agents** to view registered external agents.

**[Python SDK]**

```python
agents = project.agents.list(kind="external")
for a in agents:
    print(a.name)
```

**[C# SDK]**

```csharp
#pragma warning disable AAIP001
foreach (ProjectsAgentRecord agent in agentsClient.GetAgents(kind: ProjectsAgentKind.External))
{
    Console.WriteLine(agent.Name);
}
```

**[JavaScript/TypeScript SDK]**

```typescript
const agents = project.agents.list({ kind: "external" });
for await (const agent of agents) {
  console.log(agent.name);
}
```

### Delete an external agent

**[Foundry portal]**

Use one of the SDK tabs to delete an external agent registration. Deleting the registration doesn't affect the externally hosted agent.

**[Python SDK]**

```python
# Delete the registration. This does not affect the running agent.
# force=True removes all internal revisions of the agent atomically.
project.agents.delete(agent_name="travel-planner-agent", force=True)
```

**[C# SDK]**

```csharp
#pragma warning disable AAIP001
// Delete the registration. This action doesn't affect the running agent.
// force: true removes all internal revisions of the agent atomically.
agentsClient.DeleteAgent(agentName: "travel-planner-agent", force: true);
```

**[JavaScript/TypeScript SDK]**

```typescript
// Delete the registration. This does not affect the running agent.
// force: true removes all internal revisions of the agent atomically.
await project.agents.delete("travel-planner-agent", { force: true });
```

Reference: [AIProjectClient](https://learn.microsoft.com/en-us/javascript/api/overview/azure/ai-projects-readme)

Deleting the registration removes the agent from the Foundry portal and stops traces from appearing in the Foundry agent trace view. The spans remain in Application Insights, and the running agent is not affected.

## Troubleshooting

### Troubleshoot missing traces

If you don't see traces, check the following items:

- The Application Insights resource is connected to the Foundry project where you registered the agent.
- The `otel_agent_id` on the registration matches the `gen_ai.agent.id` attribute on the spans.
- The agent process has `APPLICATIONINSIGHTS_CONNECTION_STRING` set to the correct Application Insights resource.
- Spans comply with [OpenTelemetry semantic conventions for generative AI](https://opentelemetry.io/docs/specs/semconv/gen-ai/).

For more troubleshooting guidance, see [Troubleshoot evaluation and observability issues](../02-troubleshooting.md).

### Troubleshoot registration errors

If `create_version()` (Python) or `createVersion()` (JavaScript/TypeScript) fails, check the following items:

- You constructed `AIProjectClient` with `allow_preview=True` (Python), or you passed `foundryFeatures: "ExternalAgents=V1Preview"` on the `createVersion` call (JavaScript/TypeScript). Without this opt-in, external agent requests are rejected.
- Your identity has the **Foundry User** role (or higher) on the project.
- The agent name value uses only alphanumeric characters, hyphens, and underscores.
- No existing agent with the same name and a different kind already exists. Use `project.agents.get()` to check.

## Current limitations

The following Foundry features aren't currently supported for external agents:

- [Human evaluation](../../10-evaluation/10.3-run-evaluations/14-human-evaluation.md) — Manual review workflows aren't available for externally registered agents.
- [Convert agent traces into evaluation datasets](08-traces-to-dataset.md) — Trace-to-dataset conversion isn't supported for external agents.
- [AI red teaming](../../10-evaluation/10.4-ai-red-teaming/01-ai-red-teaming-agent.md) — Red teaming scans can't target external agents.

## Related content

- [Agent tracing overview](01-trace-agent-concept.md)
- [Set up tracing in Microsoft Foundry](02-trace-agent-setup.md)
- [Configure tracing for AI agent frameworks](06-trace-agent-framework.md)
- [Evaluate your AI agents](../../10-evaluation/10.3-run-evaluations/01-evaluate-agent.md)
- [Register and manage custom agents (Control Plane)](../../13-manage-and-operate/13.2-govern-at-scale/04-register-custom-agent.md)
- [Built-in evaluators](../../10-evaluation/10.1-supported-evaluators/02-general-purpose-evaluators.md)
- [Azure Monitor OpenTelemetry overview](https://learn.microsoft.com/en-us/azure/azure-monitor/app/opentelemetry-enable)
- [Run cloud evaluations](../../10-evaluation/10.3-run-evaluations/02-cloud-evaluation.md)
