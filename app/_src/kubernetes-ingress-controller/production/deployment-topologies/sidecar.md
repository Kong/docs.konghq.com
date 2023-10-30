---
title: Sidecar
type: explanation
purpose: |
  What is Sidecar Mode? Why is it deprecated?
---

{:.important}
> Sidecar deployments are officially supported, but discouraged. We recommend using [Gateway Discovery](/kubernetes-ingress-controller/{{ page.release }}/production/deployment-topologies/gateway-discovery/) going forwards.

## Overview

Sidecar deployment is the original method of deployment for {{ site.kic_product_name }}. Both the controller and {{ site.base_gateway }} are deployed in a single Pod and each {{ site.base_gateway }} instance was managed by a different {{ site.kic_product_name }}.

This is the simplest deployment method as everything is contained in a single deployment and the controller can communicate to {{ site.base_gateway }} on `localhost`.

Sidecar deployments have been deprecated in favor of [Gateway Discovery](/kubernetes-ingress-controller/{{ page.release }}/production/deployment-topologies/gateway-discovery/) for multiple reasons:

* Reduce resource usage as the number of {{ site.kic_product_name }} instances does not scale linearly with {{ site.base_gateway }}.
* Reduce load on the Kubernetes API server. There are fewer clients, and no thrashing behaviour as multiple controllers argue of the `programmed` state of a resource.
* Scale {{ site.kic_product_name }} and {{ site.base_gateway }} independently as needed.

![Sidecar Architecture Diagram](/assets/images/products/kubernetes-ingress-controller/topology/sidecar.png)

## Migrating to Gateway Discovery

If you see two containers running in the same Pod, it's likely that you're running {{ site.kic_product_name }} in Sidecar mode.

```text
NAME                         READY   STATUS    RESTARTS   AGE
kong-kong-7f5bddf88c-f5r9h   2/2     Running   0          89s
```

Verify that one of the running containers is `ingress-controller`:

```bash
$ kubectl get pods -n kong kong-kong-7f5bddf88c-wfm6b -o jsonpath='{.spec.containers[*].name}'
```

The result should contain `ingress-controller`:

```text
ingress-controller proxy
```

You can migrate from the Sidecar deployment topology to Gateway Discovery by disabling {{ site.kic_product_name }} in your proxy deployment and creating a new Helm release that contains {{ site.kic_product_name }}.

{:.note}
> The existing proxy pod will continue to handle traffic until the final step of the migration. This leads to minimal downtime.

Update your `values.yaml` file to disable {{ site.kic_product_name }} and make the Admin API accessible:

```yaml
ingressController:
  enabled: false

admin:
  enabled: true
  type: ClusterIP
  clusterIP: None
```

The new Proxy Pod won't come online as there is no available configuration.

```
2023/10/27 15:32:43 [notice] 1257#0: *301 [lua] ready.lua:111: fn(): not ready for proxying: no configuration available (empty configuration present), client: 192.168.194.1, server: kong_status, request: "GET /status/ready HTTP/1.1", host: "192.168.194.9:8100
```

To send a configuration to the Proxy pod, deploy a new instance of {{ site.kic_product_name }} that points to the Admin API service. Create `values-controller.yaml` with the following contents:

```yaml
ingressController:
  enabled: true
  gatewayDiscovery:
    enabled: true
    adminApiService:
      name: kong-kong-admin

deployment:
  kong:
    enabled: false
```

{:.note}
> `kong-kong-admin` is the default name if your release is called `kong`. Run `kubectl get services -n kong` to find the correct name

Create a new `controller` deployment using Helm.

```bash
helm install controller kong/kong --values ./values-controller.yaml -n kong
```

The new Pods do not come online as the controller can't access the Admin API for the original Proxy Pod. Delete the old Proxy Pod to allow Gateway Discovery to work.

{:.important}
> There may be a small amount of downtime of up to three seconds between the Pod being deleted and new proxy pods receiving a configuration.

```bash
kubectl get pods -n kong
```

Find the Pod with two containers. This is the old Sidecar topology that needs to be deleted.

```text
NAME                               READY   STATUS    RESTARTS   AGE
kong-kong-7f5bddf88c-6cnlq         2/2     Running   0          2m
```

Delete the Pod.

```bash
kubectl delete pod -n kong kong-kong-7f5bddf88c-6cnlq
```

At this point there are two Pods running. `controller-kong` contains {{ site.kic_product_name }} and `kong-kong` contains {{ site.base_gateway }}

```text
NAME                               READY   STATUS    RESTARTS        AGE
kong-kong-7554ff7db4-d849p         1/1     Running   0               12m
controller-kong-644fb7f694-zw7sk   1/1     Running   1               12m
```