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
        "completion_token": 20
      },
      "meta": {
        "request_model": "command",
        "provider_name": "cohere",
        "response_model": "command",
        "plugin_id": "546c3856-24b3-469a-bd6c-f6083babd2cd"
      }
    },
    "[$plugin_name_2]": {
      "payload": { "response": "[$optional_payload_response]" },
      "usage": {
        "prompt_token": 89,
        "total_tokens": 145,
        "completion_token": 56
      },
      "meta": {
        "request_model": "gpt-35-turbo",
        "provider_name": "azure",
        "response_model": "gpt-35-turbo",
        "plugin_id": "5df193be-47a3-4f1b-8c37-37e31af0568b"
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
`ai.[$plugin_name].meta.request_model` | Model used for the AI request.
`ai.[$plugin_name].meta.provider_name` | Name of the AI service provider.
`ai.[$plugin_name].meta.response_model` | Model used for the AI response.
`ai.[$plugin_name].meta.plugin_id` | Unique identifier of the plugin.

