# Implementation plan

| Field | Value |
| --- | --- |
| **Document Title** | Implementation plan |
| **Document Location** | `docs/aidevme-foundry-image-studio/IMPLEMENTATION.md` |
| **Document Description** | Detailed, ordered implementation list for AIDevMe Foundry Image Studio, derived from the architecture document. It is intended for the engineers who build the system and for the agents that assist them. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-29 |

## Introduction

This document converts [ARCHITECTURE.md](ARCHITECTURE.md) (status: Proposed, v0.1) into work packages that can be assigned, built, and verified. Each task has an identifier, a concrete deliverable, its dependencies, and acceptance criteria. Section references such as "§6.3" point to the architecture document.

Read this document to plan a sprint, to find what blocks a task, or to check whether a change is in scope for the current phase.

## Current state

The repository contains no source code, no infrastructure code, and no build system. It contains only documentation, issue templates, Claude Code subagents, and one skill (see [CLAUDE.md](../../CLAUDE.md)). Every task below therefore starts from an empty codebase.

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
- Each task includes tests, and each changed behavior includes an update to the matching document under `docs/` (use the [documenter agent](../claude/agents/documenter.md)).
- A task is done only when all its acceptance criteria are met and the pull request has passed the checks defined in `P0.5`.
- Model names appear only in configuration (`config/routing.yaml`, deployment templates) and never in agent instructions, tool contracts, or client configuration (ADR-002).

### Phase overview

| Phase | Name | Architecture reference | Exit criteria |
| --- | --- | --- | --- |
| 0 | Foundations | §17, §18, §19 | `azd up` succeeds in `dev`, and one image is generated through the SDK |
| 1 | Image agent MVP | §4, §5, §6, §7, §13 | Developers generate and edit images from VS Code, and jobs are traceable |
| 2 | Quality and orchestration | §8, §14, §15 | The evaluation gate runs in CI, fallback is tested, and icons compose correctly |
| 3 | More agents and channels | §5, §11 | The social-post bundle workflow runs in production |
| 4 | Hardening and scale | §10, §15 | The security review passes, and the service objectives are met for 30 days |

## Decisions required before Phase 0 starts

The architecture leaves these questions open (§21.2). Record each decision as an ADR in `docs/adr/` before the dependent task starts.

| ID | Decision | Blocks | Recommended default |
| --- | --- | --- | --- |
| D1 | Primary Azure region, based on current availability of the gpt-image-2.5 models and MAI-Image | P0.3.1, P0.4.1 | An EU region that hosts the standard-tier model. Verify in the Foundry model catalog. |
| D2 | Implementation language and runtime for the MCP servers, facade, and proxy | P0.1.2 | TypeScript on Node.js for all services and the proxy (the proxy is an npm package). Python only for the icon scripts. |
| D3 | Orchestration mechanism: connected agents, Foundry workflows, or Agent Framework workflows | P2.4.1 | Connected agents for the first version. Revisit if workflows need loops or parallelism. |
| D4 | Source of brand guidelines: SharePoint, repository, or DAM | P1.7.1 | Repository folder `brand/`, indexed into Foundry IQ. |
| D5 | Tenant model: single internal tenant first, or multi-tenant from the start | P1.3.2 | Single tenant with `tenantId` in every key, so multi-tenancy needs no schema change. |
| D6 | Retention and immutability policy for assets and inputs | P1.3.1 | Use the defaults in §9.1. Add immutability only for audited tenants. |
| D7 | Whether an approval workflow is required from Phase 1 | P3.4.1 | Not required in Phase 1. Required in Phase 3 for external publication. |
| D8 | Whether any tenant may use the external OpenAI provider | P1.1.4 | None. Keep the provider disabled. |

## Gaps in the architecture document

The following items are used in the architecture but are not specified. Resolve each one before the related task starts, and update the architecture document.

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
| P0.1.1 | Create the directory layout from §18 | Directories `infra/`, `agents/orchestrator/`, `agents/image/`, `toolboxes/`, `src/image-mcp/`, `src/facade-mcp/`, `src/icon-service/`, `src/shared/`, `src/vscode-proxy/`, `skills/`, `config/`, `evals/golden-set/`, `evals/runners/`, `brand/`, `docs/adr/`, `docs/runbooks/`, `.github/workflows/`. Each directory contains a `README.md` that states its purpose. Fix gap G-5. | D2 | S | The layout matches §18, and `docs/index.md` lists the new documents. |
| P0.1.2 | Initialize the toolchain | Workspace manifest, TypeScript configuration, linter, formatter, test runner, `.editorconfig`, and `.gitignore` (which excludes `.env`, `node_modules`, `.azure/`, and build output). | D2 | S | `npm run lint`, `npm run build`, and `npm test` succeed on an empty workspace. |
| P0.1.3 | Add pre-commit and secret scanning | A pre-commit hook for lint and format, and a secret scanner (for example gitleaks) with a repository baseline. | P0.1.2 | S | A commit that contains a fake key is rejected locally. |
| P0.1.4 | Update `CLAUDE.md` | Add real build, lint, and test commands, and the architecture summary, as the file requires. | P0.1.2 | S | `CLAUDE.md` no longer states that no build system exists. |

