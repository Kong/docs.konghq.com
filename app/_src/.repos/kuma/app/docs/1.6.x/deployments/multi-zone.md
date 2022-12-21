---
title: Multi-zone deployment
---

## About

Kuma supports running your service mesh in multiple zones. It is even possible to run with a mix of Kubernetes and Universal zones. Your mesh environment can include multiple isolated service meshes (multi-tenancy), and workloads running in different regions, on different clouds, or in different datacenters. A zone can be a Kubernetes cluster, a VPC, or any other deployment you need to include in the same distributed mesh environment.

<center>
<img src="/assets/images/docs/0.6.0/distributed-diagram.jpg" alt="" style="width: 500px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

### How it works

Kuma manages service connectivity -- establishing and maintaining connections across zones in the mesh -- with the zone ingress and with a DNS resolver.

The DNS resolver is embedded in each data plane proxy and configured through XDS. It resolves each service address to a virtual IP address for all service-to-service communication.

The global control plane and the zone control planes communicate to synchronize resources such as Kuma policy configurations over Kuma Discovery Service (KDS), which is a protocol based on xDS.

{% tip %}
A zone ingress is not an API gateway. Instead, it is specific to internal cross-zone communication within the mesh. API gateways are supported in Kuma [gateway mode](/docs/{{ page.version }}/explore/gateway) which can be deployed in addition to zone ingresses.
{% endtip %}

### Components of a multi-zone deployment

A multi-zone deployment includes:

* The **global control plane**:
  * Accept connections only from zone control planes.
  * Accept creation and changes to [policies](/policies) that will be applied to the data plane proxies.
  * Send policies down to zone control planes.
  * Send zone ingresses down to zone control plane.
  * Keep an inventory of all data plane proxies running in all zones (this is only done for observability but is not required for operations).
  * Reject connections from data plane proxies.
* The **zone control planes**: 
  * Accept connections from data plane proxies started within this zone.
  * Receive policy updates from the global control plane.
  * Send data plane proxies and zone ingress changes to the global control plane.
  * Compute and send configurations using XDS to the local data plane proxies.
  * Update list of services which exist in the zone in the zone ingress.
  * Reject policy changes that do not come from global.
* The **data plane proxies**:
  * Connect to the local zone control plane.
  * Receive configurations using XDS from the local zone control plane.
  * Connect to other local data plane proxies.
  * Connect to zone ingresses for sending cross zone traffic.
  * Receive traffic from local data plane proxies and local zone ingresses.
* The **zone ingress**:
  * Receive XDS configuration from the local zone control plane.
  * Proxy traffic from other zone data plane proxies to local data plane proxies.
* (optional) The **zone egress**:
    * Receive XDS configuration from the local zone control plane.
    * Proxy traffic from local data plane proxies:
      * to zone ingress proxies from other zones;
      * to external services from local zone;

## Usage

To set up a multi-zone deployment we will need to:

- Set up the global control plane
- Set up the zone control planes
- Verify control plane connectivity
- Set up cross-zone communication between data plane proxies

### Set up the global control plane

The global control plane must run on a dedicated cluster, and cannot be assigned to a zone.

{% tabs global-control-plane useUrlFragment=false %}
{% tab global-control-plane Kubernetes %}

The global control plane on Kubernetes must reside on its own Kubernetes cluster, to keep its resources separate from the resources the zone control planes create during synchronization.

1.  Run:

    ```sh
    kumactl install control-plane --mode=global | kubectl apply -f -
    ```

1.  Find the external IP and port of the `global-remote-sync` service in the `kuma-system` namespace:

    ```sh
    kubectl get services -n kuma-system
    NAMESPACE     NAME                   TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)                                                                  AGE
    kuma-system   global-remote-sync     LoadBalancer   10.105.9.10     35.226.196.103   5685:30685/TCP                                                           89s
    kuma-system   kuma-control-plane     ClusterIP      10.105.12.133   <none>           5681/TCP,443/TCP,5676/TCP,5677/TCP,5678/TCP,5679/TCP,5682/TCP,5653/UDP   90s
    ```

    In this example the value is `35.226.196.103:5685`. You pass this as the value of `<global-kds-address>` when you set up the zone control planes.

