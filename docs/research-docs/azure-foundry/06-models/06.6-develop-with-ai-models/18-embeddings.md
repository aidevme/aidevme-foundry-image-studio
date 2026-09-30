# Generate embeddings with Azure OpenAI

| Field | Value |
| --- | --- |
| **Document Title** | Generate embeddings with Azure OpenAI |
| **Document Location** | `docs/research-docs/azure-foundry/06-models/06.6-develop-with-ai-models/18-embeddings.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Generate embeddings with Azure OpenAI". Learn how to generate vector embeddings with Azure OpenAI by using current OpenAI SDKs for Python, C#, JavaScript, Java, and Go, or the REST API. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/openai/how-to/embeddings). Article date: 2026-07-22. Page updated: 2026-07-22. Retrieved: 2026-09-29. Navigation: Models > Develop with AI models > Embeddings > Embeddings.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

An embedding is a vector of floating-point numbers that represents the semantic meaning of text. Similar text produces vectors that are close together, which makes embeddings useful for vector search, recommendations, classification, and clustering.

## Prerequisites

- An Azure subscription. [Create one for free](https://azure.microsoft.com/free/) if you don't have one.
- An Azure OpenAI resource with an embedding model deployment.
- Your resource endpoint, such as `https://YOUR-RESOURCE-NAME.openai.azure.com`.
- For Microsoft Entra ID authentication, an identity with the `Cognitive Services OpenAI User` role assigned to the Azure OpenAI resource. For more information, see [Role-based access control for Azure OpenAI](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/how-to/role-based-access-control).
- The [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) for local authentication.
- The runtime and package manager for the language you select.

For more language-specific setup guidance, see [Azure OpenAI supported programming languages](../../05-developer-tools-and-integrations/05.4-sdks-and-apis/05-supported-languages.md).

The `model` value in each request is your Azure model deployment name. The examples use `text-embedding-3-small`; replace it if your deployment has a different name.

## Generate an embedding

Send text to the embeddings endpoint, and read the vector from the first item in the response.

The v1 embeddings API supports Microsoft Entra ID and API key authentication. Microsoft Entra ID is recommended because it avoids storing long-lived credentials. The examples in this article use Microsoft Entra ID.

For local development, sign in to Azure before you run an SDK example:

```bash
az login
```

`DefaultAzureCredential` uses your signed-in identity locally and can use a managed identity when your application runs in Azure.

API key authentication is also supported. For key-based client configuration, see [Azure OpenAI v1 API guidance](../../05-developer-tools-and-integrations/05.4-sdks-and-apis/04-api-version-lifecycle.md).

**[Python]**

Install the OpenAI and Azure Identity packages:

```bash
pip install openai azure-identity
```

Generate an embedding and print its dimensions:

```python
from openai import OpenAI
from azure.identity import DefaultAzureCredential, get_bearer_token_provider

endpoint = "https://YOUR-RESOURCE-NAME.openai.azure.com/openai/v1/"
token_provider = get_bearer_token_provider(
	DefaultAzureCredential(), "https://ai.azure.com/.default"
)
openai = OpenAI(
	base_url=endpoint,
	api_key=token_provider,
)

# Generate one embedding vector.
response = openai.embeddings.create(
	model="text-embedding-3-small",
	input="The quick brown fox jumped over the lazy dog.",
)
print(f"Embedding dimensions: {len(response.data[0].embedding)}")
```

```output
Embedding dimensions: <number>
```

