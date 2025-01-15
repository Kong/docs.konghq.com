---
title: GitLab Integration
content-type: reference
beta: true

discovery_support: true
discovery_default: true
bindable_entities: "Projects"
mechanism: "pull/ingestion model"
---

_Type: External_

The GitLab integration allows you to associate your {{site.service_catalog_name}} service to one or more [GitLab projects](https://docs.gitlab.com/ee/user/get_started/get_started_projects.html). 

For each linked Project, the UI can show a **Project Summary** with simple data pulled from the GitLab API, such as the number of open issues, open merge requests, contributors, languages, and latest releases.

## Prerequisites

* You need the [Owner GitLab role](https://docs.gitlab.com/ee/user/permissions.html) to authorize the integration. This is required for event injestion.
* Only [GitLab.com subscriptions](https://docs.gitlab.com/ee/subscriptions/gitlab_com/) are supported at this time

## Authorize the GitLab integration

1. From the **{% konnect_icon servicehub %} Service Catalog** in {{site.konnect_product_name}}, select **[Integrations](https://cloud.konghq.com/us/service-catalog/integrations)**. 
2. Select **GitLab**, then **Install GitLab**.
3. Select **Authorize**. 

## View GitLab specs in Service Catalog

You can map specs to a Service Catalog service and view them in {{site.konnect_short_name}}.

1. From the **{% konnect_icon servicehub %} Service Catalog** in {{site.konnect_product_name}}, select **[Services](https://cloud.konghq.com/us/service-catalog)**. 
2. Select a service, then open the **API Specs** tab.
2. Select **Add API Spec**.
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