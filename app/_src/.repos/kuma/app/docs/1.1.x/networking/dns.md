---
title: Kuma DNS
---

The Kuma control plane deploys its Domain Name Service resolver on UDP port `5653` (resembling the standard port `53`). Its purpose is to allow for decoupling the service name resolving from the underlying infrastructure and thus make Kuma more flexible. When Kuma is deployed as a distributed control plane, the Kuma DNS enables cross-cluster service discovery.

In version 1.1.3, Kuma offers an advanced method to resolve service and domain names, which simplifies the deployment
and operation of the DNS resolution. Check the [section](#data-plane-proxy-built-in-dns) at the end of this page to
learn more about it.

This DNS configuration is critical for multi-zone deployments as multi-zone requires .mesh addresses to be used to resolve services across the zones in a service mesh. Workloads that are connected as an ExternalService do not require this .mesh resolution. Take special note of your deployment topology as Universal mode and Kubernetes mode have difference configuration steps, both of which are covered within this page.

## Deployment

To enable the redirection of the DNS requests for the `.mesh` DNS zone (the default), within a Kubernetes, use `kumactl install dns | kubectl apply -f -`. This invocation of `kumactl` expects to find the environment variable `KUBECONFIG` set, so it can fetch the active Kubernetes DNS server configuration. Once this is done, `kumactl install dns` will output a patched resource ready to be applied through `kubectl apply`. Since this is a modification to system resources, it is strongly recommended that you first inspect the resulting configuration.

`kumactl install dns` is recognizing and supports the major flavors of CoreDNS as well as Kube DNS resources.

{% tip %}
In a **Kubernetes** environment, this command creates a configmap object that will update DNS to send .mesh requests to the correct DNS resolution. In **Universal** deployments, this functionality is enabled through a combination of the `kumactl install transparent-proxy` command as well as the `kuma-dp run` command this is covered more in the [section](#universal) section.
{% endtip %}

## Configuration

Kuma DNS can be configured by the configuration file, or by the respective environment variables as follows:

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

The `domain` field can change the default `.mesh` DNS zone that Kuma DNS will resolve for. If this is changed, please check the output of `kumactl install dns` and change the zone accordingly, so that your Kube DNS or Core DNS server will redirect all the relevant DNS requests.

The `port` can set the port on which the Kuma DNS is accepting requests. Changing this value on Kubernetes shall be reflected in the respective port setting in the `kuma-control-plane` service. 

The `CIDR` field sets the IP range of virtual IPs. The default `240.0.0.0/4` is reserved for future use IPv4 range and is guaranteed to be non-routable. We strongly recommend to not change this, unless it is needed.

## Operation 

The basic operation of Kuma DNS includes a couple of main components: DNS server, VIPs allocator, cross-replica persistence.

The DNS server listens on port `5653` and responds for type `A` and `AAAA` DNS requests and answers with `A` or `AAAAA` record, e.g. ```<service>.mesh. 60 IN A  240.0.0.100``` or ```<service>.mesh. 60 IN AAAAA  fd00:fd00::100```. The default TTL is set to 60 seconds, to ensure the client will synchronize with Kuma DNS and account for any changes happening meanwhile.

Kuma DNS allocates the virtual IPs from the configured CIDR, by constantly scanning the services available in all Kuma meshes. When a service is removed its VIP is freed too and Kuma DNS will not respond for it with `A` DNS record.

{% tip %}
Kuma DNS is not a service discovery mechanism, instead it returns a single VIP, mapped to the relevant service in the mesh. This makes for a unified view of all services within the zone or cross-zones.
{% endtip %}

## Usage

Consuming a service handled by Kuma DNS from inside a Kubernetes container is based on the automatically generated `kuma.io/service` tag. The resulting domain name has the format `{service tag}.mesh`, for example:
```bash
<kuma-enabled-pod>curl http://echo-server_echo-example_svc_1010.mesh:80
<kuma-enabled-pod>curl http://echo-server_echo-example_svc_1010.mesh
```

Alternatively, a DNS standards compliant name is available, where the underscores in the service name are replaced with dots.
The above example can be rewritten as follows:
```bash
<kuma-enabled-pod>curl http://echo-server.echo-example.svc.1010.mesh:80
<kuma-enabled-pod>curl http://echo-server.echo-example.svc.1010.mesh
```

Since the default VIP created listeners will default to port `80`, it can be omitted when using a standard HTTP client.
 
Kuma DNS allocates a VIP for every Service within a mesh. Then, it creates outbound virtual listener for every VIP. However, by inspecting `curl localhost:9901/config_dump`, we can see sections similar to this one:

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

## Data plane proxy built in DNS

In this mode, instead of using the control plane based DNS server, all the name lookups are handled locally by each data plane proxy.
This allows for more robust handling of name resolution.

### Kubernetes

Set the following environment variable when starting the control plane:
`KUMA_RUNTIME_KUBERNETES_INJECTOR_BUILTIN_DNS_ENABLED=true`.

{% tabs kubernetes %}
{% tab kubernetes kumactl %}

Supply the following argument to `kumactl`

```shell
kumactl install control-plane \
  --env-var KUMA_RUNTIME_KUBERNETES_INJECTOR_BUILTIN_DNS_ENABLED=true
```

{% endtab %}
{% tab kubernetes Helm %}

With [Helm](/docs/{{ page.version }}/installation/helm), the command invocation looks like:

```shell
helm install --version 0.5.7 --namespace kuma-system \
  --set controlPlane.envVars.KUMA_RUNTIME_KUBERNETES_INJECTOR_BUILTIN_DNS_ENABLED=true \
   kuma kuma/kuma
```

{% endtab %}
{% endtabs %}

### Universal

In Universal mode, the `kumactl install transparent-proxy` and `kuma-dp` processes enable DNS resolution to .mesh addresses.

Prerequisite: All three binaries -- `kuma-dp`, `envoy` and `coredns` -- must run in the worker node (i.e. the node that is running your service mesh workload).
`core-dns` must also be in the PATH so that `kuma-dp` can access it. Or you can specify the location
with the `--dns-coredns-path` flag. You should also create a user to run the `kuma-dp` process. On Ubuntu for example this can be done with the following command: `useradd -U kuma-dp`. You will need to run the `kuma-dp` process from a DIFFERENT user than the user you wish to test with in order for resolution to work correctly.

1.  Specify the two additional flags `--skip-resolv-conf` and `--redirect-dns` to the [transparent proxy](/docs/{{ page.version }}/networking/transparent-proxying/) iptables rules:

    ```shell
    kumactl install transparent-proxy \
              --kuma-dp-user kuma-dp \
              --kuma-cp-ip <kuma-cp IP> \
              --skip-resolv-conf \
              --redirect-dns
    ```

2.  Specify `--dns-enabled` when you start [the kuma-dp](/docs/{{ page.version }}/networking/dps-and-data-model/#dataplane-entity)

    ```shell
    kuma-dp run \
      --cp-address=https://127.0.0.1:5678 \
      --dataplane-file=dp.yaml \
      --dataplane-token-file=/tmp/kuma-dp-redis-1-token \
      --dns-enabled
    ```

When this command is run with `--dns-enabled`, the `kuma-dp` process will also spawn coredns and allow resolution of .mesh addresses.

### Special considerations

This mode implements advanced networking techniques, so take special care for the following cases:

 * The mode can safely be used with the [Kuma CNI plugin](/docs/{{ page.version }}/networking/cni/).
 * In mixed IPv4 and IPv6 environments, it's recommended that you specify an [IPv6 virtual IP CIDR](/docs/{{ page.version }}/networking/ipv6/).
