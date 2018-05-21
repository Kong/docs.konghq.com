---
id: page-plugin
title: Plugins - Zipkin
header_title: Zipkin  
header_icon: https://konghq.com/wp-content/uploads/2018/05/zipkin.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Documentation
    items:
      - label: How it Works FIXME
      - label: Generators FIXME
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
      value_in_examples: http://your.zipkin.collector
      description: |
        The HTTP(S) endpoint to which Zipkin spans should be sent by Kong.

---

## How it Works FIXME

It does things. FIXME

## Generators FIXME

#### sub-heading FIXME

Details here FIXME

#### another sub-heading FIXME

Details here FIXME.



## FAQ

#### Can I use this plugin with other tracing systems, like Jaeger?

Probably! Jaeger accepts spans in Zipkin format - see https://www.jaegertracing.io/docs/features/#backwards-compatibility-with-zipkin for more information.
