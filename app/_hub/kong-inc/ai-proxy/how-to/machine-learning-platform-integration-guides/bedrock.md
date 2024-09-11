---
nav_title: Bedrock
title: Set up AI Proxy with Bedrock
---

This guide walks you through setting up the AI Proxy plugin with [Amazon Bedrock](https://aws.amazon.com/bedrock/).

For all providers, the Kong AI Proxy plugin attaches to route entities.

## Prerequisites
* [{{site.base_gateway}} is installed and running](/gateway/latest/get-started/)
* An AWS account
* Any keys?

## Configure the AI Proxy plugin

1. Create a service in {{site.base_gateway}} that will represent the Bedrock API:
```sh
curl -X POST http://localhost:8001/services \
 --data "name=bedrock-service" \
 --data "url=https://bedrock-runtime.us-east-1.amazonaws.com"
```

1. Create a route that maps to the service you defined:
```sh
curl -i -X POST http://localhost:8001/routes \
    --data "paths[]=/bedrock" \
    --data "service.id=$(curl -s http://localhost:8001/services/bedrock-service | jq -r '.id')"
```

1. Use the Kong Admin API to configure the AI Proxy Plugin to route requests to Amazon Bedrock:
```sh
curl -X POST http://localhost:8001/services/bedrock-service/plugins \
  --header 'Content-Type: application/json' \
  --header 'accept: application/json' \
  --data '{
    "name": "ai-proxy",
    "instance_name": "ai-proxy-bedrock",
    "config": {
      "route_type": "llm/v1/chat",
      "auth": {
        "allow_override": false
      },
      "model": {
        "provider": "bedrock",
        "name": "meta.llama3-70b-instruct-v1:0",
        "options": {
          "bedrock": {
            "aws_region": "us-east-1"
          }
        }
      }
    }
  }'
```