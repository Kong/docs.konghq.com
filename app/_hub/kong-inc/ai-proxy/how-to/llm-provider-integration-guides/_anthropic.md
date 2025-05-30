---
nav_title: Anthropic
title: Set up AI Proxy with Anthropic
---

This guide walks you through setting up the AI Proxy plugin with [Anthropic](https://www.anthropic.com/).

{% include_cached /md/plugins-hub/ai-providers-prereqs.md snippet='intro' %}

## Prerequisites

{% include_cached /md/plugins-hub/ai-providers-prereqs.md snippet='service' provider='Anthropic' %}

## Provider configuration

After creating an Anthropic account and purchasing a subscription, you can then create an
AI Proxy route and plugin configuration.

### Set up route and plugin

{% navtabs %}
{% navtab Kong Admin API %}

Create the route:

```bash
curl -X POST http://localhost:8001/services/ai-proxy/routes \
  --data "name=anthropic-chat" \
  --data "paths[]=~/anthropic-chat$"
```

Enable and configure the AI Proxy plugin for Anthropic, replacing the `<anthropic_key>` with your own API key:

```bash
curl -X POST http://localhost:8001/routes/anthropic-chat/plugins \
  --data "name=ai-proxy" \
  --data "config.route_type=llm/v1/chat" \
  --data "config.auth.header_name=apikey" \
  --data "config.auth.header_value=<anthropic_key>" \ 
  --data "config.model.provider=anthropic" \
  --data "config.model.name=claude-2.1" \
  --data "config.model.options.max_tokens=512" \
  --data "config.model.options.temperature=1.0" \
  --data "config.model.options.top_p=0.5" \
  --data "config.model.options.top_k=256"
```

{% endnavtab %}
{% navtab YAML %}
```yaml
name: anthropic-chat
paths:
  - "~/anthropic-chat$"
methods:
  - POST
plugins:
  - name: ai-proxy
    config:
      route_type: "llm/v1/chat"
      auth:
        header_name: "apikey"
        header_value: "<anthropic_key>"  # add your own Anthropic API key
      model:
        provider: "anthropic"
        name: "claude-2.1"
        options:
          max_tokens: 512
          temperature: 1.0
          top_p: 0.5
          top_k: 256
```

{% endnavtab %}
{% endnavtabs %}

### Test the configuration

Make an `llm/v1/chat` type request to test your new endpoint:

```bash
curl -X POST http://localhost:8000/anthropic-chat \
  -H 'Content-Type: application/json' \
  --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```
