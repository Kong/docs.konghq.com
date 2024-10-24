---
nav_title: Bedrock
title: Bedrock
minimum_version: 3.8.x
---

## AWS Bedrock

When hosting your LLMs with [AWS Bedrock Converse API](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_Converse.html) in a business or enterprise plan,
and running them through AI Proxy, it is possible to use an [IAM Identity](https://docs.aws.amazon.com/IAM/latest/UserGuide/id.html) that can be assigned to a currently running EC2 instance,
an EKS deployment, ECS deployment, or just used via the [AWS CLI](https://aws.amazon.com/cli/) credential context on the local machine.

How you do this depends on where and how you are running {{site.base_gateway}}.

### Prerequisites

You must be running a {{site.ee_product_name}} instance.

Ensure that the EC2 instance, EKS deployment, ECS deployment, etcetera, has been assigned the IAM principal,
configurable from the AWS IAM portal.

If the role requires crossing permission boundaries, ensure that the correct Assume-Role Policy is applied.

Assign the correct permissions to the identity's IAM Policy:

* `bedrock:InvokeModel`
* `bedrock:InvokeModelWithResponseStream`

respective to the `Resource ARNs` that corresponds to the models that Kong is allowed to call on the user's behalf.

### Configuring the AI Proxy Advanced Plugin to use AWS IAM

When running Kong inside of your AWS subscription, AI Proxy Advanced is usually able to detect the designated IAM Principal automatically, based on the
assigned identity.

Kong will use the same **authentication credentials chain** as with most AWS SDKs (and the AWS CLI). See the [Java credentials chain](https://docs.aws.amazon.com/sdk-for-java/latest/developer-guide/credentials-chain.html)
precedence order, for an example.

#### AWS IAM Identity

To use an AWS-assigned IAM Identity, set up your plugin config like this example:

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/ai-proxy-advanced
name: ai-proxy
config:
  route_type: "llm/v1/chat"
  logging:
    log_statistics: true
    log_payloads: false
  model:
    provider: "bedrock"
    name: "amazon.titan-text-express-v1"
targets:
  - route
  - consumer_group
  - global
formats:
  - konnect
  - curl
  - yaml
  - kubernetes
  - terraform
{% endplugin_example %}
<!--vale on -->

In most workloads, this is **zero-configuration** and you should not need to instruct Kong AI Proxy plugin with any credentials of
Bedrock-specific configuration - Kong will find the correct IAM credentials automatically, upon **first invocation of the model**.

#### Environment variables

You can also specify your own AWS IAM credentials; simply set this environment variables in the Kong workload or deployment configuration:

Environment variable:
```sh
AWS_ACCESS_KEY_ID=AKAI...
AWS_SECRET_ACCESS_KEY=...
AWS_REGION=eu-west-1
```

or set it directly in the plugin configuration:

```yaml
config:
  auth:
    aws_access_key_id: 'AKAI...'
    aws_secret_access_key: '...'
  options:
    bedrock:
      aws_region: 'eu-west-1'
```

or, more securely, use a vault reference to e.g. AWS Secrets Manager:

```yaml
config:
  auth:
    aws_access_key_id: 'AKAI...'
    aws_secret_access_key: '{vault://aws/BEDROCK_SECRET_ACCESS_KEY}'
  options:
    bedrock:
      aws_region: 'eu-west-1'
```
