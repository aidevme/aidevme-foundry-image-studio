# Quickstart: Get started with Azure OpenAI audio generation

| Field | Value |
| --- | --- |
| **Document Title** | Quickstart: Get started with Azure OpenAI audio generation |
| **Document Location** | `docs/research-docs/azure-foundry/06-models/06.7-model-capabilities/10-audio-completions-quickstart.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Quickstart: Get started with Azure OpenAI audio generation". Get started with audio generation using Azure OpenAI. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/openai/audio-completions-quickstart). Article date: 2026-05-31. Page updated: 2026-06-05. Retrieved: 2026-09-29. Navigation: Models > Model capabilities > Audio and speech > Audio generation.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

**[ai-foundry-portal]**

Audio-enabled models introduce the audio modality into the existing `/chat/completions` API. The audio model expands the potential for AI applications in text and voice-based interactions and audio analysis. Modalities supported in `gpt-4o-audio-preview` and `gpt-4o-mini-audio-preview` models include: text, audio, and text + audio.

Here's a table of the supported modalities with example use cases:

| Modality input | Modality output | Example use case |
| --- | --- | --- |
| Text | Text + audio | Text to speech, audio book generation |
| Audio | Text + audio | Audio transcription, audio book generation |
| Audio | Text | Audio transcription |
| Text + audio | Text + audio | Audio book generation |
| Text + audio | Text | Audio transcription |

By using audio generation capabilities, you can achieve more dynamic and interactive AI applications. Models that support audio inputs and outputs allow you to generate spoken audio responses to prompts and use audio inputs to prompt the model.

## Supported models

The following OpenAI models support audio generation:

| Model | Audio generation? | Primary Use |
| --- | --- | --- |
| `gpt-4o-audio-preview` | ✔️ | Chat completions with spoken output |
| `gpt-4o-mini-tts` | ✔️ | Fast, scalable text-to-speech |
| `gpt-4o-mini-audio-preview` | ✔️ | Asynchronous audio generation |
| `gpt-realtime` | ✔️ | Real‑time interactive voice |
| `gpt-realtime-mini` | ✔️ | Low‑latency audio streaming |
| `tts-1` / `tts-1-hd` | ✔️ | General‑purpose speech synthesis |

For information about region availability, see the [models and versions documentation](../06.1-explore-foundry-models/01-models-sold-directly-by-azure.md).

> **Note**
>
> The [Realtime API](15-realtime-audio-websockets.md#voice-agent-quickstart) uses the same underlying GPT-4o audio model as the completions API, but is optimized for low-latency, real-time audio interactions.

## Input requirements

The following voices are supported for audio out: Alloy, Ash, Ballad, Coral, Echo, Sage, Shimmer, Verse, Marin, and Cedar.

The following audio output formats are supported: wav, mp3, flac, opus, pcm16, and aac.

The maximum audio file size is 20 MB.

## API support

Support for audio completions was first added in API version `2025-01-01-preview`.

## Deploy a model for audio generation

To deploy the `gpt-4o-mini-audio-preview` model in the Microsoft Foundry portal:

1. Go to the [Foundry portal](https://ai.azure.com/?cid=learnDocs) and create or select your project.
2. Select **Models + endpoints** from under **My assets** in the left pane.
3. Select **+ Deploy model** > **Deploy base model** to open the deployment window.
4. Search for and select the `gpt-4o-mini-audio-preview` model and then select **Confirm**.
5. Review the deployment details and select **Deploy**.
6. Follow the wizard to finish deploying the model.

Now that you have a deployment of the `gpt-4o-mini-audio-preview` model, you can interact with it in the Foundry portal **Chat** playground or chat completions API.

## Use GPT-4o audio generation

To chat with your deployed `gpt-4o-mini-audio-preview` model in the **Chat** playground of [Microsoft Foundry portal](https://ai.azure.com/?cid=learnDocs), follow these steps:

1. Go to the [Foundry portal](https://ai.azure.com/?cid=learnDocs) and select your project that has your deployed `gpt-4o-mini-audio-preview` model.
2. Go to your project in [Foundry](https://ai.azure.com/?cid=learnDocs).
3. Select **Playgrounds** from the left pane.
4. Select **Audio playground** > **Try the Chat playground**.

   > **Note**
   >
   > The **Audio playground** doesn't support the `gpt-4o-mini-audio-preview` model. Use the **Chat playground** as described in this section.
5. Select your deployed `gpt-4o-mini-audio-preview` model from the **Deployment** dropdown.
6. Start chatting with the model and listen to the audio responses.

   [![Screenshot of the Chat playground page.](https://learn.microsoft.com/en-us/azure/foundry/openai/media/quickstarts/audio-completions-chat-playground.png)](https://learn.microsoft.com/en-us/azure/foundry/openai/media/quickstarts/audio-completions-chat-playground.png#lightbox)

   You can:
   - Record audio prompts.
   - Attach audio files to the chat.
   - Enter text prompts.

**[programming-language-javascript]**

[Reference documentation](https://developers.openai.com/api/reference/resources/responses) | [Library source code](https://github.com/openai/openai-node?azure-portal=true) | [Package (npm)](https://www.npmjs.com/package/openai) | [Samples](https://github.com/Azure/azure-sdk-for-js/tree/main/sdk/openai/openai/samples)

Audio-enabled models introduce the audio modality into the existing `/chat/completions` API. The audio model expands the potential for AI applications in text and voice-based interactions and audio analysis. Modalities supported in `gpt-4o-audio-preview` and `gpt-4o-mini-audio-preview` models include: text, audio, and text + audio.

Here's a table of the supported modalities with example use cases:

| Modality input | Modality output | Example use case |
| --- | --- | --- |
| Text | Text + audio | Text to speech, audio book generation |
| Audio | Text + audio | Audio transcription, audio book generation |
| Audio | Text | Audio transcription |
| Text + audio | Text + audio | Audio book generation |
| Text + audio | Text | Audio transcription |

By using audio generation capabilities, you can achieve more dynamic and interactive AI applications. Models that support audio inputs and outputs allow you to generate spoken audio responses to prompts and use audio inputs to prompt the model.

## Supported models

The following OpenAI models support audio generation:

| Model | Audio generation? | Primary Use |
| --- | --- | --- |
| `gpt-4o-audio-preview` | ✔️ | Chat completions with spoken output |
| `gpt-4o-mini-tts` | ✔️ | Fast, scalable text-to-speech |
| `gpt-4o-mini-audio-preview` | ✔️ | Asynchronous audio generation |
| `gpt-realtime` | ✔️ | Real‑time interactive voice |
| `gpt-realtime-mini` | ✔️ | Low‑latency audio streaming |
| `tts-1` / `tts-1-hd` | ✔️ | General‑purpose speech synthesis |

For information about region availability, see the [models and versions documentation](../06.1-explore-foundry-models/01-models-sold-directly-by-azure.md).

> **Note**
>
> The [Realtime API](15-realtime-audio-websockets.md#voice-agent-quickstart) uses the same underlying GPT-4o audio model as the completions API, but is optimized for low-latency, real-time audio interactions.

## Input requirements

The following voices are supported for audio out: Alloy, Ash, Ballad, Coral, Echo, Sage, Shimmer, Verse, Marin, and Cedar.

The following audio output formats are supported: wav, mp3, flac, opus, pcm16, and aac.

The maximum audio file size is 20 MB.

## API support

Support for audio completions was first added in API version `2025-01-01-preview`.

## Prerequisites

- An Azure subscription - [Create one for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn)
- [Node.js LTS or ESM support.](https://nodejs.org/)
- An Azure OpenAI resource created in one of the supported regions. For more information about region availability, see the [Region availability for Foundry Models sold by Azure](../06.2-quota-limits-and-region-availability/01-models-sold-directly-by-azure-region-availability.md).
- Then, you need to deploy a `gpt-4o-mini-audio-preview` model with your Azure OpenAI resource. For more information, see [Create a resource and deploy a model with Azure OpenAI](https://learn.microsoft.com/en-us/azure/foundry-classic/openai/how-to/create-resource).

## Microsoft Entra ID prerequisites

For the recommended keyless authentication with Microsoft Entra ID, you need to:

- Install the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) used for keyless authentication with Microsoft Entra ID.
- Assign the `Cognitive Services User` role to your user account. You can assign roles in the Azure portal under **Access control (IAM)** > **Add role assignment**.

## Set up

1. Create a new folder `audio-completions-quickstart` and go to the quickstart folder with the following command:

   ```shell
   mkdir audio-completions-quickstart && cd audio-completions-quickstart
   ```
2. Create the `package.json` with the following command:

   ```shell
   npm init -y
   ```
3. Install the OpenAI client library for JavaScript with:

   ```console
   npm install openai
   ```
4. For the **recommended** keyless authentication with Microsoft Entra ID, install the `@azure/identity` package with:

   ```console
   npm install @azure/identity
   ```

## Retrieve resource information

You need to retrieve the following information to authenticate your application with your Azure OpenAI resource:

**[Microsoft Entra ID]**

| Variable name | Value |
| --- | --- |
| `AZURE_OPENAI_ENDPOINT` | This value can be found in the **Keys and Endpoint** section when examining your resource from the Azure portal. |
| `AZURE_OPENAI_DEPLOYMENT_NAME` | This value will correspond to the custom name you chose for your deployment when you deployed a model. This value can be found under **Resource Management** > **Model Deployments** in the Azure portal. |

Learn more about [keyless authentication](https://learn.microsoft.com/en-us/azure/ai-services/authentication) and [setting environment variables](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-environment-variables).

**[API key]**

| Variable name | Value |
| --- | --- |
| `AZURE_OPENAI_ENDPOINT` | This value can be found in the **Keys and Endpoint** section when examining your resource from the Azure portal. |
| `AZURE_OPENAI_API_KEY` | This value can be found in the **Keys and Endpoint** section when examining your resource from the Azure portal. You can use either `KEY1` or `KEY2`. |
| `AZURE_OPENAI_DEPLOYMENT_NAME` | This value will correspond to the custom name you chose for your deployment when you deployed a model. This value can be found under **Resource Management** > **Model Deployments** in the Azure portal. |

Learn more about [finding API keys](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-environment-variables) and [setting environment variables](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-environment-variables).

> **Important**
>
> Use API keys with caution. Don't include the API key directly in your code, and never post it publicly. If you use an API key, store it securely in Azure Key Vault. For more information about using API keys securely in your apps, see [API keys with Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/apps-api-keys-secrets).
>
> For more information about AI services security, see [Authenticate requests to Azure AI services](https://learn.microsoft.com/en-us/azure/ai-services/authentication).

> **Caution**
>
> To use the recommended keyless authentication with the SDK, make sure that the `AZURE_OPENAI_API_KEY` environment variable isn't set.

## Generate audio from text input

**[Microsoft Entra ID]**

1. Create the `to-audio.js` file with the following code:

   ```javascript
   require("dotenv").config();
   const { AzureOpenAI } = require("openai");
   const { DefaultAzureCredential, getBearerTokenProvider } = require("@azure/identity");
   const { writeFileSync } = require("node:fs");

   // Keyless authentication    
   const credential = new DefaultAzureCredential();
   const scope = "https://ai.azure.com/.default";
   const azureADTokenProvider = getBearerTokenProvider(credential, scope);

   // Set environment variables or edit the corresponding values here.
   const endpoint = process.env.AZURE_OPENAI_ENDPOINT || "AZURE_OPENAI_ENDPOINT";
   const deployment = process.env.AZURE_OPENAI_DEPLOYMENT_NAME || "gpt-4o-mini-audio-preview"; 
   const apiVersion = process.env.OPENAI_API_VERSION || "2025-01-01-preview"; 

   const client = new AzureOpenAI({ 
       endpoint, 
       azureADTokenProvider, 
       apiVersion, 
       deployment 
   }); 

   async function main() {

       // Make the audio chat completions request
       const response = await client.chat.completions.create({ 
           model: "gpt-4o-mini-audio-preview", 
           modalities: ["text", "audio"], 
           audio: { voice: "alloy", format: "wav" }, 
           messages: [ 
           { 
               role: "user", 
               content: "Is a golden retriever a good family dog?" 
           } 
           ] 
       }); 

   // Inspect returned data 
   console.log(response.choices[0]); 

   // Write the output audio data to a file
   writeFileSync( 
       "dog.wav", 
       Buffer.from(response.choices[0].message.audio.data, 'base64'), 
       { encoding: "utf-8" } 
   ); 
   }

   main().catch((err) => {
     console.error("Error occurred:", err);
   });

   module.exports = { main };
   ```
2. Sign in to Azure with the following command:

   ```shell
   az login
   ```
3. Run the JavaScript file.

   ```shell
   node to-audio.js
   ```

**[API key]**

1. Create the `to-audio.js` file with the following code:

   ```javascript
   require("dotenv").config();
   const { AzureOpenAI } = require("openai");
   const { writeFileSync } = require("node:fs");

   // Set environment variables or edit the corresponding values here.
   const endpoint = process.env.AZURE_OPENAI_ENDPOINT || "AZURE_OPENAI_ENDPOINT";
   const apiKey = process.env.AZURE_OPENAI_API_KEY || "AZURE_OPENAI_API_KEY";
   const apiVersion = "2025-01-01-preview"; 
   const deployment = "gpt-4o-mini-audio-preview"; 

   const client = new AzureOpenAI({ 
       endpoint, 
       apiKey, 
       apiVersion, 
       deployment 
   });  

   async function main() {

       // Make the audio chat completions request
       const response = await client.chat.completions.create({ 
           model: "gpt-4o-mini-audio-preview", 
           modalities: ["text", "audio"], 
           audio: { voice: "alloy", format: "wav" }, 
           messages: [ 
           { 
               role: "user", 
               content: "Is a golden retriever a good family dog?" 
           } 
           ] 
       }); 

   // Inspect returned data 
   console.log(response.choices[0]); 

   // Write the output audio data to a file
   writeFileSync( 
       "dog.wav", 
       Buffer.from(response.choices[0].message.audio.data, 'base64'), 
       { encoding: "utf-8" } 
   ); 
   }

   main().catch((err) => {
     console.error("Error occurred:", err);
   });

   module.exports = { main };
   ```
2. Run the JavaScript file.

   ```shell
   node to-audio.js
   ```

Wait a few moments to get the response.

### Output for audio generation from text input

The script generates an audio file named *dog.wav* in the same directory as the script. The audio file contains the spoken response to the prompt, "Is a golden retriever a good family dog?"

## Generate audio and text from audio input

**[Microsoft Entra ID]**

1. Create the `from-audio.js` file with the following code:

   ```javascript
   require("dotenv").config();
   const { AzureOpenAI } = require("openai");
   const { DefaultAzureCredential, getBearerTokenProvider } = require("@azure/identity");
   const fs = require('fs').promises;
   const { writeFileSync } = require("node:fs");

   // Keyless authentication    
   const credential = new DefaultAzureCredential();
   const scope = "https://ai.azure.com/.default";
   const azureADTokenProvider = getBearerTokenProvider(credential, scope);

   // Set environment variables or edit the corresponding values here.
   const endpoint = process.env.AZURE_OPENAI_ENDPOINT || "AZURE_OPENAI_ENDPOINT";
   const apiVersion = "2025-01-01-preview"; 
   const deployment = "gpt-4o-mini-audio-preview"; 

   const client = new AzureOpenAI({ 
       endpoint, 
       azureADTokenProvider, 
       apiVersion, 
       deployment 
   });    

   async function main() {

       // Buffer the audio for input to the chat completion
       const wavBuffer = await fs.readFile("dog.wav"); 
       const base64str = Buffer.from(wavBuffer).toString("base64"); 

       // Make the audio chat completions request
       const response = await client.chat.completions.create({
           model: "gpt-4o-mini-audio-preview",
           modalities: ["text", "audio"],
           audio: { voice: "alloy", format: "wav" }, 
           messages: [
               {
                   role: "user",
                   content: [
                       { 
                           type: "text", 
                           text: "Describe in detail the spoken audio input." 
                       },
                       { 
                           type: "input_audio", 
                           input_audio: { 
                               data: base64str, 
                               format: "wav" 
                           } 
                       }
                   ]
               }
           ]
       });

       console.log(response.choices[0]); 

       // Write the output audio data to a file
       writeFileSync( 
           "analysis.wav", 
           Buffer.from(response.choices[0].message.audio.data, 'base64'), 
           { encoding: "utf-8" } 
       ); 
   }

   main().catch((err) => {
       console.error("Error occurred:", err);
   });

   module.exports = { main };
   ```
2. Sign in to Azure with the following command:

   ```shell
   az login
   ```
3. Run the JavaScript file.

   ```shell
   node from-audio.js
   ```

**[API key]**

1. Create the `from-audio.js` file with the following code:

   ```javascript
   require("dotenv").config();
   const { AzureOpenAI } = require("openai");
   const fs = require('fs').promises;
   const { writeFileSync } = require("node:fs");

   // Set environment variables or edit the corresponding values here.
   const endpoint = process.env.AZURE_OPENAI_ENDPOINT || "AZURE_OPENAI_ENDPOINT";
   const apiKey = process.env.AZURE_OPENAI_API_KEY || "AZURE_OPENAI_API_KEY";
   const apiVersion = "2025-01-01-preview"; 
   const deployment = "gpt-4o-mini-audio-preview"; 

   const client = new AzureOpenAI({ 
       endpoint, 
       apiKey, 
       apiVersion, 
       deployment 
   });  

   async function main() {

       // Buffer the audio for input to the chat completion
       const wavBuffer = await fs.readFile("dog.wav"); 
       const base64str = Buffer.from(wavBuffer).toString("base64"); 

       // Make the audio chat completions request
       const response = await client.chat.completions.create({
           model: "gpt-4o-mini-audio-preview",
           modalities: ["text", "audio"],
           audio: { voice: "alloy", format: "wav" }, 
           messages: [
               {
                   role: "user",
                   content: [
                       { 
                           type: "text", 
                           text: "Describe in detail the spoken audio input." 
                       },
                       { 
                           type: "input_audio", 
                           input_audio: { 
                               data: base64str, 
                               format: "wav" 
                           } 
                       }
                   ]
               }
           ]
       });

       console.log(response.choices[0]); 

       // Write the output audio data to a file
       writeFileSync( 
           "analysis.wav", 
           Buffer.from(response.choices[0].message.audio.data, 'base64'), 
           { encoding: "utf-8" } 
       ); 
   }

   main().catch((err) => {
       console.error("Error occurred:", err);
   });

   module.exports = { main };
   ```
2. Run the JavaScript file.

   ```shell
   node from-audio.js
   ```

Wait a few moments to get the response.

### Output for audio and text generation from audio input

The script generates a transcript of the summary of the spoken audio input. It also generates an audio file named *analysis.wav* in the same directory as the script. The audio file contains the spoken response to the prompt.

## Generate audio and use multi-turn chat completions

**[Microsoft Entra ID]**

1. Create the `multi-turn.js` file with the following code:

   ```javascript
   require("dotenv").config();
   const { AzureOpenAI } = require("openai");
   const { DefaultAzureCredential, getBearerTokenProvider } = require("@azure/identity");
   const fs = require('fs').promises;

   // Keyless authentication    
   const credential = new DefaultAzureCredential();
   const scope = "https://ai.azure.com/.default";
   const azureADTokenProvider = getBearerTokenProvider(credential, scope);

   // Set environment variables or edit the corresponding values here.
   const endpoint = process.env.AZURE_OPENAI_ENDPOINT || "AZURE_OPENAI_ENDPOINT";
   const apiVersion = "2025-01-01-preview"; 
   const deployment = "gpt-4o-mini-audio-preview"; 

   const client = new AzureOpenAI({ 
       endpoint, 
       azureADTokenProvider, 
       apiVersion, 
       deployment 
   }); 

   async function main() {

       // Buffer the audio for input to the chat completion
       const wavBuffer = await fs.readFile("dog.wav"); 
       const base64str = Buffer.from(wavBuffer).toString("base64"); 

       // Initialize messages with the first turn's user input 
       const messages = [
           {
               role: "user",
               content: [
                   { 
                       type: "text", 
                       text: "Describe in detail the spoken audio input." 
                   },
                   { 
                       type: "input_audio", 
                       input_audio: { 
                           data: base64str, 
                           format: "wav" 
                       } 
                   }
               ]
           }
       ];

       // Get the first turn's response 

       const response = await client.chat.completions.create({ 
           model: "gpt-4o-mini-audio-preview",
           modalities: ["text", "audio"], 
           audio: { voice: "alloy", format: "wav" }, 
           messages: messages
       }); 

       console.log(response.choices[0]); 

       // Add a history message referencing the previous turn's audio by ID 
       messages.push({ 
           role: "assistant", 
           audio: { id: response.choices[0].message.audio.id }
       });

       // Add a new user message for the second turn
       messages.push({ 
           role: "user", 
           content: [ 
               { 
                   type: "text", 
                   text: "Very concisely summarize the favorability." 
               } 
           ] 
       }); 

       // Send the follow-up request with the accumulated messages
       const followResponse = await client.chat.completions.create({ 
           model: "gpt-4o-mini-audio-preview",
           messages: messages
       });

       console.log(followResponse.choices[0].message.content); 
   }

   main().catch((err) => {
       console.error("Error occurred:", err);
   });

   module.exports = { main };
   ```
2. Sign in to Azure with the following command:

   ```shell
   az login
   ```
3. Run the JavaScript file.

   ```shell
   node multi-turn.js
   ```

**[API key]**

1. Create the `multi-turn.js` file with the following code:

   ```javascript
   require("dotenv").config();
   const { AzureOpenAI } = require("openai");
   const fs = require('fs').promises;

   // Set environment variables or edit the corresponding values here.
   const endpoint = process.env.AZURE_OPENAI_ENDPOINT || "AZURE_OPENAI_ENDPOINT";
   const apiKey = process.env.AZURE_OPENAI_API_KEY || "AZURE_OPENAI_API_KEY";
   const apiVersion = "2025-01-01-preview"; 
   const deployment = "gpt-4o-mini-audio-preview"; 

   const client = new AzureOpenAI({ 
       endpoint, 
       apiKey, 
       apiVersion, 
       deployment 
   });  

   async function main() {

       // Buffer the audio for input to the chat completion
       const wavBuffer = await fs.readFile("dog.wav"); 
       const base64str = Buffer.from(wavBuffer).toString("base64"); 

       // Initialize messages with the first turn's user input 
       const messages = [
           {
               role: "user",
               content: [
                   { 
                       type: "text", 
                       text: "Describe in detail the spoken audio input." 
                   },
                   { 
                       type: "input_audio", 
                       input_audio: { 
                           data: base64str, 
                           format: "wav" 
                       } 
                   }
               ]
           }
       ];

       // Get the first turn's response 

       const response = await client.chat.completions.create({ 
           model: "gpt-4o-mini-audio-preview",
           modalities: ["text", "audio"], 
           audio: { voice: "alloy", format: "wav" }, 
           messages: messages
       }); 

       console.log(response.choices[0]); 

       // Add a history message referencing the previous turn's audio by ID 
       messages.push({ 
           role: "assistant", 
           audio: { id: response.choices[0].message.audio.id }
       });

       // Add a new user message for the second turn
       messages.push({ 
           role: "user", 
           content: [ 
               { 
                   type: "text", 
                   text: "Very concisely summarize the favorability." 
               } 
           ] 
       }); 

       // Send the follow-up request with the accumulated messages
       const followResponse = await client.chat.completions.create({ 
           model: "gpt-4o-mini-audio-preview",
           messages: messages
       });

       console.log(followResponse.choices[0].message.content); 
   }

   main().catch((err) => {
       console.error("Error occurred:", err);
   });

   module.exports = { main };
   ```
2. Run the JavaScript file.

   ```shell
   node multi-turn.js
   ```

Wait a few moments to get the response.

### Output for multi-turn chat completions

The script generates a transcript of the summary of the spoken audio input. Then, it makes a multi-turn chat completion to briefly summarize the spoken audio input.

**[programming-language-python]**

[Library source code](https://github.com/openai/openai-python/tree/main/src/openai) | [Package](https://github.com/openai/openai-python) | [Samples](https://github.com/openai/openai-python/tree/main/examples)

Audio-enabled models introduce the audio modality into the existing `/chat/completions` API. The audio model expands the potential for AI applications in text and voice-based interactions and audio analysis. Modalities supported in `gpt-4o-audio-preview` and `gpt-4o-mini-audio-preview` models include: text, audio, and text + audio.

Here's a table of the supported modalities with example use cases:

| Modality input | Modality output | Example use case |
| --- | --- | --- |
| Text | Text + audio | Text to speech, audio book generation |
| Audio | Text + audio | Audio transcription, audio book generation |
| Audio | Text | Audio transcription |
| Text + audio | Text + audio | Audio book generation |
| Text + audio | Text | Audio transcription |

By using audio generation capabilities, you can achieve more dynamic and interactive AI applications. Models that support audio inputs and outputs allow you to generate spoken audio responses to prompts and use audio inputs to prompt the model.

## Supported models

The following OpenAI models support audio generation:

| Model | Audio generation? | Primary Use |
| --- | --- | --- |
| `gpt-4o-audio-preview` | ✔️ | Chat completions with spoken output |
| `gpt-4o-mini-tts` | ✔️ | Fast, scalable text-to-speech |
| `gpt-4o-mini-audio-preview` | ✔️ | Asynchronous audio generation |
| `gpt-realtime` | ✔️ | Real‑time interactive voice |
| `gpt-realtime-mini` | ✔️ | Low‑latency audio streaming |
| `tts-1` / `tts-1-hd` | ✔️ | General‑purpose speech synthesis |

For information about region availability, see the [models and versions documentation](../06.1-explore-foundry-models/01-models-sold-directly-by-azure.md).

> **Note**
>
> The [Realtime API](15-realtime-audio-websockets.md#voice-agent-quickstart) uses the same underlying GPT-4o audio model as the completions API, but is optimized for low-latency, real-time audio interactions.

## Input requirements

The following voices are supported for audio out: Alloy, Ash, Ballad, Coral, Echo, Sage, Shimmer, Verse, Marin, and Cedar.

The following audio output formats are supported: wav, mp3, flac, opus, pcm16, and aac.

The maximum audio file size is 20 MB.

## API support

Support for audio completions was first added in API version `2025-01-01-preview`.

Use this guide to get started generating audio with the Azure OpenAI SDK for Python.

## Prerequisites

- An Azure subscription. [Create one for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- [Python 3.8 or later version](https://www.python.org/). We recommend using Python 3.10 or later, but having at least Python 3.8 is required. If you don't have a suitable version of Python installed, you can follow the instructions in the [VS Code Python Tutorial](https://code.visualstudio.com/docs/python/python-tutorial#_install-a-python-interpreter) for the easiest way of installing Python on your operating system.
- An Azure OpenAI resource created in one of the supported regions. For more information about region availability, see the [Region availability for Foundry Models sold by Azure](../06.2-quota-limits-and-region-availability/01-models-sold-directly-by-azure-region-availability.md).
- Then, you need to deploy a `gpt-4o-mini-audio-preview` model with your Azure OpenAI resource. For more information, see [Create a resource and deploy a model with Azure OpenAI](https://learn.microsoft.com/en-us/azure/foundry-classic/openai/how-to/create-resource).

## Microsoft Entra ID prerequisites

For the recommended keyless authentication with Microsoft Entra ID, you need to:

- Install the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) used for keyless authentication with Microsoft Entra ID.
- Assign the `Cognitive Services User` role to your user account. You can assign roles in the Azure portal under **Access control (IAM)** > **Add role assignment**.

## Set up

1. Create a new folder `audio-completions-quickstart` and go to the quickstart folder with the following command:

   ```shell
   mkdir audio-completions-quickstart && cd audio-completions-quickstart
   ```
2. Create a virtual environment. If you already have Python 3.10 or higher installed, you can create a virtual environment using the following commands:

   **[Windows]**

   ```bash
   py -3 -m venv .venv
   .venv\scripts\activate
   ```

   **[Linux]**

   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   ```

   **[macOS]**

   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   ```

   Activating the Python environment means that when you run `python` or `pip` from the command line, you then use the Python interpreter contained in the `.venv` folder of your application. You can use the `deactivate` command to exit the python virtual environment, and can later reactivate it when needed.

   > **Tip**
   >
   > We recommend that you create and activate a new Python environment to use to install the packages you need for this tutorial. Don't install packages into your global python installation. You should always use a virtual or conda environment when installing python packages, otherwise you can break your global installation of Python.
3. Install the OpenAI client library for Python with:

   ```console
   pip install openai
   ```
4. For the **recommended** keyless authentication with Microsoft Entra ID, install the `azure-identity` package with:

   ```console
   pip install azure-identity
   ```

## Retrieve resource information

You need to retrieve the following information to authenticate your application with your Azure OpenAI resource:

**[Microsoft Entra ID]**

| Variable name | Value |
| --- | --- |
| `AZURE_OPENAI_ENDPOINT` | This value can be found in the **Keys and Endpoint** section when examining your resource from the Azure portal. |
| `AZURE_OPENAI_DEPLOYMENT_NAME` | This value will correspond to the custom name you chose for your deployment when you deployed a model. This value can be found under **Resource Management** > **Model Deployments** in the Azure portal. |

Learn more about [keyless authentication](https://learn.microsoft.com/en-us/azure/ai-services/authentication) and [setting environment variables](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-environment-variables).

**[API key]**

| Variable name | Value |
| --- | --- |
| `AZURE_OPENAI_ENDPOINT` | This value can be found in the **Keys and Endpoint** section when examining your resource from the Azure portal. |
| `AZURE_OPENAI_API_KEY` | This value can be found in the **Keys and Endpoint** section when examining your resource from the Azure portal. You can use either `KEY1` or `KEY2`. |
| `AZURE_OPENAI_DEPLOYMENT_NAME` | This value will correspond to the custom name you chose for your deployment when you deployed a model. This value can be found under **Resource Management** > **Model Deployments** in the Azure portal. |

Learn more about [finding API keys](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-environment-variables) and [setting environment variables](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-environment-variables).

> **Important**
>
> Use API keys with caution. Don't include the API key directly in your code, and never post it publicly. If you use an API key, store it securely in Azure Key Vault. For more information about using API keys securely in your apps, see [API keys with Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/apps-api-keys-secrets).
>
> For more information about AI services security, see [Authenticate requests to Azure AI services](https://learn.microsoft.com/en-us/azure/ai-services/authentication).

## Generate audio from text input

**[Microsoft Entra ID]**

1. Create the `to-audio.py` file with the following code:

   ```python
   import requests
   import base64 
   import os 
   from openai import AzureOpenAI
   from azure.identity import DefaultAzureCredential, get_bearer_token_provider

   token_provider=get_bearer_token_provider(DefaultAzureCredential(), "https://ai.azure.com/.default")

   # Set environment variables or edit the corresponding values here.
   endpoint = os.environ['AZURE_OPENAI_ENDPOINT']

   # Keyless authentication
   client=AzureOpenAI(
       azure_ad_token_provider=token_provider,
       azure_endpoint=endpoint,
       api_version="2025-01-01-preview"
   )

   # Make the audio chat completions request
   completion=client.chat.completions.create(
       model="gpt-4o-mini-audio-preview",
       modalities=["text", "audio"],
       audio={"voice": "alloy", "format": "wav"},
       messages=[
           {
               "role": "user",
               "content": "Is a golden retriever a good family dog?"
           }
       ]
   )

   print(completion.choices[0])

   # Write the output audio data to a file
   wav_bytes=base64.b64decode(completion.choices[0].message.audio.data)
   with open("dog.wav", "wb") as f:
       f.write(wav_bytes)
   ```
2. Run the Python file.

   ```shell
   python to-audio.py
   ```

**[API key]**

1. Create the `to-audio.py` file with the following code:

   ```python
   import base64 
   import os 
   from openai import AzureOpenAI 

   # Set environment variables or edit the corresponding values here.
   endpoint = os.environ['AZURE_OPENAI_ENDPOINT']
   api_key = os.environ['AZURE_OPENAI_API_KEY']

   client = AzureOpenAI(
       api_version="2025-01-01-preview",  
       api_key=api_key,
       azure_endpoint=endpoint
   )

   # Make the audio chat completions request
   completion = client.chat.completions.create(
       model="gpt-4o-mini-audio-preview",
       modalities=["text", "audio"],
       audio={"voice": "alloy", "format": "wav"},
       messages=[
           {
               "role": "user",
               "content": "Is a golden retriever a good family dog?"
           }
       ]
   )

   print(completion.choices[0])

   # Write the output audio data to a file
   wav_bytes = base64.b64decode(completion.choices[0].message.audio.data)
   with open("dog.wav", "wb") as f:
       f.write(wav_bytes)
   ```
2. Run the Python file.

   ```shell
   python to-audio.py
   ```

Wait a few moments to get the response.

### Output for audio generation from text input

The script generates an audio file named *dog.wav* in the same directory as the script. The audio file contains the spoken response to the prompt, "Is a golden retriever a good family dog?"

> **Tip**
>
> Play the generated *dog.wav* file to verify the audio was generated correctly. You can use any media player or double-click the file to open it in your default audio player.

## Generate audio and text from audio input

**[Microsoft Entra ID]**

1. Create the `from-audio.py` file with the following code:

   ```python
   import base64
   import os
   from openai import AzureOpenAI
   from azure.identity import DefaultAzureCredential, get_bearer_token_provider

   token_provider=get_bearer_token_provider(DefaultAzureCredential(), "https://ai.azure.com/.default")

   # Set environment variables or edit the corresponding values here.
   endpoint = os.environ['AZURE_OPENAI_ENDPOINT']

   # Keyless authentication
   client=AzureOpenAI(
       azure_ad_token_provider=token_provider,
       azure_endpoint=endpoint,
       api_version="2025-01-01-preview"
   )

   # Read and encode audio file  
   with open('dog.wav', 'rb') as wav_reader: 
       encoded_string = base64.b64encode(wav_reader.read()).decode('utf-8') 

   # Make the audio chat completions request
   completion = client.chat.completions.create( 
       model="gpt-4o-mini-audio-preview", 
       modalities=["text", "audio"], 
       audio={"voice": "alloy", "format": "wav"}, 
       messages=[ 
           { 
               "role": "user", 
               "content": [ 
                   {  
                       "type": "text", 
                       "text": "Describe in detail the spoken audio input." 
                   }, 
                   { 
                       "type": "input_audio", 
                       "input_audio": { 
                           "data": encoded_string, 
                           "format": "wav" 
                       } 
                   } 
               ] 
           }, 
       ] 
   ) 

   print(completion.choices[0].message.audio.transcript)

   # Write the output audio data to a file
   wav_bytes = base64.b64decode(completion.choices[0].message.audio.data)
   with open("analysis.wav", "wb") as f:
       f.write(wav_bytes)
   ```
2. Run the Python file.

   ```shell
   python from-audio.py
   ```

**[API key]**

1. Create the `from-audio.py` file with the following code:

   ```python
   import base64
   import os
   from openai import AzureOpenAI

   # Set environment variables or edit the corresponding values here.
   endpoint = os.environ['AZURE_OPENAI_ENDPOINT']
   api_key = os.environ['AZURE_OPENAI_API_KEY']

   client = AzureOpenAI(
       api_version="2025-01-01-preview",  
       api_key=api_key, 
       azure_endpoint=endpoint,
   )

   # Read and encode audio file  
   with open('dog.wav', 'rb') as wav_reader: 
       encoded_string = base64.b64encode(wav_reader.read()).decode('utf-8') 

   # Make the audio chat completions request
   completion = client.chat.completions.create( 
       model="gpt-4o-mini-audio-preview", 
       modalities=["text", "audio"], 
       audio={"voice": "alloy", "format": "wav"}, 
       messages=[ 
           { 
               "role": "user", 
               "content": [ 
                   {  
                       "type": "text", 
                       "text": "Describe in detail the spoken audio input." 
                   }, 
                   { 
                       "type": "input_audio", 
                       "input_audio": { 
                           "data": encoded_string, 
                           "format": "wav" 
                       } 
                   } 
               ] 
           }, 
       ] 
   ) 

   print(completion.choices[0].message.audio.transcript)

   # Write the output audio data to a file
   wav_bytes = base64.b64decode(completion.choices[0].message.audio.data)
   with open("analysis.wav", "wb") as f:
       f.write(wav_bytes)
   ```
2. Run the Python file.

   ```shell
   python from-audio.py
   ```

Wait a few moments to get the response.

### Output for audio and text generation from audio input

The script generates a transcript of the summary of the spoken audio input. It also generates an audio file named *analysis.wav* in the same directory as the script. The audio file contains the spoken response to the prompt.

> **Tip**
>
> Play the generated *analysis.wav* file to hear the audio description of the input.

## Generate audio and use multi-turn chat completions

**[Microsoft Entra ID]**

1. Create the `multi-turn.py` file with the following code:

   ```python
   import base64 
   import os 
   from openai import AzureOpenAI 
   from azure.identity import DefaultAzureCredential, get_bearer_token_provider

   token_provider=get_bearer_token_provider(DefaultAzureCredential(), "https://ai.azure.com/.default")

   # Set environment variables or edit the corresponding values here.
   endpoint = os.environ['AZURE_OPENAI_ENDPOINT']

   # Keyless authentication
   client=AzureOpenAI(
       azure_ad_token_provider=token_provider,
       azure_endpoint=endpoint,
       api_version="2025-01-01-preview"
   )

   # Read and encode audio file  
   with open('dog.wav', 'rb') as wav_reader: 
       encoded_string = base64.b64encode(wav_reader.read()).decode('utf-8') 

   # Initialize messages with the first turn's user input 
   messages = [
       { 
           "role": "user", 
           "content": [ 
               { "type": "text", "text": "Describe in detail the spoken audio input." }, 
               { "type": "input_audio", 
                   "input_audio": { 
                       "data": encoded_string, 
                       "format": "wav" 
                   } 
               } 
           ] 
       }] 

   # Get the first turn's response

   completion = client.chat.completions.create( 
       model="gpt-4o-mini-audio-preview", 
       modalities=["text", "audio"], 
       audio={"voice": "alloy", "format": "wav"}, 
       messages=messages
   ) 

   print("Get the first turn's response:")
   print(completion.choices[0].message.audio.transcript) 

   print("Add a history message referencing the first turn's audio by ID:")
   print(completion.choices[0].message.audio.id)

   # Add a history message referencing the first turn's audio by ID 
   messages.append({ 
       "role": "assistant", 
       "audio": { "id": completion.choices[0].message.audio.id } 
   }) 

   # Add the next turn's user message 
   messages.append({ 
       "role": "user", 
       "content": "Very briefly, summarize the favorability." 
   }) 

   # Send the follow-up request with the accumulated messages
   completion = client.chat.completions.create( 
       model="gpt-4o-mini-audio-preview", 
       messages=messages
   ) 

   print("Very briefly, summarize the favorability.")
   print(completion.choices[0].message.content)
   ```
2. Run the Python file.

   ```shell
   python multi-turn.py
   ```

**[API key]**

1. Create the `multi-turn.py` file with the following code:

   ```python
   import base64 
   import os 
   from openai import AzureOpenAI 

   # Set environment variables or edit the corresponding values here.
   endpoint = os.environ['AZURE_OPENAI_ENDPOINT']
   api_key = os.environ['AZURE_OPENAI_API_KEY']

   client = AzureOpenAI(
       api_version="2025-01-01-preview",  
       api_key=api_key, 
       azure_endpoint=endpoint
   )

   # Read and encode audio file  
   with open('dog.wav', 'rb') as wav_reader: 
       encoded_string = base64.b64encode(wav_reader.read()).decode('utf-8') 

   # Initialize messages with the first turn's user input 
   messages = [
       { 
           "role": "user", 
           "content": [ 
               { "type": "text", "text": "Describe in detail the spoken audio input." }, 
               { "type": "input_audio", 
                   "input_audio": { 
                       "data": encoded_string, 
                       "format": "wav" 
                   } 
               } 
           ] 
       }] 

   # Get the first turn's response 

   completion = client.chat.completions.create( 
       model="gpt-4o-mini-audio-preview", 
       modalities=["text", "audio"], 
       audio={"voice": "alloy", "format": "wav"}, 
       messages=messages
   ) 

   print("Get the first turn's response:")
   print(completion.choices[0].message.audio.transcript) 

   print("Add a history message referencing the first turn's audio by ID:")
   print(completion.choices[0].message.audio.id)

   # Add a history message referencing the first turn's audio by ID 
   messages.append({ 
       "role": "assistant", 
       "audio": { "id": completion.choices[0].message.audio.id } 
   }) 

   # Add the next turn's user message 
   messages.append({ 
       "role": "user", 
       "content": "Very briefly, summarize the favorability." 
   }) 

   # Send the follow-up request with the accumulated messages 
   completion = client.chat.completions.create( 
       model="gpt-4o-mini-audio-preview", 
       messages=messages
   ) 

   print("Very briefly, summarize the favorability.")
   print(completion.choices[0].message.content)
   ```
2. Run the Python file.

   ```shell
   python multi-turn.py
   ```

Wait a few moments to get the response.

### Output for multi-turn chat completions

The script generates a transcript of the summary of the spoken audio input. Then, it makes a multi-turn chat completion to briefly summarize the spoken audio input.

> **Tip**
>
> Review the console output to see the transcript and verify the multi-turn conversation completed successfully.

**[rest-api]**

[REST API Spec](https://github.com/Azure/azure-rest-api-specs/blob/main/specification/cognitiveservices/data-plane/AzureOpenAI/inference/stable/2024-10-21/inference.json) |

Audio-enabled models introduce the audio modality into the existing `/chat/completions` API. The audio model expands the potential for AI applications in text and voice-based interactions and audio analysis. Modalities supported in `gpt-4o-audio-preview` and `gpt-4o-mini-audio-preview` models include: text, audio, and text + audio.

Here's a table of the supported modalities with example use cases:

| Modality input | Modality output | Example use case |
| --- | --- | --- |
| Text | Text + audio | Text to speech, audio book generation |
| Audio | Text + audio | Audio transcription, audio book generation |
| Audio | Text | Audio transcription |
| Text + audio | Text + audio | Audio book generation |
| Text + audio | Text | Audio transcription |

By using audio generation capabilities, you can achieve more dynamic and interactive AI applications. Models that support audio inputs and outputs allow you to generate spoken audio responses to prompts and use audio inputs to prompt the model.

## Supported models

The following OpenAI models support audio generation:

| Model | Audio generation? | Primary Use |
| --- | --- | --- |
| `gpt-4o-audio-preview` | ✔️ | Chat completions with spoken output |
| `gpt-4o-mini-tts` | ✔️ | Fast, scalable text-to-speech |
| `gpt-4o-mini-audio-preview` | ✔️ | Asynchronous audio generation |
| `gpt-realtime` | ✔️ | Real‑time interactive voice |
| `gpt-realtime-mini` | ✔️ | Low‑latency audio streaming |
| `tts-1` / `tts-1-hd` | ✔️ | General‑purpose speech synthesis |

For information about region availability, see the [models and versions documentation](../06.1-explore-foundry-models/01-models-sold-directly-by-azure.md).

> **Note**
>
> The [Realtime API](15-realtime-audio-websockets.md#voice-agent-quickstart) uses the same underlying GPT-4o audio model as the completions API, but is optimized for low-latency, real-time audio interactions.

## Input requirements

The following voices are supported for audio out: Alloy, Ash, Ballad, Coral, Echo, Sage, Shimmer, Verse, Marin, and Cedar.

The following audio output formats are supported: wav, mp3, flac, opus, pcm16, and aac.

The maximum audio file size is 20 MB.

## API support

Support for audio completions was first added in API version `2025-01-01-preview`.

## Prerequisites

- An Azure subscription. [Create one for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- [Python 3.8 or later version](https://www.python.org/). We recommend using Python 3.10 or later, but having at least Python 3.8 is required. If you don't have a suitable version of Python installed, you can follow the instructions in the [VS Code Python Tutorial](https://code.visualstudio.com/docs/python/python-tutorial#_install-a-python-interpreter) for the easiest way of installing Python on your operating system.
- An Azure OpenAI resource created in one of the supported regions. For more information about region availability, see the [Region availability for Foundry Models sold by Azure](../06.2-quota-limits-and-region-availability/01-models-sold-directly-by-azure-region-availability.md).
- Then, you need to deploy a `gpt-4o-mini-audio-preview` model with your Azure OpenAI resource. For more information, see [Create a resource and deploy a model with Azure OpenAI](https://learn.microsoft.com/en-us/azure/foundry-classic/openai/how-to/create-resource).

## Microsoft Entra ID prerequisites

For the recommended keyless authentication with Microsoft Entra ID, you need to:

- Install the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) used for keyless authentication with Microsoft Entra ID.
- Assign the `Cognitive Services User` role to your user account. You can assign roles in the Azure portal under **Access control (IAM)** > **Add role assignment**.

## Set up

1. Create a new folder `audio-completions-quickstart` and go to the quickstart folder with the following command:

   ```shell
   mkdir audio-completions-quickstart && cd audio-completions-quickstart
   ```
2. Create a virtual environment. If you already have Python 3.10 or higher installed, you can create a virtual environment using the following commands:

   **[Windows]**

   ```bash
   py -3 -m venv .venv
   .venv\scripts\activate
   ```

   **[Linux]**

   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   ```

   **[macOS]**

   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   ```

   Activating the Python environment means that when you run `python` or `pip` from the command line, you then use the Python interpreter contained in the `.venv` folder of your application. You can use the `deactivate` command to exit the python virtual environment, and can later reactivate it when needed.

   > **Tip**
   >
   > We recommend that you create and activate a new Python environment to use to install the packages you need for this tutorial. Don't install packages into your global python installation. You should always use a virtual or conda environment when installing python packages, otherwise you can break your global installation of Python.
3. Install the OpenAI client library for Python with:

   ```console
   pip install openai
   ```
4. For the **recommended** keyless authentication with Microsoft Entra ID, install the `azure-identity` package with:

   ```console
   pip install azure-identity
   ```

## Retrieve resource information

You need to retrieve the following information to authenticate your application with your Azure OpenAI resource:

**[Microsoft Entra ID]**

| Variable name | Value |
| --- | --- |
| `AZURE_OPENAI_ENDPOINT` | This value can be found in the **Keys and Endpoint** section when examining your resource from the Azure portal. |
| `AZURE_OPENAI_DEPLOYMENT_NAME` | This value will correspond to the custom name you chose for your deployment when you deployed a model. This value can be found under **Resource Management** > **Model Deployments** in the Azure portal. |

Learn more about [keyless authentication](https://learn.microsoft.com/en-us/azure/ai-services/authentication) and [setting environment variables](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-environment-variables).

**[API key]**

| Variable name | Value |
| --- | --- |
| `AZURE_OPENAI_ENDPOINT` | This value can be found in the **Keys and Endpoint** section when examining your resource from the Azure portal. |
| `AZURE_OPENAI_API_KEY` | This value can be found in the **Keys and Endpoint** section when examining your resource from the Azure portal. You can use either `KEY1` or `KEY2`. |
| `AZURE_OPENAI_DEPLOYMENT_NAME` | This value will correspond to the custom name you chose for your deployment when you deployed a model. This value can be found under **Resource Management** > **Model Deployments** in the Azure portal. |

Learn more about [finding API keys](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-environment-variables) and [setting environment variables](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-environment-variables).

> **Important**
>
> Use API keys with caution. Don't include the API key directly in your code, and never post it publicly. If you use an API key, store it securely in Azure Key Vault. For more information about using API keys securely in your apps, see [API keys with Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/apps-api-keys-secrets).
>
> For more information about AI services security, see [Authenticate requests to Azure AI services](https://learn.microsoft.com/en-us/azure/ai-services/authentication).

## Generate audio from text input

**[Microsoft Entra ID]**

1. Create the `to-audio.py` file with the following code:

   ```python
   import requests
   import base64 
   import os 
   from openai import AzureOpenAI
   from azure.identity import DefaultAzureCredential

   # Set environment variables or edit the corresponding values here.
   endpoint = os.environ['AZURE_OPENAI_ENDPOINT']

   # Keyless authentication
   credential = DefaultAzureCredential()
   token = credential.get_token("https://ai.azure.com/.default")

   api_version = '2025-01-01-preview'
   url = f"{endpoint}/openai/deployments/gpt-4o-mini-audio-preview/chat/completions?api-version={api_version}"
   headers= { "Authorization": f"Bearer {token.token}", "Content-Type": "application/json" }
   body = {
     "modalities": ["audio", "text"],
     "model": "gpt-4o-mini-audio-preview",
     "audio": {
         "format": "wav",
         "voice": "alloy"
     },
     "messages": [
       {
         "role": "user",
         "content": [
           {
             "type": "text",
             "text": "Is a golden retriever a good family dog?"
           }
         ]
       }
     ]
   }

   # Make the audio chat completions request
   completion = requests.post(url, headers=headers, json=body)
   audio_data = completion.json()['choices'][0]['message']['audio']['data']

   # Write the output audio data to a file
   wav_bytes = base64.b64decode(audio_data)
   with open("dog.wav", "wb") as f: 
     f.write(wav_bytes) 
   ```
2. Run the Python file.

   ```shell
   python to-audio.py
   ```

**[API key]**

1. Create the `to-audio.py` file with the following code:

   ```python
   import requests
   import base64 
   import os 
   from openai import AzureOpenAI 

   # Set environment variables or edit the corresponding values here.
   endpoint = os.environ['AZURE_OPENAI_ENDPOINT']
   api_key = os.environ['AZURE_OPENAI_API_KEY']

   api_version = '2025-01-01-preview'
   url = f"{endpoint}/openai/deployments/gpt-4o-mini-audio-preview/chat/completions?api-version={api_version}"
   headers= { "api-key": api_key, "Content-Type": "application/json" }
   body = {
     "modalities": ["audio", "text"],
     "model": "gpt-4o-mini-audio-preview",
     "audio": {
         "format": "wav",
         "voice": "alloy"
     },
     "messages": [
       {
         "role": "user",
         "content": [
           {
             "type": "text",
             "text": "Is a golden retriever a good family dog?"
           }
         ]
       }
     ]
   }

   # Make the audio chat completions request
   completion = requests.post(url, headers=headers, json=body)
   audio_data = completion.json()['choices'][0]['message']['audio']['data']

   # Write the output audio data to a file 
   wav_bytes = base64.b64decode(audio_data)
   with open("dog.wav", "wb") as f: 
     f.write(wav_bytes) 
   ```
2. Run the Python file.

   ```shell
   python to-audio.py
   ```

Wait a few moments to get the response.

### Output for audio generation from text input

The script generates an audio file named *dog.wav* in the same directory as the script. The audio file contains the spoken response to the prompt, "Is a golden retriever a good family dog?"

## Generate audio and text from audio input

**[Microsoft Entra ID]**

1. Create the `from-audio.py` file with the following code:

   ```python
   import requests
   import base64
   import os
   from azure.identity import DefaultAzureCredential

   # Set environment variables or edit the corresponding values here.
   endpoint = os.environ['AZURE_OPENAI_ENDPOINT']

   # Keyless authentication
   credential = DefaultAzureCredential()
   token = credential.get_token("https://ai.azure.com/.default")

   # Read and encode audio file  
   with open('dog.wav', 'rb') as wav_reader: 
     encoded_string = base64.b64encode(wav_reader.read()).decode('utf-8') 

   api_version = '2025-01-01-preview'
   url = f"{endpoint}/openai/deployments/gpt-4o-mini-audio-preview/chat/completions?api-version={api_version}"
   headers= { "Authorization": f"Bearer {token.token}", "Content-Type": "application/json" }
   body = {
     "modalities": ["audio", "text"],
     "model": "gpt-4o-mini-audio-preview",
     "audio": {
         "format": "wav",
         "voice": "alloy"
     },
     "messages": [
       { 
           "role": "user", 
           "content": [ 
               {  
                   "type": "text", 
                   "text": "Describe in detail the spoken audio input." 
               }, 
               { 
                   "type": "input_audio", 
                   "input_audio": { 
                       "data": encoded_string, 
                       "format": "wav" 
                   } 
               } 
           ] 
       }, 
     ]
   }

   completion = requests.post(url, headers=headers, json=body)

   print(completion.json()['choices'][0]['message']['audio']['transcript'])

   # Write the output audio data to a file
   audio_data = completion.json()['choices'][0]['message']['audio']['data'] 
   wav_bytes = base64.b64decode(audio_data)
   with open("analysis.wav", "wb") as f: 
     f.write(wav_bytes) 
   ```
2. Run the Python file.

   ```shell
   python from-audio.py
   ```

**[API key]**

1. Create the `from-audio.py` file with the following code:

   ```python
   import requests
   import base64
   import os

   # Set environment variables or edit the corresponding values here.
   endpoint = os.environ['AZURE_OPENAI_ENDPOINT']
   api_key = os.environ['AZURE_OPENAI_API_KEY']

   # Read and encode audio file  
   with open('dog.wav', 'rb') as wav_reader: 
     encoded_string = base64.b64encode(wav_reader.read()).decode('utf-8') 

   api_version = '2025-01-01-preview'
   url = f"{endpoint}/openai/deployments/gpt-4o-mini-audio-preview/chat/completions?api-version={api_version}"
   headers= { "api-key": api_key, "Content-Type": "application/json" }
   body = {
     "modalities": ["audio", "text"],
     "model": "gpt-4o-mini-audio-preview",
     "audio": {
         "format": "wav",
         "voice": "alloy"
     },
     "messages": [
       { 
           "role": "user", 
           "content": [ 
               {  
                   "type": "text", 
                   "text": "Describe in detail the spoken audio input." 
               }, 
               { 
                   "type": "input_audio", 
                   "input_audio": { 
                       "data": encoded_string, 
                       "format": "wav" 
                   } 
               } 
           ] 
       }, 
     ]
   }

   completion = requests.post(url, headers=headers, json=body)

   print(completion.json()['choices'][0]['message']['audio']['transcript'])

   # Write the output audio data to a file
   audio_data = completion.json()['choices'][0]['message']['audio']['data'] 
   wav_bytes = base64.b64decode(audio_data)
   with open("analysis.wav", "wb") as f: 
     f.write(wav_bytes) 
   ```
2. Run the Python file.

   ```shell
   python from-audio.py
   ```

Wait a few moments to get the response.

### Output for audio and text generation from audio input

The script generates a transcript of the summary of the spoken audio input. It also generates an audio file named *analysis.wav* in the same directory as the script. The audio file contains the spoken response to the prompt.

## Generate audio and use multi-turn chat completions

**[Microsoft Entra ID]**

1. Create the `multi-turn.py` file with the following code:

   ```python
   import requests
   import base64 
   import os 
   from openai import AzureOpenAI 
   from azure.identity import DefaultAzureCredential

   # Set environment variables or edit the corresponding values here.
   endpoint = os.environ['AZURE_OPENAI_ENDPOINT']

   # Keyless authentication
   credential = DefaultAzureCredential()
   token = credential.get_token("https://ai.azure.com/.default")

   api_version = '2025-01-01-preview'
   url = f"{endpoint}/openai/deployments/gpt-4o-mini-audio-preview/chat/completions?api-version={api_version}"
   headers= { "Authorization": f"Bearer {token.token}", "Content-Type": "application/json" }

   # Read and encode audio file  
   with open('dog.wav', 'rb') as wav_reader: 
     encoded_string = base64.b64encode(wav_reader.read()).decode('utf-8') 

   # Initialize messages with the first turn's user input 
   messages = [
       { 
           "role": "user", 
           "content": [ 
               {  
                   "type": "text", 
                   "text": "Describe in detail the spoken audio input." 
               }, 
               { 
                   "type": "input_audio", 
                   "input_audio": { 
                       "data": encoded_string, 
                       "format": "wav" 
                   } 
               } 
           ] 
       }] 

   body = {
     "modalities": ["audio", "text"],
     "model": "gpt-4o-mini-audio-preview",
     "audio": {
         "format": "wav",
         "voice": "alloy"
     },
     "messages": messages
   }

   # Get the first turn's response, including generated audio 
   completion = requests.post(url, headers=headers, json=body)

   print("Get the first turn's response:")
   print(completion.json()['choices'][0]['message']['audio']['transcript']) 

   print("Add a history message referencing the first turn's audio by ID:")
   print(completion.json()['choices'][0]['message']['audio']['id'])

   # Add a history message referencing the first turn's audio by ID 
   messages.append({ 
       "role": "assistant", 
       "audio": { "id": completion.json()['choices'][0]['message']['audio']['id'] } 
   }) 

   # Add the next turn's user message 
   messages.append({ 
       "role": "user", 
       "content": "Very briefly, summarize the favorability." 
   }) 

   body = {
     "model": "gpt-4o-mini-audio-preview",
     "messages": messages
   }

   # Send the follow-up request with the accumulated messages
   completion = requests.post(url, headers=headers, json=body) 

   print("Very briefly, summarize the favorability.")
   print(completion.json()['choices'][0]['message']['content'])
   ```
2. Run the Python file.

   ```shell
   python multi-turn.py
   ```

**[API key]**

1. Create the `multi-turn.py` file with the following code:

   ```python
   import requests
   import base64 
   import os 
   from openai import AzureOpenAI 

   # Set environment variables or edit the corresponding values here.
   endpoint = os.environ['AZURE_OPENAI_ENDPOINT']
   api_key = os.environ['AZURE_OPENAI_API_KEY']

   api_version = '2025-01-01-preview'
   url = f"{endpoint}/openai/deployments/gpt-4o-mini-audio-preview/chat/completions?api-version={api_version}"
   headers= { "api-key": api_key, "Content-Type": "application/json" }

   # Read and encode audio file  
   with open('dog.wav', 'rb') as wav_reader: 
     encoded_string = base64.b64encode(wav_reader.read()).decode('utf-8') 

   # Initialize messages with the first turn's user input 
   messages = [
       { 
           "role": "user", 
           "content": [ 
               {  
                   "type": "text", 
                   "text": "Describe in detail the spoken audio input." 
               }, 
               { 
                   "type": "input_audio", 
                   "input_audio": { 
                       "data": encoded_string, 
                       "format": "wav" 
                   } 
               } 
           ] 
       }] 

   body = {
     "modalities": ["audio", "text"],
     "model": "gpt-4o-mini-audio-preview",
     "audio": {
         "format": "wav",
         "voice": "alloy"
     },
     "messages": messages
   }


   # Get the first turn's response, including generated audio 
   completion = requests.post(url, headers=headers, json=body)

   print("Get the first turn's response:")
   print(completion.json()['choices'][0]['message']['audio']['transcript']) 

   print("Add a history message referencing the first turn's audio by ID:")
   print(completion.json()['choices'][0]['message']['audio']['id'])

   # Add a history message referencing the first turn's audio by ID 
   messages.append({ 
       "role": "assistant", 
       "audio": { "id": completion.json()['choices'][0]['message']['audio']['id'] } 
   }) 

   # Add the next turn's user message 
   messages.append({ 
       "role": "user", 
       "content": "Very briefly, summarize the favorability." 
   }) 

   body = {
     "model": "gpt-4o-mini-audio-preview",
     "messages": messages
   }

   # Send the follow-up request with the accumulated messages
   completion = requests.post(url, headers=headers, json=body) 

   print("Very briefly, summarize the favorability.")
   print(completion.json()['choices'][0]['message']['content'])
   ```
2. Run the Python file.

   ```shell
   python multi-turn.py
   ```

Wait a few moments to get the response.

### Output for multi-turn chat completions

The script generates a transcript of the summary of the spoken audio input. Then, it makes a multi-turn chat completion to briefly summarize the spoken audio input.

**[programming-language-typescript]**

[Reference documentation](https://platform.openai.com/docs/api-reference/chat) | [Library source code](https://github.com/openai/openai-node?azure-portal=true) | [Package (npm)](https://www.npmjs.com/package/openai) | [Samples](https://github.com/Azure/azure-sdk-for-js/tree/main/sdk/openai/openai/samples)

Audio-enabled models introduce the audio modality into the existing `/chat/completions` API. The audio model expands the potential for AI applications in text and voice-based interactions and audio analysis. Modalities supported in `gpt-4o-audio-preview` and `gpt-4o-mini-audio-preview` models include: text, audio, and text + audio.

Here's a table of the supported modalities with example use cases:

| Modality input | Modality output | Example use case |
| --- | --- | --- |
| Text | Text + audio | Text to speech, audio book generation |
| Audio | Text + audio | Audio transcription, audio book generation |
| Audio | Text | Audio transcription |
| Text + audio | Text + audio | Audio book generation |
| Text + audio | Text | Audio transcription |

By using audio generation capabilities, you can achieve more dynamic and interactive AI applications. Models that support audio inputs and outputs allow you to generate spoken audio responses to prompts and use audio inputs to prompt the model.

## Supported models

The following OpenAI models support audio generation:

| Model | Audio generation? | Primary Use |
| --- | --- | --- |
| `gpt-4o-audio-preview` | ✔️ | Chat completions with spoken output |
| `gpt-4o-mini-tts` | ✔️ | Fast, scalable text-to-speech |
| `gpt-4o-mini-audio-preview` | ✔️ | Asynchronous audio generation |
| `gpt-realtime` | ✔️ | Real‑time interactive voice |
| `gpt-realtime-mini` | ✔️ | Low‑latency audio streaming |
| `tts-1` / `tts-1-hd` | ✔️ | General‑purpose speech synthesis |

For information about region availability, see the [models and versions documentation](../06.1-explore-foundry-models/01-models-sold-directly-by-azure.md).

> **Note**
>
> The [Realtime API](15-realtime-audio-websockets.md#voice-agent-quickstart) uses the same underlying GPT-4o audio model as the completions API, but is optimized for low-latency, real-time audio interactions.

## Input requirements

The following voices are supported for audio out: Alloy, Ash, Ballad, Coral, Echo, Sage, Shimmer, Verse, Marin, and Cedar.

The following audio output formats are supported: wav, mp3, flac, opus, pcm16, and aac.

The maximum audio file size is 20 MB.

## API support

Support for audio completions was first added in API version `2025-01-01-preview`.

## Prerequisites

- An Azure subscription - [Create one for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn)
- [Node.js LTS or ESM support.](https://nodejs.org/)
- [TypeScript](https://www.typescriptlang.org/download/) installed globally.
- An Azure OpenAI resource created in one of the supported regions. For more information about region availability, see the [Region availability for Foundry Models sold by Azure](../06.2-quota-limits-and-region-availability/01-models-sold-directly-by-azure-region-availability.md).
- Then, you need to deploy a `gpt-4o-mini-audio-preview` model with your Azure OpenAI resource. For more information, see [Create a resource and deploy a model with Azure OpenAI](https://learn.microsoft.com/en-us/azure/foundry-classic/openai/how-to/create-resource).

## Microsoft Entra ID prerequisites

For the recommended keyless authentication with Microsoft Entra ID, you need to:

- Install the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) used for keyless authentication with Microsoft Entra ID.
- Assign the `Cognitive Services User` role to your user account. You can assign roles in the Azure portal under **Access control (IAM)** > **Add role assignment**.

## Set up

1. Create a new folder `audio-completions-quickstart` and go to the quickstart folder with the following command:

   ```shell
   mkdir audio-completions-quickstart && cd audio-completions-quickstart
   ```
2. Create the `package.json` with the following command:

   ```shell
   npm init -y
   ```
3. Update the `package.json` to ECMAScript with the following command:

   ```shell
   npm pkg set type=module
   ```
4. Install the OpenAI client library for JavaScript with:

   ```console
   npm install openai
   ```
5. For the **recommended** keyless authentication with Microsoft Entra ID, install the `@azure/identity` package with:

   ```console
   npm install @azure/identity
   ```

## Retrieve resource information

You need to retrieve the following information to authenticate your application with your Azure OpenAI resource:

**[Microsoft Entra ID]**

| Variable name | Value |
| --- | --- |
| `AZURE_OPENAI_ENDPOINT` | This value can be found in the **Keys and Endpoint** section when examining your resource from the Azure portal. |
| `AZURE_OPENAI_DEPLOYMENT_NAME` | This value will correspond to the custom name you chose for your deployment when you deployed a model. This value can be found under **Resource Management** > **Model Deployments** in the Azure portal. |

Learn more about [keyless authentication](https://learn.microsoft.com/en-us/azure/ai-services/authentication) and [setting environment variables](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-environment-variables).

**[API key]**

| Variable name | Value |
| --- | --- |
| `AZURE_OPENAI_ENDPOINT` | This value can be found in the **Keys and Endpoint** section when examining your resource from the Azure portal. |
| `AZURE_OPENAI_API_KEY` | This value can be found in the **Keys and Endpoint** section when examining your resource from the Azure portal. You can use either `KEY1` or `KEY2`. |
| `AZURE_OPENAI_DEPLOYMENT_NAME` | This value will correspond to the custom name you chose for your deployment when you deployed a model. This value can be found under **Resource Management** > **Model Deployments** in the Azure portal. |

Learn more about [finding API keys](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-environment-variables) and [setting environment variables](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-environment-variables).

> **Important**
>
> Use API keys with caution. Don't include the API key directly in your code, and never post it publicly. If you use an API key, store it securely in Azure Key Vault. For more information about using API keys securely in your apps, see [API keys with Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/apps-api-keys-secrets).
>
> For more information about AI services security, see [Authenticate requests to Azure AI services](https://learn.microsoft.com/en-us/azure/ai-services/authentication).

> **Caution**
>
> To use the recommended keyless authentication with the SDK, make sure that the `AZURE_OPENAI_API_KEY` environment variable isn't set.

## Generate audio from text input

**[Microsoft Entra ID]**

1. Create the `to-audio.ts` file with the following code:

   ```typescript
   import { writeFileSync } from "node:fs";
   import { AzureOpenAI } from "openai/index.mjs";
   import {
       DefaultAzureCredential,
       getBearerTokenProvider,
     } from "@azure/identity";

   // Set environment variables or edit the corresponding values here.
   const endpoint: string = process.env.AZURE_OPENAI_ENDPOINT || "AZURE_OPENAI_ENDPOINT";
   const deployment: string = process.env.AZURE_OPENAI_DEPLOYMENT_NAME || "gpt-4o-mini-audio-preview"; 
   const apiVersion: string = process.env.OPENAI_API_VERSION || "2025-01-01-preview"; 

   // Keyless authentication 
   const getClient = (): AzureOpenAI => {
       const credential = new DefaultAzureCredential();
       const scope = "https://ai.azure.com/.default";
       const azureADTokenProvider = getBearerTokenProvider(credential, scope);
       const client = new AzureOpenAI({
         endpoint: endpoint,
         apiVersion: apiVersion,
         azureADTokenProvider,
       });
       return client;
   };

   const client = getClient();

   async function main(): Promise<void> {

       // Make the audio chat completions request
       const response = await client.chat.completions.create({ 
           model: "gpt-4o-mini-audio-preview", 
           modalities: ["text", "audio"], 
           audio: { voice: "alloy", format: "wav" }, 
           messages: [ 
           { 
               role: "user", 
               content: "Is a golden retriever a good family dog?" 
           } 
           ] 
       }); 

     // Inspect returned data 
     console.log(response.choices[0]); 

     // Write the output audio data to a file
     if (response.choices[0].message.audio) {
       writeFileSync( 
         "dog.wav", 
         Buffer.from(response.choices[0].message.audio.data, 'base64'), 
         { encoding: "utf-8" } 
       ); 
     } else {
       console.error("Audio data is null or undefined.");
     }
   }

   main().catch((err: Error) => {
     console.error("Error occurred:", err);
   });

   export { main };
   ```
2. Create the `tsconfig.json` file to transpile the TypeScript code and copy the following code for ECMAScript.

   ```json
   {
       "compilerOptions": {
         "module": "NodeNext",
         "target": "ES2022", // Supports top-level await
         "moduleResolution": "NodeNext",
         "skipLibCheck": true, // Avoid type errors from node_modules
         "strict": true // Enable strict type-checking options
       },
       "include": ["*.ts"]
   }
   ```
3. Transpile from TypeScript to JavaScript.

   ```shell
   tsc
   ```
4. Sign in to Azure with the following command:

   ```shell
   az login
   ```
5. Run the code with the following command:

   ```shell
   node to-audio.js
   ```

**[API key]**

1. Create the `to-audio.ts` file with the following code:

   ```typescript
   import { writeFileSync } from "node:fs";
   import { AzureOpenAI } from "openai/index.mjs";

   // Set environment variables or edit the corresponding values here.
   const endpoint: string = process.env.AZURE_OPENAI_ENDPOINT || "AZURE_OPENAI_ENDPOINT";
   const apiKey: string = process.env.AZURE_OPENAI_API_KEY || "AZURE_OPENAI_API_KEY";
   const apiVersion: string = "2025-01-01-preview"; 
   const deployment: string = "gpt-4o-mini-audio-preview"; 

   const client = new AzureOpenAI({ 
     endpoint, 
     apiKey, 
     apiVersion, 
     deployment 
   });  

   async function main(): Promise<void> {

       // Make the audio chat completions request
       const response = await client.chat.completions.create({ 
           model: "gpt-4o-mini-audio-preview", 
           modalities: ["text", "audio"], 
           audio: { voice: "alloy", format: "wav" }, 
           messages: [ 
           { 
               role: "user", 
               content: "Is a golden retriever a good family dog?" 
           } 
           ] 
       }); 

     // Inspect returned data 
     console.log(response.choices[0]); 

     // Write the output audio data to a file
     if (response.choices[0].message.audio) {
       writeFileSync( 
         "dog.wav", 
         Buffer.from(response.choices[0].message.audio.data, 'base64'), 
         { encoding: "utf-8" } 
       ); 
     } else {
       console.error("Audio data is null or undefined.");
     }
   }

   main().catch((err: Error) => {
     console.error("Error occurred:", err);
   });

   export { main };
   ```
2. Create the `tsconfig.json` file to transpile the TypeScript code and copy the following code for ECMAScript.

   ```json
   {
       "compilerOptions": {
         "module": "NodeNext",
         "target": "ES2022", // Supports top-level await
         "moduleResolution": "NodeNext",
         "skipLibCheck": true, // Avoid type errors from node_modules
         "strict": true // Enable strict type-checking options
       },
       "include": ["*.ts"]
   }
   ```
3. Transpile from TypeScript to JavaScript.

   ```shell
   tsc
   ```
4. Run the code with the following command:

   ```shell
   node to-audio.js
   ```

Wait a few moments to get the response.

### Output for audio generation from text input

The script generates an audio file named *dog.wav* in the same directory as the script. The audio file contains the spoken response to the prompt, "Is a golden retriever a good family dog?"

## Generate audio and text from audio input

**[Microsoft Entra ID]**

1. Create the `from-audio.ts` file with the following code:

   ```typescript
   import { AzureOpenAI } from "openai";
   import { writeFileSync } from "node:fs";
   import { promises as fs } from 'fs';
   import {
       DefaultAzureCredential,
       getBearerTokenProvider,
     } from "@azure/identity";

   // Set environment variables or edit the corresponding values here.
   const endpoint: string = process.env.AZURE_OPENAI_ENDPOINT || "AZURE_OPENAI_ENDPOINT";
   const apiVersion: string = "2025-01-01-preview"; 
   const deployment: string = "gpt-4o-mini-audio-preview"; 

   // Keyless authentication 
   const getClient = (): AzureOpenAI => {
       const credential = new DefaultAzureCredential();
       const scope = "https://ai.azure.com/.default";
       const azureADTokenProvider = getBearerTokenProvider(credential, scope);
       const client = new AzureOpenAI({
         endpoint: endpoint,
         apiVersion: apiVersion,
         azureADTokenProvider,
       });
       return client;
   };

   const client = getClient();

   async function main(): Promise<void> {

       // Buffer the audio for input to the chat completion
       const wavBuffer = await fs.readFile("dog.wav"); 
       const base64str = Buffer.from(wavBuffer).toString("base64"); 

       // Make the audio chat completions request
       const response = await client.chat.completions.create({ 
         model: "gpt-4o-mini-audio-preview",
         modalities: ["text", "audio"], 
         audio: { voice: "alloy", format: "wav" },
         messages: [ 
           { 
             role: "user", 
             content: [ 
               { 
                 type: "text", 
                 text: "Describe in detail the spoken audio input." 
               }, 
               { 
                 type: "input_audio", 
                 input_audio: { 
                   data: base64str, 
                   format: "wav" 
                 } 
               } 
             ] 
           } 
         ] 
       }); 

       console.log(response.choices[0]); 

       // Write the output audio data to a file
       if (response.choices[0].message.audio) {
           writeFileSync("analysis.wav", Buffer.from(response.choices[0].message.audio.data, 'base64'), { encoding: "utf-8" });
       }
       else {
           console.error("Audio data is null or undefined.");
     }
   }

   main().catch((err: Error) => {
     console.error("Error occurred:", err);
   });

   export { main };
   ```
2. Create the `tsconfig.json` file to transpile the TypeScript code and copy the following code for ECMAScript.

   ```json
   {
       "compilerOptions": {
         "module": "NodeNext",
         "target": "ES2022", // Supports top-level await
         "moduleResolution": "NodeNext",
         "skipLibCheck": true, // Avoid type errors from node_modules
         "strict": true // Enable strict type-checking options
       },
       "include": ["*.ts"]
   }
   ```
3. Transpile from TypeScript to JavaScript.

   ```shell
   tsc
   ```
4. Sign in to Azure with the following command:

   ```shell
   az login
   ```
5. Run the code with the following command:

   ```shell
   node from-audio.js
   ```

**[API key]**

1. Create the `from-audio.ts` file with the following code:

   ```typescript
   import { AzureOpenAI } from "openai";
   import { writeFileSync } from "node:fs";
   import { promises as fs } from 'fs';

   // Set environment variables or edit the corresponding values here.
   const endpoint: string = process.env.AZURE_OPENAI_ENDPOINT || "AZURE_OPENAI_ENDPOINT";
   const apiKey: string = process.env.AZURE_OPENAI_API_KEY || "AZURE_OPENAI_API_KEY";
   const apiVersion: string = "2025-01-01-preview"; 
   const deployment: string = "gpt-4o-mini-audio-preview"; 

   const client = new AzureOpenAI({ 
     endpoint, 
     apiKey, 
     apiVersion, 
     deployment 
   });  

   async function main(): Promise<void> {

     // Buffer the audio for input to the chat completion
     const wavBuffer = await fs.readFile("dog.wav"); 
     const base64str = Buffer.from(wavBuffer).toString("base64"); 

     // Make the audio chat completions request
     const response = await client.chat.completions.create({ 
       model: "gpt-4o-mini-audio-preview",
       modalities: ["text", "audio"], 
       audio: { voice: "alloy", format: "wav" },
       messages: [ 
         { 
           role: "user", 
           content: [ 
             { 
               type: "text", 
               text: "Describe in detail the spoken audio input." 
             }, 
             { 
               type: "input_audio", 
               input_audio: { 
                 data: base64str, 
                 format: "wav" 
               } 
             } 
           ] 
         } 
       ] 
     }); 

     console.log(response.choices[0]); 

     // Write the output audio data to a file
     if (response.choices[0].message.audio) {
         writeFileSync("analysis.wav", Buffer.from(response.choices[0].message.audio.data, 'base64'), { encoding: "utf-8" });
     }
     else {
         console.error("Audio data is null or undefined.");
   }
   }

   main().catch((err: Error) => {
   console.error("Error occurred:", err);
   });

   export { main };
   ```
2. Create the `tsconfig.json` file to transpile the TypeScript code and copy the following code for ECMAScript.

   ```json
   {
       "compilerOptions": {
         "module": "NodeNext",
         "target": "ES2022", // Supports top-level await
         "moduleResolution": "NodeNext",
         "skipLibCheck": true, // Avoid type errors from node_modules
         "strict": true // Enable strict type-checking options
       },
       "include": ["*.ts"]
   }
   ```
3. Transpile from TypeScript to JavaScript.

   ```shell
   tsc
   ```
4. Run the code with the following command:

   ```shell
   node from-audio.js
   ```

Wait a few moments to get the response.

### Output for audio and text generation from audio input

The script generates a transcript of the summary of the spoken audio input. It also generates an audio file named *analysis.wav* in the same directory as the script. The audio file contains the spoken response to the prompt.

## Generate audio and use multi-turn chat completions

**[Microsoft Entra ID]**

1. Create the `multi-turn.ts` file with the following code:

   ```typescript
   import { AzureOpenAI } from "openai/index.mjs";
   import { promises as fs } from 'fs';
   import { ChatCompletionMessageParam } from "openai/resources/index.mjs";
   import {
       DefaultAzureCredential,
       getBearerTokenProvider,
     } from "@azure/identity";

   // Set environment variables or edit the corresponding values here.
   const endpoint: string = process.env.AZURE_OPENAI_ENDPOINT || "AZURE_OPENAI_ENDPOINT";
   const apiVersion: string = "2025-01-01-preview"; 
   const deployment: string = "gpt-4o-mini-audio-preview"; 

   // Keyless authentication 
   const getClient = (): AzureOpenAI => {
       const credential = new DefaultAzureCredential();
       const scope = "https://ai.azure.com/.default";
       const azureADTokenProvider = getBearerTokenProvider(credential, scope);
       const client = new AzureOpenAI({
         endpoint: endpoint,
         apiVersion: apiVersion,
         azureADTokenProvider,
       });
       return client;
   };

   const client = getClient(); 

   async function main(): Promise<void> {

       // Buffer the audio for input to the chat completion
       const wavBuffer = await fs.readFile("dog.wav"); 
       const base64str = Buffer.from(wavBuffer).toString("base64"); 

       // Initialize messages with the first turn's user input 
       const messages: ChatCompletionMessageParam[] = [
         {
           role: "user",
           content: [
             { 
               type: "text", 
               text: "Describe in detail the spoken audio input." 
             },
             { 
               type: "input_audio", 
               input_audio: { 
                 data: base64str, 
                 format: "wav" 
               } 
             }
           ]
         }
       ];

       // Get the first turn's response 

       const response = await client.chat.completions.create({ 
           model: "gpt-4o-mini-audio-preview",
           modalities: ["text", "audio"], 
           audio: { voice: "alloy", format: "wav" }, 
           messages: messages
       }); 

       console.log(response.choices[0]); 

       // Add a history message referencing the previous turn's audio by ID 
       messages.push({ 
           role: "assistant", 
           audio: response.choices[0].message.audio ? { id: response.choices[0].message.audio.id } : undefined
       });

       // Add a new user message for the second turn
       messages.push({ 
           role: "user", 
           content: [ 
               { 
                 type: "text", 
                 text: "Very concisely summarize the favorability." 
               } 
           ] 
       }); 

       // Send the follow-up request with the accumulated messages
       const followResponse = await client.chat.completions.create({ 
           model: "gpt-4o-mini-audio-preview",
           messages: messages
       });

       console.log(followResponse.choices[0].message.content); 
   }

   main().catch((err: Error) => {
     console.error("Error occurred:", err);
   });

   export { main };
   ```
2. Create the `tsconfig.json` file to transpile the TypeScript code and copy the following code for ECMAScript.

   ```json
   {
       "compilerOptions": {
         "module": "NodeNext",
         "target": "ES2022", // Supports top-level await
         "moduleResolution": "NodeNext",
         "skipLibCheck": true, // Avoid type errors from node_modules
         "strict": true // Enable strict type-checking options
       },
       "include": ["*.ts"]
   }
   ```
3. Transpile from TypeScript to JavaScript.

   ```shell
   tsc
   ```
4. Sign in to Azure with the following command:

   ```shell
   az login
   ```
5. Run the code with the following command:

   ```shell
   node multi-turn.js
   ```

**[API key]**

1. Create the `multi-turn.ts` file with the following code:

   ```typescript
   import { AzureOpenAI } from "openai/index.mjs";
   import { promises as fs } from 'fs';
   import { ChatCompletionMessageParam } from "openai/resources/index.mjs";

   // Set environment variables or edit the corresponding values here.
   const endpoint: string = process.env.AZURE_OPENAI_ENDPOINT || "AZURE_OPENAI_ENDPOINT" as string;
   const apiKey: string = process.env.AZURE_OPENAI_API_KEY || "AZURE_OPENAI_API_KEY";
   const apiVersion: string = "2025-01-01-preview"; 
   const deployment: string = "gpt-4o-mini-audio-preview"; 

   const client = new AzureOpenAI({ 
     endpoint, 
     apiKey, 
     apiVersion, 
     deployment 
   });  

   async function main(): Promise<void> {

       // Buffer the audio for input to the chat completion
       const wavBuffer = await fs.readFile("dog.wav"); 
       const base64str = Buffer.from(wavBuffer).toString("base64"); 

       // Initialize messages with the first turn's user input 
       const messages: ChatCompletionMessageParam[] = [
         {
           role: "user",
           content: [
             { 
               type: "text", 
               text: "Describe in detail the spoken audio input." 
             },
             { 
               type: "input_audio", 
               input_audio: { 
                 data: base64str, 
                 format: "wav" 
               } 
             }
           ]
         }
       ];

       // Get the first turn's response 

       const response = await client.chat.completions.create({ 
         model: "gpt-4o-mini-audio-preview",
         modalities: ["text", "audio"], 
         audio: { voice: "alloy", format: "wav" }, 
         messages: messages
       }); 

       console.log(response.choices[0]); 

       // Add a history message referencing the previous turn's audio by ID 
       messages.push({ 
           role: "assistant", 
           audio: response.choices[0].message.audio ? { id: response.choices[0].message.audio.id } : undefined
       });

       // Add a new user message for the second turn
       messages.push({ 
           role: "user", 
           content: [ 
               { 
                 type: "text", 
                 text: "Very concisely summarize the favorability." 
               } 
           ] 
       }); 

       // Send the follow-up request with the accumulated messages
       const followResponse = await client.chat.completions.create({ 
           model: "gpt-4o-mini-audio-preview",
           messages: messages
       });

       console.log(followResponse.choices[0].message.content); 
   }

   main().catch((err: Error) => {
     console.error("Error occurred:", err);
   });

   export { main };
   ```
2. Create the `tsconfig.json` file to transpile the TypeScript code and copy the following code for ECMAScript.

   ```json
   {
       "compilerOptions": {
         "module": "NodeNext",
         "target": "ES2022", // Supports top-level await
         "moduleResolution": "NodeNext",
         "skipLibCheck": true, // Avoid type errors from node_modules
         "strict": true // Enable strict type-checking options
       },
       "include": ["*.ts"]
   }
   ```
3. Transpile from TypeScript to JavaScript.

   ```shell
   tsc
   ```
4. Run the code with the following command:

   ```shell
   node multi-turn.js
   ```

Wait a few moments to get the response.

### Output for multi-turn chat completions

The script generates a transcript of the summary of the spoken audio input. Then, it makes a multi-turn chat completion to briefly summarize the spoken audio input.

## Clean up resources

If you want to clean up and remove an Azure OpenAI resource, you can delete the resource. Before deleting the resource, you must first delete any deployed models.

- [Azure portal](https://learn.microsoft.com/en-us/azure/ai-services/multi-service-resource?pivots=azportal#clean-up-resources)
- [Azure CLI](https://learn.microsoft.com/en-us/azure/ai-services/multi-service-resource?pivots=azcli#clean-up-resources)

## Troubleshooting

> **Note**
>
> When using `gpt-4o-audio-preview` for chat completions with the audio modality and `stream` is set to true the only supported audio format is pcm16.

### Authentication errors

If you receive a 401 or 403 error:

- **Keyless auth:** Verify you've run `az login` and have the `Cognitive Services User` role assigned to your account.
- **API key:** Check that `AZURE_OPENAI_API_KEY` is set correctly and the key hasn't been regenerated.

### Model not found

If the `gpt-4o-mini-audio-preview` model isn't available:

- Verify the model is deployed in your Azure OpenAI resource.
- Check that you're using a [supported region](../06.1-explore-foundry-models/01-models-sold-directly-by-azure.md).

### Audio file issues

If the generated audio file doesn't play:

- Ensure the file was written completely (check file size is greater than 0 bytes).
- Verify the format matches what your player supports (wav is widely compatible).
- For streaming responses, remember that only pcm16 format is supported.

### Rate limiting

If you receive a 429 error, you've exceeded the rate limit. Wait and retry, or request a quota increase. For more information about rate limits, see [Azure OpenAI quotas and limits](../06.2-quota-limits-and-region-availability/06-quotas-limits.md).

## Related content

- Learn more about Azure OpenAI [deployment types](../06.3-offers-deployment-types-and-pricing/04-deployment-types.md).
- Learn more about Azure OpenAI [quotas and limits](../06.2-quota-limits-and-region-availability/06-quotas-limits.md).
