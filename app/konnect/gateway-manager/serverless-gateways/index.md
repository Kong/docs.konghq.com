---
title: Serverless Gateways
---

Serverless gateways are lightweight data plane nodes that are fully managed by Kong in {{site.konnect_short_name}}.

Serverless gateways offer the following benefits:

* {{site.konnect_short_name}} manages provisioning and placement.
* Can be deployed in under 30 seconds.
* Access to {{site.base_gateway}} plugins.

You can manage your serverless gateway nodes within [Gateway Manager](https://cloud.konghq.com/gateway-manager/).

## How do Serverless gateways work? {#serverless-features}

{% include_cached /md/konnect/deployment-topologies.md %}

> _**Figure 2:** Data planes are hosted in the cloud by Kong. The control plane connects to the database, and the data planes receive a configuration from the control plane._

When you create a Serverless gateway, {{site.konnect_short_name}} creates a control plane. This control plane, like other {{site.konnect_short_name}} control planes, is hosted by {{site.konnect_short_name}}. {{site.konnect_short_name}} then provisions a hosted data plane for you and automatically configures the connection to the control plane, before providing the user with an auto-generated, unique hostname in the form of `https://kong-xxxxxx.kongcloud.dev`.

Serverless gateways are designed to be fast to provision and lightweight, therefore it is not possible to configure:

* {{site.base_gateway}} version. The default is `latest` and is automatically upgraded.
* The number of data planes.
* The size of the data planes.
* The region that the data planes are deployed to. Typically the data planes are deployed on the same region as the {{site.konnect_short_name}} control plane, but with serverless gateways this is not guaranteed.

{:.note}
>**Note**: Control planes in {{site.konnect_short_name}} **cannot** contain both serverless gateway and self-managed data plane nodes.

## Networking

Serverless gateways only supports public networking. There are currently no capabilities for private networking between your data centers and hosted Kong data planes. For use cases where private networking is required, [Dedicated Cloud Gateways](/konnect/gateway-manager/dedicated-cloud-gateways) with [AWS Transit Gateways](/konnect/gateway-manager/dedicated-cloud-gateways/transit-gateways/) may be a better choice.

## Plugin considerations for serverless gateways
There are some limitations for plugins with serverless gateways:

* Any plugins that depend on a local agent will not work with serverless gateways.
* Any plugins that depend on the Status API or on Admin API endpoints will not work.
* Any plugins or functionality that depend on AWS IAM `AssumeRole` need to be configured differently. 
This includes [data plane resilience](/gateway/latest/kong-enterprise/cp-outage-handling/).

## More information

* [Securing backend traffic](/konnect/gateway-manager/serverless-gateways/securing-backend-traffic)
* [Custom domains](/konnect/reference/custom-dns/)
* [Serverless gateways API](/konnect/api/cloud-gateways/latest/)