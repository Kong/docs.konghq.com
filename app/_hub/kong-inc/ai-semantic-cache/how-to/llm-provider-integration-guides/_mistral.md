---
nav_title: Mistral
title: Set up AI Semantic Cache with Mistral
---

## Prerequisites 

* Mistral's API key
* [Redis configured as a vector database](https://redis.io/docs/latest/develop/get-started/vector-database/)
* [Redis configured as a cache](https://redis.io/docs/latest/operate/oss_and_stack/management/config/#configuring-redis-as-a-cache)
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
curl -s -X POST http://localhost:8001/routes/mistral-semantic-cache/plugins \
  --header 'Content-Type: application/json' \
  --header 'accept: application/json' \
  --data '{
    "name": "ai-semantic-cache",
    "instance_name": "ai-semantic-cache",
    "config": {
      "embeddings": {
        "auth": {
          "header_name": "Authorization",
          "header_value": "Bearer MISTRAL_API_KEY"
        },
        "model": {
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
This configures the following:
* `embeddings.model.name`: The AI model to use for generating embeddings. This example is configured with `mistral-embed` because it's the only option available for Mistral AI.
* `vectordb.dimensions`: The dimensionality for the vectors. This configuration uses `1024` since it's the [example Mistral uses in their documentation](https://docs.mistral.ai/capabilities/embeddings/#mistral-embed-api).
* `vectordb.distance_metric`: The distance metric to use for vectors. This example uses `cosine`.
* `vectordb.strategy`: Defines the vector database, in this case, Redis.
* `vectordb.threshold`: Defines the similarity threshold for accepting semantic search results. In the example, this is configured to as a low threshold, meaning it would include results that are only somewhat similar.
* `vectordb.redis.host`: The host of your vector database.
* `vectordb.redis.port`: The port to use for your vector database.

## More information
* *Redis Documentation:* [Vectors](https://redis.io/docs/latest/develop/interact/search-and-query/advanced-concepts/vectors/) - Learn how to use vector fields and perform vector searches in Redis
* *Redis Documentation:* [How to Perform Vector Similarity Search Using Redis in NodeJS](https://redis.io/learn/howtos/solutions/vector/getting-started-vector)