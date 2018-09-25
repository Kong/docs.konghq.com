---
redirect_to: /hub/kong-inc/ip-restriction

id: page-plugin
title: Plugins - IP Restriction
header_title: IP Restriction
header_icon: /assets/images/icons/plugins/ip-restriction.png
breadcrumbs:
  Plugins: /plugins

description: |
  Restrict access to a Service or a Route (or the deprecated API entity) by either whitelisting or blacklisting IP addresses. Single IPs, multiple IPs or ranges in [CIDR notation](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_notation) like `10.10.10.0/24` can be used.

params:
  name: ip-restriction
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: whitelist
      required: semi
      default:
      value_in_examples: 54.13.21.1, 143.1.0.0/24
      description: |
        Comma separated list of IPs or CIDR ranges to whitelist. One of `config.whitelist` or `config.blacklist` must be specified.
    - name: blacklist
      required: semi
      default:
      description: |
        Comma separated list of IPs or CIDR ranges to blacklist. One of `config.whitelist` or `config.blacklist` must be specified.

  extra: |

    Note that the `whitelist` and `blacklist` models are mutually exclusive in their usage, as they provide complimentary approaches. That is, you cannot configure the plugin with both `whitelist` and `blacklist` configurations. An `whitelist` provides a positive security model, in which the configured CIDR ranges are allowed access to the resource, and all others are inherently rejected. By contrast, a `blacklist` configuration provides a negative security model, in which certain CIDRS are explicitly denied access to the resource (and all others are inherently allowed).

---
