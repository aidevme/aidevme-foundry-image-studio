# Deploy a steerable agent (preview)

| Field | Value |
| --- | --- |
| **Document Title** | Deploy a steerable agent (preview) |
| **Document Location** | `docs/research-docs/azure-foundry/07-agents/07.3-hosted-agents/42-deploy-steerable-agent.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Deploy a steerable agent (preview)". Deploy a hosted agent that accepts a new instruction mid-run, cooperatively winding down the in-flight turn and continuing with the redirected input. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/deploy-steerable-agent). Article date: 2026-08-20. Page updated: 2026-09-23. Retrieved: 2026-09-29. Navigation: Agents > Hosted agents > Build long-running agents (preview) > Deploy a steerable agent (preview).
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

In this article, you deploy a [long-running hosted agent](04-long-running-agent-resilience.md) that supports *steering*: when a second turn arrives on the same conversation while the first turn is still running, the platform queues the new turn and cooperatively cancels the current one instead of rejecting it with `409 conversation_locked`.

The sample is a Responses protocol agent that turns on resilience and steering with two options. It uses a simulated model stream, so you can run it without model credentials.

> **Note**
>
> Long-running agents are in preview. APIs and package versions are subject to change.

## Prerequisites

- An Azure subscription with Microsoft Foundry access.
- [Python 3.13](https://www.python.org/downloads/).
- The [Azure Developer CLI (`azd`)](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd) with the Foundry agents extension (`azd extension install azure.ai.agents`), version `azd-ext-azure-ai-agents_1.0.0-beta.16` or later for the `--long-running` invoke flag and the `invocations` lifecycle commands. `azd` handles authentication when it calls the deployed agent.

## Get the sample

In an empty directory, initialize the resilient steering agent from its `azure.yaml` manifest:

```bash
azd auth login
azd ai agent init -m https://github.com/microsoft-foundry/foundry-samples/blob/main/samples/python/hosted-agents/bring-your-own/responses/resilient-steering/azure.yaml
```

The command downloads the sample source, adopts its `azure.yaml`, creates an azd environment, and connects it to the Foundry project you select.

The agent enables resilience and steering when it constructs the host:

```python
options = ResponsesServerOptions(
    resilient_background=True,
    steerable_conversations=True,
)
app = ResponsesAgentServerHost(options=options)
```

By using `steerable_conversations=True`, a second turn on a busy conversation is queued and the running handler is cooperatively cancelled, rather than returning `409 conversation_locked`.

## Provision and deploy

Provision the project and deploy the agent. When prompted for a location, choose a [region that supports hosted agents](01-hosted-agents.md#region-availability).

```bash
azd up
```

`azd up` prints the Responses endpoint and a playground link.

## Steer the deployed agent

Steering redirects an in-flight turn, so the first turn must keep running while you send the second. Start the first turn as a long-running background response in a fresh conversation, and return immediately with `--no-wait`:

```bash
azd ai agent invoke --long-running --no-wait --new-session "Explain quantum computing in detail, including its history, principles, algorithms, hardware, error correction, and applications."
```

`--long-running` sends `store=true` and `background=true`, and `azd ai agent invoke` reuses that conversation on your next invocation by default. While the first turn is still running, send a new instruction to steer the in-flight turn. Omit `--no-wait` this time so the CLI stays attached and streams the steered turn through completion:

```bash
azd ai agent invoke --long-running "Instead, explain relativity and focus on practical examples."
```

The first turn observes the queued input and winds down at its next safe point. The queued turn then streams to completion in your terminal, so you can watch the handoff. To replay a specific response by ID instead, use `azd ai agent invocations follow --id <response-id>`.

## Clean up

```bash
azd down
```

## Related content

- [Resilience for long-running hosted agents](04-long-running-agent-resilience.md)
- [Steer an in-flight agent turn](44-steer-hosted-agent.md)
- [Add a human-in-the-loop approval step](46-add-human-in-the-loop.md)
- [Deploy a crash-resilient long-running agent](41-deploy-resilient-agent.md)
