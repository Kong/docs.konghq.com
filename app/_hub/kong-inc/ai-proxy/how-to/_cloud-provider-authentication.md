---
nav_title: Cloud Provider Authentication
title: Authenticate to Cloud-Hosted Models Using their Native Authentication
minimum_version: 3.7.x
---

{:.note}
> This feature requires {{site.ee_product_name}}.

This guide walks you through setting up the AI Proxy plugin with a cloud-hosted model,
using the cloud's native authentication mechanism.

## Overview

When running software on a cloud-hosted virtual machine or container instance, the provider
offers a keyless role-based access mechanism, allowing you to call services native to that cloud
provider without having to store any keys inside the running instance (or in the Kong configuration).

This operates like a single-sign-on (SSO) mechanism for your cloud applications.

Kong's AI Gateway (AI Proxy) can take advantage of the authentication mechanisms for
many different cloud providers and, where available, can also use this authentication to call
LLM-based services using those same methods.

## Supported providers

Kong's AI Gateway currently supports the following cloud authentication:

| AI-Proxy LLM Provider          | Cloud Provider                                  | Type                                    |
|--------------------------------|-------------------------------------------------|-----------------------------------------|
| `azure` (Kong Enterprise Only) | Azure OpenAI                                    | [Entra / Managed Identity Authentication](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) |
| `gemini`                       | Gemini Enterprise (on Vertex or Workspace)      | [GCP Service Account](https://cloud.google.com/iam/docs/service-account-overview) |
| `bedrock`                      | AWS Bedrock Converse-API                        | [AWS IAM Identity](https://docs.aws.amazon.com/IAM/latest/UserGuide/id.html) |

## Azure OpenAI (Kong Enterprise Only)

When hosting your LLMs with [Azure OpenAI Service](https://azure.microsoft.com/en-gb/products/ai-services/openai-service)
and running them through AI Proxy, it is possible to use the assigned
[Azure Managed Identity or User-Assigned Identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview)
of the VM, Kubernetes service-account, or ACS container, to call the Azure OpenAI models.

You can also use an Entra principal or App Registration (`client_id`, `client_secret`, and `tenant_id` triplet) when
Kong is hosted outside of Azure.

How you do this depends on where and how you are running {{site.base_gateway}}.

### Prerequisites

You must be running a {{site.ee_product_name}} instance.

Ensure that the Azure principal that you have assigned to the Compute resource (that is running your {{site.base_gateway}}) has the necessary
Entra or IAM permissions to execute commands on the desired OpenAI instances. It must have one of the following permissions:

* Cognitive Services OpenAI User
* Cognitive Services OpenAI Contributor

See [Azure's documentation on managed identity](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/managed-identity)
to set this up.

### Configuring the AI Proxy  Plugin to use Azure Identity

When running Kong inside of your Azure subscription, AI Proxy is usually able to detect the designated Managed Identity or User-Assigned Identity
of that Azure Compute resource, and use it accordingly.

#### Azure-Assigned Managed Identity

To use an Azure-Assigned Managed Identity, set up your plugin config like this:

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/ai-proxy
name: ai-proxy
config:
  route_type: "llm/v1/chat"
  auth:
    azure_use_managed_identity: true
  model:
    provider: "azure"
    name: "gpt-35-turbo"
    options:
      azure_instance: "my-openai-instance"
      azure_deployment_id: "kong-gpt-3-5"
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

#### User-Assigned Identity

To use a User-Assigned Identity, specify its client ID like this:

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/ai-proxy
name: ai-proxy
config:
  route_type: "llm/v1/chat"
  auth:
    azure_use_managed_identity: true
    azure_client_id: "aabdecea-fc38-40ca-9edd-263878b290fe"
  model:
    provider: "azure"
    name: "gpt-35-turbo"
    options:
      azure_instance: "my-openai-instance"
      azure_deployment_id: "kong-gpt-3-5"
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

#### Using Entra or app registration

If running outside of Azure, to use an Entra principal or app registration, specify all properties like this:

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/ai-proxy
name: ai-proxy
config:
  route_type: "llm/v1/chat"
  auth:
    azure_use_managed_identity: true
    azure_client_id: "aabdecea-fc38-40ca-9edd-263878b290fe"
    azure_client_secret: "be0c34b6-b5f1-4343-99a3-140df73e0c1c"
    azure_tenant_id: "1e583ecd-9293-4db1-b1c0-2b6126cb5fdd"
  model:
    provider: "azure"
    name: "gpt-35-turbo"
    options:
      azure_instance: "my-openai-instance"
      azure_deployment_id: "kong-gpt-3-5"
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

#### Environment variables

You can also specify some (or all) of these properties as environment variables. For example:


Environment variable:
```sh
AZURE_CLIENT_SECRET="be0c34b6-b5f1-4343-99a3-140df73e0c1c"
```

Plugin configuration:

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/ai-proxy
name: ai-proxy
config:
  route_type: "llm/v1/chat"
  auth:
    azure_use_managed_identity: true
    azure_client_id: "aabdecea-fc38-40ca-9edd-263878b290fe"
    azure_tenant_id: "1e583ecd-9293-4db1-b1c0-2b6126cb5fdd"
  model:
    provider: "azure"
    name: "gpt-35-turbo"
    options:
      azure_instance: "my-openai-instance"
      azure_deployment_id: "kong-gpt-3-5"
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

## Google Gemini

When hosting your LLMs with [Google Gemini Vertex](https://cloud.google.com/vertex-ai?hl=en) in a business or enterprise plan, and running them through AI Proxy,
it is possible to use a [GCP Workload Identity](https://cloud.google.com/iam/docs/workload-identity-federation) that can be assigned to a currently running instance,
a Container Platform deployment, or just used via the [gcloud CLI](https://cloud.google.com/sdk/gcloud) sign-in on the local machine.

How you do this depends on where and how you are running {{site.base_gateway}}.

### Prerequisites

You must be running a {{site.ee_product_name}} instance.

Ensure that the GCP Virtual Machine, Container Deployment, Container Application (or a combination of these) has been assigned the Service Account principal,
configurable from the Google Cloud IAM portal.

Assign the `'Vertex AI User'` role to the Service Account.

### Configuring the AI Proxy Plugin to use GCP Workload Identity

When running Kong inside of your GCP subscription, AI Proxy is usually able to detect the designated Service Account automatically, based on the
`GCP_SERVICE_ACCOUNT` JSON that is automatically injected into an environment variable in your Kong deployment (or the Kong Virtual Machine(s)).

#### GCP-Assigned Workload Identity

To use a GCP-Assigned Workload Identity, set up your plugin config like this example:

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/ai-proxy
name: ai-proxy
config:
  route_type: "llm/v1/chat"
  auth:
    use_gcp_service_account: true
  logging:
    log_statistics: true
    log_payloads: false
  model:
    provider: "gemini"
    name: "gemini-1.5-flash"
  options:
    gemini:
      api_endpoint: "us-central1-aiplatform.googleapis.com"
      project_id: "sample-project-123456"
      location_id: "us-central1"
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

#### Environment variables

You can also specify your own GCP Service Account JSON; simply set this environment variable in the Kong workload or deployment configuration:

Environment variable:
```sh
GCP_SERVICE_ACCOUNT='{ "type": "service_account", "project_id": "sample-project-123456", "private_key_id": "...", "private_key": "..."...}'
```

or set it directly in the plugin configuration:

```yaml
config:
  auth:
    use_gcp_service_account: true
    gcp_service_account_json: '{ "type": "service_account", "project_id": "sample-project-123456", "private_key_id": "...", "private_key": "..."...}'
```

or, more securely, use a vault reference to e.g. GCP Secrets Manager:

```yaml
config:
  auth:
    use_gcp_service_account: true
    gcp_service_account_json: '{vault://gcp/VERTEX_SERVICE_ACCOUNT_JSON}'
```