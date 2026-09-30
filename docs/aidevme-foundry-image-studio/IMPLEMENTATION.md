# Implementation plan

| Field | Value |
| --- | --- |
| **Document Title** | Implementation plan |
| **Document Location** | `docs/aidevme-foundry-image-studio/IMPLEMENTATION.md` |
| **Document Description** | Detailed, ordered implementation list for AIDevMe Foundry Image Studio, derived from the architecture document. It is intended for the engineers who build the system and for the agents that assist them. |
| **Version** | 2.2 |
| **Last Updated On** | 2026-09-30 |

## Introduction

This document converts [ARCHITECTURE.md](ARCHITECTURE.md) (status: Proposed, v0.2) into work packages that can be assigned, built, and verified. Each task has an identifier, a concrete deliverable, its dependencies, and acceptance criteria. Section references such as "§6.3" point to the architecture document.

Read this document to plan a sprint, to find what blocks a task, or to check whether a change is in scope for the current phase.

## Current state

The repository contains documentation, issue templates, Claude Code subagents and one skill, README stubs for the services under `src/`, and the infrastructure code: Bicep templates in `bicep/` and three manually started GitHub Actions workflows in `.github/workflows/`. The infrastructure code lints and compiles. Its first deployment to `dev` had not completed when this document was updated (see [INFRASTRUCTURE.md](INFRASTRUCTURE.md)). There is no application code and no build system.

## How to read this plan

### Task identifiers

A task identifier has the form `P<phase>.<package>.<task>`, for example `P1.2.3`. Cross-cutting tasks use the prefix `X`.

### Task size

| Size | Meaning |
| --- | --- |
| S | Up to one day for one engineer |
| M | Two to three days |
| L | About one week |

The sizes are planning estimates. Confirm them against live measurements after the first sprint.

### Conventions for every task

- Each task is delivered in one pull request unless its description says otherwise.
- Each task includes tests, and each changed behavior includes an update to the matching document under `docs/` (use the [documenter agent](../project-docs/claude/agents/documenter.md)).
- A task is done only when all its acceptance criteria are met and the pull request has passed the checks defined in `P0.5`.
- Model names appear only in configuration (`config/routing.yaml`, deployment templates) and never in agent instructions, tool contracts, or client configuration (ADR-002).

### Phase overview

| Phase | Name | Architecture reference | Exit criteria |
| --- | --- | --- | --- |
| 0 | Foundations | §17, §18, §19 | The `infra-deploy` workflow succeeds in `dev`, and one image is generated through the SDK |
| 1 | Image agent MVP | §4, §5, §6, §7, §13 | Developers generate and edit images from VS Code, and jobs are traceable |
| 2 | Quality and orchestration | §8, §14, §15 | The evaluation gate runs in CI, fallback is tested, and icons compose correctly |
| 3 | More agents and channels | §5, §11 | The social-post bundle workflow runs in production |
| 4 | Hardening and scale | §10, §15 | The security review passes, and the service objectives are met for 30 days |

## Decisions required before Phase 0 starts

The architecture leaves these questions open (§21.2). Record each decision as an ADR in `docs/adr/` before the dependent task starts.

| ID | Decision | Blocks | Recommended default |
| --- | --- | --- | --- |
| D1 | Primary Azure region | P0.3.1, P0.4.1 | **Decided: Sweden Central** (ADR-010, architecture v0.2). It is the only region checked on 2026-09-29 that offers all `gpt-image` models and MAI-Image. |
| D2 | Implementation language and runtime for the MCP servers, facade, and proxy | P0.1.2 | **Decided: TypeScript on Node.js** for all services and the proxy (ADR-015). Python only for the icon scripts (`find_icon.py`, `compose.py`). A proposed exception for the hosted agents is open in D9. |
| D3 | Orchestration mechanism: connected agents, Foundry workflows, or Agent Framework workflows | P2.4.1 | **Recommended by research (2026-09-29), pending owner decision (ADR-016, status Proposed):** a Microsoft Agent Framework workflow running in a Foundry hosted agent, in Python or C# (language: D9). Connected agents are not available in the new Foundry Agent Service, and Agents (classic) retire on 2027-03-31. Foundry workflows retire on 2026-12-01, before phases 2 and 3 ship, so do not use them. **Fallback,** only if the TypeScript-only rule (D2) must hold in phase 2: a prompt-agent orchestrator that calls the image prompt agent through the GA `a2a` tool, for intent routing and a single hand-off. The critic loop, A/B mode, and budgets then live in TypeScript code in the Image MCP server or a facade-side controller. Switch to the recommended option when any of these is needed: parallel A/B generation, a guaranteed loop or budget, multi-step phase 3 workflows, the approval step P3.4.1, or resumable long jobs. Comparison and sources: [ARCHITECTURE.md section 5.6](ARCHITECTURE.md#56-orchestration-mechanism-research-result). |
| D4 | Source of brand guidelines: SharePoint, repository, or DAM | P1.7.1 | Repository folder `brand/`, indexed into Foundry IQ. |
| D5 | Tenant model: single internal tenant first, or multi-tenant from the start | P1.3.2 | Single tenant with `tenantId` in every key, so multi-tenancy needs no schema change. |
| D6 | Retention and immutability policy for assets and inputs | P1.3.1 | Use the defaults in §9.1. Add immutability only for audited tenants. |
| D7 | Whether an approval workflow is required from Phase 1 | P3.4.1 | Not required in Phase 1. Required in Phase 3 for external publication. |
| D8 | Whether any tenant may use the external OpenAI provider | P1.1.4 | None. Keep the provider disabled. |
| D9 | Language for the hosted agents (orchestrator and image agent). Proposed exception to D2. | P2.2.1, P2.4.1 | **Recommended, pending owner decision.** D2 stays in force until the owner records a decision. Hosted agents support Python and C# only, and "there's no Node.js hosted runtime" (documented, source in [ARCHITECTURE.md section 5.6](ARCHITECTURE.md#56-orchestration-mechanism-research-result)). Options: (1) Python, recommended by the research (inferred: the icon scripts are already Python, the Python workflow API supports native loops and `asyncio.gather`, and the resilient-background and approval stores are documented for Python; risk: the Python hosting package is prerelease). (2) C#, if the team prefers the .NET workflow packages, which the research describes as stable (not independently verified). (3) Keep TypeScript everywhere and use the fallback in D3. Do not create a hosted agent in TypeScript or start P2.2.1 and P2.4.1 before the decision is recorded. |

## Gaps in the architecture document

These items were used in the architecture (v0.1) without a specification. **G-1 to G-7 are resolved in ARCHITECTURE.md v0.2**, and the table is kept for traceability. Tasks that mention a gap use the resolution in the architecture document. New gaps found later (data residency, quota, soft delete, and others) are listed in the change table at the top of [ARCHITECTURE.md](ARCHITECTURE.md) and in its section 21.

| ID | Gap | Affects | Proposed resolution |
| --- | --- | --- | --- |
| G-1 | No tool contract exists for overlaying text in code (§6.3 and §8.6 require it). | P2.6.3 | Add an `overlay_text` tool to the Image MCP server, with font, position, and color inputs. |
| G-2 | `generate_image` accepts a `brief_id`, but no brief store or brief lifecycle is defined. | P1.3.3, P1.5.1 | Store the brief in the `jobs` container as a nested document, and treat `brief_id` as the job identifier. |
| G-3 | The facade `tier` enum omits `alternative`, and the facade does not expose `variations` or `upscale` (FR3). | P1.9.1, P2.5.1 | Keep `alternative` internal to the A/B mode. Add `variations` and `upscale` to the facade in Phase 2. |
| G-4 | `list_recent_visuals` needs a query by user, but the Cosmos partition key is `/tenantId`. | P1.9.2 | Add a composite index on `userId` and `createdAt`. |
| G-5 | The repository structure (§18) places `ARCHITECTURE.md` at the repository root, but the file is in `docs/aidevme-foundry-image-studio/`. | P0.1.1 | Update §18 to the actual location. |
| G-6 | The architecture names four product skills (`image-brief`, `image-generate`, `image-edit`, `microsoft-product-icons`), but the repository currently contains only `write-document`. | P0.6 | Add the four skills under `skills/`. Keep `write-document` under `.claude/skills/`. |
| G-7 | Both the image agent and the facade time out at different limits (§15 states 60 seconds for the facade only). | P1.8.3 | Define an agent-run timeout of 50 seconds so the facade can return a job identifier before its own limit. |

## Phase 0: Foundations

**Goal:** A reproducible environment, the repository skeleton, the pipeline, and proof that one image can be generated.

### P0.1 Repository skeleton

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P0.1.1 | Create the directory layout from §18 | Directories `bicep/`, `agents/orchestrator/`, `agents/image/`, `toolboxes/`, `src/image-mcp/`, `src/facade-mcp/`, `src/icon-service/`, `src/shared/`, `src/vscode-proxy/`, `src/infrastructure/`, `skills/`, `config/`, `evals/golden-set/`, `evals/runners/`, `brand/`, `docs/adr/`, `docs/runbooks/`, `.github/workflows/`. Each directory contains a `README.md` that states its purpose. Fix gap G-5. | D2 | S | The layout matches §18, and `docs/index.md` lists the new documents. |
| P0.1.2 | Initialize the toolchain | Workspace manifest, TypeScript configuration, linter, formatter, test runner, `.editorconfig`, and `.gitignore` (which excludes `.env`, `node_modules`, `.azure/`, and build output). | D2 | S | `npm run lint`, `npm run build`, and `npm test` succeed on an empty workspace. |
| P0.1.3 | Add pre-commit and secret scanning | A pre-commit hook for lint and format, and a secret scanner (for example gitleaks) with a repository baseline. | P0.1.2 | S | A commit that contains a fake key is rejected locally. |
| P0.1.4 | Update `CLAUDE.md` | Add real build, lint, and test commands, and the architecture summary, as the file requires. | P0.1.2 | S | `CLAUDE.md` no longer states that no build system exists. |