### P0.2 Decisions and ADRs

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P0.2.1 | Write ADR-001 to ADR-009 | One file per decision in `docs/adr/`, using the decisions in §20. Include context, decision, consequences, and status. | P0.1.1 | M | Nine files exist, and the statuses match §20. |
| P0.2.2 | Record decisions D1 to D8 | One ADR per decision (ADR-010 onward), or an explicit "deferred" entry with a due phase. | P0.2.1 | S | Every decision in the table above has a status. |
| P0.2.3 | Update the architecture document | Resolve gaps G-1 to G-7 in the architecture, and raise its version. | P0.2.2 | S | The architecture document contains no unresolved gap. |

### P0.3 Infrastructure for the `dev` environment

All modules use Bicep and are deployed with Azure Developer CLI (`azd`). Every resource uses managed identity and data-plane RBAC, with no keys.

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P0.3.1 | Foundry resource and project | `infra/modules/foundry.bicep`: Foundry resource, project, and region from D1. Parameter file for `dev`. | D1, P0.1.1 | M | `azd provision` creates the project. |
| P0.3.2 | Model deployments | `infra/modules/models.bicep`: deployments for draft (`img-draft-gpt-image-1-mini`) and standard (`img-std-gpt-image-2-5-flare`), plus one reasoning and vision model for the agents. Pinned versions, upgrade policy set to manual (§6.4). | P0.3.1, P0.4.1 | M | Each deployment answers a smoke request. |
| P0.3.3 | Data services | `infra/modules/data.bicep`: Storage account (containers `assets`, `inputs`, `brand`, `icons`), Cosmos DB (container `jobs`, partition key `/tenantId`), Key Vault, and App Configuration. Lifecycle rules from §9.1. | P0.3.1 | M | Containers exist, the lifecycle policy is applied, and public access is off for blobs. |
| P0.3.4 | Safety and monitoring | `infra/modules/monitoring.bicep`: Log Analytics, Application Insights, Azure AI Content Safety. | P0.3.1 | S | Telemetry from a test app appears in Application Insights. |
| P0.3.5 | Identities and RBAC | `infra/modules/identity.bicep`: user-assigned managed identities for the facade and the Image MCP server, with the role assignments listed in §10.2. | P0.3.1, P0.3.3, P0.3.4 | M | The role assignments match §10.2, and no assignment is broader than listed. |
| P0.3.6 | `azd` project | `azure.yaml`, `infra/main.bicep`, and per-environment parameter files. | P0.3.1 to P0.3.5 | S | `azd up` completes from a clean subscription in `dev`. |

### P0.4 Access and quota

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P0.4.1 | Request model access | Submit limited-access requests for the image models that require them, and record the approval status in `docs/runbooks/model-access.md`. | D1 | S | The status of each model is recorded. Start immediately because approval time is outside the project's control. |
| P0.4.2 | Request quota | Request quota for the standard tier first, then for the other tiers (§15). | P0.4.1 | S | Quota values are recorded per deployment. |

### P0.5 Continuous integration

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P0.5.1 | Pull request workflow | `.github/workflows/ci.yml`: lint, unit tests, Bicep build and `what-if`, secret scan. | P0.1.2, P0.3.6 | M | A pull request with a lint error fails the workflow. |
| P0.5.2 | Azure federation | OIDC federation between GitHub Actions and Azure, with a role scoped to the `dev` resource group. | P0.3.6 | S | The workflow authenticates without stored secrets. |
| P0.5.3 | Deploy workflow for `dev` | `.github/workflows/deploy-dev.yml`: runs `azd deploy` on merge to `main`. | P0.5.1, P0.5.2 | S | A merge deploys to `dev`. |

