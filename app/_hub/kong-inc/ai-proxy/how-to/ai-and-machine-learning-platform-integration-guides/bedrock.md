---
nav_title: Amazon Bedrock
title: Set up AI Proxy with Amazon Bedrock
---

## Prerequisites

* [Kong Gateway is installed and running](/gateway/latest/get-started/)

## Configure Amazon Bedrock

1. From the [AWS Management Console](https://aws.amazon.com/console/), navigate to Amazon Bedrock.
1. Create an [Amazon Bedrock Model](https://docs.aws.amazon.com/bedrock/latest/userguide/what-is-bedrock.html). You will need to select a model type, configure model parameters, and deploy it.
1. Configure any necessary settings such as model parameters, input/output formats, and resource requirements. The configuration details can be found in the [Amazon Bedrock API Reference](https://docs.aws.amazon.com/bedrock/latest/APIReference/).
1. Navigate to the IAM (Identity and Access Management) section in the AWS Console to create or manage API keys and permissions. You will need to save your API key and endpoint URL.
1. Ensure that the IAM roles and policies associated with your Bedrock models have the correct permissions to allow access and interaction. For more information, see [Amazon's IAM User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/).

## Configure the AI Proxy plugin

1. Create a service in {{site.base_gateway}} that will represent the Bedrock API:
```sh
curl -i -X POST http://localhost:8001/services \
    --data "name=bedrock-service" \
    --data "url=https://bedrock-api-url"
```
1. Create a route that maps to the service you defined:
```sh
curl -i -X POST http://localhost:8001/routes \
    --data "paths[]=/bedrock" \
    --data "service.id=$(curl -s http://localhost:8001/services/bedrock-service | jq -r '.id')"
```
1. Use the Kong Admin API to configure the AI Proxy Plugin to route requests to Amazon Bedrock:
```sh
curl -i -X POST http://localhost:8001/services/my-service/plugins \
    --data "name=ai-proxy" \
    --data "config.model=bedrock" \
    --data "config.api_key=YOUR_BEDROCK_API_KEY" \
    --data "config.api_url=https://bedrock-api-url"
```
Replace the following placeholders:

* `YOUR_BEDROCK_API_KEY` with your actual Bedrock API key.
* `https://bedrock-api-url` with the endpoint URL for Amazon Bedrock’s API.