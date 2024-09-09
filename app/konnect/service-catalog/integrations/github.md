---
title: GitHub Integration
content-type: reference
---

_Type: External_

The GitHub integration allows you to associate your Service Catalog service to one or more GitHub repositories. 

For each linked Repository, the UI can show a **Repository Summary** with simple data pulled from the github API, such as number of open issues, open pull requests, most recently closed pull requests, languages, and more.


## Authorize the GitHub application

1. From {{site.konnect_product_name}} select **[Integrations](https://cloud.konghq.com/us/service-catalog/integrations)**. 
2. Select **Github**, then **Install Github**.
3. Select **Authorize**. 

This will take you to Github where you can grant {{site.konnect_product_name}} access to either **All Repositories** or **Select repositories**. 

The {{site.konnect_product_name}} application can be managed from Github as a [Github Application](https://docs.github.com/en/apps/using-github-apps/authorizing-github-apps).

## Bindable Entities

Entity | Binding Level | Description
-------|---------------|-------------
Repository | Service | A GitHub repository relating to the service


## Discovery FAQs

| **Question**                                     | **Answer**                      |
|--------------------------------------------------|----------------------------------|
| Is discovery supported by this integration?      | Yes.                            |
| Is discovery enabled by default?                 | Yes.                            |
| What bindable entities can be discovered?        | Repositories.                   |
| What mechanism is used for discovery?            | Pull/Ingestion model.           |




