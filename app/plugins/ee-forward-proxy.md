---
id: page-plugin
title: Plugins - EE Forward Proxy
header_title: EE Forward Proxy
header_icon: /assets/images/icons/plugins/ee-forward-proxy.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Requesting Access
---

The Forward Proxy plugin allows Kong to connect to intermediary transparent HTTP proxies, instead of directly to the upstream_url, when forwarding requests upstream. This is useful in environments where Kong sits in an organization's internal network, the upstream API is available via the public internet, and the organization proxies all outbound traffic through a forward proxy server.
<br />

<div class="alert alert-warning">
  <strong>Enterprise-Only</strong> This plugin is only available with an
  Enterprise Subscription.
</div>

----

## Requesting Access

This plugin is only available with a [Kong Enterprise](https://konghq.com/kong-enterprise-edition)
subscription.

If you are not a Kong Enterprise customer, you can inquire about our
Enterprise offering by [contacting us](https://konghq.com/request-demo).
