---
title: Kong Konnect
subtitle: The SaaS API Platform
breadcrumb: Overview
---

## Introducing {{site.konnect_short_name}}

{{site.konnect_short_name}} is an API lifecycle
management platform designed from the ground up for the cloud native era
and delivered as a service. This platform lets you build modern applications
better, faster, and more securely. The control plane is hosted
in the cloud by Kong, while you can choose to either host the data plane yourself in your preferred network environment or let Kong manage it for you in the cloud. All of this is powered by {{site.base_gateway}} — Kong's
lightweight, fast, and flexible API gateway. 

<p align="center">
  <img src="/assets/images/products/konnect/dashboard/konnect-dashboard.png" alt="Konnect's dashboard screenshot" />
</p>

{{site.konnect_short_name}} helps simplify multi-cloud API management by:

* Offering the control plane to deploy and manage your APIs and microservices in any environment: cloud, on-premises, Kubernetes, and virtual machines.

* Instantly applying authentication, API security, and traffic control policies consistently across all your services using powerful enterprise and community plugins.

* Providing a real-time, centralized view of all your services. Monitor golden signals such as error rate and latency for each service and route to gain deep insights into your API products.

* Control which [geographic region](/konnect/geo) the universal API control plane is operated in. AU, EU, and US geos are currently supported. This allows you to operate {{site.konnect_short_name}} in a similar geographic region to your end-users, as well as ensure data privacy and regulatory compliance.


<div class="docs-grid-install">

  <!-- TO DO: ADD KONNECT FEATURES TABLE
   <a href="#features" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-flag.svg" alt="">
    <div class="install-text">Features</div>
  </a> -->

  <a href="https://konghq.com/products/kong-konnect/register?utm_medium=referral&utm_source=docs&utm_campaign=gateway-konnect&utm_content=konnect-getting-started" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-flag.svg" alt="">
    <div class="install-text">Sign up for {{site.konnect_short_name}}</div>
  </a>

  <a href="/konnect/getting-started/add-api" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-admin-api-color.svg" alt="">
    <div class="install-text">Add an API to {{site.konnect_short_name}}</div>
  </a>

  <a href="/konnect/getting-started/import" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-deployment-color.svg" alt="">
    <div class="install-text">Import {{site.base_gateway}} entities to {{site.konnect_short_name}}</div>
  </a>

  <a href="/hub/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-api-plugins-color.svg" alt="">
    <div class="install-text">Plugins</div>
  </a>
</div>
## {{site.konnect_short_name}} modules

### {{site.service_catalog_name}}

The [{{site.service_catalog_name}}](/konnect/service-catalog) makes internal APIs discoverable,
consumable, and reusable for internal development teams. You can use the {{site.service_catalog_name}} to monitor
all your services and create a single source of
truth for your organization’s service inventory. By leveraging the {{site.service_catalog_name}},
your application developers
can search, discover, and consume existing services to accelerate their
time-to-market, while enabling a more consistent end-user experience
across the organization’s applications.

[Start cataloging services &rarr;](/konnect/service-catalog)


### Gateway Manager

[Gateway Manager](/konnect/gateway-manager/) instantly
provisions a hosted {{site.base_gateway}} control plane and supports securely
attaching self-hosted or [managed](/konnect/gateway-manager/dedicated-cloud-gateways/) data planes.

Through the Gateway Manager, increase the security of your APIs with out-of-the-box enterprise and community plugins, including OpenID Connect, Open Policy Agent, Mutual TLS, and more.

[Learn more about the Gateway Manager &rarr;](/konnect/gateway-manager/)

[Check out {{site.konnect_short_name}}-compatible plugins &rarr;](/hub)

### Mesh Manager 

[Mesh Manager](https://cloud.konghq.com/mesh-manager) in {{site.konnect_product_name}} allows you to create, manage, and view your {{site.mesh_product_name}} service meshes using the {{site.konnect_short_name}} platform. Mesh Manager is ideal for organizations who want to have one or more global control planes that allow you to run your mesh deployments across multiple zones. You can run a mix of Kubernetes and Universal zones. Your mesh deployment environments can include multiple isolated meshes for multi-tenancy, with workloads running in different regions, on different clouds, or in different data-centers.

[Learn more about Mesh Manager &rarr;](/konnect/mesh-manager/)

### API Products

Use API Products to bundle and manage multiple services via API products. You can use API products to version your services as well as upload documentation for your API product. This allows you to prepare to productize your services by publishing your API products to Dev Portal.
[Start productizing services with API Products &rarr;](/konnect/api-products)

### Dev Portal

Streamline developer onboarding with the [Dev Portal](/konnect/dev-portal/), which offers a self-service developer experience
to discover, register, and consume published API products from your API Products catalog.
This customizable experience can be used to match your own unique branding and
highlights the documentation and interactive API specifications of your services.
Enable application registration to automatically secure your APIs with a
 variety of authorization providers.

[Learn more about the Dev Portal &rarr;](/konnect/dev-portal)

### Analytics

Use [Analytics](/konnect/analytics/) to gain deep insights
into service, route, and application usage and health monitoring data. Keep your finger
on the pulse of the health of your API products with custom reports and contextual dashboards.
In addition, you can enhance the native monitoring and analytics capabilities with
{{site.base_gateway}} plugins that enable streaming monitoring metrics to
third-party analytics providers, such as Datadog and Prometheus.

{{site.konnect_short_name}} Analytics provides pre-built custom reports to all new organizations. These reports contains common examples for important key performance indicators (KPIs) to keep track of while monitoring the success of your APIs. Users are free to modify them, and use them as a base to start their own analytics reports.

[Learn more about Analytics &rarr;](/konnect/analytics)

### Teams

To help secure and govern your environment, {{site.konnect_short_name}} provides
the ability to manage authorization with [teams](/konnect/org-management/teams-and-roles/).
You can use {{site.konnect_short_name}}'s predefined teams for a standard set of roles,
or create custom teams with any roles you choose. Invite users and add them to these teams to manage user
access. You can also map groups from your existing identity provider into {{site.konnect_short_name}} teams.

[Learn more about team and user administration &rarr;](/konnect/org-management/teams-and-roles)
