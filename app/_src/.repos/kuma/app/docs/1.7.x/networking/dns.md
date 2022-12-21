---
title: DNS
---

Kuma ships with DNS resolver to provide service naming - a mapping of hostname to Virtual IPs (VIPs) of services registered in Kuma.

The usage of Kuma DNS is only relevant when [transparent proxying](/docs/{{ page.version }}/networking/transparent-proxying) is used.

## How it works

Kuma DNS server responds to type `A` and `AAAA` DNS requests, and answers with `A` or `AAAAA` records, for example `redis.mesh. 60 IN A 240.0.0.100` or `redis.mesh. 60 IN AAAAA fd00:fd00::100`.

The virtual IPs are allocated by the control plane from the configured CIDR (by default `240.0.0.0/4`) , by constantly scanning the services available in all Kuma meshes.
When a service is removed, its VIP is also freed, and Kuma DNS does not respond for it with `A` and `AAAA` DNS record.
Virtual IPs are stable (replicated) between instances of the control plane and data plane proxies.

Once a new VIP is allocated or an old VIP is freed, the control plane configures the data plane proxy with this change.

All name lookups are handled locally by the data plane proxy, not by the control plane.
This approach allows for more robust handling of name resolution.
For example, when the control plane is down, a data plane proxy can still resolve DNS.

The data plane proxy DNS consists of:

- an Envoy DNS filter provides responses from the mesh for DNS records
- a CoreDNS instance launched by `kuma-dp` that sends requests between the Envoy DNS filter and the original host DNS
- iptable rules that will redirect the original DNS traffic to the local CoreDNS instance

As the DNS requests are sent to the Envoy DNS filter first, any DNS name that exists inside the mesh will always resolve to the mesh address.
This in practice means that DNS name present in the mesh will "shadow" equivalent names that exist outside the mesh.

Kuma DNS is not a service discovery mechanism, it does not return real IP address of service instances.
Instead, it always returns a single VIP that is assigned to the relevant service in the mesh. This makes for a unified view of all services within a single zone or across multiple zones.

The default TTL is 60 seconds, to ensure the client synchronizes with Kuma DNS and to account for any intervening changes.

## Installation

{% tabs installation useUrlFragment=false %}
{% tab installation Kubernetes %}

Kuma DNS is enabled by default whenever kuma-dp sidecar proxy is injected.

{% endtab %}
{% tab installation Universal %}

Follow the instruction in [transparent proxying](/docs/{{ page.version }}/networking/transparent-proxying).

{% endtab %}
{% endtabs %}

### Special considerations

This mode implements advanced networking techniques, so take special care for the following cases:

- The mode can safely be used with the [Kuma CNI plugin](/docs/{{ page.version }}/networking/cni).
- In mixed IPv4 and IPv6 environments, it's recommended that you specify an [IPv6 virtual IP CIDR](/docs/{{ page.version }}/networking/ipv6).

### Overriding the CoreDNS configuration

In some cases it might be useful for you to configure the default CoreDNS.

{% tabs override useUrlFragment=false %}
{% tab override Kubernetes %}
At this moment, there is no builtin option to override CoreDNS configuration.
{% endtab %}
{% tab override Universal %}
Use `--dns-coredns-config-template-path` as an argument to `kuma-dp`.
{% endtab %}
{% endtabs %}

