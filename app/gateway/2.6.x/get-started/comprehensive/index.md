---
title: Comprehensive Getting Started Guide
---

In this guide, you will:

* Expose your services using Service and Route objects
* Set up rate limits and proxy caching
* Secure services with key authentication
* Load balance traffic

If you have a license, you also have access
to Enterprise features. In addition to the basics above,
use this guide to:

* Manage teams by setting up role-based access control (RBAC)
* Enable the Dev Portal to give your teams a central location to
publish, access, and consume services

**{{site.ce_product_name}}**: an open-source, lightweight API gateway optimized
for microservices, delivering unparalleled latency, performance, and scalability.
 If you just want the basics, this option will work for you.

**{{site.base_gateway}}**: extends the {{site.base_gateway}} with Enterprise
features and support. It provides advanced functionality using plugins for
security, collaboration, performance at scale, and use of advanced protocols.

## Concepts and Features in this guide

Here’s the content covered in this guide, and how the pieces fit together:

![Features in getting started guide](/assets/images/docs/getting-started-guide/Kong-GS-overview.png)

| Concept/Feature    | Description {:width=75%:} |
|:------------------ |:--------------------------|
| Service            | A Service object is the ID {{site.base_gateway}} uses to refer to the upstream APIs and microservices it manages.  |
| Routes             | Routes specify how (and if) requests are sent to their Services after they reach the API gateway. A single Service can have many Routes. |
| Consumers          | Consumers represent end users of your API. Consumer objects let you control who can access your APIs. They also let you report on traffic using logging plugins and Kong Vitals.  |
| Kong Manager       | Kong Manager is the visual browser-based tool for monitoring and managing {{site.ee_product_name}}.    |
| Admin API          | {{site.base_gateway}} comes with an internal RESTful API for administration purposes. API commands can be run on any node in the cluster, and the configuration will apply consistently on all nodes.  |
| Plugins            | Plugins provide a modular system for modifying and controlling {{site.base_gateway}}’s capabilities. For example, to secure your API, you could require an access key, which you could set up using the key-auth plugin. Plugins provide a wide array of functionality, including access control, caching, rate limiting, logging, and more.                |
| Rate Limiting plugin <br/><br/> Rate Limiting Advanced plugin | This plugin lets you limit the number of HTTP requests a client can make within a given period of time. <br/><br/> The advanced version of this plugin also provides sliding window support, and the ability to limit by header and service. |
| Proxy Caching plugin <br/><br/> Proxy Caching Advanced plugin | This plugin provides a reverse proxy cache implementation. It caches response entities based on response code, content type, and request method for a given period of time. <br/><br/> The advanced version of this plugin supports Redis and Redis Sentinel deployments. |
| Key Auth plugin <br/><br/> Key Auth - Encrypted plugin | This plugin lets you add key authentication (also known as an API key) to a Service or a Route. <br/><br/> The advanced version of this plugin stores the API keys in an encrypted format within the {{site.base_gateway}} data store. |
| Load Balancing     | {{site.base_gateway}} provides two methods for load balancing: straightforward DNS-based or using a ring-balancer. In this guide, you’ll use a ring-balancer, which requires configuring upstream and target entities. With this method, the adding and removing of backend services is handled by {{site.base_gateway}}, and no DNS updates are necessary. |
| User Authorization (RBAC)  | {{site.base_gateway}} handles user authorization through role-based access control (RBAC). Once enabled, RBAC lets you create teams and admins and assign them granular permissions either within a workspace, or across workspaces. |
| Dev Portal   | The Dev Portal provides a single source of truth for all developers to locate, access, and consume services.  |


## Understanding traffic flow in {{site.base_gateway}}

{{site.base_gateway}} listens for traffic on its configured proxy port(s) `8000`
and `8443`, by default. It evaluates incoming client API requests and routes them
to the appropriate backend APIs. While routing requests and providing responses,
policies can be applied via plugins as necessary.  

For example, before routing a request, the client might be required to
authenticate. This delivers several benefits, including:

* The service doesn’t need its own authentication logic since
{{site.base_gateway}} is handling authentication.
* The service only receives valid requests and therefore cycles are not wasted
processing invalid requests.
* All requests are logged for central visibility of traffic.

![API Gateway traffic](/assets/images/docs/getting-started-guide/gateway-traffic.png)

## Before you begin

Note the following before you start using this guide:

### Installation

* This guide assumes that you have {{site.ce_product_name}}
or {{site.base_gateway}}
[installed and running](/gateway/{{page.kong_version}}/install-and-run/) on the platform of your choice.
* During your installation, take note of the `KONG_PASSWORD`; you’ll need it
later on in this guide for setting up user authorization.

### Deployment guidelines

* You can use this guide to get started in production environments, but this
guide does not provide all of the necessary configurations and security settings
that you would need for a production environment.
* The examples in this guide all use `<admin-hostname>` to refer to a
{{site.base_gateway}} instance's Admin API URL. Make sure to replace the
variable with the actual URL of your {{site.base_gateway}} installation.

    To find the URL, check the `admin_listen` property in the
    `/etc/kong/kong.conf` file.

### Using this guide

* Throughout this guide, you will have the option to configure Kong in a few
different ways. Choose your preferred method, if options are available —
you don’t have to walk through all of them:
  * Programmatically manage {{site.base_gateway}} using its REST-based Admin API
  * Use the Kong Manager GUI *(Not available for open-source Gateway)*
  * Use decK for declarative configuration (YAML)
* If you're running {{site.base_gateway}} in Hybrid mode, all tasks contained
in this guide take place on the Control Plane.
* This guide provides Kong Admin API examples in both HTTPie and cURL. If you
want to use HTTPie, install it from [here](https://httpie.org/).
* Any references to “{{site.base_gateway}}” refer to features or concepts
common to both {{site.ce_product_name}} and {{site.base_gateway}}.

### Next Steps

Next, [prepare to administer {{site.base_gateway}}](/gateway/{{page.kong_version}}/get-started/comprehensive/prepare).
