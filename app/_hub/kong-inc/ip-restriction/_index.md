---
name: IP Restriction
publisher: Kong Inc.
desc: Allow or deny IPs that can make requests to your Services
description: |
  Restrict access to a Service or a Route by either allowing or denying IP addresses. Single IPs, multiple IPs, or ranges in [CIDR notation](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_notation) like `10.10.10.0/24` can be used. The plugin supports IPv4 and IPv6 addresses.

type: plugin
categories:
  - security
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
params:
  name: ip-restriction
  service_id: true
  route_id: true
  consumer_id: true
  protocols:
    - http
    - https
  dbless_compatible: 'yes'
  config:

# deprecated parameters and previous versions
    - name: whitelist
      required: semi
      default:
      value_in_examples: 54.13.21.1, 143.1.0.0/24
      description: |
        Comma-separated list of IPs or CIDR ranges to whitelist. One of `config.whitelist` or `config.blacklist` must be specified.
      maximum_version: "2.0.x"
    - name: blacklist
      required: semi
      default:
      description: |
        Comma-separated list of IPs or CIDR ranges to blacklist. One of `config.whitelist` or `config.blacklist` must be specified.
      maximum_version: "2.0.0"
    - name: allow
      required: semi
      default: null
      value_in_examples:
        - 54.13.21.1
        - 143.1.0.0/24
      datatype: array of string elements
      description: |
        List of IPs or CIDR ranges to allow. One of `config.allow` or `config.deny` must be specified.

        Note: We have deprecated the usage of `whitelist` and `blacklist` in favor of `allow` and `deny`.  
      minimum_version: "2.1.x"
      maximum_version: "2.8.x"
    - name: deny
      required: semi
      default: null
      datatype: array of string elements
      description: |
        List of IPs or CIDR ranges to deny. One of `config.allow` or `config.deny` must be specified.

        Note: We have deprecated the usage of `whitelist` and `blacklist` in favor of `allow` and `deny`.  
      minimum_version: "2.1.x"
      maximum_version: "2.8.x"

# current parameters
    - name: allow
      required: semi
      default: null
      value_in_examples:
        - 54.13.21.1
        - 143.1.0.0/24
      datatype: array of string elements
      description: |
        List of IPs or CIDR ranges to allow. One of `config.allow` or `config.deny` must be specified.
      minimum_version: "3.0.x"
    - name: deny
      required: semi
      default: null
      datatype: array of string elements
      description: |
        List of IPs or CIDR ranges to deny. One of `config.allow` or `config.deny` must be specified.
      minimum_version: "3.0.x"
    - name: status
      required: false
      default: 403
      datatype: integer
      description: |
        The HTTP status of the requests that will be rejected by the plugin.
      minimum_version: "2.7.x"
    - name: message
      required: false
      default: Your IP address is not allowed
      datatype: string
      description: |
        The message to send as a response body to rejected requests.
      minimum_version: "2.7.x"
---
## Usage

{% if_plugin_version gte:2.1.x %}

{% if_plugin_version lte:2.8.x %}

{:.note}
> **Note**: We have deprecated the usage of `whitelist` and `blacklist` in favor of `allow` and `deny`. This change may require Admin API requests to be updated.

{% endif_plugin_version %}

An `allow` list provides a positive security model, in which the configured CIDR ranges are allowed access to the resource, and all others are inherently rejected. By contrast, a `deny` list configuration provides a negative security model, in which certain CIDRS are explicitly denied access to the resource (and all others are inherently allowed).

You can configure the plugin with both `allow` and `deny` configurations. An interesting use case of this flexibility is to allow a CIDR range, but deny an IP address on that CIDR range:

```bash
$ curl -X POST http://kong:8001/services/{service}/plugins \
    --data "name=ip-restriction" \
    --data "config.allow=127.0.0.0/24" \
    --data "config.deny=127.0.0.1"
```
{% endif_plugin_version %}

{% if_plugin_version eq:2.0.x %}

Note that the `whitelist` and `blacklist` models are mutually exclusive in their usage, as they provide complimentary approaches. That is, you cannot configure the plugin with both `whitelist` and `blacklist` configurations. A `whitelist` provides a positive security model, in which the configured CIDR ranges are allowed access to the resource, and all others are inherently rejected. In contrast, a `blacklist` configuration provides a negative security model, in which certain CIDRS are explicitly denied access to the resource (and all others are inherently allowed).

{% endif_plugin_version %}

---

## Changelog

**{{site.base_gateway}} 3.0.x**
- Removed the deprecated `whitelist` and `blacklist` parameters.
They are no longer supported.

**{{site.base_gateway}} 2.7.x**
- Addition of `status` and `message` fields

**{{site.base_gateway}} 2.1.x**
- Use `allow` and `deny` instead of `whitelist` and `blacklist`
