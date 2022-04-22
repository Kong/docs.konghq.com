---
title: Introduction to Kong Enterprise
---

## Introduction

Kong Enterprise is a Service Control Platform that brokers an organization’s information across all services by allowing customers to manage the full lifecycle of services and APIs. Built on top of Kong Gateway Community, Kong Enterprise enables users to simplify the management of APIs and microservices across hybrid-cloud and multi-cloud deployments.

Kong Enterprise is designed to run on decentralized architectures, leveraging workflow automation and modern GitOps practices. With Kong Enterprise, users can:

* Decentralize applications/services and transition to microservices
* Create a thriving API developer ecosystem
* Proactively identify API-related anomalies and threats
* Secure and govern APIs/services, and improve API visibility across the entire organization

Kong Enterprise is a combination of several features and add-ons on top of the open-sourced Kong Gateway Community, as shown in the diagram and described in the next section [_Kong Enterprise Features_](https://docs.konghq.com/enterprise/{{page.kong_version}}/introduction/key-concepts).

![Introduction to Kong Enterprise](/assets/images/docs/ee/introduction.png)

## Kong Enterprise Features

Kong Enterprise features are described in this section, including add-ons and plugins that extend and enhance the functionality of the Kong Enterprise platform.

### Kong Gateway Community

Kong Gateway Community is a lightweight, fast, and flexible cloud-native API gateway. It’s easy to download, install, and configure to get up and running once you know the basics. Kong Gateway Community runs in front of any RESTful API and is extended through add-ons and plugins which provide extra functionality beyond the core platform.

### Kong Admin API

Kong Admin API provides a RESTful interface for administration and configuration of Services, Routes, Plugins, and Consumers. All of the tasks you perform in the Kong Manager can be automated using the Kong Admin API. For more information, see [_Kong Admin API_](https://docs.konghq.com/enterprise/{{page.kong_version}}/admin-api/).

### Kong Developer Portal

Kong Developer Portal (Kong Dev Portal) is used to onboard new developers and to generate API documentation, create custom pages, manage API versions, and secure developer access. For more information, see [_Kong Developer Portal_](https://docs.konghq.com/enterprise/{{page.kong_version}}/developer-portal/).

### Kong for Kubernetes

Kong for Kubernetes Enterprise (K4K8S) is a Kubernetes Ingress Controller. A Kubernetes Ingress Controller is a proxy that exposes Kubernetes services from applications (for example, Deployments, RepliaSets) running on a Kubernetes cluster to client applications running outside of the cluster. The intent of an Ingress Controller is to provide a single point of control for all incoming traffic into the Kubernetes cluster. For more information, see [_Kong for Kubernetes_](https://docs.konghq.com/enterprise/{{page.kong_version}}/kong-for-kubernetes/).

### Kong Manager

Kong Manager is the Graphical User Interface (GUI) for Kong Enterprise. It uses the Kong Admin API under the hood to administer and control Kong Gateway Enterprise. Use Kong Manager to organize teams, adjust policies, and monitor performance with just a few clicks. Group your teams, services, plugins, consumer management, and more exactly how you want them. Create new routes and services, activate or deactivate plugins in seconds. For more information, see the [_Kong Manager Guide_](https://docs.konghq.com/enterprise/{{page.kong_version}}/kong-manager/overview/).

### Kong Plugins

Kong Enterprise plugins provide advanced functionality to better manage your API and microservices. With turnkey capabilities to meet the most challenging use cases, Kong Enterprise Plugins ensure maximum control and minimizes unnecessary overhead. Enable features like authentication, rate-limiting, and transformations by enabling Kong Enterprise plugins through Kong Manager or the Kong Admin API. For more information on which plugins are Enterprise-only, see the [_Kong Hub_](https://docs.konghq.com/hub/).

### Kong Vitals

Kong Vitals provides useful metrics about the health and performance of your Kong Enterprise nodes, as well as metrics about the usage of your Kong-proxied APIs. You can visually monitor vital signs and pinpoint anomalies in real-time, and use visual API analytics to see exactly how your APIs and Gateway are performing and access key statistics. Kong Vitals is part of the Kong Manager UI. For more information, see [_Kong Vitals_](https://docs.konghq.com/enterprise/{{page.kong_version}}/admin-api/vitals/).

### Kong Studio

Kong Studio enables spec-first development for all REST and GraphQL services. With Kong Studio, organizations can accelerate design and test workflows using automated testing, direct Git sync, and inspection of all response types. Teams of all sizes can use Kong Studio to increase development velocity, reduce deployment risk, and increase collaboration. For more information, see [_Kong Studio_](https://docs.konghq.com/studio/).


## Try Kong Enterprise

Here are a couple of ways to try Kong Enterprise:

* Get a demonstration at [_Request Demo_](https://konghq.com/request-demo/)
* Get a free trial at [_Kong Free Trial_](https://konghq.com/products/kong-enterprise/free-trial/)
