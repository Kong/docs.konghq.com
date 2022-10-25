---
title: Runtime Instance Installation Options
no_version: true
---

{{site.konnect_short_name}} supports {{site.base_gateway}} as a runtime.
You can set up any number of {{site.base_gateway}} runtime instances.

A {{site.base_gateway}} runtime instance acts as a data plane, which is a node
serving traffic for the proxy. Data plane nodes are not directly connected
to a database. Instead, they receive configuration from their runtime group,
which stores and manages the configuration in {{site.konnect_saas}}.

{{site.base_gateway}} runtime instances can be installed on many different systems.
From bare metal, to virtual machines, and cloud native Kubernetes environments,
{{site.base_gateway}} is a low-demand, high-performing API gateway.

We recommend running one major version (2.x or 3.x) of a runtime instance per
runtime group, unless you are in the middle of version upgrades to the data plane.
Mixing versions may cause [compatibility issues](/konnect/runtime-manager/troubleshoot/#version-compatibility).

<!-- Runtime Manager provides pre-populated templates for AWS and Azure that you can create your runtime instances in any of these clouds directly from {{site.konnect_short_name}}. -->

{:.note}
> **Note:** Kong does not host runtimes. You must install and host your own
runtime instances.

This page outlines Kong's official support policy and provides links to detailed installation instructions for each.

_Note: We consider an installation option "Production Ready" when Kong guarantees support. All of the options below run as expected, but no official support is available for those marked with a_ <i class="fa fa-times" style="color: #d44324; opacity: 50%"></i>.

{% include feature-table.html config=site.data.tables.install_options_konnect columns='2' %}
