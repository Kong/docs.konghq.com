---
title: Kong Gateway
breadcrumb: Overview
subtitle: API gateway built for hybrid and multi-cloud, optimized for microservices and distributed architectures
description: Kong Gateway is a lightweight, fast, and flexible cloud-native API gateway. Kong is a reverse proxy that lets you manage, configure, and route requests
konnect_cta_card: true
---

## Quick Links

<div class="docs-grid-install max-3">

  <a href="#features" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-flag.svg" alt="">
    <div class="install-text">Features</div>
  </a>

  <a href="/konnect/getting-started/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/icn-cloud-blue.svg" alt="">
    <div class="install-text">Quick Start (Cloud)</div>
  </a>

  <a href="/gateway/{{page.release}}/get-started/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-learning.svg" alt="">
    <div class="install-text">Quick Start (Docker)</div>
  </a>

  <a href="/gateway/{{page.release}}/install/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-deployment-color.svg" alt="">
    <div class="install-text">Install</div>
  </a>

  <a href="/hub/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-api-plugins-color.svg" alt="">
    <div class="install-text">Plugins</div>
  </a>

  <a href="/gateway/{{page.release}}/admin-api/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-admin-api-color.svg" alt="">
    <div class="install-text">API Reference</div>
  </a>

</div>

## Introducing {{ site.base_gateway }}

{{site.base_gateway}} is a lightweight, fast, and flexible cloud-native API
gateway. An API gateway is a reverse proxy that lets you manage, configure, and route
requests to your APIs.

{{site.base_gateway}} runs in front of any RESTful API and can be extended through
modules and plugins. It's designed to run on decentralized architectures, including
hybrid-cloud and multi-cloud deployments.

With {{site.base_gateway}}, users can:

* Leverage workflow automation and modern GitOps practices
* Decentralize applications/services and transition to microservices
* Create a thriving API developer ecosystem
* Proactively identify API-related anomalies and threats
* Secure and govern APIs/services, and improve API visibility across the
entire organization.

<blockquote class="note no-icon" id="nurture-signup">
  <p>Looking for additional help? Free training and curated content, just for you:</p>
  <form action="https://go.konghq.com/l/392112/2022-09-19/cfr97r" method="post">
    <input class="button" name="email" placeholder="you@yourcompany.com" />
    <button class="button" type="submit">Sign up now</button>
  </form>
</blockquote>

## Extending the {{site.base_gateway}}

