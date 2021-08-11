---
name: Bot Detection
publisher: Kong Inc.
version: 1.0.0

desc: Detect and block bots or custom clients
description: |
  Protects a Service or a Route from most common bots and has the capability of allowing and denying custom clients.

type: plugin
categories:
  - security

kong_version_compatibility:
    community_edition:
      compatible:
        - 2.4.x
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 2.0.x
        - 1.5.x
        - 1.4.x
        - 1.3.x
        - 1.2.x
        - 1.1.x
        - 1.0.x
        - 0.14.x
        - 0.13.x
        - 0.12.x
        - 0.11.x
        - 0.10.x
        - 0.9.x
    enterprise_edition:
      compatible:
        - 2.4.x
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 1.5.x
        - 1.3-x
        - 0.36-x

params:
  name: bot-detection
  service_id: true
  route_id: true
  consumer_id: false
  protocols: ["http", "https"]
  dbless_compatible: yes
  config:
    - name: allow
      required: false
      default:
      datatype: array of string elements
      description: |
        An array of regular expressions that should be allowed. The regular expressions will be checked against the `User-Agent` header.
    - name: deny
      required: false
      default:
      datatype: array of string elements
      description: |
        An array of regular expressions that should be denied. The regular expressions will be checked against the `User-Agent` header.

---

## Default rules

The plugin already includes a basic list of rules that will be checked on every request. You can find this list on GitHub at [https://github.com/Kong/kong/blob/master/kong/plugins/bot-detection/rules.lua](https://github.com/Kong/kong/blob/master/kong/plugins/bot-detection/rules.lua).

[api-object]: /gateway-oss/latest/admin-api/#api-object
[configuration]: /gateway-oss/latest/configuration
[consumer-object]: /gateway-oss/latest/admin-api/#consumer-object

