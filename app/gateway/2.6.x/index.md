---
title: Kong Gateway
subtitle: API gateway built for hybrid and multi-cloud, optimized for microservices and distributed architectures
---

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
entire organization

## Extending the Kong Gateway

{{site.base_gateway}} is a Lua application running in Nginx. {{site.base_gateway}}
is distributed along with [OpenResty](https://openresty.org/), which is a bundle
of modules that extend the [lua-nginx-module](https://github.com/openresty/lua-nginx-module).

This sets the foundations for a modular architecture, where Lua scripts
(plugins) can be enabled and executed at runtime. At its core,
{{site.base_gateway}} implements database abstraction, routing, and plugin
management. Plugins can live in separate code bases and be injected anywhere
into the request lifecycle, all with a few lines of code.

## Packages and modes

{{site.base_gateway}} is available in the following modes:

**Kong Gateway (OSS)**: an open-source package containing the basic API gateway
functionality and open-source plugins. You can manage the open-source Gateway
with Kong's [Admin API](#kong-admin-api) or with [declarative configuration](#deck).

**Kong Gateway** (available in
[Free or Enterprise modes](https://konghq.com/pricing)): Kong's API gateway
with added functionality.
* In **Free mode** (<span class="badge free"></span>),
  this package adds [Kong Manager](#kong-manager) to the basic open-source functionality.
* With an **Enterprise** subscription (<span class="badge enterprise"></span>),
  it also includes:
    * [Dev Portal](#kong-dev-portal)
    * [Vitals](#kong-vitals)
    * [Immunity](#kong-immunity)
    * [RBAC](/gateway/{{page.kong_version}}/admin-api/rbac/reference)
    * [Enterprise plugins](/hub/)

You can manage {{site.base_gateway}} in Free or Enterprise mode with Kong's
[Admin API](#kong-admin-api), [declarative configuration](#deck), or [Kong Manager](#kong-manager).

This package is also available as part of
[{{site.konnect_product_name}}](/konnect/).

![Introduction to {{site.base_gateway}}](/assets/images/docs/gateway/gateway_overview.png)
> _Figure 1: Diagram of {{site.base_gateway}} modules and how they relate to the
foundational Gateway components._
> <br>
> _Requests flow from an API client into the
Gateway, are modified and managed by the proxy based on your Gateway
configuration, and forwarded to upstream services._

## Features

### Kong Admin API

[Kong Admin API](/gateway/{{page.kong_version}}/admin-api) provides a RESTful interface for administration and configuration of Services, Routes, Plugins, and Consumers. All of the tasks you perform in the Kong Manager can be automated using the Kong Admin API.

### Kong Manager
{:.badge .free}

[Kong Manager](/gateway/{{page.kong_version}}/configure/auth/kong-manager) is
the graphical user interface (GUI) for {{site.base_gateway}}. It uses the Kong
Admin API under the hood to administer and control {{site.base_gateway}}.

Here are some of the things you can do with Kong Manager:

* Create new Routes and Services
* Activate or deactivate plugins with a couple of clicks
* Group your teams, services, plugins, consumer management, and everything else
exactly how you want them
* Monitor performance: visualize cluster-wide, workspace-level, or
object-level health using intuitive, customizable dashboards

### Kong Dev Portal
{:.badge .enterprise}

[Kong Dev Portal](/gateway/{{page.kong_version}}/developer-portal) is used to onboard new developers and to generate API documentation, create custom pages, manage API versions, and secure developer access.

### Kong Immunity
{:.badge .enterprise}

[Kong Immunity](/gateway/{{page.kong_version}}/immunity) uses machine learning to autonomously identify service behavior anomalies in real-time to improve security, mitigate breaches, and isolate issues. Use Kong Immunity to autonomously identify service issues with machine learning-powered anomaly detection.

### Kong Vitals
{:.badge .enterprise}

[Kong Vitals](/gateway/{{page.kong_version}}/vitals) provides useful metrics about the health and performance of your {{site.base_gateway}} nodes, as well as metrics about the usage of your proxied APIs. You can visually monitor vital signs and pinpoint anomalies in real-time, and use visual API analytics to see exactly how your APIs and Gateway are performing and access key statistics. Kong Vitals is part of the Kong Manager UI.

### Kubernetes Ingress Controller

[Kong for Kubernetes Enterprise](/kubernetes-ingress-controller/) (K4K8S) is a Kubernetes Ingress Controller. A Kubernetes Ingress Controller is a proxy that exposes Kubernetes services from applications (for example, Deployments, ReplicaSets) running on a Kubernetes cluster to client applications running outside of the cluster. The intent of an Ingress Controller is to provide a single point of control for all incoming traffic into the Kubernetes cluster.

### Kong plugins

[{{site.base_gateway}} plugins](/hub/) provide advanced functionality to better manage your API and microservices. With turnkey capabilities to meet the most challenging use cases, {{site.base_gateway}} plugins ensure maximum control and minimizes unnecessary overhead. Enable features like authentication, rate-limiting, and transformations by enabling {{site.base_gateway}} plugins through Kong Manager or the Admin API.

## Tools
Kong also provides API lifecycle management tools that you can use with {{site.base_gateway}}.

### Insomnia

[Insomnia](https://docs.insomnia.rest) enables spec-first development for all REST and GraphQL services. With Insomnia, organizations can accelerate design and test workflows using automated testing, direct Git sync, and inspection of all response types. Teams of all sizes can use Insomnia to increase development velocity, reduce deployment risk, and increase collaboration.

### decK
[decK](/deck) helps manage {{site.base_gateway}}’s configuration in a declarative fashion.
This means that a developer can define the desired state of Kong Gateway or
Konnect &ndash; services, routes, plugins, and more &ndash; and let decK handle
implementation without needing to execute each step manually, as you would with
the Kong Admin API.


## Get started with Kong Gateway

[Download and install Kong Gateway](/gateway/{{page.kong_version}}/install-and-run).
To test it out, you can choose either the open-source package, or
run Kong Gateway in free mode and also try out Kong Manager.

After installation, get started with one of our introductory guides:
* **[Quickstart](/gateway/{{page.kong_version}}/get-started/quickstart)**: An introduction to
{{site.base_gateway}}, common objects, and basic Admin API commands.
* **[Getting started guide](/gateway/{{page.kong_version}}/get-started/comprehensive)**:
The complete {{site.base_gateway}}
getting started guide provides in-depth examples, explanations, and step-by-step
instructions, and explores Kong's many available tools for managing the gateway.

### Try in Konnect

{{site.base_gateway}} is also bundled with {{site.konnect_product_name}}.
There are a few ways to test out the gateway's Plus or Enterprise features:

* Sign up for a [free trial of {{site.konnect_product_name}} Plus](https://konnect.konghq.com/register).
* Try out {{site.base_gateway}} on Kubernetes using a live tutorial at
[https://www.konglabs.io/kubernetes/](https://www.konglabs.io/kubernetes/).
* If you are interested in evaluating Enterprise features locally, the
Kong sales team manages evaluation licenses as part of a formal sales process.
The best way to get started with the sales process is to
[request a demo](https://konghq.com/get-started/#request-demo) and indicate
your interest.

## Support policy
Kong primarily follows a [semantic versioning](https://semver.org/) (SemVer)
model for its products.

For the latest version support information for {{site.ee_product_name}} and
{{site.mesh_product_name}}, see our [version support policy](/konnect-platform/support-policy).
