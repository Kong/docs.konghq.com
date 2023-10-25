---
title: Proxy HTTP requests
type: how-to
purpose: |
  How to proxy HTTP requests
---

Create HTTP routing configuration for {{site.base_gateway}} in Kubernetes using either the `HTTPRoute` Gateway API resource or `Ingress` resource.

{% include_cached /md/kic/prerequisites.md kong_version=page.kong_version gateway_api_experimental=true %}

## Install echo service

Install an example echo service:

```bash
kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/echo-service.yaml
```
The results should look like this:
```text
service/echo created
deployment.apps/echo created
```

{% include_cached /md/kic/http-test-routing.md kong_version=page.kong_version path='/echo' name='echo' service='echo' port='1027' skip_host=true %}