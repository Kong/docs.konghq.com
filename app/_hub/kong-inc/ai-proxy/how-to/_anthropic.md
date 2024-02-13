---
nav_title: Anthropic
title: Set up AI Proxy with Anthropic
---

Set up the AI Proxy plugin to use [Anthropic](https://www.anthropic.com/).

## Prerequisites

{% include_cached /md/plugins-hub/ai-providers-prereqs.md %}

* You have an Anthropic account and subscription

Now you can create a **route** and accompanying **AI Proxy plugin** for your AI provider.

## Provider configuration

After creating an Anthropic account, and purchasing a subscription, you can then create an
AI Proxy route and plugin configuration (based off this configuration YAML):

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
          top_p: 256
          top_k: 0.5
```

### Plugin Installation

Create the resources:

```bash
curl -X POST http://localhost:8001/services/ai-proxy/routes \
    --data "name=anthropic-chat" \
    --data "paths[]=~/anthropic-chat$"
```

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
    --data "config.model.options.top_p=256" \
    --data "config.model.options.top_k=0.5"
```

### Test

Finally, make an `llm/v1/chat` type request to your new endpoint:

```bash
curl -X POST http://localhost:8000/anthropic-chat \
  -H 'Content-Type: application/json' \
  --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```
