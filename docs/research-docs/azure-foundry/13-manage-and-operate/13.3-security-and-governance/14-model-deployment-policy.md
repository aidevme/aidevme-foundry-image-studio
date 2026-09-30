# Built-in policies for model deployment in Microsoft Foundry portal

| Field | Value |
| --- | --- |
| **Document Title** | Built-in policies for model deployment in Microsoft Foundry portal |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.3-security-and-governance/14-model-deployment-policy.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Built-in policies for model deployment in Microsoft Foundry portal". Govern AI model deployment in Microsoft Foundry portal with built-in Azure Policy definitions. Approve specific models and enforce eligibility requirements such as source and lifecycle status. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/model-deployment-policy). Article date: 2026-08-18. Page updated: 2026-08-18. Retrieved: 2026-09-29. Navigation: Manage and operate > Security and governance > Policy management > Built-in policy for model deployment.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Azure Policy provides built-in policy definitions that help you govern the deployment of AI models in Microsoft Foundry portal. You can use these policies to control what models your developers can deploy in the Foundry portal.

> **Note**
>
> To deploy and use [model router](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/model-router) while the approved-models policy is assigned, model router and every model included in the deployment must satisfy the policy through either an allowed publisher or an allowed asset ID. If you use publisher-based approval, include `Microsoft` for model router and each publisher represented in the selected routing set, such as `Anthropic` for Claude models. Publisher names are listed on each model's card in the [model catalog](https://learn.microsoft.com/en-us/azure/ai-foundry/how-to/model-catalog-overview). With ARM or CLI, any noncompliant model in the requested set causes the entire deployment to fail. In the Foundry portal, noncompliant models can be excluded and a compliant subset deployed.

## Prerequisites