{% endtab %}
{% tab global-control-plane Helm %}

1.  Set the `controlPlane.mode` value to `global` in the chart (`values.yaml`), then install. On the command line, run:

    ```sh
    helm install kuma --namespace kuma-system --set controlPlane.mode=global kuma/kuma
    ```

    Or you can edit the chart and pass the file to the `helm install kuma` command. To get the default values, run:

    ```sh
    helm show values kuma/kuma
    ```
1.  Find the external IP and port of the `global-remote-sync` service in the `kuma-system` namespace:

    ```sh
    kubectl get services -n kuma-system
    NAMESPACE     NAME                   TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)                                                                  AGE
    kuma-system   global-remote-sync     LoadBalancer   10.105.9.10     35.226.196.103   5685:30685/TCP                                                           89s
    kuma-system   kuma-control-plane     ClusterIP      10.105.12.133   <none>           5681/TCP,443/TCP,5676/TCP,5677/TCP,5678/TCP,5679/TCP,5682/TCP,5653/UDP   90s
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
    --namespace kuma-system \
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
    --namespace kuma-system \
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

2. Generate the zone ingress token:

   To register the zone ingress with the zone control plane, we need to generate a zone ingress token first

    ```sh
    kumactl generate zone-ingress-token --zone=<zone-name> > /tmp/ingress-token
    ```

   You can also generate the token [with the REST API](/docs/{{ page.version }}/security/zone-ingress-auth).

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
    --dataplane-token-file=/tmp/ingress-token \
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

5. Optional: if you want to deploy zone egress

   Create a `ZoneEgress` data plane proxy configuration to allow `kuma-cp` services

   To register the zone egress with the zone control plane, we need to generate
   a zone token first with appropriate scope first:

    ```sh
    kumactl generate zone-token --zone=<zone-name> --valid-for=24h --scope egress > /tmp/zoneegress-token
    ```

   You can also generate the token [with the REST API](/docs/{{ page.version }}/security/zoneegress-auth).

6. Create a `ZoneEgress` data plane proxy configuration to allow `kuma-cp` services
   to be configured to proxy traffic to other zones or external services through
   zone egress:

    ```sh
    echo "type: ZoneEgress
    name: zoneegress-01
    networking:
      address: 127.0.0.1 # address that is routable within the zone
      port: 10002" > zoneegress-dataplane.yaml
    ```

7. Apply the egress config, passing the IP address of the zone control plane to `cp-address`:

    ```sh
    kuma-dp run \
    --proxy-type=egress \
    --cp-address=https://<kuma-cp-address>:5678 \
    --dataplane-token-file=/tmp/zoneegress-token \
    --dataplane-file=zoneegress-dataplane.yaml
    ```
{% endtab %}
{% endtabs %}

### Verify control plane connectivity

You can run `kumactl get zones`, or check the list of zones in the web UI for the global control plane, to verify zone control plane connections.

When a zone control plane connects to the global control plane, the `Zone` resource is created automatically in the global control plane.

The Zone Ingress tab of the web UI also lists zone control planes that you
deployed with zone ingress.

### Set up cross-zone communication

#### Enable mTLS

You must [enable mTLS](/docs/{{ page.version }}/policies/mutual-tls) and [enable ZoneEgress](/docs/{{ page.version }}/explore/zoneegress#configuration) for cross-zone communication.

Kuma uses the Server Name Indication field, part of the TLS protocol, as a way to pass routing information cross zones. Thus, mTLS is mandatory to enable cross-zone service communication.

#### Ensure Zone Ingress has an external advertised address and port

Cross-zone communication between services is available only if Zone Ingress has an external advertised address and port.

{% tabs address-and-port useUrlFragment=false %}
{% tab address-and-port Kubernetes %}

If a service of type `NodePort` or `LoadBalancer` is attached to the data plane, Kuma will automatically retrieve the external address and port.

A service of type `LoadBalancer` is automatically created when installing Kuma with `kumactl install control-plane` or helm.

Depending on your load balancer implementation, you might need to wait a few minutes for Kuma to get the address.

You can also set this address and port by using the annotations: [`kuma.io/ingress-public-address` and `kuma.io/ingress-public-port`](/docs/{{ page.version }}/reference/kubernetes-annotations/#kuma-io-ingress-public-port)

{% endtab %}
{% tab address-and-port Universal %}
Set the advertisedAddress and advertisedPort field in the `ZoneIngress` definition
```yaml
type: ZoneIngress
name: ingress-01
networking:
  address: 127.0.0.1 # address that is routable within the zone
  port: 10000
  advertisedAddress: 10.0.0.1 # an address which other zones can use to consume this zone-ingress
  advertisedPort: 10000 # a port which other zones can use to consume this zone-ingress
