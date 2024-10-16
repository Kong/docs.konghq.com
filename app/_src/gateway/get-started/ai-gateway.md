---
title: Get started with AI Gateway
content-type: tutorial
---

With Kong's AI Gateway, you can deploy AI infrastructure for traffic 
being sent to one or more LLMs, which lets you semantically route, secure, observe, accelerate, 
and govern using a special set of AI plugins that are bundled with {{site.base_gateway}} distributions.

Kong AI Gateway is a set of [AI plugins](/hub/?category=ai), which can be used by
installing {{site.base_gateway}} and then by following the documented configuration instructions for each plugin. 
The AI plugins are supported in all deployment modes, 
including {{site.konnect_short_name}}, self-hosted traditional, hybrid, and DB-less, and on Kubernetes via the 
[{{site.kic_product_name}}](/kubernetes-ingress-controller/latest/).

AI plugins are fully supported by {{site.konnect_short_name}} in both hybrid mode, 
and as a [fully managed service](/konnect/gateway-manager/dedicated-cloud-gateways).

You can enable most {{site.base_gateway}} AI capabilities with one of the following plugins:
* [AI Proxy](/hub/kong-inc/ai-proxy/): The open source AI proxy plugin.
* [AI Proxy Advanced](/hub/kong-inc/ai-proxy-advanced/): 
The enterprise version offering more advanced load balancing, routing, and retries. 

These plugins enable upstream connectivity to the LLMs and direct {{site.base_gateway}} to proxy
traffic to the intended LLM models. 
Once these plugins are installed and your AI traffic is being proxied, you can use any 
other {{site.base_gateway}} plugin to add more enhanced capabilities.


The main difference between simply adding an LLM's API behind {{site.base_gateway}} 
and using the AI plugins, is that with the former, you can only interact at the API 
level with internal traffic. With AI plugins, Kong can understand the prompts that are 
being sent through the Gateway. The plugins can introspect the body and provide more specific AI capabilities 
to your traffic, beyond treating the LLMs as "just APIs".

## Prerequisites

Run {{site.base_gateway}} in {{site.konnect_short_name}}, or use your distribution of choice:
* The easiest way to get started is to [run {{site.base_gateway}} for free on {{site.konnect_short_name}}](/konnect/getting-started/)
* To run {{site.base_gateway}} locally, use the [quickstart script](/gateway/{{page.release}}/get-started/), or 
[see all installation options](/gateway/{{page.release}}/install/)

## Set up AI Gateway

### 1. Create an ingress route

Create a [service and a route](/gateway/{{page.release}}/get-started/services-and-routes/) 
to define the ingress route to consume your LLMs.

{% navtabs %}
{% navtab Kong Gateway Admin API %}

Create a Gateway service:
```sh
curl -i -s -X POST http://localhost:8001/services \
  --data name="llm_service" \
  --data url="http://fake.host.internal"
```

Then, create a route for the service:
```sh
curl -i -s -X POST http://localhost:8001/services/llm_service/routes \
  --data name="openai-llm" \
  --data paths="/openai"
```
{% endnavtab %}
{% navtab Konnect API %}

Create a Gateway service:
```sh
curl -X POST \
https://{us|eu}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/services/ \
  --header "accept: application/json" \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer TOKEN" \
  --data '
    {
      "name": "llm_service",
      "url": "http://fake.host.internal"
    }
```

Then, create a route for the service:
```sh
curl -X POST \
https://{us|eu}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/services/{serviceID}/routes \
  --header "accept: application/json" \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer TOKEN" \
  --data  '
    {
      "name": "openai-llm",
      "paths": [
        {
          "/openai"
        }
      ]
    }
```

Take note of the route ID in the response.

{% endnavtab %}
{% endnavtabs %}

Adding this route entity creates an ingress rule on the `/openai` path. 

{:.note}
> These examples use the fake URL `http://fake.host.internal` as the upstream URL for the service - but you don't need to replace it with a real one.
This is because the service upstream URL won't really matter, because after installing the AI Proxy plugin (or AI Proxy Advanced), 
the upstream proxying destination will be determined dynamically based on your AI Proxy plugin configuration.

### 2. Install the AI Proxy plugin

Configure your destination LLM using either AI Proxy or AI Proxy Advanced so that all traffic 
sent to your route is redirected to the correct LLM.

This example uses the AI Proxy plugin.

{% navtabs %}
{% navtab Kong Gateway Admin API %}
```sh
curl -X POST http://localhost:8001/routes/openai-llm/plugins \
  --header "accept: application/json" \
  --header "Content-Type: application/json" \
  --data '
  {
    "name": "ai-proxy",
    "config": {
      "route_type": "llm/v1/chat",
      "model": {
        "provider": "openai"
      }
    }
  }'
```
{% endnavtab %}
{% navtab Konnect API %}

Replace `{route_id}` with the ID of the route created in the previous step:

```sh
curl -X POST \
https://{us|eu}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/routes/{routeId}/plugins \
  --header "accept: application/json" \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer TOKEN" \
  --data '
  {
    "name": "ai-proxy",
    "config": {
      "route_type": "llm/v1/chat",
      "model": {
        "provider": "openai"
      }
    }
  }'
```
{% endnavtab %}
{% endnavtabs %}

In this simple example, we are allowing the client to consume all models in the `openai` provider.
You can restrict the models that can be consumed by specifying the model name explicitly using 
the `config.model.name` parameter, 
and manage the LLM credentials in {{site.base_gateway}} itself so that the client doesn't have to send them. 

### 3. Validate the connection to the LLM

Make your first request to OpenAI via {{site.base_gateway}}:

```sh
curl --http1.1 http://localhost:8000/openai \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
     "model": "gpt-4o-mini",
     "messages": [{"role": "user", "content": "Say this is a test!"}]
   }'
```

The response body should contain the response `This is a test!`:

```json
{
  "id": "chatcmpl-AIm1TMhTkcH1sf67GYXIM5fsfu94X9Gdk",
  "object": "chat.completion",
  "created": 1729037867,
  "model": "gpt-4o-mini-2024-07-18",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "This is a test! How can I assist you today?",
        "refusal": null
      },
      "logprobs": null,
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 13,
    "completion_tokens": 12,
    "total_tokens": 25,
    "prompt_tokens_details": {
      "cached_tokens": 0
    },
    "completion_tokens_details": {
      "reasoning_tokens": 0
    }
  },
  "system_fingerprint": "fp_r0bdr52e6e"
}
```

Now, your traffic is being properly proxied to OpenAI via {{site.base_gateway}} and the AI Proxy plugin.

## Installing other AI plugins

The AI Proxy and AI Proxy Advanced plugins are able to understand the incoming OpenAI protocol.
This allows you to:

* Route to [all supported LLMs](/hub/kong-inc/ai-proxy-advanced/), 
even the ones that don't natively support the OpenAI specification, as Kong will automatically transform the request. 
Write once, and use all LLMs.
* Extract [observability metrics for AI](/gateway/latest/production/monitoring/ai-metrics/).
* Cache traffic using the [AI Semantic cache plugin](/hub/kong-inc/ai-semantic-cache/) plugin.
* Secure traffic with the [AI Prompt Guard](/hub/kong-inc/ai-prompt-guard/) and 
[AI Semantic Prompt Guard](/hub/kong-inc/ai-semantic-prompt-guard/) plugins.
* Provide prompt templates with [AI Prompt template](/hub/kong-inc/ai-prompt-template/).
* Programmatically inject system or assistant prompts to all incoming prompts with the 
[AI Prompt Decorator](/hub/kong-inc/ai-prompt-decorator/).

See all the [AI plugins](/hub/?category=ai) for more capabilities.

For example, you can rate limit AI traffic based on the number of tokens that are being sent 
(as opposed to the number of API requests) using the [AI Rate Limiting Advanced](/hub/kong-inc/ai-rate-limiting-advanced/) plugin:

```sh
curl -X POST http://localhost:8001/services/llm_service/plugins \
    --header "accept: application/json" \
    --header "Content-Type: application/json" \
    --data '
    {
  "name": "ai-rate-limiting-advanced",
  "config": {
    "llm_providers": [
      {
        "name": "openai",
        "limit": 5,
        "window_size": 60
      }
    ]
  }
}'
```

Every other {{site.base_gateway}} plugin can also be used in addition to the AI plugins, for advanced access control, authorization and authentication, security, observability, and more.

## Quickstart script

Alternatively, you can launch a demo instance of {{site.base_gateway}} to test out the 
AI plugins using the interactive AI quickstart script.
This script deploys {{site.base_gateway}} in a Docker container in traditional mode.
This option is for demo purposes only, and is not meant for production use.

{:.note}
> **Note:**
> Running this script prompts you for AI Provider API Keys which are used to configure authentication with
> hosted AI providers. These keys are only passed to the {{site.base_gateway}} Docker container and are 
> not otherwise transmitted outside the host machine.

```sh
curl -Ls https://get.konghq.com/ai | bash
```

Follow the prompts to set up the AI Proxy plugin with the LLM provider of your choice. 
The script creates a service with two routes, and configures the AI Proxy plugin on those routes based on the provider that you specify.

Check out the full script at [https://get.konghq.com/ai](https://get.konghq.com/ai) to see which entities 
it generates, and access all of your routes and services by visiting either [Gateway Manager in {{site.konnect_short_name}}](https://cloud.konghq.com/gateway-manager/) or 
Kong Manager at `https://localhost:8002` in any browser.

{:.note}
> **Note:**
> By default, local models are configured on the endpoint `http://host.docker.internal:11434`,
> which allows {{site.base_gateway}} running in Docker to connect to the host machine. 