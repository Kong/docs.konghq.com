---
title: Service catalog
subtitle: Track every service across your architecture
content-type: explanation
---

{{site.konnect_saas}}'s Service Catalog offers a comprehensive catalog of all services running in your organization, both {{site.base_gateway}} services and external services. This catalog is the single source of truth for your organization’s service inventory and their dependencies.

{% mermaid %}
graph TD
    subgraph "Built-In Integrations"
        D[{{site.base_gateway}}]
        E[{{site.mesh_product_name}}]
        F[{{site.konnect_short_name}} Analytics]
        G[API Products]
    end

    subgraph "External Integrations"
        H[GitHub]
        I[PagerDuty]
    end

    D -->A[{{site.konnect_short_name}} Service Catalog]
    E -->A
    F -->A
    G -->A

    H -->A
    I -->A
{% endmermaid %}

> Figure 1: This diagram shows how you can pull services from built-in integrations (like {{site.base_gateway}}, {{site.mesh_product_name}}, {{site.konnect_short_name}} Analytics, and API Products) and external services (like from GitHub and PagerDuty) into the Service Catalog. This consolidates all your organization's services and service health metrics into a single view.

Specifically, Service Catalog addresses the following problems:

* **Service discovery:** Gain visibility into all your services, including unrecognized or undiscovered APIs that live in your organization’s fragmented ecosystems. 
* **Service ownership:** Keep track of your organization's service ownership by mapping teams and services. 
* **Service health:** The Service Catalog consolidates key service health metrics into a single view, so you no longer need to check multiple tools (like GitHub and PagerDuty) for recent activity and status. It also helps you quickly identify and reuse existing services, reducing duplication and effort.
* **Service governance and policy enforcement:** Enables governance in how services are created and maintained across your company to ensure you adhere to security, compliance, and engineering best practices.

{% mermaid %}
graph TD
    subgraph "{{site.konnect_short_name}} Service Catalog"
        SC[Service Catalog]
        SG[{{site.base_gateway}} Service]
        API[API Product]
    end

    subgraph "External APIs"
        GitHub[GitHub]
        PagerDuty[PagerDuty]
        Data[External API Data]
    end

    GitHub -->|Pulls Service| SC
    PagerDuty -->|Pulls Service| SC
    SC -->|Maps to| SG
    SC -->|Maps to| API
    SC -->|Collects Data from| Data
    Data -->|Reports to| SC
{% endmermaid %}

> Figure 2: This diagram shows how you can map services from one source, like GitHub, to another, such as a {{site.base_gateway}} service, in Service Catalog. Service Catalog also shows you how your services interact with external APIs.

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