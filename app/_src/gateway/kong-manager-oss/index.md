---
title: About Kong Manager Open Source
badge: oss
github_star_button: <a class='github-button' href='https://github.com/Kong/kong-manager' data-icon='octicon-star' data-show-count='true' aria-label='Star kong/kong-manager on GitHub'>Star</a>

---

Kong Manager Open Source (OSS) is the graphical user interface (GUI) for {{site.ce_product_name}}. It uses the Kong Admin API under the hood to administer and control {{site.ce_product_name}}. To access Kong Manager OSS, go to the following URL after installing {{site.ce_product_name}}: [http://localhost:8002](http://localhost:8002)

Here are some of the things you can do with Kong Manager OSS:

* Create new routes and services
* Activate or deactivate plugins
* Group your services, plugins, consumer management, and everything else exactly how you want them
* Manage certificates
* Centrally store and easily access key sets and keys. 

{:.note}
> **Note:** If you are using the Enterprise image of {{site.base_gateway}}, you can use the [Kong Manager Enterprise](/gateway/{{page.release}}/kong-manager/). 

## Kong Manager OSS interface

![Kong Manager OSS interface](/assets/images/products/gateway/km_oss.png)

> Figure 1: Kong Manager OSS overview

 Item | Description
------|------------
**Overview** | Dashboard that contains information about your {{site.ce_product_name}}.
[**Gateway Services**](/gateway/{{page.release}}/key-concepts/services/) | Overview of all services associated with your {{site.ce_product_name}}. From this dashboard, you can add new services, manage existing services, and see all services at a glance.
[**Routes**](/gateway/{{page.release}}/key-concepts/routes/) | Overview of all routes associated with your {{site.ce_product_name}}. From this dashboard, you can add new routes, manage existing routes, and see all routes at a glance. 
**Consumers** | Overview of all consumers associated with your {{site.ce_product_name}}. From this dashboard, you can add new consumers, manage existing consumers, and see all consumers at a glance.
[**Plugins**](/gateway/{{page.release}}/key-concepts/plugins/) | Overview of all plugins associated with your {{site.ce_product_name}}. From this dashboard, you can enable or disable plugins. 
[**Upstreams**](/gateway/{{page.release}}/key-concepts/upstreams/) | Overview of all upstreams associated with your {{site.ce_product_name}}. From this dashboard, you can add new upstreams, manage existing upstreams, and see all upstreams at a glance.
**Certificates** | Manage your certificates for SSL/TLS termination for encrypted requests.
**CA Certificates** | Manage your CA certificates for client and server certificate validation.
**SNIs** | Manage SNI object one-to-many mappings of hostnames to a certificate. 
**Vaults** | Manage the security of {{site.ce_product_name}} with centralized secrets.
**Keys** | Manage your asymmetric keys by adding a key object.
**Key Sets** | Manage your asymmetric key collections by adding a key set object.
