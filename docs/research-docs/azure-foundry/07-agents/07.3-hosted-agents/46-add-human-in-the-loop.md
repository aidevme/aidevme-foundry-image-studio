# Add a human-in-the-loop approval step (preview)

| Field | Value |
| --- | --- |
| **Document Title** | Add a human-in-the-loop approval step (preview) |
| **Document Location** | `docs/research-docs/azure-foundry/07-agents/07.3-hosted-agents/46-add-human-in-the-loop.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Add a human-in-the-loop approval step (preview)". Pause a long-running hosted agent indefinitely for human approval or input, then resume the conversation from where it left off. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/add-human-in-the-loop). Article date: 2026-08-05. Page updated: 2026-08-19. Retrieved: 2026-09-29. Navigation: Agents > Hosted agents > Build long-running agents (preview) > Add human-in-the-loop approval.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Some agent workflows must stop and wait for a person - to approve an action, answer a question, or provide missing input - and then continue. A [long-running hosted agent](04-long-running-agent-resilience.md) can pause indefinitely for that reply without holding a request open or losing its place, because a multi-turn chain persists between turns.

> **Note**
>
> Long-running agents are in preview. APIs and package versions are subject to change.

## How pause-and-resume works

A `@multi_turn_task` chain doesn't end when a turn returns - it moves to the `suspended` state and stays alive under one `task_id`. The next input on the same `task_id` reenters the same handler with `ctx.entry_mode == "resumed"`. That is the natural shape for a human-in-the-loop pause:

1. The agent does work until it needs a human decision.
2. It returns a turn that asks for the decision (the chain suspends).
3. A person replies; your app starts a new turn on the same `task_id`.
4. The handler resumes and continues with the human's answer.

Because the chain is durable, the wait can be arbitrarily long - minutes, hours, or days - and survives container restarts.

## Implement the approval turn

```python
from azure.ai.agentserver.core.tasks import multi_turn_task, TaskContext

@multi_turn_task(name="expense-approval")
async def approve(ctx: TaskContext[dict]) -> dict:
    if ctx.entry_mode == "resumed":
        # We're back with the human's decision.
        decision = ctx.input["decision"]
        if decision == "approved":
            await submit_expense(ctx.metadata["expense_id"])
            return {"status": "submitted"}
        return {"status": "rejected"}

    # First turn: prepare the request and ask for a decision.
    expense = await build_expense(ctx.input)
    ctx.metadata["expense_id"] = expense.id          # small watermark, survives the pause
    return {"status": "awaiting_approval", "summary": expense.summary}
```

Drive it from your application:

```python
# Turn 1 - agent produces an approval request, then the chain suspends.
r1 = await approve.run(task_id="exp-42", input={"amount": 1200, "category": "travel"})
# ... show r1["summary"] to a human and wait for their reply (could be much later) ...

# Turn 2 - same task_id resumes the suspended chain.
r2 = await approve.run(task_id="exp-42", input={"decision": "approved"})
```

> **Tip**
>
> Keep only small references in `ctx.metadata` (an expense ID, a step number). Store the full request, history, or generated artifacts in your own storage or a framework checkpoint. See [Manage state for long-running agents](48-manage-task-state.md).

## Use a framework interrupt with Responses

If you build on an agent framework (for example, LangGraph or Microsoft Agent Framework) over a background response, use the framework's own interrupt and approval mechanism. Keep the response resilient so the pause survives a restart. Set `resilient_background=True` and persist the framework's checkpoint at the interrupt point. On resume, rebuild from that checkpoint. See [Recover long-running work after a crash](43-recover-long-running-work.md).

## Clean up a finished chain

You delete a suspended chain only when you delete it explicitly. The system automatically cleans up one-shot `@task` records when they complete.

```python
await approve.delete("exp-42")
```

## Related content

- [Resilience for long-running hosted agents](04-long-running-agent-resilience.md)
- [Long-running agent API reference](06-long-running-agent-reference.md)
- [Steer an in-flight agent turn](44-steer-hosted-agent.md)
- [Manage state for long-running agents](48-manage-task-state.md)
- [Recover long-running work after a crash](43-recover-long-running-work.md)
