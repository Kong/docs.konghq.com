---
title: Deploying a DataPlane to konnect
---

The Kong `DataPlane` can be configured with half-managed `Hybrid` or `KIC` [`ControlPlane`s](/konnect/gateway-manager/#control-planes). This means that the `ControlPlane` entity referenced (via KonnectID or NamespacedRef) by the `KonnectExtension` object must belong to one of these two categories. It is important to notice, though, that in case the Konnect `ControlPlane` is of type KIC, the Kong `DataPlane` needs a Kubernetes `ControlPlane` (a.k.a. KIC) running in the cluster to be properly configured. In that scenario, the use of a [`Gateway`](/gateway-operator/{{page.release}}/guides/konnect-dataplanes/gateway) is highly recommended.

## Create the KonnectExtension

{% include md/kgo/secret-provisioning-prerequisites.md disable_accordian=false version=page.version release=page.release is-kic-cp=false %}

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
