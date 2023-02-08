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
