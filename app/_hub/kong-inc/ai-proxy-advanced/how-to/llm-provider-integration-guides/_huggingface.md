---
nav_title: Hugging Face
title: Set up AI Proxy Advanced with Hugging Face
minimum_version: 3.9.x
---

This guide walks you through setting up the AI Proxy plugin with [Hugging Face](https://huggingface.co/).

{% include_cached /md/plugins-hub/ai-providers-prereqs-advanced.md snippet='intro' %}

## Prerequisites

{% include_cached /md/plugins-hub/ai-providers-prereqs-advanced.md snippet='service' provider='Hugging Face' %}
* Hugging Face access token with permissions to make calls to the Inference API
* [Text-generation model](https://huggingface.co/models?pipeline_tag=text-generation&sort=trending) from Hugging Face

## Provider configuration

### Set up route and plugin

Create the route:

```bash
curl -X POST http://localhost:8001/services/ai-proxy-advanced/routes \
  --data "name=huggingface-chat" \
  --data "paths[]=~/huggingface-chat$"
```

Enable and configure the AI Proxy Advanced plugin for Hugging Face, replacing the `<huggingface_token>` with your own access token and `<huggingface_model>` with the name of the model to use.

<!--vale off-->
{% plugin_example %}
plugin: kong-inc/ai-proxy-advanced
name: ai-proxy-advanced
config:
  targets:
  - route_type: "llm/v1/chat"
    auth:
      header_name: Authorization
      header_value: "Bearer <huggingface_token>"
    model:
      provider: huggingface
      name: <huggingface_model>
      options:
        max_tokens: 512
        temperature: 1.0
        top_p: 0.5
        top_k: 256
targets:
  - route
formats:
  - curl
  - konnect
  - yaml
  - kubernetes
  - terraform
{% endplugin_example %}
<!--vale on-->

### Test the configuration

Make an `llm/v1/chat` type request to test your new endpoint:

```bash
curl -X POST http://localhost:8000/huggingface-chat \
  -H 'Content-Type: application/json' \
  --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```