### P0.2 Decisions and ADRs

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P0.2.1 | Write ADR-001 to ADR-009 | One file per decision in `docs/adr/`, using the decisions in §20. Include context, decision, consequences, and status. | P0.1.1 | M | Nine files exist, and the statuses match §20. |
| P0.2.2 | Record decisions D1 to D9 | One ADR per decision (ADR-010 onward), or an explicit "deferred" entry with a due phase. | P0.2.1 | S | Every decision in the table above has a status. |
| P0.2.3 | Update the architecture document | Resolve gaps G-1 to G-7 in the architecture, and raise its version. **Done in v0.2.** Keep it current as decisions are made. | P0.2.2 | S | The architecture document contains no unresolved gap. |

### P0.3 Infrastructure
 

#### P0.3.1 Infrastructure for the `dev` environment

All modules use Bicep and are deployed with `az deployment sub create` from manually started GitHub Actions workflows (ADR-011). `azd` is not used. Every resource uses managed identity and data-plane RBAC, with no keys. The templates are written in `bicep/` and compile cleanly. They had not completed a deployment when this document was updated.

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P0.3.1 | Foundry resource and project | `bicep/modules/foundry.bicep`: Foundry resource, project, and region from D1. Parameter file for `dev`. | D1, P0.1.1 | M | The `infra-deploy` workflow creates the project. |
| P0.3.2 | Model deployments | `bicep/modules/models.bicep`: deployments for draft (`img-draft-gpt-image-1-mini`) and standard (`img-std-gpt-image-2-5-flare`), plus one reasoning and vision model for the agents. Pinned versions, upgrade policy set to manual (§6.4). | P0.3.1, P0.4.1 | M | Each deployment answers a smoke request. |
| P0.3.3 | Data services | `bicep/modules/data.bicep`: Storage account (containers `assets`, `inputs`, `brand`, `icons`), Cosmos DB (container `jobs`, partition key `/tenantId`), Key Vault, and App Configuration. Lifecycle rules from §9.1. | P0.3.1 | M | Containers exist, the lifecycle policy is applied, and public access is off for blobs. |
| P0.3.4 | Safety and monitoring | `bicep/modules/monitoring.bicep`: Log Analytics, Application Insights, Azure AI Content Safety. | P0.3.1 | S | Telemetry from a test app appears in Application Insights. |
| P0.3.5 | Identities and RBAC | `bicep/modules/identity.bicep`: user-assigned managed identities for the facade and the Image MCP server, with the role assignments listed in §10.2. | P0.3.1, P0.3.3, P0.3.4 | M | The role assignments match §10.2, and no assignment is broader than listed. |
| P0.3.6 | Deployment entry point | `bicep/main.bicep` (subscription scope), `main.<env>.bicepparam` per environment, and the naming rules in ARCHITECTURE.md section 17.2. Only `dev` exists. | P0.3.1 to P0.3.5 | S | The `infra-deploy` workflow completes from a clean subscription in `dev`. |

#### P0.3.2 Infrastructure for the `test` environment

All modules use Bicep and are deployed with `az deployment sub create` from manually started GitHub Actions workflows (ADR-011). `azd` is not used. Every resource uses managed identity and data-plane RBAC, with no keys. The templates are written in `bicep/` and compile cleanly. They had not completed a deployment when this document was updated.

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P0.3.1 | Foundry resource and project | `bicep/modules/foundry.bicep`: Foundry resource, project, and region from D1. Parameter file for `dev`. | D1, P0.1.1 | M | The `infra-deploy` workflow creates the project. |
| P0.3.2 | Model deployments | `bicep/modules/models.bicep`: deployments for draft (`img-draft-gpt-image-1-mini`) and standard (`img-std-gpt-image-2-5-flare`), plus one reasoning and vision model for the agents. Pinned versions, upgrade policy set to manual (§6.4). | P0.3.1, P0.4.1 | M | Each deployment answers a smoke request. |
| P0.3.3 | Data services | `bicep/modules/data.bicep`: Storage account (containers `assets`, `inputs`, `brand`, `icons`), Cosmos DB (container `jobs`, partition key `/tenantId`), Key Vault, and App Configuration. Lifecycle rules from §9.1. | P0.3.1 | M | Containers exist, the lifecycle policy is applied, and public access is off for blobs. |
| P0.3.4 | Safety and monitoring | `bicep/modules/monitoring.bicep`: Log Analytics, Application Insights, Azure AI Content Safety. | P0.3.1 | S | Telemetry from a test app appears in Application Insights. |
| P0.3.5 | Identities and RBAC | `bicep/modules/identity.bicep`: user-assigned managed identities for the facade and the Image MCP server, with the role assignments listed in §10.2. | P0.3.1, P0.3.3, P0.3.4 | M | The role assignments match §10.2, and no assignment is broader than listed. |
| P0.3.6 | Deployment entry point | `bicep/main.bicep` (subscription scope), `main.<env>.bicepparam` per environment, and the naming rules in ARCHITECTURE.md section 17.2. Only `dev` exists. | P0.3.1 to P0.3.5 | S | The `infra-deploy` workflow completes from a clean subscription in `dev`. |

#### P0.3.3 Infrastructure for the `prod` environment

All modules use Bicep and are deployed with `az deployment sub create` from manually started GitHub Actions workflows (ADR-011). `azd` is not used. Every resource uses managed identity and data-plane RBAC, with no keys. The templates are written in `bicep/` and compile cleanly. They had not completed a deployment when this document was updated.

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P0.3.1 | Foundry resource and project | `bicep/modules/foundry.bicep`: Foundry resource, project, and region from D1. Parameter file for `dev`. | D1, P0.1.1 | M | The `infra-deploy` workflow creates the project. |
| P0.3.2 | Model deployments | `bicep/modules/models.bicep`: deployments for draft (`img-draft-gpt-image-1-mini`) and standard (`img-std-gpt-image-2-5-flare`), plus one reasoning and vision model for the agents. Pinned versions, upgrade policy set to manual (§6.4). | P0.3.1, P0.4.1 | M | Each deployment answers a smoke request. |
| P0.3.3 | Data services | `bicep/modules/data.bicep`: Storage account (containers `assets`, `inputs`, `brand`, `icons`), Cosmos DB (container `jobs`, partition key `/tenantId`), Key Vault, and App Configuration. Lifecycle rules from §9.1. | P0.3.1 | M | Containers exist, the lifecycle policy is applied, and public access is off for blobs. |
| P0.3.4 | Safety and monitoring | `bicep/modules/monitoring.bicep`: Log Analytics, Application Insights, Azure AI Content Safety. | P0.3.1 | S | Telemetry from a test app appears in Application Insights. |
| P0.3.5 | Identities and RBAC | `bicep/modules/identity.bicep`: user-assigned managed identities for the facade and the Image MCP server, with the role assignments listed in §10.2. | P0.3.1, P0.3.3, P0.3.4 | M | The role assignments match §10.2, and no assignment is broader than listed. |
| P0.3.6 | Deployment entry point | `bicep/main.bicep` (subscription scope), `main.<env>.bicepparam` per environment, and the naming rules in ARCHITECTURE.md section 17.2. Only `dev` exists. | P0.3.1 to P0.3.5 | S | The `infra-deploy` workflow completes from a clean subscription in `dev`. |

### P0.4 Access and quota

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P0.4.1 | Request model access | Submit limited-access requests for the image models that require them, and record the approval status in `docs/runbooks/model-access.md`. | D1 | S | The status of each model is recorded. Start immediately because approval time is outside the project's control. |
| P0.4.2 | Request quota | Request quota for the standard tier first, then for the other tiers (§15). | P0.4.1 | S | Quota values are recorded per deployment. |

### P0.5 Continuous integration

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P0.5.1 | Validate workflow | `.github/workflows/infra-validate.yml` (manual): lint, build, placeholder check, optional what-if. Application lint, unit tests and secret scan are added when code exists. | P0.1.2, P0.3.6 | M | Running the workflow with a lint error fails it. |
| P0.5.2 | Azure federation | OIDC federation between GitHub Actions and Azure: an app registration with one federated credential per GitHub environment (immutable subject format, see ARCHITECTURE.md section 10.1), and the roles in section 10.2. | P0.3.6 | S | The workflow authenticates without stored secrets. |
| P0.5.3 | Deploy and delete workflows | `.github/workflows/infra-deploy.yml` and `infra-delete.yml` (both manual, run in the GitHub environment). Delete tolerates missing resources and purges soft-deleted ones. | P0.5.1, P0.5.2 | S | A deploy creates `dev`, and a delete followed by a deploy succeeds. |

### P0.6 Product skills

These are the **product skills** of the Foundry solution. They live in `skills/` at the repository root, are served to the Foundry agents through a Toolbox, and are published to consuming repositories. They are separate from the development skills in `.claude/skills/` (such as `write-document`), which are never deployed. See ARCHITECTURE.md section 12.

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P0.6.1 | `image-brief` skill | `skills/image-brief/SKILL.md` with the brief schema from §12, tier selection rules, and the rule that `standard` is the default and `precision` requires a reason. | P0.1.1 | M | The skill validates against the schema in `src/shared` (see `P0.7.1`). |
| P0.6.2 | `image-generate` skill | Prompt structure (subject, composition, style, lighting and palette, exact text, constraints), exploration strategy, review checklist, and retry and escalation rules. | P0.6.1 | M | The skill contains the five critique checks from §8.5. |
| P0.6.3 | `image-edit` skill | Edit classification, mask rules, the `Change: ... Keep unchanged: ...` format, one change per call, and drift checks (§8.3). | P0.6.1 | M | The skill states that chains of three or more edits use `precision`. |
| P0.6.4 | `microsoft-product-icons` skill and scripts | `skills/microsoft-product-icons/` with `find_icon.py` and `compose.py`, and the icon sources from §12. | P0.6.1 | L | `find_icon.py "Copilot Studio"` returns an official icon path, and `compose.py` places icons without changing them. |
| P0.6.5 | Skill evaluations and documentation | An `evals/evals.json` inside each skill folder under `skills/`, and a document per skill under `docs/skills/` (not `docs/project-docs/claude/skills/`, which documents development skills). | P0.6.1 to P0.6.4 | M | Every skill has documented eval cases and a documentation page. |

