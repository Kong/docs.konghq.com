---
title: Dedicated Cloud Gateways
content_type: concept
---

Dedicated Cloud Gateways are data plane nodes that are fully managed by Kong in {{site.konnect_short_name}}.
	
You don't need to host any data planes, while maintaining control over the size and location of the gateway infrastructure. This allows Kong to autoscale your nodes for you and reduces your operational complexity.


Dedicated Cloud Gateways offer the following benefits:
* {{site.konnect_short_name}} handles gateway upgrades for you
* A public or private mode to decide who can view your APIs. In public mode, powered by Kong's public Edge DNS for clusters, you can expose your APIs to the internet. 
* Automatic scaling of data plane nodes to meet changing demand with Autopilot mode
* Supported on the following AWS regions: Sydney, Tokyo, Singapore, Frankfurt, Ireland, London, Ohio, Oregon
* <span class="badge alpha"></span> Supported on the following Azure regions: Frankfurt, Ireland, UK South, Virginia, Washington

You can manage your Dedicated Cloud Gateway nodes in [Gateway Manager](https://cloud.konghq.com/gateway-manager/).

<img src="/assets/images/products/konnect/gateway-manager/konnect-control-plane-cloud-gateway-wizard.png" alt="cloud gateway wizard" style="max-width: 800px;">
> _**Figure 1:** The Dedicated Cloud Gateway wizard in the {{site.konnect_short_name}} UI. The wizard allows you to configure the {{site.base_gateway}} version, mode, cluster region, and API access level._


## How do Dedicated Cloud Gateways work? {#dedicated-features}

{% include_cached /md/konnect/deployment-topologies.md %}

> _**Figure 2:** Data planes are hosted in the cloud by Kong. The control plane connects to the database, and the data planes receive configuration from the control plane. Data plane nodes are scaled automatically according to the settings in your Dedicated Cloud Gateway._

When you create a Dedicated Cloud Gateway, {{site.konnect_short_name}} creates a control plane. This control plane, like other {{site.konnect_short_name}} control planes, is hosted by {{site.konnect_short_name}}. You can then deploy data planes in regions close to yours users that will be managed by {{site.konnect_short_name}}. 

When you configure your Dedicated Cloud Gateway, you can choose one of two configuration modes to create your data plane nodes:

* **Autopilot:** In Autopilot mode, you configure how many requests per second you expect the instance to receive, then Kong pre-warms and autoscales the data plane nodes in the cluster for you.
* **Custom:** In Custom mode, you specify the instance size and type (for example, dev, production, or large production) as well as the number of nodes per cluster.

Because data plane nodes in Autopilot configuration mode automatically scale, you **cannot** manually increase or decrease nodes. You can only manually increase or decrease data plane nodes when the Dedicated Cloud Gateway is configured in the Custom mode.

Control planes in {{site.konnect_short_name}} **cannot** contain both Dedicated Cloud Gateway and self-managed data plane nodes.

## Private vs public networks

Dedicated Cloud Gateways support public and private networking on AWS.
* **Public networking:** Easy access to services and APIs, but low security. We recommend only using this option for testing.
* **Private networking:** A secure way to expose your APIs to the internet.
 
You can set up private networking for Dedicated Cloud Gateways with [AWS Transit Gateways](/konnect/gateway-manager/data-plane-nodes/transit-gateways/).

## More information

* [Networking and Peering information](/konnect/network-resiliency/#how-does-network-peering-work-with-dedicated-cloud-gateway-nodes)
* [Supported regions](/konnect/geo/#dedicated-cloud-gateways)
* [Transit Gateways](/konnect/gateway-manager/data-plane-nodes/transit-gateways/)
* [How to upgrade data planes](/konnect/gateway-manager/data-plane-nodes/upgrade/)
* [Custom Domains](/konnect/reference/custom-dns/)
* [Cloud Gateways API](/konnect/api/cloud-gateways/latest/)