using './main.bicep'

param environmentName = 'dev'
param environmentType = 'dev'

// Set by the workflow from the AZURE_LOCATION repository variable.
param location = readEnvironmentVariable('AZURE_LOCATION', '')

// Set by the workflow from the APIM_PUBLISHER_EMAIL repository variable, or locally.
param apimPublisherEmail = readEnvironmentVariable('APIM_PUBLISHER_EMAIL', '')

param deployerPrincipalId = readEnvironmentVariable('AZURE_PRINCIPAL_ID', '')
param allowedIpAddresses = []
param enableAsyncJobs = false
param enableExternalProvider = false

// Replace every <...> placeholder with a verified value from the Foundry model catalog
// for your region before deploying. The workflow refuses to deploy while placeholders remain.
param modelDeployments = [
  {
    name: 'img-draft-gpt-image-1-mini'
    model: 'gpt-image-1-mini'
    format: 'OpenAI'
    version: '<pinned-version>'
    skuName: 'GlobalStandard'
    capacity: 1
  }
  {
    name: 'img-std-gpt-image-2-5-flare'
    model: 'gpt-image-2.5-flare'
    format: 'OpenAI'
    version: '<pinned-version>'
    skuName: 'GlobalStandard'
    capacity: 1
  }
  {
    name: 'llm-agents'
    model: '<reasoning-and-vision-model>'
    format: 'OpenAI'
    version: '<pinned-version>'
    skuName: 'GlobalStandard'
    capacity: 50
  }
]
