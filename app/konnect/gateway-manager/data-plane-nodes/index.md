---
title: Installation Options
content_type: explanation
disable_image_expand: true
---

A data plane node is a single self-managed instance of {{site.base_gateway}} that acts as a proxy and serves traffic.
In {{site.konnect_saas}}, data planes are managed by [control planes](/konnect/gateway-manager/control-plane-groups/). Control planes manage and store configurations in {{site.konnect_saas}}, and data plane nodes are configured according to the configuration distributed by the control plane.

{{site.konnect_short_name}} provides data plane node installation scripts for various platforms. 
These data plane nodes are configured to run in your {{site.konnect_short_name}} environment.

## Supported installation options

You can set up a data plane node by navigating to {% konnect_icon runtimes %} [**Gateway Manager**](https://cloud.konghq.com/runtime-manager/), choosing a control plane, then clicking on **New Data Plane Node**.

This brings you to a set of installation options. Choose one of the options, then follow the instructions in {{site.konnect_short_name}} to finish setting up.

{{site.konnect_short_name}} supports the following installation options:

{% include install.html config=site.data.tables.install_options_konnect header='no-header' %}

{:.note}
> **Notes:** 
> * Gateway Manager includes a feature called Runtime Launcher which can be used with any of AWS, Azure, or GCP. This feature is currently in tech preview.
> * Kong does not host data plane nodes. You must install and host your own.
> * Gateway Manager allows users to select the {{site.base_gateway}} version that they want for their Quickstart scripts (except for cloud provider quickstart scripts for AWS, Azure, and GCP). This allows you to leverage official {{site.konnect_short_name}} scripts to start your gateways while reducing the number of errors due to an invalid script for a certain {{site.base_gateway}} version.

### Forward proxy support

{{site.konnect_product_name}} supports using non-transparent forward proxies to connect your {{site.base_gateway}} data plane with the {{site.konnect_saas}} control plane. See the [Forward proxy connections](/gateway/latest/production/networking/cp-dp-proxy/) {{site.base_gateway}} documentation for more information.

## Data plane node dashboard
### Data plane node dashboard
![gateway data plane node dashboard](/assets/images/docs/konnect/konnect-runtime-instance-gateway.png)
> **Figure 1:** This image shows the Gateway data plane node dashboard. For each Gateway data plane node, you can see analytics, and host details.

### KIC data plane node dashboard
![KIC data plane node dashboard](/assets/images/docs/konnect/konnect-runtime-instance-kic.png)
> **Figure 2:** This image shows a KIC data plane node dashboard. For each KIC data plane node, you can see details about the data plane node, analytics, and KIC status details.

## More information

- [Upgrade a data plane node](/konnect/runtime-manager/runtime-instances/upgrade/)
- [Renew certificates](/konnect/runtime-manager/runtime-instances/renew-certificates/) - Renew your data plane certificates
- [Backup and restore](/konnect/runtime-manager/backup-restore/) - Back up and restore {{site.konnect_short_name}} using declarative configuration
- [Forward proxy connections](/gateway/latest/production/networking/cp-dp-proxy/) - Allow data plane nodes to communicate with {{site.konnect_short_name}} through a forward proxy
- [Runtime parameter reference](/konnect/runtime-manager/runtime-instances/runtime-parameter-reference/) - Reference for the default configuration parameters used in data plane node installation
- [Analytics dashboard](/konnect/analytics/) - Monitor and analyze your data plane nodes, as well as specific entities
- [Troubleshooting documentation](/konnect/runtime-manager/troubleshoot/) - Common data plane node troubleshooting instruction documentation.
