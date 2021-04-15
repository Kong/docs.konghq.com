---
name: IP Restriction
publisher: Kong Inc.
version: 2.0.x

desc: Allow or deny IPs that can make requests to your Services
description: |
  Restrict access to a Service or a Route by either allowing or denying IP addresses. Single IPs, multiple IPs or ranges in [CIDR notation](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_notation) like `10.10.10.0/24` can be used. The plugin supports IPv4 and IPv6 addresses.

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
        - 0.8.x
        - 0.7.x
        - 0.6.x
        - 0.5.x
        - 0.4.x
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
  name: ip-restriction
  service_id: true
  route_id: true
  consumer_id: true
  protocols: ["http", "https"]
  dbless_compatible: yes
  config:
    - name: allow
      required: semi
      default:
      value_in_examples: [ "54.13.21.1", "143.1.0.0/24" ]
      datatype: array of string elements
      description: |
        List of IPs or CIDR ranges to allow. One of `config.allow` or `config.deny` must be specified.
    - name: deny
      required: semi
      default:
      datatype: array of string elements
      description: |
        List of IPs or CIDR ranges to deny. One of `config.allow` or `config.deny` must be specified.

  extra: |

    An `allow` list provides a positive security model, in which the configured CIDR ranges are allowed access to the resource, and all others are inherently rejected. By contrast, a `deny` list configuration provides a negative security model, in which certain CIDRS are explicitly denied access to the resource (and all others are inherently allowed).

    You can configure the plugin with both `allow` and `deny` configurations. An interesting use case of this flexibility is to allow a CIDR range, but deny an IP address on that CIDR range:

    ```bash
    $ curl -X POST http://kong:8001/services/{service}/plugins \
        --data "name=ip-restriction" \
        --data "config.allow=127.0.0.0/24" \
        --data "config.deny=127.0.0.1"
    ```

---
