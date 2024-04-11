---
nav_title: How to create rate limiting for different LLM providers
title: How to create rate limiting for different LLM providers
---

## About AI Rate Limiting with {{site.base_gateway}}

The AI Rate Limiting Advanced plugin enables rate limiting for AI providers used by various LLM (Large Language Model) plugins. This plugin extends the functionality of the [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) plugin.

## Prerequisite

You have LLM plugins proxy already configured

## Add your service and route on Kong

After installing and starting {{site.base_gateway}}, use the Admin API on port 8001 to add a new Service and Route. In this example, {{site.base_gateway}} will reverse proxy every incoming request with the specified incoming host to the associated upstream URL. You can implement very complex routing mechanisms beyond simple host matching.

```sh
curl -i -X POST \
  --url http://localhost:8001/services/ \
  --data 'name=graphql-service' \
  --data 'url=http://example.com'
```

```sh
curl -i -X POST \
  --url http://localhost:8001/services/example-service/routes \
  --data 'hosts[]=example.com' \
```  

## Add the GraphQL Rate Limiting Advanced plugin to the service

Protect your LLM service with rate limiting. It will analyze query costs and token response to provide an enterprise-grade rate limiting strategy.

```sh
curl -i -X POST http://localhost:8001/services/example-service/plugins \
  --data name=ai-rate-limiting-advanced \
  --data config.limit=100,10000 \
  --data config.window_size=60,3600 \
  --data config.sync_rate=10
```

The AI Rate Limiting Advanced plugin supports threes rate limiting strategies. The default strategy will estimate cost on queries by counting the total token value returned in the LLM responses.


