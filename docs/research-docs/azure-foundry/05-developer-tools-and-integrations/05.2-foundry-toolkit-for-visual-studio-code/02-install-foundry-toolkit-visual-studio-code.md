# Install Microsoft Foundry Toolkit for Visual Studio Code

| Field | Value |
| --- | --- |
| **Document Title** | Install Microsoft Foundry Toolkit for Visual Studio Code |
| **Document Location** | `docs/research-docs/azure-foundry/05-developer-tools-and-integrations/05.2-foundry-toolkit-for-visual-studio-code/02-install-foundry-toolkit-visual-studio-code.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Install Microsoft Foundry Toolkit for Visual Studio Code". Install and verify Microsoft Foundry Toolkit for Visual Studio Code from the Visual Studio Marketplace or the Extensions view. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/develop/install-foundry-toolkit-visual-studio-code). Article date: 2026-08-20. Page updated: 2026-08-25. Retrieved: 2026-09-29. Navigation: Developer tools and integrations > Foundry Toolkit for Visual Studio Code > Install Foundry Toolkit.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Install Microsoft Foundry Toolkit for Visual Studio Code from the Visual Studio Marketplace or the Extensions view. When you finish, the Foundry Toolkit view is available in Visual Studio Code.

## Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/Download).
- The [.NET Runtime](https://learn.microsoft.com/en-us/dotnet/core/install/). Foundry Toolkit depends on this runtime.

For a complete Foundry development environment, install [Foundry DevPack](../01-install-cli-sdk.md#install-foundry-devpack) instead of installing Foundry Toolkit by itself. DevPack installs Foundry Toolkit, `azd` and `azd ai`, Foundry Canvas, and Microsoft Foundry Skill to provide a smoother workflow across your editor, terminal, and coding agent. For the full setup, see [Prepare your development environment](../01-install-cli-sdk.md).

## Install Foundry Toolkit

Install the extension from the Visual Studio Marketplace or from within Visual Studio Code.

### Install from the Visual Studio Marketplace

1. Open the [Microsoft Foundry Toolkit for Visual Studio Code extension](https://aka.ms/foundrytk) page.
2. Select **Install**, and follow the prompt to open Visual Studio Code.
3. In Visual Studio Code, complete the installation. Reload the window if prompted.
4. Confirm that the **Foundry Toolkit** icon appears in the Activity Bar.

### Install manually from Visual Studio Code

Use the Extensions view to find and install the extension without leaving Visual Studio Code.

[![Screenshot of the Visual Studio Code Extensions Marketplace showing the Foundry Toolkit for VS Code extension details.](https://learn.microsoft.com/en-us/azure/foundry/media/how-to/get-started-projects-vs-code/install-foundry-toolkit-marketplace.png)](https://learn.microsoft.com/en-us/azure/foundry/media/how-to/get-started-projects-vs-code/install-foundry-toolkit-marketplace.png#lightbox)

1. In the Activity Bar, select **Extensions**.
2. Search for **Foundry Toolkit for VS Code**.
3. In the search results, select the extension published by Microsoft.
4. Select **Install**.
5. Reload the window if prompted.
6. Confirm that the **Foundry Toolkit** icon appears in the Activity Bar.

After installation, open **What's New** under **Help And Feedback** in Foundry Toolkit to review the features and changes in the installed version.

## Confirm the installation

Confirm that the extension activated successfully.

1. Select **Foundry Toolkit** in the Activity Bar.
2. Confirm that **My Resources**, **Developer Tools**, and **Help And Feedback** appear in the Foundry Toolkit view.

## Clean up

This procedure doesn't create Azure resources. If you installed Foundry Toolkit only to evaluate it, open **Extensions**, find **Foundry Toolkit for Visual Studio Code**, and select **Uninstall**. Uninstalling the extension doesn't delete any Azure resources.

## Next step

[Set up a Foundry project](03-set-up-foundry-project-visual-studio-code.md)
