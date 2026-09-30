# Contributing to aidevme-foundry-image-studio

Thanks for your interest in contributing. This project is a multi-agent image generation system on Microsoft Foundry: an orchestrator plus specialist agents, tier-based model routing, an MCP server for VS Code, and reusable agent skills.

## Ways to contribute

- **Report a bug** or **request a feature** using the [issue templates](https://github.com/aidevme/aidevme-foundry-image-studio/issues/new/choose).
- **Improve the docs** in [docs/](docs/index.md).
- **Submit code** for the orchestrator, specialist agents, model routing, MCP server or skills.

For anything larger than a small fix, open an issue first so the approach can be agreed before you invest time.

## Getting started

1. Fork the repository and clone your fork.
2. Create a branch from `main`, named for the change (for example `fix/routing-quota-fallback` or `docs/mcp-setup`).
3. Make your change, keeping it focused on one topic.
4. Open a pull request against `main`.

The repository is still being scaffolded and has no build system or test suite yet. When one is added, run its build, lint and test commands before opening a pull request, and document the commands here.

## Pull requests

- Describe what changed and why, and link the related issue.
- Keep pull requests small and focused. Don't mix refactors with behavior changes.
- Update documentation when behavior, configuration or interfaces change.
- Add or update tests for changed behavior once a test suite exists.
- Explain anything you couldn't verify, such as changes that need live Foundry access.

## Security and secrets

- Never commit API keys, tokens, endpoints containing secrets, or `.env` files.
- Don't paste credentials into issues, logs or screenshots.

## Project workflow with Claude Code

The repository ships custom Claude Code subagents in [.claude/agents/](.claude/agents), documented in [docs/project-docs/claude/agents/](docs/index.md#project-docsclaudeagents). You can use them for a typical change:

1. [architect](docs/project-docs/claude/agents/architect.md) designs the change.
2. [developer](docs/project-docs/claude/agents/developer.md) implements it.
3. [tester](docs/project-docs/claude/agents/tester.md) covers it with tests.
4. [reviewer](docs/project-docs/claude/agents/reviewer.md) reviews the diff.
5. [documenter](docs/project-docs/claude/agents/documenter.md) updates the docs.

The repository also ships Claude Code skills in [.claude/skills/](.claude/skills), documented in the [skills overview](docs/project-docs/claude/skills/index.md). The documenter agent preloads the [write-document](docs/project-docs/claude/skills/write-document.md) skill.

Using them is optional, and you're responsible for the quality of what you submit either way.

## Microsoft product icons

The project includes official Microsoft product icons. Use them only as permitted by Microsoft's brand and icon guidelines, and don't alter them.

## License

By contributing, you agree that your contributions are licensed under the [MIT License](LICENSE).
