---
name: IP Restriction
publisher: Kong Inc.

desc: Whitelist or blacklist IPs that can make API requests
description: |
  Restrict access to a Service or a Route (or the deprecated API entity) by either whitelisting or blacklisting IP addresses. Single IPs, multiple IPs or ranges in [CIDR notation](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_notation) like `10.10.10.0/24` can be used.

type: plugin
categories:
  - security

kong_version_compatibility:
    community_edition:
      compatible:
        - 0.14.x
        - 0.13.x
        - 0.12.x
        - 0.11.x
        - 0.10.x
        - 0.9.x
        - 0.8.x
        - 0.7.x
        - 0.6.x
        - 0.5.x
        - 0.4.x
    enterprise_edition:
      compatible:
        - 0.34-x
        - 0.33-x
        - 0.32-x
        - 0.31-x

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
