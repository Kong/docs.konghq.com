---
title: GitHub Integration
content-type: reference
beta: true

discovery_support: true
discovery_default: true
bindable_entities: "Repositories"
mechanism: "pull/ingestion model"
---

_Type: External_

The GitHub integration allows you to associate your {{site.service_catalog_name}} service to one or more GitHub repositories. 

For each linked Repository, the UI can show a **Repository Summary** with simple data pulled from the GitHub API, such as the number of open issues, open pull requests, most recently closed pull requests, languages, and more.

## Authorize the GitHub integration

1. From the **{% konnect_icon servicehub %} Service Catalog** in {{site.konnect_product_name}}, select **[Integrations](https://cloud.konghq.com/us/service-catalog/integrations)**. 
2. Select **GitHub**, then **Install Github**.
3. Select **Authorize**. 


This will take you to GitHub where you can grant {{site.konnect_product_name}} access to either **All Repositories** or **Select repositories**. 

The {{site.konnect_product_name}} application can be managed from GitHub as a [GitHub Application](https://docs.github.com/en/apps/using-github-apps/authorizing-github-apps).

## Resources

Entity  | Description
-------|-------------
Repository | A GitHub repository relating to the service

## Events

The Eventing feature supports viewing the following event types for linked repositories from the {{site.konnect_product_name}} UI.

Event types: 

* Open pull request
* Merge pull request
* Close pull request


## Discovery information

<!-- vale off-->

{% include_cached service-catalog-discovery.html 
   discovery_support=page.discovery_support
   discovery_default=page.discovery_default
   bindable_entities=page.bindable_entities
   mechanism=page.mechanism %}

<!-- vale on-->