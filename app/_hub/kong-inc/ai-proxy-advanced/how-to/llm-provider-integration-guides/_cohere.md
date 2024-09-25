---
nav_title: Cohere
title: Set up AI Proxy Advanced with Cohere
---

This guide walks you through setting up the AI Proxy Advanced plugin with [Cohere](https://cohere.com/).

{% include_cached /md/plugins-hub/ai-providers-prereqs-advanced.md snippet='intro' %}

## Prerequisites

{% include_cached /md/plugins-hub/ai-providers-prereqs-advanced.md snippet='service' provider='Cohere' %}

## Provider configuration

After creating a Cohere account and purchasing a subscription, you can then create an
AI Proxy Advanced route and plugin configuration.

### Set up route and plugin

Create the route:

```bash
curl -X POST http://localhost:8001/services/ai-proxy-advanced/routes \
  --data "name=cohere-chat" \
  --data "paths[]=~/cohere-chat$"
```

Enable and configure the AI Proxy Advanced plugin for Cohere, replacing the `<cohere_key>` with your own API key:

<!--vale off-->
{% plugin_example %}
plugin: kong-inc/ai-proxy-advanced
name: ai-proxy-advanced
config:
  targets:
  - route_type: "llm/v1/chat"
    auth:
      header_name: "Authorization"
      header_value: "Bearer <cohere_key>"
    model:
      provider: cohere
      name: "command"
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
curl -X POST http://localhost:8000/cohere-chat \
  -H 'Content-Type: application/json' \
  --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```
