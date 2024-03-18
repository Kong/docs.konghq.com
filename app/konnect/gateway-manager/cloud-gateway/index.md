---
title: About Cloud Gateways
content_type: concept
---

Dedicated cloud gateways are a type of API gateway in {{site.konnect_short_name}} that are completely managed in the cloud provider of your choice. With a dedicated cloud infrastructure, you control the sizing and deployment locations of the gateway infrastructure and Kong manages the operations of individual instances and the cluster for you.

In just a few steps, you can configure a dedicated cloud gateway using the UI wizard in {{site.konnect_short_name}}. You can manage your dedicated cloud gateways alongside all your other gateways in Gateway Manager.

Dedicated cloud gateways have the following benefits over a typical hybrid gateway:

* **Pre-warm a cluster:** You can pre-warm your cluster by specifying the number of requests per second so that the first requests don’t have to wait for the infrastructure to scale up.
* **Fast setup:** Configure and start your dedicated cloud gateway in four steps.  
* **SOC1 compliant:** Dedicated cloud gateways are SOC1 compliant out-of-the-box.
* **Kong-managed:** Kong manages the cluster for you, all you need to do is configure a few settings. 
* **One-click upgrades:** {{site.konnect_short_name}} handles upgrades for you. You decide when you want to upgrade and what {{site.base_gateway}} version you want to upgrade to and {{site.konnect_short_name}} does it for you. There's no downtime when upgrading the infrastructure.
* **Multi-region:** Dedicated cloud gateways are supported on the following AWS regions: Sydney, Tokyo, Singapore, Frankfurt, Ireland, London, Ohio, Oregon.

![cloud gateway dashboard](/assets/images/products/konnect/gateway-manager/konnect-control-plane-cloud-gateway.png)
> _**Figure 1:** Example of the dedicated cloud gateway dashboard in Gateway Manager. The dashboard displays the total traffic, error rate, and P99 latency. It also displays the top five gateway services and routes by traffic, as well as the plugins and consumers associated with the gateway._

## Dedicated cloud gateway architecture

{% include_cached /md/konnect/deployment-topologies.md topology='cloud' %}

> _Figure 1: In a dedicated cloud gateway, the control plane is hosted in {{site.konnect_short_name}} and data planes are hosted in the cloud by Kong. The control plane connects to the database, and the data planes receive configuration from the control plane._

## More information

[Link out to other CGW sections, currently we don't have those sections drafted, so I don't have anything to link to]
