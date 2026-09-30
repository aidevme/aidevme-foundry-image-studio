# Prepare your development environment

| Field | Value |
| --- | --- |
| **Document Title** | Prepare your development environment |
| **Document Location** | `docs/research-docs/azure-foundry/05-developer-tools-and-integrations/01-install-cli-sdk.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Prepare your development environment". Set up your development environment with Foundry DevPack, language runtimes, and Git. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/develop/install-cli-sdk). Article date: 2026-08-18. Page updated: 2026-08-28. Retrieved: 2026-09-29. Navigation: Developer tools and integrations > Set up your developer environment.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Prepare your development environment to build with Microsoft Foundry. You need a supported programming language, Git, and the Foundry developer tools that fit your workflow.

> **Tip**
>
> Foundry DevPack is the recommended way to install the developer tools in one command. You can also install each tool separately.

> **Important**
>
> This article covers general prerequisites and developer tools. It doesn't cover scenario-specific SDK packages or authentication code. When your environment is ready, continue to the [quickstart](../04-get-started/02-quickstart-create-foundry-resources.md).

## Prerequisites

- An Azure account with an active subscription. If you don't have one, create a [free Azure account, which includes a free trial subscription](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- Access to the Foundry resource or project that you plan to use. For setup guidance, see [Minimum role assignments to get started](../13-manage-and-operate/13.3-security-and-governance/02-rbac-foundry.md#minimum-role-assignments-to-get-started).

## Install Foundry DevPack

Foundry DevPack installs the Foundry developer tools for your terminal, editor, and coding agent. Select your operating system.

**[Windows]**

```powershell
winget install Microsoft.FoundryDevPack
```

**[macOS]**

```bash
brew install --cask microsoft/foundry/devpack && foundry-devpack install
```

**[Linux]**

```bash
curl -fsSL https://aka.ms/foundry-devpack-install.sh | bash
```

DevPack installs its core tools and adds host extensions only when their apps are present:

| Tool | What you can do |
| --- | --- |
| [`azd` and `azd ai`](05.1-azure-developer-cli/01-cli-agent-development.md) | Scaffold, deploy, evaluate, and automate from the terminal. |
| [Microsoft Foundry Skill](../04-get-started/04.1-what-do-you-want-to-build/05-use-microsoft-foundry-skill.md) | Give coding agents reusable guidance for Foundry workflows. |
| [Microsoft Foundry Toolkit for Visual Studio Code](05.2-foundry-toolkit-for-visual-studio-code/01-get-started-projects-visual-studio-code.md) | Installed only when Visual Studio Code is present. Build, test, evaluate, and deploy from the editor. |
| [Foundry Canvas (preview)](05.3-coding-agents/03-foundry-agent-canvas.md) | Installed only when GitHub Copilot App is present. Design and deploy hosted agents from a guided canvas. |

DevPack doesn't install Visual Studio Code or GitHub Copilot App.

Continue with the following sections to set up your programming language and install Git.

## Work with a programming language

Use the language that your application requires. Select a tab to install its runtime or Visual Studio Code extension.

**[Python]**

Install [Python 3.10 or later](https://www.python.org/downloads/). Python 3.10 is the minimum supported version. Create a virtual environment for your project instead of installing packages globally.

**Windows**

```powershell
py -3 -m venv .venv
.\.venv\Scripts\Activate.ps1
```

**macOS and Linux**

```bash
python3 -m venv .venv
source .venv/bin/activate
```

For editor support, install the [Python extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-python.python).

**[C#]**

Install the latest Long-Term Support version of the [.NET SDK](https://dotnet.microsoft.com/download). For editor support, install [C# Dev Kit for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csdevkit).

**[JavaScript/TypeScript]**

Install [Node.js](https://nodejs.org/). Version 20 or later is recommended.

**[Java]**

Install JDK 17 or later. The [Microsoft Build of OpenJDK](https://learn.microsoft.com/en-us/java/openjdk/download) is a free Long-Term Support distribution. For editor support, install the [Visual Studio Code Extension Pack for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack).

## Install Git

To clone Foundry SDK samples, you need Git. If you don't have Git installed, download and install it from the [Git website](https://git-scm.com/downloads).

## Install developer tools separately

If you don't use Foundry DevPack, select a tab to install only the tooling that you need.

**[azd and azd ai]**

1. [Install the Azure Developer CLI](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd).
2. Install the Foundry extensions:

   ```bash
   azd ext install microsoft.foundry
   ```

To install individual extensions instead of the full bundle, see [Install the Azure Developer CLI Foundry extensions](05.1-azure-developer-cli/02-install-cli-foundry-extensions.md).

For direct, granular management of individual Azure resources, use the Azure CLI (`az`). See [Azure Developer CLI vs Azure CLI](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/azure-developer-cli-vs-azure-cli).

**[Microsoft Foundry Skill]**

Install the [Microsoft Foundry Skill](../04-get-started/04.1-what-do-you-want-to-build/05-use-microsoft-foundry-skill.md) in your coding agent. The installation steps vary by coding-agent host.

**[Microsoft Foundry Toolkit]**

If you use Visual Studio Code, [install Microsoft Foundry Toolkit](https://code.visualstudio.com/docs/intelligentapps/overview#_install-and-setup).

**[Foundry Canvas]**

If you use GitHub Copilot App, [install Foundry Canvas](05.3-coding-agents/03-foundry-agent-canvas.md) to design and deploy hosted agents from a guided canvas.

## Troubleshooting

| Issue | Resolution |
| --- | --- |
| Command not found after installation | Close and reopen your terminal. If you use Visual Studio Code, restart it so that PATH changes take effect. |
| Python isn't found | Use `python3` instead of `python` on macOS or Linux, or install Python 3.10 or later. |
| Permission denied during Python package installation | On macOS or Linux, don't use `sudo pip install`. Use a virtual environment instead. |

## Related content

- [Create Foundry resources with the Microsoft Foundry SDK](../04-get-started/02-quickstart-create-foundry-resources.md)
- [Get started with Foundry](../04-get-started/04.1-what-do-you-want-to-build/03-get-started-code.md)
- [Microsoft Foundry SDK reference for Python](https://learn.microsoft.com/en-us/python/api/overview/azure/ai-projects-readme)
- [Microsoft Foundry SDK reference for .NET](https://learn.microsoft.com/en-us/dotnet/api/overview/azure/ai.projects-readme)
- [Microsoft Foundry SDK reference for JavaScript and TypeScript](https://learn.microsoft.com/en-us/javascript/api/overview/azure/ai-projects-readme)
- [Microsoft Foundry SDK reference for Java](https://learn.microsoft.com/en-us/java/api/overview/azure/ai-projects-readme)
