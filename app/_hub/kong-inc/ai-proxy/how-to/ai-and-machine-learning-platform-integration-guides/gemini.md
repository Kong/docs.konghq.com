---
nav_title: Gemini
title: Set up AI Proxy with Gemini
---

## Prerequisites
* [Kong Gateway is installed and running](/gateway/latest/get-started/)

## Step 1: Configure Google Gemini Models
1. Set up or select the Google Gemini model you want to use. You must configure the [model parameters](https://cloud.google.com/vertex-ai/generative-ai/docs/samples/generativeaionvertexai-gemini-pro-config-example) and ensure it's ready for deployment.
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
curl -i -X POST http://localhost:8001/services/my-service/plugins \
    --data "name=ai-proxy" \
    --data "config.model=gemini" \
    --data "config.api_key=YOUR_API_KEY" \
    --data "config.api_url=https://language.googleapis.com/v1/documents:analyzeSentiment"
```
Replace the following placeholders:

* `YOUR_API_KEY` with your actual Google API key.
* `https://language.googleapis.com/v1/documents:analyzeSentiment` with the endpoint URL for the Google Gemini API.