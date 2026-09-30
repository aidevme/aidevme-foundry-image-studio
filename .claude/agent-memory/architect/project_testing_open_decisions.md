---
name: project-testing-open-decisions
description: Open user decisions raised when the Testing section (T-prefixed tasks) of IMPLEMENTATION.md was designed on 2026-09-29; check whether each is resolved before reusing
metadata:
  type: project
---

On 2026-09-29 I proposed a "Testing" section for IMPLEMENTATION.md (task IDs T1.x to T11.x, between Phase 4 and Cross-cutting work). It was returned as text to the caller, not written; check the file to see whether it was adopted.

Open decisions raised (TD1 to TD10), none decided by the user yet:
- TD1 test runner (proposed Vitest; alternatives node:test, Jest), pending P0.1.2.
- TD2 coverage thresholds (proposed 90/85 line/branch for router, resilience, schemas, errors; 75 line elsewhere).
- TD3 new pull_request-triggered CI workflow with no Azure login (all existing workflows are workflow_dispatch only, and federated credentials exist only for environment subjects).
- TD4 monthly budget for live image generation in tests.
- TD5 who approves prod smoke tests.
- TD6 separate test identity for live data-plane tests instead of the deployment identity.
- TD7 exact word-count threshold for the overlay rule (architecture says "~8 words").
- TD8 idempotency behavior for same key with a different body, and how the key travels over MCP.
- TD9 routing behavior in dev, where precision/fallback/alternative deployments are absent but routing.yaml references them; and which "other tier in the same region" is the fallback for region faults.
- TD10 cadence of the deploy-delete-redeploy cycle, which interacts with ADR-014 purge protection in dev.

**Why:** these were left open deliberately because they carry cost, new dependencies, or interface changes.
**How to apply:** before designing more test or CI work, ask whether these were decided; do not assume the proposed defaults were accepted.
