# Stream long-running agent output with reconnect (preview)

| Field | Value |
| --- | --- |
| **Document Title** | Stream long-running agent output with reconnect (preview) |
| **Document Location** | `docs/research-docs/azure-foundry/07-agents/07.3-hosted-agents/47-stream-with-reconnect.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Stream long-running agent output with reconnect (preview)". Stream a hosted agent's output so clients can drop and reconnect without losing events, using the streaming registry, backings, and the starting_after cursor. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/stream-with-reconnect). Article date: 2026-08-05. Page updated: 2026-08-19. Retrieved: 2026-09-29. Navigation: Agents > Hosted agents > Build long-running agents (preview) > Stream with reconnect.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

A [long-running hosted agent](04-long-running-agent-resilience.md) can stream output for minutes. Clients disconnect and reconnect, and the container itself can restart mid-turn. This article shows how to stream so subscribers catch up cleanly after a drop, and how a crashed producer resumes the same stream.

> **Note**
>
> Long-running agents are in preview. APIs and package versions are subject to change.

## The streaming model in brief

An event stream connects a producer (your agent work) to one or more subscribers (SSE, WebSocket, or polling). Two rules matter most:

- **Use a per-turn stream ID.** Identify one request, turn, or invocation - never reuse a multiturm conversation ID as the stream ID.
- **Choose a backing that matches the recovery you need.** The backing decides whether late subscribers can replay and whether the stream survives a restart.

## Choose a backing

With the Invocations and task primitives, pick a backing once at app startup, then look streams up by ID anywhere in your process:

```python
from azure.ai.agentserver.core.streaming import streams

# Pick ONE at startup.
streams.use_in_memory_live()                                   # no replay, no restart survival
streams.use_in_memory_replay(cursor_fn=lambda ev: ev["n"],     # replay within a TTL
                             ttl_seconds=600)
streams.use_file_backed_replay(storage_dir=Path("/streams"),   # replay AND survives restart
                               cursor_fn=lambda ev: ev["n"])
```

| Backing | Replay for late or reconnecting subscribers | Survives process restart |
| --- | --- | --- |
| `use_in_memory_live()` (default) | No | No |
| `use_in_memory_replay(...)` | Yes, within `ttl_seconds` | No |
| `use_file_backed_replay(...)` | Yes | Yes |

For HTTP surfaces, prefer a replay backing so a subscriber can attach late without racing the producer. Choose `use_file_backed_replay` when a producer might crash and a fresh worker must resume the same turn.

> **Important**
>
> Pass `cursor_fn` if you want cursored reconnect. It receives each event and returns an `int` cursor (a monotonically increasing sequence number is typical). Without it, `subscribe(after=...)` is ignored and `last_cursor()` returns `None`.

## Produce and subscribe

The producer and subscriber both call `get_or_create(id)` with the same ID and get the same stream:

```python
# Producer (your @task handler)
async def produce(stream_id: str) -> None:
    stream = await streams.get_or_create(stream_id)
    try:
        for n in range(total):
            await stream.emit({"n": n, "delta": chunk})
    finally:
        await stream.close()

# Subscriber (your HTTP layer) - reconnect with the last cursor seen
async def consume(stream_id: str, last_seen: int | None) -> None:
    stream = await streams.get_or_create(stream_id)
    async for event in stream.subscribe(after=last_seen):
        yield event
```

After a crash, a file-backed producer reads the last persisted cursor and continues emitting from the next one - the same cursor is both the client's reconnect primitive and the producer's recovery primitive. Don't mirror stream cursors into task metadata; the stream log already owns stream progress.

## Reconnect with the Responses protocol

The Responses protocol manages the SSE stream for you. A client reconnects by replaying from a cursor:

```http
GET /responses/{id}?stream=true&starting_after=<sequence_number>
```

The server resumes emitting after that sequence number.

> **Important**
>
> Teach clients that any `response.in_progress` event *after the first one* is a **snapshot reset**. On such an event the client replaces its local output with the snapshot in the event, discards partially accumulated content, and applies later events additively. Treat output indexes as slot identifiers, not monotonic counters - after a reset, an index might refer to an already-existing slot.

## Stream lifecycle

Streams move from active to closed, then eventually to destroyed. Closing a stream stops new emits, lets current subscribers drain, and (with a replay backing) still lets late subscribers replay retained history until it expires. Destruction happens through explicit delete, unknown IDs, or TTL cleanup after close.

## Related content

- [Resilience for long-running hosted agents](04-long-running-agent-resilience.md#replay-streamed-output)
- [Long-running agent API reference](06-long-running-agent-reference.md)
- [Recover long-running work after a crash](43-recover-long-running-work.md)
- [Manage state for long-running agents](48-manage-task-state.md)
