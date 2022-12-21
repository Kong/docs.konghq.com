---
title: Fine-tuning
---

## Postgres

If you choose `Postgres` as a configuration store for `Kuma` on Universal,
please be aware of the following key settings that affect performance of Kuma Control Plane.

* `KUMA_STORE_POSTGRES_CONNECTION_TIMEOUT` : connection timeout to the Postgres database (default: 5s)
* `KUMA_STORE_POSTGRES_MAX_OPEN_CONNECTIONS` : maximum number of open connections to the Postgres database (default: unlimited)

### KUMA_STORE_POSTGRES_CONNECTION_TIMEOUT

The default value will work well in those cases where both `kuma-cp` and Postgres database are deployed in the same datacenter / cloud region.

However, if you're pursuing a more distributed topology, e.g. by hosting `kuma-cp` on premise and using Postgres as a service in the cloud, the default value might no longer be enough.

### KUMA_STORE_POSTGRES_MAX_OPEN_CONNECTIONS

The more dataplanes join your meshes, the more connections to Postgres database Kuma might need to fetch configurations and update statuses.

The default value (unlimited) allows Kuma to make better use of all available resources.

However, if your Postgres database (e.g., as a service in the cloud) only permits a small number of concurrent connections, you will have to adjust Kuma configuration respectively.

## Snapshot Generation

{% warning %}
This is advanced topic describing Kuma implementation internals
{% endwarning %}

The main task of the control plane is to provide config for dataplanes. When a dataplane connects to the control plane, the CP starts a new goroutine.
This goroutine runs the reconciliation process with given interval (1s by default). During this process, all dataplanes and policies are fetched for matching.
When matching is done, the Envoy config (including policies and available endpoints of services) for given dataplane is generated and sent only if there is an actual change.

* `KUMA_XDS_SERVER_DATAPLANE_CONFIGURATION_REFRESH_INTERVAL` : interval for re-genarting configuration for Dataplanes connected to the Control Plane (default: 1s)

This process can be CPU intensive with high number of dataplanes therefore you can control the interval time for a single dataplane.
You can lower the interval scarifying the latency of the new config propagation to avoid overloading the CP. For example,
changing it to 5s means that when you apply a policy (like TrafficPermission) or the new dataplane of the service is up or down, CP will generate and send new config within 5 seconds.

For systems with high traffic, keeping old endpoints for such a long time (5s) may not be acceptable. To solve this, you can use passive or active [health checks](/docs/{{ page.version }}/policies/health-check) provided by Kuma.

Additionally, to avoid overloading the underlying storage there is a cache that shares fetch results between concurrent reconciliation processes for multiple dataplanes.

* `KUMA_STORE_CACHE_EXPIRATION_TIME` : expiration time for elements in cache (1s by default).

You can also change the expiration time, but it should not exceed `KUMA_XDS_SERVER_DATAPLANE_CONFIGURATION_REFRESH_INTERVAL`, otherwise CP will be wasting time building Envoy config with the same data.

## Profiling

Kuma's control plane ships with [pprof](https://golang.org/pkg/net/http/pprof/) endpoints so you can profile and debug the performance of the `kuma-cp` process.

To enable the debugging endpoints, you can set the `KUMA_DIAGNOSTICS_DEBUG_ENDPOINTS` environment variable to `true` before starting `kuma-cp` and use one of the following methods to retrieve the profiling information:

{% tabs profiling useUrlFragment=false %}
{% tab profiling pprof %}

You can retrieve the profiling information with Golang's `pprof` tool, for example:

```sh
go tool pprof http://<IP of the CP>:5680/debug/pprof/profile?seconds=30
```

{% endtab %}
{% tab profiling curl %}

You can retrieve the profiling information with `curl`, for example:

```sh
curl http://<IP of the CP>:5680/debug/pprof/profile?seconds=30 --output prof.out
```
{% endtab %}
{% endtabs %}

Then, you can analyze the retrieved profiling data using an application like [Speedscope](https://www.speedscope.app/).

{% warning %}
After a successful debugging session, please remember to turn off the debugging endpoints since anybody could execute heap dumps on them potentially exposing sensitive data.
{% endwarning %}