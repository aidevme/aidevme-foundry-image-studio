# documenter agent

| Field | Value |
| --- | --- |
| **Document Title** | documenter agent |
| **Document Location** | `docs/project-docs/claude/agents/documenter.md` |
| **Document Description** | Describes the documenter subagent, which writes and updates documentation for aidevme-foundry-image-studio according to the repository document style. It is intended for contributors who use Claude Code subagents. |
| **Version** | 3.3 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The documenter agent writes and updates documentation. It does not write application code. The agent loads the [write-document skill](../skills/write-document.md), which applies the [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md). Read this document to learn what the agent produces and which rules it follows. The agent runs as a Claude Code subagent, and its definition is in [.claude/agents/documenter.md](../../../../.claude/agents/documenter.md).

## Configuration

| Setting | Value |
| --- | --- |
| Model | `sonnet` |
| Tools | `Read`, `Write`, `Edit`, `Grep`, `Glob` |
| Skills | `write-document` |
| Memory | `project` (`.claude/agent-memory/documenter/`) |

## When to use the agent

Provide what changed or what is undocumented, or request a full documentation review. Typical targets are:

- README sections
- Content under `docs/`
- Model Context Protocol (MCP) server usage and tool reference
- Agent skill descriptions
- Setup and deployment guides

The agent reviews all documents on every invocation, so a request for one document also results in a check of the others. See [Documentation review](#documentation-review).

## Behavior

The agent performs these actions:

1. Reads the actual code or configuration for the subject and does not describe behavior from the request alone when the implementation is available.
2. Follows the [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md) through the `write-document` skill. The style defines the metadata header, the document structure, and the writing rules.
3. Documents what a user or integrator needs: how to configure the MCP server, how model routing decisions are made and how to override them, how to add a specialist agent or skill, and which environment variables and credentials are required.
4. Keeps the text accurate instead of exhaustive, and omits internal details that are not part of a usable interface.
5. Links to existing documents instead of restating their content.
6. Updates the version and the last-updated date of a changed document, and updates [docs/index.md](../../../index.md).

## Documentation review

On every invocation, the agent reviews all documents, not only the documents named in the request. It performs these steps:

1. Lists and reads every Markdown file under `docs/`, plus `README.md`, `CONTRIBUTING.md`, and `CLAUDE.md`.
2. Checks each document against the [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md). It verifies the header fields, the match between Document Location and the actual path, the structure, and the writing style.
3. Checks each document against the current repository. It compares agent documents with `.claude/agents/` and `.claude/skills/`, verifies that links and file paths resolve, and identifies statements that no longer match the code or configuration.
4. Checks that [docs/index.md](../../../index.md) lists every document under `docs/` and lists no document that does not exist.
5. Updates each document that needs a change. It increases the version and the last-updated date only for documents that it changes, and it leaves correct documents untouched.
6. Reports the result for each document as updated (with the reason and the new version), already correct, or requiring a decision from you.

The agent does not invent content to fill a gap. It flags the gap instead.

## Document header

Every document that the agent creates or updates contains a header with these fields: Document Title, Document Location, Document Description, Version, and Last Updated On. The versioning rules are in the [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md#versioning).

## Output

The agent returns the documents it created or changed and their versions, and a per-document review result. It flags anything it could not verify against code or configuration, such as an inferred environment variable name.

## Agent memory

The agent has persistent project memory. The memory files are stored in `.claude/agent-memory/documenter/` and are shared with the team through version control.

- Before the agent starts, it reads its memory directory.
- After the agent finishes, it records durable learnings only, such as terminology decisions, recurring style corrections, and flagged gaps that still need a decision from you.
- The agent does not store information that it can read from the repository, and it never stores secrets or credentials.

Review memory files in pull requests like any other file. Delete a memory file to make the agent forget its content. For the current contents and the reset procedure, see the [documenter agent memory](../agent-memory/documenter.md).

## Example request

```text
Use the documenter agent to document how to add a new specialist agent.
```

```text
Use the documenter agent to review all documents and update the ones that need it.
```

## Related documents

- [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md): the style that the agent applies
- [write-document skill](../skills/write-document.md): the skill that loads the style
- [Skills overview](../skills/index.md): the skill folder convention and how to add a skill
- [developer agent](developer.md): supplies the changes that the documenter records