Reference: [`embeddings.create`](https://github.com/openai/openai-python/blob/main/src/openai/resources/embeddings.py)

**[C#]**

Install the OpenAI and Azure Identity packages:

```dotnetcli
dotnet add package OpenAI
dotnet add package Azure.Identity
```

Generate an embedding and print its dimensions:

```csharp
using Azure.Identity;
using OpenAI;
using OpenAI.Embeddings;
using System.ClientModel.Primitives;

#pragma warning disable OPENAI001

var endpoint = new Uri(
	"https://YOUR-RESOURCE-NAME.openai.azure.com/openai/v1/");
BearerTokenPolicy tokenPolicy = new(
	new DefaultAzureCredential(),
	"https://ai.azure.com/.default");
var openAIClient = new EmbeddingClient(
	model: "text-embedding-3-small",
	authenticationPolicy: tokenPolicy,
	options: new OpenAIClientOptions { Endpoint = endpoint });

// Generate one embedding vector.
OpenAIEmbedding embedding = openAIClient.GenerateEmbedding(
	"The quick brown fox jumped over the lazy dog.");
Console.WriteLine($"Embedding dimensions: {embedding.ToFloats().Length}");
```

```output
Embedding dimensions: <number>
```

Reference: [`EmbeddingClient.GenerateEmbedding`](https://github.com/openai/openai-dotnet/blob/main/OpenAI/src/Custom/Embeddings/EmbeddingClient.cs)

**[JavaScript]**

Install the OpenAI and Azure Identity packages:

```bash
npm install openai @azure/identity
```

Generate an embedding and print its dimensions:

```javascript
import {
	DefaultAzureCredential,
	getBearerTokenProvider,
} from "@azure/identity";
import OpenAI from "openai";

const endpoint = "https://YOUR-RESOURCE-NAME.openai.azure.com/openai/v1/";
const tokenProvider = getBearerTokenProvider(
	new DefaultAzureCredential(),
	"https://ai.azure.com/.default",
);
const openai = new OpenAI({ baseURL: endpoint, apiKey: tokenProvider });

// Generate one embedding vector.
const response = await openai.embeddings.create({
  model: "text-embedding-3-small",
  input: "The quick brown fox jumped over the lazy dog.",
});
console.log(`Embedding dimensions: ${response.data[0].embedding.length}`);
```

```output
Embedding dimensions: <number>
```

Reference: [`embeddings.create`](https://github.com/openai/openai-node/blob/main/src/resources/embeddings.ts)

**[Java]**

For Maven, add the OpenAI and Azure Identity packages:

```xml
<dependencies>
	<dependency>
		<groupId>com.openai</groupId>
		<artifactId>openai-java</artifactId>
		<version>4.43.0</version>
	</dependency>
	<dependency>
		<groupId>com.azure</groupId>
		<artifactId>azure-identity</artifactId>
		<version>1.18.4</version>
	</dependency>
</dependencies>
```

For Gradle setup, see [Azure OpenAI Java support](../../05-developer-tools-and-integrations/05.4-sdks-and-apis/05-supported-languages.md).

Generate an embedding and print its dimensions:

```java
import com.azure.identity.AuthenticationUtil;
import com.azure.identity.DefaultAzureCredentialBuilder;
import com.openai.client.OpenAIClient;
import com.openai.client.okhttp.OpenAIOkHttpClient;
import com.openai.credential.BearerTokenCredential;
import com.openai.models.embeddings.EmbeddingCreateParams;

public class EmbeddingsExample {
	public static void main(String[] args) {
		String endpoint = "https://YOUR-RESOURCE-NAME.openai.azure.com/openai/v1/";
		OpenAIClient openAIClient = OpenAIOkHttpClient.builder()
				.baseUrl(endpoint)
				.credential(BearerTokenCredential.create(
						AuthenticationUtil.getBearerTokenSupplier(
								new DefaultAzureCredentialBuilder().build(),
								"https://ai.azure.com/.default")))
				.build();

		// Generate one embedding vector.
		EmbeddingCreateParams params = EmbeddingCreateParams.builder()
				.model("text-embedding-3-small")
				.input("The quick brown fox jumped over the lazy dog.")
				.encodingFormat(EmbeddingCreateParams.EncodingFormat.FLOAT)
				.build();
		int dimensions = openAIClient.embeddings().create(params)
				.data().get(0).embedding().size();
		System.out.println("Embedding dimensions: " + dimensions);
	}
}
```

```output
Embedding dimensions: <number>
```

Reference: [`EmbeddingCreateParams`](https://github.com/openai/openai-java/blob/main/openai-java-example/src/main/java/com/openai/example/EmbeddingsExample.java)

**[Go]**

Install version 3 of the OpenAI Go module and the Azure Identity module:

```bash
go get github.com/openai/openai-go/v3
go get github.com/Azure/azure-sdk-for-go/sdk/azidentity
```

Generate an embedding and print its dimensions:

```go
package main

import (
	"context"
	"fmt"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/openai/openai-go/v3"
	"github.com/openai/openai-go/v3/azure"
	"github.com/openai/openai-go/v3/option"
)

func main() {
	credential, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil { panic(err) }
	endpoint := "https://YOUR-RESOURCE-NAME.openai.azure.com/openai/v1/"
	openaiClient := openai.NewClient(
		option.WithBaseURL(endpoint),
		azure.WithTokenCredential(credential, azure.WithTokenCredentialScopes(
			[]string{"https://ai.azure.com/.default"})))

	// Generate one embedding vector.
	response, err := openaiClient.Embeddings.New(context.Background(), openai.EmbeddingNewParams{
		Model: "text-embedding-3-small",
		Input: openai.EmbeddingNewParamsInputUnion{OfString: openai.String(
			"The quick brown fox jumped over the lazy dog.")},
	})
	if err != nil { panic(err) }
	fmt.Printf("Embedding dimensions: %d\n", len(response.Data[0].Embedding))
}
```

```output
Embedding dimensions: <number>
```

Reference: [`Embeddings.New`](https://github.com/openai/openai-go/blob/main/embedding.go)

**[PowerShell]**

Store your resource endpoint in `AZURE_OPENAI_ENDPOINT`. Then get an access token and generate an embedding:

```powershell
$Env:AZURE_OPENAI_ENDPOINT = "https://YOUR-RESOURCE-NAME.openai.azure.com"
```

```powershell
$endpoint = "$($env:AZURE_OPENAI_ENDPOINT.TrimEnd('/'))/openai/v1/embeddings"
$token = az account get-access-token `
	--resource https://cognitiveservices.azure.com `
	--query accessToken `
	--output tsv
$headers = @{ Authorization = "Bearer $token" }

# Generate one embedding vector.
$body = @{
    model = "text-embedding-3-small"
    input = "The quick brown fox jumped over the lazy dog."
} | ConvertTo-Json
$response = Invoke-RestMethod `
    -Uri $endpoint `
    -Method Post `
    -Headers $headers `
    -ContentType "application/json" `
    -Body $body
Write-Output "Embedding dimensions: $($response.data[0].embedding.Count)"
```

```output
Embedding dimensions: <number>
```

Reference: [`Invoke-RestMethod`](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod) and [`az account get-access-token`](https://learn.microsoft.com/en-us/cli/azure/account#az-account-get-access-token)

**[REST]**

Get an access token, and send a request to the v1 embeddings endpoint:

```bash
AZURE_OPENAI_AUTH_TOKEN=$(az account get-access-token \
	--resource https://cognitiveservices.azure.com \
	--query accessToken \
	--output tsv)
curl "https://YOUR-RESOURCE-NAME.openai.azure.com/openai/v1/embeddings" \
  -H "Content-Type: application/json" \
	-H "Authorization: Bearer $AZURE_OPENAI_AUTH_TOKEN" \
  -d '{"model":"text-embedding-3-small","input":"The quick brown fox."}'
```

```output
{"data":[{"embedding":[<vector-values>]}]}
```

Reference: [Azure OpenAI embeddings REST API](https://learn.microsoft.com/en-us/rest/api/microsoft-foundry/azureopenai/embeddings) and [`az account get-access-token`](https://learn.microsoft.com/en-us/cli/azure/account#az-account-get-access-token)

## Best practices

> **Tip**
>
> Embedding requests return HTTP 400 when the **sum** of input tokens exceeds 300,000, even if every individual input is under the per-input limit. Split large batches into smaller requests.

### Verify inputs don't exceed the maximum length

- The maximum input length for the current embedding models is 8,192 tokens. Check each input before sending the request.
- If you send an array of inputs in a single embedding request, the maximum array size is 2,048.
- Each `/embeddings` request has a 300,000-token aggregate limit across all inputs. Requests above this limit fail with HTTP 400.
- Keep the total tokens per minute below the quota assigned to your model deployment. For current limits, see [Azure OpenAI quotas and limits](../06.2-quota-limits-and-region-availability/06-quotas-limits.md).

## Troubleshooting

- For a `401` response, sign in again and confirm that the access token uses the correct audience.
- For a `403` response, confirm that your identity has the `Cognitive Services OpenAI User` role assigned to the Azure OpenAI resource.
- For a `404` response, confirm that the endpoint includes `/openai/v1/` and that `model` contains a valid deployment name.
- For a `400` response, check the request body, each input's token count, the number of inputs, and the aggregate token count.

## Limitations and risks

Embedding models might be unreliable or pose social risks in certain cases. They might cause harm if used without mitigations. For more information about how to approach their use responsibly, see the [Responsible AI](../../12-trust-and-safety/12.2-responsible-ai/01-responsible-use-of-ai-overview.md) content.

## Next steps

- [Explore embeddings and document search](19-embeddings.md).
- [Review available Azure OpenAI models](../06.1-explore-foundry-models/01-models-sold-directly-by-azure.md).
- Choose a service to store and search vectors:
  - [Azure AI Search](https://learn.microsoft.com/en-us/azure/search/vector-search-overview)
  - [Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications?view=azuresql&preserve-view=true#vector-search)
  - [Azure Cosmos DB for NoSQL](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/vector-search)
  - [Azure Database for PostgreSQL flexible server](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/how-to-use-pgvector)
  - [Azure Managed Redis](https://learn.microsoft.com/en-us/azure/redis/overview-vector-similarity)
  - [Eventhouse in Microsoft Fabric](https://learn.microsoft.com/en-us/fabric/real-time-intelligence/vector-database)
