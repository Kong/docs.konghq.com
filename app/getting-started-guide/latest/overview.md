---
title: Getting Started Guide
skip_read_time: true
is_homepage: true
---
This Getting Started Guide walks you through the basic features of Kong Gateway.

In this guide, you will:
* Expose your services using Service and Route objects
* Set up rate limits and proxy caching
* Secure services with key authentication
* Load balance traffic

## Overview

### Kong Community Gateway
Kong Community Gateway is an open-source, lightweight API gateway optimized for microservices, delivering unparalleled latency performance and scalability. If you just want the basics, this option will work for you.

### Kong Enterprise and free trials
<div class="alert alert-ee">
<img src="/assets/images/icons/icn-enterprise-grey.svg" alt="Enterprise" /> This guide also includes some features specific to Kong Enteprise and the Kong Enterprise Gateway. They'll be called out in blue blocks like this, or in their own Kong Manager tabs.
<br/><br/>
Kong Enterprise extends the Kong Community Gateway with enterprise features and support. It provides advanced functionality using plugins for security, collaboration, performance at scale, and use of advanced protocols.
<br/><br/>
If you don’t currently have Kong Enterprise but want to experience it, check out our <a href="https://konghq.com/products/kong-enterprise/free-trial?itm_source=website&itm_medium=nav">Free Trial</a>.</div>


## Concepts and Features in this Guide
Here’s the content covered in this guide, and how the pieces fit together:

![Features in getting started guide](/assets/images/docs/getting-started-guide/Kong-GS-overview.png)

| Concept/Feature	| Description	| OSS or Enterprise	|
|-----------------|-------------|-------------------|
| Service        	| A Service object is the ID Kong Gateway uses to refer to the upstream APIs and microservices it manages.	| Both |
| Routes         	| Routes specify how (and if) requests are sent to their Services after they reach the API gateway. A single Service can have many Routes.	| Both	|
| Consumers	      | Consumers represent end users of your API. Consumer objects let you control who can access your APIs. They also let you report on traffic using logging plugins and Kong Vitals.	| Both	|
| Kong Manager	  | Kong Manager is the visual browser-based tool for monitoring and managing Kong Enterprise. | Enterprise	|
| Admin API	      | Kong Gateway comes with an internal RESTful API for administration purposes. API commands can be run on any node in the cluster, and the configuration will apply consistently on all nodes.	| Both, but with added functionality in Kong Enterprise	|
| Plugins       	| Plugins provide a modular system for modifying and controlling Kong Gateway’s capabilities. For example, to secure your API, you could require an access key, which you could set up using the key-auth plugin. Plugins provide a wide array of functionality, including access control, caching, rate limiting, logging, and more.	| Both, but with added functionality in Kong Enterprise	|
| Rate Limiting plugin <br/><br/> Rate Limiting Advanced plugin	| This plugin lets you limit the number of HTTP requests a client can make within a given period of time. <br/><br/> The advanced version of this plugin also provides sliding window support, and the ability to limit by header and service.	| Both, but with added functionality in Kong Enterprise	|
| Proxy Caching plugin <br/><br/> Proxy Caching Advanced plugin	| This plugin provides a reverse proxy cache implementation. It caches response entities based on response code, content type, and request method for a given period of time. <br/><br/> The advanced version of this plugin supports Redis and Redis Sentinel deployments.	| Both, but with added functionality in Kong Enterprise	|
| Key Auth plugin <br/><br/> Key Auth - Encrypted plugin	| This plugin lets you add key authentication (also known as an API key) to a Service or a Route. <br/><br/> The advanced version of this plugin stores the API keys in an encrypted format within the Kong Gateway data store.	| Both, but with added functionality in Kong Enterprise	|
| Load Balancing 	| Kong Gateway provides two methods for load balancing: straightforward DNS-based or using a ring-balancer. In this guide, you’ll use a ring-balancer, which requires configuring upstream and target entities. With this method, the adding and removing of backend services is handled by Kong Gateway, and no DNS updates are necessary.	| Both	|
| User Authorization (RBAC)	| Kong Enterprise Gateway handles user authorization through role-based access control (RBAC). Once enabled, RBAC lets you create teams and admins and assign them granular permissions either within a workspace, or across workspaces.	| Enterprise	|
| Developer Portal	| The Developer Portal provides a single source of truth for all developers to locate, access, and consume services.	| Enterprise	|


## Understanding traffic flow in Kong Gateway
Kong Gateway listens for traffic on its configured proxy port(s) 8000 and 8443, by default. It evaluates incoming client API requests and routes them to the appropriate backend APIs. While routing requests and providing responses, policies can be applied via plugins as necessary.  

For example, before routing a request, the client might be required to authenticate. This delivers several benefits, including:

* The service doesn’t need its own authentication logic since Kong Gateway is handling authentication.
* The service only receives valid requests and therefore cycles are not wasted processing invalid requests.
* All requests are logged for central visibility of traffic.

![API Gateway traffic](/assets/images/docs/getting-started-guide/gateway-traffic.png)

## Before you begin
Note the following before you start using this guide:

### Installation
* This guide assumes that you have [Kong Community Gateway](https://konghq.com/install/) or [Kong Enterprise Gateway](/enterprise/{{page.kong_version}}/deployment/installation/overview/) installed and running on the platform of your choice, or that you have signed up for an Enterprise free trial.
* During your installation, take note of the KONG_PASSWORD; you’ll need it later on in this guide for setting up user authorization.

### Deployment guidelines
* You can use this guide to get started in production environments, but this guide does not provide all of the necessary configurations and security settings that you would need for a production environment.
* The examples in this guide all use `<admin-hostname>` to refer to a Kong Gateway instance's Admin API URL. Make sure to replace the variable with the actual URL of your Kong Gateway installation.
    * To find the URL, check the `admin_listen` property in the `/etc/kong/kong.conf` file.

### Using this guide
* As a Kong Enterprise or Free Trial user, functionalities can be managed programmatically using a REST-based Admin API, or using the Kong Manager GUI. As a Kong Gateway user, you need to follow the Admin API steps since Manager is an Enterprise feature. In this guide, you can choose your preferred method, if options are available — you don’t have to follow both.
* This guide provides Kong Admin API examples in both HTTPie and cURL. If you want to use HTTPie, install it from [here](https://httpie.org/).
* Any references to “Kong Gateway” refer to features or concepts common to both Kong Community Gateway and Kong Enterprise Gateway.

### Next Steps

Next, [prepare to administer Kong Gateway](/getting-started-guide/{{page.kong_version}}/prepare).
