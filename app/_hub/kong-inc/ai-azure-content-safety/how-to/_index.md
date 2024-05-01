---
nav_title: Using the AI Azure Content Safety plugin
title: Using the AI Azure Content Safety plugin
---

## Overview

TO DO

## Prerequisites

First, as in the [AI Proxy](/hub/kong-inc/ai-proxy/) documentation, create a service, route, and `ai-proxy` plugin
that will serve as your LLM access point.

## Examples

You can configure the plugin with an array of supported categories as defined by the Azure SaaS itself:

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/ai-azure-content-safety
name: ai-azure-content-safety
config:
  content_safety_url: "https://ai-regression-content-safety.cognitiveservices.azure.com/contentsafety/text:analyze"
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

