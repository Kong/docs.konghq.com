---
title: Kong Konnect
subtitle: The SaaS API Platform
breadcrumb: Overview
---

## Introducing {{site.konnect_short_name}}

{{site.konnect_short_name}} is an API lifecycle
management platform designed from the ground up for the cloud native era
and delivered as a service. This platform lets you build modern applications
better, faster, and more securely. The management plane is hosted
in the cloud by Kong, while the runtime engine, {{site.base_gateway}} — Kong's
lightweight, fast, and flexible API gateway  — is managed by you within your
preferred network environment.

<p align="center">
  <img src="/assets/images/docs/konnect/dashboard/konnect-dashboard.png" />
</p>

{{site.konnect_short_name}} helps simplify multi-cloud API management by:

* Offering a single management plane to deploy and manage your APIs and microservices in any environment: cloud, on-premises, Kubernetes, and virtual machines.

* Instantly applying authentication, API security, and traffic control policies consistently across all your services using powerful enterprise and community plugins.

* Providing a real-time, centralized view of all your services. Monitor golden signals such as error rate and latency for each service and route to gain deep insights into your API products.


<div class="docs-grid-install">

  <!-- TO DO: ADD KONNECT FEATURES TABLE
   <a href="#features" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-flag.svg" alt="">
    <div class="install-text">Features</div>
  </a> -->

  <a href="https://cloud.konghq.com/quick-start" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-learning.svg" alt="">
    <div class="install-text">Get Started</div>
  </a>

  <a href="/konnect/runtime-manager/runtime-instances/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/konnect/icn-runtimes-nav.svg" alt="">
    <div class="install-text">Set up Runtime Instances</div>
  </a>

  <a href="/deck/guides/konnect/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-references-color.svg" alt="">
    <div class="install-text">Manage {{site.konnect_short_name}} with decK</div>
  </a>

  <a href="/hub/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-api-plugins-color.svg" alt="">
    <div class="install-text">Plugins</div>
  </a>
</div>
## {{site.konnect_short_name}} modules

### Service Hub

[Service Hub](/konnect/servicehub) makes internal APIs discoverable,
consumable, and reusable for internal development teams. Catalog
all your services through the Service Hub to create a single source of
truth for your organization’s service inventory. By leveraging Service Hub,
your application developers
can search, discover, and consume existing services to accelerate their
time-to-market, while enabling a more consistent end-user experience
across the organization’s applications.

[Start cataloging services with Service Hub &rarr;](/konnect/servicehub)


### Runtime Manager

[Runtime Manager](/konnect/runtime-manager/) empowers your teams to securely
collaborate and manage their own set of runtimes and services without
the risk of impacting other teams and projects. Runtime Manager instantly
provisions hosted {{site.base_gateway}} control planes and supports securely
attaching {{site.base_gateway}} data planes from your cloud or hybrid environments.

Through the Runtime Manager, increase the security of your APIs with out-of-the-box enterprise and community plugins, including OpenID Connect, Open Policy Agent, Mutual TLS, and more.

[Learn more about the Runtime Manager &rarr;](/konnect/runtime-manager/)

[Check out {{site.konnect_short_name}}-compatible plugins &rarr;](/hub)

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

[Learn more about Analytics &rarr;](/konnect/analytics)

### Teams

To help secure and govern your environment, {{site.konnect_short_name}} provides
the ability to manage authorization with [teams](/konnect/org-management/teams-and-roles/).
You can use {{site.konnect_short_name}}'s predefined teams for a standard set of roles,
or create custom teams with any roles you choose. Invite users and add them to these teams to manage user
access. You can also map groups from your existing identity provider into {{site.konnect_short_name}} teams.

[Learn more about team and user administration &rarr;](/konnect/org-management/teams-and-roles)