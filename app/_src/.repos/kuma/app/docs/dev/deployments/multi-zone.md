---
title: Multi-zone deployment
---

## About

{{site.mesh_product_name}} supports running your service mesh in multiple zones. It is even possible to run with a mix of Kubernetes and Universal zones. Your mesh environment can include multiple isolated service meshes (multi-tenancy), and workloads running in different regions, on different clouds, or in different datacenters. A zone can be a Kubernetes cluster, a VPC, or any other deployment you need to include in the same distributed mesh environment.
The only condition is that all the data planes running within the zone must be able to connect to the other data planes in this same zone.

<center>
<img src="/assets/images/diagrams/gslides/kuma_multizone.svg" alt="Kuma service mesh multi zone deployment without zone egress" style="padding-top: 20px; padding-bottom: 10px;"/>
</center>
Or without the optional zone egress:
<center>
<img src="/assets/images/diagrams/gslides/kuma_multizone_without_egress.svg" alt="Kuma service mesh multi zone deployment with zone egress" style="padding-top: 20px; padding-bottom: 10px;"/>
</center>

### How it works

In {{site.mesh_product_name}}, zones are abstracted away, meaning that your data plane proxies will find services anywhere they run.
Therefore, you can make a service multi-zone by having data planes using the same `kuma.io/service` run in different zones, this can help you achieve automatic fail-over of services when a specific zone fails.

We will now explain how this works in details:

In the local zone: the zone ingress will receive all traffic coming from other zones and route it within this zone. The control-plane will update its local zone ingresses with a list of local services and the number of instances available, it will then synchronize it with the global control-plane.

The global control-plane will propagate the zone ingress resources and all policies to all other zones over {{site.mesh_product_name}} Discovery Service (KDS), which is a protocol based on xDS.

In the remote zone, data plane proxies will either add new services or add endpoints to existing services which correspond to the remote zone-ingresses entries.
Requests are then routed to either local instances of the service or to the remote zone ingress where instances of the service are running, which will proxy the request to the actual instance.

In the presence of a [zone egress](/docs/{{ page.version }}/explore/zoneegress) the traffic is routed through the local zone egress before being sent to the remote zone ingress.

When using [transparent-proxy](/docs/{{ page.version }}/networking/transparent-proxying) (enabled by default in Kubernetes), {{site.mesh_product_name}} generates a VIP, a DNS entry with the format
`<kuma.io/service>.mesh`, and will listen for traffic on port 80.

{% tip %}
A zone ingress is not an API gateway. It is only used for cross-zone communication within a mesh. API gateways are supported in {{site.mesh_product_name}} [gateway mode](/docs/{{ page.version }}/explore/gateway) and can be deployed in addition to zone ingresses.

For Kubernetes the `kuma.io/service` is automatically generated as explained in the [data-plane on Kubernetes documentation](/docs/{{ page.version }}/explore/dpp-on-kubernetes).

For load-balancing the zone ingress endpoints are weighted with the number of instances running behind them (.i.e: a zone with 2 instances will receive twice more traffic than a zone with 1 instance), you can also favor local traffic with [localityAware load-balancing](/docs/{{ page.version }}/policies/locality-aware).

The `<kuma.io/service>.mesh:80>` is a convention. [Virtual Outbound](/docs/{{ page.version }}/policies/virtual-outbound)s will enable you to expose hostname/port differently.
{% endtip %}

### Components of a multi-zone deployment

A multi-zone deployment includes:

- The **global control plane**:
  - Accept connections only from zone control planes.
  - Accept creation and changes to [policies](/policies) that will be applied to the data plane proxies.
  - Send policies down to zone control planes.
  - Send zone ingresses down to zone control plane.
  - Keep an inventory of all data plane proxies running in all zones (this is only done for observability but is not required for operations).
  - Reject connections from data plane proxies.
- The **zone control planes**:
  - Accept connections from data plane proxies started within this zone.
  - Receive policy updates from the global control plane.
  - Send data plane proxies and zone ingress changes to the global control plane.
  - Compute and send configurations using XDS to the local data plane proxies.
  - Update list of services which exist in the zone in the zone ingress.
  - Reject policy changes that do not come from global.
