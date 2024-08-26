---
nav_title: OpenAI
title: Configure OpenAI for AI Semantic Cache
---

need API key

Get your Route Id:
ROUTE_ID=$(curl -s  http://admin-ai-gateway.kong-demo.com:8001/routes/bedrock-chat | jq -r '.id')

Set the Semantic Cache plugin with the following request. Note we're using the Mistral's API Key explicitly. You can use an env variable instead, if you want.

The "threshold" parameter defines the similarity between for accepting semantic search results.
curl -s -X POST http://admin-ai-gateway.kong-demo.com:8001/routes/$ROUTE_ID/plugins \
  --header 'Content-Type: application/json' \
  --header 'accept: application/json' \
  --data '{
    "name": "ai-semantic-cache",
    "instance_name": "ai-semantic-cache",
    "config": {
      "embeddings": {
        "auth": {
          "header_name": "Authorization",
          "header_value": "Bearer YOUR_OPENAI_API_KEY"
        },
        "model": {
          "provider": "openai",
          "name": "text-embedding-ada-002",
          "options": {
            "upstream_url": "https://api.openai.com/v1/embeddings"
          }
        }
      },
      "vectordb": {
        "dimensions": 1536,
        "distance_metric": "cosine",
        "strategy": "redis",
        "threshold": 0.1,
        "redis": {
          "host": "redis-stack.redis.svc.cluster.local",
          "port": 6379
        }
      }
    }
  }' | jq
