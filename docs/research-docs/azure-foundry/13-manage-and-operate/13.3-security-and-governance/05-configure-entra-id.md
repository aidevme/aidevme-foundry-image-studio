# Configure keyless authentication with Microsoft Entra ID

| Field | Value |
| --- | --- |
| **Document Title** | Configure keyless authentication with Microsoft Entra ID |
| **Document Location** | `docs/research-docs/azure-foundry/13-manage-and-operate/13.3-security-and-governance/05-configure-entra-id.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Configure keyless authentication with Microsoft Entra ID". Learn how to configure keyless authentication with Microsoft Entra ID for Microsoft Foundry Models. Eliminate the need for API keys, enhance security with RBAC, and simplify compliance. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/how-to/configure-entra-id). Article date: 2026-08-31. Page updated: 2026-08-31. Retrieved: 2026-09-29. Navigation: Manage and operate > Security and governance > Identity > Configure keyless authentication.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

This article explains how to configure keyless authentication with Microsoft Entra ID for Microsoft Foundry Models. Keyless authentication enhances security by eliminating the need for API keys, simplifies the user experience with role-based access control (RBAC), and reduces operational complexity while providing robust compliance support.

## Prerequisites

To complete this article, you need:

- An Azure subscription.
- A Foundry project. This kind of project is managed under a Foundry resource. If you don't have a Foundry project, see [Create a project for Foundry (Foundry projects)](../13.1-set-up-and-configure/07-create-projects.md)
- The endpoint's URL.
- An account with `Microsoft.Authorization/roleAssignments/write` and `Microsoft.Authorization/roleAssignments/delete` permissions, such as the **Owner** or **User Access Administrator** role. For more information, see the next section on [Required Azure roles and permissions](#required-azure-roles-and-permissions).

### Required Azure roles and permissions

Microsoft Entra ID uses role-based access control (RBAC) to manage access to Azure resources. You need different roles, depending on whether you're an administrator setting up authentication, or you're a developer using it to make API calls.

#### For setting up authentication

- **Subscription owner or administrator**: An account with `Microsoft.Authorization/roleAssignments/write` and `Microsoft.Authorization/roleAssignments/delete` permissions, such as the **Owner** or **User Access Administrator** role, required to assign the **Cognitive Services User** role to developers.

#### For making authenticated API calls

- **Cognitive Services User** role: Required for developers to authenticate and make inference API calls using Microsoft Entra ID. This role must be assigned at the scope of your Foundry resource.

#### Role assignment requirements

When assigning roles, specify these three elements:

- **Security principal**: Your user account, service principal, or security group (recommended for managing multiple users)
- **Role definition**: The **Cognitive Services User** role
- **Scope**: Your specific Foundry resource

> **Tip**
>
> Azure role assignments can take up to 5 minutes to propagate. When using security groups, changes to group membership propagate immediately.

#### Custom role (optional)

If you prefer a custom role instead of **Cognitive Services User**, make sure it includes these permissions:

```json
{
  "permissions": [
    {
      "dataActions": [
        "Microsoft.CognitiveServices/accounts/MaaS/*"
      ]
    }
  ]
}
```

For more context on how roles work with Azure resources, see [Understand roles in the context of resource in Azure](#understand-roles-in-the-context-of-resource-in-azure).

**[ai-foundry-portal]**

## Configure Microsoft Entra ID for inference

This section lists the steps to configure Microsoft Entra ID for inference from the Microsoft Foundry resource page in the [Azure portal](https://portal.azure.com/).

[![Screenshot showing the resource to which we configure Microsoft Entra ID.](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/media/configure-entra-id/locate-resource-ai-services.png)](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/media/configure-entra-id/locate-resource-ai-services.png#lightbox)

1. Select the resource name to open it.
2. In the left pane, select **Access control (IAM)**, and then select **Add** > **Add role assignment**.

   [![Screenshot showing how to add a role assignment in the Access control section of the resource in the Azure portal.](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/media/configure-entra-id/resource-aim.png)](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/media/configure-entra-id/resource-aim.png#lightbox)

   > **Tip**
   >
   > Use the **View my access** option to verify which roles are already assigned to you.
3. In **Job function roles**, type **Cognitive Services User**.

   [![Screenshot showing how to select the Cognitive Services User role assignment.](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/media/configure-entra-id/cognitive-services-user.png)](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/media/configure-entra-id/cognitive-services-user.png#lightbox)
4. Select the role and select **Next**.
5. On **Members**, select the user or group you want to grant access to. Use security groups whenever possible because they're easier to manage and maintain.

   [![Screenshot showing how to select the user to whom assign the role.](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/media/configure-entra-id/select-user.png)](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/media/configure-entra-id/select-user.png#lightbox)
6. Select **Next** and finish the wizard.
7. The selected user can now use Microsoft Entra ID for inference.

   > **Tip**
   >
   > Azure role assignments can take up to five minutes to propagate. When working with security groups, adding or removing users from the security group propagates immediately.
8. Verify the role assignment:
   1. On the left pane in the Azure portal, select **Access control (IAM)**.
   2. Select **Check access**.
   3. Search for the user or security group you assigned the role to.
   4. Verify that **Cognitive Services User** appears in their assigned roles.

## Use Microsoft Entra ID in your code

After you configure Microsoft Entra ID in your resource, update your code to use it when you consume the inference endpoint. This example shows how to use the Responses API:

**[Python]**

Install the OpenAI SDK using a package manager like pip:

```bash
pip install openai
```

For Microsoft Entra ID authentication, also install:

```bash
pip install azure-identity
```

Use the package to consume the model. The following example shows how to create a client and make a test call to the Responses API by using Microsoft Entra ID and your model deployment.

Replace `<resource>` with your Foundry resource name. Find it in the Azure portal or by running `az cognitiveservices account list`. Replace `deepseek-v3-0324` with your actual deployment name.

```python
from openai import OpenAI
from azure.identity import DefaultAzureCredential, get_bearer_token_provider

token_provider = get_bearer_token_provider(
    DefaultAzureCredential(), 
    "https://ai.azure.com/.default"
)

client = OpenAI(
    base_url="https://<resource>.openai.azure.com/openai/v1/",
    api_key=token_provider,
)

response = client.responses.create(
    model="deepseek-v3-0324",  # Replace with your model deployment name.
    input="What is Azure AI?",
)

