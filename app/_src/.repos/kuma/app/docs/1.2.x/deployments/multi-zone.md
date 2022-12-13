---
title: Set up a multi-zone deployment
---

## Multi-Zone Mode

This is a more advanced deployment mode for Kuma that allow us to support service meshes that are running on many zones, including hybrid deployments on both Kubernetes and VMs.

* **Control plane**: There is one `global` control plane, and many `zone` control planes. A global control plane only accepts connections from zone control planes.
* **Data plane proxies**: The data plane proxies connect to the closest `zone` control plane in the same zone. Additionally, we need to start a `zone-ingress` proxy on every zone to have cross-zone communication between data plane proxies in different zones.
* **Service Connectivity**: Automatically resolved via the built-in DNS resolver that ships with Kuma. When a service wants to consume another service, it will resolve the DNS address of the desired service with Kuma, and Kuma will respond with a Virtual IP address, that corresponds to that service in the Kuma service domain.

{% tip %}
We can support multiple isolated service meshes thanks to Kuma's multi-tenancy support, and workloads from both Kubernetes or any other supported Universal environment can participate in the Service Mesh across different regions, clouds, and datacenters while not compromising the ease of use and still allowing for end-to-end service connectivity.
{% endtip %}

When running in multi-zone mode, we introduce the notion of a `global` and `zone` control planes for Kuma:

* **Global**: this control plane will be used to configure the global Service Mesh [policies](/policies) that we want to apply to our data plane proxies. Data plane proxies **cannot** connect directly to a global control plane, but can connect to `zone` control planes that are being deployed on each underlying zone that we want to include as part of the Service Mesh (can be a Kubernetes cluster, or VM based). Only one deployment of the global control plane is required, and it can be scaled horizontally.
* **Zone**: we are going to have as many zone control planes as the number of underlying Kubernetes or VM zones that we want to include in a Kuma [mesh](/docs/{{ page.version }}/policies/mesh/). Zone control planes accept connections from data plane proxies that are started in the same underlying zone, and they connect to the `global` control plane to fetch their service mesh policies. Zone control plane policy APIs are read-only and **cannot** accept Service Mesh policies to be directly configured on them. They can be scaled horizontally within their zone.

In this deployment, a Kuma cluster is made of one global control plane and as many zone control planes as the number of zones that we want to support:

* **Zone**: A zone identifies a Kubernetes cluster, a VPC, or any other cluster that we want to include in a Kuma service mesh.

<center>
<img src="/assets/images/docs/distributed-diagram@2x.jpg" alt="" style="width: 500px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

In a multi-zone deployment mode, services will be running on multiple platforms, clouds, or Kubernetes clusters (which are identifies as `zones` in Kuma). While all of them will be part of a Kuma mesh by connecting their data plane proxies to the local `zone` control plane in the same zone, implementing service to service connectivity would be tricky since a source service may not know where a destination service is being hosted at (for instance, in another zone).

To implement easy service connectivity, Kuma ships with:

* **DNS Resolver**: Kuma provides an out of the box DNS server on every `zone` control plane that will be used to resolve service addresses when estabilishing any service-to-service communication. It scales horizontally as we scale the `zone` control plane.
* **Zone Ingress Proxy**: Kuma provides an out of the box `zone-ingress` proxy mode that will be used to enable traffic to enter a zone from another zone. It can be scaled horizontally. Each zone must have a `zone-ingress` proxy deployed. 

{% tip %}
A `zone-ingress` proxy is specific to internal communication within a mesh and is not to be considered an API gateway. API gateways are supported in Kuma's [gateway mode](/docs/{{ page.version }}/documentation/dps-and-data-model/#gateway), which can be deployed in addition to `zone-ingress` proxies.
{% endtip %}

The global control plane and the zone control planes communicate with each other over xDS to synchronize the resources that are created to configure Kuma, such as policies.

{% warning %}
**For Kubernetes**: The global control plane on Kubernetes must reside on its own Kubernetes cluster, in order to keep the CRDs separate from the ones that the zone control planes will create during the synchronization process.
{% endwarning %}

### Usage

In order to deploy Kuma in a multi-zone deployment, we must start a `global` and as many `zone` control planes as the number of zones that we want to support.

### Global control plane

First we start the `global` control plane and configure the `zone` control planes connectivity.

{% tabs global useUrlFragment=false %}
{% tab global Kubernetes %}

Install the `global` control plane using:
```bash
kumactl install control-plane --mode=global | kubectl apply -f -
```

Find the external IP and port of the `global-zone-sync` service in `kuma-system` namespace:

