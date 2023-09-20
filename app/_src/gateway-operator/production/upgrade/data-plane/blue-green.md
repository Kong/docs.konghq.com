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