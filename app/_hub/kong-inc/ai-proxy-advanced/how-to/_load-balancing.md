---
title: Load Balancing
nav_title: Configure Load Balancing with AI Proxy Advanced
minimum_version: 3.8.x
---

The AI Proxy Advanced plugin offers different load-balancing algorithms to define how to distribute requests to different AI models. This guide provides a configuration example for each algorithm.

## Semantic routing

Semantic routing enables distribution of requests based on the similarity between the prompt and the description of each model. This allows Kong to automatically select the model that is best suited for the given domain or use case.

To set up load balancing with the AI Proxy Advanced plugin, you need to configure the following parameters:
* [`config.embeddings`](/hub/kong-inc/ai-proxy-advanced/configuration/#config-embeddings) to define the model to use to match the model description and the prompts.
* [`config.vectordb`](/hub/kong-inc/ai-proxy-advanced/configuration/#config-vectordb) to define the vector database parameters. You can use either [Redis](/hub/kong-inc/ai-proxy-advanced/configuration/#config-vectordb-redis) or [PGVector](/hub/kong-inc/ai-proxy-advanced/configuration/#config-vectordb-pgvector) database.
* [`config.targets[].description`](/hub/kong-inc/ai-proxy-advanced/configuration/#config-targets-description) to define the description to be matched with the prompts.

For example, the following configuration uses two OpenAI models: one for questions related to Kong, and another for questions related to Microsoft.

```yaml
_format_version: "3.0"
services:
- name: openai-chat-service
  url: https://httpbin.konghq.com/
  routes:
  - name: openai-chat-route
    paths:
    - /chat
plugins:
- name: ai-proxy-advanced
  config:
    embeddings:
      auth:
        header_name: Authorization
        header_value: Bearer <token>
      model:
        name: text-embedding-3-small
        provider: openai
    vectordb:
      dimensions: 1024
      distance_metric: cosine
      strategy: redis
      threshold: 0.7
      redis:
        host: redis-stack-server
        port: 6379
    balancer:
      algorithm: semantic
    targets:
    - model:
        name: gpt-4
        provider: openai
        options:
          max_tokens: 512
          temperature: 1.0
      route_type: llm/v1/chat
      auth:
        header_name: Authorization
        header_value: Bearer <token>
      description: "What is Kong?"
    - model:
        name: gpt-4o-mini
        provider: openai
        options:
          max_tokens: 512
          temperature: 1.0
      route_type: llm/v1/chat
      auth:
        header_name: Authorization
        header_value: Bearer <token>
      description: "What is Microsoft?"
```

You can validate this configuration by sending requests and checking the `X-Kong-LLM-Model` response header to see which model was used.

In the response to the following request, the `X-Kong-LLM-Model` header value is `openai/gpt-4`.

```bash
curl --request POST \
  --url http://localhost:8000/chat \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/10.0.0' \
  --data '{
	"messages": [
		{
			"role": "system",
			"content": "You are an IT specialist"
		},
		{
			"role": "user",
			"content": "Who founded Kong?"
		}
	]
}'
```

## Weighted round-robin

The round-robin algorithm distributes requests to the different models on a rotation. By default, all models have the same weight and receive the same percentage of requests. However, this can be configured with the [`config.targets[].weight`](/hub/kong-inc/ai-proxy-advanced/configuration/#config-targets-weight) parameter.

If you have three models and want to assign 70% of requests to the first one, 25% of requests to the second one, and 5% of requests to the third one, you can use the following configuration:

```yaml
_format_version: "3.0"
services:
- name: openai-chat-service
  url: https://httpbin.konghq.com/
  routes:
  - name: openai-chat-route
    paths:
    - /chat
plugins:
- name: ai-proxy-advanced
  config:
    balancer:
      algorithm: round-robin
    targets:
    - model:
        name: gpt-4
        provider: openai
        options:
          max_tokens: 512
          temperature: 1.0
      route_type: llm/v1/chat
      auth:
        header_name: Authorization
        header_value: Bearer <token>
      weight: 70
    - model:
        name: gpt-4o-mini
        provider: openai
        options:
          max_tokens: 512
          temperature: 1.0
      route_type: llm/v1/chat
      auth:
        header_name: Authorization
        header_value: Bearer <token>
      weight: 25
    - model:
        name: gpt-3
        provider: openai
        options:
          max_tokens: 512
          temperature: 1.0
      route_type: llm/v1/chat
      auth:
        header_name: Authorization
        header_value: Bearer <token>
      weight: 5
```

## Consistent-hashing

The consistent-hashing algorithm uses a request header to consistently route requests to the same AI model based on the header value. By default, the header is `X-Kong-LLM-Request-ID`, but it can be customized with the [`config.balancer.hash_on_header`](/hub/kong-inc/ai-proxy-advanced/configuration/#config-balancer-hash_on_header) parameter.

For example:
```yaml
_format_version: "3.0"
services:
- name: openai-chat-service
  url: https://httpbin.konghq.com/
  routes:
  - name: openai-chat-route
    paths:
    - /chat
plugins:
- name: ai-proxy-advanced
  config:
    balancer:
      algorithm: consistent-hashing
      hash_on_header: X-Hashing-Header
    targets:
    - model:
        name: gpt-4
        provider: openai
        options:
          max_tokens: 512
          temperature: 1.0
      route_type: llm/v1/chat
      auth:
        header_name: Authorization
        header_value: Bearer <token>
    - model:
        name: gpt-4o-mini
        provider: openai
        options:
          max_tokens: 512
          temperature: 1.0
      route_type: llm/v1/chat
      auth:
        header_name: Authorization
        header_value: Bearer <token>
```

## Lowest-latency

The lowest-latency algorithm distributes requests to the model with the lowest response time. By default, the latency is calculated based on the time the model takes to generate each token (`tpot`). You can change the value of the [`config.balancer.latency_strategy`](/hub/kong-inc/ai-proxy-advanced/configuration/#config-balancer-latency_strategy) to `e2e` to use the end-to-end response time.

For example:
```yaml
_format_version: "3.0"
services:
- name: openai-chat-service
  url: https://httpbin.konghq.com/
  routes:
  - name: openai-chat-route
    paths:
    - /chat
plugins:
- name: ai-proxy-advanced
  config:
    balancer:
      algorithm: lowest-latency
      latency_strategy: e2e
    targets:
    - model:
        name: gpt-4
        provider: openai
        options:
          max_tokens: 512
          temperature: 1.0
      route_type: llm/v1/chat
      auth:
        header_name: Authorization
        header_value: Bearer <token>
    - model:
        name: gpt-4o-mini
        provider: openai
        options:
          max_tokens: 512
          temperature: 1.0
      route_type: llm/v1/chat
      auth:
        header_name: Authorization
        header_value: Bearer <token>
```

## Lowest-usage

The lowest-usage algorithm distributes requests to the model with the lowest usage volume. By default, the usage is calculated based on the total number of tokens in the prompt and in the response. However, you can customize this using the [`config.balancer.tokens_count_strategy`](/hub/kong-inc/ai-proxy-advanced/configuration/#config-balancer-tokens_count_strategy) parameter. You can use:
* `prompt-tokens` to count only the tokens in the prompt
* `completion-tokens` to count only the tokens in the response
* `total-tokens` to count both tokens in the prompt and in the response
{% if_version gte:3.10.x -%}
* `cost` to count the cost of the tokens. The `cost` parameter must set in each model configuration to use this strategy and `log_statistics` should be turned on.
{% endif_version %}

For example:
```yaml
_format_version: "3.0"
services:
- name: openai-chat-service
  url: https://httpbin.konghq.com/
  routes:
  - name: openai-chat-route
    paths:
    - /chat
plugins:
- name: ai-proxy-advanced
  config:
    balancer:
      algorithm: lowest-usage
      tokens_count_strategy: prompt-tokens
    targets:
    - model:
        name: gpt-4
        provider: openai
        options:
          max_tokens: 512
          temperature: 1.0
      route_type: llm/v1/chat
      auth:
        header_name: Authorization
        header_value: Bearer <token>
    - model:
        name: gpt-4o-mini
        provider: openai
        options:
          max_tokens: 512
          temperature: 1.0
      route_type: llm/v1/chat
      auth:
        header_name: Authorization
        header_value: Bearer <token>
```

## Priority

In the priority algorithm, targets that have same `weight` are identified as a group. By default, all models have the same priority. However, this can be configured with the [`config.targets[].weight`](/hub/kong-inc/ai-proxy-advanced/configuration/#config-targets-weight) parameter.

The balancer always chooses one of the targets of the group with the highest priority first. If all targets in the highest priority group are down, the balancer chooses one of the targets in the next highest priority.


For example:
```yaml
_format_version: "3.0"
services:
- name: openai-chat-service
  url: https://httpbin.konghq.com/
  routes:
  - name: openai-chat-route
    paths:
    - /chat
plugins:
- name: ai-proxy-advanced
  config:
    balancer:
      algorithm: priority
    targets:
    - model:
        name: gpt-4
        provider: openai
        options:
          max_tokens: 512
          temperature: 1.0
      route_type: llm/v1/chat
      auth:
        header_name: Authorization
        header_value: Bearer <token>
      weight: 70
    - model:
        name: gpt-4o-mini
        provider: openai
        options:
          max_tokens: 512
          temperature: 1.0
      route_type: llm/v1/chat
      auth:
        header_name: Authorization
        header_value: Bearer <token>
      weight: 70
    - model:
        name: gpt-3
        provider: openai
        options:
          max_tokens: 512
          temperature: 1.0
      route_type: llm/v1/chat
      auth:
        header_name: Authorization
        header_value: Bearer <token>
      weight: 25
```