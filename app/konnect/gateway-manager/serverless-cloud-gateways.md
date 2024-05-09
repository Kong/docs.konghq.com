---
title: Serverless Cloud Gateways
content_type: concept
---

Serverless Cloud Gateways are data plane nodes that are fully managed by Kong in {{site.konnect_short_name}}.
	
They provide a lightweight easy way to get started trying out Kong Konnect without having to provision and manage your own data plane nodes.

Because they are designed for lighter weight workloads and rapid prototyping, they lack many of the configuration options of [Dedicated Cloud Gateways](/konnect/gateway-manager/dedicated-cloud-gateways/). 

Serverless Cloud Gateways offer the following features:
* Latest version only of Kong Gateway
* Kong Admin API access and configurability
* A publicly exposed Kong Gateway proxy endpoint with an auto-assigned DNS name
* No auto-scaling or availability guarantees
* Auto-selection of the deployment region at a datacenter corresponding to the selected {{site.konnect_short_name}} region

You can manage your Serverless Cloud Gateway nodes in [Gateway Manager](https://cloud.konghq.com/gateway-manager/).


## Provisioning a Serverless Cloud Gateway

1. Login to your {{site.konnect_short_name}} account.
2. Create a new organization and prefix the name of the organization with `[Serverless] `. E.g. `[Serverless] My Test Org`.
3. Select a region.

After completing these steps you will be dropped into the Serverless Gateway CP Overview, and your serverless data plane node will be automatically created.

When the notification appears to confirm your gateway has been provisioned, you should be able to find the external Serverless Gateway URL in the overview box:

<img src="/assets/images/products/konnect/gateway-manager/serverless-gateways-overview.png" alt="serverless gateways overview" style="max-width: 800px;">
> _**Figure 1:** The Serverless Gateway CP overview in the {{site.konnect_short_name}} UI. Once provisioned, the gateway proxy URL will show in this overview section._

The Serverless Gateway is now ready to use, and you can create services, routes, plugins, view analytics and more as you would with Hybrid Gateways or Dedicated Cloud Gateways in {{site.konnect_short_name}}.