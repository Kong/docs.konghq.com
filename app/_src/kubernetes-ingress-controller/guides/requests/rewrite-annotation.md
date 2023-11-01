---
title: Rewrite Annotation
type: explanation
purpose: |
  What is the rewrite annotation and how does it work?
---

{{ site.kic_product_name }} provides the `konghq.com/rewrite` annotation to customize the request path before it is sent to the upstream service.

The annotation can be used on `Ingress` and `HTTPRoute` resources, and configures a [request-transformer](/hub/kong-inc/request-transformer/) plugin within Kong when added to a route.

This definition creates a route that matches the path `/users/(\w+)` and rewrites it to `/requests/users_svc/$1` before sending the request upstream.

{% include /md/kic/http-test-routing-resource.md kong_version=page.kong_version path='/users/(\w+)' name='user' service='users' port='80' skip_host=true route_type='RegularExpression' no_results=true annotation_rewrite="/requests/users_svc/$1" %}

Alternatively, you can define this in a plugin configuration.

```yaml
plugins:
- name: request-transformer
  service: SERVICE_NAME|ID
  config:
    replace:
      uri: "/requests/users_svc/$(uri_captures[1])"
```

The `$1` in the annotation is expanded to `$(uri_captures[1])` in the plugin configuration.

Up to nine capture groups are supported using the `konghq.com/rewrite` annotation. If you need more than 9 capture groups, [create a KongPlugin resource](/hub/kong-inc/request-transformer/how-to/basic-example/?tab=kubernetes) to handle the transformation.
