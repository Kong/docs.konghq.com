---
id: page-plugin
title: Plugins - EE Forward Proxy
layout: plugin-ee
header_title: EE Forward Proxy
header_icon: /assets/images/icons/plugins/ee-forward-proxy.png
header_btn_text: Report Bug
header_btn_href: mailto:support@konghq.com?subject={{ page.header_title }} Plugin Bug
breadcrumbs:
  Plugins: /plugins
description: |
  The Forward Proxy plugin allows Kong to connect to intermediary transparent HTTP proxies, instead of directly to the upstream_url, when forwarding requests upstream. This is useful in environments where Kong sits in an organization's internal network, the upstream API is available via the public internet, and the organization proxies all outbound traffic through a forward proxy server.

---
