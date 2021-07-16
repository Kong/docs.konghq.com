---
title: Kong Gateway (Enterprise)
subtitle: API gateway built for hybrid and multi-cloud, optimized for microservices and distributed architectures
---

{{site.ee_product_name}} is Kong's API gateway with enterprise functionality. As part of [{{site.konnect_product_name}}](/konnect/), the gateway brokers an organization’s information across all services by allowing customers to manage the full lifecycle of services and APIs. On top of that, it enables users to simplify the management of APIs and microservices across hybrid-cloud and multi-cloud deployments.

{{site.base_gateway}} is designed to run on decentralized architectures, leveraging workflow automation and modern GitOps practices. With {{site.base_gateway}}, users can:

* Decentralize applications/services and transition to microservices
* Create a thriving API developer ecosystem
* Proactively identify API-related anomalies and threats
* Secure and govern APIs/services, and improve API visibility across the entire organization

{{site.base_gateway}} is a combination of several features and modules built on top of the open-sourced {{site.base_gateway}}, as shown in the diagram and described in the next section, [_{{site.ee_product_name}} Features_](#kong-gateway-enterprise-features).

![Introduction to {{site.ee_product_name}}](/assets/images/docs/ee/introduction.png)

## Kong Gateway Enterprise Features

{{site.ee_product_name}} features are described in this section, including modules and plugins that extend and enhance the functionality of the {{site.konnect_product_name}} platform.

### Kong Gateway (OSS)

{{site.ce_product_name}} is a lightweight, fast, and flexible cloud-native API gateway. It’s easy to download, install, and configure to get up and running once you know the basics. The gateway runs in front of any RESTful API and is extended through modules and plugins which provide extra functionality beyond the core platform.

### Kong Admin API

Kong Admin API provides a RESTful interface for administration and configuration of Services, Routes, Plugins, and Consumers. All of the tasks you perform in the Kong Manager can be automated using the Kong Admin API. For more information, see [_Kong Admin API_](/enterprise/{{page.kong_version}}/admin-api/).

### Kong Developer Portal

Kong Developer Portal (Kong Dev Portal) is used to onboard new developers and to generate API documentation, create custom pages, manage API versions, and secure developer access. For more information, see [_Kong Developer Portal_](/enterprise/{{page.kong_version}}/developer-portal/).

### Kong Immunity

Kong Immunity uses machine learning to autonomously identify service behavior anomalies in real-time to improve security, mitigate breaches and isolate issues. Use Kong Immunity to autonomously identify service issues with machine learning-powered anomaly detection. For more information, see [_Kong Immunity_](/enterprise/{{page.kong_version}}/immunity/install-configure/).

### Kubernetes Ingress Controller

Kong for Kubernetes Enterprise (K4K8S) is a Kubernetes Ingress Controller. A Kubernetes Ingress Controller is a proxy that exposes Kubernetes services from applications (for example, Deployments, ReplicaSets) running on a Kubernetes cluster to client applications running outside of the cluster. The intent of an Ingress Controller is to provide a single point of control for all incoming traffic into the Kubernetes cluster. For more information, see [_Kong for Kubernetes_](/enterprise/{{page.kong_version}}/deployment/kong-for-kubernetes-enterprise).

### Kong Manager

Kong Manager is the Graphical User Interface (GUI) for {{site.ee_product_name}}. It uses the Kong Admin API under the hood to administer and control {{site.ce_product_name}}. Use Kong Manager to organize teams, adjust policies, and monitor performance with just a few clicks. Group your teams, services, plugins, consumer management, and more exactly how you want them. Create new routes and services, activate or deactivate plugins in seconds. For more information, see the [_Kong Manager Guide_](/enterprise/{{page.kong_version}}/kong-manager/overview/).

### Kong Plugins

{{site.base_gateway}} plugins provide advanced functionality to better manage your API and microservices. With turnkey capabilities to meet the most challenging use cases, {{site.ee_product_name}} plugins ensure maximum control and minimizes unnecessary overhead. Enable features like authentication, rate-limiting, and transformations by enabling {{site.ee_product_name}} plugins through Kong Manager or the Admin API. For more information on which plugins are Enterprise-only, see the [_Kong Hub_](/hub/).

### Kong Vitals

Kong Vitals provides useful metrics about the health and performance of your {{site.ee_product_name}} nodes, as well as metrics about the usage of your gateway-proxied APIs. You can visually monitor vital signs and pinpoint anomalies in real-time, and use visual API analytics to see exactly how your APIs and Gateway are performing and access key statistics. Kong Vitals is part of the Kong Manager UI. For more information, see [_Kong Vitals_](/enterprise/{{page.kong_version}}/admin-api/vitals/).

### Insomnia

Insomnia enables spec-first development for all REST and GraphQL services. With Insomnia, organizations can accelerate design and test workflows using automated testing, direct Git sync, and inspection of all response types. Teams of all sizes can use Insomnia to increase development velocity, reduce deployment risk, and increase collaboration. For more information, see [_Insomnia documentation_](https://support.insomnia.rest/){:target="_blank"}.


## Try Kong Gateway (Enterprise)

{{site.base_gateway}} is available in free mode.
[Download it](/enterprise/{{page.kong_version}}/deployment/installation/overview)
and start testing out Gateway's open source features with Kong Manager today.

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
