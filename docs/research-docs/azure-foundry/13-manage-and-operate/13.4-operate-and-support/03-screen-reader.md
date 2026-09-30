# Use a screen reader with Microsoft Foundry

| Field | Value |
| --- | --- |
| **Document Title** | Use a screen reader with Microsoft Foundry |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.4-operate-and-support/03-screen-reader.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Use a screen reader with Microsoft Foundry". Learn how to get oriented and navigate Microsoft Foundry with a screen reader. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/tutorials/screen-reader). Article date: 2026-08-27. Page updated: 2026-09-01. Retrieved: 2026-09-29. Navigation: Manage and operate > Operate and support > Use with a screen reader.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

This article is for people who use screen readers such as [Microsoft's Narrator](https://support.microsoft.com/accessibility/windows/narrator/complete-guide-to-narrator), JAWS, NVDA, or Apple's VoiceOver. In this article, you learn the basic structure of Microsoft Foundry and how to navigate efficiently.

## Prerequisites

- A Microsoft Foundry account with access to at least one project.
- Permission to open that project in Foundry portal.
- A supported browser, such as Microsoft Edge, Google Chrome, or Safari, and an active internet connection.
- A screen reader such as Narrator, JAWS, NVDA, or VoiceOver.
- Familiarity with common screen reader landmark and heading navigation commands.

Control labels and page layout can differ slightly between the new and classic experiences and can change over time.

## Get oriented in Foundry portal

Most pages in the new [Microsoft Foundry](https://ai.azure.com/?cid=learnDocs) experience have the following landmark structure:

- Banner has
  - Foundry application title
  - Project selector
  - Search
  - Main section navigation: Home, Discover, Build, Operate, Manage, Docs
  - Settings
  - Profile information
- Left pane has navigation for the section selected in the main navigation. The Home page has no left pane navigation.
- Many pages also have tabs as a third level of navigation.

For efficient navigation, you can use landmarks to move between these sections on the page.

## Switch between portal experiences

You can switch between the classic and new Foundry portal experiences using the **New Foundry** toggle in the top banner.

To switch back to the classic experience:

1. In the top banner, press Tab until focus reaches the **New Foundry** toggle.
2. Select the toggle to switch to the classic experience.

The page reloads with the classic portal interface. Your screen reader announces the page title for the classic experience.

> **Note**
>
> The toggle preserves your current context, such as the project you're working in, when switching between experiences.

## Projects

You enter the portal with a selected project. The **Home**, **Discover**, **Build**, and **Manage** sections display content for your selected project. **Operate** shows information for all your projects, and **Docs** opens product documentation.

To create or switch projects:

1. In [Microsoft Foundry](https://ai.azure.com/?cid=learnDocs), on the top banner, select **Foundry**.
2. Press Tab until you hear a project name.
3. Use the down-arrow to scroll through the list of recent projects.
4. At the end of the list of recent projects, you find options to **View all projects**, **Create new project**, and **View legacy resources**.
5. If you don't hear a project name, return focus to the top banner and select **Foundry** again to reopen the project list.

After you select a project, your screen reader announces the selected project name in the top banner.

## Navigation

In the new Foundry experience, use landmarks and headings to move between these areas:

- Top banner navigation: **Home**, **Discover**, **Build**, **Operate**, **Manage**, and **Docs**.
- Left pane navigation for the selected top-level area.
- Page tabs, when available, as a third navigation level.

To move quickly to feature areas:

1. Use landmark navigation to move to the left pane.
2. Press the down-arrow to move through navigation items.
3. Select a section such as **Build** to access model and tool workflows.
4. If the left pane isn't available, move focus back to the top banner and reselect the project.

After you select a section, your screen reader announces the page title and the navigation items available in that section.

## Use playgrounds

After you select a project:

1. In the top banner navigation, select **Build**.
2. Move to the left navigation landmark.
3. Select **Model** or **Agent**.
4. Select the model or agent you want to interact with.
5. Use heading navigation to move between configuration and interaction areas.
6. If **Model** or **Agent** isn't announced in the left pane, confirm that you're in a project and still in the **Build** section.

When you send a prompt in a chat-style experience, your screen reader should announce new content when the model response is received. If you don't hear a response announcement, move to the chat history region by heading navigation and read the most recent message.

## Evaluations

To create an evaluation in the new Foundry experience:

1. Move to the top navigation landmark and select **Build**.
2. Select **Evaluation**.
3. Select **Create** and complete the dialog fields.
4. Return to the evaluations list and open a run to review details.

Your screen reader announces the evaluation run page title and its main status information.

To export results:

1. Open an evaluation run.
2. Navigate to **Raw JSON** and select it.
3. Select **Copy JSON** to copy.
4. Select **Close** to close the dialog.

To compare evaluation runs:

1. Return to the main evaluations list.
2. Select multiple evaluation runs.
3. Select **Compare** to open a comparison view.

## Verify your navigation setup

After you complete the steps in this article, verify the following outcomes:

- You can move between major page landmarks, such as banner, navigation, and main content.
- You can identify your current portal experience (new or classic) and switch experiences if needed.
- You can return to your previous location after switching views or opening dialogs.
- You can locate your selected project and move to key areas such as **Home**, **Discover**, **Build**, **Operate**, **Manage**, and **Docs**.

## Troubleshoot screen reader navigation

- If focus seems trapped in a panel or dialog, use Esc to close the dialog, then continue with heading or landmark navigation.
- If a control label differs from this article, search for nearby landmarks or headings because labels can vary slightly by experience and updates.
- If the left navigation isn't present, confirm that you selected a project. Some pages don't show full navigation until a project is selected.
- If you lose context after switching between new and classic experiences, reselect your project from the top banner project selector.

## Technical support for customers with disabilities

Microsoft wants to provide the best possible experience for all customers. If you have a disability or have questions related to accessibility, contact the [Microsoft Disability Answer Desk](https://www.microsoft.com/accessibility/disability-answer-desk) for technical assistance. The Disability Answer Desk support team is trained in using many popular assistive technologies. They can offer assistance in English, Spanish, French, and American Sign Language. Go to the Disability Answer Desk site to find the contact details for your region.

If you're a government, commercial, or enterprise customer, contact the [Enterprise Disability Answer Desk](https://support.microsoft.com/accessibility/enterprise-answer-desk).

## Related content

- [What is Microsoft Foundry?](../../01-what-is-microsoft-foundry/01-what-is-foundry.md)
