---
nav_title: Bedrock
title: Set up AI Proxy Advanced with Bedrock
---

This guide walks you through setting up the AI Proxy Advanced plugin with [Amazon Bedrock](https://aws.amazon.com/bedrock/).

{{site.base_gateway}} can automatically fetch IAM role credentials based on your AWS environment, observing the following precedence order:
- Fetch from credentials defined in environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
- Fetch from profile and credential file, defined by `AWS_PROFILE` and `AWS_SHARED_CREDENTIALS_FILE`.
- Fetch from an ECS [container credential provider](https://docs.aws.amazon.com/sdkref/latest/guide/feature-container-credentials.html).
- Fetch from an EKS [IAM roles for service account](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html).
- Fetch from EC2 IMDS metadata. Both v1 and v2 are supported


## Configure the AI Proxy Advanced plugin


The following steps demonstrate how to set up the AI Proxy Advanced plugin using
Access Key ID and Secret Access Key credentials.

1. Create a service in {{site.base_gateway}} that will represent the Bedrock API:
```sh
curl -X POST http://localhost:8001/services \
 --data "name=bedrock-service" \
 --data "url=https://bedrock-runtime.us-east-1.amazonaws.com"
```
Be sure to replace `us-east-1` with the region for your environment.

1. Create a route that maps to the service you defined:
```sh
curl -i -X POST http://localhost:8001/routes \
    --data "paths[]=/bedrock" \
    --data "service.id=$(curl -s http://localhost:8001/services/bedrock-service | jq -r '.id')"
```

1. Use the Kong Admin API to configure the AI Proxy Advanced Plugin to route requests to Amazon Bedrock:
```sh
curl -X POST http://localhost:8001/services/bedrock-service/plugins \
  --header 'Content-Type: application/json' \
  --header 'accept: application/json' \
  --data '{
    "name": "ai-proxy-advanced",
    "instance_name": "ai-proxy-bedrock",
    "config": {
      "targets": [
        {
          "route_type": "llm/v1/chat",
          "auth": {
            "allow_override": false,
            "aws_access_key_id": "<YOUR_AWS_ACCESS_KEY_ID>",
            "aws_secret_access_key": "<YOUR_AWS_SECRET_ACCESS_KEY>"
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
      ]
    }
  }'
```
Be sure to replace the following values:
* `YOUR_AWS_ACCESS_KEY_ID`
* `YOUR_AWS_SECRET_ACCESS_KEY`
* Configure the correct provider model (`config.model.name`) and AWS region (`config.model.options.bedrock.aws_region`) for your environment.

## Test the configuration

Make an `llm/v1/chat` type request to test your new endpoint:

```sh
curl -X POST http://localhost:8000/bedrock \
-H 'Content-Type: application/json' \
--data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```