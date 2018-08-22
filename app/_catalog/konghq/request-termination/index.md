---
name: Request Termination
nav:
  - label: Usage
    items:
      - label: Example Use Cases

desc: Terminates all requests with a specific response
description: |
  This plugin terminates incoming requests with a specified status code and
  message. This allows to (temporarily) stop traffic on a Service or a Route
  (or the deprecated API entity), or even block a Consumer.

type: plugin
categories:
  - traffic-control

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
    Once applied, every request (within the configured plugin scope of a Service,
    Route, Consumer, API, or global) will be immediately terminated by
    sending the configured response.

---

## Example Use Cases

- Temporarily disable a Service (e.g. it is under maintenance).
- Temporarily disable a Route (e.g. the rest of the Service is up and running, but a particular endpoint must be disabled).
- Temporarily disable a Consumer (e.g. excessive consumption).
- Block anonymous access with multiple auth plugins in a logical `OR` setup.
