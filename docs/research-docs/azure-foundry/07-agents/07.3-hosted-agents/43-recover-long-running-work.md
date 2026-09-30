# Recover long-running work after a crash (preview)

| Field | Value |
| --- | --- |
| **Document Title** | Recover long-running work after a crash (preview) |
| **Document Location** | `docs/research-docs/azure-foundry/07-agents/07.3-hosted-agents/43-recover-long-running-work.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Recover long-running work after a crash (preview)". Make a hosted agent's background responses crash-recoverable, and resume a recovered run from its last checkpoint instead of rerunning the whole turn. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/recover-long-running-work). Article date: 2026-08-05. Page updated: 2026-09-23. Retrieved: 2026-09-29. Navigation: Agents > Hosted agents > Build long-running agents (preview) > Recover work after a crash.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

A [long-running hosted agent](04-long-running-agent-resilience.md) can be interrupted at any time by a crash, an out-of-memory kill, a redeploy, or a scale-in. This article shows how to make your agent's background responses recoverable and how to resume a recovered run from its last checkpoint.

> **Note**
>
> Long-running agents are in preview. APIs and package versions are subject to change.

## Turn on crash recovery

Crash recovery is **off by default**. Enable it explicitly for the surface you use.

### Responses protocol

Set `resilient_background=True` on `ResponsesServerOptions`:

```python
from azure.ai.agentserver.responses import ResponsesAgentServerHost, ResponsesServerOptions

app = ResponsesAgentServerHost(
    options=ResponsesServerOptions(resilient_background=True),
)
```

Recovery applies only to responses that are **stored and run in the background** - that is, requests with `store=true` and `background=true`. When you enable the opt-in and the container crashes mid-response, the framework reinvokes your handler on restart, replays persisted stream events to reconnecting clients, and preserves conversation state.

> **Important**
>
> Without `resilient_background=True`, a background response that crashes is marked `failed` with `error.code="server_error"` - the framework does **not** reinvoke the handler. Foreground (`background=false`) responses are always marked `failed` on crash, because their client connection is already gone.

### Invocations / task primitives

When you build directly on the task primitives, you opt in to the resilient task subsystem. Call `set_resilient_tasks_enabled(True)` before host startup so the framework constructs the `TaskManager` and runs the startup recovery scan. Without it, `get_task_manager()` raises `TaskManagerNotInitialized` and `.run()` and `.start()` can't run a task. Declaring a `@task` doesn't enable the subsystem on its own:

```python
from azure.ai.agentserver.core.tasks import set_resilient_tasks_enabled

set_resilient_tasks_enabled(True)   # call at import time, before host lifespan startup
```

## What you get for free

When you turn on recovery, you get the framework half with no handler changes:

| Behavior | Detail |
| --- | --- |
| Handler reinvocation | The restarted container reenters your handler with the same request, input, and metadata. |
| Stream replay | Persisted SSE events replay to reconnecting clients. |
| Conversation lock | Prevents concurrent conflicting writes to the same conversation. |
| No-op cleanup | Marks nonrecoverable responses `failed` instead of silently rerunning them. |

A naive recovered handler still produces a correct response - it just reruns the whole turn. Making the recovered attempt *resume where it left off* is the handler half you take on when you need it.

## Detect a recovered entry

On reinvocation, branch on the recovery marker rather than reconstructing the original request.

**[Responses]**

```python
@app.response_handler
async def handler(request, context, cancellation_signal):
    if context.is_recovery:
        # Seed from the last checkpoint instead of starting over.
        stream = ResponseEventStream.from_snapshot(context.persisted_response)
        start_phase = len(stream.response.output)   # completed, checkpointed phases
    else:
        stream = ResponseEventStream(response_id=context.response_id, request=request)
        start_phase = 0
    ...
```

**[Tasks]**

```python
@multi_turn_task(name="research")
async def research(ctx: TaskContext[dict]) -> dict:
    if ctx.entry_mode == "recovered":
        last_done = ctx.metadata.get("last_done_step", 0)   # resume from watermark
    else:
        last_done = 0
    ...
```

`ctx.entry_mode` is one of `"fresh"`, `"resumed"` (a later turn of a chain), or `"recovered"` (a previous lifetime didn't finish and the framework is reinvoking with the persisted input).

## Choose a resume strategy

Pick a strategy based on where your progress state lives.

| Strategy | Where progress lives | Recovery behavior |
| --- | --- | --- |
| Naive rerun | Nowhere | Rerun the whole turn. Correct, but unsafe for non-idempotent side effects unless they're fenced. |
| Framework checkpoints | Persisted response snapshots | Seed from `context.persisted_response`, resume after the checkpointed output items. |
| Upstream-owned resume | Your framework or app store | Rebuild from an agent-framework checkpoint or your database. See [Manage state for long-running agents](48-manage-task-state.md). |
| Watermark overlay | Small metadata watermarks | Combine with any strategy to avoid repeating side effects the upstream can't deduplicate. |

Prefer phase boundaries that checkpoint cleanly: complete one output item per phase, then checkpoint. If a phase crashes before its checkpoint it reruns; after the checkpoint the recovered attempt skips it.

## Fence non-idempotent side effects

Before an action an upstream system can't deduplicate (for example, sending an email or charging a card), stamp and flush a watermark, then clear it after the side effect commits:

```python
context.conversation_chain_metadata["email_sent"] = True
await context.conversation_chain_metadata.flush()   # fence before the side effect
await email_service.send(...)
```

## Handle graceful shutdown

Graceful shutdown is different from terminal failure. A handler that can't finish during shutdown should defer for recovery so the record stays in progress and a later lifetime reclaims it:

```python
if context.is_shutting_down:      # or ctx.shutdown.is_set() for tasks
    await context.exit_for_recovery()   # leaves the response in_progress for re-invocation
```

Crash recovery reenters the same attempt state; it doesn't consume retry budget, and a wall-clock timeout doesn't reset because the process restarted.

## Related content

- [Resilience for long-running hosted agents](04-long-running-agent-resilience.md)
- [Long-running agent API reference](06-long-running-agent-reference.md)
- [Deploy a crash-resilient long-running agent](41-deploy-resilient-agent.md)
- [Manage state for long-running agents](48-manage-task-state.md)
- [Stream with reconnect](47-stream-with-reconnect.md)
- [Cancel a hosted agent turn](45-cancel-hosted-agent-turn.md)
