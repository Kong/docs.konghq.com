---
name: IP Restriction
publisher: Kong Inc.
version: 1.0.0

desc: Whitelist or blacklist IPs that can make requests to your Services
description: |
  Restrict access to a Service or a Route by either whitelisting or blacklisting IP addresses. Single IPs, multiple IPs or ranges in [CIDR notation](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_notation) like `10.10.10.0/24` can be used. The plugin supports IPv4 and IPv6 addresses.

type: plugin
categories:
  - security

kong_version_compatibility:
    community_edition:
      compatible:
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
        - 0.8.x
        - 0.7.x
        - 0.6.x
        - 0.5.x
        - 0.4.x
    enterprise_edition:
      compatible:
        - 1.5.x
        - 1.3-x
        - 0.36-x
        - 0.35-x
        - 0.34-x
        - 0.33-x
        - 0.32-x
        - 0.31-x

params:
  name: ip-restriction
  service_id: true
  route_id: true
  consumer_id: true
  protocols: ["http", "https"]
  dbless_compatible: yes
  config:
    - name: whitelist
      required: semi
      default:
      value_in_examples: [ "54.13.21.1", "143.1.0.0/24" ]
      description: |
        List of IPs or CIDR ranges to whitelist. One of `config.whitelist` or `config.blacklist` must be specified.
    - name: blacklist
      required: semi
      default:
      description: |
        List of IPs or CIDR ranges to blacklist. One of `config.whitelist` or `config.blacklist` must be specified.

  extra: |

    A `whitelist` provides a positive security model, in which the configured CIDR ranges are allowed access to the resource, and all others are inherently rejected. By contrast, a `blacklist` configuration provides a negative security model, in which certain CIDRS are explicitly denied access to the resource (and all others are inherently allowed).

    You can configure the plugin with both `whitelist` and `blacklist` configurations. An interesting use case of this flexibility is to whitelist a CIDR range, but blacklist an IP address on that CIDR range:

    ```bash
    $ curl -X POST http://kong:8001/services/{service}/plugins \
        --data "name=ip-restriction" \
        --data "config.whitelist=127.0.0.0/24" \
        --data "config.blacklist=127.0.0.1"
    ```

---