This file is a [CoreDNS configuration](https://coredns.io/manual/toc/) that is processed as a go-template.
If you edit this configuration you should base yourself on the default existing configuration, which looks like the following

{% raw %}

```
.:{{ .CoreDNSPort }} {
    forward . 127.0.0.1:{{ .EnvoyDNSPort }}
    # We want all requests to be sent to the Envoy DNS Filter, unsuccessful responses should be forwarded to the original DNS server.
    # For example: requests other than A, AAAA and SRV will return NOTIMP when hitting the envoy filter and should be sent to the original DNS server.
    # Codes from: https://github.com/miekg/dns/blob/master/msg.go#L138
    alternate NOTIMP,FORMERR,NXDOMAIN,SERVFAIL,REFUSED . /etc/resolv.conf
    prometheus localhost:{{ .PrometheusPort }}
    errors
}

.:{{ .CoreDNSEmptyPort }} {
    template ANY ANY . {
      rcode NXDOMAIN
    }
}
```

{% endraw %}

## Configuration

You can configure Kuma DNS in `kuma-cp`:

```yaml
dnsServer:
  CIDR: "240.0.0.0/4" # ENV: KUMA_DNS_SERVER_CIDR
  domain: "mesh" # ENV: KUMA_DNS_SERVER_DOMAIN
  serviceVipEnabled: true # ENV: KUMA_DNS_SERVER_SERVICE_VIP_ENABLED
```

The `CIDR` field sets the IP range of virtual IPs. The default `240.0.0.0/4` is reserved for future IPv4 use and is guaranteed to be non-routable. We strongly recommend to not change this value unless you have a specific need for a different IP range.

The `domain` field specifies the default `.mesh` DNS zone that Kuma DNS provides resolution for. It's only relevant when `serviceVipEnabled` is set to `true`.

The `serviceVipEnabled` field defines if there should be a vip generated for each `kuma.io/service`. This can be disabled for performance reason and [virtual-outbound](/docs/{{ page.version }}/policies/virtual-outbound) provides a more flexible way to do this.

## Usage

Consuming a service handled by Kuma DNS, whether from Kuma-enabled Pod on Kubernetes or VM with `kuma-dp`, is based on the automatically generated `kuma.io/service` tag. The resulting domain name has the format `{service tag}.mesh`. For example:

```
<kuma-enabled-pod>$ curl http://echo-server_echo-example_svc_1010.mesh:80
<kuma-enabled-pod>$ curl http://echo-server_echo-example_svc_1010.mesh
```

A DNS standards compliant name is also available, where the underscores in the service name are replaced with dots. For example:

```
<kuma-enabled-pod>$ curl http://echo-server.echo-example.svc.1010.mesh:80
<kuma-enabled-pod>$ curl http://echo-server.echo-example.svc.1010.mesh
```

The default listeners created on the VIP default to port `80`, so the port can be omitted with a standard HTTP client.

Kuma DNS allocates a VIP for every service within a mesh. Then, it creates an outbound virtual listener for every VIP. If you inspect the result of `curl localhost:9901/config_dump`, you can see something similar to:

```json
    {
     "name": "outbound:240.0.0.1:80",
     "active_state": {
      "version_info": "51adf4e6-287e-491a-9ae2-e6eeaec4e982",
      "listener": {
       "@type": "type.googleapis.com/envoy.api.v2.Listener",
       "name": "outbound:240.0.0.1:80",
       "address": {
        "socket_address": {
         "address": "240.0.0.1",
         "port_value": 80
        }
       },
       "filter_chains": [
        {
         "filters": [
          {
           "name": "envoy.filters.network.tcp_proxy",
           "typed_config": {
            "@type": "type.googleapis.com/envoy.config.filter.network.tcp_proxy.v2.TcpProxy",
            "stat_prefix": "echo-server_kuma-test_svc_80",
            "cluster": "echo-server_kuma-test_svc_80"
           }
          }
         ]
        }
       ],
       "deprecated_v1": {
        "bind_to_port": false
       },
       "traffic_direction": "OUTBOUND"
      },
      "last_updated": "2020-07-06T14:32:59.732Z"
     }
    },
```

{% tip %}
The following setup will work when `serviceVipEnabled=true` which is a default value.

The preferred way to define hostnames is using [Virtual Outbounds](/docs/{{ page.version }}/policies/virtual-outbound).
Virtual Outbounds also makes it possible to define dynamic hostnames using specific tags or to expose services on a different port.
{% endtip %}
