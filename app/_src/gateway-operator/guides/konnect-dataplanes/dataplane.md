---
title: Deploying a DataPlane to konnect
---

The Kong `DataPlane` can be configured with half-managed `Hybrid` or `KIC` [`ControlPlane`s](/konnect/gateway-manager/#control-planes). This means that the `ControlPlane` entity referenced (via KonnectID or NamespacedRef) by the `KonnectExtension` object must belong to one of these two categories. It is important to notice, though, that in case the Konnect `ControlPlane` is of type KIC, the Kong `DataPlane` needs a Kubernetes `ControlPlane` (a.k.a. KIC) running in the cluster be be properly configured. In that scenario, the use of a [`Gateway`](/gateway-operator/{{page.release}}/guides/konnect-dataplanes/gateway) is highly recommended.

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=false version=page.version release=page.release
with-control-plane=true %}

## Create the KonnectExtension

The command below can be used to configure a `DataPlane` in an hybrid `ControlPlane` referenced via `NamespacedRef`, with automatic secret provisioning and one `DataPlane` label. You can find all the `KonnectExtension` available options and knobs in the [overview page](/gateway-operator/{{page.release}}/guides/konnect-dataplanes/overview).

```sh
echo '
kind: KonnectExtension
apiVersion: konnect.konghq.com/v1alpha1
metadata:
  name: my-konnect-config
  namespace: default
spec:
  konnect:
    controlPlane:
      ref:
        type: konnectID
        konnectID: a6554c4c-79a6-4db7-b7a4-201c0cf746ba
    dataPlane:
      labels:
        nickname: lovely-dataplane
  clientAuth:
    certificateSecret:
      provisioning: Manual
      secretRef:
        name: konnect-client-tls' | kubectl apply -f -
```

## Create the DataPlane

Configure a Kong `DataPlane` by using the `KonnectExtension` created in the step above.

```sh
echo '
apiVersion: gateway-operator.konghq.com/v1beta1
kind: DataPlane
metadata:
  name: my-dataplane
  labels:
    nickname: lovely-dataplane
spec:
  extensions:
  - kind: KonnectExtension
    name: my-konnect-config
    group: konnect.konghq.com
```

## Deploy Konnect entities

Now you are ready to leverage the [Konnect entities](/gateway-operator/{{page.release}}/guides/konnect-entities/service-and-route) to configure your Kong `DataPlane` in Konnect.
