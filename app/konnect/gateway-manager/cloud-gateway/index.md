---
title: About Cloud Gateways
content_type: concept
---

Dedicated cloud gateways are a type of API gateway in {{site.konnect_short_name}} that are completely managed in the cloud provider of your choice. With a dedicated cloud infrastructure, you have control over the sizing and deployment locations of the gateway infrastructure, without having to manage the operations of individual instances that we will be deploying for them, nor they directly manage operations of the cluster other than specifying the desidered state.

In just a few clicks, you can configure a dedicated cloud gateway using the UI wizard in {{site.konnect_short_name}}. You can manage your dedicated cloud gateways alongside all your other gateways.

[Screenshots of the new deployment dashboard]

Dedicated cloud gateways have the following benefits over a typical hybrid gateway:

* **Pre-warm cluster:** You can pre-warm your cluster by specifying the number of requests per second so that the first requests don’t have to wait for the infrastructure to scale up.
* **Fast setup:** Configure and start your dedicated cloud gateway in x steps, a regular hybrid gateway takes longer to configure at x steps.  
* **SOC1 compliant:** Dedicated cloud gateways are SOC1 compliant out-of-the-box.
* **One click upgrades:** {{site.konnect_short_name}} handles upgrades for you. You decide when you want to upgrade and what {{site.base_gateway}} version you want to upgrade to and {{site.konnect_short_name}} does it for you. There's no downtime when upgrading the infrastructure.
* **Multi-region:** Dedicated cloud gateways are supported on the following AWS regions: Sydney, Tokyo, Singapore, Frankfurt, Ireland, London, Ohio, Oregon.

With dedicated cloud gateways, you can use the following features: 

* **Security:** You can choose between the following;
    * L7 security with proxy secret injection and client certificate.
    * Firewall with Egress IPs
    * VPC peering
    * Private links <!--might not be MVP-->
* **DNS:** You specify a geo-load balanced global DNS that points to each cloud and region that are part of the dedicated cloud. There is a DNS for both the proxy API, to consume APIs, and the Admin API, to programmatically configure the cluster.
* **Upgrades:** {{site.konnect_short_name}} handles upgrades for you. You decide when you want to upgrade and what {{site.base_gateway}} version you want to upgrade to and {{site.konnect_short_name}} does it for you. There's no downtime when upgrading the infrastructure.
* **Compliance:** Dedicated cloud gateways are SOC1 compliant.
* **Autopilot:** Pre-warm your cluster by specifying the number of requests per second so that the first requests don’t have to wait for the infrastructure to scale up.
* **Node limit information:** the limit is going to be 30 nodes (across the aggregate of all the regions configured) per control plane.
* **Available regions and providers:** AWS on the following regions: Sydney, Tokyo, Singapore, Frankfurt, Ireland, London, Ohio, Oregon.

## Diagram of how the thing works

cool diagram

## More information

Link out to other CGW sections
