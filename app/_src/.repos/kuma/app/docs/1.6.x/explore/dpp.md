---
title: Data plane proxy
---

When Kuma (`kuma-cp`) runs, it waits for the data plane proxies to connect and register themselves.

<center>
<img src="/assets/images/docs/0.4.0/diagram-10.jpg" alt="" style="width: 500px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

## Dataplane Entity

A `Dataplane` entity must be passed to `kuma-dp` when instances attempt to connect to the control plane.
On Kubernetes, this operation is [fully **automated**](/docs/{{ page.version }}/explore/dpp-on-kubernetes).
On Universal, it must be executed [**manually**](/docs/{{ page.version }}/explore/dpp-on-universal).

To understand why the `Dataplane` entity is required, we must take a step back. As we have explained already, Kuma follows a sidecar proxy model for the data plane proxies, where we have an instance of a data plane proxy for every instance of our services. Each Service and DP will communicate with each other on the same machine, therefore on `127.0.0.1`.

For example, if we have 6 replicas of a "Redis" service, then we must have one instances of `kuma-dp` running alongside each replica of the service, therefore 6 replicas of `kuma-dp` and 6 `Dataplane` entities as well.

<center>
<img src="/assets/images/docs/0.4.0/diagram-11.jpg" alt="" style="width: 500px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

{% tip %}
**Many DPs!** The number of data plane proxies that we have running can quickly add up, since we have one replica of `kuma-dp` for every replica of every service. That's why it's important for the `kuma-dp` process to be lightweight and consume few resources, otherwise we would quickly run out of memory, especially on platforms like Kubernetes where multiple services are running on the same underlying host machine. And that's one of the reasons Kuma leverages Envoy for this task.
{% endtip %}

When we start a new data plane proxy in Kuma, it needs to communicate a few things to the control-plane: 

- What types they are: "standard", "zone-ingress", "zoneegress" or "gateway".
- How they can be reached by other data plane proxies (This is an address/port combination).
- What services they expose (This will be called inbounds).
- How the application will use the sidecar to reach other services (either with transparent proxy or by explicitly listing services it will connect to).

{% tip %}
There exists special types of data planes proxies:

- [ZoneIngress](/docs/{{ page.version }}/explore/zone-ingress) which will enable inbound cross-zone traffic.
- [ZoneEgress](/docs/{{ page.version }}/explore/zoneegress) which allows isolating outgoing cross-zone
  traffic as well as any traffic going to external services available in local
  zone
- [Gateway](/docs/{{ page.version }}/explore/gateway) which will traffic external to the mesh to enter it.

Because these dataplane types are specific and complex we will discuss them separately to "standard" dataplane proxies.
{% endtip %}

To do this, we have to create a file with a `Dataplane` definition and pass it to `kuma-dp run`. This way, data-plane will be registered in the Control Plane and Envoy will start accepting requests.

{% tip %}
**Remember**: this is [all automated](/docs/{{ page.version }}/explore/dpp-on-kubernetes) if you are running Kuma on Kubernetes!
{% endtip %}

The registration of the `Dataplane` includes three main sections that are described below in the [Dataplane Specification](/docs/{{ page.version }}/reference/dpp-specification):

* `address` IP at which this dataplane will be accessible to other data plane proxies
* `inbound` networking configuration, to configure on what port the data plane proxy will listen to accept external requests, specify on what port the service is listening on the same machine (for internal DP <> Service communication), and the [Tags](#tags) that belong to the service. 
* `outbound` networking configuration, to enable the local service to consume other services.

{% tip %}
In order for a data plane proxy to successfully run, there must exist at least one [`Mesh`](/docs/{{ page.version }}/policies/mesh) in Kuma.
By default, the system generates a `default` Mesh when the control-plane is run for the first time.
{% endtip %}

## Envoy

`kuma-dp` is built on top of `Envoy`, which has a powerful [Admin API](https://www.envoyproxy.io/docs/envoy/latest/operations/admin) that enables monitoring and troubleshooting of a running dataplane.

By default, `kuma-dp` starts `Envoy Admin API` on the loopback interface (that is only accessible from the local host)
and port is taken from the data plane resource field `networking.admin.port`. If the `admin` section is empty or port
is equal to zero then the default value for port will be taken from the Kuma Control Plane configuration:

```yaml
# Configuration of Bootstrap Server, which provides bootstrap config to Dataplanes
bootstrapServer:
  # Parameters of bootstrap configuration
  params:
    # Port of Envoy Admin
    adminPort: 9901 # ENV: KUMA_BOOTSTRAP_SERVER_PARAMS_ADMIN_PORT
```

It is not possible to override the data plane proxy resource directly in Kubernetes. If you still want to override it, use the pod annotation `kuma.io/envoy-admin-port`.

## Tags

Each Kuma data plane proxy is associated with tags - or attributes - that can be used to both identify the service that the data plane proxy is representing, they are also used to configure the service mesh with matching [policies](/policies).

A tag attributes a qualifier to the data plane proxy, and the tags that are reserved to Kuma are prefixed with `kuma.io` like:

* `kuma.io/service`: Identifies the service name. On Kubernetes this tag is automatically created, while on Universal it must be specified manually.
* `kuma.io/zone`: Identifies the zone name in a [multi-zone deployment](/docs/{{ page.version }}/deployments/multi-zone). This tag is automatically created and cannot be overwritten.
* `kuma.io/protocol`: Identifies [the protocol](/docs/{{ page.version }}/policies/protocol-support-in-kuma) that is being exposed by the service and its data plane proxies. Accepted values are `tcp`, `http`, `http2`, `grpc` and `kafka`.

{% tip %}
The `kuma.io/service` tag must always be present.
{% endtip %}
