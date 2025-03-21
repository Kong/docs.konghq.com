---
title: Deploying a DataPlane to Konnect
---

The Kong `DataPlane` can be configured with half-managed `Hybrid` or `KIC` [`ControlPlane`s](/konnect/gateway-manager/#control-planes). This means that the `controlPlane` entity referenced (via KonnectID or NamespacedRef) by the `KonnectExtension` object must belong to one of these two categories. It is important to notice, though, that in case the Konnect `ControlPlane` is of type KIC, the Kong `DataPlane` needs a Kubernetes `ControlPlane` (a.k.a. KIC) running in the cluster to be properly configured. In that scenario, the use of a [`Gateway`](/gateway-operator/{{page.release}}/guides/konnect-dataplanes/gateway) is highly recommended.

## Create the KonnectExtension

{% include md/kgo/secret-provisioning-prerequisites.md disable_accordian=false version=page.version release=page.release is-kic-cp=false %}

## Create the DataPlane

Configure a Kong `DataPlane` by using your `KonnectExtension` reference.

```bash
echo '
apiVersion: gateway-operator.konghq.com/v1beta1
kind: DataPlane
metadata:
  name: dataplane-example
spec:
  extensions:
  - kind: KonnectExtension
    name: my-konnect-config
    group: konnect.konghq.com
  deployment:
    podTemplateSpec:
      spec:
        containers:
        - name: proxy
          image: kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}
' | kubectl apply -f -
```
