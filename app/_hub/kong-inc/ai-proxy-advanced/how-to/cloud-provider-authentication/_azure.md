---
nav_title: Azure
title: Azure
minimum_version: 3.7.x
---

When hosting your LLMs with [Azure OpenAI Service](https://azure.microsoft.com/en-gb/products/ai-services/openai-service)
and running them through AI Proxy Advanced, you can use the assigned
[Azure Managed Identity or User-Assigned Identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview)
of the VM, Kubernetes service-account, or ACS container, to call the Azure OpenAI models.

You can also use an Entra principal or App Registration (`client_id`, `client_secret`, and `tenant_id` triplet) when
Kong is hosted outside of Azure.

How you do this depends on where and how you are running {{site.base_gateway}}.

You can use the following table to help you determine which method to use:

| Where is {{site.base_gateway}} hosted? | Then use... |
| -------------------------------------- | ----------- |
| Inside Azure | [Azure-managed identity](#azure-assigned-managed-identity) |
| Inside Azure | [User-assigned identity](#user-assigned-identity) |
| Outside Azure | [Azure-managed identity with Entra](#using-entra-or-app-registration) |

## Prerequisites

* You must be running a {{site.ee_product_name}} instance.
* Ensure that the Azure principal that you have assigned to the Compute resource (that is running your {{site.base_gateway}}) has one of the following Entra or IAM permissions to execute commands on the desired OpenAI instances:
    * [Cognitive Services OpenAI User](https://learn.microsoft.com/azure/ai-services/openai/how-to/role-based-access-control#cognitive-services-openai-user)
    * [Cognitive Services OpenAI Contributor](https://learn.microsoft.com/azure/ai-services/openai/how-to/role-based-access-control#cognitive-services-openai-contributor)
    
    See [Azure's documentation on managed identity](https://learn.microsoft.com/azure/ai-services/openai/how-to/managed-identity) to set this up.

## Configure the AI Proxy Advanced plugin to use Azure Identity

When running {{site.base_gateway}} inside of your Azure subscription, AI Proxy Advanced is usually able to detect the designated Managed Identity or User-Assigned Identity
of that Azure Compute resource and use it accordingly.

### Azure-assigned managed identity

To use an Azure-assigned managed identity, set up your plugin config like the following:

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/ai-proxy-advanced
name: ai-proxy-advanced
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

### User-assigned identity

To use a User-assigned identity, specify its client ID like the following:

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/ai-proxy-advanced
name: ai-proxy-advanced
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

### Using Entra or app registration

If you're running {{site.base_gateway}} outside of Azure, use an Entra principal or app registration by specifing all properties like the following:

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/ai-proxy-advanced
name: ai-proxy-advanced
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

You can also specify some, or all, of these properties as environment variables. For example:


Environment variable:
```sh
AZURE_CLIENT_SECRET="be0c34b6-b5f1-4343-99a3-140df73e0c1c"
```

You can then omit that value from the plugin configuration like the following:

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/ai-proxy-advanced
name: ai-proxy-advanced
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