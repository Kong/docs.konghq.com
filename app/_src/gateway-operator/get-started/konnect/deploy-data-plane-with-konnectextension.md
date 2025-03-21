---
title: Deploy a Data Plane
content-type: tutorial
book: kgo-konnect-get-started
chapter: 2
---

In order to bind a Kong `DataPlane` to a Konnect `ControlPlane`, you can use the `KonnectExtension` (CRD reference can be found [here][kext_crd]).

You can learn more about how to use the `KonnectExtension` object in [this guide][konnectextension_overview].

[kext_crd]: /gateway-operator/{{page.release}}/reference/custom-resources/#konnectextension-1
[konnectextension_overview]: /gateway-operator/{{page.release}}/guides/konnect-dataplanes/overview

## Binding the DataPlane to a Konnect ControlPlane

The Kong `DataPlane` can be configured with half-managed `Hybrid` or `KIC` [`ControlPlane`s](/konnect/gateway-manager/#control-planes). This means that the `controlPlane` entity referenced (via KonnectID or NamespacedRef) by the `KonnectExtension` object must belong to one of these two categories. It is important to notice, though, that in case the Konnect `ControlPlane` is of type KIC, the Kong `DataPlane` needs a Kubernetes `ControlPlane` (see the [`ControlPlane` CRD ref][controlplane_crd]) running in the cluster to be properly configured. In that scenario, the use of a [`Gateway`](/gateway-operator/{{page.release}}/guides/konnect-dataplanes/gateway) is highly recommended.

[controlplane_crd]: /gateway-operator/{{page.release}}/reference/custom-resources/#controlplane

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