```
{% endtab %}
{% endtabs %}

{% tip %}
This address doesn't need to be public to the internet.
It only needs to be reachable from all data plane proxies in other zones.
{% endtip %}

### Cross-zone communication details

{% tabs cross-zone-communication-details useUrlFragment=false %}
{% tab cross-zone-communication-details Kubernetes %}

To view the list of service names available for cross-zone communication, run:

```sh
kubectl get dataplanes -n echo-example -o yaml | grep kuma.io/service
           kuma.io/service: echo-server_echo-example_svc_1010
```

To consume the example service only within the same Kuma zone, you can run:

```sh
<kuma-enabled-pod>$ curl http://echo-server:1010
```

To consume the example service across all zones in your Kuma deployment (that is, from endpoints ultimately connecting to the same global control plane), you can run either of:

```sh
<kuma-enabled-pod>$ curl http://echo-server_echo-example_svc_1010.mesh:80
<kuma-enabled-pod>$ curl http://echo-server.echo-example.svc.1010.mesh:80
```

And if your HTTP clients take the standard default port 80, you can the port value and run either of:

```sh
<kuma-enabled-pod>$ curl http://echo-server_echo-example_svc_1010.mesh
<kuma-enabled-pod>$ curl http://echo-server.echo-example.svc.1010.mesh
```

Because Kuma on Kubernetes relies on transparent proxy, `kuma-dp` listens on port 80 for all virtual IPs that are assigned to services in the `.mesh` DNS zone. The DNS names are rendered RFC compatible by replacing underscores with dots.
We can configure more flexible setup of hostnames and ports using [Virtual Outbound](/docs/{{ page.version }}/policies/virtual-outbound).

{% endtab %}
{% tab cross-zone-communication-details Universal %}

With a hybrid deployment, running in both Kubernetes and Universal mode, the service tag should be the same in both environments (e.g `echo-server_echo-example_svc_1010`):

```yaml
type: Dataplane
mesh: default
name: backend-02 
networking:
  address: 127.0.0.1
  inbound:
  - port: 2010
    servicePort: 1010
    tags:
      kuma.io/service: echo-server_echo-example_svc_1010
```

If the service is only meant to be run Universal, `kuma.io/service` does not have to follow `{name}_{namespace}_svc_{port}` convention.

To consume a distributed service in a Universal deployment, where the application address is `http://localhost:20012`:

```yaml
type: Dataplane
mesh: default
name: web-02 
networking:
  address: 127.0.0.1
  inbound:
  - port: 10000
    servicePort: 10001
    tags:
      kuma.io/service: web
  outbound:
  - port: 20012
    tags:
      kuma.io/service: echo-server_echo-example_svc_1010
```

Alternatively, you can just call `echo-server_echo-example_svc_1010.mesh` without defining `outbound` section if you configure [transparent proxy](/docs/{{ page.version }}/networking/transparent-proxying).

{% endtab %}
{% endtabs %}

