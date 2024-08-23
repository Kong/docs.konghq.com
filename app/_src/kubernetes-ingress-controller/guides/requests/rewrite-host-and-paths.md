---
title: Rewrite Host and Paths
type: how-to
purpose: |
  Rewrite the host header and paths for incoming requests
---

This guide demonstrates host and path rewrites using Ingress and Service configuration.

{% include /md/kic/prerequisites.md release=page.release disable_gateway_api=false%}

{% include /md/kic/test-service-echo.md release=page.release %}

{% include /md/kic/http-test-routing.md release=include.release path='/echo' name='echo' %}

## Host manipulation

{{ site.kic_product_name }} provides two annotations for manipulating the `Host` header. These annotations allow for three different behaviours:

* Preserve the user-provided `Host` header
* Default to the `Host` of the upstream service
* Explicitly set the `Host` header to a known value

{% capture preserve_host %}
{% navtabs api %}
{% navtab Gateway API %}
```bash
kubectl patch httproute echo --type merge -p '{"metadata":{"annotations":{"konghq.com/preserve-host":"false"}}}'
```
{% endnavtab %}
{% navtab Ingress %}
```bash
kubectl patch ingress echo -p '{"metadata":{"annotations":{"konghq.com/preserve-host":"false"}}}'
``` 
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

### Preserve the Host header

{{ site.kic_product_name }} preserves the hostname in the request by default.

```bash
$ curl -H 'Host:kong.example' "$PROXY_IP/echo?details=true"
```

```text
HTTP request details
---------------------
Protocol: HTTP/1.1
Host: kong.example
Method: GET
URL: /?details=true
```

The `Host` header in the response matches the `Host` header in the request.

### Use the upstream Host name

You can disable `preserve-host` if you want the `Host` header to contain the upstream hostname of your service.

Add the `konghq.com/preserve-host` annotation to your route:

{{ preserve_host }}

The `Host` header in the response now contains the upstream Host and Port.

```text
HTTP request details
---------------------
Protocol: HTTP/1.1
Host: 192.168.194.11:1027
Method: GET
URL: /?details=true
```
### Set the Host header explicitly

{% if_version gte:3.2.0 %}
#### Using Gateway API

You can set the Host header explicitly when using Gateway API's HTTPRoute with [`URLRewrite`](https://gateway-api.sigs.k8s.io/reference/spec/#gateway.networking.k8s.io%2fv1.HTTPURLRewriteFilter) 
filter's `hostname` field. You only need to add a `URLRewrite` filter to your HTTPRoute rule.

```yaml
...
filters:
- type: URLRewrite
  urlRewrite:
    hostname: internal.myapp.example.com
```
{% endif_version %}

#### Using the `konghq.com/host-header` annotation

You can set the Host header explicitly if needed by disabling `konghq.com/preserve-host` and setting the `konghq.com/host-header` annotation.

1. Add the [`konghq.com/preserve-host` annotation][0] to your Ingress, to disable `preserve-host` and send the hostname provided in the `host-header` annotation:
{{ preserve_host | indent }}
1. Add the [`konghq.com/host-header` annotation][1] to your Service, which sets
  the `Host` header directly:
  ```bash
  $ kubectl patch service echo -p '{"metadata":{"annotations":{"konghq.com/host-header":"internal.myapp.example.com"}}}'
  ```

1. Make a `curl` request with a `Host` header:

    ```bash
    curl -H 'Host:kong.example' "$PROXY_IP/echo?details=true"
    ```

    The request upstream now uses the header from the `host-header` annotation:
    ```
    HTTP request details
    ---------------------
    Protocol: HTTP/1.1
    Host: internal.myapp.example.com:1027
    Method: GET
    URL: /?details=true
    ```

## Path manipulation

Users have the following options to rewrite the default path handling behavior:

{% if_version gte:3.2.0 %}* Rewrite using Gateway API's `URLRewrite` filter {% endif_version %}
* Rewrite using regular expressions
* Remove the path prefix using `strip-path`
* Add a path prefix using the `path` annotation

### Rewriting the path

