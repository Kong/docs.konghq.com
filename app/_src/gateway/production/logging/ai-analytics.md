---
title: AI Audit Log Reference
content_type: reference
---

Kong AI Gateway offers a unified logging format for AI plugins, enabling the emission of analytics events. This facilitates the aggregation of AI usage analytics across various providers in a standardized manner.

## Log Formats

Each AI plugin returns a set of tokens. 

All log entries include the following attributes:

```json
"ai": {
    "payload": { "[$optional_payload_request_]" },
    "[$plugin_name_1]": {
      "payload": { "[$optional_payload_response]" },
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
      "payload": { "[$optional_payload_response]" },
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
