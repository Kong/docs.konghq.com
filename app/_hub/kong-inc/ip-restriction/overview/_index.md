---
nav_title: Overview
---

Restrict access to a service or a route by either allowing or denying IP addresses. 
Single IPs, multiple IPs, or ranges in [CIDR notation](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_notation) 
like `10.10.10.0/24` can be used. 

The plugin supports IPv4 and IPv6 addresses.

## Usage

{% if_plugin_version lte:2.8.x %}

{:.note}
> **Note**: We have deprecated the usage of `whitelist` and `blacklist` in favor of `allow` and `deny`. This change may require Admin API requests to be updated.

{% endif_plugin_version %}

An `allow` list provides a positive security model, in which the configured CIDR ranges are allowed access to the resource, and all others are inherently rejected. By contrast, a `deny` list configuration provides a negative security model, in which certain CIDRS are explicitly denied access to the resource (and all others are inherently allowed).

You can configure the plugin with both `allow` and `deny` configurations. An interesting use case of this flexibility is to allow a CIDR range, but deny an IP address on that CIDR range:

```bash
curl -X POST http://kong:8001/services/{service}/plugins \
  --data "name=ip-restriction" \
  --data "config.allow=127.0.0.0/24" \
  --data "config.deny=127.0.0.1"
```

### IP Addresses

It is important to understand how the IP address is determined. The IP address is determined by the request header sent to Kong from downstream. In most cases, the header has a name of `X-Real-IP` or `X-Forwarded-For`.

By default, Kong uses the header name `X-Real-IP`. If a different header name is required, it needs to be defined using the [real_ip_header](/gateway/latest/reference/configuration/#real_ip_header) Nginx property. Depending on the environmental network setup, the [trusted_ips](/gateway/latest/reference/configuration/#trusted_ips) Nginx property may also need to be configured to include the load balancer IP address.

---