- The **data plane proxies**:
  - Connect to the local zone control plane.
  - Receive configurations using XDS from the local zone control plane.
  - Connect to other local data plane proxies.
  - Connect to zone ingresses for sending cross zone traffic.
  - Receive traffic from local data plane proxies and local zone ingresses.
- The **zone ingress**:
  - Receive XDS configuration from the local zone control plane.
  - Proxy traffic from other zone data plane proxies to local data plane proxies.
- (optional) The **zone egress**:
  - Receive XDS configuration from the local zone control plane.
  - Proxy traffic from local data plane proxies:
    - to zone ingress proxies from other zones;
    - to external services from local zone;

## Usage

To set up a multi-zone deployment we will need to:

- [Set up the global control plane](#set-up-the-global-control-plane)
- [Set up the zone control planes](#set-up-the-zone-control-planes)
- [Verify control plane connectivity](#verify-control-plane-connectivity)
- [Ensure mTLS is enabled for the multi-zone meshes](#ensure-mtls-is-enabled-on-the-multi-zone-meshes)

### Set up the global control plane

The global control plane must run on a dedicated cluster, and cannot be assigned to a zone.

{% tabs global-control-plane useUrlFragment=false %}
{% tab global-control-plane Kubernetes %}

The global control plane on Kubernetes must reside on its own Kubernetes cluster, to keep its resources separate from the resources the zone control planes create during synchronization.

1.  Run:

    ```sh
    kumactl install control-plane --mode=global | kubectl apply -f -
    ```

1.  Find the external IP and port of the `global-remote-sync` service in the `{{site.default_namespace}}` namespace:

    ```sh
    kubectl get services -n {{site.default_namespace}}
    NAMESPACE     NAME                   TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)                                                                  AGE
    {{site.default_namespace}}   global-remote-sync     LoadBalancer   10.105.9.10     35.226.196.103   5685:30685/TCP                                                           89s
    {{site.default_namespace}}   kuma-control-plane     ClusterIP      10.105.12.133   <none>           5681/TCP,443/TCP,5676/TCP,5677/TCP,5678/TCP,5679/TCP,5682/TCP,5653/UDP   90s
    ```

    In this example the value is `35.226.196.103:5685`. You pass this as the value of `<global-kds-address>` when you set up the zone control planes.

{% endtab %}
{% tab global-control-plane Helm %}

1.  Set the `controlPlane.mode` value to `global` in the chart (`values.yaml`), then install. On the command line, run:

    ```sh
    helm install kuma --create-namespace --namespace {{site.default_namespace}} --set controlPlane.mode=global kuma/kuma
    ```

    Or you can edit the chart and pass the file to the `helm install kuma` command. To get the default values, run:

    ```sh
    helm show values kuma/kuma
    ```

1.  Find the external IP and port of the `global-remote-sync` service in the `{{site.default_namespace}}` namespace:

    ```sh
    kubectl get services -n {{site.default_namespace}}
    NAMESPACE     NAME                   TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)                                                                  AGE
    {{site.default_namespace}}   global-remote-sync     LoadBalancer   10.105.9.10     35.226.196.103   5685:30685/TCP                                                           89s
    {{site.default_namespace}}   kuma-control-plane     ClusterIP      10.105.12.133   <none>           5681/TCP,443/TCP,5676/TCP,5677/TCP,5678/TCP,5679/TCP,5682/TCP,5653/UDP   90s
    ```

    By default, it's exposed on [port 5685](/docs/{{ page.version }}/networking/networking). In this example the value is `35.226.196.103:5685`. You pass this as the value of `<global-kds-address>` when you set up the zone control planes.

{% endtab %}
{% tab global-control-plane Universal %}

1.  Set up the global control plane, and add the `global` environment variable:

    ```sh
    KUMA_MODE=global kuma-cp run
    ```

{% endtab %}
{% endtabs %}

### Set up the zone control planes

You need the following values to pass to each zone control plane setup:

- `zone` -- the zone name. An arbitrary string. This value registers the zone control plane with the global control plane.
- `kds-global-address` -- the external IP and port of the global control plane.

{% tabs zone-control-planes useUrlFragment=false %}
{% tab zone-control-planes Kubernetes %}

**Without zone egress**:

1.  On each zone control plane, run:

    ```sh
    kumactl install control-plane \
    --mode=zone \
    --zone=<zone name> \
    --ingress-enabled \
    --kds-global-address grpcs://<global-kds-address>:5685 | kubectl apply -f -
    ```

    where `zone` is the same value for all zone control planes in the same zone.

**With zone egress**:

1.  On each zone control plane, run:

    ```sh
    kumactl install control-plane \
    --mode=zone \
    --zone=<zone-name> \
    --ingress-enabled \
    --egress-enabled \
    --kds-global-address grpcs://<global-kds-address>:5685 | kubectl apply -f -
    ```

    where `zone` is the same value for all zone control planes in the same zone.

{% endtab %}
{% tab zone-control-planes Helm %}

**Without zone egress**:

1.  On each zone control plane, run:

    ```sh
    helm install kuma \
    --create-namespace \
    --namespace {{site.default_namespace}} \
    --set controlPlane.mode=zone \
    --set controlPlane.zone=<zone-name> \
    --set ingress.enabled=true \
    --set controlPlane.kdsGlobalAddress=grpcs://<global-kds-address>:5685 kuma/kuma
    ```

    where `controlPlane.zone` is the same value for all zone control planes in the same zone.

**With zone egress**:

1.  On each zone control plane, run:

    ```sh
    helm install kuma \
    --create-namespace \
    --namespace {{site.default_namespace}} \
    --set controlPlane.mode=zone \
    --set controlPlane.zone=<zone-name> \
    --set ingress.enabled=true \
    --set egress.enabled=true \
    --set controlPlane.kdsGlobalAddress=grpcs://<global-kds-address>:5685 kuma/kuma
    ```

    where `controlPlane.zone` is the same value for all zone control planes in the same zone.

{% endtab %}
{% tab zone-control-planes Universal %}

1. On each zone control plane, run:

   ```sh
   KUMA_MODE=zone \
   KUMA_MULTIZONE_ZONE_NAME=<zone-name> \
   KUMA_MULTIZONE_ZONE_GLOBAL_ADDRESS=grpcs://<global-kds-address>:5685 \
   ./kuma-cp run
   ```

   where `KUMA_MULTIZONE_ZONE_NAME` is the same value for all zone control planes in the same zone.

2. Generate the zone proxy token:

   To register the zone ingress and zone egress with the zone control plane, we need to generate a token first

   ```sh
   kumactl generate zone-token --zone=<zone-name> --scope egress --scope ingress > /tmp/zone-token
   ```

   You can also generate the token [with the REST API](/docs/{{ page.version }}/security/zoneproxy-auth).
   Alternatively, you could generate separate tokens for ingress and egress.

3. Create an `ingress` data plane proxy configuration to allow `kuma-cp` services to be exposed for cross-zone communication:

   ```sh
   echo "type: ZoneIngress
   name: ingress-01
   networking:
     address: 127.0.0.1 # address that is routable within the zone
     port: 10000
     advertisedAddress: 10.0.0.1 # an address which other zones can use to consume this zone-ingress
     advertisedPort: 10000 # a port which other zones can use to consume this zone-ingress" > ingress-dp.yaml
   ```

4. Apply the ingress config, passing the IP address of the zone control plane to `cp-address`:

   ```sh
   kuma-dp run \
   --proxy-type=ingress \
   --cp-address=https://<kuma-cp-address>:5678 \
   --dataplane-token-file=/tmp/zone-token \
   --dataplane-file=ingress-dp.yaml
   ```

   If zone-ingress is running on a different machine than zone-cp you need to
   copy CA cert file from zone-cp (located in `~/.kuma/kuma-cp.crt`) to somewhere accessible by zone-ingress (e.g. `/tmp/kuma-cp.crt`).
   Modify the above command and provide the certificate path in `--ca-cert-file` argument.

   ```sh
   kuma-dp run \
   --proxy-type=ingress \
   --cp-address=https://<kuma-cp-address>:5678 \
   --dataplane-token-file=/tmp/zone-token \
   --ca-cert-file=/tmp/kuma-cp.crt \
   --dataplane-file=ingress-dp.yaml
   ```

5.  Optional: if you want to deploy zone egress

    Create a `ZoneEgress` data plane proxy configuration to allow `kuma-cp` services
    to be configured to proxy traffic to other zones or external services through
    zone egress:

    ```sh
    echo "type: ZoneEgress
    name: zoneegress-01
    networking:
      address: 127.0.0.1 # address that is routable within the zone
      port: 10002" > zoneegress-dataplane.yaml
    ```

6. Apply the egress config, passing the IP address of the zone control plane to `cp-address`:

        ```sh
        kuma-dp run \
        --proxy-type=egress \
        --cp-address=https://<kuma-cp-address>:5678 \
        --dataplane-token-file=/tmp/zone-token \
        --dataplane-file=zoneegress-dataplane.yaml
        ```

    {% endtab %}
    {% endtabs %}

### Verify control plane connectivity

You can run `kumactl get zones`, or check the list of zones in the web UI for the global control plane, to verify zone control plane connections.

When a zone control plane connects to the global control plane, the `Zone` resource is created automatically in the global control plane.

The Zone Ingress tab of the web UI also lists zone control planes that you
deployed with zone ingress.

### Ensure mTLS is enabled on the multi-zone meshes

MTLS is mandatory to enable cross-zone service communication.
mTLS can be configured in your mesh configuration as indicated in the [mTLS section](/docs/{{ page.version }}/policies/mutual-tls).
This is required because {{site.mesh_product_name}} uses the [Server Name Indication](https://en.wikipedia.org/wiki/Server_Name_Indication) field, part of the TLS protocol, as a way to pass routing information cross zones.

### Cross-zone communication details

For this example we will assume we have a service running in a Kubernetes zone exposing a `kuma.io/service` with value `echo-server_echo-example_svc_1010`.
The following examples are running in the remote zone trying to access the previously mentioned service.

{% tabs cross-zone-communication-details useUrlFragment=false %}
{% tab cross-zone-communication-details Kubernetes %}

To view the list of service names available, run:

```sh
kubectl get serviceinsight all-services-default -oyaml
apiVersion: kuma.io/v1alpha1
kind: ServiceInsight
mesh: default
metadata:
  name: all-services-default
spec:
  services:
    echo-server_echo-example_svc_1010:
      dataplanes:
        online: 1
        total: 1
      issuedBackends:
        ca-1: 1
      status: online
```

The following are some examples of different ways to address `echo-server` in the
`echo-example` `Namespace` in a multi-zone mesh.

To send a request in the same zone, you can rely on Kubernetes DNS and use the usual Kubernetes hostnames and ports:

```sh
curl http://echo-server:1010
```

Requests are distributed round robin between zones.
You can use [locality-aware load balancing](/docs/{{ page.version }}/policies/locality-aware) to keep requests in the same zone.

To send a request to any zone, you can [use the generated `kuma.io/service`](/docs/{{ page.version }}/explore/dpp-on-kubernetes#tag-generation) and [{{site.mesh_product_name}} DNS](/docs/{{ page.version }}/networking/dns#dns):

```sh
curl http://echo-server_echo-example_svc_1010.mesh:80
```

{{site.mesh_product_name}} DNS also supports [RFC 1123](https://datatracker.ietf.org/doc/html/rfc1123) compatible names, where underscores are replaced with dots:

```sh
curl http://echo-server.echo-example.svc.1010.mesh:80
```

{% endtab %}
{% tab cross-zone-communication-details Universal %}

```sh
kumactl inspect services
SERVICE                                  STATUS               DATAPLANES
echo-service_echo-example_svc_1010       Online               1/1

```

To consume the service in a Universal deployment without transparent proxy add the following outbound to your [dataplane configuration](/docs/{{ page.version }}/explore/dpp-on-universal):

```yaml
outbound:
  - port: 20012
    tags:
      kuma.io/service: echo-server_echo-example_svc_1010
```

From the data plane running you will now be able to reach the service using `localhost:20012`.

Alternatively, if you configure [transparent proxy](/docs/{{ page.version }}/networking/transparent-proxying) you can just call `echo-server_echo-example_svc_1010.mesh` without defining an `outbound` section.

{% endtab %}
{% endtabs %}

{% tip %}
For security reasons it's not possible to customize the `kuma.io/service` in Kubernetes.

If you want to have the same service running on both Universal and Kubernetes make sure to align the Universal's data plane inbound to have the same `kuma.io/service` as the one in Kubernetes or leverage [TrafficRoute](/docs/{{ page.version }}/policies/traffic-route).
{% endtip %}

## Failure modes

### Global control plane offline

- Policy updates will be impossible
- Change in service list between zones will not propagate:
  - New services will not be discoverable in other zones.
  - Services removed from a zone will still appear available in other zones.
- You won't be able to disable or delete a zone.

{% tip %}
Note that both local and cross-zone application traffic is not impacted by this failure case.
Data plane proxy changes will be propagated within their zones.
{% endtip %}

### Zone control plane offline

- New data plane proxies won't be able to join the mesh.
- Data plane proxy configuration will not be updated.
- Communication between data plane proxies will still work.
- Cross zone communication will still work.
- Other zones are unaffected.

{% tip %}
You can think of this failure case as _"Freezing"_ the zone mesh configuration.
Communication will still work but changes will not be reflected on existing data plane proxies.
{% endtip %}

### Communication between Global and Zone control plane failing

This can happen with misconfiguration or network connectivity issues between control planes.

- Operations inside the zone will happen correctly (data plane proxies can join, leave and all configuration will be updated and sent correctly).
- Policy changes will not be propagated to the zone control plane.
- `ZoneIngress`, `ZoneEgress` and `Dataplane` changes will not be propagated to the global control plane:
  - The global inventory view of the data plane proxies will be outdated (this only impacts observability).
  - Other zones will not see new services registered inside this zone.
  - Other zones will not see services no longer running inside this zone.
  - Other zones will not see changes in number of instances of each service running in the local zone.
- Global control plane will not send changes from other zone ingress to the zone:
  - Local data plane proxies will not see new services registered in other zones.
  - Local data plane proxies will not see services no longer running in other zones.
  - Local data plane proxies will not see changes in number of instances of each service running in other zones.
- Global control plane will not send changes from other zone ingress to the zone.

{% tip %}
Note that both local and cross-zone application traffic is not impacted by this failure case.
{% endtip %}

### Communication between 2 zones failing

This can happen if there are network connectivity issues:

- Between control plane and zone ingress from other zone.
- Between control plane and zone egress (when present).
- Between zone egress (when present) and zone ingress from other zone.
- All Zone egress instances of a zone (when present) are down.
- All zone ingress instances of a zone are down.

When it happens:

- Communication and operation within each zone is unaffected.
- Communication across each zone will fail.

{% tip %}
With the right resiliency setup ([Retries](/docs/{{ page.version }}/policies/retry), [Probes](/docs/{{ page.version }}/policies/health-check), [Locality Aware LoadBalancing](/docs/{{ page.version }}/policies/locality-aware), [Circuit Breakers](/docs/{{ page.version }}/policies/circuit-breaker)) the failing zone can be quickly severed and traffic re-routed to another zone.
{% endtip %}

## Delete a zone

To delete a `Zone` we must first shut down the corresponding {{site.mesh_product_name}} zone control plane instances. As long as the Zone CP is running this will not be possible, and {{site.mesh_product_name}} returns a validation error like:

```
zone: unable to delete Zone, Zone CP is still connected, please shut it down first
```

When the Zone CP is fully disconnected and shut down, then the `Zone` can be deleted. All corresponding resources (like `Dataplane` and `DataplaneInsight`) will be deleted automatically as well.

{% tabs delete-zone useUrlFragment=false %}
{% tab delete-zone Kubernetes %}

```sh
kubectl delete zone zone-1
```

{% endtab %}
{% tab delete-zone Universal %}

```sh
kumactl delete zone zone-1
```

{% endtab %}
{% endtabs %}

## Disable a zone

Change the `enabled` property value to `false` in the global control plane:

{% tabs disable-zone useUrlFragment=false %}
{% tab disable-zone Kubernetes %}

```yaml
apiVersion: kuma.io/v1alpha1
kind: Zone
metadata:
  name: zone-1
spec:
  enabled: false
```

{% endtab %}
{% tab disable-zone Universal %}

```yaml
type: Zone
name: zone-1
spec:
  enabled: false
```

{% endtab %}
{% endtabs %}

With this setting, the global control plane will stop exchanging configuration with this zone.
As a result, the zone's ingress from zone-1 will be deleted from other zone and traffic won't be routed to it anymore.
The zone will show as **Offline** in the GUI and CLI.
