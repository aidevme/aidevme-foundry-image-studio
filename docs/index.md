# Documentation index

Documentation for **aidevme-foundry-image-studio**, grouped by topic.

| Folder | Topic |
| --- | --- |
| `azure-foundry/` | Microsoft Foundry: projects, model deployments, and agents |
| `open-ai/` | OpenAI image models (GPT-image) used through Foundry |
| `azure-ai-search/` | Azure AI Search integration |
| `claude/` | Claude Code setup, agent skills, and MCP server usage |
| `terraform/` | Infrastructure as code for provisioning the Azure resources |
| `templates/` | Document templates: [Generic Document Style](templates/GENERIC_DOCUMENT_STYLE.md) |

> Folders without links below don't contain any documents yet. When you add pages, link them here
> (for example `[Deploy models](azure-foundry/deploy-models.md)`) and keep this table in sync.

## claude/agents

Custom Claude Code subagents defined in [.claude/agents/](../.claude/agents/).

| Agent | Purpose |
| --- | --- |
| [researcher](claude/agents/researcher.md) | Investigates external facts (Foundry, MCP, VS Code APIs, pricing) and reports sourced findings |
| [architect](claude/agents/architect.md) | Designs architecture and model routing; proposes plans, does not implement |
| [developer](claude/agents/developer.md) | Implements features, fixes and refactors from a spec |
| [tester](claude/agents/tester.md) | Writes and runs tests; reproduces bugs with failing tests |
| [reviewer](claude/agents/reviewer.md) | Reviews changes and reports findings with concrete failure scenarios |
| [documenter](claude/agents/documenter.md) | Writes and updates documentation |
