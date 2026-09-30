# Use Terraform to manage Microsoft Foundry resources

| Field | Value |
| --- | --- |
| **Document Title** | Use Terraform to manage Microsoft Foundry resources |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.1-set-up-and-configure/04-create-resource-terraform.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Use Terraform to manage Microsoft Foundry resources". In this article, you create a Microsoft Foundry resource, a Microsoft Foundry project, using Terraform infrastructure as code templates. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/how-to/create-resource-terraform). Article date: 2026-08-27. Page updated: 2026-09-25. Retrieved: 2026-09-29. Navigation: Manage and operate > Set up and configure > Manage Foundry resources > Manage resources using Terraform.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Use Terraform to automate the creation of [Microsoft Foundry](https://ai.azure.com/?cid=learnDocs) resources, projects, deployments, and connections.

If you already configured a Foundry resource in the Azure portal, you can [export that configuration as Terraform code](#export-an-existing-resource-to-terraform) instead of authoring a configuration from scratch.

You can use either the Terraform [AzAPI Provider](https://learn.microsoft.com/en-us/azure/developer/terraform/overview-azapi-provider) or [AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account) to manage Foundry resources. The AzAPI provider lets you access all Foundry control plane configurations including preview features. The AzureRM variant is limited to core management capabilities.

Terraform state files can include sensitive values. Use a secure backend and access controls for team scenarios.

> **Tip**
>
> For production-ready Terraform configurations that cover common Foundry deployment scenarios, see the [infrastructure-setup-terraform](https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-terraform) folder in the Foundry samples repository. Clone the repository and customize the configurations instead of starting from scratch.

[Terraform](https://www.terraform.io/) enables the definition, preview, and deployment of cloud infrastructure. Using Terraform, you create configuration files using [HCL syntax](https://developer.hashicorp.com/terraform/language/syntax/configuration). The HCL syntax allows you to specify the cloud provider - such as Azure - and the elements that make up your cloud infrastructure. After you create your configuration files, you create an *execution plan* that allows you to preview your infrastructure changes before they're deployed. Once you verify the changes, you apply the execution plan to deploy the infrastructure.

## Provider capabilities

The following table shows which actions each provider supports:

| Action | AzAPI Provider | AzureRM Provider |
| --- | --- | --- |
| Create a resource group | ✅ | ✅ |
| Create a Foundry resource | ✅ | ✅ |
| Configure deployments | ✅ | ✅ |
| Configure projects | ✅ | ✅ |
| Configure a connection to knowledge and tools | ✅ | ✅ |

## Prerequisites

An Azure account with an active subscription. If you don't have one, create a [free Azure account, which includes a free trial subscription](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

- Access to a role that allows you to create a Foundry resource, such as **Foundry Account Owner** or **Foundry Owner** on the subscription or resource group. For more information about permissions, see [Role-based access control for Microsoft Foundry](../13.3-security-and-governance/02-rbac-foundry.md#permissions-for-each-built-in-role).

  > **Important**
  >
  > The Foundry RBAC roles were recently renamed. **Foundry User**, **Foundry Owner**, **Foundry Account Owner**, and **Foundry Project Manager** were previously named Azure AI User, Azure AI Owner, Azure AI Account Owner, and Azure AI Project Manager. You might still see the previous names in some places while the rename rolls out. The role IDs and core permissions are unchanged by the rename.
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli). Run `az login`, and then run `az account show` to verify your active subscription.
- [Install and configure Terraform](https://learn.microsoft.com/en-us/azure/developer/terraform/quickstart-configure).

## Create a basic Foundry configuration

**[AzAPI Provider]**

1. Create a directory to test and run the sample Terraform code. Make this directory your current directory.
2. Create a file named `versions.tf` and add the required provider sources.

   ```terraform
   terraform {
       required_providers {
           azapi = {
               source  = "Azure/azapi"
               version = "~> 2.5"
           }
           random = {
               source  = "hashicorp/random"
               version = "~> 3.6"
           }
       }
   }
   ```
3. Create a file named `providers.tf` and add the following code.

   ```Terraform
   # Setup providers
   provider "azapi" {
     subscription_id = var.subscription_id
   }
   ```
4. Create a file named `main.tf` and add the following code.

   ```Terraform
   ## Create a random string
   ## 
   resource "random_string" "unique" {
     length      = 5
     min_numeric = 5
     numeric     = true
     special     = false
     lower       = true
     upper       = false
   }

   ## Create a resource group for the resources to be stored in
   ##
   resource "azapi_resource" "rg" {
     type      = "Microsoft.Resources/resourceGroups@2021-04-01"
     name      = "tf-319-basic"
     location  = var.location
   }

   ########## Create AI Foundry resource
   ##########

   ## Create the AI Foundry resource
   ##
   resource "azapi_resource" "ai_foundry" {
     type                      = "Microsoft.CognitiveServices/accounts@2025-06-01"
     name                      = "aifoundry${random_string.unique.result}"
     parent_id                 = azapi_resource.rg.id
     location                  = var.location
     schema_validation_enabled = false

     body = {
       kind = "AIServices"
       sku = {
         name = "S0"
       }
       identity = {
         type = "SystemAssigned"
       }

       properties = {
         # Support both Entra ID and API Key authentication for Cognitive Services account
         disableLocalAuth = false

         # Specifies that this is an AI Foundry resourceyes
         allowProjectManagement = true

         # Set custom subdomain name for DNS names created for this Foundry resource
         customSubDomainName = "aifoundry${random_string.unique.result}"
       }
     }
   }

   ## Create a deployment for OpenAI's GPT-4o in the AI Foundry resource
   ##
   resource "azapi_resource" "aifoundry_deployment_gpt_4o" {
     type      = "Microsoft.CognitiveServices/accounts/deployments@2023-05-01"
     name      = "gpt-4o"
     parent_id = azapi_resource.ai_foundry.id
     depends_on = [
       azapi_resource.ai_foundry
     ]

     body = {
       sku = {
         name     = "Standard"
         capacity = 1
       }
       properties = {
         model = {
           format  = "OpenAI"
           name    = "gpt-4o"
           version = "2024-11-20"
         }
       }
     }
   }

   ## Create AI Foundry project
   ##
   resource "azapi_resource" "ai_foundry_project" {
     type                      = "Microsoft.CognitiveServices/accounts/projects@2025-06-01"
     name                      = "project${random_string.unique.result}"
     parent_id                 = azapi_resource.ai_foundry.id
     location                  = var.location
     schema_validation_enabled = false

     body = {
       sku = {
         name = "S0"
       }
       identity = {
         type = "SystemAssigned"
       }

       properties = {
         displayName = "project"
         description = "My first project"
       }
     }
   }
   ```
5. Create a file named `variables.tf` and add the following code.

   ```Terraform
   variable "location" {
     description = "The name of the location to provision the resources to"
     type        = string
   }

   variable "subscription_id" {
     type = string
   }
   ```

**[AzureRM Provider]**

1. Create a directory to test and run the sample Terraform code. Make this directory your current directory.
2. Create a file named `providers.tf` and add the following code.

   ```Terraform
   # Setup providers
   provider "azurerm" {
     features {}
     storage_use_azuread = true
     subscription_id = var.subscription_id
   }
   ```
3. Create a file named `main.tf` and add the following code.

   ```Terraform
   ## Create a random string
   ## 
   resource "random_string" "unique" {
     length      = 5
     min_numeric = 5
     numeric     = true
     special     = false
     lower       = true
     upper       = false
   }

   ## Create a resource group for the resources to be stored in
   ##
   resource "azurerm_resource_group" "rg" {
     name     = "rg-aifoundry${random_string.unique.result}"
     location = var.location
   }

   ## Create an AI Foundry resource
   ##

   resource "azurerm_cognitive_account" "ai_foundry" {
     name                = "aifoundry${random_string.unique.result}"
     location            = var.location
     resource_group_name = azurerm_resource_group.rg.name
     kind                = "AIServices"

     identity {
       type = "SystemAssigned"
     }

     sku_name = "S0"

     # required for stateful development in Foundry including agent service
     custom_subdomain_name = "aifoundry${random_string.unique.result}"
     project_management_enabled = true

     tags = {
       Acceptance = "Test"
     }
   }

   # Create a Foundry project (folder for organizing stateful work)
   resource "azurerm_cognitive_account_project" "example" {
     name                 = "myproject"
     cognitive_account_id = azurerm_cognitive_account.ai_foundry.id
     location             = azurerm_resource_group.rg.location 

     identity {
       type = "SystemAssigned"
     }
   }

   ## Create a deployment for OpenAI's GPT-4o in the AI Foundry resource
   ##
   resource "azurerm_cognitive_deployment" "aifoundry_deployment_gpt_4o" {
     depends_on = [
       azurerm_cognitive_account.ai_foundry
     ]

     name                 = "gpt-4o"
     cognitive_account_id = azurerm_cognitive_account.ai_foundry.id

     sku {
       name     = "GlobalStandard"
       capacity = 1
     }

     model {
       format  = "OpenAI"
       name    = "gpt-4o"
       version = "2024-11-20"
     }
   }
   ```
4. Create a file named `variables.tf` and add the following code.

   ```Terraform
   variable "location" {
     description = "The name of the location to provision the resources to"
     type        = string
   }

   variable "subscription_id" {
     type = string
   }
   ```

Set the required variables in your current shell. Replace `eastus` if you want to deploy to another supported region.

```console
export TF_VAR_subscription_id=$(az account show --query id --output tsv)
export TF_VAR_location=eastus
```

Run `test -n "$TF_VAR_subscription_id" && echo "Subscription configured."` to verify that the subscription variable is set.

**References:**

- [AzAPI provider documentation](https://learn.microsoft.com/en-us/azure/developer/terraform/overview-azapi-provider)
- [AzureRM cognitive_account resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account)
- [Foundry Terraform samples](https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-terraform)

## Initialize Terraform

Run [terraform init](https://www.terraform.io/docs/commands/init.html) to initialize the Terraform deployment. This command downloads the Azure provider required to manage your Azure resources.

```console
terraform init -upgrade
```

**Key points:**

- The `-upgrade` parameter upgrades the necessary provider plugins to the newest version that complies with the configuration's version constraints.

## Create a Terraform execution plan

Run [terraform plan](https://www.terraform.io/docs/commands/plan.html) to create an execution plan.

```console
terraform plan -out main.tfplan
```

**Key points:**

- The `terraform plan` command creates an execution plan, but doesn't execute it. Instead, it determines what actions are necessary to create the configuration specified in your configuration files. This pattern allows you to verify whether the execution plan matches your expectations before making any changes to actual resources.
- The optional `-out` parameter allows you to specify an output file for the plan. Using the `-out` parameter ensures that the plan you reviewed is exactly what is applied.

## Apply a Terraform execution plan

Run [terraform apply](https://www.terraform.io/docs/commands/apply.html) to apply the execution plan to your cloud infrastructure.

```console
terraform apply main.tfplan
```

**Key points:**

- The example `terraform apply` command assumes you previously ran `terraform plan -out main.tfplan`.
- If you specified a different filename for the `-out` parameter, use that same filename in the call to `terraform apply`.
- If you didn't use the `-out` parameter, call `terraform apply` without any parameters.

## Verify your deployment

Run the following commands to verify deployed resources:

```terraform
terraform state list
terraform validate
```

The state list includes the resource group, Foundry resource, model deployment, project, and generated random string. Terraform reports `Success! The configuration is valid.`

## Export an existing resource to Terraform

If you already configured a Foundry resource in the Azure portal, you can export that configuration as Terraform code. The export captures your current resource settings, including network rules, identity configuration, and project associations. Use the exported code as a starting point for managing the resource with Terraform.

1. In the [Azure portal](https://portal.azure.com/), go to your Foundry resource.
2. In the left menu, expand **Automation**, and then select **Export template**.

   [![Screenshot of a Foundry resource left menu with the Automation group expanded and Export template selected.](https://learn.microsoft.com/en-us/azure/foundry/how-to/media/export-template/foundry-resource-export-template-menu.png)](https://learn.microsoft.com/en-us/azure/foundry/how-to/media/export-template/foundry-resource-export-template-menu.png#lightbox)
3. Select the **Terraform** tab to view the generated Terraform code. Use the **AzureRM** or **AzApi** subtab to choose which provider format to export.

   [![Screenshot of the Foundry Export template page with the Terraform tab selected, showing the Download, Open in VS Code, and Copy buttons above the AzureRM and AzApi subtabs and the generated Terraform code.](https://learn.microsoft.com/en-us/azure/foundry/how-to/media/export-template/foundry-export-template-terraform.png)](https://learn.microsoft.com/en-us/azure/foundry/how-to/media/export-template/foundry-export-template-terraform.png#lightbox)
4. Select **Download** to save the file locally, **Open in VS Code** to edit it directly, or **Copy** to copy the code to your clipboard.

> **Note**
>
> The export might complete with warnings if some resource types don't support full export. Review the output and fill in any missing properties manually.

### Import the exported resource into Terraform state

To manage the exported resource with Terraform going forward, import it into your Terraform state. For the AzAPI provider:

```terraform
terraform import azapi_resource.example <resource-id>
```

Replace `<resource-id>` with the full Azure resource ID shown in the exported file (for example, `/subscriptions/.../providers/Microsoft.CognitiveServices/accounts/<name>`).

### Customize the exported configuration

The exported Terraform code contains hardcoded values specific to your subscription and resource group. Before you reuse the configuration:

- Replace hardcoded subscription IDs, resource group names, and resource IDs with [Terraform variables](https://developer.hashicorp.com/terraform/language/values/variables).
- Remove any properties you don't need or that reference resources outside the deployment scope.
- Add or adjust security configurations to match your organization's requirements.

For production-ready Terraform configurations with enterprise security built in, see the [infrastructure-setup-terraform](https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-terraform) folder in the Foundry samples repository.

### Related security configurations

When you customize your configuration, consider adding the following security settings. Choose based on your governance requirements:

| Control | When to add it | Learn more |
| --- | --- | --- |
| **Private endpoints (network isolation)** | Your organization bans public endpoints, or you need to keep traffic on your virtual network for compliance (HIPAA, PCI, FedRAMP). | [Configure network isolation with private endpoints](../13.3-security-and-governance/07-configure-private-link.md) |
| **Customer-managed keys (CMK) for encryption** | You must control the encryption-key lifecycle, rotation cadence, or revocation, or your data classification requires bring-your-own-key. | [Customer-managed key encryption in Microsoft Foundry](../13.3-security-and-governance/11-customer-managed-keys.md) |
| **Role-based access control (RBAC)** | You need least-privilege access for builders versus administrators, or you grant access to multiple teams that share a Foundry resource. | [Configure role-based access control for Foundry](../13.3-security-and-governance/02-rbac-foundry.md) |
| **Custom Azure Policy definitions** | Your platform team enforces a security baseline (allowed regions, required tags, allowed SKUs, mandatory CMK or private link) across every Foundry resource the organization creates. | [Create custom Azure Policy definitions](../13.3-security-and-governance/15-custom-policy-definition.md) |

## Customize security and compliance

To meet security and compliance requirements, customize Foundry with security configurations and by bringing your own storage resources. For example, when using the Agent service, you can opt to bring your own Azure Cosmos DB database, Azure AI Search instance, and Azure Storage Account to store your threads and messages.

For advanced setup samples, see the following repositories:

- [Foundry Samples](https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-terraform) repository contains example Terraform configurations for the most common enterprise security configurations.
- [Terraform Azure Verified Module (Cognitive Services account)](https://registry.terraform.io/modules/Azure/avm-res-cognitiveservices-account/azurerm/latest) is a generic module set to manage the Azure resource type used by Foundry, Azure OpenAI, Azure Speech, Azure Language.
- [Terraform Azure Verified Pattern Module (Foundry)](https://registry.terraform.io/modules/Azure/avm-ptn-aiml-ai-foundry/azurerm/latest) is a reference implementation for Foundry.
- [Terraform Azure Verified Pattern Module (Azure AI and ML Landing Zone)](https://registry.terraform.io/modules/Azure/avm-ptn-aiml-landing-zone/azurerm/latest) provides a reference for the set of resources typically created alongside Foundry for an end-to-end sample.

## Clean up resources

When you no longer need the resources created via Terraform, do the following steps:

1. Run [terraform plan](https://www.terraform.io/docs/commands/plan.html) and specify the `destroy` flag.

   ```console
   terraform plan -destroy -out main.destroy.tfplan
   ```

   **Key points:**
   - The `terraform plan` command creates an execution plan, but doesn't execute it. Instead, it determines what actions are necessary to create the configuration specified in your configuration files. This pattern allows you to verify whether the execution plan matches your expectations before making any changes to actual resources.
   - The optional `-out` parameter allows you to specify an output file for the plan. Using the `-out` parameter ensures that the plan you reviewed is exactly what is applied.
2. Run [terraform apply](https://www.terraform.io/docs/commands/apply.html) to apply the execution plan.

   ```console
   terraform apply main.destroy.tfplan
   ```

## Troubleshoot Terraform on Azure

[Troubleshoot common problems when using Terraform on Azure](https://learn.microsoft.com/en-us/azure/developer/terraform/troubleshoot).

## Next steps

- [See AzureRM reference docs for Foundry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account)
- [Learn more about AzAPI provider](https://learn.microsoft.com/en-us/azure/developer/terraform/overview-azapi-provider)
