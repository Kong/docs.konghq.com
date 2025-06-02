---
nav_title: Hugging Face
title: Set up AI Proxy with Hugging Face
minimum_version: 3.9.x
---

This guide walks you through setting up the AI Proxy plugin with [Hugging Face](https://huggingface.co/).

{% include_cached /md/plugins-hub/ai-providers-prereqs.md snippet='intro' %}

## Prerequisites

{% include_cached /md/plugins-hub/ai-providers-prereqs.md snippet='service' provider='Hugging Face' %}
* Hugging Face access token with permissions to make calls to the Inference API
* [Text-generation model](https://huggingface.co/models?pipeline_tag=text-generation&sort=trending) from Hugging Face

## Provider configuration

### Set up route and plugin

{% navtabs %}
{% navtab Kong Admin API %}

Create the route:

```bash
curl -X POST http://localhost:8001/services/ai-proxy/routes \
  --data "name=huggingface-chat" \
  --data "paths[]=~/huggingface-chat$"
```

Enable and configure the AI Proxy plugin for Hugging Face, replacing the `<huggingface_token>` with your access token and `<huggingface_model>` with the name of the model to use:

```bash
curl -X POST http://localhost:8001/routes/huggingface-chat/plugins \
  --data "name=ai-proxy" \
  --data "config.route_type=llm/v1/chat" \
  --data "config.auth.header_name=Authorization" \
  --data "config.auth.header_value= Bearer <huggingface_token>" \ 
  --data "config.model.provider=huggingface" \
  --data "config.model.name=<huggingface_model>" \
  --data "config.model.options.max_tokens=512" \
  --data "config.model.options.temperature=1.0" \
  --data "config.model.options.top_p=0.5" \
  --data "config.model.options.top_k=256"
```

{% endnavtab %}
{% navtab YAML %}
```yaml
routes:
- name: huggingface-chat
  service:
    name: ai-proxy
  paths:
    - "~/huggingface-chat$"
  methods:
    - POST
plugins:
  - name: ai-proxy
    config:
      route_type: "llm/v1/chat"
      auth:
        header_name: "Authorization"
        header_value: "Bearer <huggingface_token>"  # add your Hugging Face access token
      model:
        provider: "huggingface"
        name: "<huggingface_model>" # add the Hugging Face model to use
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
curl -X POST http://localhost:8000/huggingface-chat \
  -H 'Content-Type: application/json' \
  --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```
