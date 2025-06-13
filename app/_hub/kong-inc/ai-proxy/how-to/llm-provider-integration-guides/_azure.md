---
nav_title: Azure
title: Set up AI Proxy with Azure OpenAI Service
---

This guide walks you through setting up the AI Proxy plugin with [Azure OpenAI Service](https://azure.microsoft.com/en-us/products/ai-services/openai-service).

{% include_cached /md/plugins-hub/ai-providers-prereqs.md snippet='intro' %}

## Prerequisites

{% include_cached /md/plugins-hub/ai-providers-prereqs.md snippet='service' provider='Azure OpenAI Service' %}

## Provider configuration

### Create or locate OpenAI instance

Log in to your Azure account, and (if necessary) create an OpenAI instance with the following values: 

* Name: `azure_instance`
* Access key as the `header_value`


### Create or locate model deployment

Once it has instantiated, create (if necessary) a model deployment in this instance. 
Record its name as your `azure_deployment_id`:

### Set up route and plugin

Now you can create an AI Proxy route and plugin configuration:

{% navtabs %}
{% navtab Kong Admin API %}

Create the route:

```bash
curl -X POST http://localhost:8001/services/ai-proxy/routes \
  --data "name=azure-chat" \
  --data "paths[]=~/azure-chat$"
```

Enable and configure the AI Proxy plugin for Azure, replacing the `<azure_ai_access_key>` with your own API key:

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

{% endnavtab %}
{% navtab YAML %}
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
{% endnavtab %}
{% endnavtabs %}

### Test the configuration

Make an `llm/v1/chat` type request to test your new endpoint:

```bash
curl -X POST http://localhost:8000/azure-chat \
  -H 'Content-Type: application/json' \
  --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```
{% include_cached /md/plugins-hub/ai-custom-model.md %}