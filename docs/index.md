# Documentation index

Documentation for **aidevme-foundry-image-studio**, grouped by topic.

| Folder | Topic |
| --- | --- |
| `research-docs/` | Research and reference documentation: the local copy of the Microsoft Foundry documentation (`azure-foundry/`) |
| `project-docs/` | Documentation of this project's own code, pipelines and tooling: the Bicep templates (`bicep/`), the GitHub Actions workflows (`github/`), and the Claude Code subagents, memory and skills (`claude/`) |
| [`research-docs/azure-foundry/`](research-docs/azure-foundry/index.md) | Microsoft Foundry: projects, model deployments, and agents. Subfolders `01-` to `13-` follow the section order of the Microsoft Foundry documentation (what is Foundry, product and capability map, capability reference, get started, developer tools, models, agents, toolboxes, observability, evaluation, optimization, trust and safety, manage and operate). |
| `open-ai/` | OpenAI image models (GPT-image) used through Foundry |
| `azure-ai-search/` | Azure AI Search integration |
| `project-docs/claude/` | Claude Code setup: subagents, agent memory, and skills |
| `project-docs/bicep/` | Bicep templates: [overview](project-docs/bicep/index.md) |
| `project-docs/github/` | GitHub Actions workflows: [overview](project-docs/github/workflows/index.md) |
| `terraform/` | Infrastructure as code for provisioning the Azure resources |
| `templates/` | Document templates: [Generic Document Style](templates/GENERIC_DOCUMENT_STYLE.md) and [Research Document Style](templates/RESEARCH_DOCUMENT_STYLE.md) (layout, index table, and sync rules for copies of external documentation) |

> Folders without links below don't contain any documents yet. When you add pages, link them here
> (for example `[Deploy models](research-docs/azure-foundry/deploy-models.md)`) and keep this table in sync.

## project-docs/claude/agents

Custom Claude Code subagents defined in [.claude/agents/](../.claude/agents).

| Agent | Purpose |
| --- | --- |
| [researcher](project-docs/claude/agents/researcher.md) | Investigates external facts (Foundry, MCP, VS Code APIs, pricing) and reports sourced findings |
| [architect](project-docs/claude/agents/architect.md) | Designs architecture and model routing; proposes plans, does not implement |
| [developer](project-docs/claude/agents/developer.md) | Implements features, fixes and refactors from a spec |
| [tester](project-docs/claude/agents/tester.md) | Writes and runs tests; reproduces bugs with failing tests |
| [reviewer](project-docs/claude/agents/reviewer.md) | Reviews changes and reports findings with concrete failure scenarios |
| [documenter](project-docs/claude/agents/documenter.md) | Writes and updates documentation |

## project-docs/claude/skills

Claude Code skills defined in [.claude/skills/](../.claude/skills).

| Document | Purpose |
| --- | --- |
| [Skills overview](project-docs/claude/skills/index.md) | What a skill is, the folder convention, and how to add a skill |
| [write-document](project-docs/claude/skills/write-document.md) | Applies the repository document style when creating or editing docs |

## project-docs/claude/agent-memory

Persistent project memory of each subagent, stored in [.claude/agent-memory/](../.claude/agent-memory).

| Document | Purpose |
| --- | --- |
| [Agent memory overview](project-docs/claude/agent-memory/index.md) | Shared concepts: scope, storage, version control, review and reset |
| [architect memory](project-docs/claude/agent-memory/architect.md) | What the architect records, current contents, and how to reset it |
| [developer memory](project-docs/claude/agent-memory/developer.md) | What the developer records, current contents, and how to reset it |
| [tester memory](project-docs/claude/agent-memory/tester.md) | What the tester records, current contents, and how to reset it |
| [reviewer memory](project-docs/claude/agent-memory/reviewer.md) | What the reviewer records, current contents, and how to reset it |
| [researcher memory](project-docs/claude/agent-memory/researcher.md) | What the researcher records, current contents, and how to reset it |
| [documenter memory](project-docs/claude/agent-memory/documenter.md) | What the documenter records, current contents, and how to reset it |

## project-docs/bicep

Bicep templates in [bicep/](../bicep), documented file by file.

| Document | Purpose |
| --- | --- |
| [Bicep code overview](project-docs/bicep/index.md) | Folder layout, module table and dependency diagram, naming, security defaults, parameters, flags, deployment, what is not implemented, known risks, and how to extend the templates |
| [main.bicep](project-docs/bicep/main.md) | Target scope, parameters, variables, module calls, outputs, and deployment order |
| [Parameter file and linter configuration](project-docs/bicep/parameters.md) | `main.dev.bicepparam` (parameters, model deployments, environment variables) and `bicepconfig.json` |
| [Monitoring module](project-docs/bicep/modules/monitoring.md) | Log Analytics workspace and Application Insights |
| [Identity module](project-docs/bicep/modules/identity.md) | Two user-assigned managed identities |
| [Storage module](project-docs/bicep/modules/storage.md) | Storage account, containers, lifecycle rules, and diagnostics |
| [Cosmos DB module](project-docs/bicep/modules/cosmos.md) | Serverless Cosmos DB account, database, and `jobs` container |
| [Key Vault module](project-docs/bicep/modules/keyvault.md) | Key Vault with RBAC, soft delete, and purge protection |
| [App Configuration module](project-docs/bicep/modules/appconfig.md) | App Configuration store for the routing table |
| [Foundry module](project-docs/bicep/modules/foundry.md) | Foundry resource, project, model deployments, and Content Safety |
| [Search module](project-docs/bicep/modules/search.md) | Azure AI Search service |
| [Registry module](project-docs/bicep/modules/registry.md) | Container Registry |
| [Service Bus module](project-docs/bicep/modules/servicebus.md) | Service Bus namespace and queue (optional) |
| [Container apps module](project-docs/bicep/modules/containerapps.md) | Container Apps environment, apps, and worker job |
| [API Management module](project-docs/bicep/modules/apim.md) | API Management instance, backend, API, and logger |
| [RBAC module](project-docs/bicep/modules/rbac.md) | Every role assignment, and the assignments that are not in the template |

## project-docs/github/workflows

GitHub Actions workflows defined in [.github/workflows/](../.github/workflows).

| Document | Purpose |
| --- | --- |
| [Workflows overview](project-docs/github/workflows/index.md) | The three workflows, the concepts they share (manual triggers, OIDC sign-in, repository variables, environments, concurrency), how to run them, and troubleshooting |
| [Infrastructure validate](project-docs/github/workflows/infra-validate.md) | Lints and builds the Bicep templates, checks placeholders, and optionally previews changes with what-if |
| [Infrastructure deploy](project-docs/github/workflows/infra-deploy.md) | Checks settings, previews, and deploys the Bicep templates to Azure |
| [Infrastructure delete](project-docs/github/workflows/infra-delete.md) | Deletes an environment's resource group and purges soft-deleted resources, with typed confirmation and dry run |

## aidevme-foundry-image-studio

Design and delivery documents for the system.

| Document | Purpose |
| --- | --- |
| [Architecture](aidevme-foundry-image-studio/ARCHITECTURE.md) | Proposed architecture: components, agents, model strategy, tool contracts, security, and roadmap |
| [Implementation plan](aidevme-foundry-image-studio/IMPLEMENTATION.md) | Ordered work packages, tasks, dependencies, and acceptance criteria derived from the architecture |
| [Infrastructure provisioning with Bicep](aidevme-foundry-image-studio/INFRASTRUCTURE.md) | How to provision all Azure services with Bicep and Azure Developer CLI: modules, deployment, verification, and troubleshooting |
