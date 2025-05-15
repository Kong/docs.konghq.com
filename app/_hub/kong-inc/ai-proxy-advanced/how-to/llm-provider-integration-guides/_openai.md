---
nav_title: OpenAI
title: Set up AI Proxy Advanced with OpenAI
---

This guide walks you through setting up the AI Proxy Advanced plugin with [OpenAI](https://openai.com/).

{% include_cached /md/plugins-hub/ai-providers-prereqs-advanced.md snippet='intro' %}

## Prerequisites

{% include_cached /md/plugins-hub/ai-providers-prereqs-advanced.md snippet='service' provider='OpenAI' %}

## Provider configuration

### Set up route and plugin

After creating an OpenAI account, and purchasing a subscription, you can then create an
AI Proxy Advanced route and plugin configuration.

Create a route:

```bash
curl -X POST http://localhost:8001/services/ai-proxy/routes \
  --data "name=openai-chat" \
  --data "paths[]=~/openai-chat$"
```

Enable and configure the AI Proxy plugin for OpenAI, replacing the `<openai_key>` with your own API key.

<!--vale off-->
{% plugin_example %}
plugin: kong-inc/ai-proxy-advanced
name: ai-proxy-advanced
config:
  targets:
  - route_type: "llm/v1/chat"
    auth:
      header_name: "Authorization"
      header_value: "Bearer <openai_key>"
    model:
      provider: openai
      name: "gpt-4"
      options:
        max_tokens: 512
        temperature: 1.0
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
curl -X POST http://localhost:8000/openai-chat \
  -H 'Content-Type: application/json' \
  --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```
{% include_cached /md/plugins-hub/ai-custom-model-advanced.md %}