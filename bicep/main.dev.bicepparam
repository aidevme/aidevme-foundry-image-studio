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

// Model names, versions, and SKUs were read from the Foundry model catalog for
// swedencentral on 2026-09-29 (az cognitiveservices model list). Re-check them before
// changing the region or upgrading a version. Do not leave <...> placeholders: the
// workflow refuses to deploy while any remain.
param modelDeployments = [
  {
    name: 'img-draft-gpt-image-1-mini'
    model: 'gpt-image-1-mini'
    format: 'OpenAI'
    version: '2025-10-06'
    skuName: 'GlobalStandard'
    capacity: 1
  }
  {
    name: 'img-std-gpt-image-2-5-flare'
    model: 'gpt-image-2.5-flare'
    format: 'OpenAI'
    version: '2026-09-08'
    skuName: 'GlobalStandard'
    capacity: 1
  }
  {
    name: 'llm-agents'
    model: 'gpt-5.4'
    format: 'OpenAI'
    version: '2026-03-05'
    skuName: 'GlobalStandard'
    capacity: 50
  }
]