{{site.base_gateway}} is a Lua application running in Nginx. {{site.base_gateway}}
is distributed along with [OpenResty](https://openresty.org/), which is a bundle
of modules that extend the [lua-nginx-module](https://github.com/openresty/lua-nginx-module).

This sets the foundations for a modular architecture, where
plugins can be enabled and executed at runtime. At its core,
{{site.base_gateway}} implements database abstraction, routing, and plugin
management. Plugins can live in separate code bases and be injected anywhere
into the request lifecycle, all with a few lines of code.

Kong provides many [plugins](#kong-gateway-plugins) for you to use in your
Gateway deployments. You can also create your own custom plugins. For more
information, see the
[plugin development guide](/gateway/{{page.release}}/plugin-development),
the [PDK reference](/gateway/{{page.release}}/plugin-development/pdk/), and the guide on creating plugins with other languages ([JavaScript](/gateway/{{page.release}}/plugin-development/pluginserver/javascript), [Go](/gateway/{{page.release}}/plugin-development/pluginserver/go), and [Python](/gateway/{{page.release}}/plugin-development/pluginserver/python/)).

## Packages and modes

There are two ways to deploy {{site.base_gateway}}: Managed with {{ site.konnect_saas }}, and self-managed. If you're trying
out {{site.base_gateway}} for the first time, we recommend starting with [{{ site.konnect_saas }}](https://konghq.com/products/kong-konnect/register?utm_medium=referral&utm_source=docs&utm_campaign=gateway-konnect&utm_content=gateway-mode-overview).

### {{site.konnect_short_name}}

{{site.konnect_short_name}} provides the easiest way to get started 
with {{site.base_gateway}}. 
The global control plane is hosted in the cloud by Kong, and you manage the 
individual data plane nodes within your preferred network environment.

{{site.konnect_short_name}} offers two pricing packages: 
* **Plus**: Our self-serve pay-as-you-go pricing model, giving you access to the 
{{site.konnect_short_name}} platform in its entirety while offering the flexibility 
to only pay for the services your organization uses. 

* **Enterprise**: With an Enterprise subscription,
  you have access to the entire {{ site.konnect_saas }} suite and: 

  * 24x7x365 technical support
  * Professional Services to create a purpose-built solution for your environment

For more information, visit the [pricing page](https://konghq.com/pricing).

![Introduction to {{site.base_gateway}} in {{site.konnect_short_name}}](/assets/images/products/konnect/gateway-manager/konnect-control-planes-example.png)
> _Figure 1: Diagram of {{site.base_gateway}} data planes connected to a {{site.konnect_short_name}} control plane._
> <br>
> _Requests flow from an API client into the
Gateway data planes, are modified and managed by the proxy based on your control plane
configuration, and are forwarded to upstream services._

### Self-managed

{{site.base_gateway}} is available in two different packages: Open Source (OSS) and Enterprise.

**{{site.ce_product_name}}**: An open-source package containing the basic API gateway
functionality and open-source plugins. You can manage the open-source Gateway
with Kong's [Admin API](#kong-admin-api){% if_version gte:3.4.x %}, [Kong Manager Open Source](/gateway/{{page.release}}/kong-manager-oss/),{% endif_version %} or with [declarative configuration](#deck).

**{{site.ee_product_name}}** (available in
[Free or Enterprise mode](https://konghq.com/pricing)): Kong's API gateway
with added functionality.
* <span class="badge free"></span> In **Free mode**,
  this package adds [Kong Manager](#kong-manager) to the basic open-source functionality.
* <span class="badge enterprise"></span> With an **Enterprise** subscription,
  it also includes:
    {% if_version lte:3.4.x -%}
    * [Dev Portal](#kong-dev-portal)
    * [Vitals](#kong-vitals)
    {% endif_version -%}
    * [RBAC](/gateway/api/admin-ee/latest/#/rbac/get-rbac-users)
    * [Enterprise plugins](/hub/)

You can manage {{site.ee_product_name}} in Free or Enterprise mode with Kong's
[Admin API](#kong-admin-api), [declarative configuration](#deck), or [Kong Manager](#kong-manager).

![Introduction to {{site.base_gateway}}](/assets/images/products/gateway/kong-gateway-features.png)
> _Figure 2: Diagram of {{site.base_gateway}} key features. {{site.ce_product_name}} provides basic functionality, 
while {{site.ee_product_name}} builds on top of the open-source foundation with advanced proxy features._
> <br>
> _Requests flow from an API client into the
Gateway, are modified and managed by the proxy based on your Gateway
configuration, and forwarded to upstream services._

## Features

{% include_cached feature-table.html config=site.data.tables.features.gateway %}

### Kong Admin API

[Kong Admin API](/gateway/{{page.release}}/admin-api) provides a RESTful
interface for administration and configuration of Gateway entities such as services, 
routes, plugins, consumers, and more. All of the tasks you can perform against the 
Gateway can be automated using the Kong Admin API.

### Kong Manager
{:.badge .free}

{:.note}
> **Note**: If you are running Kong in traditional mode, increased traffic could
> lead to potential performance with Kong Proxy.
> Server-side sorting and filtering large quantities of entities will also cause increased CPU usage in both Kong CP and database.


[Kong Manager](/gateway/{{page.release}}/kong-manager/) is
the graphical user interface (GUI) for {{site.base_gateway}}. It uses the Kong
Admin API under the hood to administer and control {{site.base_gateway}}.

Here are some of the things you can do with Kong Manager:

* Create new routes and services
* Activate or deactivate plugins with a couple of clicks
* Group your teams, services, plugins, consumer management, and everything else
exactly how you want them
{% if_version lte:3.4.x -%}
* Monitor performance: visualize cluster-wide, workspace-level, or
object-level health using intuitive, customizable dashboards
{% endif_version %}

{% if_version lte:3.4.x %}
### Kong Dev Portal
{:.badge .enterprise}

[Kong Dev Portal](/gateway/{{page.release}}/kong-enterprise/dev-portal/) is used to onboard new developers and to generate API documentation, create custom pages, manage API versions, and secure developer access.

### Kong Vitals
{:.badge .enterprise}

[Kong Vitals](/gateway/{{page.release}}/kong-enterprise/analytics/) provides useful metrics about the health and performance of your {{site.base_gateway}} nodes, as well as metrics about the usage of your proxied APIs. You can visually monitor vital signs and pinpoint anomalies in real-time, and use visual API analytics to see exactly how your APIs and Gateway are performing and access key statistics. Kong Vitals is part of the Kong Manager UI.
{% endif_version %}

### Kubernetes

{{site.base_gateway}} can run natively on Kubernetes with its custom [ingress controller](/kubernetes-ingress-controller/), Helm chart, and Operator. A Kubernetes ingress controller is a proxy that exposes Kubernetes services from applications (for example, Deployments, ReplicaSets) running on a Kubernetes cluster to client applications running outside of the cluster. The intent of an ingress controller is to provide a single point of control for all incoming traffic into the Kubernetes cluster.

### {{site.base_gateway}} plugins

[{{site.base_gateway}} plugins](/hub/) provide advanced functionality to better manage your API and microservices. With turnkey capabilities to meet the most challenging use cases, {{site.base_gateway}} plugins ensure maximum control and minimizes unnecessary overhead. Enable features like authentication, rate-limiting, and transformations by enabling {{site.base_gateway}} plugins through Kong Manager or the Admin API.

## Tools
Kong also provides API lifecycle management tools that you can use with {{site.base_gateway}}.

### Insomnia

[Insomnia](https://docs.insomnia.rest) enables spec-first development for all REST and GraphQL services. With Insomnia, organizations can accelerate design and test workflows using automated testing, direct Git sync, and inspection of all response types. Teams of all sizes can use Insomnia to increase development velocity, reduce deployment risk, and increase collaboration.

### decK
[decK](/deck/) helps manage {{site.base_gateway}}’s configuration in a declarative fashion.
This means that a developer can define the desired state of {{site.base_gateway}} or
{{site.konnect_short_name}} &ndash; services, routes, plugins, and more &ndash; and let decK handle
implementation without needing to execute each step manually, as you would with
the Kong Admin API.


## Get started with {{site.base_gateway}}

[Download and install {{site.base_gateway}}](/gateway/{{page.release}}/install/).
To test it out, you can choose either the open-source package, or
run {{site.ee_product_name}} in free mode and also try out Kong Manager.

After installation, get started with the introductory [quickstart guide](/gateway/{{page.release}}/get-started/).

### Try in {{site.konnect_short_name}}

[{{site.konnect_product_name}}](/konnect/) can manage {{site.base_gateway}}
instances. With this setup, Kong hosts the control plane and you host your
own data planes.

There are a few ways to test out the Gateway's Enterprise features:

* Sign up for [{{site.konnect_product_name}}](https://konghq.com/products/kong-konnect/register?utm_medium=referral&utm_source=docs&utm_campaign=gateway-konnect&utm_content=gateway-overview).
* Check out learning labs at [Kong Academy]({{site.links.learn}}).
* If you are interested in evaluating Enterprise features locally,
[request a demo](https://konghq.com/get-started/#request-demo) and a Kong
representative will reach out with details to get you started.

## Support policy
Kong follows a structured approach to versioning its products.

For the latest version support information for {{site.ee_product_name}} and
{{site.mesh_product_name}}, see the [version support policy](/gateway/{{page.release}}/support-policy/).
