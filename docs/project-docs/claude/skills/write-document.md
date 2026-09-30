# write-document skill

| Field | Value |
| --- | --- |
| **Document Title** | write-document skill |
| **Document Location** | `docs/project-docs/claude/skills/write-document.md` |
| **Document Description** | Describes the write-document skill, which applies the repository document style when Claude Code creates or edits documentation. It is intended for contributors who use, test, or maintain the skill. |
| **Version** | 1.2 |
| **Last Updated On** | 2026-09-30 |

## Introduction

The `write-document` skill instructs Claude Code how to create or edit a documentation file in aidevme-foundry-image-studio. It delegates all style rules to the [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md) and adds a fixed workflow around them. Read this document to learn when the skill applies, what it does, and how to test and maintain it. For the general skill concept and folder convention, see the [skills overview](index.md). The skill definition is in [.claude/skills/write-document/SKILL.md](../../../../.claude/skills/write-document/SKILL.md).

## Purpose and trigger

The skill applies whenever Claude Code creates or edits a file under `docs/`, including agent documents, guides, and reference pages. Claude Code selects the skill from the `description` field in the skill frontmatter. You can also invoke it explicitly with the slash command `/write-document`.

## Location and file layout

```text
.claude/skills/write-document/
├── SKILL.md
└── evals/
    └── evals.json
```

| File | Purpose |
| --- | --- |
| `SKILL.md` | Frontmatter and instructions |
| `evals/evals.json` | Eight test cases with prompts, expected output, and assertions |

The skill has no `references/` folder and no scripts. It links to the style guide instead of copying it.

## Frontmatter

| Field | Value |
| --- | --- |
| `name` | `write-document` |
| `description` | Write or update a documentation file following the standard document style (metadata header with title, location, description, version and last-updated date, professional technical writing). Use whenever creating or editing files under `docs/`. |

No other frontmatter fields are set.

## Behavior

The skill defines six steps:

1. **Read the style guide.** Open `docs/templates/GENERIC_DOCUMENT_STYLE.md` in full and follow its header, structure, writing style, and naming rules. The skill states that its rules must not be restated from memory.
2. **Read the source material.** Read the code, configuration, or agent definition being documented. Do not describe behavior from the request alone.
3. **Choose the location.** Save the file under `docs/<topic-folder>/` with a lowercase, hyphen-separated name.
4. **Create or update the document.**
   - For a new document, start from the template at the bottom of the style guide and fill in all five header fields. Set Version to `1.0` and Last Updated On to today's date in `YYYY-MM-DD` format.
   - For an existing document, apply the change and update Version and Last Updated On according to the [versioning rules](../../../templates/GENERIC_DOCUMENT_STYLE.md#versioning). If the file has no header, add one.
5. **Update the index.** Add or update the entry in [docs/index.md](../../../index.md).
6. **Run the review checklist.** Complete the checklist in the style guide before finishing.

## Inputs and outputs

| Direction | Content |
| --- | --- |
| Input | A documentation request, the style guide, and the source material to document |
| Output | A new or edited Markdown file under `docs/` with a complete header, and an updated `docs/index.md` |
| Report | A short summary of the files created or changed and their versions, plus anything not verified against code or configuration, such as an inferred setting or environment variable name |

## Constraints

- The skill writes documentation only and does not change application code.
- The skill never includes secrets, keys, or tokens. It uses placeholders.
- The skill links to existing documents instead of duplicating their content.

## Preloading agents

| Agent | Source |
| --- | --- |
| [documenter](../agents/documenter.md) | `skills:` list in [.claude/agents/documenter.md](../../../../.claude/agents/documenter.md) |

No other agent definition in `.claude/agents/` has a `skills:` entry. Other agents and the main Claude Code session can still invoke the skill on demand.

## Dependencies

| File | Relationship |
| --- | --- |
| [docs/templates/GENERIC_DOCUMENT_STYLE.md](../../../templates/GENERIC_DOCUMENT_STYLE.md) | Defines the header, structure, writing style, naming, versioning, and review checklist. The skill has no independent copy of these rules. |
| [docs/index.md](../../../index.md) | The skill updates it when a document is added or changed. |

## Evals

The evals are in `.claude/skills/write-document/evals/evals.json`. Each case has an `id`, `name`, `prompt`, `expected_output`, an optional `files` list, and `assertions`.

> **Note:** No eval results are stored in the repository. The evals have not been run, as far as the repository confirms.

| Id | Name | What it verifies |
| --- | --- | --- |
| 1 | `new-document-header` | A new document under `docs/project-docs/claude/` has a lowercase, hyphen-separated name, a five-field header, version `1.0`, today's date, and an index entry. Unverifiable content (the MCP server does not exist) is flagged. |
| 2 | `update-existing-with-header` | An edit to `docs/project-docs/claude/agents/reviewer.md` is made in place, a header is added if missing, and the index entry stays valid. |
| 3 | `version-bump-rules` | A link fix is a MINOR bump and a new section is a MAJOR bump, so the final version is `2.0`, with a `##` heading and an unchanged Document Location. |
| 4 | `typo-only-no-bump` | A spelling fix in `docs/project-docs/claude/agents/tester.md` changes nothing else and does not change Version or Last Updated On. |
| 5 | `professional-writing-style` | A request for an informal tone is answered in the formal style: no exclamation marks, no filler words, numbered imperative steps, sentence-case headings, and a note that the style guide governs the tone. |
| 6 | `no-secrets-and-placeholders` | A real key supplied in the prompt never appears in a file. The example uses placeholders and tagged code blocks, and the response explains why. |
| 7 | `index-and-links` | A new `docs/terraform/provision-foundry.md` has a full header, a Related documents section with relative links, an index entry, and a statement that no Terraform code exists to verify against. |
| 8 | `out-of-scope-code-change` | A request to refactor routing code is declined, no application files change, and the response states that routing code cannot be verified. |

Some eval preconditions no longer match the repository, so a run may not reproduce the intended scenario:

- Eval 2 assumes `docs/project-docs/claude/agents/reviewer.md` has no header. The file now has one.
- Eval 3 assumes the style guide has a header at version `1.0`. The style guide has no header.
- Evals 5 and 6 target `docs/research-docs/azure-foundry/`, which contains no documents.

## Invoke and test

To invoke the skill:

1. Open Claude Code in the repository root.
2. Enter `/write-document` followed by the request, for example `/write-document Document how to add a specialist agent`. The [documenter agent](../agents/documenter.md) loads the skill automatically.

To test the skill, run each `prompt` in `evals/evals.json` in a clean working tree, and compare the result with the `assertions` of that case. The repository has no eval runner. The way the evals were intended to be executed is not documented, and the runner command could not be verified.

## Maintenance

- When you change `SKILL.md`, update this document and its version.
- When you change the style guide, review whether the skill and the evals still match. The skill links to the guide and does not copy its rules.
- When you add or change an eval, update the eval table in this document.
- Keep the `description` field specific, because Claude Code uses it to select the skill.

## Related documents

- [Skills overview](index.md): the skill concept, folder convention, and how to add a skill
- [Generic Document Style](../../../templates/GENERIC_DOCUMENT_STYLE.md): the style that the skill applies
- [documenter agent](../agents/documenter.md): the agent that preloads the skill
