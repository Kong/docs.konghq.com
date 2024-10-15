---
title: Serverless Gateways
content_type: concept
---

Serverless Gateways are lightweight data plane nodes that are fully managed by Kong in {{site.konnect_short_name}}.
	
You don't need to host any data planes, while easily being able to deploy Kong gateways for your learning, prototyping, and hobbyist requirements.

Serverless Gateways offer the following benefits:

* {{site.konnect_short_name}} handles gateway provisioning and placement for you
* very rapid spin-up time (sub 30s)
* core subset of Kong gateway plugins
* custom domains (coming soon)

You can manage your Serverless Gateway nodes in [Gateway Manager](https://cloud.konghq.com/gateway-manager/).

<img src="/assets/images/products/konnect/gateway-manager/konnect-control-plane-serverless-gateway-overview.png" alt="severless gateway overview" style="max-width: 800px;">
> _**Figure 1:** The Serverless Gateway wizard in the {{site.konnect_short_name}} UI._


## How do Serverless Gateways work? {#serverless-features}

{% include_cached /md/konnect/deployment-topologies.md %}

> _**Figure 2:** Data planes are hosted in the cloud by Kong. The control plane connects to the database, and the data planes receive configuration from the control plane. The number and size of data plane nodes is abstracted away by Kong, and you only have to worry about running your application._

When you create a Serverless Gateway, {{site.konnect_short_name}} creates a control plane. This control plane, like other {{site.konnect_short_name}} control planes, is hosted by {{site.konnect_short_name}}. {{site.konnect_short_name}} then provisions a hosted data plane for you and automatically configures the connection to the control plane, before providing the user with an auto-generated, easy-to-use hostname in the form `https://kong-xxxxxx.kongcloud.dev`.

Serverless Gateways are designed to be fast to provision and lightweight from a maintenance and overhead point-of-view. Therefore is it not possible to configure:

* Kong version (this is defaulted to the latest version and periodically automatically upgraded)
* The number of data planes that are deployed
* The size of the data planes that are deployed
* The region that the data planes are deployed to (this usually aligns with your Konnect CP region but is not guaranteed)

Control planes in {{site.konnect_short_name}} **cannot** contain both Serverless Gateway and self-managed data plane nodes.

## Networking

Serverless Gateways only support public networking. There are currently no capabilities for private networking between your datacenters and hosted Kong data planes. For use cases where private networking is required, [Dedicated Cloud Gateways](/konnect/gateway-manager/dedicated-cloud-gateways) with [AWS Transit Gateways](/konnect/gateway-manager/dedicated-cloud-gateways/transit-gateways/) may be a better choice.

## Plugin considerations for Serverless Gateways
There are some limitations for plugins with Serverless Gateways:

* Any plugins that depend on a local agent will not work with Serverless Gateways.
* Any plugins that depend on the Status API or on Admin API endpoints will not work.
* Any plugins or functionality that depend on AWS IAM `AssumeRole` need to be configured differently. 
This includes [Data Plane Resilience](/gateway/latest/kong-enterprise/cp-outage-handling/).

## More information

* [Securing Backend Traffic](/konnect/gateway-manager/serverless-gateways/securing-backend-traffic)
* [Custom Domains](/konnect/reference/custom-dns/)
* [Serverless Gateways API](/konnect/api/cloud-gateways/latest/)