---
redirect_to: /hub/kong-inc/zipkin


# !!!!!!!!!!!!!!!!!!!!!!!!   WARNING   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# FIXME This file is dead code - it is no longer being rendered or utilized,
# and updates to this file will have no effect.
#
# The remaining contents of this file (below) will be deleted soon.
#
# Updates to the content below should instead be made to the file(s) in /app/_hub/
#
# !!!!!!!!!!!!!!!!!!!!!!!!   WARNING   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!


id: page-plugin
title: Plugins - Zipkin
header_title: Zipkin  
header_icon: https://konghq.com/wp-content/uploads/2018/05/zipkin.png
header_btn_repo_href: https://github.com/Kong/kong-plugin-zipkin
breadcrumbs:
  Plugins: /plugins
nav:
  - label: How it Works
    items:
      - label: Extractor and Injector
      - label: Reporter
  - label: FAQ
description: |
  Propagate Zipkin distributed tracing spans, and report spans to a Zipkin server.

params:
  name: zipkin
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: http_endpoint
      required: true
      default: ""
      value_in_examples: http://your.zipkin.collector:9411/api/v2/spans
      description: |
        The full HTTP(S) endpoint to which Zipkin spans should be sent by Kong.
    - name: sample_ratio
      required: false
      default: "`0.001`"
      value_in_examples: 0.001
      description: |
        How often to sample requests that do not contain trace ids.
        Set to `0` to turn sampling off, or to `1` to sample **all** requests.

---

## How it Works

When enabled, [this plugin](https://github.com/Kong/kong-plugin-zipkin) traces requests in a way compatible with [zipkin](https://zipkin.io/).

The code is structured around an [opentracing](http://opentracing.io/) core using the [opentracing-lua library](https://github.com/Kong/opentracing-lua) to collect timing data of a request in each of Kong's phases.
The plugin uses opentracing-lua compatible extractor, injector, and reporters to implement Zipkin's protocols.

### Extractor and Injector

An opentracing "extractor" collects information from an incoming request.
If no trace ID is present in the incoming request, then one is probabilistically generated based on the `sample_ratio` configuration value.

An opentracing "injector" adds trace information to an outgoing request. Currently, the injector is only called for the request proxied by kong; it is **not** yet used for requests to the database or by other plugins (such as the [http-log plugin](./http-log/)).

This plugin follows Zipkin's ["B3" specification](https://github.com/openzipkin/b3-propagation/) as to which HTTP headers to use. Additionally, it supports [Jaegar](http://jaegertracing.io/)-style `uberctx-` headers for propagating [baggage](https://github.com/opentracing/specification/blob/master/specification.md#set-a-baggage-item).


### Reporter

An opentracing "reporter" is how tracing data is reported to another system.
This plugin records tracing data for a given request, and sends it as a batch to a Zipkin server using [the Zipkin v2 API](https://zipkin.io/zipkin-api/#/default/post_spans). Note that zipkin version 1.31 or higher is required.

The `http_endpoint` configuration variable must contain the full uri including scheme, host, port and path sections (i.e. your uri likely ends in `/api/v2/spans`).


## FAQ

#### Can I use this plugin with other tracing systems, like Jaeger?

Probably! Jaeger accepts spans in Zipkin format - see https://www.jaegertracing.io/docs/features/#backwards-compatibility-with-zipkin for more information.