```bash
kubectl get services -n kuma-system
# NAMESPACE     NAME                   TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)                                                                  AGE
# kuma-system   global-zone-sync     LoadBalancer   10.105.9.10     35.226.196.103   5685:30685/TCP                                                           89s
# kuma-system   kuma-control-plane     ClusterIP      10.105.12.133   <none>           5681/TCP,443/TCP,5676/TCP,5677/TCP,5678/TCP,5679/TCP,5682/TCP,5653/UDP   90s
```

In this example it is `35.226.196.103:5685`. This will be used as `<global-kds-address>` further.
{% endtab %}
{% tab global Helm %}
Install the `global` control plane by setting the `controlPlane.mode` value to `global` when installing the chart. This can be done on the command line, or in a provided file:

```sh
helm install --version 0.6.3 kuma --namespace kuma-system --set controlPlane.mode=global kuma/kuma
```
{% endtab %}
{% tab global Universal %}

Running the Global Control Plane setting up the relevant environment variable
```sh
KUMA_MODE=global kuma-cp run
```
{% endtab %}
{% endtabs %}

### Zone control plane

Start the `zone` control planes in each zone that will be part of the multi-zone Kuma deployment.
To install `zone` control plane, you need to assign the zone name for each of them and point it to the Global CP.

{% tabs zone-control-plane useUrlFragment=false %}
{% tab zone-control-plane Kubernetes %}
```sh
kumactl install control-plane \
  --mode=zone \
  --zone=<zone name> \
  --ingress-enabled \
  --kds-global-address grpcs://`<global-kds-address>` | kubectl apply -f -
```

{% tip %}
Kuma DNS installation supports several flavors of CoreDNS and kube-dns. We recommend checking the configuration of the Kubernetes cluster after deploying the Kuma zone control plane to ensure everything is as expected.
{% endtip %}
{% endtab %}
{% tab zone-control-plane Helm %}
To install the Zone Control plane we need to provide the following parameters:
 * `controlPlane.mode=zone`
 * `controlPlane.zone=<zone-name>`
 * `ingress.enabled=true`
 * `controlPlane.kdsGlobalAddress=grpcs://<global-kds-address>`:

```bash
helm install --version 0.6.3 kuma --namespace kuma-system --set controlPlane.mode=zone,controlPlane.zone=<zone-name>,ingress.enabled=true,controlPlane.kdsGlobalAddress=grpcs://<global-kds-address> kuma/kuma
```

{% tip %}
Kuma DNS installation supports several flavors of CoreDNS and kube-dns. We recommend checking the configuration of the Kubernetes cluster after deploying Kuma zone control plane to ensure evrything is as expected.

