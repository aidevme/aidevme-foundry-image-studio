# Configure Claude Desktop for Microsoft Foundry

| Field | Value |
| --- | --- |
| **Document Title** | Configure Claude Desktop for Microsoft Foundry |
| **Document Location** | `docs/research-docs/azure-foundry/05-developer-tools-and-integrations/05.3-coding-agents/05-configure-claude-desktop.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Configure Claude Desktop for Microsoft Foundry". Configure Claude Desktop to use Microsoft Foundry as its inference provider for enterprise deployments. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/how-to/configure-claude-desktop). Article date: 2026-07-14. Page updated: 2026-08-13. Retrieved: 2026-09-29. Navigation: Developer tools and integrations > Coding agents > Configure Claude Desktop with Microsoft Foundry.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Anthropic's Claude Desktop runs the Claude Cowork and Claude Code clients. When you configure Claude Desktop to use Microsoft Foundry as the inference provider, all Claude model requests route through your own Foundry resource. Billing stays on your Azure account, conversations remain on user devices, and you can deploy and manage the app through your existing enterprise Mobile Device Management (MDM) tools such as Microsoft Intune, Group Policy, or Jamf.

This article shows you how to set up Claude Desktop with a Microsoft Foundry inference provider, for a single device or for an entire fleet.

## Prerequisites

- An Azure subscription with a valid payment method. If you don't have an Azure subscription, create a [paid Azure account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn). Free trial, student, credit–based accounts, Enterprise accounts in South Korea, and Cloud Solution Provider subscriptions aren't supported for Claude models. For details on these restrictions, see [subscription type and region support](#subscription-type-and-region-support).
- Access to Microsoft Foundry with appropriate permissions to create and manage resources.
- A Microsoft Foundry resource with one or more Claude models deployed. See [Deploy and use Claude models in Microsoft Foundry](../../06-models/06.5-model-support/06-use-foundry-models-claude.md).
- Your Foundry resource name. In the Foundry portal, select **Manage** > **Project details** > **Parent resource** to find it.
- An API key for your Foundry deployment.

### Subscription type and region support

To use Claude models in Microsoft Foundry, you must have a paid Azure subscription with a billing account in a country or region where Anthropic offers the models for purchase. For a list of common subscription-related errors, see [Common error messages and solutions](https://learn.microsoft.com/en-us/marketplace/purchase-saas-offer-in-azure-portal#common-error-messages-and-solutions). The following subscription types are currently not supported:

- Enterprise Accounts located in South Korea
- Cloud Solution Provider subscriptions
- Azure subscriptions that don't have an active pay-as-you-go billing method (for example, student, free trial, or startup credit–based accounts)
- Sponsored subscriptions that only use Azure credits. ***Note**: If you have an account with a credit card on file, the credit card will be charged instead of Azure Credits.*

For a list of supported regions, see [supported geographic locations](https://learn.microsoft.com/en-us/partner-center/marketplace-offers/marketplace-geo-availability-currencies?tabs=g--h--i--j--k#supported-geographic-locations). Note that, Anthropic's "Supported Regions Policy" may apply for the availability in your region, check [supported regions](https://aka.ms/supported_anthropic_regions) for details.

## Set up a single machine

> **Important**
>
> Availability of Claude models in Microsoft Foundry might change. Check the [Foundry Models from partners](../../06-models/06.1-explore-foundry-models/03-models-from-partners.md#anthropic) page for the latest list of available models.

Use this procedure for evaluation or pilot use on an individual device.

1. Install Claude Desktop from [claude.com/download](https://claude.com/download).
2. Open Claude Desktop, then select **Help** > **Troubleshooting** > **Enable Developer Mode**.
3. Select **Developer** > **Configure third-party inference** to open the configuration window. The window is organized into seven sections in the left sidebar. Work through them in order; each maps to a group of configuration keys, and the window validates values as you enter them.
4. Select the **Connection** section on the configuration window.
5. Select **Foundry** as the inference provider.
6. Enter your Foundry resource name and API key.
7. Set your model list by entering your Foundry model deployment names. The first entry in the list is the default model.
8. Configure settings in the other sections of the configuration window. For details on these, see [Build a configuration in the app](https://claude.com/docs/cowork/3p/installation#2-build-a-configuration-in-the-app).
9. Select **Apply locally**. Claude Desktop relaunches in third-party (3P) mode.
10. On the sign-in screen, choose **Start in Cowork on 3P** to begin using Claude Cowork with your Foundry deployment.

## Deploy to your organization with MDM

For fleet-wide rollout via Microsoft Intune, Group Policy, or Jamf, use a managed configuration instead of per-device setup. For a full list of managed configuration keys, see the [Cowork on 3P configuration reference](https://claude.com/docs/cowork/3p/configuration).

1. Complete the single-machine setup on an admin device to validate your configuration.
2. In the configuration window, review the **Firewall allowlist** section and add the listed hostnames to your network egress rules.
3. In the same configuration window, select **Export configuration**. On Windows, save the file as a `.reg` file. On macOS, save it as a `.mobileconfig` file.
4. Deploy the exported configuration file through your MDM to your target device groups.
5. Push the Claude Desktop installer to enrolled devices. When the app launches and finds a managed configuration, it enters 3P mode automatically without requiring users to sign in.

For more details about installing Claude Desktop, see [Installation and setup](https://claude.com/docs/cowork/3p/installation).

## Telemetry and session monitoring

You can export full session telemetry to your own OpenTelemetry collector for audit and usage tracking. Events include:

- User prompts and API requests (with token counts and estimated cost)
- Tool execution results (success/failure, duration)
- Errors and performance metrics
- Session and user attribution for per-team cost breakdowns

Anthropic-bound telemetry (crash reports and product analytics) contains no conversation content and can be fully disabled via managed configuration. For details, see [Telemetry and egress](https://claude.com/docs/cowork/3p/telemetry).

## Operational considerations

- **Data residency**: Conversations are stored on the user's local device. Inference requests go to your Microsoft Foundry endpoint.
- **Compliance**: Anthropic has noted that data-residency and "no conversation data sent to Anthropic" guarantees equivalent to those for Vertex AI and Amazon Bedrock are coming for Microsoft Foundry. Refer to [Anthropic's documentation](https://claude.com/docs/cowork/3p/overview) for the latest status.
- **Billing**: All inference is billed through your Azure account as token-based consumption. There's no seat licensing from Anthropic.
- **Updates**: Auto-updates are enabled by default. You can disable them and redistribute builds through your MDM on your own schedule.

## Related content

- [Configure Claude Code for Microsoft Foundry](04-configure-claude-code.md)
- [Data, privacy, and security for Claude models](../../13-manage-and-operate/13.3-security-and-governance/23-data-privacy.md)
- [Claude models in Microsoft Foundry](../../06-models/06.5-model-support/03-claude-models.md)
- [Deploy and use Claude models in Microsoft Foundry)](../../06-models/06.5-model-support/06-use-foundry-models-claude.md)
- [Claude Docs: Cowork on 3P — Overview](https://claude.com/docs/cowork/overview)
- [Claude Docs: Claude Code Overview](https://code.claude.com/docs/en/overview)
