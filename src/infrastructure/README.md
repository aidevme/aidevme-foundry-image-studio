# infrastructure

Infrastructure code that is not Bicep: TypeScript on Node.js scripts and libraries that configure the Azure and Foundry resources after the Bicep templates have created them.

The Bicep templates themselves are in [bicep/](../../bicep/README.md). Keep the two apart:

| Location | Contains | Created by |
| --- | --- | --- |
| [bicep/](../../bicep/README.md) | Bicep templates and parameter files that provision Azure resources (ARM) | `az deployment sub create`, run by the `infra-deploy` workflow |
| `src/infrastructure/` (this folder) | Code that sets up the objects Bicep cannot create (data plane) | Scripts run after provisioning |

## Planned contents

| Area | What it does | Plan task |
| --- | --- | --- |
| Agent deployment | Applies the agent definitions (`agent.yaml`) through the Foundry SDK, and is idempotent | P1.8.2 |
| Toolbox registration | Registers the Image MCP server and the product skills in a Foundry Toolbox | P1.6.1 |
| Skill publishing | Publishes the product skills to the Foundry Skills API and attaches them to the toolbox | not yet in the plan |
| Routing table | Loads `config/routing.yaml` into App Configuration | P1.2.2 |
| Brand index | Indexes the `brand/` content into Foundry IQ | P1.7.2 |
| Entra objects | Creates the facade app registration and the `ImageStudio.User` app role | P1.10.3 |

Status: not implemented yet. See the [implementation plan](../../docs/aidevme-foundry-image-studio/IMPLEMENTATION.md) and [INFRASTRUCTURE.md](../../docs/aidevme-foundry-image-studio/INFRASTRUCTURE.md).
