---
title: AI Audit Log Reference
content_type: reference
---

Kong AI Gateway provides a standardized logging format for AI plugins, enabling the emission of analytics events and facilitating the aggregation of AI usage analytics across various providers.

## Log Formats

Each AI plugin returns a set of tokens. 

All log entries include the following attributes:

```json
"ai": {
    "payload": { "request": "[$optional_payload_request_]" },
    "[$plugin_name_1]": {
      "payload": { "response": "[$optional_payload_response]" },
      "usage": {
        "prompt_token": 28,
        "total_tokens": 48,
        "completion_token": 20,
        "cost": 0.0038,
        "time_per_token": 133
      },
      "meta": {
        "request_model": "command",
        "provider_name": "cohere",
        "response_model": "command",
        "plugin_id": "546c3856-24b3-469a-bd6c-f6083babd2cd",
        "llm_latency": 2670
      }
    },
    "[$plugin_name_2]": {
      "payload": { "response": "[$optional_payload_response]" },
      "usage": {
        "prompt_token": 89,
        "total_tokens": 145,
        "completion_token": 56,
        "cost": 0.0012,
        "time_per_token": 87
      },
      "meta": {
        "request_model": "gpt-35-turbo",
        "provider_name": "azure",
        "response_model": "gpt-35-turbo",
        "plugin_id": "5df193be-47a3-4f1b-8c37-37e31af0568b",
        "llm_latency": 4927
      }
    }
  }
```

### Log Details

Each log entry includes the following details:

Property | Description
---------|-------------
`ai.payload.request` | The request payload.
`ai.[$plugin_name].payload.response` |The response payload.
`ai.[$plugin_name].usage.prompt_token` | Number of tokens used for prompting.
`ai.[$plugin_name].usage.completion_token` | Number of tokens used for completion.
`ai.[$plugin_name].usage.total_tokens` | Total number of tokens used.
`ai.[$plugin_name].usage.cost` | The total cost of the request (input and output cost).
`ai.[$plugin_name].usage.time_per_token` | The average time to generate an output token in ms.
`ai.[$plugin_name].meta.request_model` | Model used for the AI request.
`ai.[$plugin_name].meta.provider_name` | Name of the AI service provider.
`ai.[$plugin_name].meta.response_model` | Model used for the AI response.
`ai.[$plugin_name].meta.plugin_id` | Unique identifier of the plugin.
`ai.[$plugin_name].meta.llm_latency` | The time in ms it took the llm provider to generate the full response.
`ai.[$plugin_name].cache.cache_status` | The cache status, balie could be Hit, Miss. Bypass or Refresh.
`ai.[$plugin_name].cache.fetch_latency` | The time in ms it took the return a cache response.
`ai.[$plugin_name].cache.embeddings_provider` | For semantic caching, the provider used to generate the embeddings.
`ai.[$plugin_name].cache.embeddings_model` | For semantic caching, the model used to generate the embeddings.
`ai.[$plugin_name].cache.embeddings_latency` | For semantic caching, the time taken to generate the embeddings.


### Caches Logging

If using the cache semantic plugins, logging will be provided with some additional details about caching:

```json
"ai": {
    "payload": { "request": "[$optional_payload_request_]" },
    "[$plugin_name_1]": {
      "payload": { "response": "[$optional_payload_response]" },
      "usage": {
        "prompt_token": 28,
        "total_tokens": 48,
        "completion_token": 20,
        "cost": 0.0038,
        "time_per_token": 133
      },
      "meta": {
        "request_model": "command",
        "provider_name": "cohere",
        "response_model": "command",
        "plugin_id": "546c3856-24b3-469a-bd6c-f6083babd2cd",
        "llm_latency": 2670
      },
      "cache": {
        "cache_status": "Hit",
        "fetch_latency": 21
      }
    },
    "[$plugin_name_2]": {
      "payload": { "response": "[$optional_payload_response]" },
      "usage": {
        "prompt_token": 89,
        "total_tokens": 145,
        "completion_token": 56,
        "cost": 0.0012,
      },
      "meta": {
        "request_model": "gpt-35-turbo",
        "provider_name": "azure",
        "response_model": "gpt-35-turbo",
        "plugin_id": "5df193be-47a3-4f1b-8c37-37e31af0568b",
      },
      "cache": {
        "cache_status": "Hit",
        "fetch_latency": 444,
        "embeddings_provider": "openai",
        "embeddings_model": "text-embedding-3-small",
        "embeddings_latency": 424
      }
    }
  }
```

{:.note}
> **Note:** 
> When returning a cache response `time_per_token` and `llm_latency` will be omitted.
> The cache response can be returned either as a semantic cache or an exact cache. If returned as a semantic cache, it will include additional details such as the embeddings provider, embeddings model, and embeddings latency.

