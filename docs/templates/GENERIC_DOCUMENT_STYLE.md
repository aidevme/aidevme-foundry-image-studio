# Generic Document Style

The standard layout for documents in this repository. Copy the [template](#template) at the bottom into a new file, and replace every `<placeholder>`.

## Document header

Every document starts with a title and a metadata table containing these five fields:

| Field | Meaning | Rules |
| --- | --- | --- |
| **Document Title** | Name of the document | Matches the `#` heading. Short and specific. |
| **Document Location** | Path of the file, relative to the repository root | Update it when the file moves or is renamed. |
| **Document Description** | One or two sentences on what the document covers and who it is for | Plain text, no headings or lists. |
| **Version** | Version of the document, `MAJOR.MINOR` | See [Versioning](#versioning). |
| **Last Updated On** | Date of the last content change | ISO format `YYYY-MM-DD`. |

### Versioning

- Start at `1.0`.
- Increase **MINOR** (`1.0` → `1.1`) for small edits: wording, links, examples, corrections.
- Increase **MAJOR** (`1.1` → `2.0`) when the meaning changes: new or removed sections, changed procedures, changed behavior described.
- Update **Last Updated On** every time you change the version. Skip both for typo-only fixes.

## Structure

1. Header (title and metadata table).
2. Short introduction: what this is and when to read it.
3. Body sections, using `##` for sections and `###` for subsections. Don't skip heading levels.
4. Related documents, as links.

## Writing style

Write as a professional technical writer. Documents are precise, neutral, and written for a defined audience.

### Audience and purpose

- Identify the audience and the task the document supports before writing. State both in the introduction.
- State prerequisites explicitly. Do not assume knowledge the audience may lack, and define terms and acronyms on first use.
- Put the most important information first. Each section answers one question.

### Tone and voice

- Use a formal, objective tone. Avoid slang, humor, idioms, exclamation marks, and marketing language.
- Use the second person ("you") for instructions and the third person for descriptions of the system.
- Use active voice and present tense. Use the passive voice only when the actor is unknown or irrelevant.
- Avoid filler and hedging words such as "simply", "just", "easily", "obviously", "basically", and "very".
- Do not use unverifiable claims, such as "best" or "fast". State measurable facts instead.

### Clarity and precision

- Write short, direct sentences. Express one idea per sentence and keep paragraphs to a few sentences.
- Use plain words. Prefer "use" to "utilize" and "start" to "initiate".
- Use one term for one concept throughout a document, and do not vary terms for style. Keep product and model names exactly as published, for example "Microsoft Foundry" and "GPT-image-2.5".
- Use "must" for requirements, "should" for recommendations, and "can" or "may" for options. Do not use "might" or "could" to describe behavior that is certain.
- Be specific. Give exact values, limits, and names instead of "several", "some", or "a large number".

### Instructions and procedures

- Write procedures as numbered steps. Use one action per step, and start each step with an imperative verb.
- State the expected result after any step where the outcome is not obvious.
- Put conditions before actions: "If the deployment fails, check the quota."
- Use bulleted lists for unordered items and tables for comparisons or reference data. Use prose for explanations.
- Use parallel grammatical structure in every list.

### Formatting conventions

- Use sentence case for headings. Do not end headings with punctuation.
- Give every code block a language tag, such as `bash`, `json`, or `yaml`.
- Wrap commands, file names, paths, settings, parameters, and environment variables in backticks.
- Write UI elements in **bold**, for example: select **Settings**.
- Use callouts for exceptional information only, such as `> **Note:**`, `> **Important:**`, and `> **Warning:**`.
- Give links descriptive text. Do not use "click here" or a bare URL as the link text.
- Link to other documents with relative paths. Link to an existing document instead of restating its content.
- Write dates in ISO format (`YYYY-MM-DD`) and spell out numbers below ten unless they are values or units.

### Accuracy and safety

- Verify every statement, command, and value against the code, configuration, or official documentation. Do not document behavior you have not confirmed.
- Flag anything you cannot verify, and identify inferred information as such.
- Cite the primary source for external facts, and record the date for information that changes, such as pricing and limits.
- Never include secrets, keys, or tokens in examples. Use placeholders such as `<your-endpoint>`.

### Review checklist

Before you publish, confirm that:

- The header is complete, and the version and date are current.
- The introduction states the audience and purpose.
- Every procedure was run and works as written.
- Terms are consistent, and acronyms are defined.
- Links resolve, and the document is listed in [docs/index.md](../index.md).
- The text has been checked for spelling and grammar.

## Naming and location

- Save documents under [docs/](../index.md), in the folder for their topic.
- Use lowercase, hyphen-separated file names, such as `deploy-models.md`. The name of this style guide is the exception because it is a template document.
- Add every new document to [docs/index.md](../index.md).

## Template

Copy everything below into a new file.

````markdown
# <Document Title>

| Field | Value |
| --- | --- |
| **Document Title** | <Document Title> |
| **Document Location** | `docs/<folder>/<file-name>.md` |
| **Document Description** | <One or two sentences on what this covers and who it is for.> |
| **Version** | 1.0 |
| **Last Updated On** | YYYY-MM-DD |

## Introduction

<Purpose of the document, the intended audience, and when to read it.>

## Prerequisites

<Required knowledge, access, and tools. Remove this section if none apply.>

## <Section>

<Content.>

## Related documents

- [<Document name>](<relative/path.md>)
````
