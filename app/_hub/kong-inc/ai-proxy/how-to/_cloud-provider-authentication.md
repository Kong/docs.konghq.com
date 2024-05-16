---
nav_title: Cloud Provider Authentication
title: Authenticate to Cloud-Hosted Models Using its Native Authentication
---

This guide walks you through setting up the AI Proxy plugin with a cloud-hosted model,
using the cloud's native authentication mechanism.

## Overview

When running software on a cloud-hosted virtual machine or container instance, the provider will
offer a key-less role-based access mechanism, allowing you to call services native to that cloud
provider without having to store any keys inside the running instance (or in the Kong configuration).

This operates like a single-sign-on mechanism for your cloud applications.

Kong's AI Gateway (AI-Proxy) has the capability to take advantage of the authentication mechanisms for
many different cloud providers and, where available, is also able to use this authentication to call
LLM-based services using those same methods.

## Supported Providers

Currently supported are:

| AI-Proxy LLM Provider | Cloud Provider | Type                                    |
|-----------------------|----------------|-----------------------------------------|
| `azure`               | Azure OpenAI   | [Entra / Managed Identity Authentication](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) |

Sections below outline how you would use each, with examples.

### Azure OpenAI

When hosting your LLMs with [Azure OpenAI Service](https://azure.microsoft.com/en-gb/products/ai-services/openai-service)
and running them through AI-Proxy, it is possible to use the assigned
[Azure Managed Identity or User-Assigned Identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview)
of the VM, Kubernetes service-account, or ACS container, to call the Azure OpenAI models.

You can also use an Entra principal or App Registration (`client_id`, `client_secret`, and `tenant_id` triplet) when
Kong is hosted outside of Azure.

How you do this, depends on where and how you are running the Kong gateway.

#### Prerequisite

Ensure that the Azure principal that you have assigned to the Compute resource (that is running your Kong gateway) has the necessary
Entra or IAM permissions to execute commands on the desired OpenAI instances.

Kong requires one of either:

* "Cognitive Services OpenAI User" or
* "Cognitive Services OpenAI Contributor"

[Use Azure's documention for assistance in setting this up.](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/managed-identity)

#### Configuring AI Proxy Plugin to use Azure Identity

When running Kong inside of your Azure subscription, AI Proxy is usually able to detect the designated Managed Identity or User-Assigned Identity
of that Azure Compute resource, and use it accordingly.

**To use an Azure-assigned Managed Identity, set your plugin config like this:**

```yaml
plugins:
- name: ai-proxy
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
```

**To use a User-Assigned Identity, specify its client ID like this:**

```yaml
plugins:
- name: ai-proxy
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
```

**If running outside of Azure, to use an Entra principal or App Registration, specify all properties like this:**

```yaml
plugins:
- name: ai-proxy
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
```

**Finally, you can also specify some (or all) of these properties as environment variables, for example this mix:**

```yaml
# Environment variables:
AZURE_CLIENT_SECRET="be0c34b6-b5f1-4343-99a3-140df73e0c1c"

# Plugin Config:
plugins:
- name: ai-proxy
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
```
