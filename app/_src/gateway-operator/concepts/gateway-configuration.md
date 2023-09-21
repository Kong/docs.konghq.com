---
title: Gateway Configuration
---

{{ site.kgo_product_name }} provides a `GatewayConfiguration` CRD that allows you to customise the deployment of both `ControlPlane` and `DataPlane` resources.

These customizations are primarily used to set the container image to be used and any environment variables required by the containers.

Here is an example of the `GatewayConfiguration` that provides an enterprise license for {{ site.base_gateway }}.

```yaml
kind: GatewayConfiguration
apiVersion: gateway-operator.konghq.com/v1alpha1
metadata:
  name: kong
  namespace: <your-namespace>
spec:
  dataPlaneDeploymentOptions:
    containerImage: kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}
    env:
    - name: KONG_LICENSE_DATA
      valueFrom:
        secretKeyRef:
          key: license
          name: kong-enterprise-license
```

For more information about `GatewayConfiguration` see the [GatewayConfiguration CRD reference](/gateway-operator/{{ page.release }}/reference/custom-resources#gatewayconfiguration)
