---
title: About Cloud Gateways
content_type: concept
---

Dedicated cloud gateways are API gateway data plane nodes in {{site.konnect_short_name}} that are completely managed by the cloud provider of your choice. You maintain control over the size and location of the gateway infrastructure, while Kong oversees the management of each instance and the entire cluster for you. This allows Kong to autoscale your nodes for you and reduces your operational complexity.

You can manage your dedicated cloud gateway nodes alongside all your other gateway nodes in [Gateway Manager](https://cloud.konghq.com/gateway-manager/).

{% include_cached /md/konnect/deployment-topologies.md topology='cloud' %}

> _Figure 1: In a dedicated cloud gateway, the control plane is hosted in {{site.konnect_short_name}} and data planes are hosted in the cloud by Kong. The control plane connects to the database, and the data planes receive configuration from the control plane._

Dedicated cloud gateways are useful for the following use cases:

| Use Case | Benefit |
| ------- | ----------- |
| Reducing latency is important to your org. You need an infrastructure that is fault tolerant and has low-latency. | Dedicated cloud gateways are supported on multiple AWS regions: Sydney, Tokyo, Singapore, Frankfurt, Ireland, London, Ohio, Oregon. This helps you achieve high availability and regional failover so that if one region goes down, you can switch to another. You can use this capability to implement configurations like [cross-region DNS-based load balancing and failover](https://docs.aws.amazon.com/whitepapers/latest/real-time-communication-on-aws/cross-region-dns-based-load-balancing-and-failover.html). |
| Your organization operates in a regulated industry with strict data protection and privacy requirements. | Ensures compliance by keeping data traffic within a secure, private network, reducing exposure to external threats. |
| Your organization needs high availability with zero downtime while upgrading data plane nodes. | {{site.konnect_short_name}} handles upgrades for you. There's no downtime when upgrading the infrastructure. Additionally, you can pre-warm your cluster by specifying the number of requests per second so that the first requests don’t have to wait for the infrastructure to scale up. |
| Your organization uses several tools for API gateways and their infrastructure and you  want to reduce operational complexity. | Kong manages the cluster for you, all you need to do is configure the {{site.base_gateway}} version, configuration mode, cluster region, and the API access level. |
| You have infrastructure in multiple clouds. | Dedicated Cloud Gateways allows you to run a multi-cloud solution that allows to standardize API operations across the board to reduce complexity and increase agility. |

## More information

[Link out to other CGW sections, currently we don't have those sections drafted, so I don't have anything to link to]
