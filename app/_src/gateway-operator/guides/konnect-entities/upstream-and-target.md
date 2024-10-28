---
title: Upstream and Target 
---

In this guide you'll learn how to use the `KongUpstream` and `KongTarget` custom resources to
manage Konnect [Upstream](/konnect/gateway-manager/configuration/#upstreams)
and their Targets natively from your Kubernetes cluster.

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=false version=page.version release=page.release
with-control-plane=true %}

## Create an Upstream

Creating the `KongUpstream` object in your Kubernetes cluster will provision a Konnect Key in
your [Gateway Manager](/konnect/gateway-manager).
You can refer to the CR [API](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongupstream)
to see all the available fields.

Your `KongUpstream` must be associated with a `KonnectGatewayControlPlane` object that you've created in your cluster.
It will make it part of the Gateway Control Plane's configuration.

To create a `KongUpstream`, you can apply the following YAML manifest:

```yaml
echo '
kind: KongUpstream
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  name: upstream
  namespace: default
spec:
  name: upstream
  controlPlaneRef:
    type: konnectNamespacedRef # This indicates that an in cluster reference is used
    konnectNamespacedRef:
      name: gateway-control-plane # KonnectGatewayControlPlane reference
  ' | kubectl apply -f -
```

You can verify the `KongUpstream` was reconciled successfully by checking its `Programmed` condition.

```shell
kubectl get kongkey key -o=jsonpath='{.status.conditions}' | jq '.[] | select(.type == "Programmed")' 
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

At this point, you should see the Upstream in the Gateway Manager UI.

## Create a Target

Each `KongTarget` must be associated with a `KongUpstream` it's meant to be a backend for. For this reason, you must
specify the `upstreamRef` field in the `spec` section of the `KongTarget` object. Please refer to the CR [API](
/gateway-operator/{{ page.release }}/reference/custom-resources/#kongtarget)
to see all the available fields.

To create two different `KongTarget`s associated with the `KongUpstream` created before, you can apply the following
YAML manifest:

```yaml
echo '
kind: KongTarget
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  name: target-a
  namespace: default
spec:
  upstreamRef:
    name: upstream # Reference to the KongUpstream object
  target: "10.0.0.1"
  weight: 30
---
kind: KongTarget
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  name: target-b
  namespace: default
spec:
  upstreamRef:
    name: upstream # Reference to the KongUpstream object
  target: "10.0.0.2"
  weight: 70
  ' | kubectl apply -f - 
```

You can verify both `KongTarget`s successfully were associated with the `KongUpstream` by checking their
`KongUpstreamRefValid` condition.

```shell
kubectl get kongtarget target-a -o=jsonpath='{.status.conditions}' | jq '.[] | select(.type == "KongUpstreamRefValid")'
kubectl get kongtarget target-b -o=jsonpath='{.status.conditions}' | jq '.[] | select(.type == "KongUpstreamRefValid")'
```

The output should look similar to this:

```console
{
  "observedGeneration": 1,
  "reason": "Valid",
  "status": "True",
  "type": "KongUpstreamRefValid"
}
{
  "observedGeneration": 1,
  "reason": "Valid",
  "status": "True",
  "type": "KongUpstreamRefValid"
}
```

You can also verify both `KongTarget`s were reconciled successfully by checking their `Programmed` condition.

```shell
kubectl get kongtarget target-a -o=jsonpath='{.status.conditions}' | jq '.[] | select(.type == "Programmed")'
kubectl get kongtarget target-b -o=jsonpath='{.status.conditions}' | jq '.[] | select(.type == "Programmed")'
```

The output should look similar to this:

```console
{
  "observedGeneration": 1,
  "reason": "Programmed",
  "status": "True",
  "type": "Programmed"
}
{
  "observedGeneration": 1,
  "reason": "Programmed",
  "status": "True",
  "type": "Programmed"
}
```

At this point, you should see both Targets in the `upstream` Upstream in the Gateway Manager UI.
