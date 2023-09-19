---
title: Installation Options
content_type: explanation
disable_image_expand: true
---

A runtime instance is a single self-managed instance of {{site.base_gateway}} that functions as a data plane. In {{site.konnect_saas}}, runtime instances are part of [runtime groups](/konnect/runtime-manager/runtime-groups) and can be used to serve traffic to the runtime group. Runtime groups manage and store configuration in {{site.konnect_saas}}, and runtime instances are configured according to the configuration distributed by the runtime group.

{{site.konnect_short_name}} provides runtime instance installation scripts for various platforms. 
These runtime instances are configured to run in your {{site.konnect_short_name}} environment.

## Supported installation options

You can set up a runtime instance by navigating to {% konnect_icon runtimes %} [**Runtime Manager**](https://cloud.konghq.com/runtime-manager/), choosing a runtime group, then clicking on **New Runtime Instance**.

This brings you to a set of installation options. Choose one of the options, then follow the instructions in {{site.konnect_short_name}} to finish setting up.

{{site.konnect_short_name}} supports the following installation options:

![Konnect install options](https://github.com/Kong/docs.konghq.com/assets/8153796/fa7fccda-cc4f-47a6-bdc3-491d053b3cc5)

* macOS
* Windows
* Linux
* Linux (Docker)
* Kubernetes
* AWS
* Azure
* Google Cloud

{:.note}
> **Notes:** 
> * Runtime Manager includes a feature called Runtime Launcher which can be used with any of AWS, Azure, or GCP. This feature is currently in tech preview.
> * Kong does not host runtime instances. You must install and host your own.
> * Runtime Manager allows users to select the {{site.base_gateway}} version that they want for their Quickstart scripts (except for cloud provider quickstart scripts for AWS, Azure, and GCP). This allows you to leverage official {{site.konnect_short_name}} scripts to start your gateways while reducing the number of errors due to an invalid script for a certain {{site.base_gateway}} version.

### Forward proxy support

{{site.konnect_product_name}} supports using non-transparent forward proxies to connect your {{site.base_gateway}} data plane with the {{site.konnect_saas}} control plane. See the [Forward proxy connections](/gateway/latest/production/networking/cp-dp-proxy/) {{site.base_gateway}} documentation for more information.

## Runtime instance dashboard
### Gateway runtime instance dashboard
![gateway runtime instance dashboard](/assets/images/docs/konnect/konnect-runtime-instance-gateway.png)
> **Figure 1:** This image shows a Gateway runtime instance dashboard. For each Gateway runtime instance, you can see details about the runtime instance, analytics, and host details.

### KIC runtime instance dashboard
![KIC runtime instance dashboard](/assets/images/docs/konnect/konnect-runtime-instance-kic.png)
> **Figure 2:** This image shows a KIC runtime instance dashboard. For each KIC runtime instance, you can see details about the runtime instance, analytics, and KIC status details.

## More information

- [Upgrade a runtime instance](/konnect/runtime-manager/runtime-instances/upgrade/)
- [Renew certificates](/konnect/runtime-manager/runtime-instances/renew-certificates/) - Renew your data plane certificates
- [Backup and restore](/konnect/runtime-manager/backup-restore/) - Back up and restore {{site.konnect_short_name}} using declarative configuration
- [Forward proxy connections](/gateway/latest/production/networking/cp-dp-proxy/) - Allow runtime instances to communicate with {{site.konnect_short_name}} through a forward proxy
- [Runtime parameter reference](/konnect/runtime-manager/runtime-instances/runtime-parameter-reference/) - Reference for the default configuration parameters used in runtime instance installation
- [Analytics dashboard](/konnect/analytics/) - Monitor and analyze your runtime instances, as well as specific entities
- [Troubleshooting documentation](/konnect/runtime-manager/troubleshoot/) - Common runtime instance troubleshooting instruction documentation.
