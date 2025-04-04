---
title: GitHub Integration
content-type: reference
beta: true

discovery_support: true
bindable_entities: "Repositories"
---

_Type: External_

The GitHub integration allows you to associate your {{site.service_catalog_name}} service to one or more GitHub repositories. 

For each linked Repository, the UI can show a **Repository Summary** with simple data pulled from the GitHub API, such as the number of open issues, open pull requests, most recently closed pull requests, languages, and more.

## Discovery information

<!-- vale off-->

{% include_cached service-catalog-discovery.html 
   discovery_support=page.discovery_support
   discovery_default=page.discovery_default
   bindable_entities=page.bindable_entities
   mechanism=page.mechanism %}

<!-- vale on-->
