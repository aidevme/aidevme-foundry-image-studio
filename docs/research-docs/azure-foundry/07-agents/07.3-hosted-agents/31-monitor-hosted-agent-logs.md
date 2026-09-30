# Monitor hosted agent logs with the Azure Developer CLI

| Field | Value |
| --- | --- |
| **Document Title** | Monitor hosted agent logs with the Azure Developer CLI |
| **Document Location** | `docs/research-docs/azure-foundry/07-agents/07.3-hosted-agents/31-monitor-hosted-agent-logs.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Monitor hosted agent logs with the Azure Developer CLI". Stream and inspect Microsoft Foundry hosted agent logs with azd to troubleshoot sessions, container events, and runtime behavior. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/monitor-hosted-agent-logs). Article date: 2026-07-21. Page updated: 2026-07-21. Retrieved: 2026-09-29. Navigation: Agents > Hosted agents > Run, test, and debug > View logs.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Stream and inspect logs from your deployed Microsoft Foundry hosted agent for troubleshooting and observability. You learn how to view console logs, stream in real time, inspect system events, filter by session, and recognize common log patterns.

## Prerequisites

- A deployed hosted agent. To deploy one, see [Deploy a hosted agent](49-deploy-hosted-agent.md).
- The azd Foundry extensions installed. For installation steps, see [Install the azd Foundry extensions](../../05-developer-tools-and-integrations/05.1-azure-developer-cli/02-install-cli-foundry-extensions.md).
- An authenticated Azure Developer CLI session. Run `azd auth login` if needed.
- For session-specific logs, a session ID from an `azd ai agent invoke` response. To invoke an agent, see [Invoke a hosted agent with the Azure Developer CLI](26-invoke-hosted-agent.md).

## View recent console logs

- Fetch recent console logs:

  ```bash
  azd ai agent monitor
  ```

  This command fetches recent console logs, including stdout and stderr, from the agent's last invoke session. If no session exists, it streams container logs. The command exits after fetching the available logs. Use `--follow` to stream continuously.

## Stream logs in real time

- Stream logs continuously:

  ```bash
  azd ai agent monitor --follow
  ```

  Press **Ctrl+C** to stop. This is the most useful mode for debugging. Run it in one terminal while sending requests in another.

## View system event logs

- Show container lifecycle events instead of console output:

  ```bash
  azd ai agent monitor --type system
  ```

  Use system event logs to diagnose container crashes, restart loops, and resource issues.

## View session-specific logs

- Filter logs to a specific agent session:

  ```bash
  azd ai agent monitor --session-id <session-id>
  ```
- Combine with `--follow` for real-time streaming:

  ```bash
  azd ai agent monitor --session-id <session-id> --follow
  ```

  To find session IDs, check the output of `azd ai agent invoke`. It prints the session ID for each request.

## Control log length

- Show the last 100 lines:

  ```bash
  azd ai agent monitor --tail 100
  ```

  The range is 1-300. The default is 50.

## Monitor a specific agent

- In multi-service projects, pass the agent name:

  ```bash
  azd ai agent monitor my-agent
  ```

## Recognize common log patterns

| Pattern | Meaning | Action |
| --- | --- | --- |
| `Listening on 0.0.0.0:8088` | Agent started successfully. | None needed. |
| `AuthenticationError` | The agent's Entra Agent Identity can't authenticate. | Check RBAC roles. |
| `ModelNotFound` | Model deployment name mismatch. | Verify the deployment name in `azure.yaml` matches the Foundry portal. |
| `ResourceNotFound` | Foundry endpoint mismatch. | Check `FOUNDRY_PROJECT_ENDPOINT` value. |
| Container restart events in system logs | Crash loop. | Check code for unhandled exceptions; consider increasing container resource limits in `azure.yaml`. |
| `TimeoutError` | Request took too long. | Check model responsiveness; increase timeout on invoke. |

## Follow a debugging workflow

A typical debugging session looks like this:

1. Stream logs in one terminal:

   ```bash
   azd ai agent monitor --follow
   ```
2. Send a request in another terminal:

   ```bash
   azd ai agent invoke "Test message"
   ```
3. Watch the logs for error patterns or unexpected behavior.
4. Check system events if the agent seems unresponsive:

   ```bash
   azd ai agent monitor --type system
   ```

For a comprehensive debugging workflow, see [Debug a hosted agent](29-debug-hosted-agent.md).

## Related content

- [Debug a hosted agent](29-debug-hosted-agent.md) for step-by-step diagnostic workflows.
- [Test a hosted agent](28-test-hosted-agent.md) for validation strategies before production.
- [Isolate hosted agent sessions per user](34-isolate-sessions-per-user.md) for logs in isolated sessions.
