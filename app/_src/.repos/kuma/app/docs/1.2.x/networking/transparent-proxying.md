---
title: Transparent Proxying
---

In order to interecept traffic from and to a service through a `kuma-dp` data plane proxy instance, Kuma utilizes a variety of patterns.

* On **Kubernetes** `kuma-dp` leverages transparent proxying automatically via `iptables` or CNI, for all incoming and outgoing traffic that is automatically intercepted by `kuma-dp` without having to change the application code.
* On **Universal** `kuma-dp` leverages the [data plane proxy specification](/docs/{{ page.version }}/documentation/dps-and-data-model/) associated to it for receiving incoming requests on a pre-defined port, while it can leverage both transparent proxying and explicit `outbound` entries in the same data plane proxy specification for all outgoing traffic.

There are several advantages for using transparent proxying in universal mode:

 * Simpler [Dataplane resource](/docs/{{ page.version }}/documentation/dps-and-data-model/#dataplane-specification), as the `outbound` section becomes obsolete and can be skipped.
 * Universal service naming with `.mesh` [DNS domain](/docs/{{ page.version }}/networking/dns/).
 * Better service manageability (security, tracing).

### Preparing the Kuma Control plane

The Kuma control plane exposes a DNS service which handles the name resolution in the `.mesh` DNS zone. By default it listens on port `UDP/5653`. For this setup we need it to listen on port `UDP/53`, therefore make sure that this environment variable is set before running `kuma-cp`: `KUMA_DNS_SERVER_PORT=53`.

{% tip %}
The IP address of the host that runs Kuma Control plane will be used in the next section. Make sure to have it once, `kuma-cp` is started.
{% endtip %}

### Setting up the service host

The host that will run the `kuma-dp` process in transparent proxying mode needs to be prepared with the following steps:

 1. Create a new dedicated user on the machine.
 2. Redirect all the relevant inbound and outbound traffic to the Kuma data plane proxy.
 3. Point the DNS resolving for `.mesh` to the `kuma-cp` embedded DNS server.

Kuma comes with [`kumactl` executable](/docs/{{ page.version }}/documentation/cli/#kumactl) which can help us preparing the host. Due to the wide variety of Linux setup options, these steps may vary and may need to be adjusted for the specifics of the particular deployment. However, the common steps would be to execute the following commands as `root`:

```sh
# create a dedicated user called kuma-dp-user
useradd -u 5678 -U kuma-dp

# use kumactl
kumactl install transparent-proxy \
          --kuma-dp-user kuma-dp \
          --kuma-cp-ip <kuma-cp IP>
```

Where `kuma-dp-user` is the name of the dedicated user that will be used to run the `kuma-dp` process and `<kuma-cp IP>` is the IP address of the Kuma control plane (`kuma-cp`). 

{% warning %}
Please note that this command **will change** both the host `iptables` rules as well as modify `/etc/resolv.conf`, while keeping a backup copy of the original file.
{% endwarning %}

The command has several other options which allow to change the default inbound and outbound redirect ports, add ports for exclusion and also disable the iptables or `resolve.conf` modification steps. The command's help has enumerated and documented the available options.

{% tip %}
The default settings will exclude the SSH port `22` from the redirection, thus allowing the remote access to the host to be preserved. If the host is set up to use other remote management mechanisms, use `--exclude-inbound-ports` to provide a comma separated list of the TCP ports that will be excluded from the redirection.
{% endtip %}

The changes will persist over restarts, so this command is needed only once. Reverting back to the original state of the host can be done by issuing `kumactl uninstall transparent-proxy`.

### `firewalld` support

If you run `firewalld` to manage firewalls and wrap iptables, add the `--store-firewalld` flag to `kumactl install transparent-proxy`. This persists the relevant rules across host restarts. The changes are stored in `/etc/firewalld/direct.xml`. There is no uninstall command for this feature.

### Upgrades

Before upgrading to the next version of Kuma, make sure to run `kumactl uninstall transparent-proxy` and only then replace the `kumactl` binary.
This will ensure smooth upgrade and no leftovers from the previous installations.

### Data plane proxy resource

In transparent proxying mode, the `Dataplane` resource that will be should ommit the `networking.outbound` section and use `networking.transparentProxying`section instead.

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

It is important that the `kuma-dp` process runs with the same system user that was passed to `kumactl install transparent-proxy --kuma-dp-user`.

When systemd is used, this can be done with an entry `User=kuma-dp` in the `[Service]` section of the service file.

When starting `kuma-dp` with a script or some other automation instead, we can use `runuser` with the aforementioned yaml resource as follows:

```sh
runuser -u kuma-dp -- \
  /usr/bin/kuma-dp run \
    --cp-address=https://172.19.0.2:5678 \
    --dataplane-token-file=/kuma/token-demo \
    --dataplane-file=/kuma/dpyaml-demo \
    --dataplane-var name=dp-demo \
    --dataplane-var address=172.19.0.4 \
    --dataplane-var port=80  \
    --binary-path /usr/local/bin/envoy
```

## Transparent Proxying

There are two ways of how the service can interact with its sidecar to connect to other services.

One is explicitly defining outbounds in the Dataplane:

```yaml
type: Dataplane
...
networking:
  ...
  outbound:
  - port: 10000
    tags:
      kuma.io/service: backend
```

This approach is simple, but it has the disadvantage that you need to reconfigure the service to use `http://localhost:10000` when it wants to connect with service `backend`.
This strategy is used on Universal deployments.

The alternative approach is Transparent Proxying. With Transparent Proxying before we start a service, we apply [`iptables`](https://linux.die.net/man/8/iptables) that intercept all the traffic on VM/Pod and redirect it to Envoy.
The main advantage of this mode is when you integrate with the current hostname resolving mechanism, you can deploy Service Mesh _transparently_ on the platform without reconfiguring applications.

Kuma provides support for transparent proxying on both Universal and Kubernetes.

### Configure intercepted traffic

{% tabs configure-intercepted-traffic useUrlFragment=false %}
{% tab configure-intercepted-traffic Kubernetes %}
Kuma deploys `iptables` rules either with `kuma-init` Init Container or with `cni` when deployed with CNI mode.

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

You can also control this value on whole Kuma deployment with the following Kuma CP configuration
```sh
KUMA_RUNTIME_KUBERNETES_SIDECAR_TRAFFIC_EXCLUDE_INBOUND_PORTS=1234
KUMA_RUNTIME_KUBERNETES_SIDECAR_TRAFFIC_EXCLUDE_OUTBOUND_PORTS=5678,8900
``` 

Global settings can be always overridden with annotations on the individual Pods. 

{% tip %}
When deploying Kuma with `kumactl install control-plane` you can set those settings with
```sh
kumactl install control-plane \
  --env-var KUMA_RUNTIME_KUBERNETES_SIDECAR_TRAFFIC_EXCLUDE_INBOUND_PORTS=1234
  --env-var KUMA_RUNTIME_KUBERNETES_SIDECAR_TRAFFIC_EXCLUDE_OUTBOUND_PORTS=5678,8900
```

When deploying Kuma with HELM, use `controlPlane.envVar` value
```yaml
envVar:
  KUMA_RUNTIME_KUBERNETES_SIDECAR_TRAFFIC_EXCLUDE_INBOUND_PORTS: "1234"
  KUMA_RUNTIME_KUBERNETES_SIDECAR_TRAFFIC_EXCLUDE_OUTBOUND_PORTS=5678,8900
```
{% endtip %}
{% endtab %}
{% endtabs %}

