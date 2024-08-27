---
nav_title: OpenAI
title: Configure OpenAI for AI Semantic Cache
---

## Prerequisites 

* OpenAI account and subscription
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
  --data "name=openai-semantic-cache" \
  --data "paths[]=~/openai-semantic-cache$"
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
      "provider": "openai",
      "name": "text-embedding-3-large",
      "options": {
        "upstream_url": "?"
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
`config.embeddings.name`: which AI model to use for generating embeddings. This example is configured with `text-embedding-3-large`, but you can also choose `text-embedding-3-small` for OpenAI.
The "threshold" parameter defines the similarity between for accepting semantic search results.