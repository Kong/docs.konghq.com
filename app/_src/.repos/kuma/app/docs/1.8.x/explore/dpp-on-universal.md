---
title: Data plane on Universal
---

As mentioned previously in universal you need to create a dataplane definition and pass it to the `kuma-dp run` command.

When transparent proxying is not enabled, the outbound service dependencies have to be manually specified in the [`Dataplane`](/docs/{{ page.version }}/explore/dpp#dataplane-entity) entity.
This also means that with transparent proxying **you must update** your codebases to consume those external services on `127.0.0.1` on the port specified in the `outbound` section.

For example, this is how we start a `Dataplane` for a hypothetical Redis service and then start the `kuma-dp` process:

```sh
cat dp.yaml
type: Dataplane
mesh: default
name: redis-1
networking:
  address: 192.168.0.1
  inbound:
  - port: 9000
    servicePort: 6379
    tags:
      kuma.io/service: redis

kuma-dp run \
  --cp-address=https://127.0.0.1:5678 \
  --dataplane-file=dp.yaml
  --dataplane-token-file=/tmp/kuma-dp-redis-1-token
```

In the example above, any external client who wants to consume Redis will have to make a request to the DP on address `192.168.0.1` and port `9000`, which internally will be redirected to the Redis service listening on address `127.0.0.1` and port `6379`.

{% tip %}
Note that in Universal dataplanes need to start with a token for authentication. You can learn how to generate tokens in the [security section](/docs/{{ page.version }}/security/dp-auth#data-plane-proxy-token).
{% endtip %}

Now let's assume that we have another service called "Backend" that internally listens on port `80`, and that makes outgoing requests to the `redis` service:

```sh
cat dp.yaml
type: Dataplane
mesh: default
name: {{ name }}
networking:
  address: {{ address }}
  inbound:
  - port: 8000
    servicePort: 80
    tags:
      kuma.io/service: backend
      kuma.io/protocol: http
  outbound:
  - port: 10000
    tags:
      kuma.io/service: redis

kuma-dp run \
  --cp-address=https://127.0.0.1:5678 \
  --dataplane-file=dp.yaml \
  --dataplane-var name=`hostname -s` \
  --dataplane-var address=192.168.0.2 \
  --dataplane-token-file=/tmp/kuma-dp-backend-1-token
```

In order for the `backend` service to successfully consume `redis`, we specify an `outbound` networking section in the `Dataplane` configuration instructing the DP to listen on a new port `10000` and to proxy any outgoing request on port `10000` to the `redis` service.
For this to work, we must update our application to consume `redis` on `127.0.0.1:10000`.

{% tip %}
You can parametrize your `Dataplane` definition, so you can reuse the same file for many `kuma-dp` instances or even services.
{% endtip %}

## Lifecycle

On Universal you can manage `Dataplane` resources either in [Direct](#direct) mode or in [Indirect](#indirect) mode.

### Direct

This is the recommended way to operate with `Dataplane` resources on Universal.

#### Joining the mesh

Pass `Dataplane` resource directly to `kuma-dp run` command. `Dataplane` resource could be a [Mustache template](http://mustache.github.io/mustache.5.html) in this case:

_backend-dp-tmpl.yaml_

```yaml
type: Dataplane
mesh: default
name: { { name } }
networking:
  address: { { address } }
  inbound:
    - port: 8000
      servicePort: 80
      tags:
        kuma.io/service: backend
        kuma.io/protocol: http
```

The command with template parameters will look like this:

```shell
kuma-dp run \
  --dataplane-file=backend-dp-tmpl.yaml \
  --dataplane-var name=my-backend-dp \
  --dataplane-var address=192.168.0.2 \
  ...
```

When xDS connection between proxy and kuma-cp is established, `Dataplane` resource will be created automatically by kuma-cp.

To join the mesh in a graceful way, we need to first make sure the application is ready to serve traffic before it can be considered a valid traffic destination.
By default, a proxy will be considered healthy regardless of its state. Consider using [service probes](/docs/{{ page.version }}/policies/service-health-probes)
to mark the data plane proxy as healthy only after all health checks are passed.

#### Leaving the mesh

To leave the mesh in a graceful shutdown, we need to remove the traffic destination from all the clients before shutting it down.

`kuma-dp` process upon receiving SIGTERM starts listener draining in Envoy, then it waits for draining time before stopping the process.
During the draining process, Envoy can still accept connections however:

1. It is marked as unhealthy on Envoy Admin `/ready` endpoint
2. It sends `connection: close` for HTTP/1.1 requests and GOAWAY frame for HTTP/2.
   This forces clients to close a connection and reconnect to the new instance.

If the application next to the `kuma-dp` process quits immediately after the SIGTERM signal, there is a high chance that clients will still try to send traffic to this destination.
To mitigate this, we need to support graceful shutdown in the application. For example, the application should wait X seconds to exit after receiving the first SIGTERM signal.

Consider using [service probes](/docs/{{ page.version }}/policies/service-health-probes) to mark data plane proxy as unhealthy when it is in draining state.

If data plane proxy is shutdown gracefully, the `Dataplane` resource is automatically deleted by kuma-cp.

If the data plane proxy goes down ungracefully, the `Dataplane` resource is not deleted immediately. The following happens:
of the events should happen:

1. After `KUMA_METRICS_DATAPLANE_IDLE_TIMEOUT` (default 5mins) the data plane proxy is marked as Offline . This is because
   there's no active xDS connection between the proxy and kuma-cp.
2. After `KUMA_RUNTIME_UNIVERSAL_DATAPLANE_CLEANUP_AGE` (default 72h) offline data plane proxies are deleted.

This guarantees that `Dataplane` resources are eventually cleaned up even in the case of **ungraceful** shutdown.

### Indirect

The lifecycle is called "Indirect", because there is no strict dependency between `Dataplane` resource creation and the
startup of the data plane proxy. This is a good way if you have some external components that manages `Dataplane`
lifecycle.

#### Joining the mesh

`Dataplane` resource is created using [HTTP API](/docs/{{ page.version }}/reference/http-api#dataplanes) or [kumactl](/docs/{{ page.version }}/explore/cli).
`Dataplane` resource is created before data plane proxy started. There is no support for templates, resource should be
a valid `Dataplane` configuration.

When data plane proxy is started, it takes `name` and `mesh` as an input arguments. After connection between proxy and
kuma-cp is established, kuma-cp finds the `Dataplane` resource with `name` and `mesh` in the store.

```shell
kuma-cp run \
  --name=my-backend-dp \
  --mesh=default \
  ...
```

To join the mesh in a graceful way, you can use service probes just like in Direct section.

#### Leaving the mesh

Kuma-cp will **never** delete the `Dataplane` resource (with both graceful and ungraceful shutdowns).

If data plane proxy is shutdown gracefully, then `Dataplane` resource will be marked as Offline. Offline data plane proxies
deleted automatically after `KUMA_RUNTIME_UNIVERSAL_DATAPLANE_CLEANUP_AGE`, by default it's 72h.

If data plane proxy went down ungracefully, then the following sequence of the events should happen:

1. After `KUMA_METRICS_DATAPLANE_IDLE_TIMEOUT` (default 5mins) the data plane proxy is marked as Offline . This is because
   there's no active xDS connection between the proxy and kuma-cp.
2. After `KUMA_RUNTIME_UNIVERSAL_DATAPLANE_CLEANUP_AGE` (default 72h) offline data plane proxies are deleted.

To leave the mesh in a graceful way, you can use service probes just like in Direct section.

## Envoy

`Envoy` has a powerful [Admin API](https://www.envoyproxy.io/docs/envoy/latest/operations/admin) for monitoring and troubleshooting.

By default, `kuma-dp` starts `Envoy Admin API` on the loopback interface. The port is configured in the `Dataplane` entity:

```yaml
type: Dataplane
mesh: default
name: my-dp
networking:
  admin:
    port: 1000
# ...
```

If the `admin` section is empty or port is equal to zero then the default value for port will be taken from the [Kuma Control Plane configuration](/docs/{{ page.version }}/generated/kuma-cp).
