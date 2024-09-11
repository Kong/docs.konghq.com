---
nav_title: Gemini
title: Set up AI Proxy Advanced with Gemini
---

## Prerequisites
* [{{site.base_gateway}} is installed and running](/gateway/latest/get-started/)
* [Create or retrieve an API key](https://ai.google.dev/gemini-api/docs/api-key) on the Google Cloud API Credentials Page to access Google’s AI services

## Configure the AI Proxy Advanced plugin

1. Create a service in {{site.base_gateway}} that will represent the Google Gemini API:
```sh
curl -i -X POST http://localhost:8001/services \
    --data "name=gemini-service" \
    --data "url=https://generativelanguage.googleapis.com"
```
1. Create a route that maps to the service you defined:
```sh
curl -i -X POST http://localhost:8001/routes \
    --data "paths[]=/gemini" \
    --data "service.id=$(curl -s http://localhost:8001/services/gemini-service | jq -r '.id')"
```
1. Use the Kong Admin API to configure the AI Proxy Advanced plugin to route requests to Google Gemini:
```sh
curl -i -X POST http://localhost:8001/services/gemini-service/plugins \
--header "accept: application/json" \
--header "Content-Type: application/json" \
--data '
{
  "name": "ai-proxy-advanced",
  "config": {
    "targets": [
      {
        "route_type": "llm/v1/chat",
        "auth": {
          "param_name": "key",
          "param_value": "<GEMINI_API_TOKEN>",
          "param_location": "query"
        },
        "model": {
          "provider": "gemini",
          "name": "gemini-1.5-flash"
        }
      }
    ]
  }
}
'
```

Be sure to replace `GEMINI_API_TOKEN` with your API token.

### Test the configuration

Make an `llm/v1/chat` type request to test your new endpoint:

```sh
curl -X POST http://localhost:8000/gemini \
 -H 'Content-Type: application/json' \
 --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```