print(response.output_text)
```

Expected output

```output
Azure AI is a comprehensive suite of artificial intelligence services and tools from Microsoft that enables developers to build intelligent applications. It includes services for natural language processing, computer vision, speech recognition, and machine learning capabilities.
```

Reference: [OpenAI Python SDK](https://github.com/openai/openai-python) and [DefaultAzureCredential class](https://learn.microsoft.com/en-us/python/api/azure-identity/azure.identity.defaultazurecredential).

**[C#]**

Install the OpenAI SDK:

```dotnetcli
dotnet add package OpenAI
```

For Microsoft Entra ID authentication, also install the `Azure.Identity` package:

```dotnetcli
dotnet add package Azure.Identity
```

Then, use the package to consume the model. The following example shows how to create a client and make a test call to the Responses API by using Microsoft Entra ID and your model deployment.

Replace `<resource>` with your Foundry resource name (find it in the Azure portal). Replace `deepseek-v3-0324` with your actual deployment name.

```csharp
using Azure.Identity;
using OpenAI;
using OpenAI.Responses;
using System.ClientModel.Primitives;

#pragma warning disable OPENAI001

BearerTokenPolicy tokenPolicy = new(
    new DefaultAzureCredential(),
    "https://ai.azure.com/.default"
);

OpenAIResponseClient client = new(
    model: "deepseek-v3-0324", // Replace with your model deployment name.
    authenticationPolicy: tokenPolicy,
    options: new OpenAIClientOptions()
    {
        Endpoint = new Uri("https://<resource>.openai.azure.com/openai/v1/")
    }
);

OpenAIResponse response = client.CreateResponse("What is Azure AI?");

Console.WriteLine(response.GetOutputText());
```

Expected output:

```output
Azure AI is a comprehensive suite of artificial intelligence services and tools from Microsoft that enables developers to build intelligent applications. It includes services for natural language processing, computer vision, speech recognition, and machine learning capabilities.
```

Reference: [OpenAI .NET SDK](https://github.com/openai/openai-dotnet) and [DefaultAzureCredential class](https://learn.microsoft.com/en-us/dotnet/api/azure.identity.defaultazurecredential).

**[JavaScript]**

Install the OpenAI SDK with npm:

```bash
npm install openai
```

For Microsoft Entra ID authentication, also install:

```bash
npm install @azure/identity
```

Then, use the package to consume the model. The following example shows how to create a client and make a test call to the Responses API by using Microsoft Entra ID and your model deployment.

Replace `<resource>` with your Foundry resource name (find it in the Azure portal or by running `az cognitiveservices account list`). Replace `deepseek-v3-0324` with your actual deployment name.

```javascript
import { DefaultAzureCredential, getBearerTokenProvider } from "@azure/identity";
import { OpenAI } from "openai";

const tokenProvider = getBearerTokenProvider(
    new DefaultAzureCredential(),
    'https://ai.azure.com/.default'
);

const client = new OpenAI({
    baseURL: "https://<resource>.openai.azure.com/openai/v1/",
    apiKey: tokenProvider
});

const response = await client.responses.create({
    model: "deepseek-v3-0324", // Replace with your model deployment name.
    input: "What is Azure AI?"
});

console.log(response.output_text);
```

Expected output:

```output
Azure AI is a comprehensive suite of artificial intelligence services and tools from Microsoft that enables developers to build intelligent applications. It includes services for natural language processing, computer vision, speech recognition, and machine learning capabilities.
```

Reference: [OpenAI Node.js SDK](https://github.com/openai/openai-node) and [DefaultAzureCredential class](https://learn.microsoft.com/en-us/javascript/api/@azure/identity/defaultazurecredential).

**[Java]**

Add the OpenAI SDK to your project. Check the [OpenAI Java GitHub repository](https://github.com/openai/openai-java) for the latest version and installation instructions.

For Microsoft Entra ID authentication, also add:

```xml
<dependency>
    <groupId>com.azure</groupId>
    <artifactId>azure-identity</artifactId>
    <version>1.18.0</version>
</dependency>
```

Then, use the package to consume the model. The following example shows how to create a client and make a test call to the Responses API by using Microsoft Entra ID and your model deployment.

Replace `<resource>` with your Foundry resource name (find it in the Azure portal). Replace `deepseek-v3-0324` with your actual deployment name.

```java
import com.azure.identity.AuthenticationUtil;
import com.azure.identity.DefaultAzureCredential;
import com.azure.identity.DefaultAzureCredentialBuilder;
import com.openai.client.OpenAIClient;
import com.openai.client.okhttp.OpenAIOkHttpClient;
import com.openai.credential.BearerTokenCredential;
import com.openai.models.responses.Response;
import com.openai.models.responses.ResponseCreateParams;

DefaultAzureCredential tokenCredential = new DefaultAzureCredentialBuilder().build();

OpenAIClient client = OpenAIOkHttpClient.builder()
    .baseUrl("https://<resource>.openai.azure.com/openai/v1/")
    .credential(BearerTokenCredential.create(
        AuthenticationUtil.getBearerTokenSupplier(
            tokenCredential, 
            "https://ai.azure.com/.default"
        )
    ))
    .build();

ResponseCreateParams params = ResponseCreateParams.builder()
    .model("deepseek-v3-0324") // Replace with your model deployment name.
    .input("What is Azure AI?")
    .build();

Response response = client.responses().create(params);

// The Responses API has no single output-text accessor; concatenate the output items.
response.output().stream()
    .flatMap(item -> item.message().stream())
    .flatMap(message -> message.content().stream())
    .flatMap(content -> content.outputText().stream())
    .forEach(outputText -> System.out.println(outputText.text()));
```

Expected output:

```output
Azure AI is a comprehensive suite of artificial intelligence services and tools from Microsoft that enables developers to build intelligent applications. It includes services for natural language processing, computer vision, speech recognition, and machine learning capabilities.
```

Reference: [OpenAI Java SDK](https://github.com/openai/openai-java) and [DefaultAzureCredential class](https://learn.microsoft.com/en-us/java/api/com.azure.identity.defaultazurecredential).

**[REST]**

Explore the API design in the [reference section](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/azureopenai/responses?view=rest-microsoft-foundry-v1&preserve-view=true) to see which parameters are available. Insert the authentication (bearer) token in the `Authorization` header.

For example, the [Responses API](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/azureopenai/responses?view=rest-microsoft-foundry-v1&preserve-view=true) reference section details how to use the `/responses` route to generate predictions. The `/openai/v1/` path is included in the root of the URL:

**Request**

Replace `<resource>` with your Foundry resource name (find it in the Azure portal or by running `az cognitiveservices account list`). Replace `deepseek-v3-0324` with your actual deployment name.

The base URL accepts both `https://<resource>.openai.azure.com/openai/v1/` and `https://<resource>.services.ai.azure.com/openai/v1/` formats.

```bash
curl -X POST https://<resource>.openai.azure.com/openai/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AZURE_OPENAI_AUTH_TOKEN" \
  -d '{
      "model": "deepseek-v3-0324",
      "input": "Explain what the bitter lesson is?"
    }'
```