### P0.6 Skills

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P0.6.1 | `image-brief` skill | `skills/image-brief/SKILL.md` with the brief schema from §12, tier selection rules, and the rule that `standard` is the default and `precision` requires a reason. | P0.1.1 | M | The skill validates against the schema in `src/shared` (see `P0.7.1`). |
| P0.6.2 | `image-generate` skill | Prompt structure (subject, composition, style, lighting and palette, exact text, constraints), exploration strategy, review checklist, and retry and escalation rules. | P0.6.1 | M | The skill contains the five critique checks from §8.5. |
| P0.6.3 | `image-edit` skill | Edit classification, mask rules, the `Change: ... Keep unchanged: ...` format, one change per call, and drift checks (§8.3). | P0.6.1 | M | The skill states that chains of three or more edits use `precision`. |
| P0.6.4 | `microsoft-product-icons` skill and scripts | `skills/microsoft-product-icons/` with `find_icon.py` and `compose.py`, and the icon sources from §12. | P0.6.1 | L | `find_icon.py "Copilot Studio"` returns an official icon path, and `compose.py` places icons without changing them. |
| P0.6.5 | Skill evaluations and documentation | An `evals/evals.json` per skill, and a document per skill under `docs/claude/skills/`. | P0.6.1 to P0.6.4 | M | Every skill has documented eval cases and a documentation page. |

### P0.7 Shared contracts

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P0.7.1 | JSON schemas | `src/shared/schemas/`: `brief`, `job`, `sidecar`, `generate_image` (input and output), `edit_image`, `compose_icons`, and the facade tool inputs (§7, §9). | P0.1.2 | M | Schemas validate the example documents in the architecture. `tier` is required, and model names are rejected. |
| P0.7.2 | Error catalog | `src/shared/errors.ts`: `BLOCKED_BY_SAFETY`, `BUDGET_EXCEEDED`, `UNSUPPORTED_SIZE`, `PROVIDER_UNAVAILABLE`, `INVALID_MASK`, each mapped to an MCP error result. | P0.7.1 | S | Each error has a unit test. |
| P0.7.3 | Telemetry helper | `src/shared/telemetry.ts`: OpenTelemetry setup and the custom dimensions from §14.1. | P0.3.4 | S | A test span carries all listed dimensions. |
| P0.7.4 | Authentication helper | `src/shared/auth.ts`: `DefaultAzureCredential` wrapper for data-plane and model calls. | P0.3.5 | S | The helper obtains a token for a Foundry deployment in `dev`. |

### P0.8 Spike

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P0.8.1 | Generate one image through the SDK | A script in `src/image-mcp/spikes/` that calls the draft and standard deployments with Entra authentication. | P0.3.2, P0.7.4 | S | One image per tier is saved locally. |
| P0.8.2 | Record the latency baseline | Measure 20 requests per tier and record p50 and p95 in `docs/runbooks/baseline.md`. | P0.8.1 | S | The baseline is documented and is used for the alerts in `P1.12.3`. |

**Phase 0 exit check:** `azd up` succeeds in `dev`, the pull request workflow is green, and `P0.8.1` produces an image.

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
| P1.8.2 | Deployment script | A script that applies `agents/**/agent.yaml` through the Foundry SDK, and is idempotent. | P1.8.1 | M | Running the script twice produces the same state. |
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
| P1.10.1 | APIM instance | `infra/modules/apim.bicep`: the AI gateway with JWT validation for the facade app registration and a product per consumer group. | P1.9.3 | M | A call without a token returns 401, and a call with a valid token reaches the facade. |
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
| P2.1.1 | Service Bus | `infra/modules/servicebus.bicep`: namespace, queue with sessions per job, and a monitored dead-letter queue. | P0.3.1 | M | A message round-trips, and dead-lettered messages are visible. |
| P2.1.2 | Async submission | `generate_image` and `edit_image` accept `async=true`, create a queued job, enqueue work items, and return the job identifier. Requests that exceed 60 seconds, precision jobs, and `count > 4` become asynchronous automatically (§15). | P2.1.1, P1.5.2 | M | The tool returns a job identifier without waiting. |
| P2.1.3 | Worker | A Container Apps job that receives work items, routes, generates, checks safety, stores, and updates the job state. | P2.1.2 | L | A batch of 50 items completes, and failed items report partial success. |
| P2.1.4 | Scaling and back-pressure | KEDA scaling on queue length, and a per-deployment concurrency semaphore. | P2.1.3 | M | Load tests show no 429 storm, and workers scale up and down with the queue. |
| P2.1.5 | Dead-letter handling | Retry policy, dead-letter after the retry limit, and the runbook `docs/runbooks/dead-letter.md`. | P2.1.3 | S | A poisoned message reaches the dead-letter queue, and the alert in §14.2 fires. |

