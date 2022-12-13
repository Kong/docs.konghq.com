---
title: IPv6 support
---

All Kuma entitites do support running in mixed IPv4 and IPv6 environments as well as pure IPv6 setup. This includes
Global and Remote control planes, the Data plane proxy, the accompanying iptables scripts and the CNI. All major deployment
scenarios are continuously verified - standalone Kubernetes and Universal, multizone and hybrid.

For the most part any IPv6 setup will work out of the box, but there are some specifics that need to be taken into account:
 
 * when the dataplane proxies are run in IPv6 only environment (i.e. no IPv4 address), the DNS shall be set to generate relevant
   IPv6 addresses using `KUMA_DNS_SERVER_CIDR`. Please make sure there is no overlap with a pre-existing network in your environment.

 * On Universal, when the dataplane resource is generated, specify `networking.transparentProxying.redirectPortInboundV6`.
   The default value for that port is `15010`.

```yaml
type: Dataplane
mesh: default
name: {{ name }}
networking:
  address: {{ address }}
  inbound:
  - port: {{ port }}
    tags:
      kuma.io/service: demo-client
  transparentProxying:
    redirectPortInbound: 15006
    redirectPortInboundV6: 15010
    redirectPortOutbound: 15001 
```
