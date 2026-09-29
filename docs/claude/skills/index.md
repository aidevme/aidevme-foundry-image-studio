# Skills overview

| Field | Value |
| --- | --- |
| **Document Title** | Skills overview |
| **Document Location** | `docs/claude/skills/index.md` |
| **Document Description** | Explains what a Claude Code skill is in aidevme-foundry-image-studio, the skill folder convention, the list of skills, and how to add a skill. It is intended for contributors who use or maintain skills. |
| **Version** | 1.0 |
| **Last Updated On** | 2026-09-29 |

## Introduction

A skill is a reusable set of instructions that Claude Code loads when a task matches the skill description. Skills in this repository are stored in `.claude/skills/` and are shared with the team through version control. Read this document to find the available skills and to add a new one.

## Skill folder structure

Each skill has its own folder under `.claude/skills/`, named after the skill in lowercase with hyphens.

```text
.claude/skills/<skill-name>/
├── SKILL.md
├── evals/
│   └── evals.json
├── references/
└── scripts/
```

| Path | Required | Purpose |
| --- | --- | --- |
| `SKILL.md` | Yes | Frontmatter (`name`, `description`) and the instructions |
| `evals/evals.json` | Recommended | Test cases with prompts and assertions |
| `references/`, `scripts/` | No | Supporting files that the skill reads or runs |

> **Note:** The existing skill uses only `SKILL.md` and `evals/evals.json`. The `references/` and `scripts/` folders are optional Claude Code conventions and no skill in this repository uses them yet.

Agents preload a skill through a `skills:` list in the frontmatter of their definition in `.claude/agents/`.

## Skills

| Skill | Purpose | Preloaded by |
| --- | --- | --- |
| [write-document](write-document.md) | Applies the repository document style when creating or editing files under `docs/` | [documenter](../agents/documenter.md) |

## Add a skill

1. Create the folder `.claude/skills/<skill-name>/`.
2. Create `SKILL.md` with frontmatter that contains `name` and a specific `description`, then write the steps and constraints.
3. Link to existing documents in the skill instead of copying their rules.
4. Add `evals/evals.json` with test cases. Follow the structure in the [write-document evals](../../../.claude/skills/write-document/evals/evals.json).
5. To preload the skill in an agent, add the skill name to the `skills:` list in `.claude/agents/<agent>.md`, and update the matching [agent document](../agents/documenter.md).
6. Create `docs/claude/skills/<skill-name>.md` from the [Generic Document Style](../../templates/GENERIC_DOCUMENT_STYLE.md) template.
7. Add the skill to the table in this document and to [docs/index.md](../../index.md).

## Related documents

- [write-document skill](write-document.md)
- [Generic Document Style](../../templates/GENERIC_DOCUMENT_STYLE.md)
- [Agent documents](../../index.md#claudeagents)
