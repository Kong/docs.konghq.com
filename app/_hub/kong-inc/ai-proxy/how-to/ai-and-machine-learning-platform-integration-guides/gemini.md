---
nav_title: Gemini
title: Set up AI Proxy with Gemini
---

## Prerequisites
* [{{site.base_gateway}} is installed and running](/gateway/latest/get-started/)

## Step 1: Configure Google Gemini Models
1. Set up or select the Google Gemini model you want to use. You must configure the [model parameters](https://cloud.google.com/vertex-ai/generative-ai/docs/samples/generativeaionvertexai-gemini-pro-config-example) and ensure it's ready for deployment. <!-- is there any additional guidance here about what to configure? something we could put in a table with mapping the parameter to the value?-->
1. [Create or retrieve an API key](https://ai.google.dev/gemini-api/docs/api-key) on the Google Cloud API Credentials Page to access Google’s AI services.
1. Auth?

## Configure the AI Proxy plugin

1. Create a service in {{site.base_gateway}} that will represent the Google Gemini API:
```sh
curl -i -X POST http://localhost:8001/services \
    --data "name=gemini-service" \
    --data "url=https://language.googleapis.com"
```
1. Create a route that maps to the service you defined:
```sh
curl -i -X POST http://localhost:8001/routes \
    --data "paths[]=/gemini" \
    --data "service.id=$(curl -s http://localhost:8001/services/gemini-service | jq -r '.id')"
```
1. Use the Kong Admin API to configure the AI Proxy Plugin to route requests to Google Gemini:
```sh
curl -i -X POST http://localhost:8001/services/gemini-service/plugins \
    --data 'name=ai-proxy' \
    --data 'config.route_type=preserve' \
    --data 'config.auth.header_name=Authorization' \
    --data 'config.auth.header_value=Bearer <GEMINI_API_TOKEN>' \
    --data 'config.model.provider=gemini' \
    --data 'config.model.options.gemini.api_endpoint=YOUR_REGIONAL_API_ENDPOINT' \
    --data 'config.model.options.gemini.project_id=YOUR_PROJECT_ID' \
    --data 'config.model.options.gemini.location_id=YOUR_LOCATION_ID'
```
<!-- I'm confused about the entity_checks. Looks like it needs to be false for Gemini/Bedrock. It's false by default, so I don't think I need to specify it in the config. But does that then mean I should remove the auth headers from the config? is the auth then replaced by the gemini/bedrock config?-->