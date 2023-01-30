---
name: Request Termination
publisher: Kong Inc.
desc: Terminates all requests with a specific response
description: |
  This plugin terminates incoming requests with a specified status code and
  message. This can be used to (temporarily) stop traffic on a Service or a Route,
  or even block a Consumer.
type: plugin
categories:
  - traffic-control
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---

## Example Use Cases

- Temporarily disable a Service (e.g. it is under maintenance).
- Temporarily disable a Route (e.g. the rest of the Service is up and running, but a particular endpoint must be disabled).
- Temporarily disable a Consumer (e.g. excessive consumption).
- Block anonymous access with multiple auth plugins in a logical `OR` setup.
- Debugging erroneous requests in live systems.

---

