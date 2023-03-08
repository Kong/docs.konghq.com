---
title: Runtime Instance Installation Options
content_type: reference
---

{{site.konnect_short_name}} supports {{site.base_gateway}} as a runtime.
You can set up any number of {{site.base_gateway}} runtime instances.

A {{site.base_gateway}} runtime instance acts as a data plane, which is a node
serving traffic for the proxy. Data plane nodes are not directly connected
to a database. Instead, they receive configuration from their runtime group,
which stores and manages the configuration in {{site.konnect_saas}}. 

In situations where forward proxies are non-transparent, you can still connect the {{site.base_gateway}} data plane with the {{site.konnect_saas}} control plane. 
To do this, you need to configure each {{site.base_gateway}} runtime instance to authenticate with the proxy server and allow traffic through.
For more information, see [Control Plane and Data Plane Communication through a Forward Proxy](/gateway/latest/production/networking/cp-dp-proxy/) in the {{site.base_gateway}} documentation.

We recommend running one major version (2.x or 3.x) of a runtime instance per
runtime group, unless you are in the middle of version upgrades to the data plane.
Mixing versions may cause [compatibility issues](/konnect/runtime-manager/troubleshoot/#version-compatibility).

<!-- Runtime Manager provides pre-populated templates for AWS and Azure that you can create your runtime instances in any of these clouds directly from {{site.konnect_short_name}}. -->

{:.note}
> **Note:** Kong does not host runtimes. You must install and host your own
runtime instances.

{% include install.html config=site.data.tables.install_options_konnect header='no-header' %}