**Response**

If authentication is successful, you receive a `200 OK` response with the response results in the response body:

```json
{
  "id": "resp_...",
  "object": "response",
  "created_at": 1738368234,
  "model": "deepseek-v3-0324",
  "status": "completed",
  "output": [
    {
      "type": "message",
      "role": "assistant",
      "content": [
        {
          "type": "output_text",
          "text": "The bitter lesson refers to a key insight in AI research that emphasizes the importance of general-purpose learning methods that leverage computation, rather than human-designed domain-specific approaches. It suggests that methods which scale with increased computation tend to be more effective in the long run."
        }
      ]
    }
  ],
  "usage": {
    "input_tokens": 28,
    "output_tokens": 52,
    "total_tokens": 80
  }
}
```

Tokens must be issued with scope `https://ai.azure.com/.default`.

For testing purposes, the easiest way to get a valid token for your user account is to use the Azure CLI. In a console, sign in and request a token by running the following Azure CLI commands:

```azurecli
az login
az account get-access-token --resource https://ai.azure.com --query "accessToken" --output tsv
```

This command outputs an access token that you can store in the `$AZURE_OPENAI_AUTH_TOKEN` environment variable.

Reference: [Responses API](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/azureopenai/responses?view=rest-microsoft-foundry-v1&preserve-view=true)

### Options for credential when using Microsoft Entra ID

`DefaultAzureCredential` is an opinionated, ordered sequence of mechanisms for authenticating to Microsoft Entra ID. Each authentication mechanism is a class that's derived from the `TokenCredential` class and is known as a credential. At runtime, `DefaultAzureCredential` attempts to authenticate using the first credential. If that credential fails to acquire an access token, the next credential in the sequence is attempted, and so on, until an access token is obtained. In this way, your app can use different credentials in different environments without writing environment-specific code.

When the preceding code runs on your local development workstation, it looks in the environment variables for an application service principal or at locally installed developer tools, like Visual Studio, for a set of developer credentials. You can use either approach to authenticate the app to Azure resources during local development.

When deployed to Azure, this same code can also authenticate your app to other Azure resources. `DefaultAzureCredential` can retrieve environment settings and managed identity configurations to authenticate to other services automatically.

### Best practices

- Use deterministic credentials in production environments: Strongly consider moving from `DefaultAzureCredential` to one of the following deterministic solutions in production environments:
  - A specific `TokenCredential` implementation, like `ManagedIdentityCredential`. See the [Derived list for options](https://learn.microsoft.com/en-us/dotnet/api/azure.core.tokencredential#definition).
  - A pared-down `ChainedTokenCredential` implementation that's optimized for the Azure environment in which your app runs. `ChainedTokenCredential` essentially creates a specific allowlist of acceptable credential options, like `ManagedIdentity` for production and `VisualStudioCredential` for development.
- Configure system-assigned or user-assigned managed identities to the Azure resources where your code runs, if possible. Configure Microsoft Entra ID access to those specific identities.

## Disable key-based authentication in the resource

Disable key-based authentication when you implement Microsoft Entra ID and fully address compatibility or fallback concerns in all applications that consume the service. You can disable key-based authentication by using Azure CLI or when deploying with Bicep or ARM.

Key-based access is still possible for users that already have keys available to them. To revoke the keys, in the Azure portal, on the left navigation, select **Resource Management** > **Keys and Endpoints** > **Regenerate Key1** and **Regenerate Key2**.

**[programming-language-cli]**

- Install the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/)
- Identify the following information:
  - Your Azure subscription ID
  - Your Microsoft Foundry resource name
  - The resource group where you deployed the Foundry resource

## Configure Microsoft Entra ID for inference

To configure Microsoft Entra ID for inference, follow these steps:

1. Sign in to your Azure subscription.

   ```azurecli
   # Authenticate with Azure and sign in interactively
   az login
   ```
2. If you have more than one subscription, select the subscription where your resource is located.

   ```azurecli
   # Set the active subscription context
   az account set --subscription "<subscription-id>"
   ```
3. Set the following environment variables with the name of the resource and resource group you plan to use.

   ```azurecli
   # Store resource identifiers for reuse in subsequent commands
   ACCOUNT_NAME="<ai-services-resource-name>"
   RESOURCE_GROUP="<resource-group>"
   ```
4. Get the full name of your resource.

   ```azurecli
   # Retrieve the full Azure Resource Manager ID for role assignment scoping
   RESOURCE_ID=$(az resource show -g $RESOURCE_GROUP -n $ACCOUNT_NAME --resource-type "Microsoft.CognitiveServices/accounts" --query id --output tsv)
   ```
5. Get the object ID of the security principal you want to assign permissions to. The following examples show how to get the object ID associated with:

   **Your own signed in account:**

   ```azurecli
   # Get your user's Microsoft Entra ID object ID
   OBJECT_ID=$(az ad signed-in-user show --query id --output tsv)
   ```

   **A security group:**

   ```azurecli
   # Get the object ID for a security group (recommended for production)
   OBJECT_ID=$(az ad group show --group "<group-name>" --query id --output tsv)
   ```

   **A service principal:**

   ```azurecli
   # Get the object ID for a service principal (for app authentication)
   OBJECT_ID=$(az ad sp show --id "<service-principal-guid>" --query id --output tsv)
   ```
6. Assign the **Cognitive Services User** role to the service principal (scoped to the resource). By assigning a role, you grant the service principal access to this resource.

   ```azurecli
   # Grant inference access by assigning the Cognitive Services User role
   az role assignment create --assignee-object-id $OBJECT_ID --role "Cognitive Services User" --scope $RESOURCE_ID
   ```
7. The selected user can now use Microsoft Entra ID for inference.

   > **Tip**
   >
   > Keep in mind that Azure role assignments can take up to five minutes to propagate. Adding or removing users from a security group propagates immediately.
8. Verify the role assignment:

   ```azurecli
   az role assignment list --scope $RESOURCE_ID --assignee $OBJECT_ID --query "[?roleDefinitionName=='Cognitive Services User'].{principalName:principalName, roleDefinitionName:roleDefinitionName}" --output table
   ```

   The output should show the **Cognitive Services User** role assigned to your principal.

## Use Microsoft Entra ID in your code

After you configure Microsoft Entra ID in your resource, update your code to use it when you consume the inference endpoint. The following example shows how to use the Responses API:

**[Python]**

Install the OpenAI SDK using a package manager like pip:

```bash
pip install openai
```

For Microsoft Entra ID authentication, also install:

```bash
pip install azure-identity
```

Use the package to consume the model. The following example shows how to create a client and make a test call to the Responses API by using Microsoft Entra ID and your model deployment.

