# Microsoft Foundry Notification Center

| Field | Value |
| --- | --- |
| **Document Title** | Microsoft Foundry Notification Center |
| **Document Location** | `docs/research-docs/azure-foundry/09-observability/09.1-monitoring/01-concept-notification-center.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Microsoft Foundry Notification Center". The Microsoft Foundry Notification Center surfaces security, policy, and performance alerts in one place. Explore key features to keep your AI solutions reliable. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/concepts/concept-notification-center). Article date: 2026-09-18. Page updated: 2026-09-18. Retrieved: 2026-09-29. Navigation: Observability > Monitoring > Notification Center.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Microsoft Foundry Notification Center centralizes all important observability alerts and notifications for your AI agents, models, and projects. Previously, developers had to manually monitor multiple siloed systems and configure Azure Monitor alerts to catch agent issues. This approach was error-prone and time-consuming. Now, the Notification Center automatically aggregates critical signals into a single in-app feed, so you can see and address problems directly within the Foundry portal, without complex setup.

By delivering timely notifications in the same UI where you manage your agents, the Notification Center helps you stay on top of issues in real time and maintain your AI solutions' reliability and compliance.

## When to use the Notification Center

Use the Notification Center when you want a single in-portal feed for critical Foundry signals, without configuring and monitoring multiple Azure Monitor alert rules yourself. For example:

- Catch high-severity Microsoft Defender for Cloud security alerts on your agents or infrastructure.
- Track Azure Policy or guardrail compliance issues across your projects.
- Know when long-running evaluation or training jobs finish or fail.

## Prerequisites

- An active Microsoft Foundry project. To create one, see [Create a project](../../13-manage-and-operate/13.1-set-up-and-configure/07-create-projects.md).
- Access to the [Foundry portal](https://ai.azure.com/).

## Delivery channels

Currently, the Foundry web portal (in-app) delivers notifications. A small badge on the bell icon indicates new unread items whenever they arrive.

## Key capabilities and alert coverage

The Foundry Notification Center provides a comprehensive alerting experience integrated into the Foundry web portal. Key capabilities include:

### Centralized notifications panel

A bell icon in the Foundry portal's header opens the Notification Center panel. This panel shows recent notifications (unread and read) with timestamps (for example, "3m ago") and short descriptions, giving you an immediate overview of new events. You can select any item to see details or navigate to the relevant resource for resolution. A **Dismiss all** action is available to mark all notifications as read (with a confirmation prompt) for quick cleanup.

### View all notifications page

For deeper review, a dedicated expanded view page lists all notifications in a table format, including older or previously read items. Unlike the compact bell panel, this page is designed for detailed review, filtering, and auditing of notifications. You can sort or filter notifications by criteria like type, project, or severity (with more filtering options on the way). The **View all** page ensures you can explore your entire notification history across all categories of events, not just the latest alerts.

### Alert types covered

The Notification Center aggregates multiple categories of key events from across the Foundry environment. It supports four main types of notifications:

- **Security alerts (Defender)**: The Notification Center surfaces high-severity security issues, such as malicious activities or content safety violations flagged by Microsoft Defender for Cloud, through integration with Azure's security alert APIs. These alerts ensure that you're promptly informed of potential threats to your agents or underlying infrastructure.
- **Policy and compliance**: The Notification Center delivers notifications about issues arising from Azure Policy or Foundry's built-in guardrails, such as ML governance policy violations or required compliance actions. You can quickly address governance and compliance concerns.
- **Run completion and other events**: Certain long-running operations in Foundry, such as evaluation runs or model training jobs, trigger notifications upon completion or failure. These events push a notification to the center via Foundry's backend API as soon as they occur, ensuring near-real-time updates for these workflows.

## Use the Notification Center

> **Note**
>
> These steps require portal access. For RBAC role requirements, see [Role-based access control for Microsoft Foundry](../../13-manage-and-operate/13.3-security-and-governance/02-rbac-foundry.md).

### Access notifications

In the Foundry portal, select the Notification Center (bell) icon to open the notifications panel. The panel displays a scrollable list of your most recent notifications, with each entry showing a concise description and an icon or color that indicates its category or importance. New (unread) notifications are highlighted.

### View notification details

To learn more about a notification, select it in the panel. Selecting a notification opens a detailed view or relevant page:

- For agent evaluation alerts or run completions, selecting an item might open the Foundry **Operate** page or evaluation results for the specific agent or run, where you can inspect metrics and logs around the time of the alert.
- For security or policy alerts, selecting a notification directs you to the appropriate details. For example, a deep link to the Azure portal security center or policy compliance page so you can investigate and fix the issue.

### Mark notifications as read

After you review an alert, the panel marks it as read automatically and the visual highlight disappears. In the notifications panel, select **Dismiss all** to mark all current notifications as read at once.

## Related content

- [Observability in generative AI](../01-observability.md)
- [Monitor agents with the Agent Monitoring Dashboard](../../07-agents/07.3-hosted-agents/33-how-to-monitor-agents-dashboard.md)
- [Role-based access control for Microsoft Foundry](../../13-manage-and-operate/13.3-security-and-governance/02-rbac-foundry.md)
- [Guardrails overview](../../12-trust-and-safety/12.1-guardrails-and-controls/01-guardrails-overview.md)
