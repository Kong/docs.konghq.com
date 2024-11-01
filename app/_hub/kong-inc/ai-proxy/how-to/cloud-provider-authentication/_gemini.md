---
nav_title: Gemini
title: 
minimum_version: 3.8.x
---

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