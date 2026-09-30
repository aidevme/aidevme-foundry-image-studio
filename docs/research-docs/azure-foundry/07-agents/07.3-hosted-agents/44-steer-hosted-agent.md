# Steer an in-flight agent turn (preview)

| Field | Value |
| --- | --- |
| **Document Title** | Steer an in-flight agent turn (preview) |
| **Document Location** | `docs/research-docs/azure-foundry/07-agents/07.3-hosted-agents/44-steer-hosted-agent.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Steer an in-flight agent turn (preview)". Let a new input redirect a hosted agent's in-flight turn instead of racing or rejecting it, using steerable conversations and the steering queue. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/steer-hosted-agent). Article date: 2026-08-05. Page updated: 2026-09-23. Retrieved: 2026-09-29. Navigation: Agents > Hosted agents > Build long-running agents (preview) > Steer an in-flight turn.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

*Steering* lets you redirect a [long-running hosted agent](04-long-running-agent-resilience.md) while it's still working. A new input queues behind the active turn and the running handler cooperatively winds down. This approach avoids rejecting the new turn or racing two turns at once.

> **Note**
>
> Long-running agents are in preview. APIs and package versions are subject to change.

## Turn on steering

### Responses protocol

Set `steerable_conversations=True` on `ResponsesServerOptions`:

```python
app = ResponsesAgentServerHost(
    options=ResponsesServerOptions(steerable_conversations=True),
)
```

A second turn that arrives on a busy conversation queues and the current handler cooperatively cancels. This approach avoids returning `409 conversation_locked`. Send the follow-up as a new response with `previous_response_id` set to the running response and the same `agent_session_id`.

### Invocations and task primitives

Pass `steerable=True` to `@multi_turn_task`:

```python
@multi_turn_task(name="conv", steerable=True)
async def conv(ctx: TaskContext[dict]) -> dict:
    return await llm(ctx.input)

# A .start() against an in-flight chain queues instead of raising.
r1 = asyncio.create_task(conv.start(task_id="c1", input={"msg": "Plan a trip to Rome"}))
await asyncio.sleep(0.05)
r2 = asyncio.create_task(conv.start(task_id="c1", input={"msg": "Actually, Paris"}))
# r1 resolves with turn 1's outcome; r2 resolves with turn 2's outcome.
```

Without `steerable=True`, a concurrent `.start()` on an in-flight chain raises `TaskConflictError`.

## Wind down the active turn

When something is queued, the framework signals the running handler through the cooperative cancel signal. A steerable handler should check for it at safe boundaries and return early so the queued turn can take over:

```python
@multi_turn_task(name="conv", steerable=True)
async def conv(ctx: TaskContext[dict]) -> dict:
    for step in plan:
        if ctx.cancel.is_set() and ctx.pending_input_count > 0:
            # A newer turn is waiting - stop at this boundary and let it run.
            return partial_result
        await do_step(step)
    return final_result
```

Steering observability on the context:

| Field | Meaning |
| --- | --- |
| `ctx.is_steered_turn` | `True` if this turn was promoted from the queue. |
| `ctx.pending_input_count` | How many newer turns are currently queued. |
| `ctx.cancel` | Cooperative cancel signal; set when a queued turn is waiting. |

## Order turns with a precondition

When a client reasons about message ordering, pass `if_last_input_id` so a stale caller can't append after another caller has advanced the chain. It's the input-queue equivalent of an HTTP `If-Match`:

```python
await conv.start(task_id="c1", input=new_msg, if_last_input_id=prev_input_id)
```

If the chain's last accepted input no longer matches, the call raises `LastInputIdPreconditionFailed`.

## Handle a full queue

The steering queue is bounded. When it's full, an enqueue raises `SteeringQueueFull`; surface a clear "please wait" signal to the user rather than dropping the input silently:

```python
try:
    run = await conv.start(task_id="c1", input=new_msg)
except SteeringQueueFull:
    return {"status": "busy", "detail": "Too many pending turns; try again shortly."}
```

Steerable conversations are sequential, not forked: newer input can queue behind or interrupt the active turn, but the conversation still has one latest turn and one ordered history.

## Related content

- [Resilience for long-running hosted agents](04-long-running-agent-resilience.md)
- [Long-running agent API reference](06-long-running-agent-reference.md)
- [Deploy a steerable agent](42-deploy-steerable-agent.md)
- [Add a human-in-the-loop approval step](46-add-human-in-the-loop.md)
- [Recover long-running work after a crash](43-recover-long-running-work.md)
- [Cancel a hosted agent turn](45-cancel-hosted-agent-turn.md)
