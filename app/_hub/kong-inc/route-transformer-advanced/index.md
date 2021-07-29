---
name: Route Transformer Advanced
publisher: Kong Inc.
# internal handler version 0.2.1

desc: Transform routing by changing the upstream server, port, or path
description: |
   This plugin transforms the routing on the fly in Kong, changing the upstream server, port, or path to hit. The substitutions can be configured via flexible templates.

type: plugin
enterprise: true
categories:
  - transformations

kong_version_compatibility:
    community_edition:
      compatible:
    enterprise_edition:
      compatible:
        - 2.4.x
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 1.5.x
        - 1.3-x

params:

  name: route-transformer-advanced
  service_id: true
  route_id: true
  consumer_id: true
  konnect_examples: false
  dbless_compatible: yes
  config:
    - name: path
      required: semi
      value_in_examples: [ "/path" ]
      datatype: string
      description: |
        Updates the upstream request path with given value/template. This value can only be used to update the path part of the URI, not the scheme, nor the hostname. One of `config.path` or `config.host` or `config.port` must be specified.
    - name: host
      required: semi
      datatype: string
      description: |
        Updates the upstream request Host with given value/template. This value can only be used to update the routing, it will not update the Host-header value. One of `config.path` or `config.host` or `config.port` must be specified.
    - name: port
      required: semi
      datatype: string
      description: |
         Updates the upstream request Port with given value/template. Note that the port as set may be overridden again by DNS resolution (in case of SRV records,or an Upstream) One of `config.path` or `config.host` or `config.port` must be specified.

---

_NOTE_: The advanced label is only attached because this is an Enterprise-only
plugin. There is no corresponding community plugin version available.

## Synopsis

This plugin transforms the routing on the fly in Kong, changing the upstream server/port/path to hit. The substitutions can be configured via flexible templates.

## Template as value

The templates that can be used as values are the same as the [request-transformer](/hub/kong-inc/request-transformer-advanced/).

[badge-travis-url]: https://travis-ci.com/Kong/kong-plugin-route-transformer-advanced/branches
[badge-travis-image]: https://travis-ci.com/Kong/kong-plugin-route-transformer-advanced.svg?token=BfzyBZDa3icGPsKGmBHb&branch=master