### P0.7 Shared contracts

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P0.7.1 | JSON schemas | `src/shared/schemas/`: `brief`, `job`, `sidecar`, `generate_image` (input and output), `edit_image`, `compose_icons`, and the facade tool inputs (§7, §9). | P0.1.2 | M | Schemas validate the example documents in the architecture. `tier` is required, and model names are rejected. |
| P0.7.2 | Error catalog | `src/shared/errors.ts`: `BLOCKED_BY_SAFETY`, `BUDGET_EXCEEDED`, `UNSUPPORTED_SIZE`, `PROVIDER_UNAVAILABLE`, `INVALID_MASK`, `TEXT_OVERFLOW`, each mapped to an MCP error result. | P0.7.1 | S | Each error has a unit test. |
| P0.7.3 | Telemetry helper | `src/shared/telemetry.ts`: OpenTelemetry setup and the custom dimensions from §14.1. | P0.3.4 | S | A test span carries all listed dimensions. |
| P0.7.4 | Authentication helper | `src/shared/auth.ts`: `DefaultAzureCredential` wrapper for data-plane and model calls. | P0.3.5 | S | The helper obtains a token for a Foundry deployment in `dev`. |

### P0.8 Spike

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P0.8.1 | Generate one image through the SDK | A script in `src/image-mcp/spikes/` that calls the draft and standard deployments with Entra authentication. | P0.3.2, P0.7.4 | S | One image per tier is saved locally. |
| P0.8.2 | Record the latency baseline | Measure 20 requests per tier and record p50 and p95 in `docs/runbooks/baseline.md`. | P0.8.1 | S | The baseline is documented and is used for the alerts in `P1.12.3`. |

**Phase 0 exit check:** the `infra-deploy` workflow succeeds in `dev`, the validate workflow is green, and `P0.8.1` produces an image.

## Phase 1: Image agent MVP

**Goal:** A developer can generate and edit images from VS Code, and every job is traceable.

### P1.1 Provider layer (§6.5)

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P1.1.1 | `ImageProvider` interface | `src/image-mcp/providers/types.ts` with `generate`, `edit`, and `capabilities` (maximum size, transparency, mask support, maximum references, qualities). | P0.7.1 | S | The interface compiles, and a fake provider passes the shared contract tests. |
| P1.1.2 | `FoundryImageProvider` | Calls a Foundry deployment with Entra authentication. Normalizes size, quality, background, mask, and references. Returns the common result shape. | P1.1.1, P0.3.2 | L | Generate and edit calls succeed against `dev`. Unsupported parameters return `UNSUPPORTED_SIZE` or `INVALID_MASK`. |
| P1.1.3 | Provider contract tests | A shared test suite that every provider must pass. | P1.1.1 | M | The suite runs against the fake provider and the Foundry provider. |
| P1.1.4 | `OpenAIImageProvider` stub | A disabled implementation that reads its key from Key Vault. The tenant flag from D8 controls it. | P1.1.1, D8 | S | The provider is off by default, and enabling it without the flag fails closed. |

### P1.2 Router (§6.2, §6.3, §15)

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P1.2.1 | Routing table | `config/routing.yaml` with the tiers and fallbacks from §6.2, and a schema check for it. | P0.7.1 | S | Invalid tables are rejected at load time. |
| P1.2.2 | App Configuration loader | Reads the table from App Configuration and reloads it without a restart. | P1.2.1, P0.3.3 | M | Changing a value changes routing within the reload interval, and no request fails during the reload. |
| P1.2.3 | Routing rules | Implements every row of §6.3 that applies in Phase 1: brief tier, edit chain of three or more forces `precision`, long in-image text is generated without text, fallback on 429 or 5xx, region fallback, and budget downgrade. | P1.2.2, P1.1.2 | L | A unit test exists for each rule, and `fallback_used` is recorded. |
| P1.2.4 | Retry and circuit breaker | Exponential backoff with jitter (maximum three retries, honoring `retry-after`), and a circuit breaker per deployment that opens after five consecutive failures and half-opens after 60 seconds. | P1.2.3 | M | Tests simulate 429 and 5xx responses and verify the timing and state changes. |
| P1.2.5 | Model-name rejection | Reject any request that contains a model name instead of a tier. | P1.2.1 | S | A request with a model name returns a validation error. |

### P1.3 Storage and job store (§9)

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P1.3.1 | Asset store | Writes assets using the Blob layout in §9.1. Creates user-delegation SAS URLs with a 15-minute lifetime. Never overwrites a source asset. | P0.3.3, D6 | M | An asset is readable through a SAS URL that expires, and direct access without SAS fails. |
| P1.3.2 | Job store | Cosmos DB access for the `jobs` container with the schema in §9.2, and the composite index from gap G-4. | P0.3.3, D5, P0.7.1 | M | Create, update, and query by `userId` and `createdAt` work. |
| P1.3.3 | Brief storage | Stores the brief in the job record, per gap G-2. | P1.3.2 | S | A job record contains the brief that produced it. |
| P1.3.4 | Sidecar writer | Writes the sidecar in §9.3 next to every asset, with the job identifier, brief, prompt, tier, provider, deployment, model version, icon sources, and safety verdict. Preserves C2PA metadata. | P1.3.1 | M | Every asset has a sidecar, and a test confirms that C2PA data is not stripped. |
| P1.3.5 | Idempotency | Honor an `Idempotency-Key` and return the existing job for a duplicate (§15). | P1.3.2 | S | Two identical submissions produce one job. |

### P1.4 Content safety (§10.4, §11)

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P1.4.1 | Prompt and output checks | Call Content Safety before generation and after generation. Block and record the verdict. | P0.3.4, P1.1.2 | M | A blocked prompt returns `BLOCKED_BY_SAFETY`, and a blocked output is not stored as an asset. |
| P1.4.2 | Prompt Shields | Check user text and reference images for injection. | P1.4.1 | M | A known injection sample is blocked. |
| P1.4.3 | Abuse logging | Log blocked prompts with category and user identifier, and raise an alert on repeated violations. | P1.4.1, P0.7.3 | S | A repeated violation produces an alert in `dev`. |

### P1.5 Image MCP server (§7.1)

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P1.5.1 | Server skeleton | `src/image-mcp/`: streamable HTTP MCP server, schema validation on every request and response, Entra-protected, health endpoint. | P0.7.1, P0.7.4 | M | The server lists its tools and rejects unauthenticated calls. |
| P1.5.2 | `generate_image` | Full pipeline: validate, safety check, route, generate, safety check, store, record, return the output in §7.1. Synchronous only in Phase 1. | P1.5.1, P1.2.3, P1.3.1 to P1.3.4, P1.4.1 | L | The output matches the contract, no base64 appears anywhere, and the job record and sidecar exist. |
| P1.5.3 | `edit_image` | Load the source asset, apply the mask if present, call the provider, and store the result as a new asset with `parent_asset_id`. | P1.5.2 | L | The source asset is unchanged, and the new asset links to it. |
| P1.5.4 | `get_job_status` | Return the state and assets of a job. | P1.3.2 | S | The tool returns each defined status. |
| P1.5.5 | Container image and deployment | Dockerfile, Container Apps module in Bicep, internal ingress, and managed identity. | P1.5.2, P0.3.5 | M | The server runs in `dev` and answers tool calls from the agent identity. |

### P1.6 Toolbox

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P1.6.1 | Toolbox definition | `toolboxes/image-studio.yaml` that registers the Image MCP server, and later the icon tools and the knowledge tool. | P1.5.5 | S | The toolbox loads in the Foundry project and lists the tools. |

### P1.7 Brand knowledge (§4 C9)

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P1.7.1 | Sample brand content | `brand/` with sample palette, tone, and do and don't lists (source from D4). | D4 | S | The folder contains at least one guideline document and one reference image. |
| P1.7.2 | Index in Foundry IQ | Index `brand/` in Foundry IQ (Azure AI Search) with a tenant filter. | P1.7.1, P0.3.1 | M | A query for the brand palette returns the guideline text. |

### P1.8 Image agent (§5.2, §5.3)

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P1.8.1 | Agent definition | `agents/image/agent.yaml`: instructions based on the skeleton in §5.3, the reasoning and vision model, and the Toolbox and knowledge tools. Instructions mention tiers only. | P1.6.1, P1.7.2, P0.6.1 to P0.6.3 | M | The definition applies without error, and a text search finds no model name in the instructions. |
| P1.8.2 | Deployment script | A TypeScript script in `src/infrastructure/` that applies `agents/**/agent.yaml` through the Foundry SDK, and is idempotent. | P1.8.1 | M | Running the script twice produces the same state. |
| P1.8.3 | Run limits | Budgets: at most three attempts and one precision escalation per request, and the timeout from gap G-7. | P1.8.1 | S | A test shows the agent stops after three attempts and reports what is wrong. |
| P1.8.4 | Playground validation | Run 20 briefs in the Foundry playground and record the outcomes in `docs/runbooks/image-agent-baseline.md`. | P1.8.2 | M | The agent asks at most one question, always chooses a tier, and never names a model. |

