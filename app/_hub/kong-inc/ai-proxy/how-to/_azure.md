---
nav_title: Azure
title: Set up AI Proxy with Azure OpenAI Service
---

Set up the AI Proxy plugin with the [Azure OpenAI Service](https://azure.microsoft.com/en-us/products/ai-services/openai-service).

## Prerequisites

{% include_cached /md/plugins-hub/ai-providers-prereqs.md %}

* You have an Anthropic account and subscription

Now you can create a **route** and accompanying **AI Proxy plugin** for your AI provider.

## Provider configuration

### Create or locate OpenAI instance

Log in to your Azure Subscription, and (if necessary) create your OpenAI instance. Record its name as your **"azure_instance"**.
Also record one of the access keys as its **"header_value"**:

![Azure setup 1](/assets/images/products/plugins/ai-proxy/ai-proxy-azure-1.png)

### Create / Locate Model Deployment

Once it has instantiated, create (if necessary) a model deployment in this instance. Record its name as your **"azure_deployment_id"**:

![Azure setup 2](/assets/images/products/plugins/ai-proxy/ai-proxy-azure-2.png)

Now you can create an AI Proxy route and plugin configuration (based off this configuration YAML):

```yaml
name: azure-chat
paths:
  - "~/azure-chat$"
methods:
  - POST
plugins:
  - name: ai-proxy
    config:
      route_type: "llm/v1/chat"
      auth:
        header_name: "api-key"
        header_value: "<azure_ai_access_key>"  # add your own 'Azure OpenAI' access key
      model:
        provider: "azure"
        name: "gpt-35-turbo"
        options:
          azure_instance: "ai-proxy-regression"
          azure_deployment_id: "kong-gpt-3-5"
```

### Plugin installation

Create the resources:

```bash
curl -X POST http://localhost:8001/services/ai-proxy/routes \
    --data "name=azure-chat" \
    --data "paths[]=~/azure-chat$"
```

```bash
curl -X POST http://localhost:8001/routes/azure-chat/plugins \
    --data "name=ai-proxy" \
    --data "config.route_type=llm/v1/chat" \
    --data "config.auth.header_name=api-key" \
    --data "config.auth.header_value=<azure_ai_access_key>" \
    --data "config.model.provider=azure" \
    --data "config.model.name=gpt-35-turbo" \
    --data "config.model.options.azure_instance=ai-proxy-regression" \
    --data "config.model.options.azure_deployment_id=kong-gpt-3-5"
```

### Test

Finally, make an `llm/v1/chat` type request to your new endpoint:

```bash
curl -X POST http://localhost:8000/azure-chat \
  -H 'Content-Type: application/json' \
  --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```