To install DNS we need to use `kumactl`. It reads the state of the control plane therefore it could not be put into HELM.  You can track the issue to put this into HELM [here](https://github.com/kumahq/kuma/issues/1124).
{% endtip %}
{% endtab %}
{% tab zone-control-plane Universal %}

Run the `kuma-cp` in `zone` mode.

```sh
KUMA_MODE=zone \
  KUMA_MULTIZONE_ZONE_NAME=<zone-name> \
  KUMA_MULTIZONE_ZONE_GLOBAL_ADDRESS=grpcs://<global-kds-address> \
  ./kuma-cp run
```

Where `<zone-name>` is the name of the zone matching one of the Zone resources to be created at the Global CP. `<global-zone-sync-address>` is the public address as obtained during the Global CP deployment step.

Note that this example runs the zone control plane with an in-memory datastore. This approach is not recommended for production because it does not scale. Consider running with Postgres instead.

Add a `zone-ingress` proxy, so `kuma-cp` can expose its services for cross-zone communication. Typically, that data plane proxy would run on a dedicated host, so we will need the Zone CP address `<kuma-cp-address>` and pass it as `--cp-address`, when `kuma-dp` is started. Another important thing is to generate the data plane proxy token using the REST API or `kumactl` as [described](/docs/{{ page.version }}/deployments/security/#data-plane-proxy-authentication).

```bash
echo "type: ZoneIngress
name: ingress-01
networking:
  address: 127.0.0.1 # address that is routable within the zone
  port: 10000
  advertisedAddress: 10.0.0.1 # an address which other zones can use to consume this zone-ingress
  advertisedPort: 10000 # a port which other zones can use to consume this zone-ingress" > ingress-dp.yaml
kumactl generate zone-ingress-token --zone=<zone-name> > /tmp/ingress-token
kuma-dp run \
  --proxy-type=ingress \
  --cp-address=https://<kuma-cp-address>:5678 \
  --dataplane-token-file=/tmp/ingress-token \
  --dataplane-file=ingress-dp.yaml 
```

Adding more data plane proxies can be done locally by following the Use Kuma section on the [installation page](/install).
{% endtab %}
{% endtabs %}

### Verify control plane connectivity

When a zone control plane connects to the global control plane, the `Zone` resource is created automatically in the global control plane.
You can verify if a zone control plane is connected to the global control plane by inspecting the list of zones in the global control plane GUI (`:5681/gui/#/zones`) or by using `kumactl get zones`.

Additionally, if you deployed zone control plane with Zone Ingress, it should be visible in the Zone Ingress tab of the GUI.
Cross-zone communication between services is only available if Zone Ingress has a public address and public port.
Note that on Kubernetes, Kuma automatically tries to pick up the public address and port. Depending on the LB implementation of your Kubernetes provider, you may need to wait a couple of minutes to receive the address. 

### Enable mTLS

Cross-zone communication between services is only possible when mTLS is enabled, because Zone Ingress is routing connections using SNI.
Make sure you [enable mTLS](/docs/{{ page.version }}/policies/mutual-tls) and apply [Traffic Permission](/docs/{{ page.version }}/policies/traffic-permissions). 

### Using the multi-zone deployment

To utilize the multi-zone Kuma deployment follow the steps below
{% tabs multi-zone-deployment useUrlFragment=false %}
{% tab multi-zone-deployment Kubernetes %}

To figure out the service names that we can use in the applications for cross-zone communication, we can look at the 
service tag in the deployed data plane proxies: 

```bash
kubectl get dataplanes -n echo-example -o yaml | grep service
           service: echo-server_echo-example_svc_1010
```

On Kubernetes, Kuma uses transparent proxy. In this mode, `kuma-dp` is listening on port 80 for all the virtual IPs that 
Kuma DNS assigns to services in the `.mesh` DNS zone. It also provides an RFC compatible DNS name where the underscores in the
service are replaced by dots. Therefore, we have the following ways to consume a service from within the mesh:

```bash
<kuma-enabled-pod>curl http://echo-server:1010
<kuma-enabled-pod>curl http://echo-server_echo-example_svc_1010.mesh:80
<kuma-enabled-pod>curl http://echo-server.echo-example.svc.1010.mesh:80
<kuma-enabled-pod>curl http://echo-server_echo-example_svc_1010.mesh
<kuma-enabled-pod>curl http://echo-server.echo-example.svc.1010.mesh
```
The first method still works, but is limited to endpoints implemented within the same Kuma zone (i.e. the same Kubernetes cluster).
The second and third options allow to consume a service that is distributed across the Kuma cluster (bound by the same `global` control plane). For
example there can be an endpoint running in another Kuma zone in a different data-center.

Since most HTTP clients (such as `curl`) will default to port 80, the port can be omitted, like in the fourth and fifth options above.
{% endtab %}
{% tab multi-zone-deployment Universal %}

In hybrid (Kubernetes and Universal) deployments, the service tag should be the same in both environments (e.g `echo-server_echo-example_svc_1010`)

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

If a multi-zone Universal control plane is used, the service tag has no such limitation.

And to consume the distributed service from a Universal deployment, where the application will use `http://localhost:20012`.

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

{% endtab %}
{% endtabs %}

{% tip %}
The Kuma DNS service format (e.g. `echo-server_kuma-test_svc_1010.mesh`) is a composition of Kubernetes Service Name (`echo-server`),
Namespace (`kuma-test`), a fixed string (`svc`), the service port (`1010`). The service is resolvable in the DNS zone `.mesh` where
the Kuma DNS service is hooked.
{% endtip %}

### Deleting a Zone

To delete a `Zone` we must first shut down the corresponding Kuma Zone CP instances. As long as the Zone CP is running this will not be possible, and Kuma will return a validation error like:

```
zone: unable to delete Zone, Zone CP is still connected, please shut it down first
```

When the Zone CP is fully disconnected and shut down, then the `Zone` can be deleted. All corresponding resources (like `Dataplane` and `DataplaneInsight`) will be deleted automatically as well.

### Disabling zone

In order to disable routing traffic to a specific `Zone`, we can disable the `Zone` via the `enabled` field:

```yaml
type: Zone
name: zone-1
spec:
  enabled: true
```

Changing this value to `enabled: false` will allow the user to exclude the `Zone Ingress` from all other zones - and by doing so - preventing traffic from being able to enter the `zone`. 

{% tip %}
A `Zone` that has been disabled will show up as "Offline" in the GUI and CLI
{% endtip %}