### P1.9 Agent MCP facade (§7.2)

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P1.9.1 | Facade tools | `src/facade-mcp/`: `create_visual`, `edit_visual`, `get_job_status`. Calls the agent through the Responses API on the project endpoint. Accepts `tier` of `auto`, `draft`, `standard`, or `precision`. | P1.8.2, P0.7.1 | L | A call returns asset URLs, job identifiers, and the agent's rationale. |
| P1.9.2 | `list_recent_visuals` | Returns the caller's recent assets using the index from gap G-4. | P1.3.2, P1.9.1 | S | The tool returns only the caller's assets, newest first. |
| P1.9.3 | Deployment | Dockerfile and Container Apps module, private ingress that trusts APIM only, and managed identity with the Azure AI User role. | P1.9.1, P0.3.5 | M | The facade runs in `dev`. |

### P1.10 API gateway (§4 C2, §10.1)

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P1.10.1 | APIM instance | `bicep/modules/apim.bicep`: the AI gateway with JWT validation for the facade app registration and a product per consumer group. | P1.9.3 | M | A call without a token returns 401, and a call with a valid token reaches the facade. |
| P1.10.2 | Quotas and metering | Per-subscription quotas and rate limits, and metering per user. | P1.10.1 | M | A caller who exceeds the quota receives a 429. |
| P1.10.3 | App roles | Custom `ImageStudio.User` app role on the facade app registration. | P1.10.1 | S | Only holders of the role can call the facade. |

### P1.11 VS Code proxy (§13.2)

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P1.11.1 | Proxy package | `src/vscode-proxy/`: npm package `@aidevme/image-studio-mcp` with stdio transport. Authenticates with the developer's Azure sign-in and forwards calls to APIM. | P1.10.1 | L | The proxy lists the facade tools in VS Code. |
| P1.11.2 | File download | Download returned SAS URLs into `OUTPUT_DIR`, write the sidecar, and return local paths. No image bytes enter the model context. | P1.11.1 | M | The image and sidecar exist in the workspace, and the tool result contains only paths. |
| P1.11.3 | Client configuration | Document the `mcp.json` example from §13.2, and the remote-only alternative. | P1.11.1 | S | A new developer configures the proxy by following the document. |
| P1.11.4 | Client-side skills | Provide the four skills under `.github/skills/` and `.claude/skills/` for consuming repositories (§13.3). | P0.6.5 | S | The skills load in Copilot agent mode and in Claude Code. |

### P1.12 Observability (§14.1, §14.2)

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P1.12.1 | End-to-end tracing | One trace identifier from APIM to the model call, with the custom dimensions from §14.1. | P0.7.3, P1.5.2, P1.9.1 | M | A single trace shows all hops for one request. |
| P1.12.2 | Dashboards | Foundry Agent Monitoring Dashboard and an Azure Monitor workbook for tiers, cost, and safety. | P1.12.1 | M | The workbook shows the data of a test run. |
| P1.12.3 | Alerts | Alert rules for the metrics in §14.2, with thresholds derived from `P0.8.2`. | P1.12.2, P0.8.2 | M | Each alert fires in a controlled test. |

### P1.13 Testing and hand-off

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P1.13.1 | Unit and contract tests | Coverage for router rules, providers, schemas, error mapping, and idempotency. | P1.2.3, P1.5.3 | L | The suite runs in CI, and each routing rule in §6.3 has a test. |
| P1.13.2 | Integration tests | Tests of the Image MCP server and the facade against `dev`, including error paths (unavailable model, exhausted quota, malformed MCP request). | P1.5.5, P1.9.3 | L | Tests use real deployments and no mocks of the routing logic. |
| P1.13.3 | End-to-end test | Generate and edit an image from VS Code, and check the asset, sidecar, and job record. | P1.11.2 | M | The scenario passes and is repeatable. |
| P1.13.4 | Latency measurement | Compare the standard-tier p50 and p95 against the targets in §2.2. | P1.13.3 | S | The result is documented, and the targets are confirmed or adjusted. |
| P1.13.5 | Documentation | User guide for the MCP server and proxy, configuration reference, and how to add a specialist agent or skill. | P1.11.3 | M | The documenter agent reviews all documents, and `docs/index.md` is current. |

**Phase 1 exit check:** A developer generates and edits an image from VS Code, every job has a record and a sidecar, and the p95 latency is measured.

## Phase 2: Quality and orchestration

**Goal:** Reliable quality through the critic loop and evaluations, asynchronous jobs, and multi-agent orchestration.

### P2.1 Asynchronous jobs (§8.2)

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P2.1.1 | Service Bus | `bicep/modules/servicebus.bicep`: namespace, queue with sessions per job, and a monitored dead-letter queue. | P0.3.1 | M | A message round-trips, and dead-lettered messages are visible. |
| P2.1.2 | Async submission | `generate_image` and `edit_image` accept `async=true`, create a queued job, enqueue work items, and return the job identifier. Requests that exceed 60 seconds, precision jobs, and `count > 4` become asynchronous automatically (§15). | P2.1.1, P1.5.2 | M | The tool returns a job identifier without waiting. |
| P2.1.3 | Worker | A Container Apps job that receives work items, routes, generates, checks safety, stores, and updates the job state. | P2.1.2 | L | A batch of 50 items completes, and failed items report partial success. |
| P2.1.4 | Scaling and back-pressure | KEDA scaling on queue length, and a per-deployment concurrency semaphore. | P2.1.3 | M | Load tests show no 429 storm, and workers scale up and down with the queue. |
| P2.1.5 | Dead-letter handling | Retry policy, dead-letter after the retry limit, and the runbook `docs/runbooks/dead-letter.md`. | P2.1.3 | S | A poisoned message reaches the dead-letter queue, and the alert in §14.2 fires. |

### P2.2 Hosted image agent and critic loop (§5.5, §8.5)

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P2.2.1 | Hosted agent project | Microsoft Agent Framework project for the image agent, with unit tests and a local run. Publish as a hosted agent (ADR-008). Hosted agents must be Python or C# (D9), and the same project skeleton also hosts the orchestrator workflow (P2.4.1). | P1.8.2, D9 | L | The hosted agent produces the same results as the prompt agent on the Phase 1 briefs. |
| P2.2.2 | Critique step | A vision-model critique that scores subject, composition, text, brand, and artifacts from 0 to 1, against the brief. | P2.2.1 | L | Scores are recorded in the job record (§9.2). |
| P2.2.3 | Retry and escalation | Attempt 1 fails: improve the prompt. Attempt 2 fails: escalate the tier. Attempt 3 fails: return the best result and the open issues. | P2.2.2 | M | A test sequence reproduces each branch of the flowchart in §8.5. |
| P2.2.4 | A/B mode | Generate with the primary and `alternative` tiers in parallel, as a fan-out and fan-in in the Agent Framework workflow, score both, and return the better result or both. Store the scores as evaluation data. | P2.2.3, P0.3.2 | L | Both candidates are generated in parallel, and the scores are stored. |
| P2.2.5 | Alternative deployment | Add the MAI-Image deployment (`img-alt-mai-image`) to `dev` and `test`. | P0.3.2 | S | The deployment answers a smoke request. |

### P2.3 Icon service (§8.4, §12)

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P2.3.1 | Icon index | Build-time step that extracts the Azure icon set into `icons/azure`, and loads the product icon index. Cache in `icons/cache/`. | P0.6.4 | M | Every product name in the sample briefs resolves to an official file. |
| P2.3.2 | `compose_icons` tool | Implements the contract in §7.1: scale icons uniformly, place them with labels, and never alter the icon files. | P2.3.1, P1.5.1 | L | The output has no modified icons, and the sidecar lists the icon sources. |
| P2.3.3 | Backdrop workflow | The agent generates a backdrop with reserved empty positions, and calls `compose_icons`. | P2.3.2, P2.2.1 | M | A sample brief with three products produces the expected composition. |
| P2.3.4 | Brand and legal checks | Verify that the product name appears near each icon (§11) and that no generated logo exists. | P2.3.3 | S | The critique step flags a generated logo. |

### P2.4 Orchestrator (§5.4)

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P2.4.1 | Orchestration approach | Implement the approach from D3. Recommended: an Agent Framework workflow wrapped with `Workflow.as_agent()` and published as a hosted agent that serves the Responses protocol, in the language chosen in D9. It is built from the same project skeleton as P2.2.1. Specialists that stay prompt agents (copy, brand QA, and the image agent until P2.2.1 lands) are called as workflow participants (inferred: `FoundryAgent`) or through the A2A tool. Fallback if D9 keeps TypeScript: a prompt-agent orchestrator with the GA `a2a` tool, with deterministic control in TypeScript. | D3, D9, P2.2.1 | M | The workflow routes one image request end to end through the hosted orchestrator. With the fallback: the prompt-agent orchestrator hands one image request to the image prompt agent through the `a2a` tool. |
| P2.4.2 | Orchestrator agent | The orchestrator workflow and its agent definition in `agents/orchestrator/` (whether a hosted agent uses an `agent.yaml` file like the prompt agents is not verified): classify intent (`image`, `copy`, `image+copy`, `review`), call the image agent, and expose `get_job_status`. | P2.4.1 | L | Image requests through the orchestrator match the direct image agent results. |
| P2.4.3 | Budgets | Enforce the maximum attempts and maximum precision calls per request. Keep them as workflow state, not as prompt instructions, and enforce them again server-side in the Image MCP server, keyed by request identifier (inferred defense in depth). | P2.4.2 | S | A request that exceeds a budget returns `BUDGET_EXCEEDED`, including when the orchestrator is bypassed. |
| P2.4.4 | Facade switch | Point the facade to the orchestrator without changing its contract (§5.1). The hosted orchestrator endpoint is `{project}/agents/{name}/endpoint/protocols/openai/responses` (documented), which the TypeScript facade can call with an OpenAI-compatible SDK. Use `background: true` for long jobs. | P2.4.2 | S | The facade contract tests pass unchanged. |

### P2.5 Additional image tools

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P2.5.1 | `variations` and `upscale` | Implement both tools in the Image MCP server, and expose them through the facade (gap G-3). | P1.5.3 | M | Each tool returns a new asset linked to its source. |
| P2.5.2 | Facade contract update | Update the facade schema and documentation. | P2.5.1 | S | The contract tests cover the new tools. |

