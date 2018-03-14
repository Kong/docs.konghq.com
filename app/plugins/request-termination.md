---
id: page-plugin
title: Plugins - Request Termination
header_title: Request Termination
header_icon: /assets/images/icons/plugins/request-termination.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Usage
    items:
      - label: Example Use Cases

description: |
  This plugin terminates incoming requests with a specified status code and
  message. This allows to (temporarily) block a Route, Service, API or Consumer.

params:
  name: request-termination
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: status_code
      required: false
      default: "`503`"
      value_in_examples: 403
      description: The response code to send.
    - name: message
      required: false
      value_in_examples: "So long and thanks for all the fish!"
      description: The message to send, if using the default response generator.
    - name: body
      required: false
      description: The raw response body to send, this is mutually exclusive with the `config.message` field.
    - name: content_type
      required: false
      default: "`application/json; charset=utf-8`"
      description: Content type of the raw response configured with `config.body`.
  extra: |
    Once applied, every request (within the configured plugin scope of an API,
    Route, Service, Consumer, or global) will be immediately terminated by
    sending the configured response.

---

## Example Use Cases

- Temporarily disable an API (ex: maintenance mode).
- Temporarily disable a Consumer (ex: excessive consumption).
- Block anonymous access with multiple auth plugins in a logical `OR` setup.
