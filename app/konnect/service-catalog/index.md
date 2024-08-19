---
title: Service catalog
subtitle: Track every service across your architecture
content-type: explanation
---

{{site.konnect_saas}}'s Service Catalog offers a comprehensive catalog of all services running in your organization, both {{site.base_gateway}} services and external integration resources.

<!-- vale off-->
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
<!-- vale on-->

> Figure 1: This diagram shows how you can use both external integrations, like GitHub and PagerDuty, as well as built-in integrations like {{site.base_gateway}} to pull resources into Service Catalog. You can then map those resources (like GitHub repositories, PagerDuty services, and {{site.base_gateway}} services) to Service Catalog Services.

## Service Catalog use cases

| You want to... | Then use... |
| -------------- | ----------- |
| Keep track of your organization's service ownership by mapping teams to services. | [{{site.konnect_short_name}} Organization Teams](https://cloud.konghq.comorganization/teams) |
| Gain visibility into all your services, including unrecognized or undiscovered APIs in your organization.  | [Service Catalog integrations](https://cloud.konghq.com/servicehub/integrations) |
| Consolidate key service health metrics into a single dashboard, allowing you to interact with other tools from one place. | [Service Catalog dashboard](https://cloud.konghq.com/servicehub) |
| Govern how services are created and maintained across your company to adhere to security, compliance, and engineering best practices. | ? |

## Service Catalog terminology

| Term | Definition |
| ---- | ---------- |
| Integration | These are applications, either internal {{site.konnect_short_name}} applications or external applications, from which you can ingest data. For example, GitHub. |
| Resource | Resources are entities that are injested from integrations. For example, a GitHub repository. |
| Service | A Service is a collection of resources in the Service Catalog. It represents what you might consider a “service”, typically defined as an independent system delivering specific capabilities and owned by a singular team in your organization. It is *not* the same as a {{site.base_gateway}} [service](/gateway/latest/key-concepts/services/). For example, a Service Catalog Service could have 10 {{site.base_gateway}} services, a GitHub repository, and several PagerDuty services mapped to it. |
| Service Catalog | A comprehensive catalog of all resources and Services running in your organization. |

## FAQs

<details><summary>How do Services map to API products? What is the relationship there?</summary>
{% capture service_mapping %}
Service Catalog Services do not directly map to API products. Rather, a {{site.base_gateway}} service can be mapped to a Service Catalog Service and you can then map the {{site.base_gateway}} service to an API product version in Service Catalog.
{% endcapture %}

{{ konnect_concepts | markdownify }}

</details>

<details><summary>How do I view the health and status of my services in the Service Catalog?</summary>
{% capture service_mapping %}
Navigate to **Resources** in the Service Catalog and click on the service you want to view the health and status of.
{% endcapture %}

{{ konnect_concepts | markdownify }}

</details>

<details><summary>How can I identify and reuse existing Resources?</summary>
{% capture service_mapping %}
Service Catalog will pull in any Resources that match your specified criteria when you enable integrations. 
{% endcapture %}

{{ konnect_concepts | markdownify }}

</details>

<details><summary>What should I do if I notice discrepancies in the data shown in the Service Catalog?</summary>
{% capture service_mapping %}
Check the Service Catalog integration settings and data sources for any issues. Ensure that all connected tools are properly configured and that data synchronization is functioning correctly.
{% endcapture %}

{{ konnect_concepts | markdownify }}

</details>

<details><summary>Can I control who has access to specific Services or data in the Service Catalog?</summary>
{% capture service_mapping %}
Yes, you can configure access controls and manage permissions to Service Catalog by configuring [teams](/konnect/org-management/teams-and-roles/manage/) and [roles](/konnect/org-management/teams-and-roles/roles-reference/).
{% endcapture %}

{{ konnect_concepts | markdownify }}

</details>

## More information
* [Service Catalog integrations](/konnect/service-catalog/integrations)