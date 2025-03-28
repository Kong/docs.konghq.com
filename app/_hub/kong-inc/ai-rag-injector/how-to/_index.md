---
nav_title: Using the AI RAG Injector plugin
title: Using the AI RAG Injector plugin
---
## Prerequisites

- Create a service and a route
- Start a [Redis-Stack](https://redis.io/docs/latest/) instance in your environment

You can now create the AI RAG Injector plugin at the global, service, or route level, using the following examples.

## Examples

The following examples show how to configure the AI RAG Injector plugin, and the expected behavior when making requests.

### 1. Configure the AI RAG Injector plugin
Configure the AI RAG Injector plugin with the AI Proxy Advanced plugin:
```yaml
_format_version: '3.0'
services:
- name: ai-proxy
  url: http://localhost:65535
  routes:
  - name: openai-chat
    paths:
    - /
plugins:
- name: ai-proxy-advanced
  config:
    targets:
    - logging:
        log_statistics: true
      route_type: llm/v1/chat
      model:
        name: gpt-4o
        provider: openai
        options:
          max_tokens: 512
          temperature: 1.0

- name: ai-rag-injector
  config:
    inject_template: |
      Only use the following information surrounded by <CONTEXT></CONTEXT>to and your existing knowledge to provide the best possible answer to the user.
      <CONTEXT><RAG RESPONSE></CONTEXT>
      User's question: <PROMPT>
    embeddings:
      auth:
        header_name: Authorization
        header_value: Bearer <openai_key>
      model:
        provider: openai
        name: text-embedding-3-large
    vectordb:
      strategy: redis
      redis:
        host: <redis_host>
        port: <redis_port>
      distance_metric: cosine
      dimensions: 768
```

### 2. Make a AI request to the AI Proxy Advanced plugin

The AI RAG Injector plugin uses the OpenAI `text-embedding-3-large` model to generate embeddings for the content and stores them in Redis. 

Once vector database has ingested data and built a knowledge base, you can make requests to it. 
For example:

```bash
curl  --http1.1 localhost:8000/chat \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
     "messages": [{"role": "user", "content": "What is kong"}]
   }' | jq
```
