---
title: Create a Route
content-type: tutorial
book: kgo-kic-get-started
chapter: 3
alpha: true
---



```bash
kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/echo-service.yaml
```

Create HTTPRoute

```yaml
kind: HTTPRoute
apiVersion: gateway.networking.k8s.io/v1beta1
metadata:
  name: echo
spec:
  parentRefs:
    - group: gateway.networking.k8s.io
      kind: Gateway
      name: kong
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /echo
      backendRefs:
        - name: echo
          port: 1027
```