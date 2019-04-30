---
name: Bot Detection
publisher: Kong Inc.
version: 1.0.0

desc: Detect and block bots or custom clients
description: |
  Protects a Service or a Route from most common bots and has the capability of whitelisting and blacklisting custom clients.

type: plugin
categories:
  - security

kong_version_compatibility:
    community_edition:
      compatible:
        - 1.0.x
        - 0.14.x
        - 0.13.x
        - 0.12.x
        - 0.11.x
        - 0.10.x
        - 0.9.x
    enterprise_edition:
      compatible:
        - 0.34-x
        - 0.33-x
        - 0.32-x
        - 0.31-x

params:
  name: bot-detection
  service_id: true
  route_id: true
  consumer_id: false
  protocols: ["http", "https"]
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
