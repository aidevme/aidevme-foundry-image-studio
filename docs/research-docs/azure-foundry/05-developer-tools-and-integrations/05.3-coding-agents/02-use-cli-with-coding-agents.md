# Use azd ai with coding agents and scripts

| Field | Value |
| --- | --- |
| **Document Title** | Use azd ai with coding agents and scripts |
| **Document Location** | `docs/research-docs/azure-foundry/05-developer-tools-and-integrations/05.3-coding-agents/02-use-cli-with-coding-agents.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Use azd ai with coding agents and scripts". Run azd ai predictably from coding agents, CI jobs, MCP servers, and scripts that automate Microsoft Foundry project tasks. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/use-cli-with-coding-agents). Article date: 2026-06-15. Page updated: 2026-07-07. Retrieved: 2026-09-29. Navigation: Developer tools and integrations > Coding agents > Best practices for coding agents.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

> **Important**
>
> Items marked (preview) in this article are currently in public preview. This preview is provided without a service-level agreement, and we don't recommend it for production workloads. Certain features might not be supported or might have constrained capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

Use `azd ai` from coding agents and scripts with the same behavior that humans get at a terminal. You set standalone context, disable prompts, parse JSON output, and invoke direct agent endpoints for reliable automation.

## Prerequisites

- The [azd Foundry extensions installed](../05.1-azure-developer-cli/02-install-cli-foundry-extensions.md).
- An authenticated `azd` session.
- A Microsoft Foundry project endpoint for the commands you want to run. For more information, see [Set the azd project context](../05.1-azure-developer-cli/03-cli-project-context.md).
- Optional: a deployed hosted agent when you need to invoke an agent endpoint. For setup, see [Deploy a hosted agent](../../07-agents/07.3-hosted-agents/49-deploy-hosted-agent.md).

## Start with the Microsoft Foundry Skill

Coding agents work best when they already know the `azd ai` conventions. The [Microsoft Foundry Skill](../../04-get-started/04.1-what-do-you-want-to-build/05-use-microsoft-foundry-skill.md) gives a coding agent that knowledge: it generates correct `azd ai` commands and Foundry wiring, and it applies the practices in this article -- setting the project context, passing `--no-prompt`, and requesting `--output json` for structured results. Point your coding agent at the skill first, then use the patterns in the rest of this article to review and harden what it produces.

## Set the project context once

Every resource command, such as `connection`, `toolbox`, `skill`, or `routine`, needs a Foundry project endpoint to target. In automation, set that endpoint once per session, CI job, or coding-agent invocation, and then use it for the rest of the run.

There are two patterns.

### Pin once with `azd ai project set`

When you want the context to persist across shells without exporting an environment variable, set it in global config:

```bash
azd ai project set https://my-project.services.ai.azure.com/api/projects/my-project --no-prompt
azd ai project show
```

`azd ai project set <endpoint>` is fully non-interactive when you already know the URL. `azd ai project show` confirms which source resolved the active endpoint. Use it at the top of a session if you aren't sure what state the host is in.

### Set an environment variable

Set `FOUNDRY_PROJECT_ENDPOINT` in the environment where your script or coding agent runs. Every `azd ai` command automatically picks it up after the in-project azd environment and the global config.

```bash
export FOUNDRY_PROJECT_ENDPOINT="https://my-project.services.ai.azure.com/api/projects/my-project"
azd ai connection list --output json
```

This pattern fits CI well because secrets and configuration usually arrive as environment variables already, and there's no global state to clean up between jobs.

For the full explanation of how the CLI resolves the endpoint, including the precedence order, see [Set the azd project context](../05.1-azure-developer-cli/03-cli-project-context.md).

## Disable prompts

Every `azd ai` command accepts `--no-prompt`. When you set it, the command fails fast instead of blocking on interactive input. A missing required argument or a `delete` confirmation that would otherwise wait for a keypress becomes an immediate error with structured output.

Always set `--no-prompt` in CI and in coding-agent invocations.

```bash
azd ai connection create my-search \
  --kind cognitive-search \
  --target https://my-search.search.windows.net \
  --auth-type api-key \
  --key "$KEY" \
  --no-prompt
```

> **Tip**
>
> `--no-prompt` also implies "skip the `delete` confirmation prompt", so you don't need `--force` just to suppress that one prompt.

## Get JSON output

Most `azd ai` commands support `--output json`, including the `connection`, `toolbox`, `skill`, and `routine` resource commands and `azd ai agent show`. Use it to parse the result reliably with `jq`, `ConvertFrom-Json`, or your language's JSON parser instead of scraping the human-readable text output. The `azd ai agent invoke` command uses `--output raw` for the unmodified server response.

```bash
# List connections, extract names with jq
azd ai connection list --output json | jq -r '.[].name'

# Show a single resource as JSON
azd ai routine show daily-digest --output json | jq '.trigger'
```

```powershell
# PowerShell example
$conn = azd ai connection show my-search --output json | ConvertFrom-Json
Write-Host $conn.target
```

The text output is for humans and may change between releases. The JSON shape is the stable contract.

## Create resources idempotently

`create` isn't an upsert. If the named resource already exists, a re-run fails. This default works well for shared, project-scoped resources because it prevents one caller from silently overwriting another caller's state.

For automation that must succeed regardless of prior state, the `connection` commands accept `--force` to replace the existing resource.

```bash
azd ai connection create my-search \
  --kind cognitive-search \
  --target https://my-search.search.windows.net \
  --auth-type api-key \
  --key "$KEY" \
  --force --no-prompt