The Kuma DNS service format (e.g. `echo-server_kuma-test_svc_1010.mesh`) is a composition of Kubernetes Service Name (`echo-server`),
Namespace (`kuma-test`), a fixed string (`svc`), the service port (`1010`). The service is resolvable in the DNS zone `.mesh` where
the Kuma DNS service is hooked.

### Delete a zone

To delete a `Zone` we must first shut down the corresponding Kuma zone control plane instances. As long as the Remote CP is running this will not be possible, and Kuma returns a validation error like:

```
zone: unable to delete Zone, Remote CP is still connected, please shut it down first
```

When the Remote CP is fully disconnected and shut down, then the `Zone` can be deleted. All corresponding resources (like `Dataplane` and `DataplaneInsight`) will be deleted automatically as well.

{% tabs delete-a-zone useUrlFragment=false %}
{% tab delete-a-zone Kubernetes %}
```sh
kubectl delete zone zone-1
```
{% endtab %}
{% tab delete-a-zone Universal %}
```sh
kumactl delete zone zone-1
```
{% endtab %}
{% endtabs %}

### Disable a zone

Change the `enabled` property value to `false` in the global control plane:

{% tabs disable-a-zone useUrlFragment=false %}
{% tab disable-a-zone Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: Zone
metadata:
  name: zone-1
spec:
  enabled: false
```
{% endtab %}
{% tab disable-a-zone Universal %}
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

## Failure modes

### Global control plane offline

* Policy updates will be impossible
* Change in service list between zones will not propagate:
    * New services will not be discoverable in other zones.
    * Services removed from a zone will still appear available in other zones.
* You won't be able to disable or delete a zone.

{% tip %}
Note that both local and cross-zone application traffic is not impacted by this failure case.
Data plane proxy changes will be propagated within their zones.
{% endtip %}

### Zone control plane offline

* New data plane proxies won't be able to join the mesh.
* Data plane proxy configuration will not be updated.
* Communication between data plane proxies will still work.
* Cross zone communication will still work.
* Other zones are unaffected.

{% tip %}
You can think of this failure case as *"Freezing"* the zone mesh configuration.
Communication will still work but changes will not be reflected on existing data plane proxies.
{% endtip %}

### Communication between Global and Zone control plane failing

This can happen with misconfiguration or network connectivity issues between control planes.

* Operations inside the zone will happen correctly (data plane proxies can join, leave and all configuration will be updated and sent correctly).
* Policy changes will not be propagated to the zone control plane.
* `ZoneIngress`, `ZoneEgress` and `Dataplane` changes will not be propagated to the global control plane:
    * The global inventory view of the data plane proxies will be outdated (this only impacts observability).
    * Other zones will not see new services registered inside this zone.
    * Other zones will not see services no longer running inside this zone.
    * Other zones will not see changes in number of instances of each service running in the local zone.
* Global control plane will not send changes from other zone ingress to the zone:
    * Local data plane proxies will not see new services registered in other zones.
    * Local data plane proxies will not see services no longer running in other zones.
    * Local data plane proxies will not see changes in number of instances of each service running in other zones.
* Global control plane will not send changes from other zone ingress to the zone.

{% tip %}
Note that both local and cross-zone application traffic is not impacted by this failure case.
{% endtip %}

### Communication between 2 zones failing

This can happen if there are network connectivity issues:
* Between control plane and zone ingress from other zone.
* Between control plane and zone egress (when present).
* Between zone egress (when present) and zone ingress from other zone.
* All Zone egress instances of a zone (when present) are down.
* All zone ingress instances of a zone are down.

When it happens:
* Communication and operation within each zone is unaffected.
* Communication across each zone will fail.

{% tip %}
With the right resiliency setup ([Retries](/docs/{{ page.version }}/policies/retry), [Probes](/docs/{{ page.version }}/policies/health-check), [Locality Aware LoadBalancing](/docs/{{ page.version }}/policies/locality-aware), [Circuit Breakers](/docs/{{ page.version }}/policies/circuit-breaker)) the failing zone can be quickly severed and traffic re-routed to another zone.
{% endtip %}
