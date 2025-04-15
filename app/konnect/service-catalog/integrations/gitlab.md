---
title: GitLab Integration
content-type: reference
beta: true

discovery_support: true
bindable_entities: "Projects"
---

_Type: External_

The GitLab integration allows you to associate your {{site.service_catalog_name}} service to one or more [GitLab projects](https://docs.gitlab.com/ee/user/get_started/get_started_projects.html). 

For each linked project, the UI can show a **Project Summary** with simple data pulled from the GitLab API, such as the number of open issues, open merge requests, contributors, languages, and latest releases.

## Prerequisites

* You need the [Owner GitLab role](https://docs.gitlab.com/ee/user/permissions.html) to authorize the integration. This is required for event ingestion.
* Only [GitLab.com subscriptions](https://docs.gitlab.com/ee/subscriptions/gitlab_com/) are supported at this time

## Authorize the GitLab integration
{% navtabs %}
{% navtab Saas %}
1. From the **{% konnect_icon servicehub %} Service Catalog** in {{site.konnect_product_name}}, select **[Integrations](https://cloud.konghq.com/us/service-catalog/integrations)**. 
1. Select **GitLab**, then **Install GitLab**.
1. Click **Authorize**. 

{% endnavtab %}
{% navtab Self-hosted %}
To use the GitLab integration in a self-hosted environment:

1. [Create a group-owned application](https://docs.gitlab.com/integration/oauth_provider/) in your GitLab instance. This is required to enable OAuth access for your organization.
   * Use your {{site.konnect_short_name}} instance’s  URL as the redirect URI in Gitlab.
   * Make sure the application has the `api` scope.
1. In the {{site.konnect_short_name}} UI, navigate to the [GitLab integration](https://cloud.konghq.com/us/service-catalog/integrations/gitlab/configuration)
1. In the **GitLab API Base URL** field, enter the full URL to your GitLab API, ending in `/api/v4`.  
   For example: `https://gitlab.example.com/api/v4`
1. Fill out the authorization fields using the values from your GitLab OAuth application:
   * **Client ID**: The Application ID from your GitLab app
   * **Client Secret**: The secret associated with your GitLab app
   * **Token Endpoint**: `https://{your-gitlab-host}/oauth/token`
   * **Authorization Endpoint**: `https://{your-gitlab-host}/oauth/authorize`
1. Click **Authorize** to complete the connection.
{% endnavtab %}

{% endnavtabs %}
## View GitLab specs in Service Catalog

You can map specs to a Service Catalog service and view them in {{site.konnect_short_name}}.

1. From the **{% konnect_icon servicehub %} Service Catalog** in {{site.konnect_product_name}}, select **[Services](https://cloud.konghq.com/us/service-catalog)**. 
2. Select a service, then open the **API Specs** tab.
2. Click **Add API Spec**.
3. Choose GitLab as the **Source**, then pick your spec and name it.

Once it's uploaded, you can view the rendered spec on the API Specs tab in structured (UI), YAML, or JSON format, and download it in either YAML or JSON format.

## Resources

Entity  | Description
-------|-------------
Projects | Organizes all the data for a specific development project that relates to a Service Catalog Service.

## Events

This integration supports events.

You can view the following event types for linked projects from the {{site.konnect_product_name}} UI:

* Opened merge requests
* Merged merge requests


## Discovery information

<!-- vale off-->

{% include_cached service-catalog-discovery.html 
   discovery_support=page.discovery_support
   discovery_default=page.discovery_default
   bindable_entities=page.bindable_entities
   mechanism=page.mechanism %}

<!-- vale on-->