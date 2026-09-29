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

## claude/skills

Claude Code skills defined in [.claude/skills/](../.claude/skills/).

| Document | Purpose |
| --- | --- |
| [Skills overview](claude/skills/index.md) | What a skill is, the folder convention, and how to add a skill |
| [write-document](claude/skills/write-document.md) | Applies the repository document style when creating or editing docs |

## claude/agent-memory

Persistent project memory of each subagent, stored in [.claude/agent-memory/](../.claude/agent-memory/).

| Document | Purpose |
| --- | --- |
| [Agent memory overview](claude/agent-memory/index.md) | Shared concepts: scope, storage, version control, review and reset |
| [architect memory](claude/agent-memory/architect.md) | What the architect records, current contents, and how to reset it |
| [developer memory](claude/agent-memory/developer.md) | What the developer records, current contents, and how to reset it |
| [tester memory](claude/agent-memory/tester.md) | What the tester records, current contents, and how to reset it |
| [reviewer memory](claude/agent-memory/reviewer.md) | What the reviewer records, current contents, and how to reset it |
| [researcher memory](claude/agent-memory/researcher.md) | What the researcher records, current contents, and how to reset it |
| [documenter memory](claude/agent-memory/documenter.md) | What the documenter records, current contents, and how to reset it |

## aidevme-foundry-image-studio

Design and delivery documents for the system.

| Document | Purpose |
| --- | --- |
| [Architecture](aidevme-foundry-image-studio/ARCHITECTURE.md) | Proposed architecture: components, agents, model strategy, tool contracts, security, and roadmap |
| [Implementation plan](aidevme-foundry-image-studio/IMPLEMENTATION.md) | Ordered work packages, tasks, dependencies, and acceptance criteria derived from the architecture |
| [Infrastructure provisioning with Bicep](aidevme-foundry-image-studio/INFRASTRUCTURE.md) | How to provision all Azure services with Bicep and Azure Developer CLI: modules, deployment, verification, and troubleshooting |
