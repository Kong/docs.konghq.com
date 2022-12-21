---
title: Zone Egress
---

`ZoneEgress` proxy is used when it is required to isolate outgoing traffic (to services in other
zones or [external services](/docs/{{ page.version }}/policies/external-services) in the local zone).
and you want to achieve isolation of outgoing traffic (to services in other 
zones or [external services](/docs/{{ page.version }}/policies/external-services) in the local zone),
you can use `ZoneEgress` proxy.

This proxy is not attached to any particular workload. In multi-zone the proxy is bound to a specific zone.
Zone Egress can proxy the traffic between all meshes, so we need only one deployment for every zone.

When Zone Egress is present:
* In multi-zone, all requests that are sent from local data plane proxies to other
  zones will be directed through the local Zone Egress instance, which then will
  direct the traffic to the proper instance of the Zone Ingress.
* All requests that are sent from local data plane proxies to [external services](/docs/{{ page.version }}/policies/external-services)
  available within the Zone will be directed through the local Zone Egress
  instance.

{% tip %}
Currently `ZoneEgress` is a purely optional component.
In the future it will become compulsory for using external services.
{% endtip %}

The `ZoneEgress` entity includes a few sections:

* `type`: must be `ZoneEgress`.
* `name`: this is the name of the `ZoneEgress` instance, and it must be **unique**
   for any given `zone`.
* `networking`: contains networking parameters of the Zone Egress
    * `address`: the address of the network interface Zone Egress is listening on.
    * `port`: is a port that Zone Egress is listening on
    * `admin`: determines parameters related to Envoy Admin API
      * `port`: the port that Envoy Admin API will listen to
* `zone` **[auto-generated on Kuma CP]** : zone where Zone Egress belongs to

{% tabs zone-egress useUrlFragment=false %}
{% tab zone-egress Kubernetes %}
The recommended way to deploy a `ZoneEgress` proxy in Kubernetes is to use
`kumactl`, or the Helm charts as specified in [multi-zone](/docs/{{ page.version }}/deployments/multi-zone).
It works as a separate deployment of a single-container pod.

**Standalone**:

```shell
kumactl install control-plane \
  --egress-enabled \
  [...] | kubectl apply -f -
```

**Multi-zone**:

```shell
kumactl install control-plane \
  --mode=zone \
  --zone=<my-zone> \
  --kds-global-address grpcs://`<global-kds-address>` \
  --egress-enabled \
  [...] | kubectl apply -f -
```

{% endtab %}
{% tab zone-egress Universal %}

**Standalone**

In Universal mode, the token is required to authenticate `ZoneEgress` instance. Create the token by using `kumactl` binary:

```bash
kumactl generate zone-token --valid-for 24h --scope egress > /path/to/token
```

Create a `ZoneEgress` data plane proxy configuration to allow `kuma-cp` services to be configured to proxy traffic to other zones or external services through zone egress:

```yaml
type: ZoneEgress
name: zoneegress-1
networking:
  address: 192.168.0.1
  port: 10002
```

Apply the egress configuration, passing the IP address of the control plane and your instance should start.

```bash
kuma-dp run \
--proxy-type=egress \
--cp-address=https://<kuma-cp-address>:5678 \
--dataplane-token-file=/path/to/token \
--dataplane-file=/path/to/config
```

**Multi-zone**

Multi-zone deployment is similar and for deployment, you should follow [multi-zone deployment instruction](/docs/{{ page.version }}/deployments/multi-zone).

{% endtab %}
{% endtabs %}

A `ZoneEgress` deployment can be scaled horizontally.

## Configuration

[mTLS](/docs/{{ page.version }}/policies/mutual-tls) is required to enable `ZoneEgress`. In addition, there's a configuration in the `Mesh` policy to route traffic through the `ZoneEgress`

{% tabs configuration useUrlFragment=false %}
{% tab configuration Kubernetes %}

```shell
echo "apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  routing:
    zoneEgress: true
  mtls: # mTLS is required to use ZoneEgress
    [...]" | kubectl apply -f -
```

{% endtab %}
{% tab configuration Universal %}

```shell
cat <<EOF | kumactl apply -f -
type: Mesh
name: default
mtls: # mTLS is required to use ZoneEgress
  [...]
routing:
  zoneEgress: true
EOF
```

{% endtab %}
{% endtabs %}

This configuration will force cross zone communication to go through `ZoneEgress`. If enabled but no `ZoneEgress` is available the communication will fail.
