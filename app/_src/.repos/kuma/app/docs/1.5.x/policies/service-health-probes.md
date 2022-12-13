---
title: Service Health Probes
---

Kuma is able to track the status of the Envoy proxy. If grpc stream with Envoy is disconnected then Kuma considers this 
proxy as offline, but we still send the traffic regardless of that, because this status is designed to track the connection
between `kuma-cp` and `kuma-dp`. 

Also, every `inbound` in the Dataplane model has `health` section:

```yaml
type: Dataplane
mesh: default
name: web-01
networking:
  address: 127.0.0.1
  inbound:
    - port: 11011
      servicePort: 11012
      health:
        ready: true
      tags:
        kuma.io/service: backend
        kuma.io/protocol: http
```

This `health.ready` status is intended to show the status of the service itself. It is set differently depending on 
the environment ([Kubernetes](#kubernetes-probes) or [Universal](#universal-probes)), but it's treated the same way 
regardless of the environment:

- if `health.ready` is true or `health` section is missing - Kuma considers the inbound as healthy and includes it 
  into load balancing set.
- if `health.ready` is false -  Kuma doesn't include the inbound into load balancing set.

Also, `health.ready` is used to compute the status of the Dataplanes and Service. You can see these statuses both in Kuma GUI and Kuma CLI:

- if proxy status is `Offline`, then Dataplane is `Offline`:
- if proxy status is `Online`:
  - if all inbounds are ready then Dataplane is `Online`
  - if all inbounds are not ready then Dataplane is `Offline`
  - if at least one of the inbounds is not ready then Dataplane is `Partially degraded` 
  - if inbound is not ready then it's not included in the load-balancer set which means it doesn't receive the traffic
  - if all inbounds which implement the same service are ready then service is `Online`
  - if all inbounds which implement the same service are not ready then service is `Offline`
  - if at least one of the inbounds which implement the same service is not ready then service is `Partially degraded`

## Kubernetes probes

Even if Kubernetes probes are disabled, Kuma takes `pod.status.containerStatuses.ready` in order to fill `dataplane.inbound.health` section.

If you specify `httpGet` probe for the Pod, Kuma will generate a special non-MTLs listener and overrides the probe itself in 
the Pod resource. This feature is called Virtual probes, and it allows `kubelet` probing the pod status even if MTLS is enabled on the mesh. 
For example, if we specify the following probe:

```yaml
livenessProbe:
  httpGet:
    path: /metrics
    port: 3001
  initialDelaySeconds: 3
  periodSeconds: 3
```

Kuma will replace it with:

```yaml
livenessProbe:
  httpGet:
    path: /3001/metrics
    port: 9000
  initialDelaySeconds: 3
  periodSeconds: 3
```

Where `9000` is a default virtual probe port, which can be configured in `kuma-cp.config`:

```yaml
runtime:
  kubernetes:
    injector:
      virtualProbesPort: 19001
```
And can also be overwritten in the Pod's annotations:

```yaml
annotations:
  kuma.io/virtual-probes-port: 19001
```

To disable Kuma's probe virtualziation, we can either set it in Kuma's configuration file `kuma-cp.config`:

```yaml
runtime:
  kubernetes:
    injector:
      virtualProbesEnabled: false
```

or in the Pod's annotations:

```yaml
annotations:
  kuma.io/virtual-probes: disabled
```

The same behaviour could be configured using environment variables: 

- `KUMA_RUNTIME_KUBERNETES_VIRTUAL_PROBES_ENABLED=false`
- `KUMA_RUNTIME_KUBERNETES_VIRTUAL_PROBES_ENABLED=19001`


## Universal probes

On Universal there is no single standard for probing the service. For health checking of the service status on
Universal Kuma is using Envoy's Health Discovery Service (HDS). Envoy does health checks and reports the status back to Kuma Control Plane.

In order to configure health checking of your service you have to update `inbound` config with `serviceProbe`:

```yaml
type: Dataplane
mesh: default
name: web-01
networking:
  address: 127.0.0.1
  inbound:
    - port: 11011
      servicePort: 11012
      serviceProbe:
        timeout: 2s # optional (default value is taken from KUMA_DP_SERVER_HDS_CHECK_TIMEOUT)
        interval: 1s # optional (default value is taken from KUMA_DP_SERVER_HDS_CHECK_INTERVAL)
        healthyThreshold: 1 # optional (default value is taken from KUMA_DP_SERVER_HDS_CHECK_HEALTHY_THRESHOLD)
        unhealthThreshold: 1 # optional (default value is taken from KUMA_DP_SERVER_HDS_CHECK_UNHEALTHY_THRESHOLD)
        tcp: {}
      tags:
        kuma.io/service: backend
        kuma.io/protocol: http
```

If there is a `serviceProbe` configured for the inbound, Kuma will automatically fill the `health` section and update it 
with interval equal to `KUMA_DP_SERVER_HDS_REFRESH_INTERVAL`. Alternatively, it's possible to omit a `serviceProbe` section and develop custom
automation that periodically updates the `health` of the inbound.

Comparing to `HealthCheck` policy `serviceProbes` have some advantages:
- knowledge about health is propagated back to `kuma-cp` and could be seen both in Kuma GUI and Kuma CLI
- scalable with thousands of Dataplanes

but at the same time unlike `HealthCheck` policy `serviceProbes`:
- works only when `kuma-cp` is up and running
- can't check TLS between Envoys