Replace `<resource>` with your Foundry resource name. Find it in the Azure portal or by running `az cognitiveservices account list`. Replace `deepseek-v3-0324` with your actual deployment name.

```python
from openai import OpenAI
from azure.identity import DefaultAzureCredential, get_bearer_token_provider

token_provider = get_bearer_token_provider(
    DefaultAzureCredential(), 
    "https://ai.azure.com/.default"
)

client = OpenAI(
    base_url="https://<resource>.openai.azure.com/openai/v1/",
    api_key=token_provider,
)

response = client.responses.create(
    model="deepseek-v3-0324",  # Replace with your model deployment name.
    input="What is Azure AI?",
)

print(response.output_text)
```

Expected output

```output
Azure AI is a comprehensive suite of artificial intelligence services and tools from Microsoft that enables developers to build intelligent applications. It includes services for natural language processing, computer vision, speech recognition, and machine learning capabilities.
```

Reference: [OpenAI Python SDK](https://github.com/openai/openai-python) and [DefaultAzureCredential class](https://learn.microsoft.com/en-us/python/api/azure-identity/azure.identity.defaultazurecredential).

**[C#]**

Install the OpenAI SDK:

```dotnetcli
dotnet add package OpenAI
```

For Microsoft Entra ID authentication, also install the `Azure.Identity` package:

```dotnetcli
dotnet add package Azure.Identity
```

Then, use the package to consume the model. The following example shows how to create a client and make a test call to the Responses API by using Microsoft Entra ID and your model deployment.

Replace `<resource>` with your Foundry resource name (find it in the Azure portal). Replace `deepseek-v3-0324` with your actual deployment name.

```csharp
using Azure.Identity;
using OpenAI;
using OpenAI.Responses;
using System.ClientModel.Primitives;

#pragma warning disable OPENAI001

BearerTokenPolicy tokenPolicy = new(
    new DefaultAzureCredential(),
    "https://ai.azure.com/.default"
);

OpenAIResponseClient client = new(
    model: "deepseek-v3-0324", // Replace with your model deployment name.
    authenticationPolicy: tokenPolicy,
    options: new OpenAIClientOptions()
    {
        Endpoint = new Uri("https://<resource>.openai.azure.com/openai/v1/")
    }
);

OpenAIResponse response = client.CreateResponse("What is Azure AI?");

Console.WriteLine(response.GetOutputText());
```

Expected output:

```output
Azure AI is a comprehensive suite of artificial intelligence services and tools from Microsoft that enables developers to build intelligent applications. It includes services for natural language processing, computer vision, speech recognition, and machine learning capabilities.
```

Reference: [OpenAI .NET SDK](https://github.com/openai/openai-dotnet) and [DefaultAzureCredential class](https://learn.microsoft.com/en-us/dotnet/api/azure.identity.defaultazurecredential).

**[JavaScript]**

Install the OpenAI SDK with npm:

```bash
npm install openai
```

For Microsoft Entra ID authentication, also install:

```bash
npm install @azure/identity
```

Then, use the package to consume the model. The following example shows how to create a client and make a test call to the Responses API by using Microsoft Entra ID and your model deployment.

Replace `<resource>` with your Foundry resource name (find it in the Azure portal or by running `az cognitiveservices account list`). Replace `deepseek-v3-0324` with your actual deployment name.

```javascript
import { DefaultAzureCredential, getBearerTokenProvider } from "@azure/identity";
import { OpenAI } from "openai";

const tokenProvider = getBearerTokenProvider(
    new DefaultAzureCredential(),
    'https://ai.azure.com/.default'
);

const client = new OpenAI({
    baseURL: "https://<resource>.openai.azure.com/openai/v1/",
    apiKey: tokenProvider
});

const response = await client.responses.create({
    model: "deepseek-v3-0324", // Replace with your model deployment name.
    input: "What is Azure AI?"
});

console.log(response.output_text);
```

Expected output:

```output
Azure AI is a comprehensive suite of artificial intelligence services and tools from Microsoft that enables developers to build intelligent applications. It includes services for natural language processing, computer vision, speech recognition, and machine learning capabilities.
```

Reference: [OpenAI Node.js SDK](https://github.com/openai/openai-node) and [DefaultAzureCredential class](https://learn.microsoft.com/en-us/javascript/api/@azure/identity/defaultazurecredential).

**[Java]**

Add the OpenAI SDK to your project. Check the [OpenAI Java GitHub repository](https://github.com/openai/openai-java) for the latest version and installation instructions.

For Microsoft Entra ID authentication, also add:

```xml
<dependency>
    <groupId>com.azure</groupId>
    <artifactId>azure-identity</artifactId>
    <version>1.18.0</version>
</dependency>
```

Then, use the package to consume the model. The following example shows how to create a client and make a test call to the Responses API by using Microsoft Entra ID and your model deployment.

Replace `<resource>` with your Foundry resource name (find it in the Azure portal). Replace `deepseek-v3-0324` with your actual deployment name.

```java
import com.azure.identity.AuthenticationUtil;
import com.azure.identity.DefaultAzureCredential;
import com.azure.identity.DefaultAzureCredentialBuilder;
import com.openai.client.OpenAIClient;
import com.openai.client.okhttp.OpenAIOkHttpClient;
import com.openai.credential.BearerTokenCredential;
import com.openai.models.responses.Response;
import com.openai.models.responses.ResponseCreateParams;

DefaultAzureCredential tokenCredential = new DefaultAzureCredentialBuilder().build();

OpenAIClient client = OpenAIOkHttpClient.builder()
    .baseUrl("https://<resource>.openai.azure.com/openai/v1/")
    .credential(BearerTokenCredential.create(
        AuthenticationUtil.getBearerTokenSupplier(
            tokenCredential, 
            "https://ai.azure.com/.default"
        )
    ))
    .build();

ResponseCreateParams params = ResponseCreateParams.builder()
    .model("deepseek-v3-0324") // Replace with your model deployment name.
    .input("What is Azure AI?")
    .build();

Response response = client.responses().create(params);

// The Responses API has no single output-text accessor; concatenate the output items.
response.output().stream()
    .flatMap(item -> item.message().stream())
    .flatMap(message -> message.content().stream())
    .flatMap(content -> content.outputText().stream())
    .forEach(outputText -> System.out.println(outputText.text()));
```

Expected output:

```output
Azure AI is a comprehensive suite of artificial intelligence services and tools from Microsoft that enables developers to build intelligent applications. It includes services for natural language processing, computer vision, speech recognition, and machine learning capabilities.
```

Reference: [OpenAI Java SDK](https://github.com/openai/openai-java) and [DefaultAzureCredential class](https://learn.microsoft.com/en-us/java/api/com.azure.identity.defaultazurecredential).

**[REST]**

Explore the API design in the [reference section](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/azureopenai/responses?view=rest-microsoft-foundry-v1&preserve-view=true) to see which parameters are available. Insert the authentication (bearer) token in the `Authorization` header.

For example, the [Responses API](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/azureopenai/responses?view=rest-microsoft-foundry-v1&preserve-view=true) reference section details how to use the `/responses` route to generate predictions. The `/openai/v1/` path is included in the root of the URL:

**Request**

Replace `<resource>` with your Foundry resource name (find it in the Azure portal or by running `az cognitiveservices account list`). Replace `deepseek-v3-0324` with your actual deployment name.

The base URL accepts both `https://<resource>.openai.azure.com/openai/v1/` and `https://<resource>.services.ai.azure.com/openai/v1/` formats.

```bash
curl -X POST https://<resource>.openai.azure.com/openai/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AZURE_OPENAI_AUTH_TOKEN" \
  -d '{
      "model": "deepseek-v3-0324",
      "input": "Explain what the bitter lesson is?"
    }'
```

**Response**

If authentication is successful, you receive a `200 OK` response with the response results in the response body:

```json
{
  "id": "resp_...",
  "object": "response",
  "created_at": 1738368234,
  "model": "deepseek-v3-0324",
  "status": "completed",
  "output": [
    {
      "type": "message",
      "role": "assistant",
      "content": [
        {
          "type": "output_text",
          "text": "The bitter lesson refers to a key insight in AI research that emphasizes the importance of general-purpose learning methods that leverage computation, rather than human-designed domain-specific approaches. It suggests that methods which scale with increased computation tend to be more effective in the long run."
        }
      ]
    }
  ],
  "usage": {
    "input_tokens": 28,
    "output_tokens": 52,
    "total_tokens": 80
  }
}
```

Tokens must be issued with scope `https://ai.azure.com/.default`.

For testing purposes, the easiest way to get a valid token for your user account is to use the Azure CLI. In a console, sign in and request a token by running the following Azure CLI commands:

```azurecli
az login
az account get-access-token --resource https://ai.azure.com --query "accessToken" --output tsv
```

This command outputs an access token that you can store in the `$AZURE_OPENAI_AUTH_TOKEN` environment variable.

Reference: [Responses API](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/azureopenai/responses?view=rest-microsoft-foundry-v1&preserve-view=true)

### Options for credential when using Microsoft Entra ID

`DefaultAzureCredential` is an opinionated, ordered sequence of mechanisms for authenticating to Microsoft Entra ID. Each authentication mechanism is a class that's derived from the `TokenCredential` class and is known as a credential. At runtime, `DefaultAzureCredential` attempts to authenticate using the first credential. If that credential fails to acquire an access token, the next credential in the sequence is attempted, and so on, until an access token is obtained. In this way, your app can use different credentials in different environments without writing environment-specific code.

When the preceding code runs on your local development workstation, it looks in the environment variables for an application service principal or at locally installed developer tools, like Visual Studio, for a set of developer credentials. You can use either approach to authenticate the app to Azure resources during local development.

When deployed to Azure, this same code can also authenticate your app to other Azure resources. `DefaultAzureCredential` can retrieve environment settings and managed identity configurations to authenticate to other services automatically.

### Best practices

- Use deterministic credentials in production environments: Strongly consider moving from `DefaultAzureCredential` to one of the following deterministic solutions in production environments:
  - A specific `TokenCredential` implementation, like `ManagedIdentityCredential`. See the [Derived list for options](https://learn.microsoft.com/en-us/dotnet/api/azure.core.tokencredential#definition).
  - A pared-down `ChainedTokenCredential` implementation that's optimized for the Azure environment in which your app runs. `ChainedTokenCredential` essentially creates a specific allowlist of acceptable credential options, like `ManagedIdentity` for production and `VisualStudioCredential` for development.
- Configure system-assigned or user-assigned managed identities to the Azure resources where your code runs, if possible. Configure Microsoft Entra ID access to those specific identities.

## Disable key-based authentication in the resource

Disable key-based authentication when you implement Microsoft Entra ID and fully address compatibility or fallback concerns in all the applications that consume the service. Use Azure PowerShell to disable local authentication for an individual resource. First sign in with the `Connect-AzAccount` command. Then use the `Set-AzCognitiveServicesAccount` cmdlet with the parameter `-DisableLocalAuth $true`, like the following example:

```powershell
Set-AzCognitiveServicesAccount -ResourceGroupName "my-resource-group" -Name "my-resource-name" -DisableLocalAuth $true
```

For more information about how to use the Azure CLI to disable or reenable local authentication and verify authentication status, see [Disable local authentication in Foundry Tools](https://learn.microsoft.com/en-us/azure/ai-services/disable-local-auth).

**[programming-language-bicep]**

- Install the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/)
- Identify the following information:
  - Your Azure subscription ID

## About this tutorial

The example in this article is based on code samples in the [Azure-Samples/azureai-model-inference-bicep](https://github.com/Azure-Samples/azureai-model-inference-bicep) repository. To run the commands locally without copying or pasting file content, clone the repository with these commands and go to the folder for your coding language:

```azurecli
git clone https://github.com/Azure-Samples/azureai-model-inference-bicep
```

The files for this example are in the following directory:

```azurecli
cd azureai-model-inference-bicep/infra
```

## Understand the resources

In this tutorial, you create the following resources:

- A Microsoft Foundry resource with key access disabled. For simplicity, this template doesn't deploy models.
- A role assignment for a given security principal with the role **Cognitive Services User**.

To create these resources, use the following assets:

1. Use the template `modules/ai-services-template.bicep` to describe your Foundry resource.

   **modules/ai-services-template.bicep**

   ```bicep
   @description('Location of the resource.')
   param location string = resourceGroup().location

   @description('Name of the Azure AI Services account.')
   param accountName string

   @description('The resource model definition representing SKU')
   param sku string = 'S0'

   @description('Whether or not to allow keys for this account.')
   param allowKeys bool = true

   @allowed([
     'Enabled'
     'Disabled'
   ])
   @description('Whether or not public endpoint access is allowed for this account.')
   param publicNetworkAccess string = 'Enabled'

   @allowed([
     'Allow'
     'Deny'
   ])
   @description('The default action for network ACLs.')
   param networkAclsDefaultAction string = 'Allow'

   resource account 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
     name: accountName
     location: location
     identity: {
       type: 'SystemAssigned'
     }
     sku: {
       name: sku
     }
     kind: 'AIServices'
     properties: {
       customSubDomainName: accountName
       publicNetworkAccess: publicNetworkAccess
       networkAcls: {
         defaultAction: networkAclsDefaultAction
       }
       disableLocalAuth: allowKeys
     }
   }

   output endpointUri string = 'https://${account.outputs.name}.services.ai.azure.com/models'
   output id string = account.id
   ```

   > **Tip**
   >
   > This template accepts the `allowKeys` parameter. Set it to `false` to disable key access in the resource.
2. Use the template `modules/role-assignment-template.bicep` to describe a role assignment in Azure:

   **modules/role-assignment-template.bicep**

   ```bicep
   @description('Specifies the role definition ID used in the role assignment.')
   param roleDefinitionID string

   @description('Specifies the principal ID assigned to the role.')
   param principalId string

   @description('Specifies the resource ID of the resource to assign the role to.')
   param scopeResourceId string = resourceGroup().id

   var roleAssignmentName= guid(principalId, roleDefinitionID, scopeResourceId)
   resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
     name: roleAssignmentName
     properties: {
       roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionID)
       principalId: principalId
     }
   }

   output name string = roleAssignment.name
   output resourceId string = roleAssignment.id
   ```

## Create the resources

In your console, follow these steps:

1. Define the main deployment:

   **deploy-entra-id.bicep**

   ```bicep
   @description('Location to create the resources in')
   param location string = resourceGroup().location

   @description('Name of the resource group to create the resources in')
   param resourceGroupName string = resourceGroup().name

   @description('Name of the AI Services account to create')
   param accountName string = 'azurei-models-dev'

   @description('ID of the developers to assign the user role to')
   param securityPrincipalId string

   module aiServicesAccount 'modules/ai-services-template.bicep' = {
     name: 'aiServicesAccount'
     scope: resourceGroup(resourceGroupName)
     params: {
       accountName: accountName
       location: location
       allowKeys: false
     }
   }

   module roleAssignmentDeveloperAccount 'modules/role-assignment-template.bicep' = {
     name: 'roleAssignmentDeveloperAccount'
     scope: resourceGroup(resourceGroupName)
     params: {
       roleDefinitionID: 'a97b65f3-24c7-4388-baec-2e87135dc908' // Azure Cognitive Services User
       principalId: securityPrincipalId
     }
   }

   output endpoint string = aiServicesAccount.outputs.endpointUri
   ```
2. Sign in to Azure:

   ```azurecli
   az login
   ```
3. Make sure you're in the right subscription:

   ```azurecli
   az account set --subscription "<subscription-id>"
   ```
4. Run the deployment:

   ```azurecli
   RESOURCE_GROUP="<resource-group-name>"
   SECURITY_PRINCIPAL_ID="<your-security-principal-id>"

   az deployment group create \
     --resource-group $RESOURCE_GROUP \
     --parameters securityPrincipalId=$SECURITY_PRINCIPAL_ID \
     --template-file deploy-entra-id.bicep
   ```
5. The template outputs the Foundry Models endpoint that you can use to consume any of the model deployments you created.
6. Verify the deployment and role assignment:

   ```azurecli
   # Get the endpoint from deployment output
   ENDPOINT=$(az deployment group show --resource-group $RESOURCE_GROUP --name deploy-entra-id --query properties.outputs.endpoint.value --output tsv)

   # Verify role assignment
   RESOURCE_ID=$(az deployment group show --resource-group $RESOURCE_GROUP --name deploy-entra-id --query properties.outputs.resourceId.value --output tsv)
   az role assignment list --scope $RESOURCE_ID --assignee $SECURITY_PRINCIPAL_ID --query "[?roleDefinitionName=='Cognitive Services User'].roleDefinitionName" --output tsv

   # Test authentication by getting an access token
   az account get-access-token --resource https://ai.azure.com --query "accessToken" --output tsv
   ```

   If successful, you see **Cognitive Services User** from the role assignment check and an access token from the authentication test. You can now use this endpoint and Microsoft Entra ID authentication in your code.

## Use Microsoft Entra ID in your code

After you configure Microsoft Entra ID in your resource, update your code to use it when you consume the inference endpoint. The following example shows how to use the Responses API.

**[Python]**

Install the OpenAI SDK using a package manager like pip:

```bash
pip install openai
```

For Microsoft Entra ID authentication, also install:

```bash
pip install azure-identity
```

Use the package to consume the model. The following example shows how to create a client and make a test call to the Responses API by using Microsoft Entra ID and your model deployment.

Replace `<resource>` with your Foundry resource name. Find it in the Azure portal or by running `az cognitiveservices account list`. Replace `deepseek-v3-0324` with your actual deployment name.

```python
from openai import OpenAI
from azure.identity import DefaultAzureCredential, get_bearer_token_provider

token_provider = get_bearer_token_provider(
    DefaultAzureCredential(), 
    "https://ai.azure.com/.default"
)

client = OpenAI(
    base_url="https://<resource>.openai.azure.com/openai/v1/",
    api_key=token_provider,
)

response = client.responses.create(
    model="deepseek-v3-0324",  # Replace with your model deployment name.
    input="What is Azure AI?",
)

print(response.output_text)
```

Expected output

```output
Azure AI is a comprehensive suite of artificial intelligence services and tools from Microsoft that enables developers to build intelligent applications. It includes services for natural language processing, computer vision, speech recognition, and machine learning capabilities.
```

Reference: [OpenAI Python SDK](https://github.com/openai/openai-python) and [DefaultAzureCredential class](https://learn.microsoft.com/en-us/python/api/azure-identity/azure.identity.defaultazurecredential).

**[C#]**

Install the OpenAI SDK:

```dotnetcli
dotnet add package OpenAI
```

For Microsoft Entra ID authentication, also install the `Azure.Identity` package:

```dotnetcli
dotnet add package Azure.Identity
```

Then, use the package to consume the model. The following example shows how to create a client and make a test call to the Responses API by using Microsoft Entra ID and your model deployment.

Replace `<resource>` with your Foundry resource name (find it in the Azure portal). Replace `deepseek-v3-0324` with your actual deployment name.

```csharp
using Azure.Identity;
using OpenAI;
using OpenAI.Responses;
using System.ClientModel.Primitives;

#pragma warning disable OPENAI001

BearerTokenPolicy tokenPolicy = new(
    new DefaultAzureCredential(),
    "https://ai.azure.com/.default"
);

OpenAIResponseClient client = new(
    model: "deepseek-v3-0324", // Replace with your model deployment name.
    authenticationPolicy: tokenPolicy,
    options: new OpenAIClientOptions()
    {
        Endpoint = new Uri("https://<resource>.openai.azure.com/openai/v1/")
    }
);

OpenAIResponse response = client.CreateResponse("What is Azure AI?");

Console.WriteLine(response.GetOutputText());
```

Expected output:

```output
Azure AI is a comprehensive suite of artificial intelligence services and tools from Microsoft that enables developers to build intelligent applications. It includes services for natural language processing, computer vision, speech recognition, and machine learning capabilities.
```

Reference: [OpenAI .NET SDK](https://github.com/openai/openai-dotnet) and [DefaultAzureCredential class](https://learn.microsoft.com/en-us/dotnet/api/azure.identity.defaultazurecredential).

**[JavaScript]**

Install the OpenAI SDK with npm:

```bash
npm install openai
```

For Microsoft Entra ID authentication, also install:

```bash
npm install @azure/identity
```

Then, use the package to consume the model. The following example shows how to create a client and make a test call to the Responses API by using Microsoft Entra ID and your model deployment.

Replace `<resource>` with your Foundry resource name (find it in the Azure portal or by running `az cognitiveservices account list`). Replace `deepseek-v3-0324` with your actual deployment name.

```javascript
import { DefaultAzureCredential, getBearerTokenProvider } from "@azure/identity";
import { OpenAI } from "openai";

const tokenProvider = getBearerTokenProvider(
    new DefaultAzureCredential(),
    'https://ai.azure.com/.default'
);

const client = new OpenAI({
    baseURL: "https://<resource>.openai.azure.com/openai/v1/",
    apiKey: tokenProvider
});

const response = await client.responses.create({
    model: "deepseek-v3-0324", // Replace with your model deployment name.
    input: "What is Azure AI?"
});

console.log(response.output_text);
```

Expected output:

```output
Azure AI is a comprehensive suite of artificial intelligence services and tools from Microsoft that enables developers to build intelligent applications. It includes services for natural language processing, computer vision, speech recognition, and machine learning capabilities.
```

Reference: [OpenAI Node.js SDK](https://github.com/openai/openai-node) and [DefaultAzureCredential class](https://learn.microsoft.com/en-us/javascript/api/@azure/identity/defaultazurecredential).

**[Java]**

Add the OpenAI SDK to your project. Check the [OpenAI Java GitHub repository](https://github.com/openai/openai-java) for the latest version and installation instructions.

For Microsoft Entra ID authentication, also add:

```xml
<dependency>
    <groupId>com.azure</groupId>
    <artifactId>azure-identity</artifactId>
    <version>1.18.0</version>
</dependency>
```

Then, use the package to consume the model. The following example shows how to create a client and make a test call to the Responses API by using Microsoft Entra ID and your model deployment.

Replace `<resource>` with your Foundry resource name (find it in the Azure portal). Replace `deepseek-v3-0324` with your actual deployment name.

```java
import com.azure.identity.AuthenticationUtil;
import com.azure.identity.DefaultAzureCredential;
import com.azure.identity.DefaultAzureCredentialBuilder;
import com.openai.client.OpenAIClient;
import com.openai.client.okhttp.OpenAIOkHttpClient;
import com.openai.credential.BearerTokenCredential;
import com.openai.models.responses.Response;
import com.openai.models.responses.ResponseCreateParams;

DefaultAzureCredential tokenCredential = new DefaultAzureCredentialBuilder().build();

OpenAIClient client = OpenAIOkHttpClient.builder()
    .baseUrl("https://<resource>.openai.azure.com/openai/v1/")
    .credential(BearerTokenCredential.create(
        AuthenticationUtil.getBearerTokenSupplier(
            tokenCredential, 
            "https://ai.azure.com/.default"
        )
    ))
    .build();

ResponseCreateParams params = ResponseCreateParams.builder()
    .model("deepseek-v3-0324") // Replace with your model deployment name.
    .input("What is Azure AI?")
    .build();

Response response = client.responses().create(params);

// The Responses API has no single output-text accessor; concatenate the output items.
response.output().stream()
    .flatMap(item -> item.message().stream())
    .flatMap(message -> message.content().stream())
    .flatMap(content -> content.outputText().stream())
    .forEach(outputText -> System.out.println(outputText.text()));
```

Expected output:

```output
Azure AI is a comprehensive suite of artificial intelligence services and tools from Microsoft that enables developers to build intelligent applications. It includes services for natural language processing, computer vision, speech recognition, and machine learning capabilities.
```

Reference: [OpenAI Java SDK](https://github.com/openai/openai-java) and [DefaultAzureCredential class](https://learn.microsoft.com/en-us/java/api/com.azure.identity.defaultazurecredential).

**[REST]**

Explore the API design in the [reference section](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/azureopenai/responses?view=rest-microsoft-foundry-v1&preserve-view=true) to see which parameters are available. Insert the authentication (bearer) token in the `Authorization` header.

For example, the [Responses API](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/azureopenai/responses?view=rest-microsoft-foundry-v1&preserve-view=true) reference section details how to use the `/responses` route to generate predictions. The `/openai/v1/` path is included in the root of the URL:

**Request**

Replace `<resource>` with your Foundry resource name (find it in the Azure portal or by running `az cognitiveservices account list`). Replace `deepseek-v3-0324` with your actual deployment name.

The base URL accepts both `https://<resource>.openai.azure.com/openai/v1/` and `https://<resource>.services.ai.azure.com/openai/v1/` formats.

```bash
curl -X POST https://<resource>.openai.azure.com/openai/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AZURE_OPENAI_AUTH_TOKEN" \
  -d '{
      "model": "deepseek-v3-0324",
      "input": "Explain what the bitter lesson is?"
    }'
```

**Response**

If authentication is successful, you receive a `200 OK` response with the response results in the response body:

```json
{
  "id": "resp_...",
  "object": "response",
  "created_at": 1738368234,
  "model": "deepseek-v3-0324",
  "status": "completed",
  "output": [
    {
      "type": "message",
      "role": "assistant",
      "content": [
        {
          "type": "output_text",
          "text": "The bitter lesson refers to a key insight in AI research that emphasizes the importance of general-purpose learning methods that leverage computation, rather than human-designed domain-specific approaches. It suggests that methods which scale with increased computation tend to be more effective in the long run."
        }
      ]
    }
  ],
  "usage": {
    "input_tokens": 28,
    "output_tokens": 52,
    "total_tokens": 80
  }
}
```

Tokens must be issued with scope `https://ai.azure.com/.default`.

For testing purposes, the easiest way to get a valid token for your user account is to use the Azure CLI. In a console, sign in and request a token by running the following Azure CLI commands:

```azurecli
az login
az account get-access-token --resource https://ai.azure.com --query "accessToken" --output tsv
```

This command outputs an access token that you can store in the `$AZURE_OPENAI_AUTH_TOKEN` environment variable.

Reference: [Responses API](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/azureopenai/responses?view=rest-microsoft-foundry-v1&preserve-view=true)

### Options for credential when using Microsoft Entra ID

`DefaultAzureCredential` is an opinionated, ordered sequence of mechanisms for authenticating to Microsoft Entra ID. Each authentication mechanism is a class that's derived from the `TokenCredential` class and is known as a credential. At runtime, `DefaultAzureCredential` attempts to authenticate using the first credential. If that credential fails to acquire an access token, the next credential in the sequence is attempted, and so on, until an access token is obtained. In this way, your app can use different credentials in different environments without writing environment-specific code.

When the preceding code runs on your local development workstation, it looks in the environment variables for an application service principal or at locally installed developer tools, like Visual Studio, for a set of developer credentials. You can use either approach to authenticate the app to Azure resources during local development.

When deployed to Azure, this same code can also authenticate your app to other Azure resources. `DefaultAzureCredential` can retrieve environment settings and managed identity configurations to authenticate to other services automatically.

### Best practices

- Use deterministic credentials in production environments: Strongly consider moving from `DefaultAzureCredential` to one of the following deterministic solutions in production environments:
  - A specific `TokenCredential` implementation, like `ManagedIdentityCredential`. See the [Derived list for options](https://learn.microsoft.com/en-us/dotnet/api/azure.core.tokencredential#definition).
  - A pared-down `ChainedTokenCredential` implementation that's optimized for the Azure environment in which your app runs. `ChainedTokenCredential` essentially creates a specific allowlist of acceptable credential options, like `ManagedIdentity` for production and `VisualStudioCredential` for development.
- Configure system-assigned or user-assigned managed identities to the Azure resources where your code runs, if possible. Configure Microsoft Entra ID access to those specific identities.

## Disable key-based authentication in the resource

Disable key-based authentication when you implement Microsoft Entra ID and fully address compatibility or fallback concerns in all applications that consume the service. Change the `disableLocalAuth` property to disable key-based authentication.

For more information about how to disable local authentication when you're using a Bicep or ARM template, see [How to disable local authentication](https://learn.microsoft.com/en-us/azure/ai-services/disable-local-auth#how-to-disable-local-authentication).

**modules/ai-services-template.bicep**

```bicep
@description('Location of the resource.')
param location string = resourceGroup().location

@description('Name of the Azure AI Services account.')
param accountName string

@description('The resource model definition representing SKU')
param sku string = 'S0'

@description('Whether or not to allow keys for this account.')
param allowKeys bool = true

@allowed([
  'Enabled'
  'Disabled'
])
@description('Whether or not public endpoint access is allowed for this account.')
param publicNetworkAccess string = 'Enabled'

@allowed([
  'Allow'
  'Deny'
])
@description('The default action for network ACLs.')
param networkAclsDefaultAction string = 'Allow'

resource account 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: accountName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: sku
  }
  kind: 'AIServices'
  properties: {
    customSubDomainName: accountName
    publicNetworkAccess: publicNetworkAccess
    networkAcls: {
      defaultAction: networkAclsDefaultAction
    }
    disableLocalAuth: allowKeys
  }
}

output endpointUri string = 'https://${account.outputs.name}.services.ai.azure.com/models'
output id string = account.id
```

## Understand roles in the context of resource in Azure

Microsoft Entra ID uses role-based access control (RBAC) for authorization, which controls what actions users can perform on Azure resources. Roles are central to managing access to cloud resources. A role is a collection of permissions that define what actions can be performed on specific Azure resources. By assigning roles to users, groups, service principals, or managed identities—collectively known as security principals—you control their access within your Azure environment to specific resources.

When you assign a role, you specify the security principal, role definition, and scope. This combination is known as a role assignment. Foundry Models is a capability of the Foundry Tools resources, therefore, roles assigned to that particular resource control the access for inference.

There are two types of access to the resources:

- **Administration access**: Actions related to the administration of the resource. These actions usually change the resource state and its configuration. In Azure, these operations are control-plane operations that you can execute using the Azure portal, Azure CLI, or infrastructure as code. Examples include creating new model deployments, changing content filtering configurations, changing the version of the model served, or changing the SKU of a deployment.
- **Developer access**: Actions related to consuming the resources, such as invoking the chat completions API. However, the user can't change the resource state and its configuration.

In Azure, Microsoft Entra ID always performs administration operations. Roles like **Cognitive Services Contributor** allow you to perform those operations. Developer operations can be performed using either access keys or Microsoft Entra ID. Roles like **Cognitive Services User** allow you to perform those operations.

> **Important**
>
> Having administration access to a resource doesn't grant developer access to it. Explicit access by granting roles is still required. This is analogous to how database servers work. Having administrator access to the database server doesn't mean you can read the data inside of a database.

## Troubleshooting

Before you troubleshoot, verify that you have the right permissions assigned:

1. Go to the [Azure portal](https://portal.azure.com/) and locate the **Microsoft Foundry resource** that you're using.
2. On the left pane, select **Access control (IAM)** and then select **Check access**.
3. Type the name of the user or identity you're using to connect to the service.
4. Verify that the role **Cognitive Services User** is listed (or a role that contains the required permissions, as explained in the Prerequisites section).

   > **Important**
   >
   > Roles like **Owner** or **Contributor** don't provide access via Microsoft Entra ID.
5. If the role isn't listed, follow the steps in this guide before you continue.

The following table contains multiple scenarios that can help you troubleshoot Microsoft Entra ID:

| Error / Scenario | Root cause | Solution |
| --- | --- | --- |
| You're using an SDK | Known issues | Before you troubleshoot further, install the latest version of the software you're using to connect to the service. Authentication bugs might already be fixed in a newer version of the software you're using. |
| `401 Principal does not have access to API/Operation` | The request indicates authentication in the correct way, but the user principal doesn't have the required permissions to use the inference endpoint. | Ensure you have: 1. Assigned the role **Cognitive Services User** to your principal to the Foundry resource. Notice that **Cognitive Services OpenAI User** grants only access to OpenAI models. **Owner** or **Contributor** don't provide access either. 1. Waited at least 5 minutes before making the first call. |
| `401 HTTP/1.1 401 PermissionDenied` | The request indicates authentication in the correct way, but the user principal doesn't have the required permissions to use the inference endpoint. | Assigned the role **Cognitive Services User** to your principal in the Foundry resource. Roles like **Owner** or **Contributor** don't grant inference access. Wait at least 5 minutes before making the first call. |
| You're using REST API calls and you get `401 Unauthorized. Access token is missing, invalid, audience is incorrect, or have expired.` | The request fails to authenticate with Microsoft Entra ID. | Ensure the `Authentication` header contains a valid token with a scope `https://ai.azure.com/.default`. |

## Next step

- [Azure OpenAI supported programming languages](../../05-developer-tools-and-integrations/05.4-sdks-and-apis/05-supported-languages.md)
