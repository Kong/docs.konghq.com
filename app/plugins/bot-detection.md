---
redirect_to: /hub/kong-inc/bot-detection


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
title: Plugins - Bot Detection
header_title: Bot Detection
header_icon: /assets/images/icons/plugins/bot-detection.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Usage
    items:
      - label: Default rules
description: |
  Protects a Service or a Route (or the deprecated API entity) from most common bots and has the capability of whitelisting and blacklisting custom clients.

params:
  name: bot-detection
  api_id: true
  service_id: true
  route_id: true
  consumer_id: false
  config:
    - name: whitelist
      required: false
      default:
      description: |
        A comma separated array of regular expressions that should be whitelisted. The regular expressions will be checked against the `User-Agent` header.
    - name: blacklist
      required: false
      default:
      description: |
        A comma separated array of regular expressions that should be blacklisted. The regular expressions will be checked against the `User-Agent` header.

---

## Default rules

The plugin already includes a basic list of rules that will be checked on every request. You can find this list on GitHub at [https://github.com/Kong/kong/blob/master/kong/plugins/bot-detection/rules.lua](https://github.com/Kong/kong/blob/master/kong/plugins/bot-detection/rules.lua).

[api-object]: /latest/admin-api/#api-object
[configuration]: /latest/configuration
[consumer-object]: /latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
