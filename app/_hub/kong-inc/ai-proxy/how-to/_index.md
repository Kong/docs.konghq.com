---
nav_title: Getting started with AI Proxy
title: Getting started with AI Proxy
---

## Initial Step

For all providers, the Kong AI Proxy plugin attaches to **route** entities.

It can be installed into one route per operation, for example:

* OpenAI "Chat" Route
* Cohere "Chat" Route
* Cohere "Completions" Route

Each of these AI-enabled routes must point to a "null" service. This service does not need to map to any real upstream URL,
it can point somewhere empty (for example on `http://localhost:32000`).

**This requirement will be removed in a later Kong revision.**

You should create this service **first** like in this example:

```bash
curl -X POST http://localhost:8001/services \
    --data "name=ai-proxy" \
    --data "url=http://localhost:32000"
```

## Provider Configuration

Now you can create a **route** and accompanying **AI-Proxy plugin** for your AI implementation.

{% navtabs %}
{% navtab OpenAI %}

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

Finally, make a `llm/v1/chat` type requeest to your new endpoint:

```bash
curl -X POST http://localhost:8000/openai-chat \
  -H 'Content-Type: application/json' \
  --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```

{% endnavtab %}
{% endnavtabs %}


Placeholder.
