---
nav_title: OpenAI
title: Set up AI Proxy with OpenAI
---

Set up the AI Proxy plugin to use [OpenAI](https://openai.com/).

## Prerequisites

{% include_cached /md/plugins-hub/ai-providers-prereqs.md %}

Now you can create a **route** and accompanying **AI Proxy plugin** for your AI provider.

## Provider configuration

After creating an OpenAI account, and purchasing a subscription, you can then create an
AI Proxy route and plugin configuration (based off this configuration YAML):

```yaml
name: openai-chat
paths:
  - "~/openai-chat$"
methods:
  - POST
plugins:
  - name: ai-proxy
    config:
      route_type: "llm/v1/chat"
      auth:
        header_name: "Authorization"
        header_value: "Bearer <openai_key>"  # add your own OpenAI API key
      model:
        provider: "openai"
        name: "gpt-4"
        options:
          max_tokens: 512
          temperature: 1.0
```

### Plugin Installation

Create the resources:

```bash
curl -X POST http://localhost:8001/services/ai-proxy/routes \
    --data "name=openai-chat" \
    --data "paths[]=~/openai-chat$"
```

```bash
curl -X POST http://localhost:8001/routes/openai-chat/plugins \
    --data "name=ai-proxy" \
    --data "config.route_type=llm/v1/chat" \
    --data "config.auth.header_name=Authorization" \
    --data "config.auth.header_value=Bearer <openai_key>" \
    --data "config.model.provider=openai" \
    --data "config.model.name=gpt-4" \
    --data "config.model.options.max_tokens=512" \
    --data "config.model.options.temperature=1.0"
```

### Test

Finally, make an `llm/v1/chat` type request to your new endpoint:

```bash
curl -X POST http://localhost:8000/openai-chat \
  -H 'Content-Type: application/json' \
  --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```