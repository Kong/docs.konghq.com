---
nav_title: Mistral
title: Set up AI Semantic Cache with Mistral
---

This guide walks you through setting up the AI Semantic Cache plugin with [Mistral](https://mistral.ai/).

{:.important}
> Mistral is a self-hosted model. As such, it requires setting model option 
> [`upstream_url`](/hub/kong-inc/ai-proxy/configuration/#config-model-options-upstream_url) to point to the absolute
> HTTP(S) endpoint for this model implementation.

There are a number of hosting/format options for running this LLM. Mistral offers a cloud-hosted service for consuming
the LLM, available at [Mistral.ai](https://mistral.ai/)

Self-hosted options include:
* [OLLAMA](https://ollama.com/)
* [Hosting the GGUF model yourself, with an e.g. Python Web Server](https://huggingface.co/mistralai/Mixtral-8x7B-v0.1)

## Upstream Formats

The "upstream" request and response formats are different between various implementations of Mistral, and/or its accompanying web-server.

For this provider, the following should be used for the [`config.model.options.mistral_format`](/hub/kong-inc/ai-proxy/configuration/#config-model-options-mistral_format) parameter:

| Mistral Hosting  | `mistral_format` Config Value | Auth Header             |
|------------------|-------------------------------|-------------------------|
| Mistral.ai       | `openai`                      | `Authorization`         |
| OLLAMA           | `ollama`                      | Not required by default |
| Self-Hosted GGUF | `openai`                      | Not required by default |


## Prerequisites 

* Mistral's API key
* [Redis configured as a vector database](https://redis.io/docs/latest/develop/get-started/vector-database/) and cache
* You need a service to contain the route for the LLM provider. Create a service **first**:
  ```sh
  curl -X POST http://localhost:8001/services \
  --data "name=ai-semantic-cache" \
  --data "url=http://localhost:32000"
  ```
  Remember that the upstream URL can point anywhere empty, as it won’t be used by the plugin.

## Steps
1. Create a route:
```sh
curl -X POST http://localhost:8001/services/ai-semantic-cache/routes \
  --data "name=mistral-semantic-cache" \
  --data "paths[]=~/mistral-semantic-cache$"
```

1. Set the AI Semantic Cache plugin. This uses Mistral's API Key explicitly, but you can use an environment variable instead if you want.
```sh
curl -s -X POST http://localhost:8001/routes/$ROUTE_ID/plugins \
  --header 'Content-Type: application/json' \
  --header 'accept: application/json' \
  --data '{
 "name": "ai-semantic-cache",
 "instance_name": "ai-semantic-cache",
 "config": {
   "embeddings": {
     "auth": {
       "header_name": "Authorization",
       "header_value": "Bearer tfgDqTqCQiuRoajvBqzYjFMjygPote4"
     },
     "provider": "mistral",
     "name": "mistral-embed",
     "options": {
       "upstream_url": "https://api.mistral.ai/v1/embeddings"
     }
   }
   },
   "vectordb": {
     "dimensions": 1024,
     "distance_metric": "cosine",
     "strategy": "redis",
     "threshold": 0.1,
     "redis": {
       "host": "redis-stack.redis.svc.cluster.local",
       "port": 6379
     }
   }
 }
}'
```
The "threshold" parameter defines the similarity between for accepting semantic search results.

