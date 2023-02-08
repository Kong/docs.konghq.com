---
name: IP Restriction
publisher: Kong Inc.
desc: Allow or deny IPs that can make requests to your Services
description: |
  Restrict access to a Service or a Route by either allowing or denying IP addresses. Single IPs, multiple IPs, or ranges in [CIDR notation](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_notation) like `10.10.10.0/24` can be used. The plugin supports IPv4 and IPv6 addresses.

type: plugin
categories:
  - security
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---
