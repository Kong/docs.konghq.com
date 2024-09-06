---
title: Service Catalog
subtitle: Track every service across your architecture
content-type: explanation
---

{{site.konnect_saas}}'s Service Catalog offers a comprehensive catalog of all services running in your organization. This catalog gives you insight into your organization's services and their dependencies. It includes both {{site.base_gateway}} services and external integration resources.

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
  GatewayManager[<img src="https://raw.githubusercontent.com/Kong/docs.konghq.com/main/app/assets/images/icons/kong-gradient.svg" width="15" height="15"/> Gateway Manager]:::resource

  %% Define the Konnect Service Catalog and its subgraphs
  subgraph KonnectServiceCatalog[Konnect Service Catalog]
    direction TB

    %% Define the Billing Service subgraph inside Konnect Service Catalog
    subgraph BillingService[Billing Service]
      direction LR
      KongGatewayService[Gateway service 1]
      PagerDutyServiceMapping[PagerDuty service 1]
      GitHubRepoMapping[GitHub repository 1]
    end

    %% Define the Inventory Service Catalog Service subgraph inside Konnect Service Catalog
    subgraph InventoryService[Inventory Service]
      direction LR
      SomeOtherService[Gateway service 2]
      AnotherService[PagerDuty service 2]
      DifferentRepo[GitHub repository 2]
    end

  end

  %% Connect the resources to the Konnect Service Catalog
  GitHub -- "GitHub repositories" --> KonnectServiceCatalog
  PagerDuty -- "PagerDuty services" --> KonnectServiceCatalog
  GatewayManager -- "Gateway services" --> KonnectServiceCatalog

  %% Style the subgraphs
  class KonnectServiceCatalog konnect
  class BillingService serviceCatalog
  class InventoryService serviceCatalog
{% endmermaid %}
<!-- vale on-->

> Figure 1: This diagram shows how you can use both external integrations, like GitHub and PagerDuty, as well as built-in integrations like Gateway Manager to pull resources into Service Catalog. You can then map those resources (like GitHub repositories, PagerDuty services, and Gateway services) to Service Catalog services.

## Service Catalog use cases

| You want to... | Then use... |
| -------------- | ----------- |
| Keep track of your organization's resource ownership by mapping teams to Service Catalog services. | Add the Service Catalog service's owner when you [create a new Service Catalog service in {{site.konnect_short_name}}](https://cloud.konghq.com/service-catalog/create-service) |
| Gain visibility into all your Services, including unrecognized or undiscovered APIs in your organization.  | [Service Catalog integrations](https://cloud.konghq.com/service-catalog/integrations) |
| Consolidate key Service Catalog service health metrics, documentation, and API specs into a single dashboard, allowing you to interact with other tools from one place. | [Service Catalog dashboard](https://cloud.konghq.com/service-catalog/) |

<!-- commenting this out until it's released:
| Govern how services are created and maintained across your company to adhere to security, compliance, and engineering best practices. | Scorecards |-->

## Service Catalog terminology

| Term | Definition |
| ---- | ---------- |
| Integration | These are applications, either {{site.konnect_short_name}}-internal or external, that act as sources from which you can ingest resources. For example, GitHub. |
| Resource | An umbrella term that denotes entities ingested by Service Catalog from enabled integrations. A resource can range from an infrastructural component (like Gateway services, mesh services, databases, and caches) to an external application or tool (like code repositories, CI/CD infrastructure, and on-call systems) to a piece of documentation (like API specs). Resources can be mapped to one or more Services. |
| Service Catalog service | A unit of software that is typically owned by a single team, exposes one or more APIs, and may be dependent on other Service Catalog services (as either upstream or downstream). A Service Catalog service can be thought of as a collection of one or more resources. |
| Service Catalog | A comprehensive catalog of all resources and Service Catalog services running in your organization. |

## FAQs

<details><summary>How do Service Catalog services map to API products? What is the relationship there?</summary>

{% capture service_mapping %}
Service Catalog services do not directly map to API products. Rather, a Gateway service can be mapped to a Service Catalog service and you can then map the Gateway service to an API product version in Service Catalog.
{% endcapture %}

{{ service_mapping | markdownify }}

</details>

<details><summary>How do I view the health and status of my services in the Service Catalog?</summary>

{% capture service_health %}
Navigate to **Resources** in the Service Catalog and click on the Service Catalog service you want to view the health and status of.
{% endcapture %}

{{ service_health | markdownify }}

</details>

<details><summary>How can I identify and reuse existing resources?</summary>

{% capture reuse_resources %}
Service Catalog will pull in any resources that match your specified criteria when you enable integrations. 
{% endcapture %}

{{ reuse_resources | markdownify }}

</details>

<details><summary>What should I do if I notice discrepancies in the data shown in the Service Catalog?</summary>

{% capture discrepancies %}
Check the Service Catalog integration settings and data sources for any issues. Ensure that all connected tools are properly configured and that data synchronization is functioning correctly.
{% endcapture %}

{{ discrepancies | markdownify }}

</details>

<details><summary>Can I control who has access to specific Service Catalog service or data?</summary>

{% capture service_access %}
Yes, you can configure access controls and manage permissions to Service Catalog by configuring [teams](/konnect/org-management/teams-and-roles/manage/) and [roles](/konnect/org-management/teams-and-roles/roles-reference/).
{% endcapture %}

{{ service_access | markdownify }}

</details>

## More information
* [Service Catalog integrations](/konnect/service-catalog/integrations)