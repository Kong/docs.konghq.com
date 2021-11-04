---
title: Kong Gateway
subtitle: API gateway built for hybrid and multi-cloud, optimized for microservices and distributed architectures
---

{{site.base_gateway}} is a lightweight, fast, and flexible cloud-native API gateway. It’s easy to download, install, and configure to get up and running once you know the basics. The gateway runs in front of any RESTful API and is extended through modules and plugins which provide extra functionality beyond the core platform.

{{site.base_gateway}} is a Lua application running in Nginx and made possible by the [lua-nginx-module](https://github.com/openresty/lua-nginx-module). Instead of compiling Nginx with this module, {{site.base_gateway}} is distributed along with [OpenResty](https://openresty.org/), which already includes lua-nginx-module.
<!-- OpenResty is *not* a fork of Nginx, but a bundle of modules extending its capabilities. -->

This sets the foundations for a modular architecture, where Lua scripts (referred to as *plugins*) can be enabled and executed at runtime. At its core, {{site.base_gateway}} implements database abstraction, routing, and plugin management. Plugins can live in separate code bases and be injected anywhere into the request lifecycle, all with a few lines of code.

{{site.base_gateway}} is designed to run on decentralized architectures, leveraging workflow automation and modern GitOps practices. With {{site.base_gateway}}, users can:

* Decentralize applications/services and transition to microservices
* Create a thriving API developer ecosystem
* Proactively identify API-related anomalies and threats
* Secure and govern APIs/services, and improve API visibility across the entire organization

{{site.base_gateway}} is a combination of several features and modules built on top of the open-sourced {{site.base_gateway}}, as shown in the diagram and described under [{{site.base_gateway}} features](#kong-gateway-enterprise-features).


## Kong Gateway vs Kong Gateway (OSS)

[REWRITE ALL OF THIS]
{{site.base_gateway}} is Kong's API gateway with enterprise functionality. As part of [{{site.konnect_product_name}}](/konnect/), the gateway brokers an organization’s information across all services by allowing customers to manage the full lifecycle of services and APIs. On top of that, it enables users to simplify the management of APIs and microservices across hybrid-cloud and multi-cloud deployments.

![Introduction to {{site.base_gateway}}](/assets/images/docs/ee/introduction.png)
[DESCRIPTION FOR DIAGRAM]

## Kong Gateway features

### Kong Admin API

[Kong Admin API](/link) provides a RESTful interface for administration and configuration of Services, Routes, Plugins, and Consumers. All of the tasks you perform in the Kong Manager can be automated using the Kong Admin API.

### Kong Dev Portal
{:.badge .enterprise}

[Kong Dev Portal](/link) is used to onboard new developers and to generate API documentation, create custom pages, manage API versions, and secure developer access.

### Kong Immunity
{:.badge .enterprise}

[Kong Immunity](/link) uses machine learning to autonomously identify service behavior anomalies in real-time to improve security, mitigate breaches and isolate issues. Use Kong Immunity to autonomously identify service issues with machine learning-powered anomaly detection.

### Kubernetes Ingress Controller

[Kong for Kubernetes Enterprise](/link) (K4K8S) is a Kubernetes Ingress Controller. A Kubernetes Ingress Controller is a proxy that exposes Kubernetes services from applications (for example, Deployments, ReplicaSets) running on a Kubernetes cluster to client applications running outside of the cluster. The intent of an Ingress Controller is to provide a single point of control for all incoming traffic into the Kubernetes cluster.

### Kong Manager
{:.badge .free}

Kong Manager is the graphical user interface (GUI) for {{site.base_gateway}}. It uses the Kong Admin API under the hood to administer and control {{site.ce_product_name}}.

Here are some of the things you can do with Kong Manager:

* Create new Routes and Services.
* Activate or deactivate plugins with a couple of clicks.
* Group your teams, services, plugins, consumer management, and everything else exactly how you want them.
* Monitor performance: visualize cluster-wide, workspace-level, or even object-level health using intuitive, customizable dashboards.

### Kong plugins

[{{site.base_gateway}} plugins](/link) provide advanced functionality to better manage your API and microservices. With turnkey capabilities to meet the most challenging use cases, {{site.base_gateway}} plugins ensure maximum control and minimizes unnecessary overhead. Enable features like authentication, rate-limiting, and transformations by enabling {{site.base_gateway}} plugins through Kong Manager or the Admin API.

### Kong Vitals
{:.badge .enterprise}

[Kong Vitals](/link) provides useful metrics about the health and performance of your {{site.base_gateway}} nodes, as well as metrics about the usage of your gateway-proxied APIs. You can visually monitor vital signs and pinpoint anomalies in real-time, and use visual API analytics to see exactly how your APIs and Gateway are performing and access key statistics. Kong Vitals is part of the Kong Manager UI.

## Tools
Here are some tools! Use them!

### Insomnia

[Insomnia](/link) enables spec-first development for all REST and GraphQL services. With Insomnia, organizations can accelerate design and test workflows using automated testing, direct Git sync, and inspection of all response types. Teams of all sizes can use Insomnia to increase development velocity, reduce deployment risk, and increase collaboration.

### decK
[decK](/link) helps manage {{site.base_gateway}}’s configuration in a declarative fashion.
This means that a developer can define the desired state of Kong Gateway or
Konnect &ndash; services, routes, plugins, and more &ndash; and let decK handle
implementation without needing to execute each step manually, as you would with
the Kong Admin API.


## Get started with Kong Gateway

{{site.base_gateway}} is available in [some list of modes].
[Download it](/enterprise/{{page.kong_version}}/deployment/installation/overview)
and start testing out Gateway's open source features with Kong Manager today.

Choose your path:
* **[Quickstart][quickstart]**: An introduction to
{{site.base_gateway}}, common objects, and basic Admin API commands.
* **[Getting started guide][getting-started]**: The complete {{site.base_gateway}}
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

[quickstart]: /gateway-oss/{{page.kong_version}}/getting-started/quickstart
[configuring-a-service]: /gateway-oss/{{page.kong_version}}/getting-started/configuring-a-service
[enabling-plugins]: /gateway-oss/{{page.kong_version}}/getting-started/enabling-plugins
[getting-started]: /getting-started-guide/latest/overview

## Support policy
Kong primarily follows a [semantic versioning](https://semver.org/) (SemVer)
model for its products. 

For the latest version support information for  {{site.ee_product_name}} and
{{site.mesh_product_name}}, see our [version support policy](/konnect-platform/support-policy).
