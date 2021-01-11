---
title: Introduction to Kong Enterprise
---

## Introduction

{{site.ee_product_name}} is a Service Control Platform that brokers an organization’s information across all services by allowing customers to manage the full lifecycle of services and APIs. Built on top of {{site.ce_product_name}}, {{site.ee_product_name}} enables users to simplify the management of APIs and microservices across hybrid-cloud and multi-cloud deployments.

{{site.ee_product_name}} is designed to run on decentralized architectures, leveraging workflow automation and modern GitOps practices. With {{site.ee_product_name}}, users can:

* Decentralize applications/services and transition to microservices
* Create a thriving API developer ecosystem
* Proactively identify API-related anomalies and threats
* Secure and govern APIs/services, and improve API visibility across the entire organization

{{site.ee_product_name}} is a combination of several features and modules on top of the open-sourced Kong Gateway, as shown in the diagram and described in the next section, [_Kong Enterprise Features_](/enterprise/{{page.kong_version}}/introduction/key-concepts).

![Introduction to Kong Enterprise](/assets/images/docs/ee/introduction.png)

## Kong Enterprise Features

{{site.ee_product_name}} features are described in this section, including modules and plugins that extend and enhance the functionality of the {{site.ee_product_name}} platform.

### Kong Gateway

{{site.ce_product_name}} is a lightweight, fast, and flexible cloud-native API gateway. It’s easy to download, install, and configure to get up and running once you know the basics. Kong runs in front of any RESTful API and is extended through modules and plugins which provide extra functionality beyond the core platform.

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

{{site.ee_product_name}} plugins provide advanced functionality to better manage your API and microservices. With turnkey capabilities to meet the most challenging use cases, {{site.ee_product_name}} plugins ensure maximum control and minimizes unnecessary overhead. Enable features like authentication, rate-limiting, and transformations by enabling {{site.ee_product_name}} plugins through Kong Manager or the Admin API. For more information on which plugins are Enterprise-only, see the [_Kong Hub_](/hub/).

### Kong Vitals

Kong Vitals provides useful metrics about the health and performance of your {{site.ee_product_name}} nodes, as well as metrics about the usage of your Kong-proxied APIs. You can visually monitor vital signs and pinpoint anomalies in real-time, and use visual API analytics to see exactly how your APIs and Gateway are performing and access key statistics. Kong Vitals is part of the Kong Manager UI. For more information, see [_Kong Vitals_](/enterprise/{{page.kong_version}}/admin-api/vitals/).

### Kong Studio

Kong Studio enables spec-first development for all REST and GraphQL services. With Kong Studio, organizations can accelerate design and test workflows using automated testing, direct Git sync, and inspection of all response types. Teams of all sizes can use Kong Studio to increase development velocity, reduce deployment risk, and increase collaboration. For more information, see [_Kong Studio_](/enterprise/{{page.kong_version}}/studio/).


## Try Kong Enterprise

Here are a few ways to try Kong Enterprise:

* Sign up for the Kong Enterprise self-serve, cloud-based, 15 day
[free trial](https://konghq.com/get-started/#free-trial/).
* Try out Kong for Kubernetes Enterprise using a live tutorial at
[https://kubecon.konglabs.io/](https://kubecon.konglabs.io/)
* If you are interested in evaluating Kong Enterprise locally, the Kong sales
team manages evaluation licenses as part of a formal sales process. The best
way to get started with the sales process is to
[request a demo](https://konghq.com/get-started/#request-demo) and indicate
your interest.
