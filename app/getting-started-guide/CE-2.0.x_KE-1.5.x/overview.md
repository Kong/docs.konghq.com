---
title: Getting Started Guide
subtitle: A single guide for both {{site.ce_product_name}} and {{site.ee_product_name}}
---
This Getting Started Guide walks you through Kong concepts and foundational API gateway features and capabilities.

In this guide, you will:
* Expose your services using Service and Route objects
* Set up rate limits and proxy caching
* Secure services with key authentication
* Load balance traffic

## Overview

### {{site.ce_product_name}}
{{site.ce_product_name}} is an open-source, lightweight API gateway optimized for microservices, delivering unparalleled latency performance and scalability. If you just want the basics, this option will work for you.

### {{site.ee_product_name}}
<div class="alert alert-ee">
<img class="no-image-expand" src="/assets/images/icons/icn-enterprise-grey.svg" alt="Enterprise" /> This guide also includes some features specific to {{site.ee_product_name}} and the {{site.base_gateway}}. They'll be called out in blue blocks like this, or in their own Kong Manager tabs.
<br/><br/>
{{site.ee_product_name}} extends the {{site.ce_product_name}} with enterprise features and support. It provides advanced functionality using plugins for security, collaboration, performance at scale, and use of advanced protocols.
</div>


## Concepts and Features in this guide
Here’s the content covered in this guide, and how the pieces fit together:

![Features in getting started guide](/assets/images/docs/getting-started-guide/Kong-GS-overview.png)

| Concept/Feature    | Description {:width=60%:} | OSS or Enterprise {:width=20%:}|
|:------------------ |:--------------------------|:-------------------------------|
| Service            | A Service object is the ID {{site.base_gateway}} uses to refer to the upstream APIs and microservices it manages.  | Both |
| Routes             | Routes specify how (and if) requests are sent to their Services after they reach the API gateway. A single Service can have many Routes. | Both |
| Consumers          | Consumers represent end users of your API. Consumer objects let you control who can access your APIs. They also let you report on traffic using logging plugins and Kong Vitals.  | Both |
| Kong Manager       | Kong Manager is the visual browser-based tool for monitoring and managing {{site.ee_product_name}}.    | Enterprise |
| Admin API          | {{site.base_gateway}} comes with an internal RESTful API for administration purposes. API commands can be run on any node in the cluster, and the configuration will apply consistently on all nodes.  | Both, but with added functionality in {{site.ee_product_name}} |
| Plugins            | Plugins provide a modular system for modifying and controlling {{site.base_gateway}}’s capabilities. For example, to secure your API, you could require an access key, which you could set up using the key-auth plugin. Plugins provide a wide array of functionality, including access control, caching, rate limiting, logging, and more.                | Both, but with added functionality in {{site.ee_product_name}} |
| Rate Limiting plugin <br/><br/> Rate Limiting Advanced plugin | This plugin lets you limit the number of HTTP requests a client can make within a given period of time. <br/><br/> The advanced version of this plugin also provides sliding window support, and the ability to limit by header and service. | Both, but with added functionality in {{site.ee_product_name}} |
| Proxy Caching plugin <br/><br/> Proxy Caching Advanced plugin | This plugin provides a reverse proxy cache implementation. It caches response entities based on response code, content type, and request method for a given period of time. <br/><br/> The advanced version of this plugin supports Redis and Redis Sentinel deployments. | Both, but with added functionality in {{site.ee_product_name}} |
| Key Auth plugin <br/><br/> Key Auth - Encrypted plugin | This plugin lets you add key authentication (also known as an API key) to a Service or a Route. <br/><br/> The advanced version of this plugin stores the API keys in an encrypted format within the {{site.base_gateway}} data store. | Both, but with added functionality in {{site.ee_product_name}} |
| Load Balancing     | {{site.base_gateway}} provides two methods for load balancing: straightforward DNS-based or using a ring-balancer. In this guide, you’ll use a ring-balancer, which requires configuring upstream and target entities. With this method, the adding and removing of backend services is handled by {{site.base_gateway}}, and no DNS updates are necessary. | Both |
| User Authorization (RBAC)  | {{site.base_gateway}} handles user authorization through role-based access control (RBAC). Once enabled, RBAC lets you create teams and admins and assign them granular permissions either within a workspace, or across workspaces. | Enterprise |
| Developer Portal   | The Developer Portal provides a single source of truth for all developers to locate, access, and consume services.  | Enterprise |


## Understanding traffic flow in {{site.base_gateway}}
{{site.base_gateway}} listens for traffic on its configured proxy port(s) 8000 and 8443, by default. It evaluates incoming client API requests and routes them to the appropriate backend APIs. While routing requests and providing responses, policies can be applied via plugins as necessary.  

For example, before routing a request, the client might be required to authenticate. This delivers several benefits, including:

* The service doesn’t need its own authentication logic since {{site.base_gateway}} is handling authentication.
* The service only receives valid requests and therefore cycles are not wasted processing invalid requests.
* All requests are logged for central visibility of traffic.

![API Gateway traffic](/assets/images/docs/getting-started-guide/gateway-traffic.png)

## Before you begin
Note the following before you start using this guide:

### Installation
* This guide assumes that you have [{{site.ce_product_name}}](https://konghq.com/install/) or [{{site.base_gateway}}](/enterprise/latest/deployment/installation/overview/) installed and running on the platform of your choice.
* During your installation, take note of the KONG_PASSWORD; you’ll need it later on in this guide for setting up user authorization.

### Deployment guidelines
* You can use this guide to get started in production environments, but this guide does not provide all of the necessary configurations and security settings that you would need for a production environment.
* The examples in this guide all use `<admin-hostname>` to refer to a {{site.base_gateway}} instance's Admin API URL. Make sure to replace the variable with the actual URL of your {{site.base_gateway}} installation.
    * To find the URL, check the `admin_listen` property in the `/etc/kong/kong.conf` file.

### Using this guide
* As a {{site.ee_product_name}} user, functionalities can be managed programmatically using a REST-based Admin API, or using the Kong Manager GUI. As a {{site.base_gateway}} user, you need to follow the Admin API steps since Manager is an Enterprise feature. In this guide, you can choose your preferred method, if options are available — you don’t have to follow both.
* This guide provides Kong Admin API examples in both HTTPie and cURL. If you want to use HTTPie, install it from [here](https://httpie.org/).
* Any references to “{{site.base_gateway}}” refer to features or concepts common to both {{site.ce_product_name}} and {{site.base_gateway}}.

### Next Steps

Next, [prepare to administer {{site.base_gateway}}](/getting-started-guide/{{page.kong_version}}/prepare).
