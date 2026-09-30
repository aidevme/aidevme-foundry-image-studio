---
name: reference-foundry-orchestration-options
description: Status of connected agents, Foundry workflows, Agent Framework workflows, A2A tool, hosted-agent languages (checked 2026-09-29, time-sensitive) for decision D3
metadata:
  type: reference
---

Checked 2026-09-29. TIME-SENSITIVE: re-verify status, dates and language support if older than ~60 days.

- **Connected agents**: classic-only tool (API 2025-05-15-preview), NOT available in the new Foundry Agent Service; recommended replacement is the A2A tool. Agents (classic) retire 2027-03-31. Sources: https://learn.microsoft.com/azure/foundry-classic/agents/how-to/connected-agents , https://learn.microsoft.com/azure/foundry/agents/how-to/migrate (tool availability table).
- **Foundry workflows (portal/YAML, Power Fx)**: preview; retiring 2026-12-01 (designer and in-portal execution). Hosted agents not supported in the designer. Migration: Agent Framework (recommended), Logic Apps, or A2A. Source: https://learn.microsoft.com/azure/foundry/agents/concepts/workflow (ms.date 2026-07-31).
- **Agent Framework**: 1.0 GA 2026-04-02 (.NET, Python); Go in preview; NO TypeScript (private source preview merged 2026-09-17, excludes workflows/MCP/Foundry/hosting). Workflows: fan-out/fan-in, conditions, loops, HITL, checkpoints; declarative YAML 1.0. Sources: https://learn.microsoft.com/agent-framework/overview/ , https://github.com/microsoft/agent-framework/pull/8414
- **Hosted agents**: GA; Python and C# only ("there's no Node.js hosted runtime"). Workflow.as_agent() hostable via Responses; resilient background for workflows; state store; agent Entra identity; BYO VNet (must be set at account creation). Python hosting package is prerelease. Sources: https://learn.microsoft.com/azure/foundry/agents/concepts/hosted-agents , https://learn.microsoft.com/azure/foundry/agents/how-to/deploy-hosted-agent-code , https://learn.microsoft.com/agent-framework/hosting/foundry-hosted-agent
- **A2A tool**: `a2a` (A2A v1.0) GA, JS/TS SDK supported, usable via Toolbox; incoming A2A on prompt agents: text-only, no streaming, Entra only, Foundry Agent Consumer role. Source: https://learn.microsoft.com/azure/foundry/agents/how-to/enable-agent-to-agent-endpoint

Related: [[project-d3-orchestration-recommendation]]