{% navtabs rewrite %}

{% if_version gte:3.2.0 %}
{% navtab Gateway API %}
You can replace the full path for a request by adding the `URLRewrite` filter with `path.replaceFullPath` to your `HTTPRoute`.

```yaml
...
filters:
- type: URLRewrite
  urlRewrite:
    path:
      type: ReplaceFullPath
      replaceFullPath: /rewritten-path
```

Alternatively, you can add the `URLRewrite` filter with `path.replacePrefixMatch` to your `HTTPRoute` rule to rewrite the path prefix.

See the [URLRewrite filter documentation](https://gateway-api.sigs.k8s.io/reference/spec/#gateway.networking.k8s.io%2fv1.HTTPPathModifier)
for more information.

```yaml
...
rules:
  - matches:
      - path:
          type: PathPrefix # Only PathPrefix path type is supported with URLRewrite filter using path.type == ReplacePrefixMatch.
          value: /old-prefix
    filters:
     - type: URLRewrite
       urlRewrite:
         path:
           type: ReplacePrefixMatch
           replacePrefixMatch: /new-prefix
```

{% endnavtab %}
{% endif_version %}
{% navtab Ingress %}

{:.note}
> This feature is available from {{ site.kic_product_name }} 2.12 and requires the [`RewriteURIs` feature gate](/kubernetes-ingress-controller/{{ page.release }}/reference/feature-gates/) to be activated.
> It's only available for Ingress.

Add the [`konghq.com/rewrite` annotation][2] to your Ingress, allows you set a specific path for the upstream request. Any regex matches defined in your route definition are usable (see the [annotation documentation][2] for more information):

```bash
kubectl patch ingress echo --type merge -p '{"metadata":{"annotations":{"konghq.com/rewrite":"/hello/world"}}}'
```
 
The request upstream now contains the value of the rewrite annotation:
```
HTTP request details
---------------------
Protocol: HTTP/1.1
Host: kong.example
Method: GET
URL: /hello/world?details=true
```

[2]: /kubernetes-ingress-controller/{{page.release}}/reference/annotations/#konghqcomrewrite

{% endnavtab %}
{% endnavtabs %}

### Strip the path

{:.note}
> This is the default behavior of {{ site.kic_product_name }}. Set `konghq.com/strip-path="false"` to disable this behavior

Add the [`konghq.com/strip-path` annotation][3] to your Ingress, which strips
the path component of the route/Ingress, leaving the remainder of the path at
the root:

{% navtabs api %}
{% navtab Gateway API %}
```bash
$ kubectl patch httproute echo --type merge -p '{"metadata":{"annotations":{"konghq.com/strip-path":"true"}}}'
```
{% endnavtab %}
{% navtab Ingress %}
```bash
$ kubectl patch ingress echo -p '{"metadata":{"annotations":{"konghq.com/strip-path":"true"}}}'
```
{% endnavtab %}
{% endnavtabs %}

The request upstream now only contains the path components not in the
Ingress rule:
```
HTTP request details
---------------------
Protocol: HTTP/1.1
Host: kong.example
Method: GET
URL: /?details=true
```

### Prepend a path
Add the [`konghq.com/path` annotation][4] to your Service, which prepends
that value to the upstream path:
```bash
$ kubectl patch service echo -p '{"metadata":{"annotations":{"konghq.com/path":"/api"}}}'
```
The request upstream now contains a leading `/api`:
```
HTTP request details
---------------------
Protocol: HTTP/1.1
Host: kong.example
Method: GET
URL: /api?details=true
```

`strip-path` and `path` can be combined together, with the `path` component
coming first. Adding both annotations send requests for `/api/echo`.

[0]: /kubernetes-ingress-controller/{{page.release}}/reference/annotations/#konghqcompreserve-host
[1]: /kubernetes-ingress-controller/{{page.release}}/reference/annotations/#konghqcomhost-header
[3]: /kubernetes-ingress-controller/{{page.release}}/reference/annotations/#konghqcomstrip-path
[4]: /kubernetes-ingress-controller/{{page.release}}/reference/annotations/#konghqcompath
