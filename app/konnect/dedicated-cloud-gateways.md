---
title: About Cloud Gateways
content_type: concept
---

Dedicated cloud gateways are API gateway data plane nodes in {{site.konnect_short_name}} that are completely managed by Kong in the cloud provider of your choice. You maintain control over the size and location of the gateway infrastructure, while Kong oversees the management of each instance and the entire cluster for you. This allows Kong to autoscale your nodes for you and reduces your operational complexity.

You can manage your Dedicated Cloud Gateway nodes in [Gateway Manager](https://cloud.konghq.com/gateway-manager/).

![cloud gateway dashboard](/assets/images/products/konnect/gateway-manager/konnect-control-plane-cloud-gateway.png)
> _**Figure 1:** Example of the dedicated cloud gateway data plane node dashboard in Gateway Manager. The dashboard displays the requests, error rate, and P99 latency. It also displays the cluster configuration, as well as the data plane groups and regions._

Dedicated Cloud Gateways are useful for the following use cases:

| Use Case | Benefit |
| ------- | ----------- |
| Reducing latency is important to your org. You need an infrastructure that is fault tolerant and has low-latency. | Dedicated Cloud Gateways are supported on multiple AWS regions: Sydney, Tokyo, Singapore, Frankfurt, Ireland, London, Ohio, Oregon. This helps you achieve high availability and regional failover so that if one region goes down, you can switch to another. You can use this capability to implement configurations like [cross-region DNS-based load balancing and failover](https://docs.aws.amazon.com/whitepapers/latest/real-time-communication-on-aws/cross-region-dns-based-load-balancing-and-failover.html). |
| Your organization operates in a regulated industry with strict data protection and privacy requirements. | Dedicated Cloud Gateways help ensure compliance by keeping data traffic within a secure, private network, reducing exposure to external threats. If you select the private gateway option, Kong provisions a private network load balancer and only exposes the IP address in the UI. Only your users can hit the private IPs to access the gateway.|
| Your organization needs high availability with zero downtime while upgrading data plane nodes. | {{site.konnect_short_name}} handles upgrades for you. There's no downtime when upgrading the infrastructure because when Kong performs the rolling upgrade, we synchronize the data plane node with load balancer registration and deregistration and gracefully terminate the old data plane nodes to reduce the impact on ongoing traffic. Additionally, you can pre-warm your cluster by specifying the number of requests per second so that the first requests don’t have to wait for the infrastructure to scale up. |
| Your organization uses several tools for API gateways and their infrastructure and you  want to reduce operational complexity. | Kong manages the cluster for you, all you need to do is configure the {{site.base_gateway}} version, configuration mode, cluster region, and the API access level. |
| You have infrastructure in multiple clouds. | Dedicated Cloud Gateways allows you to run a multi-cloud solution that allows you to standardize API operations across the board to reduce complexity and increase agility. |

## How do Dedicated Cloud Gateways work?

{% include_cached /md/konnect/deployment-topologies.md topology='cloud' %}

> _**Figure 2:** In a dedicated cloud gateway, the control plane is hosted in {{site.konnect_short_name}} and data planes are hosted in the cloud by Kong. The control plane connects to the database, and the data planes receive configuration from the control plane._

When you create a Dedicated Cloud Gateway, {{site.konnect_short_name}} also creates a control plane for the cloud gateway. This control plane, like other {{site.konnect_short_name}} control planes, is hosted in {{site.konnect_short_name}} using the AWS infrastructure. Kong also creates, and manages, the data plane nodes in the AWS region that you specify while configuring the Dedicated Cloud Gateway.

When you configure your Dedicated Cloud Gateway, you can choose one of two configuration modes to create your data plane nodes:

* **Autopilot:** In Autopilot mode, you configure how many requests per second you expect the instance to recieve, then Kong pre-warms and autoscales the data plane nodes in the cluster for you.
* **Custom:** In Custom mode, you specify the instance size and type (for example, dev, production, or large production) as well as the number of nodes per cluster.

Because data plane nodes in Autopilot configuration mode are auto scaled, you **cannot** manually increase or decrease nodes. You can only manually increase or decrease data plane nodes when the Dedicated Cloud Gateway is configured in the Custom mode.

Control planes in {{site.konnect_short_name}} **cannot** contain both Dedicated Cloud Gateway and self-managed data plane nodes.

![cloud gateway wizard](/assets/images/products/konnect/gateway-manager/konnect-control-plane-cloud-gateway-wizard.png)
> _**Figure 3:** The Dedicated Cloud Gateway wizard in the {{site.konnect_short_name}} UI. The wizard allows you to configure the {{site.base_gateway}} version, mode, cluster region, and API access level._

## How do Dedicated Cloud Gateways secure my APIs?

When you create a Dedicated Cloud Gateway, you have the option to choose between public or private API access. When you choose private API access, Kong provisions a private network load balancer and only exposes the IP address in the {{site.konnect_short_name}} UI so only your users can hit the private IP to access the gateway. 

When you choose public API access, Kong provisions public network load balancers. Each network load balancer gets its own IP set and DNS record that Kong exposes in the {{site.konnect_short_name}} UI, as well as a top-level domain record that uses latency based routing. 

In addition, you can reuse the public gateway for a private gateway. Even though the gateway has a public IP, it will never leave the AWS Backbone in the region, so it's still within the AWS infrastructure. If you want strict gateway isolation, you can create separate public and private gateways. 

## More information

[Link out to other CGW sections and the API spec, currently we don't have those sections drafted, so I don't have anything to link to]
