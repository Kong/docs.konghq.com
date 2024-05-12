---
nav_title: Using the AI Azure Content Safety plugin
title: Using the AI Azure Content Safety plugin
---

## Overview

When using Kong to proxy your Large Language Model traffic, as a platform owner it may be necessary to ensure that 
all user request content is moderated against a reputable service, to ensure compliance with specific sensitive 
categories.

This plugin integrates with the [Azure REST API](https://westus.dev.cognitive.microsoft.com/docs/services/content-safety-service-2023-04-30-preview/operations/TextOperations_Analyze) and transmits every user LLM request 
from users to the Azure Content Safety SaaS **before** proxying to the upstream LLM.

It currently uses the [**text moderation**](https://learn.microsoft.com/en-us/azure/ai-services/content-safety/quickstart-text?tabs=visual-studio%2Cwindows&pivots=programming-language-rest) operation.

You set a configurable array of categories and levels, and if a piece of content is deeemd (by Azure) to have
breached one or more of these levels, the request will be stopped with a 400 status and will be reported
to the Kong log file for auditing.

## Prerequisites

You will need an Azure subscription and a Content Safety instance. You can [follow the quickstart from Microsoft](https://learn.microsoft.com/en-us/azure/ai-services/content-safety/quickstart-text?tabs=visual-studio%2Cwindows&pivots=programming-language-rest#prerequisites) 
to get set-up quickly.

Then, as in the [AI Proxy](/hub/kong-inc/ai-proxy/) documentation, create a service, route, and `ai-proxy` plugin
that will serve as your LLM access point.

## Examples

You can configure the plugin with an array of supported categories as defined by the Azure SaaS itself:

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/ai-azure-content-safety
name: ai-azure-content-safety
config:
  content_safety_url: "https://my-acs-instance.cognitiveservices.azure.com/contentsafety/text:analyze"
  use_azure_managed_identity: false
  reveal_failure_reason: true
  content_safety_key: "{vault://env/AZURE_CONTENT_SAFETY_KEY}"
  categories:
    - name: "Hate"
      rejection_level: 2
    - name: "Violence"
      rejection_level: 2
targets:
  - service
formats:
  - konnect
  - curl
  - yaml
  - kubernetes
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

The plugin forms the "text" to inspect by concatenating the contents into the following:

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

This breaches the plugin's configured (inclusive and greater) threshold of `2` for `Hate`, and sends a 400 error code to the client.

