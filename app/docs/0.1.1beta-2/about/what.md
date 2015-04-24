---
title: What is Kong?
---

# What is Kong?

Kong is a scalable, open source **API Layer** *(also known as a API Gateway, or API Middleware)*. Kong runs in front of any RESTful API and is extended through [Plugins](/docs/{{page.kong_version}}/about/plugins), which provide [extra functionalities and services](/plugins) beyond the core platform.

Mashape, the worlds largest API marketplace, over the past several years has been powered by Kong. Delivering reliable and secure service to the 140,000 active developers in the Mashape community.

* **Scalable**: Kong easily scales horizontally by simply adding more machines, meaning your platform can handle virtually any load while keeping latency low.

* **Modular**: Kong can be extended by adding new plugins, which are easily configured through an internal RESTful API.

* **Runs on any infrastructure**: Kong runs anywhere. You can deploy Kong in the cloud or on-premise environments, including single or multi-datacenter setups and for public, private or invite-only APIs.

Kong is built on top of reliable technologies like **NGINX** and **Apache Cassandra**, and provides you with an easy to use [RESTful API](/docs/{{page.kong_version}}/internal-api) to operate and configure the system.

## Request Workflow

To better understand the system, this is a typical request workflow of an API that uses Kong:

![](/assets/images/docs/kong-simple.png)

Once Kong is running, every request being made to the API will hit Kong first, and then it will be proxied to the final API. In between requests and responses Kong will execute any plugin that you decided to install, empowering your APIs. Kong is effectively going to be the entry point for every API request.
