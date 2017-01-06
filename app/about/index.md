---
title: What is Kong?
header_icon: /assets/images/icons/icn-documentation.svg
header_title: What is Kong?
---

Kong is a scalable, open source **API Layer** *(also known as an API Gateway, or API Middleware)*. Kong runs in front of any RESTful API and is extended through [Plugins](/plugins), which provide [extra functionality and services](/plugins) beyond the core platform.

Kong was originally built at Mashape to secure, manage and extend over 15,000 APIs & Microservices for its API Marketplace, which generates billions of requests per month for over 200,000 developers. Today Kong is used in mission critical deployments at small and large organizations.

* **Scalable**: Kong easily scales horizontally by simply adding more machines, meaning your platform can handle virtually any load while keeping latency low.

* **Modular**: Kong can be extended by adding new plugins, which are easily configured through a RESTful Admin API.

* **Runs on any infrastructure**: Kong runs anywhere. You can deploy Kong in the cloud or on-premise environments, including single or multi-datacenter setups and for public, private or invite-only APIs.

![](/assets/images/docs/kong-architecture.jpg)

Kong is built on top of reliable technologies like **NGINX** and **Apache Cassandra** or **PostgreSQL**, and provides you with an easy-to-use [RESTful API](/docs/latest/admin-api) to operate and configure the system.

## Request Workflow

To better understand the system, this is a typical request workflow of an API that uses Kong:

![](/assets/images/docs/kong-simple.png)

Once Kong is running, every request being made to the API will hit Kong first, and then it will be proxied to the final API. In between requests and responses Kong will execute any plugin that you decided to install, empowering your APIs. Kong effectively becomes the entry point for every API request.
