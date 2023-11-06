---
title: Proxy HTTP requests
type: how-to
purpose: |
  How to proxy HTTP requests
---

Create HTTP routing configuration for {{site.base_gateway}} in Kubernetes using either the `HTTPRoute` Gateway API resource or `Ingress` resource.

{% include /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=false %}

{% include /md/kic/test-service-echo.md kong_version=page.kong_version %}

{% include /md/kic/http-test-routing.md kong_version=page.kong_version path='/echo' name='echo' service='echo' port='1027' skip_host=true %}