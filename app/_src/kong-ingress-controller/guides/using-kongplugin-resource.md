---
title: Using Plugin Resources
---

This guide walks you through applying the {{site.kic_product_name}} 
KongPlugin and KongClusterPlugin custom resources other configuration. These
resources change how {{site.base_gateway}} handles proxied requests. This guide
configures plugins that modify headers and enforce authentication requirements.

See the [concept](/kong-ingress-controller/{{page.kong_version}}/concepts/custom-resources/#KongPlugin)
documentation for more information about the purpose of the `KongPlugin` resource.

{% include_cached /md/kic/installation.md kong_version=page.kong_version %}

{% include_cached /md/kic/http-test-service.md kong_version=page.kong_version %}

{% include_cached /md/kic/class.md kong_version=page.kong_version %}

{% include_cached /md/kic/http-test-routing.md kong_version=page.kong_version path='/lemon' name='lemon' %}

Once the first route is working, create a second pointing to the same Service:

{% include_cached /md/kic/http-test-routing-resource.md kong_version=include.kong_version path='/lime' name='lime' %}

## Configuring plugins for routing configuration

{{site.base_gateway}} plugins can apply to a variety of resources. Plugins
apply to different sets of requests depending on what type of resource they are
applied to. Applying a plugin an Ingress or HTTPRoute will modify requests that
match that resource's routing rules.

{:.important}
> The [validating admission webhook](/kong-ingress-controller/{{page.kong_version}}/deployment/admission-webhook/)
> is not installed by this guide, but is recommended for all environments. The
> webhook is required to validate plugin configuration. Not installing the
> webhook can allow invalid plugin configuration, and invalid plugin
> configuration will block configuration updates until fixed.

### Create a plugin

To try this out, first create a KongPlugin resource that adds a response
header:

```bash
echo '
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: add-header-route
config:
  add:
    headers:
    - "x-added-route: demo"
plugin: response-transformer
' | kubectl apply -f -
```
Response:
```text
kongplugin.configuration.konghq.com/add-header-route created
```

### Associate the plugin with routing configuration

After creating the plugin, associate it with other resources by adding a
`konghq.com/plugins` annotation whose value is the KongPlugin's name:

{% navtabs api %}
{% navtab Ingress %}
```bash
kubectl annotate ingress lemon konghq.com/plugins=add-header-route
```
Response:
```text
ingress.networking.k8s.io/lemon annotated
```
{% endnavtab %}
{% navtab Gateway APIs %}
```bash
kubectl annotate httproute lemon konghq.com/plugins=add-header-route
```
Response:
```text
httproute.gateway.networking.k8s.io/lemon annotated
```
{% endnavtab %}
{% endnavtabs %}

### Test the plugin

Requests that match the `lemon` rules will now include the plugin header:

```bash
curl -si http://kong.example/lemon --resolve kong.example:80:$PROXY_IP | grep x-added-route
```
Response:
```text
x-added-route: demo
```

Requests to the `lime` rules will not:

```bash
curl -si http://kong.example/lime --resolve kong.example:80:$PROXY_IP | grep x-added-route | wc -l
```
Response:
```text
0
```

## Configuring plugins on Service resource

Associating a plugin with a Service will apply it to any requests that match a
routing rule that uses that Service as a backend.

### Create a plugin

To try this out, first create a KongPlugin resource that adds a response
header:

```bash
echo '
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: add-header-service
config:
  add:
    headers:
    - "x-added-service: demo"
plugin: response-transformer
' | kubectl apply -f -
```
Response:
```text
kongplugin.configuration.konghq.com/add-header-service created
```

### Associate the plugin with the Service

After creating the second plugin, annotate the Service to apply it:

```bash
kubectl annotate service echo konghq.com/plugins=add-header-service
```
Response:
```text
service/echo annotated
```

### Test the plugin

With the Service plugin in place, send requests through the `lemon` and `lime`
routes:

```bash
curl -si http://kong.example/lemon --resolve kong.example:80:$PROXY_IP | grep x-added-
```
Response:
```text
x-added-route: demo
```

```bash
curl -si http://kong.example/lime --resolve kong.example:80:$PROXY_IP | grep x-added-
```
Response:
```text
x-added-service: demo
```

Although both routes use the `echo` Service, only the `lime` route applies the
`echo` Service's plugin. This is because only one instance of a particular
plugin can execute on a request, determined by a [precedence order](/gateway/latest/admin-api/#precedence).
Route plugins take precedence over service plugins, so the `lemon` route still
uses the header from the first plugin you created.

### Remove a plugin

Removing the plugin annotation will remove plugin(s) from a resource:

{% navtabs api %}
{% navtab Ingress %}
```bash
kubectl annotate ingress lemon konghq.com/plugins-
```
Response:
```text
ingress.networking.k8s.io/lemon annotated
```
{% endnavtab %}
{% navtab Gateway APIs %}
```bash
kubectl annotate httproute lemon konghq.com/plugins-
```
Response:
```text
httproute.gateway.networking.k8s.io/lemon annotated
```
{% endnavtab %}
{% endnavtabs %}

Requests through the `lemon` route now use the Service's plugin:

```bash
curl -si http://kong.example/lemon --resolve kong.example:80:$PROXY_IP | grep x-added-
```
Response:
```text
x-added-service: demo
```

## Configuring global plugins

Global plugins apply to _all_ requests, regardless of which resources they
match. Because this applies across Kubernetes namespaces, global plugins
require a cluster-scoped KongClusterPlugin instead of a namespaced KongPlugin.

{:.note}
> Although not shown in this guide, you can also apply a KongClusterPlugin
> to resources using `konghq.com/plugins` annotations, to reuse plugin
> configurations across namespaces.

### Create a cluster plugin

KongClusterPlugin configuration is largely the same as KongPlugin
configuration, though this resource uses a different plugin and therefore uses
different configuration inside its `config` key:

```bash
echo "
apiVersion: configuration.konghq.com/v1
kind: KongClusterPlugin
metadata:
  name: auth
  annotations:
    kubernetes.io/ingress.class: "kong"
  labels:
    global: 'true'
plugin: key-auth
config:
  key_in_header: true
  key_in_body: false
  key_in_query: false
" | kubectl apply -f -
```
Response:
```text
kongclusterplugin.configuration.konghq.com/auth created
```

The `global='true'` label tells {{site.kic_product_name}} to create a global
plugin. These plugins do not need annotations on other resources for them to
take effect, but they do need [an `ingress.class` annotation](/kong-ingress-controller/{{ page.kong_version }}/concepts/ingress-classes/)
for the controller to recognize them.

{{site.base_gateway}} will now reject requests to any route, because the global
plugin requires authentication for all of them:


```bash
curl -si http://kong.example/lemon --resolve kong.example:80:$PROXY_IP
```
Response:
```text
HTTP/1.1 401 Unauthorized
Date: Fri, 09 Dec 2022 20:10:11 GMT
Content-Type: application/json; charset=utf-8
Connection: keep-alive
WWW-Authenticate: Key realm="kong"
Content-Length: 45
x-added-service:  demo
X-Kong-Response-Latency: 0
Server: kong/3.0.1

{
  "message":"No API key found in request"
}
```

Note that the earlier header plugins are still applied. Plugins that affect
responses can modify both proxied responses and responses generated by
{{site.base_gateway}}.

## Configure a consumer and credential

First, create a credential Secret:

{% include_cached /md/kic/key-auth.md kong_version=page.kong_version credName='kotenok-key-auth' %}

Second, create a KongConsumer resource that uses the Secret:

{% include_cached /md/kic/consumer.md kong_version=page.kong_version credName='kotenok-key-auth' %}

Including this key will now satisfy the authentication requirement enforced by
the global plugin:

```bash
curl -sI http://kong.example/lemon --resolve kong.example:80:$PROXY_IP -H "apikey: gav"
```
Response:
```text
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Content-Length: 9593
Connection: keep-alive
Server: gunicorn/19.9.0
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
x-added-service: demo
X-Kong-Upstream-Latency: 2
X-Kong-Proxy-Latency: 1
Via: kong/3.1.1
```

## Configure a plugins for consumers and multiple resources

Plugins can match requests made by a consumer and match requests that meet
multiple criteria, such as requests made by a consumer for a specific route.

### Create plugins

First, create two additional header KongPlugins:

```bash
echo '
---
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: add-header-consumer
config:
  add:
    headers:
    - "x-added-consumer: demo"
plugin: response-transformer
---
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: add-header-multi
config:
  add:
    headers:
    - "x-added-multi: demo"
plugin: response-transformer
' | kubectl apply -f -
```
Response:
```text
kongplugin.configuration.konghq.com/add-header-consumer created
kongplugin.configuration.konghq.com/add-header-multi created
```

### Associate a plugin with a consumer

Similar to the other resources, consumers can use the `konghq.com/plugins`
annotation to associate a plugin:

```bash
kubectl annotate kongconsumer kotenok konghq.com/plugins=add-header-consumer
```
Response:
```text
kongconsumer.configuration.konghq.com/kotenok annotated
```

Requests made by the `kotenok` consumer will now include this header, since
consumer plugins take precedence over both route and service plugins:

```bash
curl -si http://kong.example/lemon --resolve kong.example:80:$PROXY_IP -H "apikey: gav" | grep x-added
```
Response:
```text
x-added-consumer: demo
```

### Associate a plugin with a consumer and route

Plugins can be associated with more than one resource. Although routing and
Service configuration is implicitly linked (a routing rule cannot proxy to
multiple Services), consumers are not. Assigning plugins to multiple resources
allows a consumer to use different plugin configuration depending on which
route they hit.

First, add the `add-header-multi` plugin to a route:

{% navtabs api %}
{% navtab Ingress %}
```bash
kubectl annotate ingress lemon konghq.com/plugins=add-header-multi
```
Response:
```text
ingress.networking.k8s.io/lemon annotated
```
{% endnavtab %}
{% navtab Gateway APIs %}
```bash
kubectl annotate httproute lemon konghq.com/plugins=add-header-multi
```
Response:
```text
httproute.gateway.networking.k8s.io/lemon annotated
```
{% endnavtab %}
{% endnavtabs %}

Then, update the consumer configuration to include both plugins:

```bash
kubectl annotate kongconsumer kotenok konghq.com/plugins=add-header-consumer,add-header-multi --overwrite
```
Response:
```text
kongconsumer.configuration.konghq.com/kotenok annotated
```

The header returned now depend on which route the consumer uses:

```bash
echo "lemon\!"; curl -si http://kong.example/lemon --resolve kong.example:80:$PROXY_IP -H "apikey: gav" | grep x-added
echo "lime\!"; curl -si http://kong.example/lime --resolve kong.example:80:$PROXY_IP -H "apikey: gav" | grep x-added
```
Response:
```text
lemon!
x-added-multi: demo
lime!
x-added-consumer: demo
```

Sending a request to the `lemon` route without the consumer credentials will
_not_ activate the multi-resource plugin, and will instead fall back to the
Service plugin. When plugins are associated with multiple resources, requests
must match _all_ of them:

```bash
curl -si http://kong.example/lemon --resolve kong.example:80:$PROXY_IP | grep x-added 
```
Response:
```text
x-added-service:  demo
```

More specific plugins (for example, a route and consumer, versus just a
consumer or just a route) always take precedence over less specific plugins.

## Next steps

There's a lot more you can do with Kong plugins. Check the [Plugin Hub](/hub/) to see all of the available plugins and how to use them.

Next, you might want to learn more about Ingress with the 
[KongIngress resource guide](/kong-ingress-controller/{{page.kong_version}}/guides/using-kongingress-resource/).
