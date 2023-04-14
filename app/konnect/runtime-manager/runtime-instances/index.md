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

{% include install.html config=site.data.tables.install_options_konnect header='no-header' %}

{:.note}
> **Note:** Kong does not host runtime instances. You must install and host your own.

### Forward proxy support

{{site.konnect_product_name}} supports using non-transparent forward proxies to connect your {{site.base_gateway}} data plane with the {{site.konnect_saas}} control plane. See the [Forward proxy connections](/gateway/latest/production/networking/cp-dp-proxy/){{site.base_gateway}} documentation for more information.

## More information

- [Upgrade a runtime instance](/konnect/runtime-manager/runtime-instances/upgrade/)
- [Renew certificates](/konnect/runtime-manager/runtime-instances/renew-certificates/) - Renew your data plane certificates
- [Backup and restore](/konnect/runtime-manager/backup-restore/) - Back up and restore {{site.konnect_short_name}} using declarative configuration
- [Forward proxy connections](/gateway/latest/production/networking/cp-dp-proxy/) - Allow runtime instances to communicate with {{site.konnect_short_name}} through a forward proxy
- [Runtime parameter reference](/konnect/runtime-manager/runtime-instances/runtime-parameter-reference/) - Reference for the default configuration parameters used in runtime instance installation
- [Analytics dashboard](/konnect/analytics/) - Monitor and analyze your runtime instances, as well as specific entities
- [Troubleshooting documentation](/konnect/runtime-manager/troubleshoot/) - Common runtime instance troubleshooting instruction documentation.