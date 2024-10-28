---
title: Service and Route
---

In this guide you'll learn how to use the `KongService` and `KongRoute` custom resources to
manage Konnect [Services](/konnect/gateway-manager/configuration/#gateway-services)
and [Routes](/konnect/gateway-manager/configuration/#routes) natively from your Kubernetes cluster.

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=false version=page.version release=page.release
with-control-plane=true %}

## Create a Service

Creating the `KongService` object in your Kubernetes cluster will provision a Konnect Service in
your [Gateway Manager](/konnect/gateway-manager).
You can refer to the CR [API](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongservice)
to see all the available fields.

Your `KongService` must be associated with a `KonnectGatewayControlPlane` object that you've created in your cluster.
It will make it part of the Gateway Control Plane's configuration.

You can create a `KongService` by applying the following YAML manifest:

```yaml
echo '
kind: KongService
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  name: service
  namespace: default
spec:
  name: service
  host: example.com
  controlPlaneRef:
    type: konnectNamespacedRef # This indicates that an in cluster reference is used
    konnectNamespacedRef:
      name: gateway-control-plane # Reference to the KonnectGatewayControlPlane object
  ' | kubectl apply -f -
```

You can verify the `KongService` was reconciled successfully by checking its `Programmed` condition.

```shell
kubectl get kongservice service -o=jsonpath='{.status.conditions}' | jq '.[] | select(.type == "Programmed")'
```

The output should look similar to this:

```console
{
  "observedGeneration": 1,
  "reason": "Programmed",
  "status": "True",
  "type": "Programmed"
}
```

At this point, you should see the Service in the Gateway Manager UI.

## Create a Route

Creating the `KongRoute` object in your Kubernetes cluster will provision a Konnect Route in
your [Gateway Manager](/konnect/gateway-manager).
You can refer to the CR [API](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongroute) to see all the available fields.

Your `KongRoute` can either be associated with a `KongService` (and inherit the relation with a `KonnectGatewayControlPlane` from it)
or be directly associated with a `KonnectGatewayControlPlane` object when referring a `KongService`.

### Associate a Route with a Service

You can create a `KongRoute` associated with a `KongService` by applying the following YAML manifest:

```yaml
echo '
kind: KongRoute
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  name: route-with-service
  namespace: default
spec:
  name: route-with-service
  protocols:
  - http
  hosts:
  - example.com
  serviceRef:
    type: namespacedRef
    namespacedRef:
      name: service # KongService reference
' | kubectl apply -f -
```

You can verify the `KongRoute` was reconciled successfully by checking its `Programmed` condition.

```shell
kubectl get kongroute route-with-service -o=jsonpath='{.status.conditions}' | jq '.[] | select(.type == "Programmed")' 
```

The output should look similar to this:

```console
{
  "observedGeneration": 1,
  "reason": "Programmed",
  "status": "True",
  "type": "Programmed"
}
```

At this point, you should see the Route in the Gateway Manager UI.

### Associate a Route with a Gateway Control Plane

You can also create a `KongRoute` that won't refer any `KongService`. In that case, you must associate it with a 
`KonnectGatewayControlPlane` so that {{site.kgo_product_name}} knows what Gateway Control Plane it should be created in.
You can do so by applying the following YAML manifest:

```yaml
echo '
kind: KongRoute
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  name: route-without-service
  namespace: default
spec:
  name: route-without-service
  protocols:
  - http
  hosts:
  - example.com
  controlPlaneRef:
    type: konnectNamespacedRef
    konnectNamespacedRef:
      name: gateway-control-plane # Reference to the KonnectGatewayControlPlane object
' | kubectl apply -f -
```

You can verify the `KongRoute` was reconciled successfully by checking its `Programmed` condition.

```shell
kubectl get kongroute route-without-service -o=jsonpath='{.status.conditions}' | jq '.[] | select(.type == "Programmed")' 
```

The output should look similar to this:

```console
{
  "observedGeneration": 1,
  "reason": "Programmed",
  "status": "True",
  "type": "Programmed"
}
```

At this point, you should see the Route in the Gateway Manager UI.