### P2.6 Text handling

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P2.6.1 | OCR check | Verify exact in-image text with OCR and record the accuracy score. | P2.2.2 | M | A wrong word in a test image fails the text check. |
| P2.6.2 | Precision routing for text | Route required text to `precision`, per §6.3 and §21.1. | P1.2.3 | S | A test brief with short text uses the precision tier. |
| P2.6.3 | `overlay_text` tool | Generate long text outside the model and overlay it in code (gap G-1). | P1.5.2 | M | Text longer than eight words is rendered without errors. |

### P2.7 Evaluation (§14.3)

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P2.7.1 | Golden set | 100 to 200 briefs in `evals/golden-set/`, covering every purpose, text in image, transparency, edits, and icon composition. | P1.13.3 | L | The set covers each category with reference expectations. |
| P2.7.2 | Runner | `evals/runners/`: run the set against a target environment, score with the critique rubric, OCR, and safety pass rate. | P2.7.1, P2.2.2 | L | A run produces a report per tier and deployment. |
| P2.7.3 | Gate | The gate rule from §14.3: rubric score at least current minus 0.02, text accuracy not worse, p95 latency within budget, cost per accepted image within +20%. | P2.7.2 | M | A degraded candidate fails the gate in a test. |
| P2.7.4 | Human spot checks | Process for a 10% sample per release, documented in `docs/runbooks/spot-checks.md`. | P2.7.2 | S | The process has an owner and a checklist. |

