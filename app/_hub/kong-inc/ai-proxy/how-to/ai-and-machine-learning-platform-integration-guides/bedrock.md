---
nav_title: Amazon Bedrock
title: Set up AI Proxy with Amazon Bedrock
---

## Prerequisites

* [{{site.base_gateway}} is installed and running](/gateway/latest/get-started/)

## Configure Amazon Bedrock

1. From the [AWS Management Console](https://aws.amazon.com/console/), navigate to Amazon Bedrock.
1. Create an [Amazon Bedrock Model](https://docs.aws.amazon.com/bedrock/latest/userguide/what-is-bedrock.html). You will need to select a model type, configure model parameters, and deploy it. For more information about the supported model types, see Amazon's [Model support by AWS Region](https://docs.aws.amazon.com/bedrock/latest/userguide/models-regions.html) documentation.
1. Configure any necessary settings such as model parameters, input/output formats, and resource requirements. The configuration details can be found in the [Amazon Bedrock API Reference](https://docs.aws.amazon.com/bedrock/latest/APIReference/). <!-- are there any that we recommend configuring? If so, what guidance can we provide users so they know what to exactly put in the configuration, like example or actual values?-->
1. Navigate to the IAM (Identity and Access Management) section in the AWS Console to create or manage API keys and permissions. You will need to save your API key and endpoint URL.
1. Ensure that the IAM roles and policies associated with your Bedrock models have the correct permissions to allow access and interaction. For more information, see [How Amazon Bedrock works with IAM](https://docs.aws.amazon.com/bedrock/latest/userguide/security_iam_service-with-iam.html) in Amazon's documentation. <!-- which do we recommend or need, or is this entirely up to the user?-->

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
curl -i -X POST http://localhost:8001/services/bedrock-service/plugins \
    --data "name=ai-proxy" \
    --data "config.model.provider=bedrock" \
    --data "config.model.options.bedrock.aws_region=us-west-2" \
    --data "config.auth.aws_access_key_id=YOUR_ACCESS_KEY_ID" \
    --data "config.auth.aws_secret_access_key=YOUR_SECRET_ACCESS_KEY"
```

<!-- I'm confused about the entity_checks. Looks like it needs to be false for Gemini/Bedrock. It's false by default, so I don't think I need to specify it in the config. But does that then mean I should remove the auth headers from the config? is the auth then replaced by the gemini/bedrock config?-->