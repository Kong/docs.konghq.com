---
title: Service catalog
subtitle: Track every service across your architecture
content-type: explanation
---

{{site.konnect_saas}}'s Service Catalog offers a comprehensive catalog of all services running in your organization, both {{site.base_gateway}} services and external services. This catalog is the single source of truth for your organization’s service inventory and their dependencies.

Specifically, Service Catalog addresses the following problems:

* **Service discovery:** Gain visibility into all your services, including unrecognized or undiscovered APIs that live in your organization’s fragmented ecosystems. 
* **Service ownership:** Keep track of your organization's service ownership by mapping teams and services. 
* **Service health:** The Service Catalog consolidates key service health metrics into a single view, so you no longer need to check multiple tools (like GitHub and PagerDuty) for recent activity and status. It also helps you quickly identify and reuse existing services, reducing duplication and effort.
* **Service governance and policy enforcement:** Enables governance in how services are created and maintained across your company to ensure you adhere to security, compliance, and engineering best practices.

{% mermaid %}
graph LR
  %% Define styles for icons and nodes
  classDef integration fill:#f7f7f7,stroke:#333,stroke-width:2px;
  classDef resource fill:#e1f7d5,stroke:#333,stroke-width:2px;
  classDef konnect fill:#d0e5ff,stroke:#333,stroke-width:2px;
  classDef serviceCatalog fill:#e1f7d5,stroke:#333,stroke-width:2px;
  classDef billingInventory fill:#f0f0f0,stroke:#333,stroke-width:2px;

  %% Define the resources
  GitHub[<img src="https://img.icons8.com/ios/50/000000/github.png" width="24" height="24"/> GitHub]:::resource
  PagerDuty[<img src="https://play-lh.googleusercontent.com/E-zhAf4KJ6JDDXmQfQxBprn2sATGYUMkOEqLQX5HAQQtiwDZJg4c8sQd7deb6nCZCwU=w480-h960-rw" width="24" height="24"/> PagerDuty]:::resource
  KongGateway[<img src="https://raw.githubusercontent.com/Kong/docs.konghq.com/main/app/assets/images/icons/kong-gradient.svg" width="15" height="15"/> Kong Gateway]:::resource

  %% Define the Konnect Service Catalog and its subgraphs
  subgraph KonnectServiceCatalog[Konnect Service Catalog]
    direction TB

    %% Define the Billing Service subgraph inside Konnect Service Catalog
    subgraph BillingService[Billing Service]
      direction LR
      KongGatewayService[Kong Gateway service 1]
      PagerDutyServiceMapping[PagerDuty service 1]
      GitHubRepoMapping[GitHub repository 1]
    end

    %% Define the Inventory Service Catalog Service subgraph inside Konnect Service Catalog
    subgraph InventoryService[Inventory Service]
      direction LR
      SomeOtherService[Kong Gateway service 2]
      AnotherService[PagerDuty service 2]
      DifferentRepo[GitHub repository 2]
    end

  end

  %% Connect the resources to the Konnect Service Catalog
  GitHub -- "GitHub repositories" --> KonnectServiceCatalog
  PagerDuty -- "PagerDuty services" --> KonnectServiceCatalog
  KongGateway -- "Kong Gateway services" --> KonnectServiceCatalog

  %% Style the subgraphs
  class KonnectServiceCatalog konnect
  class BillingService serviceCatalog
  class InventoryService serviceCatalog
{% endmermaid %}

> Figure 1: This diagram shows how you can use both external integrations, like GitHub and PagerDuty, as well as built-in integrations like {{site.base_gateway}} to pull resources into Service Catalog. You can then map those resources (like GitHub repositories, PagerDuty services, and {{site.base_gateway}} services) to Service Catalog Services.

## Service Catalog terminology

| Term | Definition |
| ---- | ---------- |
| Service Catalog | The canonical system of record for your organization's services in {{site.konnect_short_name}}. This includes all the interactions between them and with external APIs. |
| [Service](/gateway/latest/key-concepts/services/) | A service is the top-level entity in the Service Catalog. It typically represents an external upstream API or microservice that's owned by a singular team in your organization. For example, a data transformation microservice, a billing API, and so on. |
| Integration | These are application integrations, either internal {{site.konnect_short_name}} applications or external applications. When enabled, an integration serves one of two purposes:<ul><li>Allows you to discover new Resources and subsequently create new services based on them. For example: creating a new {{site.konnect_short_name}} service called “Billing” from a GitHub Repository called “billing-repo-public”. In this case, the integration is GitHub and the Resource is the GitHub Repository called “billing-repo-public”.</li><li>Allows you to add helpful contextual information to a service that already exists in your catalog. For example: binding a {{site.base_gateway}} service called “trigger-payment” to a Service Catalog service. In this case, the integration is “Gateway Manager” and the Resource is the “trigger-payment” {{site.base_gateway}} service.</li> |
| Resource | A Resource represents an entity discovered from an integration that can be mapped to any number of services. For example: a {{site.base_gateway}} or GitHub service. |

## FAQs

<details><summary>How do services map to API products? What is the relationship there?</summary>
{% capture service_mapping %}
info here 
{% endcapture %}

{{ konnect_concepts | markdownify }}

</details>

<details><summary>How do I view the health and status of my services in the Service Catalog?</summary>
{% capture service_mapping %}
Navigate to **Resources** in the Service Catalog and click on the service you want to view the health and status of.
{% endcapture %}

{{ konnect_concepts | markdownify }}

</details>

<details><summary>How can I identify and reuse existing services?</summary>
{% capture service_mapping %}
Service Catalog will pull in any services that match your specified criteria when you enable integrations. 
{% endcapture %}

{{ konnect_concepts | markdownify }}

</details>

<details><summary>What should I do if I notice discrepancies in the data shown in the Service Catalog?</summary>
{% capture service_mapping %}
Check the Service Catalog integration settings and data sources for any issues. Ensure that all connected tools are properly configured and that data synchronization is functioning correctly.
{% endcapture %}

{{ konnect_concepts | markdownify }}

</details>

<details><summary>Can I control who has access to specific services or data in the Service Catalog?</summary>
{% capture service_mapping %}
Yes, you can configure access controls and manage permissions to Service Catalog by configuring [teams](/konnect/org-management/teams-and-roles/manage/) and [roles](/konnect/org-management/teams-and-roles/roles-reference/).
{% endcapture %}

{{ konnect_concepts | markdownify }}

</details>

## More information
* [Publish an API to Dev Portal](/konnect/api-products/productize-service/) - Learn how to create an API product, associate it with your service, and publish it to the Dev Portal.
* [Create a Dev Portal](/konnect/dev-portal/create-dev-portal/) - Learn more about Dev Portal and how to create one.