### P2.8 Test environment and delivery (§17)

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P2.8.1 | `test` environment | Parameter file `main.test.bicepparam`, a `test` GitHub environment with its federated credential, and deployment with private endpoints, all tiers, and candidate versions. Bring-your-own virtual network (BYO VNet) for hosted agents must be configured when the Foundry account is created (documented, see [ARCHITECTURE.md section 5.6](ARCHITECTURE.md#56-orchestration-mechanism-research-result)). Private networking for `test` and `prod` therefore cannot be added to an existing account, so create those accounts with it. | P2.2.5, P0.3.6 | L | The `infra-deploy` workflow succeeds for `test`. |
| P2.8.2 | Delivery pipeline | Merge deploys to `test`, runs the evaluation gate, requires manual approval, then deploys to `prod` (§17.3). Model and routing changes go through pull requests. | P2.7.3, P2.8.1 | M | A failing gate blocks the release and reports the result. |
| P2.8.3 | Proxy publishing | Publish the npm package from tagged releases. | P1.11.1 | S | A tag publishes a package version. |
| P2.8.4 | Fallback tests | Force throttling and regional gaps in `test` and verify the fallback chain and circuit breaker. | P1.2.4, P2.8.1 | M | Each row of §6.3 is exercised, and `fallback_used` is correct. |

**Phase 2 exit check:** The evaluation gate runs in CI, fallback is tested, and icons compose correctly.

## Phase 3: More agents and channels

**Goal:** Multi-agent workflows and additional channels.

### P3.1 Copy agent

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P3.1.1 | Agent definition | `agents/copy/agent.yaml`: reasoning model, Foundry IQ for brand voice, and web search. | P2.4.2, P1.7.2 | M | The agent writes a headline and post text in the brand voice on ten sample briefs. |
| P3.1.2 | Copy skill and evaluations | A copy skill, and golden-set cases for copy. | P3.1.1, P2.7.2 | M | The copy cases run in the evaluation runner. |

### P3.2 Brand QA agent

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P3.2.1 | Agent definition | `agents/brand-qa/agent.yaml`: vision model, Foundry IQ, Content Safety, and image analysis. | P2.4.2 | M | The agent flags a wrong palette, a wrong logo usage, and wrong text in test images. |
| P3.2.2 | Report format | A structured QA report returned to the orchestrator. | P3.2.1 | S | The orchestrator consumes the report without parsing free text. |

### P3.3 Workflows

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P3.3.1 | Blog-hero workflow | Copy agent, then image agent with reserved space, then icon composition, then brand QA, then bundle (§5.4). Build it as an Agent Framework workflow in the hosted orchestrator, in code or as a declarative YAML workflow (1.0 in .NET and Python, documented). | P3.1.1, P3.2.1, P2.3.3 | L | The workflow returns one bundle. |
| P3.3.2 | Social-post bundle workflow | The workflow in §8.6: 1024×1024 visual, headline overlay in code, brand QA, and bundle of image, alt text, and post copy. Build it as an Agent Framework workflow in the same orchestrator as P3.3.1. | P3.3.1, P2.6.3 | L | The bundle passes the evaluation gate. |

### P3.4 Channels and governance

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P3.4.1 | Approval workflow | A human approval step for precision-tier assets that are published externally (§11). Depends on D7. Implement it as an Agent Framework human-in-the-loop request (`request_info`), with the approval store that the Foundry hosting provides (documented). | D7, P3.2.1 | L | An unapproved asset cannot be marked as publishable. |
| P3.4.2 | Teams and Copilot Studio channel | Connect through the published agent, using its Responses or A2A endpoint (§4 C1), behind APIM. Which of the two Copilot Studio supports is not verified. | P1.10.1, P2.4.2 | L | A request from Teams returns an image. |
| P3.4.3 | Chargeback reports | Monthly report per APIM product, using usage and estimated cost from the job store (§16). | P1.10.2, P1.3.2 | M | The report totals match the job records. |
| P3.4.4 | Brief-hash caching | Opt-in reuse of assets for identical brief hashes within a tenant (§16). | P1.3.2 | M | An identical brief returns the existing asset and records a cache hit. |
| P3.4.5 | Public labeling | Label externally used outputs as AI-generated, per the channel policy (§11). | P3.4.1 | S | The publish path adds the label. |

**Phase 3 exit check:** The social-post bundle workflow runs in production.

## Phase 4: Hardening and scale

**Goal:** Production-grade security, resilience, and cost control.

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P4.1 | Private networking | Hub-spoke VNet, private endpoints for Foundry, model endpoints, Storage, Cosmos DB, Service Bus, Key Vault, and Content Safety, with public access disabled (§10.3). | P2.8.1 | L | No data-plane endpoint is reachable from the internet. |
| P4.2 | Agent Service network setup | Standard agent setup with BYO VNet where required. For hosted agents the BYO VNet is fixed when the Foundry account is created (see P2.8.1), so this task cannot add it later. | P4.1 | M | The agents run against private resources. |
| P4.3 | Container Apps and APIM isolation | Internal Container Apps environment, and APIM as the only public entry. | P4.1 | M | Direct calls to the services fail from outside the VNet. |
| P4.4 | Egress control | Azure Firewall with an FQDN allowlist for the external provider route, if enabled (D8). | P4.1, D8 | M | Only allowlisted destinations are reachable. |
| P4.5 | Agent identity permissions | Re-grant permissions to the identity of each published agent (§10.1). | P3.4.2 | S | Each published agent works after publishing. |
| P4.6 | RBAC review | Verify every role assignment against §10.2, and require PIM for the platform team. | P4.1 | S | The review is documented, and no unused role remains. |
| P4.7 | Multi-region fallback | Region-aware router, and fallback deployments in an EU Data Zone (§15). | P2.8.4 | L | A simulated regional outage routes to the fallback region. |
| P4.8 | Provisioned throughput evaluation | Compare pay-as-you-go and PTU costs at the observed volume (§16). | P3.4.3 | M | The decision is recorded as an ADR. |
| P4.9 | Disaster recovery | Runbook and a rehearsal in `docs/runbooks/disaster-recovery.md`. | P4.7 | M | A rehearsal restores service within the agreed objective. |
| P4.10 | Threat model verification | Test each threat in §10.4 (prompt injection, exfiltration, key leakage, cost abuse, trademark misuse, SAS sharing). | P4.1 | L | Each threat has a passing test or a documented residual risk. |
| P4.11 | Security review | Independent review, and a report of findings and their resolution. | P4.10 | L | The review passes with no open high-severity finding. |
| P4.12 | Service objectives | Track the availability target of 99.5% and the latency targets for 30 days (§2.2). | P4.9 | M | The objectives are met for 30 consecutive days. |

**Phase 4 exit check:** The security review passes, and the service objectives are met for 30 days.

## Testing

**Goal:** Evidence that each phase delivers the behavior in the architecture, at a cost that fits the image-model quotas.

This section defines the test strategy, test environments, test data, quality gates, and test tasks for AIDevMe Foundry Image Studio. It is written for the engineers and the [tester agent](../project-docs/claude/agents/tester.md), who write and run the tests, and for the owner, who approves releases. Use it to find which test covers a requirement, what blocks a pull request or a promotion, and which test tasks belong to each phase.

Test tasks use identifiers of the form `T<group>.<task>`. They add to the test work that the phases already contain (`P1.1.3`, `P1.2.4`, `P1.13.x`, `P2.2.3`, `P2.7.x`, `P2.8.4`, `P4.10`) and do not repeat it. The rule that every task includes its own tests still applies. The T tasks supply shared harnesses, cross-cutting checks, and cases that no single phase task owns.

> **Note:** No application code, package manifest, or test runner exists yet. Every tool named in this section is a proposal until task `P0.1.2` selects the toolchain for decision D2 (TypeScript on Node.js).

### Test levels

Most tests are unit and contract tests. They run in seconds and need no Azure access. Live tests are few and deliberate, because image quota is 2 to 4 units by default (ARCHITECTURE.md section 15) and each call has a cost.

| Level | What it verifies in this system | Runs in | Dependencies | Existing tasks |
| --- | --- | --- | --- | --- |
| Unit | Router rules, retry and circuit-breaker state, schema validation, error mapping, job state transitions, SAS parameters | Local, PR CI | No network. A fake clock. The routing table is loaded from a fixture copy of `config/routing.yaml`, not stubbed. | P0.7.2, P1.2.3, P1.2.4, P1.13.1 |
| Contract | MCP tool inputs, outputs, and error results for the Image MCP server and the facade. The `ImageProvider` contract. | Local, PR CI | The real MCP server runs in process, and a real MCP client calls it. A fake provider and a fake safety client sit behind their interfaces. | P1.1.3, P2.4.4, P2.5.2 |
| Integration | The server with real Foundry deployments, Blob Storage, Cosmos DB, Content Safety, and App Configuration. Service Bus and workers from Phase 2 on. | `dev`, `test` | Real services only | P1.13.2 |
| End-to-end | VS Code proxy, APIM, facade, agent, Image MCP server, storage, and workspace | `dev`, `test`, `prod` (smoke) | Real services only | P1.13.3 |
| Evaluation | Rubric score, OCR text accuracy, and safety pass rate per tier and deployment, and the gate | `test` | Real models | P0.6.5, P2.7.x |
| Safety and responsible AI | Content Safety, Prompt Shields, the people and logo policies, C2PA preservation, and the rule that blocked output is not stored | `dev`, `test` | Real Content Safety. A fake only for output blocking at contract level. | P1.4.x, P2.3.4, X6 |
| Performance and load | p50 and p95 latency, 429 rate, queue scaling | `test` | Real services, with raised quota | P0.8.2, P1.13.4, P2.1.4 |
| Resilience | Fallback, circuit breaker, dead-letter queue, regional outage, recovery | `test` | Real deployments with injected faults | P2.1.5, P2.8.4, P4.7, P4.9 |
| Security | Authentication, authorization, RBAC, local authentication disabled, threats, secrets | PR CI, `dev`, `test` | Real services only | P0.1.3, P4.6, P4.10, P4.11, X5 |
| Infrastructure | Bicep, workflows, verification checklist, deploy-delete-redeploy cycle | PR CI, `dev` | Real Azure for what-if and deployment | P0.5.1, P0.5.3 |
| Documentation | Links, header tables, the index, model names outside configuration | PR CI | None | X1, X2 |

### Proposed tools

| Purpose | Proposal | Reason |
| --- | --- | --- |
| Test runner and coverage | Vitest with V8 coverage | Native TypeScript and ESM, fake timers for backoff and breaker timing. `node:test` is the alternative with no dependency. |
| Schema validation | The validator chosen in `P0.7.1` (for example Ajv) | Tests must use the same schemas as the services. |
| MCP client in tests | The official MCP TypeScript SDK client | Tests speak the real protocol instead of hand-built JSON. |
| Icon script tests | `pytest` | The icon scripts are Python (ADR-015). |
| Image comparison | `sharp` with `pixelmatch` | Region comparison for icon integrity. |
| Provenance | `c2patool` | Reads C2PA manifests before and after storage. |
| Load | k6 | Scripted load through APIM. |
| Workflow lint | actionlint | Lints the files in `.github/workflows/`. |
| Link check | lychee | Checks links under `docs/`. |

### Rules for fakes and live models

- Do not fake the component under test. Router tests run the real router against a routing-table fixture. MCP schema tests run the real server and validate with the schemas in `src/shared/schemas/`, never with copies.
- Use a fake provider in two cases only: the provider contract tests (`P1.1.3`), which the fake must also pass, and failure injection (429 with `retry-after`, 5xx, timeouts) for retry, circuit breaker, and fallback.
- Implement the fake at the `ImageProvider` interface. Do not mock the HTTP layer of the Foundry SDK.
- Fake the critic only to test the critic-loop controller (`P2.2.3`). Test the critic's judgment at the evaluation level, with labeled images.
- A test that claims live Foundry behavior must call a real deployment. Report a live test that could not run as skipped, not as passed.

### Environments and data

| Environment | Tests | Tiers available | Live image calls per run (proposal) | Trigger |
| --- | --- | --- | --- | --- |
| Local | Unit, contract, icon scripts | None | 0 | Developer |
| PR CI | Unit, contract, lint, scans, Bicep lint and build, documentation checks | None | 0 | Pull request (new workflow, TD3) |
| `dev` | Integration, end-to-end, verification checklist, deploy-delete-redeploy | `draft`, `standard` (capacity 1 each in `main.dev.bicepparam`) | 40 | Manual, or nightly |
| `test` | Evaluation gate, fallback, resilience, load, private network, safety | All tiers and candidate versions | Golden set × 3 attempts at most | Merge to `main` (`P2.8.2`) |
| `prod` | Smoke | All tiers | 1 `draft` image | After each deployment, with approval (TD5) |

PR CI has no Azure access by design. The federated credentials exist only for the `environment:<name>` subjects (ARCHITECTURE.md section 10.1), and this section keeps it that way.

Cost and quota control:

- Use the `draft` tier for live tests unless the tier is the subject of the test.
- Run live calls with a concurrency of one per deployment.
- Stop a live run with a failure when it reaches its call cap. The harness counts calls and sums `usage.est_cost_eur`.
- Tag every test job with the `tenantId` value `test-harness` and the `channel` value `test`, so that chargeback excludes it and clean-up can find it.
- Use the smallest supported size and `count: 1`.
- Run load tests only after the quota increase in `P0.4.2`.

Test data:

- **Golden set** (`P2.7.1`): tag 10 briefs as `smoke` for each deployment to `test`, and use the full set for releases and model upgrades (X4).
- **Fixtures** in `src/shared/test-fixtures/`: PNG files with and without alpha, masks (valid, wrong size, no alpha channel), an image that carries a C2PA manifest, official icon files with their SHA-256 values, a reference image with an embedded instruction, overlay strings with German characters, and routing-table variants (valid, invalid, a model name as a tier).
- **Safety samples**: use a Content Safety custom blocklist term in `dev` and `test` for deterministic block tests, and public Prompt Shields attack samples. Do not store harmful content in the repository.
- **Secrets**: tests use no secrets. Live tests sign in with `DefaultAzureCredential`: the developer's sign-in locally, and OIDC in environment jobs (TD6).

### Routing and resilience cases

Task `T2.1` owns these cases. Each row of ARCHITECTURE.md section 6.3 has at least one named test.

| Rule | Test case | Expected result |
| --- | --- | --- |
| Brief tier set | `tier: draft`, then the fixture table changes the draft deployment | The router selects the deployment from the table, not a hard-coded name. |
| `edit_chain >= 3` | `edit_chain` of 2 and 3 with `tier: standard` | 2 keeps `standard`. 3 and every later step use `precision`. |
| Long in-image text | Required text of 8 and 9 words | 8 words: text stays in the prompt and routes to `precision` (`P2.6.2`). 9 words: the prompt contains no text, and `overlay_text` renders it (TD7). |
| 429 or 5xx after retries | The fake returns 429 four times, then succeeds on the fallback | Three retries, then the next fallback. `fallback_used` is `true` in the output, the job record, and telemetry. |
| Empty fallback chain | `draft` fails after retries | `PROVIDER_UNAVAILABLE`. No other tier is tried. |
| Non-retryable error | The fake returns 400 | No retry and no fallback. |
| Region lacks model or capacity | A capacity fault on the primary deployment | Fallback to another tier in Sweden Central. No deployment in another region is selected (ARCHITECTURE.md section 15, TD9). |
| Budget exceeded | `standard` or `precision` without a hard requirement, then `edit_chain >= 3` | The first is downgraded to `standard`. The second returns `BUDGET_EXCEEDED`, because precision is required. |
| Model name as tier | `tier: gpt-image-2`, and `tier: alternative` from a facade client | Both are rejected with a validation error (`P1.2.5`, ARCHITECTURE.md section 7.2). |
| Retry timing | `retry-after: 7` against a backoff of 2 seconds | The wait is at least 7 seconds. Jitter stays within the configured bounds. |
| Circuit breaker | 5 consecutive failures, then a request, then 60 seconds, then a probe | Open after the fifth failure. The next request goes to the fallback without a call to the open deployment. Half-open after 60 seconds, closed after a successful probe, open again after a failed probe. |
| Breaker isolation | The standard deployment is open | The draft deployment is unaffected. |

### Test tasks

#### T1 Test foundation

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| T1.1 | Test harness | Runner configuration and the scripts `test:unit`, `test:contract`, and `test:live`. Live tests are excluded by default and require `IMAGE_STUDIO_TEST_ENV`. Results are written as JUnit XML and coverage reports. | P0.1.2 | S | `npm test` passes without Azure credentials, and `npm run test:live` refuses to start without a target environment. |
| T1.2 | Fake provider and fault injector | `src/shared/testing/fake-provider.ts` implements `ImageProvider` with scripted results: success, 429 with `retry-after`, 500, 503, timeout, and content-filter rejection. | P1.1.1 | M | The fake passes the `P1.1.3` suite, and each fault can be reproduced from a script. |
| T1.3 | Live budget guard | The call counter, cost cap, concurrency limit, and `test-harness` tenant from [Environments and data](#environments-and-data). | P1.3.2 | S | A run stops at the cap with a clear failure, and its job records carry the test tenant. |
| T1.4 | Pull request workflow | `.github/workflows/ci.yml` on `pull_request`: lint, type check, unit, contract, `pytest`, secret scan, Bicep lint and build, actionlint, and documentation checks. No Azure sign-in. | P0.1.3, P0.5.1 | M | A pull request with a failing test, a fake key, or a Bicep lint error cannot merge. |
| T1.5 | Fixtures | The fixture set from [Environments and data](#environments-and-data), with a source and license note for each file. | P0.7.1 | M | The C2PA fixture verifies with `c2patool`, and the icon hashes match the official files. |

#### T2 Routing and resilience

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| T2.1 | Routing rule tests | All cases in [Routing and resilience cases](#routing-and-resilience-cases). | P1.2.3, T1.2 | M | Each case is a named test, and the suite blocks pull requests. |
| T2.2 | Retry and breaker timing | Fake-clock tests of backoff, `retry-after`, breaker states, and isolation (`P1.2.4`). A `retry-after` value that exceeds the 50-second agent budget makes the request asynchronous or fails fast. | P1.2.4, T1.2 | M | Timing and state changes match ARCHITECTURE.md section 15 without real waiting. |
| T2.3 | Configuration consistency | A static check that every deployment in `config/routing.yaml` exists in `main.<env>.bicepparam`, that versions are pinned, that no `<...>` placeholder remains, and that no moving alias is used (ARCHITECTURE.md section 6.4). | P1.2.1 | S | The check fails for the `dev` parameter file until TD9 defines routing for the tiers that `dev` lacks. |

#### T3 MCP contracts

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| T3.1 | Schema conformance | For the Image MCP server and the facade: `tools/list` matches the shared schemas, and every response of every tool validates against its output schema. | P0.7.1, P1.5.1, P1.9.1 | M | A field removed from a response fails the suite. |
| T3.2 | Error code suite | One test per code through the real tool path: `BLOCKED_BY_SAFETY`, `BUDGET_EXCEEDED`, `UNSUPPORTED_SIZE` (a size above `capabilities().maxSize`), `PROVIDER_UNAVAILABLE`, `INVALID_MASK` (wrong size, no alpha), and `TEXT_OVERFLOW`. Tool failures return an MCP error result. A malformed request returns a protocol error. | P0.7.2, P1.5.2, P2.6.3 | M | All six codes and the protocol error are covered. |
| T3.3 | No-base64 and model-name scans | At run time, scan tool outputs, job records, sidecars, and logs for `data:image/`, the PNG base64 prefix `iVBORw0KGgo`, and base64 runs longer than 1,000 characters. Base64 in an input is rejected. Statically, search `agents/`, `skills/`, `toolboxes/`, the facade schemas, and client configuration documents for model names from `config/routing.yaml` (ADR-002, ADR-009). | P1.5.2, P1.8.1 | S | Each rule has a failing sample, and both scans run in PR CI. |
| T3.4 | Proxy contract | Tool results contain only local paths, and the image and sidecar exist in `OUTPUT_DIR`. A `target_path` outside the workspace, such as `../../.ssh/x.png`, is rejected. | P1.11.2 | M | No result contains image bytes or a SAS URL. |

#### T4 Storage, jobs, and asynchronous work

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| T4.1 | SAS lifetime and scope | The time between `st` and `se` is 15 minutes or less. `skoid` is present (user delegation), `sp=r`, `sr=b`, and `spr=https`. A nightly live test reads the blob after 16 minutes and expects 403. A read without SAS fails. | P1.3.1 | S | Every parameter is asserted, and the expiry test passes in `dev`. |
| T4.2 | Idempotency | Same key and body: one job, one record, one provider call. Two parallel duplicates: one job. Same key with a different body: the behavior from TD8. | P1.3.5, T1.2 | S | The provider call count is one in each duplicate case. |
| T4.3 | Job state machine | Allowed transitions `queued` to `running` to `succeeded`, `failed`, or `blocked`. Other transitions, such as `succeeded` to `running`, are rejected. `get_job_status` returns each state. Precision, `count > 4`, and requests expected to exceed 60 seconds become asynchronous. | P1.5.4, P2.1.2 | M | Every allowed and forbidden transition has a test. |
| T4.4 | Batch and dead-letter behavior | In `test`: a batch of 50 with one poisoned item gives 49 assets and partial success. The poisoned item reaches the dead-letter queue after the retry limit. A worker stopped during an item does not produce a duplicate asset after redelivery. | P2.1.3, P2.1.5 | M | The job reports partial success, and the asset count is 49. |
| T4.5 | Audit trail and provenance | Every asset has a sidecar with the fields in ARCHITECTURE.md section 9.3. C2PA data survives storage (`P1.3.4`) and the proxy download. For each model, record whether its output carries C2PA. | P1.3.4, P1.11.2, T1.5 | S | The manifest in the workspace copy matches the stored asset. |

#### T5 Agents and quality

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| T5.1 | Critic loop branches | A scripted critic drives the real controller: pass at attempt 1, prompt change after failure 1, tier escalation after failure 2, best result and issues after failure 3. It also covers a request that starts at `precision`, where no escalation is possible. | P2.2.3 | M | At most three attempts and one precision escalation occur in every branch. |
| T5.2 | Critic calibration | 30 labeled images (proposal) with known defects: wrong text, a generated logo, an occupied reserved space, a wrong count, and an off-brand palette. | P2.2.2, P2.7.1 | M | The critic flags at least 90% of defects (proposal), and the result is recorded per release. |
| T5.3 | Agent behavior | Automate the checks of `P1.8.4` against the real agent in `dev` with 20 briefs that set `tier: draft`. | P1.8.4, T1.3 | M | The agent asks at most one question, always sets a tier, and never names a model. |
| T5.4 | Orchestrator handoff | Classification cases for `image`, `copy`, `image+copy`, and `review`, and the workflow routing to the image agent. | P2.4.2 | S | Each intent routes to the expected specialist. |

#### T6 Icons and text

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| T6.1 | Icon integrity | Tests for `find_icon.py`, `compose.py`, and `compose_icons`. The source file hash is unchanged. The placed region matches a uniform resample of the source within a per-channel difference of 2 (proposal). The aspect ratio holds within 1 pixel. No provider call occurs. An unknown product returns an error and no substitute. OCR finds the label near each icon. The sidecar lists each icon source. | P0.6.4, P2.3.2, T1.5 | M | A tinted or stretched icon fails the test. |
| T6.2 | Text overlay | OCR matches the exact text, including `Größe`, `Übersicht`, and `Straße`. Text that does not fit returns `TEXT_OVERFLOW`. The result is a new asset with `parent_asset_id`, and the source is unchanged. Fonts come only from the brand container. | P2.6.3 | S | Each case passes with the brand fonts in `dev`. |

#### T7 Safety and responsible AI

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| T7.1 | Content Safety paths | A blocklist term blocks the prompt with `BLOCKED_BY_SAFETY` and no provider call. A blocked output, injected with a fake safety client at contract level, leaves no blob under `assets/` and sets the job to `blocked`. Every block writes a log entry with category and user identifier. | P1.4.1, P1.4.3 | M | No blocked result is stored as an asset. |
| T7.2 | Prompt Shields | Injection in user text, in a reference image that contains instruction text, and in a retrieved brand document. | P1.4.2 | M | Direct and image-borne injections are blocked, and retrieved content does not change the tool calls. |
| T7.3 | Policy cases in the golden set | Requests for a real, identifiable person, a trademarked character, and a product logo. | P2.7.1, P2.3.4 | S | Person and character requests are refused, and logo requests go through `compose_icons` or are refused. |

#### T8 Security

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| T8.1 | Local authentication disabled | A static check that the templates set `disableLocalAuth: true` (Foundry, Cosmos DB, App Configuration, Search, Service Bus) and `allowSharedKeyAccess: false` (Storage). A live check that key-based calls fail (verification step 5). | P0.3.6 | S | Both checks pass in PR CI and in `dev`. |
| T8.2 | RBAC comparison | A machine-readable copy of ARCHITECTURE.md section 10.2 compared with `az role assignment list`. Negative probes: the facade identity cannot write a blob, and the Image MCP identity cannot read Key Vault secrets while the external provider is disabled. | P0.3.5 | M | An extra or broader assignment fails the check. The check supports `P4.6`. |
| T8.3 | Authentication and authorization | No token returns 401. A token without `ImageStudio.User` returns 403. An unauthenticated call to the Image MCP server is rejected. After `P4.3`, a direct call to the facade from outside the virtual network fails. | P1.10.3, P1.5.1 | S | Each case passes in `dev`, and the isolation case passes in `test`. |
| T8.4 | Leak scan | Secret scanning on every pull request (`P0.1.3`, X5). After a live run, scan logs and Application Insights for JWTs, SAS `sig` values, and keys. | P1.12.1 | S | A planted SAS URL in a log line fails the scan. |

#### T9 Infrastructure and pipeline

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| T9.1 | Bicep static checks | Lint, build, parameter-file build, and the placeholder check on each pull request that changes `bicep/`. | P0.5.1, T1.4 | S | A lint error blocks the pull request. |
| T9.2 | What-if review | Parse the what-if result before each deployment, and fail on a delete or replace that the pull request does not declare. | P0.5.1 | S | An unexpected delete stops the deployment. |
| T9.3 | Lifecycle cycle | In `dev`: deploy, verify, delete with purge, and deploy again with the same names. Cover Key Vault recovery, a second delete run that reports resources as already gone, a dry run, a wrong confirmation, and the shared concurrency group. | P0.5.3 | M | The redeployment succeeds without a name conflict. Allow several hours, because API Management takes 30 to 45 minutes. |
| T9.4 | Verification checklist | A TypeScript script in `src/infrastructure/verify/` that runs the seven checks in [INFRASTRUCTURE.md](INFRASTRUCTURE.md#verification) and writes the result to the job summary. Step 7 runs only where private networking is enabled. | P0.3.6, P1.10.1 | M | The script runs after each deployment and fails on any failed step. |
| T9.5 | Workflow lint | actionlint on each pull request that changes `.github/workflows/`. | T1.4 | S | A malformed workflow blocks the pull request. |

#### T10 Performance

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| T10.1 | Load harness | k6 scenarios through APIM for single sync calls, batches, and a mixed load, run in `test`. It supplies the measurements for `P2.1.4`. | P2.1.4, P0.4.2 | M | The 429 rate stays below 5% and the job success rate stays at 97% or higher (ARCHITECTURE.md section 14.2). |
| T10.2 | Latency regression | p50 and p95 per tier compared with the `P0.8.2` baseline and ARCHITECTURE.md section 2.2, as part of the gate. A sync request that would exceed the budget returns a job identifier within 60 seconds. | P1.13.4, P2.7.3 | S | A p95 above the budget fails the gate. |

#### T11 Documentation

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| T11.1 | Documentation checks | Link check under `docs/`, the five header fields in each document, and an entry in `docs/index.md` for each document. | T1.4 | S | A broken link or a missing index entry blocks the pull request. |

### Quality gates

| Gate | Required to pass | Blocks |
| --- | --- | --- |
| Pull request | T1.4 checks, coverage thresholds, T2.3, T3.3, and T9.1, T9.5, and T11.1 when their files change | Merge |
| Promotion to `test` | Merge to `main` and a successful deployment (`P2.8.2`) | Evaluation run |
| Promotion to `prod` | The evaluation gate (`P2.7.3`), live integration and end-to-end tests in `test`, the fallback tests (`P2.8.4`), T8.2, T8.4, and no quarantined test in T2, T3, T7, or T8 | Manual approval |
| After a `prod` deployment | T9.4 steps 1 to 6 and one `draft` end-to-end request | Release. If this fails, roll back to the previous deployment (X4). |

Phase exit evidence:

| Phase | Test evidence required at exit |
| --- | --- |
| 0 | T1.1, T1.4, T8.1, T9.1 to T9.5 green. T9.3 completed once in `dev`. |
| 1 | All T2, T3, and T7.1 to T7.2 tests green, and T4.1 to T4.3 (sync part), T4.5, T5.3, T8.2 to T8.4 green. The `P1.13.4` latency result recorded. |
| 2 | The evaluation gate running for each deployment to `test`. T4.3 (async part), T4.4, T5.1, T5.2, T5.4, T6, T7.3, and T10 green. |
| 3 | The social-post bundle cases added to the golden set and passing the gate. T7.3 extended with the public label (`P3.4.5`). |
| 4 | T8.3 isolation cases and T9.4 step 7 green in `test` and `prod`. `P4.7`, `P4.9`, and `P4.10` results recorded. |

Coverage (proposal, TD2): 90% line and 85% branch coverage for the router, retry, circuit breaker, schemas, and error mapping. 75% line coverage for the rest of each TypeScript service and the icon scripts. Coverage does not replace the named cases above.

Flaky tests:

- A test that fails and then passes on a rerun without a code change is flaky.
- Quarantine a flaky test within one working day, and open an issue with an owner. A quarantined test still runs and reports, but it does not block.
- Keep five or fewer quarantined tests. A quarantined test in T2, T3, T7, or T8 blocks promotion to `prod`.
- Unit and contract tests get no automatic retries. A live test may retry once, and only after a 429, and the retry counts against the budget.
- Assert structure, metadata, and scores for live model output, never pixel equality.

Reporting:

- Each workflow publishes JUnit results and coverage to the job summary and keeps them as artifacts.
- The evaluation runner (`P2.7.2`) publishes a report per tier and deployment. The release records the gate result (Definition of done, item 5).
- The tester agent reports each skipped live test and its reason.

### Test traceability

| Quality attribute or risk | Tests |
| --- | --- |
| Latency (ARCHITECTURE.md section 2.2) | T10.2, P0.8.2, P1.13.4 |
| Availability and fallback | T2.1, T2.2, P2.8.4, P4.7 |
| Security | T8.1 to T8.4, T3.4, P4.10 |
| Data residency (risk R-8) | T2.1 (region row), T2.3 |
| Extensibility | T1.2 with P1.1.3, T2.1 (configuration-only change), T3.3 |
| Auditability | T4.5, T3.1, T7.1 |
| Cost control | T2.1 (budget row), T5.1, T1.3, P1.10.2 |
| Recovery | T9.3, P4.9 |
| Preview models change or are withdrawn | P2.7.3, T2.3 |
| Quota limits for image models | T2.2, T10.1, T1.3 |
| Cost overrun from retries and precision | T5.1, T2.1, T1.3 |
| In-image text errors | T2.1 (text rows), T6.2, P2.6.1 |
| Soft-deleted names block redeployment | T9.3 |
| Trademark or likeness issues | T6.1, T7.3, T5.2 |

| Phase | Test tasks |
| --- | --- |
| 0 | T1.1, T1.4, T1.5, T8.1, T9.1, T9.2, T9.3, T9.4 (steps 1 to 3 and 5), T9.5, T11.1 |
| 1 | T1.2, T1.3, T2.1, T2.2, T2.3, T3.1, T3.3, T3.4, T4.1, T4.2, T4.3 (sync), T4.5, T5.3, T7.1, T7.2, T8.2, T8.3, T8.4, T9.4 (steps 4 and 6) |
| 2 | T3.2, T4.3 (async), T4.4, T5.1, T5.2, T5.4, T6.1, T6.2, T7.3, T10.1, T10.2 |
| 3 | Extensions of T5.4 (copy and review intents) and T7.3 (public label) |
| 4 | T8.3 (isolation), T9.4 (step 7), and reruns of T8.2 with PIM |

### Exit criteria for testing

1. Every T task meets its acceptance criteria in the phase listed above.
2. Every row of ARCHITECTURE.md section 6.3 and every error code in section 7.1 has a named, passing test.
3. The pull request and promotion gates are enforced by required checks and environment approvals.
4. Live test spend stays within the budget from TD4 for each month.
5. No test in T2, T3, T7, or T8 is quarantined at a release.

### Open testing decisions

| ID | Decision | Recommended default |
| --- | --- | --- |
| TD1 | Test runner and libraries | Vitest, decided in `P0.1.2` |
| TD2 | Coverage thresholds | The proposal in [Quality gates](#quality-gates) |
| TD3 | Add a `pull_request` workflow. All three current workflows start manually only. | Yes, with no Azure sign-in |
| TD4 | Monthly budget for live image generation in tests | Owner decision. Required before `T1.3`. |
| TD5 | Who approves `prod` smoke tests | The reviewer of the `prod` GitHub environment |
| TD6 | Identity for live data-plane tests | A separate test identity with data-plane roles in `dev` and `test` only, not the deployment identity |
| TD7 | Exact threshold and word-counting rule for text overlay (ARCHITECTURE.md section 6.3 says "~8 words") | More than 8 words, counted by whitespace |
| TD8 | Idempotency: the result for the same key with a different body, and how the key travels over MCP | Reject with a validation error. Carry the key in request metadata. |
| TD9 | Routing in `dev`, which has no `precision`, fallback, or `alternative` deployment, and the same-region fallback tier for each tier | A routing table per environment |
| TD10 | How often the deploy-delete-redeploy cycle runs, given its duration and ADR-014 purge protection in `dev` | Before each infrastructure release, and monthly |

---

## Cross-cutting work

| ID | Task | Applies to | Acceptance criteria |
| --- | --- | --- | --- |
| X1 | Keep the documentation current | Every phase | After each merged task, the documenter agent reviews all documents, and `docs/index.md` lists every document. |
| X2 | Keep agent and skill documents aligned | `.claude/agents/`, `.claude/skills/` | A change to an agent or skill updates its page under `docs/project-docs/claude/`. |
| X3 | Preview dependency tracking | Models and Foundry features that are in preview | A register in `docs/runbooks/preview-dependencies.md` lists each preview dependency, its isolation point, and its exit plan (§21.1). If D3 is adopted, the register includes the Agent Framework hosting packages (prerelease). |
| X4 | Model version management | All deployments | Deployments use pinned versions and a manual upgrade policy. New versions pass the evaluation gate first, and the previous deployment is kept for one release as a rollback target (§6.4). |
| X5 | Secret hygiene | Repository and CI | No secret appears in the repository, logs, or client configuration. The secret scan runs on every pull request. |
| X6 | Responsible AI controls | All tools and agents | The controls in §11 are covered by tests: no identifiable real people, no generated logos, C2PA preserved, blocked results not stored. |
| X7 | Cost monitoring | All environments | Spend alerts exist at 120% of the daily tenant budget, and estimated cost is recorded per job. |

## Traceability

### Goals to tasks

| Goal (§1.2) | Main tasks |
| --- | --- |
| G1: multi-agent system on Foundry | P1.8.x, P2.2.x, P2.4.x, P3.1.x, P3.2.x |
| G2: multiple models behind tiers | P1.1.x, P1.2.x, P2.2.5 |
| G3: consumption from VS Code | P1.9.x, P1.11.x |
| G4: enterprise governance | P1.4.x, P1.10.x, Phase 4 |
| G5: official Microsoft icons | P0.6.4, P2.3.x |
| G6: measurable quality | P2.7.x |

### Functional requirements to tasks

| Requirement (§2.1) | Main tasks |
| --- | --- |
| FR1: generate images | P1.5.2 |
| FR2: edit images | P1.5.3 |
| FR3: variations and upscale | P2.5.1 |
| FR4: brand grounding | P1.7.x, P1.8.1 |
| FR5: compose official icons | P2.3.x |
| FR6: synchronous and asynchronous jobs | P1.5.2, P2.1.x |
| FR7: save to Blob Storage and the workspace | P1.3.1, P1.11.2 |
| FR8: record job details | P1.3.2, P1.3.4 |

## Definition of done for a phase

A phase is complete when all of the following are true:

1. Every task in the phase meets its acceptance criteria.
2. The exit check for the phase passes in the target environment.
3. The architecture document, this document, and `docs/index.md` reflect the delivered state, with updated versions and dates.
4. No secret is present in the repository.
5. The evaluation gate result (from Phase 2 on) is recorded for the release.
6. The test evidence listed for the phase in [Phase exit evidence](#quality-gates) exists and is green.

## Related documents

- [Architecture](ARCHITECTURE.md): the design that this plan implements
- [Documentation index](../index.md)
- [Generic Document Style](../templates/GENERIC_DOCUMENT_STYLE.md)
- [Agent documentation](../project-docs/claude/agents/documenter.md): the agent that keeps these documents current
