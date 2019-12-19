---
name: Route Transformer Advanced
publisher: Kong Inc.

desc: Transform routing by changing the upstream server, port, or path.
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
        - 1.3-x

params:

  name: route-transformer-advanced
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: path
      required: false
      description: |
        Updates the upstream request path with given value/template. This value can only be used to update the path part of the URI, not the scheme, nor the hostname.
    - name: host
      required: false
      description: |
        Updates the upstream request Host with given value/template. This value can only be used to update the routing, it will not update the Host-header value.
    - name: port
      required: false
      description: | 
         Updates the upstream request Port with given value/template. Note that the port as set may be overridden again by DNS resolution (in case of SRV records,or an Upstream)

---

_NOTE_: the 'advanced' label is only attached since this is an enterprise only
plugin. There is not a 'regular' version available.

## Synopsis

This plugin transforms the routing on the fly in Kong, changing the upstream server/port/path to hit. The substitutions can be configured via flexible templates.

## History

See [the changelog](https://github.com/Kong/kong-plugin-route-transformer-advanced/blob/master/CHANGELOG.md).

## Template as Value

The templates that can be used as values are the same as the [request-transformer](https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/).

[badge-travis-url]: https://travis-ci.com/Kong/kong-plugin-route-transformer-advanced/branches
[badge-travis-image]: https://travis-ci.com/Kong/kong-plugin-route-transformer-advanced.svg?token=BfzyBZDa3icGPsKGmBHb&branch=master