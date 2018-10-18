---
redirect_to: /hub/kong-inc/forward-proxy


# !!!!!!!!!!!!!!!!!!!!!!!!   WARNING   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# FIXME This file is dead code - it is no longer being rendered or utilized,
# and updates to this file will have no effect.
#
# The remaining contents of this file (below) will be deleted soon.
#
# Updates to the content below should instead be made to the file(s) in /app/_hub/
#
# !!!!!!!!!!!!!!!!!!!!!!!!   WARNING   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!


id: page-plugin
title: Plugins - Kong Enterprise Forward Proxy
layout: plugin-ee
header_title: Kong Enterprise Forward Proxy
header_icon: https://2tjosk2rxzc21medji3nfn1g-wpengine.netdna-ssl.com/wp-content/uploads/2017/11/EE-forward-proxy.svg
breadcrumbs:
  Plugins: /plugins
description: |
  The Forward Proxy plugin allows Kong to connect to intermediary transparent HTTP proxies, instead of directly to the upstream_url, when forwarding requests upstream. This is useful in environments where Kong sits in an organization's internal network, the upstream API is available via the public internet, and the organization proxies all outbound traffic through a forward proxy server.

  * [Detailed documentation for the Kong Enterprise Forward Proxy Plugin](/enterprise/latest/plugins/forward-proxy/)
---
