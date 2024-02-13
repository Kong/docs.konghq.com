---
nav_title: Cohere
title: Set up AI Proxy with Cohere
---

Set up the AI Proxy plugin to use [Cohere](https://cohere.com/).

## Prerequisites

{% include_cached /md/plugins-hub/ai-providers-prereqs.md %}

* You have a Cohere account and subscription

Now you can create a **route** and accompanying **AI Proxy plugin** for your AI provider.

## Provider configuration

After creating a Cohere account, and purchasing a subscription, you can then create an
AI Proxy route and plugin configuration (based off this configuration YAML):

```yaml
name: cohere-chat
paths:
  - "~/cohere-chat$"
methods:
  - POST
plugins:
  - name: ai-proxy
    config:
      route_type: "llm/v1/chat"
      auth:
        header_name: "Authorization"
        header_value: "Bearer <cohere_key>"  # add your own Cohere API key
      model:
        provider: "cohere"
        name: "command"
        options:
          max_tokens: 512
          temperature: 1.0
```

### Plugin Installation

Create the resources:

```bash
curl -X POST http://localhost:8001/services/ai-proxy/routes \
    --data "name=cohere-chat" \
    --data "paths[]=~/cohere-chat$"
```

```bash
curl -X POST http://localhost:8001/routes/cohere-chat/plugins \
    --data "name=ai-proxy" \
    --data "config.route_type=llm/v1/chat" \
    --data "config.auth.header_name=Authorization" \
    --data "config.auth.header_value=Bearer <cohere_key>" \
    --data "config.model.provider=cohere" \
    --data "config.model.name=command" \
    --data "config.model.options.max_tokens=512" \
    --data "config.model.options.temperature=1.0"
```

### Test

Finally, make an `llm/v1/chat` type request to your new endpoint:

```bash
curl -X POST http://localhost:8000/cohere-chat \
  -H 'Content-Type: application/json' \
  --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```
