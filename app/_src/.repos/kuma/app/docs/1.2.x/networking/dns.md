---
title: DNS
---

As of Kuma version 1.2.0, DNS on the data plane proxy is enabled by default on Kubernetes. You can also continue to deploy with [DNS on the control plane](#control-plane-dns).

## Data plane proxy DNS

In this mode, all name lookups are handled locally by the data plane proxy. This approach allows for more robust handling of name resolution.

On Kubernetes, this is the default. You must enable it manually on universal deployments.

### Universal

In Universal mode, the `kumactl install transparent-proxy` and `kuma-dp` processes enable DNS resolution to .mesh addresses.

Prerequisites:

- `kuma-dp`, `envoy`, and `coredns` must run on the worker node -- that is, the node that runs your service mesh workload.
- `core-dns` must be in the PATH so that `kuma-dp` can access it. 
  - You can also set the location with the `--dns-coredns-path` flag. 
- User created to run the `kuma-dp` process. You must run the `kuma-dp` process with a different user than the user you test with. Otherwise, name resolution might not work.
  - On Ubuntu, for example, you can run: `useradd -U kuma-dp`.

1.  Specify the flags `--skip-resolv-conf` and `--redirect-dns` in the [transparent proxy](/docs/{{ page.version }}/networking/transparent-proxying/) iptables rules:

    ```shell
    kumactl install transparent-proxy \
              --kuma-dp-user kuma-dp \
              --kuma-cp-ip <kuma-cp IP> \
              --skip-resolv-conf \
              --redirect-dns
    ```

1.  Start [the kuma-dp](/docs/{{ page.version }}/networking/dps-and-data-model/#dataplane-entity)

    ```shell
    kuma-dp run \
      --cp-address=https://127.0.0.1:5678 \
      --dataplane-file=dp.yaml \
      --dataplane-token-file=/tmp/kuma-dp-redis-1-token
    ```

    The `kuma-dp` process also starts CoreDNS and allows resolution of .mesh addresses.

### Special considerations

This mode implements advanced networking techniques, so take special care for the following cases:

 * The mode can safely be used with the [Kuma CNI plugin](/docs/{{ page.version }}/networking/cni/).
 * In mixed IPv4 and IPv6 environments, it's recommended that you specify an [IPv6 virtual IP CIDR](/docs/{{ page.version }}/networking/ipv6/).

## Control Plane DNS

The Kuma control plane deploys its DNS resolver on UDP port `5653`. It allows decoupling the service name resolution from the underlying infrastructure and thus makes Kuma more flexible. When Kuma is deployed as a distributed control plane, Kuma DNS enables cross-cluster service discovery.

### Kubernetes

When you install the control plane, set the following environment variable to disable the data plane proxy DNS:

`KUMA_RUNTIME_KUBERNETES_INJECTOR_BUILTIN_DNS_ENABLED=false`

{% tabs dns-install %}
{% tab dns-install kumactl %}

Pass the environment variable to the `--env-var` argument when you install:

```shell
kumactl install control-plane \
  --env-var KUMA_RUNTIME_KUBERNETES_INJECTOR_BUILTIN_DNS_ENABLED=false
```

{% endtab %}
{% tab dns-install Helm %}

Set the environment variable:

```shell
helm install --version 0.6.3 --namespace kuma-system \
  --set controlPlane.envVars.KUMA_RUNTIME_KUBERNETES_INJECTOR_BUILTIN_DNS_ENABLED=false \
   kuma kuma/kuma
```

{% endtab %}
{% endtabs %}

### Universal

1.  Configure [the transparent proxy](/docs/{{ page.version }}/networking/transparent-proxying/) iptables rules:

    ```shell
    kumactl install transparent-proxy \
              --kuma-dp-user kuma-dp \
              --kuma-cp-ip <KUMA_CP_IP_ADDRESS>
    ```

1.  Start [the kuma-dp](/docs/{{ page.version }}/networking/dps-and-data-model/#dataplane-entity) with flag `--dns-enabled` set to `false`:

    ```shell
    kuma-dp run \
      --cp-address=https://127.0.0.1:5678 \
      --dataplane-file=dp.yaml \
      --dataplane-token-file=/tmp/<KUMA_DP_REDIS_1_TOKEN> \
      --dns-enabled=false
    ```

## Configuration

You can configure Kuma DNS with the config file, or with environment variables:

```yaml
# DNS Server configuration
dnsServer:
  # The domain that the server will resolve the services for
  domain: "mesh" # ENV: KUMA_DNS_SERVER_DOMAIN
  # Port on which the server is exposed
  port: 5653 # ENV: KUMA_DNS_SERVER_PORT
  # The CIDR range used to allocate
  CIDR: "240.0.0.0/4" # ENV: KUMA_DNS_SERVER_CIDR
```

The `domain` field specifies the default `.mesh` DNS zone that Kuma DNS provides resolution for. If you change this value, make sure to change the zone value for `kumactl install dns` to match. These values must be the same for kube-dns or CoreDNS server to redirect relevant DNS requests.

The `port` field specifies the port where Kuma DNS accepts requests. Make sure this value matches the port setting for the `kuma-control-plane` service. 

The `CIDR` field sets the IP range of virtual IPs. The default `240.0.0.0/4` is reserved for future IPv4 use IPv4 and is guaranteed to be non-routable. We strongly recommend to not change this value unless you have a specific need for a different IP range.

## How Kuma DNS works 

Kuma DNS includes these components: 

- The DNS server
- The VIPs allocator
- Cross-replica persistence

The DNS server listens on port `5653`, responds to type `A` and `AAAA` DNS requests, and answers with `A` or `AAAAA` records, for example ```<service>.mesh. 60 IN A  240.0.0.100``` or ```<service>.mesh. 60 IN AAAAA  fd00:fd00::100```. The default TTL is 60 seconds, to ensure the client synchronizes with Kuma DNS and to account for any intervening changes.

The virtual IPs are allocated from the configured CIDR, by constantly scanning the services available in all Kuma meshes. When a service is removed, its VIP is also freed, and Kuma DNS does not respond for it with `A` DNS record.

Kuma DNS is not a service discovery mechanism. Instead, it returns a single VIP that is assigned to the relevant service in the mesh. This makes for a unified view of all services within a single zone or across multiple zones.

## Usage

Consuming a service handled by Kuma DNS from inside a Kubernetes container is based on the automatically generated `kuma.io/service` tag. The resulting domain name has the format `{service tag}.mesh`. For example:

```bash
<kuma-enabled-pod>curl http://echo-server_echo-example_svc_1010.mesh:80
<kuma-enabled-pod>curl http://echo-server_echo-example_svc_1010.mesh
```

A DNS standards compliant name is also available, where the underscores in the service name are replaced with dots. For example:

```bash
<kuma-enabled-pod>curl http://echo-server.echo-example.svc.1010.mesh:80
<kuma-enabled-pod>curl http://echo-server.echo-example.svc.1010.mesh
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
