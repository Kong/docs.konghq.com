---
title: The Konnect Service Catalog
subtitle: Track every service across your architecture
content-type: explanation
beta: true
---

{{site.konnect_saas}}'s {{site.service_catalog_name}} offers a comprehensive catalog of all services running in your organization. By integrating with both Konnect-internal applications, like Gateway Manager and Mesh Manager, as well as external applications like GitHub and PagerDuty, {{site.service_catalog_name}} provides you with a 360 overview into each of your organization's services. It presents you with information that include who the service's owner is, its upstream and downstream dependencies, its code repositories, its CI/CD pipelines, and whether it is fronted by an API gateway or is part of a service mesh.

<!-- vale off-->
{% mermaid %}
graph LR
  %% Define styles for icons and nodes
  classDef konnect stroke-dasharray:3,rx:10,ry:10
  classDef serviceCatalog fill:#d0e5f3,rx:10,ry:10
  %% Define the resources
  ExternalIntegration1(External Integration 1):::resource
  ExternalIntegration2(External Integration 2</div>):::resource
  GatewayManager(<div style="text-align:center;"><img src="/assets/images/logos/konglogo-gradient-secondary.svg" style="max-width:25px; display:block; margin:0 auto;" class="no-image-expand"/> Gateway Manager</div>):::resource

  %% Define the Konnect Service Catalog and its subgraphs
  subgraph KonnectServiceCatalog[Konnect Service Catalog]
    direction TB

    %% Define the Billing Service subgraph inside Konnect Service Catalog
    subgraph BillingService[Billing Service]
      direction LR
      KongGatewayService(Gateway service 1)
      ExternalResourceMapping1(External resource)
      ExternalResourceMapping2(External resource)
    end

    %% Define the Inventory Service Catalog Service subgraph inside Konnect Service Catalog
    subgraph InventoryService[Inventory Service]
      direction LR
      SomeOtherService(Gateway service 2)
      AnotherService(External resource)
      DifferentRepo(External resource)
    end

  end

  %% Connect the resources to the Konnect Service Catalog
  ExternalIntegration1 -- "External resource" --> KonnectServiceCatalog
  ExternalIntegration2 -- "External resource" --> KonnectServiceCatalog
  GatewayManager -- "Gateway services" --> KonnectServiceCatalog

  %% Style the subgraphs
  class KonnectServiceCatalog konnect
  class BillingService serviceCatalog
  class InventoryService serviceCatalog
{% endmermaid %}
<!-- vale on-->

> *Figure 1: This diagram shows how you can use both external integrations, like GitHub and PagerDuty, as well as internal integrations like Gateway Manager to pull resources into Service Catalog. You can then map those resources (like GitHub repositories, PagerDuty services, and Gateway services) to Service Catalog services.*

## {{site.service_catalog_name}} use cases

| You want to... | Then use... |
| -------------- | ----------- |
| Keep track of your organization's resource ownership by mapping teams to {{site.service_catalog_name}} services. | Add the {{site.service_catalog_name}}service's owner when you [create a new {{site.service_catalog_name}} service in {{site.konnect_short_name}}](https://cloud.konghq.com/service-catalog/create-service) |
| Gain visibility into all your services, including unrecognized or undiscovered APIs in your organization.  | [{{site.service_catalog_name}} integrations](https://cloud.konghq.com/service-catalog/integrations) |
| Consolidate key {{site.service_catalog_name}} service health metrics, documentation, and API specs into a single list, allowing you to interact with other tools from one place. | [{{site.service_catalog_name}} dashboard](https://cloud.konghq.com/service-catalog/) |
| Govern how services are created and maintained across your company to adhere to security, compliance, and engineering best practices. | [Scorecards](/konnect/service-catalog/scorecards/) |

## {{site.service_catalog_name}} terminology

| Term | Definition |
| ---- | ---------- |
| Integration | These are applications, either {{site.konnect_short_name}}-internal or external, that act as sources from which you can ingest resources. For example, GitHub. |
| Resource | An umbrella term that denotes entities ingested by {{site.service_catalog_name}} from enabled integrations. A resource can range from an infrastructural component (like Gateway services, mesh services, databases, and caches) to an external application or tool (like code repositories, CI/CD infrastructure, and on-call systems) to a piece of documentation (like API specs). Resources can be mapped to one or more {{site.service_catalog_name}} services. |
| {{site.service_catalog_name}} service | A unit of software that is typically owned by a single team, exposes one or more APIs, and may be dependent on other {{site.service_catalog_name}} services (as either upstream or downstream). A {{site.service_catalog_name}} service can be thought of as a collection of one or more resources. |
| {{site.service_catalog_name}} | A comprehensive catalog of all resources and {{site.service_catalog_name}} services running in your organization. |
| Events | An [event](/konnect/service-catalog/integrations/#events) is a captured unit of information logged by the {{site.service_catalog_name}}. It includes a wide range of activities such as user-driven actions, configuration changes, and alerts. |
| Scorecards | [Scorecards](/konnect/service-catalog/scorecards/) are a compliance monitoring tool in {{site.service_catalog_name}} that assess services and [integrations](/konnect/service-catalog/integrations/) against predefined best practices, identifying gaps and providing actionable insights to improve security, reliability, and adherence to standards.|

## FAQs

<details><summary>How do Service Catalog services map to API products? What is the relationship there?</summary>

{% capture service_mapping %}
Service Catalog services do not directly map to API products. Rather, a Gateway service can be linked to a Service Catalog service and you can then map the Gateway service to an API product version in Service Catalog.
{% endcapture %}

{{ service_mapping | markdownify }}

</details>

<details><summary>How do I view the health and status of my services in the Service Catalog?</summary>

{% capture service_health %}
Navigate to **Services** in the Service Catalog and click on the Service Catalog service you want to view the health and status of.
{% endcapture %}

{{ service_health | markdownify }}

</details>

<details><summary>How can I identify which resources are available for mapping to my Service Catalog services?</summary>

{% capture reuse_resources %}
Navigate to the **Resources** page in the Service Catalog to view a list of all available resources. These are ingested by Service Catalog from the integrations that have been installed and authorized, which are found on the **Integrations** page. 
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