```

> **Warning**
>
> `--force` REPLACES the connection (an ARM PUT), it doesn't merge. Use it carefully on shared resources because another caller's edits to the same resource might be lost.

If you only need to change a few fields and want to preserve everything else, use `update`. Or, use the dedicated collection subcommands like `tool`, `tag`, `metadata`, and `key`.

## Create a toolbox from a file

For a multientry toolbox that bundles built-in tools, connections, and skills, put the full definition in a YAML file and pass `--from-file` to `azd ai toolbox create`. The file uses the corresponding [AgentSchema](https://github.com/microsoft/AgentSchema) shape.

```bash
azd ai toolbox create research --from-file ./resources/research-toolbox.yaml --no-prompt
```

`--from-file` is one-shot input read at invocation time. The CLI doesn't track or re-read the file, so future edits to the YAML have no effect until you rerun the command. Create connections with explicit flags (`--kind`, `--target`, `--auth-type`, and the matching credential flags), then reference them by name from the toolbox file.

## Invoke a deployed agent without an azd project

When a coding agent or script needs to call a deployed agent that lives outside its working directory, use `--agent-endpoint` to target it directly. This approach bypasses both `azure.yaml` and the active azd env. The URL alone is enough.

```bash
azd ai agent invoke \
  --agent-endpoint https://my-project.services.ai.azure.com/api/projects/my-project/agents/release-summarizer/versions/3 \
  "Summarize today's release notes." \
  --no-prompt
```

Use this shape when one repository's CI needs to call an agent owned by a different repository, or when an MCP server fronts several agents and only knows their endpoint URLs. For the full set of `invoke` options, see [Invoke a hosted agent](../../07-agents/07.3-hosted-agents/26-invoke-hosted-agent.md).

## Pass secrets to a local run

To start the agent locally with secrets, set them as `azd` environment variables and reference them from the `env` map for your `azure.ai.agent` service in `azure.yaml`. The values live in `.azure/<env>/.env`, which is gitignored by default.

```bash
azd env set OPENAI_KEY "$AZURE_OPENAI_KEY"
```

```yaml
# azure.yaml
services:
  my-agent:
    host: azure.ai.agent
    env:
      OPENAI_KEY: ${OPENAI_KEY}
```

For secrets that shouldn't live in a local `.env` file, store them in a Foundry project connection and reference them with a `${{connections.<name>.credentials.<field>}}` placeholder. See [Run a hosted agent locally](../../07-agents/07.3-hosted-agents/25-run-hosted-agent-locally.md) for the full local-run surface.

## Script a short setup

This bash script combines the patterns above. It pins the project context, creates a connection and a toolbox idempotently, wires a tool into the toolbox, and verifies the result by parsing JSON.

```bash
#!/usr/bin/env bash
set -euo pipefail

azd ai project set "$FOUNDRY_PROJECT_ENDPOINT" --no-prompt

# A 'remote-tool' connection holds the URL and credentials for the MCP server.
azd ai connection create tavily \
  --kind remote-tool \
  --target https://mcp.tavily.com/mcp \
  --auth-type custom-keys \
  --custom-key "x-api-key=$TAVILY_KEY" \
  --force --no-prompt

# Create the toolbox with the connection wired in, in a single shot
cat > research-toolbox.yaml <<'EOF'
description: Research tools
connections:
  - name: tavily
EOF

azd ai toolbox create research --from-file ./research-toolbox.yaml --no-prompt

echo "Toolbox state:"
azd ai toolbox connection list research --output json | jq .
```

`set -euo pipefail` ensures the script fails fast if any step errors out. Combined with `--no-prompt`, that gives you a deterministic exit code suitable for CI gates.

## Review endpoint resolution

Coding agents can predict which Foundry project a command will target by walking this priority order. The first source that yields a value wins; later sources aren't consulted.

1. `--project-endpoint` (or `-p`) flag (always wins).
2. Inside an azd project: the active azd env value.
3. Global config (set by `azd ai project set`).
4. `FOUNDRY_PROJECT_ENDPOINT` environment variable.
5. Error with a structured suggestion to run `azd ai project set` or pass `--project-endpoint`.

For the full explanation, including how the standalone context interacts with in-project work, see [Set the azd project context](../05.1-azure-developer-cli/03-cli-project-context.md).

## Apply coding agent tips

- Always pass `--no-prompt`, and add `--output json` on commands that support it. Together, they give you a predictable exit code plus a parseable result.
- Verify the resolved context with `azd ai project show` at the start of a session if you're uncertain what state the host is in. It's a cheap, read-only call.
- On failure, prefer parsing the structured suggestion in the error output to deciding next steps. For example, a "No Foundry project endpoint resolved" error implies you should run `azd ai project set`, or set `FOUNDRY_PROJECT_ENDPOINT`, before retrying.
- Use `--debug` only when diagnosing a problem. It produces verbose, multi-line output that's hard to parse and was never meant to be a programmatic interface.
- Treat `create` failures with "already exists" as recoverable. Rerun with `--force` if the resource is yours to replace, or switch to `update` and the collection subcommands if you only need to change part of it.

## Related content

- [Set the azd project context](../05.1-azure-developer-cli/03-cli-project-context.md) to understand how the CLI resolves the Foundry project endpoint.
- [Set up CI/CD for hosted agents with the Azure Developer CLI](../../07-agents/07.3-hosted-agents/54-set-up-ci-cd-cli.md) for patterns that run `azd ai` in pipelines.
- [Invoke a hosted agent](../../07-agents/07.3-hosted-agents/26-invoke-hosted-agent.md) for full `azd ai agent invoke` options, including `--agent-endpoint`.
