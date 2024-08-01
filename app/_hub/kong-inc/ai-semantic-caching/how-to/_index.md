---
nav_title: Set up ai semantic caching for a LLM provider
title: Set up ai semantic caching for a LLM provider
---

## About AI Semantic Caching with {{site.base_gateway}}

The AI Semantic Caching plugin enhances performance for AI providers by caching LLM responses semantically.

## Prerequisite

You have the [AI Proxy plugin](/hub/kong-inc/ai-proxy) configured.

## Add your service and route on Kong

After installing and starting {{site.base_gateway}}, use the Admin API on port 8001 to add a new service and route. In this example, {{site.base_gateway}} will reverse proxy every incoming request with the specified incoming host to the associated upstream URL. You can implement very complex routing mechanisms beyond simple host matching.

```sh
curl -i -X POST \
  --url http://localhost:8001/services/ \
  --data 'name=example-service' \
  --data 'url=http://example.com'
```

```sh
curl -i -X POST \
  --url http://localhost:8001/services/example-service/routes \
  --data 'hosts[]=example.com' \
```  

## Add the AI Semantic Caching plugin to the service

Enhance the performance of your LLM service by caching responses semantically. This caching mechanism will store
responses based on semantic similarity, improving retrieval efficiency for similar queries.


```sh
curl -i -X POST http://localhost:8001/services/example-service/plugins \
  --data name=ai-semantic-caching \
  --data config.cache_size=500 \
  --data config.ttl=3600 \
  --data config.similarity_threshold=0.8
```

The AI Semantic Caching plugin supports various configuration options:
* cache_size: The maximum number of responses to cache.
* ttl: The time-to-live for cached responses, in seconds.
* similarity_threshold: The threshold for semantic similarity to determine if a response should be cached or retrieved from the cache.


By setting up the AI Semantic Caching plugin, you can significantly reduce the load on your LLM provider and improve response times for semantically similar queries.


