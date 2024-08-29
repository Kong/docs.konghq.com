---
nav_title: OpenAI
title: Configure OpenAI for AI Semantic Cache
---

## Prerequisites 

* OpenAI account and subscription
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
  --data "name=openai-semantic-cache" \
  --data "paths[]=~/openai-semantic-cache$"
```

1. Set the AI Semantic Cache plugin. This uses Mistral's API Key explicitly, but you can use an environment variable instead if you want.
```sh
curl -s -X POST http://localhost:8001/routes/openai-semantic-cache/plugins \
  --header 'Content-Type: application/json' \
  --header 'accept: application/json' \
  --data '{
 "name": "ai-semantic-cache",
 "instance_name": "ai-semantic-cache",
 "config": {
   "embeddings": {
     "auth": {
       "header_name": "Authorization",
       "header_value": "Bearer OPENAI_API_KEY"
     },
      "provider": "openai",
      "name": "text-embedding-3-large",
      "options": {
        "upstream_url": "https://api.openai.com/v1/embeddings"
      }
    }
   },
   "vectordb": {
     "dimensions": 3072,
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
* `vectordb.dimensions`: The dimensionality for the vectors. Since this example uses `text-embedding-3-large`, OpenAI uses `3072` as the [default embedding dimension](https://platform.openai.com/docs/guides/embeddings/how-to-get-embeddings).
* `vectordb.distance_metric`: The distance metric to use for vectors. This example uses `cosine` because [OpenAI recommends it](https://platform.openai.com/docs/guides/embeddings/which-distance-function-should-i-use).
* `vectordb.strategy`: Defines the vector database, in this case, Redis.
* `vectordb.threshold`: Defines the similarity threshold for accepting semantic search results. In the example, this is configured to as a low threshold, meaning it would include results that are only somewhat similar.
* `vectordb.redis.host`: The host of your vector database.
* `vectordb.redis.port`: The port to use for your vector database.


`config.embeddings.name`: which AI model to use for generating embeddings. This example is configured with `text-embedding-3-large`, but you can also choose `text-embedding-3-small` for OpenAI.
The "threshold" parameter defines the similarity between for accepting semantic search results.

## More information
* *Redis Documentation:* [Vectors](https://redis.io/docs/latest/develop/interact/search-and-query/advanced-concepts/vectors/) - Learn how to use vector fields and perform vector searches in Redis
* *Redis Documentation:* [How to Perform Vector Similarity Search Using Redis in NodeJS](https://redis.io/learn/howtos/solutions/vector/getting-started-vector)