### P2.2 Hosted image agent and critic loop (§5.5, §8.5)

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P2.2.1 | Hosted agent project | Microsoft Agent Framework project for the image agent, with unit tests and a local run. Publish as a hosted agent (ADR-008). | P1.8.2 | L | The hosted agent produces the same results as the prompt agent on the Phase 1 briefs. |
| P2.2.2 | Critique step | A vision-model critique that scores subject, composition, text, brand, and artifacts from 0 to 1, against the brief. | P2.2.1 | L | Scores are recorded in the job record (§9.2). |
| P2.2.3 | Retry and escalation | Attempt 1 fails: improve the prompt. Attempt 2 fails: escalate the tier. Attempt 3 fails: return the best result and the open issues. | P2.2.2 | M | A test sequence reproduces each branch of the flowchart in §8.5. |
| P2.2.4 | A/B mode | Generate with the primary and `alternative` tiers in parallel, score both, and return the better result or both. Store the scores as evaluation data. | P2.2.3, P0.3.2 | L | Both candidates are generated in parallel, and the scores are stored. |
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
| P2.4.1 | Orchestration approach | Implement the approach from D3. | D3, P2.2.1 | M | The mechanism runs one connected-agent call end to end. |
| P2.4.2 | Orchestrator agent | `agents/orchestrator/agent.yaml`: classify intent (`image`, `copy`, `image+copy`, `review`), call the image agent, and expose `get_job_status`. | P2.4.1 | L | Image requests through the orchestrator match the direct image agent results. |
| P2.4.3 | Budgets | Enforce the maximum attempts and maximum precision calls per request. | P2.4.2 | S | A request that exceeds a budget returns `BUDGET_EXCEEDED`. |
| P2.4.4 | Facade switch | Point the facade to the orchestrator without changing its contract (§5.1). | P2.4.2 | S | The facade contract tests pass unchanged. |

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
| P2.8.1 | `test` environment | Parameter file and deployment with private endpoints, all tiers, and candidate versions. | P2.2.5, P0.3.6 | L | `azd up` succeeds for `test`. |
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
| P3.3.1 | Blog-hero workflow | Copy agent, then image agent with reserved space, then icon composition, then brand QA, then bundle (§5.4). | P3.1.1, P3.2.1, P2.3.3 | L | The workflow returns one bundle. |
| P3.3.2 | Social-post bundle workflow | The workflow in §8.6: 1024×1024 visual, headline overlay in code, brand QA, and bundle of image, alt text, and post copy. | P3.3.1, P2.6.3 | L | The bundle passes the evaluation gate. |

### P3.4 Channels and governance

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P3.4.1 | Approval workflow | A human approval step for precision-tier assets that are published externally (§11). Depends on D7. | D7, P3.2.1 | L | An unapproved asset cannot be marked as publishable. |
| P3.4.2 | Teams and Copilot Studio channel | Connect through the connected-agent or API route (§4 C1), behind APIM. | P1.10.1, P2.4.2 | L | A request from Teams returns an image. |
| P3.4.3 | Chargeback reports | Monthly report per APIM product, using usage and estimated cost from the job store (§16). | P1.10.2, P1.3.2 | M | The report totals match the job records. |
| P3.4.4 | Brief-hash caching | Opt-in reuse of assets for identical brief hashes within a tenant (§16). | P1.3.2 | M | An identical brief returns the existing asset and records a cache hit. |
| P3.4.5 | Public labeling | Label externally used outputs as AI-generated, per the channel policy (§11). | P3.4.1 | S | The publish path adds the label. |

**Phase 3 exit check:** The social-post bundle workflow runs in production.

## Phase 4: Hardening and scale

**Goal:** Production-grade security, resilience, and cost control.

| ID | Task | Deliverable and details | Depends on | Size | Acceptance criteria |
| --- | --- | --- | --- | --- | --- |
| P4.1 | Private networking | Hub-spoke VNet, private endpoints for Foundry, model endpoints, Storage, Cosmos DB, Service Bus, Key Vault, and Content Safety, with public access disabled (§10.3). | P2.8.1 | L | No data-plane endpoint is reachable from the internet. |
| P4.2 | Agent Service network setup | Standard agent setup with BYO VNet where required. | P4.1 | M | The agents run against private resources. |
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

## Cross-cutting work

| ID | Task | Applies to | Acceptance criteria |
| --- | --- | --- | --- |
| X1 | Keep the documentation current | Every phase | After each merged task, the documenter agent reviews all documents, and `docs/index.md` lists every document. |
| X2 | Keep agent and skill documents aligned | `.claude/agents/`, `.claude/skills/` | A change to an agent or skill updates its page under `docs/claude/`. |
| X3 | Preview dependency tracking | Models and Foundry features that are in preview | A register in `docs/runbooks/preview-dependencies.md` lists each preview dependency, its isolation point, and its exit plan (§21.1). |
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

## Related documents

- [Architecture](ARCHITECTURE.md): the design that this plan implements
- [Documentation index](../index.md)
- [Generic Document Style](../templates/GENERIC_DOCUMENT_STYLE.md)
- [Agent documentation](../claude/agents/documenter.md): the agent that keeps these documents current
