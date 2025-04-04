---
title: Deploy a Data Plane
content-type: tutorial
book: kgo-konnect-get-started
chapter: 3
---

In order to bind a Kong `DataPlane` to a Konnect `ControlPlane`, you can use the `KonnectExtension` (CRD reference can be found [here][kext_crd]).

[kext_crd]: /gateway-operator/{{page.release}}/reference/custom-resources/#konnectextension-1

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
