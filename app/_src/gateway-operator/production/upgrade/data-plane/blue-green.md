---
title: Blue/Green Upgrades
---

Blue/Green upgrades can be accomplished when working with the `DataPlane` resource directly. To enable blue/green deployments st the `deployment.rollout.strategy` on your `DataPlane` resource:

```yaml
apiVersion: gateway-operator.konghq.com/v1beta1
kind: DataPlane
metadata:
  name: bluegreen
spec:
  deployment:
    rollout:
      strategy:
        blueGreen:
          promotion:
            strategy: BreakBeforePromotion
    podTemplateSpec:
      spec:
        containers:
        - name: proxy
          image: kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}
          env:
          - name: KONG_LOG_LEVEL
            value: debug
          readinessProbe:
            initialDelaySeconds: 1
            periodSeconds: 1
```

{{ site.kgo_product_name }} will deploy a new `ReplicaSet` that you can validate before switching any traffic to the new pods.

Once you've validated the pods, run `kubectl annotate dataplanes.gateway-operator.konghq.com <dataplane_name> gateway-operator.konghq.com/promote-when-ready=true` to allow {{ site.kgo_product_name }} to switch the traffic to the new pods.

This annotation will automatically be cleared by {{ site.kgo_product_name }} once the new pods are promoted to be live.