---
nav_title: Overview
title: Overview
minimum_version: 3.7.x
---

{:.note}
> This feature requires {{site.ee_product_name}}.

This guide walks you through setting up the AI Proxy Advanced plugin with a cloud-hosted model,
using the cloud's native authentication mechanism.

Cloud native authentication has the following benefits over regular authentication:
* Additional security because you aren't passing sensitive information (like API keys) through the plugin configuration
* Use the roles and permissions from the cloud provider instead of hardcoding them

When running software on a cloud-hosted virtual machine or container instance, the provider
offers a keyless role-based access mechanism, allowing you to call services native to that cloud
provider without having to store any keys inside the running instance (or in the Kong configuration).

This operates like a single-sign-on (SSO) mechanism for your cloud applications.

Kong's AI Gateway (AI Proxy Advanced) can take advantage of the authentication mechanisms for
many different cloud providers and, where available, can also use this authentication to call
LLM-based services using those same methods.

## Supported providers

Kong's AI Gateway currently supports the following cloud authentication:

| AI Proxy Advanced LLM provider             | Cloud provider                                  | Type                                    |
|--------------------------------------------|-------------------------------------------------|-----------------------------------------|
| `azure` ('{{site.ee_product_name}}' Only)  | Azure OpenAI                                    | [Entra/Managed Identity Authentication](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) |

{% if_version gte:3.8.x %}
| `gemini`                                   | Gemini Enterprise (on Vertex or Workspace)      | [GCP Service Account](https://cloud.google.com/iam/docs/service-account-overview) |
| `bedrock`                                  | AWS Bedrock Converse-API                        | [AWS IAM Identity](https://docs.aws.amazon.com/IAM/latest/UserGuide/id.html) |
{% endif_version %}