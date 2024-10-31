---
title: Vault
---

In this guide you'll learn how to use the `KongVault` custom resource to manage
{{site.konnect_product_name}} [Vault](/konnect/gateway-manager/configuration/#vaults) natively from your Kubernetes cluster.

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=false version=page.version release=page.release
with-control-plane=true %}

## Create a vault

Creating the `KongVault` object in your Kubernetes cluster will provision a {{site.konnect_product_name}} Vault in
your [Gateway Manager](/konnect/gateway-manager). You can refer to the CR [API](/gateway-operator/{{ page.release
}}/reference/custom-resources/#kongvault) to see all the available fields.

Your `KongVault` must be associated with a `KonnectGatewayControlPlane` object that you've created in your cluster.
It will make it part of the Gateway control plane's configuration.

To create a `KongVault`, you can apply the following YAML manifest:

```yaml
echo '
kind: KongVault
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  name: env-vault
spec:
  backend: env
  prefix: env-vault
  config:
    prefix: env-vault
  controlPlaneRef:
    type: konnectNamespacedRef # This indicates that an in cluster reference is used
    konnectNamespacedRef:
      name: gateway-control-plane # Reference to the KonnectGatewayControlPlane object
      namespace: default # KongVault is cluster scoped, so we need to specify namespace of the Konnect Control Plane
  ' | kubectl apply -f -
```

{% include md/kgo/check-condition.md name='env-vault' kind='KongVault' %}
