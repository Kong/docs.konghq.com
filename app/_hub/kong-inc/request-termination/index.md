---
name: Request Termination
publisher: Kong Inc.
version: 2.1.0

desc: Terminates all requests with a specific response
description: |
  This plugin terminates incoming requests with a specified status code and
  message. This allows to (temporarily) stop traffic on a Service or a Route,
  or even block a Consumer.

type: plugin
categories:
  - traffic-control

kong_version_compatibility:
    community_edition:
      compatible:
        - 2.6.x
        - 2.5.x
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
    enterprise_edition:
      compatible:
        - 2.6.x
        - 2.5.x
        - 2.4.x
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 1.5.x
        - 1.3-x
        - 0.36-x

params:
  name: request-termination
  service_id: true
  route_id: true
  consumer_id: true
  protocols: ["http", "https"]
  dbless_compatible: yes
  config:
    - name: status_code
      required: false
      default: "`503`"
      value_in_examples: 403
      datatype: integer
      description: The response code to send. Must be an integer between 100 and 599.
    - name: message
      required: false
      value_in_examples: "So long and thanks for all the fish!"
      datatype: string
      description: The message to send, if using the default response generator.
    - name: body
      required: false
      datatype: string
      description: The raw response body to send. This is mutually exclusive with the `config.message` field.
    - name: content_type
      required: false
      default: "`application/json; charset=utf-8`"
      datatype: string
      description: Content type of the raw response configured with `config.body`.
    - name: trigger
      required: false
      default:
      description: When not set, the plugin always activates. When set to a string, the plugin will activate exclusively on requests containing either a header or a query parameter that is named the string.
    - name: echo
      required: false
      default: false
      description: When set, the plugin will echo a copy of the request back to the client. The main usecase for this is debugging. It can be combined with `trigger` in order to debug requests on live systems without disturbing real traffic.

  extra: |
    Once applied, every request (within the configured plugin scope of a Service,
    Route, Consumer, or global) will be immediately terminated by
    sending the configured response.

---

## New in 2.1.0

- `trigger` config option
- `echo` config option

## Example Use Cases

- Temporarily disable a Service (e.g. it is under maintenance).
- Temporarily disable a Route (e.g. the rest of the Service is up and running, but a particular endpoint must be disabled).
- Temporarily disable a Consumer (e.g. excessive consumption).
- Block anonymous access with multiple auth plugins in a logical `OR` setup.
- Debugging erroneous requests in live systems.
