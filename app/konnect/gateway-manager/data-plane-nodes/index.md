---
title: Installation Options
content_type: explanation
disable_image_expand: true
---

A data plane node is a single instance of {{site.base_gateway}} that acts as a proxy and serves traffic.
In {{site.konnect_saas}}, data plane nodes are managed by [control planes](/konnect/gateway-manager/control-plane-groups/). Control planes manage and store configurations in {{site.konnect_saas}}, and data plane nodes are configured according to the configuration distributed by the control plane.

{{site.konnect_short_name}} provides data plane node installation scripts for various platforms. 
These data plane nodes are configured to run in your {{site.konnect_short_name}} environment. Alternatively, {{site.konnect_short_name}} offers fully-managed data planes through [Dedicated Cloud Gateways](/konnect/gateway-manager/dedicated-cloud-gateways).

## Supported installation options

You can set up a data plane node by navigating to {% konnect_icon runtimes %} [**Gateway Manager**](https://cloud.konghq.com/gateway-manager), choosing a control plane, opening **Data Plane Nodes** from the side menu, then clicking on **New Data Plane Node**.

This brings you to a set of installation options. Choose one of the options, then follow the instructions in {{site.konnect_short_name}} to finish setting up.

{{site.konnect_short_name}} supports the following installation options:

![Konnect install options](/assets/images/products/konnect/gateway-manager/konnect-install-options.png){:.image-border}

Standard setup:
* macOS (ARM)
* macOS (Intel)
* Windows
* Linux (Docker)

Advanced setup:
* Linux
* Kubernetes
* AWS
* Azure
* Google Cloud

{:.note}
> **Notes:** 
> * Gateway Manager includes a feature called Control Plane Launcher which can be used with any of AWS, Azure, or GCP. This feature is currently in tech preview.
> * Gateway Manager allows users to select the {{site.base_gateway}} version that they want for their Quickstart scripts (except for cloud provider quickstart scripts for AWS, Azure, and GCP). This allows you to leverage official {{site.konnect_short_name}} scripts to start your gateways while reducing the number of errors due to an invalid script for a certain {{site.base_gateway}} version.
> * SSH access to Konnect data planes must be done using the cloud provider's tools when using [AWS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-connect-methods.html), [Azure](https://learn.microsoft.com/azure/cloud-shell/overview), and [Google Cloud](https://cloud.google.com/compute/docs/instances/ssh) advanced setups. Direct SSH access isn't possible because the keys are randomly generated and not exposed.

### Forward proxy support

{{site.konnect_product_name}} supports using non-transparent forward proxies to connect your {{site.base_gateway}} data plane with the {{site.konnect_saas}} control plane. See the [Forward proxy connections](/gateway/latest/production/networking/cp-dp-proxy/) {{site.base_gateway}} documentation for more information.

## Data plane node dashboard

![gateway data plane node dashboard](/assets/images/products/konnect/gateway-manager/konnect-runtime-instance-gateway.png)
> **Figure 1:** This image shows the Gateway data plane node dashboard. For each Gateway data plane node, you can see analytics, and host details.

## KIC data plane node dashboard
![KIC data plane node dashboard](/assets/images/products/konnect/gateway-manager/konnect-runtime-instance-kic.png)
> **Figure 2:** This image shows a KIC data plane node dashboard. For each KIC data plane node, you can see details about the data plane node, analytics, and KIC status details.

## More information

- [Upgrade a data plane node](/konnect/gateway-manager/data-plane-nodes/upgrade/)
- [Renew certificates](/konnect/gateway-manager/data-plane-nodes/renew-certificates/) - Renew your data plane certificates
- [Backup and restore](/konnect/gateway-manager/backup-restore/) - Back up and restore {{site.konnect_short_name}} using declarative configuration
- [Forward proxy connections](/gateway/latest/production/networking/cp-dp-proxy/) - Allow data plane nodes to communicate with {{site.konnect_short_name}} through a forward proxy
- [Data plane parameter reference](/konnect/gateway-manager/data-plane-nodes/parameter-reference/) - Reference for the default configuration parameters used in data plane node installation
- [Analytics dashboard](/konnect/analytics/) - Monitor and analyze your data plane nodes, as well as specific entities
- [Troubleshooting documentation](/konnect/gateway-manager/troubleshoot/) - Common data plane node troubleshooting instruction documentation.
