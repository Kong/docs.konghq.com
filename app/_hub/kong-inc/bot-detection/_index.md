---
name: Bot Detection
publisher: Kong Inc.
desc: Detect and block bots or custom clients
description: |
  Protects a Service or a Route from most common bots and has the capability of allowing and denying custom clients.
type: plugin
categories:
  - security
kong_version_compatibility:
  community_edition:
    compatible:
      - 2.8.x
      - 2.7.x
      - 2.6.x
      - 2.5.x
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x
      - 2.0.x

  enterprise_edition:
    compatible:
      - 2.8.x
      - 2.7.x
      - 2.6.x
      - 2.5.x
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x

params:
  name: bot-detection
  service_id: true
  route_id: true
  consumer_id: false
  protocols:
    - http
    - https
  dbless_compatible: 'yes'
  config:

  # deprecated parameters
    - name: whitelist
      required: false
      default:
      description: |
        A comma separated array of regular expressions that should be whitelisted. The regular expressions will be checked against the `User-Agent` header.
      maximum_version: "2.0.x"
    - name: blacklist
      required: false
      default:
      description: |
        A comma separated array of regular expressions that should be blacklisted. The regular expressions will be checked against the `User-Agent` header.
      maximum_version: "2.0.x"

# current parameters
    - name: allow
      required: false
      default: null
      datatype: array of string elements
      description: |
        An array of regular expressions that should be allowed. The regular expressions will be checked against the `User-Agent` header.
      minimum_version: "2.1.x"
    - name: deny
      required: false
      default: null
      datatype: array of string elements
      description: |
        An array of regular expressions that should be denied. The regular expressions will be checked against the `User-Agent` header.
      minimum_version: "2.1.x"

---

## Default rules

{% if_plugin_version gte:2.1.x and lte:2.8.x %}

{:.note}
> **Note**: We have deprecated the usage of `whitelist` and `blacklist` in favor of `allow` and `deny`. This change may require Admin API requests to be updated.

{% endif_plugin_version %}

The plugin already includes a basic list of rules that will be checked on every request. You can find this list on GitHub at [https://github.com/Kong/kong/blob/master/kong/plugins/bot-detection/rules.lua](https://github.com/Kong/kong/blob/master/kong/plugins/bot-detection/rules.lua).

[api-object]: /gateway/latest/admin-api/#api-object
[configuration]: /gateway/latest/reference/configuration
[consumer-object]: /gateway/latest/admin-api/#consumer-object


{% if_plugin_version gte:2.1.x %}

---

## Changelog

{% if_plugin_version gte:3.0.x %}

### Kong Gateway 3.0.x
- Removed the deprecated `whitelist` and `blacklist` parameters.
They are no longer supported.

{% endif_plugin_version %}

### Kong Gateway 2.1.x (plugin version 2.0.0)

- Use `allow` and `deny` instead of `whitelist` and `blacklist`

{% endif_plugin_version %}
