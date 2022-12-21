---
title: Transparent Proxying
---

In order to automatically intercept traffic from and to a service through a `kuma-dp` data plane proxy instance, Kuma utilizes a transparent proxying using [`iptables`](https://linux.die.net/man/8/iptables).

Transparent proxying helps with a smoother rollout of a Service Mesh to a current deployment by preserving existing service naming and as the result - avoid changes to the application code.

## Kubernetes

On **Kubernetes** `kuma-dp` leverages transparent proxying automatically via `iptables` installed with `kuma-init` container or CNI.
All incoming and outgoing traffic is automatically intercepted by `kuma-dp` without having to change the application code.

Kuma integrates with a service naming provided by Kubernetes DNS as well as providing its own [Kuma DNS](/docs/{{ page.version }}/networking/dns) for multizone service naming.

## Universal

On **Universal** `kuma-dp` leverages the [data plane proxy specification](/docs/{{ page.version }}/generated/resources/proxy_dataplane) associated to it for receiving incoming requests on a pre-defined port.

There are several advantages for using transparent proxying in universal mode:

 * Simpler [Dataplane resource](/docs/{{ page.version }}/generated/resources/proxy_dataplane), as the `outbound` section becomes obsolete and can be skipped.
 * Universal service naming with `.mesh` [DNS domain](/docs/{{ page.version }}/networking/dns) instead of explicit outbound like `https://localhost:10001`.
 * Support for hostnames of your choice using [VirtualOutbounds](/docs/{{ page.version }}/policies/virtual-outbound) that lets you preserve existing service naming.
 * Better service manageability (security, tracing).

### Setting up the service host

Prerequisites:

- `kuma-dp`, `envoy`, and `coredns` must run on the worker node -- that is, the node that runs your service mesh workload.
- `coredns` must be in the PATH so that `kuma-dp` can access it.
    - You can also set the location with the `--dns-coredns-path` flag to `kuma-dp`.

Kuma comes with [`kumactl` executable](/docs/{{ page.version }}/explore/cli) which can help us to prepare the host. Due to the wide variety of Linux setup options, these steps may vary and may need to be adjusted for the specifics of the particular deployment.
The host that will run the `kuma-dp` process in transparent proxying mode needs to be prepared with the following steps executed as `root`:

1. Create a new dedicated user on the machine.

   ```sh
   useradd -u 5678 -U kuma-dp
   ```

2. Redirect all the relevant inbound, outbound and DNS traffic to the Kuma data plane proxy.

   ```sh
   kumactl install transparent-proxy \
     --kuma-dp-user kuma-dp \
     --skip-resolv-conf \
     --redirect-dns
   ```
{% warning %}
Please note that this command **will change** the host `iptables` rules.
{% endwarning %}

The changes will persist over restarts, so this command is needed only once. Reverting to the original state of the host can be done by issuing `kumactl uninstall transparent-proxy`.

### Data plane proxy resource

In transparent proxying mode, the `Dataplane` resource should omit the `networking.outbound` section and use `networking.transparentProxying` section instead.

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
    redirectPortOutbound: 15001
```

The ports illustrated above are the default ones that `kumactl install transparent-proxy` will set. These can be changed using the relevant flags to that command.

### Invoking the Kuma data plane

{% warning %}
It is important that the `kuma-dp` process runs with the same system user that was passed to `kumactl install transparent-proxy --kuma-dp-user`.
{% endwarning %}

When systemd is used, this can be done with an entry `User=kuma-dp` in the `[Service]` section of the service file.

When starting `kuma-dp` with a script or some other automation instead, we can use `runuser` with the aforementioned yaml resource as follows:

```sh
runuser -u kuma-dp -- \
  /usr/bin/kuma-dp run \
    --cp-address=https://<IP or hostname of CP>:5678 \
    --dataplane-token-file=/kuma/token-demo \
    --dataplane-file=/kuma/dpyaml-demo \
    --dataplane-var name=dp-demo \
    --dataplane-var address=<IP of VM> \
    --dataplane-var port=<Port of the service>  \
    --binary-path /usr/local/bin/envoy
```

You can now reach the service on the same IP and port as before installing transparent proxy, but now the traffic goes through Envoy.
At the same time, you can now connect to services using [Kuma DNS](/docs/{{ page.version }}/networking/dns).

### firewalld support

If you run `firewalld` to manage firewalls and wrap iptables, add the `--store-firewalld` flag to `kumactl install transparent-proxy`. This persists the relevant rules across host restarts. The changes are stored in `/etc/firewalld/direct.xml`. There is no uninstall command for this feature.

### Upgrades

Before upgrading to the next version of Kuma, make sure to run `kumactl uninstall transparent-proxy` and only then replace the `kumactl` binary.
This will ensure smooth upgrade and no leftovers from the previous installations.

## Configuration

### Intercepted traffic

{% tabs intercepted-traffic useUrlFragment=false %}
{% tab intercepted-traffic Kubernetes %}

By default, all the traffic is intercepted by Envoy. You can exclude which ports are intercepted by Envoy with the following annotations placed on the Pod
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-app
  namespace: kuma-example
spec:
  ...
  template:
    metadata:
      ...
      annotations:
        # all incomming connections on ports 1234 won't be intercepted by Envoy
        traffic.kuma.io/exclude-inbound-ports: "1234"
        # all outgoing connections on ports 5678, 8900 won't be intercepted by Envoy
        traffic.kuma.io/exclude-outbound-ports: "5678,8900"
    spec:
      containers:
        ...
```  

You can also control this value on whole Kuma deployment with the following Kuma CP [configuration](/docs/{{ page.version }}/documentation/configuration)
```
KUMA_RUNTIME_KUBERNETES_SIDECAR_TRAFFIC_EXCLUDE_INBOUND_PORTS=1234
KUMA_RUNTIME_KUBERNETES_SIDECAR_TRAFFIC_EXCLUDE_OUTBOUND_PORTS=5678,8900
```

{% endtab %}
{% tab intercepted-traffic Universal %}
The default settings will exclude the SSH port `22` from the redirection, thus allowing the remote access to the host to be preserved.
If the host is set up to use other remote management mechanisms, use `--exclude-inbound-ports` to provide a comma separated list of the TCP ports that will be excluded from the redirection.

Execute `kumactl install transparent-proxy --help` to see available options.
{% endtab %}
{% endtabs %}

### Reachable Services

By default, every data plane proxy in the mesh follows every other data plane proxy.
This may lead to performance problems in larger deployments of the mesh.
It is highly recommended to define a list of services that your service connects to.

{% tabs reachable-services useUrlFragment=false %}
{% tab reachable-services Kubernetes %}
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-app
  namespace: kuma-example
spec:
  ...
  template:
    metadata:
      ...
      annotations:
        # a comma separated list of kuma.io/service values
        kuma.io/transparent-proxying-reachable-services: "redis_kuma-demo_svc_6379,elastic_kuma-demo_svc_9200"
    spec:
      containers:
        ...
```
{% endtab %}
{% tab reachable-services Universal %}
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
    redirectPortOutbound: 15001
    reachableServices:
      - redis_kuma-demo_svc_6379
      - elastic_kuma-demo_svc_9200 
```
{% endtab %}
{% endtabs %}