- An Azure account with an active subscription. If you don't have one, create a [free Azure account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn). Your Azure account lets you access the Foundry portal.
- Permissions to create and assign policies. To create and assign policies, you must be an [Owner](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#owner) or [Resource Policy Contributor](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#resource-policy-contributor) at the Azure subscription or resource group level.
- Familiarity with Azure Policy. To learn more, see [What is Azure Policy?](https://learn.microsoft.com/en-us/azure/governance/policy/overview).

Microsoft Foundry provides built-in Azure Policy definitions to help you govern which models can be deployed in your organization. The following definitions apply to model deployments:

| Policy | Purpose | Status |
| --- | --- | --- |
| **Foundry model deployments should only use approved models** | Restrict deployments to a specific list of models or publishers that your organization explicitly approves. | Generally available |
| **Foundry model deployments should meet eligibility requirements** | Restrict deployments based on model attributes such as source (Direct from Azure) and lifecycle status (Preview). | Generally available |

Both policies are evaluated at **deployment time**. The catalog doesn't hide models. Instead, the **Deploy** action is disabled with a clear reason when a policy blocks the deployment. You can assign one or both policies depending on your governance needs.

> **Note**
>
> These policies also govern the underlying models that [model router](../../06-models/06.1-explore-foundry-models/25-model-router-agents.md) selects from. Model router only routes requests to models that satisfy your assigned policies, so the same approval and eligibility rules apply whether you deploy a model directly or use model router to pick one per request. In addition, dedicated built-in policy definitions for model router are available in public preview. These definitions extend governance to other aspects of model router deployments, including deployment regions, required routing rules, and logging configurations. For more information, see [Govern model router deployments with Azure Policy](../../06-models/06.1-explore-foundry-models/24-model-router-policy.md).

## How these policies work together

The two policies are complementary and address different governance questions:

- **Approved models** answers *"Is this exact model on my organization's allow-list?"* — based on model identity.
- **Eligibility requirements** answers *"Does this model meet my organization's standards for source and maturity?"* — based on model attributes.

If you assign both policies and a model is noncompliant with both, the **Deploy** experience shows the highest-priority reason first (approval, then eligibility), so users get one clear, actionable message.

## Foundry model deployments should only use approved models

Use this policy to restrict deployments to a specific list of models or publishers that your organization explicitly approves.

> **Note**
>
> This policy was previously named *Cognitive Services Deployments should only use approved Registry Models*. The policy definition ID is unchanged, so existing assignments continue to work without any action.

### Assign the approved-models policy

**[Azure CLI]**

Use Azure CLI to find the built-in policy definition and assign it at a scope.

1. Sign in and select the subscription you want to work in:

   ```azurecli
   az login
   az account set --subscription "<subscription-id>"
   ```
2. Find the policy definition ID for the built-in definition:

   ```azurecli
   az policy definition list \
      --query "[?displayName=='Foundry model deployments should only use approved models'].{name:name, id:id}" \
      --output table
   ```

   Expected result: a row that includes the policy `id`.
3. Create a parameters file (example):

   ```json
   {
      "effect": {
         "value": "Deny"
      },
      "allowedPublishers": {
         "value": ["OpenAI"]
      },
      "allowedAssetIds": {
         "value": [
            "azureml://registries/azure-openai/models/gpt-5/",
            "azureml://registries/azure-openai/models/gpt-5.2/versions/1"
         ]
      }
   }
   ```

   Expected result: a JSON file that matches your approved publisher names and model IDs.

   > **Important**
   >
   > Each asset ID is matched as a prefix. An ID without a trailing slash also matches other models whose names begin with the same characters - for example, `azureml://registries/azure-openai/models/gpt-5` matches GPT-5 and also GPT-5.2 and GPT-5.4. Add a trailing slash (`/`) to limit the match to that specific model only - for example, `azureml://registries/azure-openai/models/gpt-5/` matches only GPT-5 (all of its versions) and excludes GPT-5.2 and GPT-5.4. To allow just one version, use the full asset ID, including the version (for example, `azureml://registries/azure-openai/models/gpt-5.2/versions/1`).

   > **Important**
   >
   > The parameter names in this example must match the policy definition you assign. If they differ in your tenant, update the JSON keys to match the policy definition parameters.
4. Assign the policy at a scope (example: subscription scope):

   ```azurecli
   az policy assignment create \
      --name "allow-only-approved-models" \
      --display-name "Allow only approved models" \
      --scope "/subscriptions/<subscription-id>" \
      --policy "<policy-definition-id>" \
      --params @params.json
   ```

   Expected result: the command returns a JSON payload that includes the assignment `id`.

Reference:

- [az policy definition list](https://learn.microsoft.com/en-us/cli/azure/policy/definition#az-policy-definition-list)
- [az policy assignment create](https://learn.microsoft.com/en-us/cli/azure/policy/assignment#az-policy-assignment-create)
- [Azure Policy assignments](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure)

**[Azure portal]**

1. From the [Azure portal](https://portal.azure.com/), select **Policy** from the left side of the page. You can also search for **Policy** in the search bar at the top of the page.
2. From the left side of the Azure Policy Dashboard, select **Authoring** > **Definitions**. Then search for `Foundry model deployments should only use approved models`.
3. Select **Assign** to assign the policy:
   - **Scope**: Select the scope where you want to assign the policy. The scope can be a management group, subscription, or resource group.
   - **Policy definition**: This section already has a value of `Foundry model deployments should only use approved models`.
   - **Assignment name**: Enter a unique name for the assignment.

   You can keep the default values for the rest of the fields or customize them as needed for your organization.
4. Select **Next** at the bottom of the page or the **Parameters** tab at the top of the page.
5. In the **Parameters** tab, clear **Only show parameters that need input or review** to see all fields:
   - **Effect**: Set to [**Deny**](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-deny).

     > **Note**
     >
     > By using the [**audit**](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-audit) option, you can configure the policy to log information to your own compliance dashboard before enforcing the policy.
   - **Allowed Models Publishers**: Enter a list of publisher names in quotes, separated by commas. Here's an example that shows where to find a publisher name:
     1. Go to the [model catalog](https://learn.microsoft.com/en-us/azure/ai-foundry/how-to/model-catalog-overview) in the Foundry portal.
     2. Select a model (for example, GPT-5).
     3. You find publisher name on the model card as shown in the following screenshot. For example, in this case it's `OpenAI`.

        ![Screenshot of model catalog showing a model card with the publisher name highlighted.](https://learn.microsoft.com/en-us/azure/foundry/how-to/media/model-deployment-policy/gpt-5-model-card.png)
   - **Allowed Asset Ids**: Enter a list of model asset IDs in quotes, separated by commas.

     To get the model asset ID strings and model publisher names, use the following steps:
     1. Go to the [model catalog](https://ai.azure.com/explore/models).
     2. For each model you want to allow, select the model to view the details. In the model detail information, copy the **Model ID** value. For example, the value might look like `azureml://registries/azure-openai/models/gpt-5.2/versions/1` for the GPT-5.2 model.

        > **Important**
        >
        > Each asset ID is matched as a prefix. An ID without a trailing slash also matches other models whose names begin with the same characters - for example, `azureml://registries/azure-openai/models/gpt-5` matches GPT-5 and also GPT-5.2 and GPT-5.4. Add a trailing slash (`/`) to limit the match to that specific model only - for example, `azureml://registries/azure-openai/models/gpt-5/` matches only GPT-5 (all of its versions). To allow just one version, use the full asset ID, including the version.
     3. Select the **Review + create** tab and verify that the policy assignment is correct. When ready, select **Create** to assign the policy.
     4. Notify your developers that the policy is in place. They receive an error message if they try to deploy a model that isn't on the list of allowed models.

## Foundry model deployments should meet eligibility requirements

Use this policy to restrict deployments based on **model attributes** rather than specific model identity. This restriction is useful when you want to enforce broader organizational standards - for example, "no preview models in production" or "only Microsoft-direct models" - without maintaining an explicit allow list.

The policy currently supports the following attributes:

| Parameter | Type | Default | Behavior when `true` |
| --- | --- | --- | --- |
| `onlyAllowDirectFromAzure` | Boolean | `false` | Denies deployment of models that aren't Direct from Azure. |
| `denyPreviewModels` | Boolean | `false` | Denies deployment of models whose lifecycle status is Preview. |

Both parameters default to `false`, so an unconfigured assignment imposes no restrictions. Enable the toggles that match your organization's posture.

### Assign the eligibility policy

**[Azure CLI]**

1. Sign in and select the subscription you want to work in:

   ```azurecli
   az login
   az account set --subscription "<subscription-id>"
   ```
2. Find the policy definition ID:

   ```azurecli
   az policy definition list \
      --query "[?displayName=='Foundry model deployments should meet eligibility requirements'].{name:name, id:id}" \
      --output table
   ```
3. Create a parameters file (example - block Preview models, allow any source):

   ```json
   {
      "effect": {
         "value": "Deny"
      },
      "onlyAllowDirectFromAzure": {
         "value": false
      },
      "denyPreviewModels": {
         "value": true
      }
   }
   ```
4. Assign the policy:

   ```azurecli
   az policy assignment create \
      --name "foundry-model-eligibility" \
      --display-name "Foundry model eligibility" \
      --scope "/subscriptions/<subscription-id>" \
      --policy "<policy-definition-id>" \
      --params @params.json
   ```

**[Azure portal]**

1. From the [Azure portal](https://portal.azure.com/), select **Policy**.
2. Select **Authoring** > **Definitions**, and search for `Foundry model deployments should meet eligibility requirements`.
3. Select **Assign**.
4. On the **Basics** tab, set the **Scope** (management group, subscription, or resource group) and an **Assignment name**.
5. On the **Parameters** tab, clear **Only show parameters that need input or review** to see all fields:
   - **Effect**: Set to [**Deny**](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-deny) to block non-compliant deployments, or [**Audit**](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-audit) to log them without blocking.
   - **Only Allow Direct From Azure**: Set to `true` to deny deployment of models that aren't Direct from Azure. Default is `false`.
   - **Deny Preview Models**: Set to `true` to deny deployment of models whose lifecycle status is Preview. Default is `false`.
6. Select **Review + create** and then **Create** to assign the policy.

## What developers see when a deployment is blocked

When a developer attempts to deploy a model that a policy blocks, the **Deploy** action is disabled and a message explains why. The model itself remains visible in the catalog so the developer understands what was attempted.

| Scenario | What the developer sees |
| --- | --- |
| Model is approved and eligible | Deploy enabled. |
| Model isn't on the approved list | Deploy disabled — message indicates the model isn't approved by the organization, with a pointer to contact the subscription or Foundry administrator. |
| Model is approved but doesn't meet eligibility (for example, a Preview model when `denyPreviewModels` is on) | Deploy disabled — message indicates the model doesn't meet the organization's eligibility requirements (source or lifecycle status), with a pointer to contact the administrator. |
| Multiple policies block the deployment | Deploy disabled — the highest-priority reason is shown (approval, then eligibility). |

Each message includes the **policy name** and **assignment ID** so administrators can quickly identify which policy is enforcing the restriction.

## Monitor compliance

To monitor compliance with the policy, follow these steps:

1. From the [Azure portal](https://portal.azure.com/), select **Policy** from the left side of the page. You can also search for **Policy** in the search bar at the top of the page.
2. From the left side of the Azure Policy Dashboard, select **Compliance**. Each policy assignment is listed with the compliance status. To view more details, select the policy assignment.

## Update the policy assignment

To update an existing policy assignment with new models, follow these steps:

1. From the [Azure portal](https://portal.azure.com/), select **Policy** from the left side of the page. You can also search for **Policy** in the search bar at the top of the page.
2. From the left side of the Azure Policy Dashboard, select **Assignments** and find the existing policy assignment. Select the ellipsis (...) next to the assignment and select **Edit assignment**.
3. From the **Parameters** tab, update **Allowed Asset Ids** and **Allowed Models Publishers** with the new approved model IDs and publisher names.
4. From the **Review + Save** tab, select **Save** to update the policy assignment.

## Best practices

- **Granular scoping**: Assign policies at the appropriate scope to balance control and flexibility. For example, apply at the subscription level to control all resources in the subscription, or apply at the resource group level to control resources in a specific group.
- **Policy naming**: Use a consistent naming convention for policy assignments to make it easier to identify the purpose of the policy. Include information such as the purpose and scope in the name.
- **Tags**: Use tags to categorize and manage your policies. For example, tag policies by environment (dev, test, prod) or by department.
- **Documentation**: Keep records of policy assignments and configurations for auditing purposes. Document any changes made to the policy over time.
- **Regular reviews**: Periodically review policy assignments to ensure they align with your organization's requirements.
- **Testing**: Test policies in a nonproduction environment before applying them to production resources.
- **Communication**: Make sure developers are aware of the policies in place and understand the implications for their work.

## Verify policy effectiveness

After you assign the policy, verify that it works as expected:

1. Wait at least 15 minutes for the policy assignment to take effect. New assignments don't apply instantly.
2. Attempt to deploy a model that isn't on the allowed list. If the policy uses the **Deny** effect, the deployment fails with a policy violation error.
3. Confirm that deploying an approved model still succeeds.
4. Check the **Compliance** dashboard in Azure Policy to verify that the policy evaluates resources correctly. Noncompliant resources appear within one compliance evaluation cycle (typically up to 24 hours).

## Troubleshoot policy assignment failures

| Symptom | Cause | Resolution |
| --- | --- | --- |
| Policy assignment fails with a permissions error | Your account lacks the **Owner** or **Resource Policy Contributor** role at the target scope. | Assign the required role and retry. See [Prerequisites](#prerequisites). |
| Policy doesn't block noncompliant deployments | The policy assignment hasn't propagated yet, or the effect is set to **Audit** instead of **Deny**. | Wait at least 15 minutes, then retry. Verify that the **Effect** parameter is set to **Deny**. |
| Approved model is blocked unexpectedly | The model asset ID or publisher name in the policy parameters doesn't match the model exactly. | Compare the parameter values against the model card in the [model catalog](https://ai.azure.com/explore/models). Asset IDs and publisher names are case-sensitive. |
| Compliance dashboard shows no data | Compliance evaluation hasn't completed yet. Azure Policy evaluates new assignments within 24 hours. | Wait for the next evaluation cycle or trigger an [on-demand evaluation scan](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data#on-demand-evaluation-scan). |
| Parameter name mismatch error during assignment | The JSON parameter keys don't match the policy definition. | Run `az policy definition show --name "<definition-id>"` to retrieve the exact parameter names from the definition. Use `allowedPublishers` and `allowedAssetIds`. |

## Related content

- [Azure Policy overview](https://learn.microsoft.com/en-us/azure/governance/policy/overview)
- [Model catalog overview](https://learn.microsoft.com/en-us/azure/ai-foundry/how-to/model-catalog-overview)
- [Govern model router with Azure Policy](../../06-models/06.1-explore-foundry-models/24-model-router-policy.md)
