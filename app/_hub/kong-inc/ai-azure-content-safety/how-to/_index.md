---
nav_title: Using the AI Azure Content Safety plugin
title: Using the AI Azure Content Safety plugin
---

## Overview

As a platform owner, you might need to moderate all user request content against a reputable service to comply with specific sensitive 
categories when using Kong to proxy your Large Language Model (LLM) traffic.

This plugin integrates with the [Azure REST API](https://azure-ai-content-safety-api-docs.developer.azure-api.net/api-details#api=content-safety-service-2023-10-01&operation=TextOperations_AnalyzeText) and transmits every user LLM request 
from users to the Azure Content Safety SaaS *before* proxying to the upstream LLM.

The plugin uses the [**text moderation**](https://learn.microsoft.com/en-us/azure/ai-services/content-safety/quickstart-text?tabs=visual-studio%2Cwindows&pivots=programming-language-rest) operation, and only supports REST API version **2023-10-01**.

To configure the plugin, you set an array of [categories and levels](https://learn.microsoft.com/en-us/azure/ai-services/content-safety/concepts/harm-categories).
If Azure finds that a piece of content has breached one or more of these levels, 
the request is stopped with a 400 status and reported to the Kong log file for auditing.

## Prerequisites

* An Azure subscription and a Content Safety instance. 
You can [follow the quickstart from Microsoft](https://learn.microsoft.com/en-us/azure/ai-services/content-safety/quickstart-text?tabs=visual-studio%2Cwindows&pivots=programming-language-rest#prerequisites) 
to get set up quickly.
* [Create a service, route, and `ai-proxy` plugin](/hub/kong-inc/ai-proxy/)
that will serve as your LLM access point.

## Authentication

In each instance of the plugin, it supports one of:

* Content Safety Key (static key generated from Azure Portal)
* Managed Identity Authentication

### Content Safety Key Auth

To use a content safety key, you must set the `config.content_safety_key` parameter.

### Managed Identity Auth

To use Managed Identity auth (e.g. Machine Identity on an Azure VM or AKS Pod), you must set `config.use_azure_managed_identity`
to `true`.

Following this, there are three more parameters that may or may not be required:

* `config.azure_client_id`
* `config.azure_client_secret`
* `config.azure_tenant_id`

The client ID is normally required when you want to use a different *user assigned identity* instead of the 
managed identity assigned to the resource on which Kong is running.

The client secret and tenant ID are usually only used when you are running Kong somewhere outside 
of Azure, but still want to use Entra ID (ADFS) to authenticate with Content Services.

See the [cloud provider authentication](/hub/kong-inc/ai-proxy/how-to/cloud-provider-authentication/) guide to learn more.

## Examples

Configure the plugin with an array of supported categories, as defined by Azure Content Safety:
* [Content Services REST API documentation](https://azure-ai-content-safety-api-docs.developer.azure-api.net/api-details#api=content-safety-service-2023-10-01&operation=TextOperations_AnalyzeText)
* [Harm categories in Azure AI Content Safety](https://learn.microsoft.com/en-us/azure/ai-services/content-safety/concepts/harm-categories)

Azure's harm categories map to `categories.name` in the plugin's configuration, and the severity levels map to `categories.rejection_level`. 

For example, here's what it looks like if you use all four
supported categories in this API version:

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/ai-azure-content-safety
name: ai-azure-content-safety
config:
  content_safety_url: "https://my-acs-instance.cognitiveservices.azure.com/contentsafety/text:analyze"
  use_azure_managed_identity: false
  content_safety_key: "{vault://env/AZURE_CONTENT_SAFETY_KEY}"
  categories:
    - name: Hate
      rejection_level: 2
    - name: SelfHarm
      rejection_level: 2
    - name: Sexual
      rejection_level: 2
    - name: Violence
      rejection_level: 2
  text_source: concatenate_user_content
  reveal_failure_reason: true
  output_type: FourSeverityLevels  # Supports FOUR or EIGHT level severity-grading
targets:
  - service
formats:
  - konnect
  - curl
  - yaml
  - kubernetes
  - terraform
{% endplugin_example %}
<!--vale on -->

Now, given the following AI Chat request:

```json
{
  "messages": [
    {
      "role": "system",
      "content": "You are a mathematician."
    },
    {
      "role": "user",
      "content": "What is 1 + 1?"
    },
    {
      "role": "assistant",
      "content": "The answer is 3."
    },
    {
      "role": "user",
      "content": "You lied, I hate you!"
    }
  ]
}
```

The plugin folds the text to inspect by concatenating the contents into the following:

```plaintext
You are a mathematician.; What is 1 + 1?; The answer is 3.; You lied, I hate you!
```

Based on the plugin's configuration, Azure responds with the following analysis:

```json
{
    "categoriesAnalysis": [
        {
            "category": "Hate",
            "severity": 2
        }
    ]
}
```

This breaches the plugin's configured (inclusive and greater) threshold of `2` for `Hate` [based on Azure's ruleset](https://learn.microsoft.com/en-us/azure/ai-services/content-safety/concepts/harm-categories?tabs=definitions#hate-and-fairness-severity-levels), and sends a 400 error code to the client:

```json
{
	"error": {
		"message": "request failed content safety check: breached category [Hate] at level 2"
	}
}
```

### Hiding the failure from the client

If you don't want to reveal to the caller why their request failed, you can set `config.reveal_failure_reason` to `false`, in which
case the response looks like this:

```json
{
	"error": {
		"message": "request failed content safety check"
	}
}
```

### Using blocklists

The plugin supports previously-created blocklists in Azure Content Safety.

Using the [Azure Content Safety API](https://learn.microsoft.com/en-us/azure/ai-services/content-safety/how-to/use-blocklist) 
or the Azure Portal, you can create a series of blocklists for banned phrases or patterns. 
You can then reference their unique names in the plugin configuration. 

In the following example, the plugin takes two existing blocklists from Azure, `company_competitors` and 
`financial_properties`:

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/ai-azure-content-safety
name: ai-azure-content-safety
config:
  content_safety_url: "https://my-acs-instance.cognitiveservices.azure.com/contentsafety/text:analyze"
  use_azure_managed_identity: false
  content_safety_key: "{vault://env/AZURE_CONTENT_SAFETY_KEY}"
  categories:
    - name: Hate
      rejection_level: 2
  blocklist_names:
    - company_competitors
    - financial_properties
  halt_on_blocklist_hit: true
  text_source: concatenate_user_content
  reveal_failure_reason: true
  output_type: FourSeverityLevels  # Supports FOUR or EIGHT level severity-grading
targets:
  - service
formats:
  - konnect
  - curl
  - yaml
  - kubernetes
  - terraform
{% endplugin_example %}
<!--vale on -->

{{site.base_gateway}} will then command Content Safety to enable and execute these blocklists against the content. The plugin property `config.halt_on_blocklist_hit` is
used to tell Content Safety to stop analyzing the content as soon as any blocklist hit matches. This can save analysis costs, at the expense of accuracy
in the response: for example, if it also fails the Hate category, this will not be reported.
