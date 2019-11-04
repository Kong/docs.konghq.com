---
title: Route Transformer Advanced Plugin
---

_NOTE_: the 'advanced' label is only attached since this is an enterprise only
plugin. There is not a 'regular' version available.

## Synopsis

This plugin transforms the routing on the fly in Kong, changing the upstream server/port/path to hit. The substitutions can be configured via flexible templates.

## History

See [the changelog](https://github.com/Kong/kong-plugin-route-transformer-advanced/blob/master/CHANGELOG.md).

## Configuration

| form parameter   | default             | description  |
| ---              | ---                 | ---          |
| `name`           |                     | The name of the plugin to use, in this case `route-transformer-advanced`
| `service_id`     |                     | The id of the Service which this plugin will target.
| `route_id`       |                     | The id of the Route which this plugin will target.
| `enabled`        | `true`              | Whether this plugin will be applied.
| `consumer_id`    |                     | The id of the Consumer which this plugin will target.
| `config.path`    |                     | Updates the upstream request path with given value/template. This value can only be used to update the path part of the URI, not the scheme, nor the hostname.
| `config.host`    |                     | Updates the upstream request Host with given value/template. This value can only be used to update the routing, it will not update the Host-header value.
| `config.port`    |                     | Updates the upstream request Port with given value/template. NOTE: the port as set may be overridden again by DNS resolution (in case of SRV records, or an Upstream)

## Template as Value

The templates that can be used as values are the same as the [request-transformer](https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/).

[badge-travis-url]: https://travis-ci.com/Kong/kong-plugin-route-transformer-advanced/branches
[badge-travis-image]: https://travis-ci.com/Kong/kong-plugin-route-transformer-advanced.svg?token=BfzyBZDa3icGPsKGmBHb&branch=master
