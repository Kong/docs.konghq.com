---
title: Using Plugin Resources
---

Learn to apply the {{site.kic_product_name}} 
`KongPlugin` and `KongClusterPlugin` custom resources to other configurations. These
resources change how {{site.base_gateway}} handles proxied requests. You can 
configures plugins to modify headers and enforce authentication requirements.

See the [concept](/kubernetes-ingress-controller/{{page.kong_version}}/concepts/custom-resources/#KongPlugin)
documentation for more information about the purpose of the `KongPlugin` resource.

{% include_cached /md/kic/installation.md kong_version=page.kong_version %}

{% include_cached /md/kic/test-service-echo.md kong_version=page.kong_version %}

{% include_cached /md/kic/class.md kong_version=page.kong_version %}

{% include_cached /md/kic/http-test-routing.md kong_version=page.kong_version path='/lemon' name='lemon' %}

After you test the routing configuration to proxy `/lemon`, create a second routing configuration to proxy `/lime` that points to the same Service:

{% include_cached /md/kic/http-test-routing-resource.md kong_version=include.kong_version path='/lime' name='lime' %}

## Configuring plugins for routing configuration

{{site.base_gateway}} plugins can apply to a variety of resources. Plugins
apply to different sets of requests depending on what type of resource they are
applied to. Applying a plugin an Ingress or HTTPRoute modifies requests that
match that resource's routing rules.

{:.important}
> The [validating admission webhook](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/admission-webhook/)
> is not installed by this guide, but is recommended for all environments. The
> webhook is required to validate plugin configuration. Not installing the
> webhook can allow invalid plugin configuration, and invalid plugin
> configuration will block configuration updates until fixed.

1. Create a KongPlugin resource `add-header-route` that adds a response header `x-added-route: demo`.

    ```bash
    echo '
    apiVersion: configuration.konghq.com/v1
    kind: KongPlugin
    metadata:
      name: add-header-route
      annotations:
        kubernetes.io/ingress.class: kong
    config:
      add:
        headers:
        - "x-added-route: demo"
    plugin: response-transformer
    ' | kubectl apply -f -
    ```
    The results should look like this:
    ```text
    kongplugin.configuration.konghq.com/add-header-route created
    ```
1. Associate the plugin with routing configuration by adding a
`konghq.com/plugins` annotation whose value is the name of the KongPlugin.
   {% capture the_code %}
{% navtabs codeblock %}
{% navtab Ingress %}
```bash
kubectl annotate ingress lemon konghq.com/plugins=add-header-route
```
{% endnavtab %}
{% navtab Gateway API %}
```bash
kubectl annotate httproute lemon konghq.com/plugins=add-header-route
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

    The results should look like this:

    {% capture the_code %}
{% navtabs codeblock %}
{% navtab Ingress %}
```text
ingress.networking.k8s.io/lemon annotated
```
{% endnavtab %}
{% navtab Gateway API %}
```text
httproute.gateway.networking.k8s.io/lemon annotated
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}
     
1. Test the plugin by sending requests to the routes. 

    * Requests that match the `lemon` rules now includes the plugin header:

       ```bash
       curl -si http://kong.example/lemon --resolve kong.example:80:$PROXY_IP | grep x-added-route
       ```
       The results should look like this:
       ```text
       x-added-route: demo
       ```

     * Requests to the `lime` rules does not include the plugin header:

       ```bash
        curl -si http://kong.example/lime --resolve kong.example:80:$PROXY_IP | grep x-added-route | wc -l
        ```
        The results should look like this:
        ```text
        0
        ```

## Configuring plugins on Service resource

Associating a plugin with a Service applies it to any requests that match a
routing rule that uses that Service as a backend.

1. Create a KongPlugin resource `add-header-service` that adds a response header `x-added-service: demo`.

    ```bash
    echo '
    apiVersion: configuration.konghq.com/v1
    kind: KongPlugin
    metadata:
      name: add-header-service
      annotations:
        kubernetes.io/ingress.class: kong
    config:
      add:
        headers:
        - "x-added-service: demo"
    plugin: response-transformer
    ' | kubectl apply -f -
    ```
    The results should look like this:
    ```text
    kongplugin.configuration.konghq.com/add-header-service created
    ```
    
1. Associate the plugin with the Service.

    ```bash
    kubectl annotate service echo konghq.com/plugins=add-header-service
    ```
    The results should look like this:
    ```text
    service/echo annotated
    ```
1. Test the plugin by sending requests to the routes. 

    * Requests to the `lemon` route includes the header from the first plugin:

       ```bash
       curl -si http://kong.example/lemon --resolve kong.example:80:$PROXY_IP | grep x-added-
       ```
       The results should look like this:
       ```text
       x-added-route: demo
       ```

     * Requests to the `lime` route includes the header from the second plugin:

       ```bash
        curl -si http://kong.example/lime --resolve kong.example:80:$PROXY_IP | grep x-added-
        ```
        The results should look like this:
        ```text
        x-added-service: demo
        ```
    
    Although both routes use the `echo` Service, only the `lime` route applies the `echo` Service's plugin. This is because only one instance of a particular plugin can execute on a request, determined by a [precedence order](/gateway/latest/admin-api/#precedence). Route plugins take precedence over service plugins, so the `lemon` route still
    uses the header from the plugin that you created first.
    
1. Remove the plugin annotation to remove plugin(s) from a resource.
   {% capture the_code %}
{% navtabs codeblock %}
{% navtab Ingress %}
```bash
kubectl annotate ingress lemon konghq.com/plugins-
```
{% endnavtab %}
{% navtab Gateway API %}
```bash
kubectl annotate httproute lemon konghq.com/plugins-
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

    The results should look like this:

    {% capture the_code %}
{% navtabs codeblock %}
{% navtab Ingress %}
```text
ingress.networking.k8s.io/lemon annotated
```
{% endnavtab %}
{% navtab Gateway API %}
```text
httproute.gateway.networking.k8s.io/lemon annotated
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

1. Verify that the plugin is removed by sending requests through the `lemon` route. It now use the Service's plugin.

    ```bash
    curl -si http://kong.example/lemon --resolve kong.example:80:$PROXY_IP | grep x-added-
    ```
    The results should look like this:
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

1. Create a cluster plugin. KongClusterPlugin configuration is largely the same as KongPlugin configuration, though this resource uses a different plugin and therefore uses different configuration inside its `config` key.

    ```bash
    echo "
    apiVersion: configuration.konghq.com/v1
    kind: KongClusterPlugin
    metadata:
      name: auth
      annotations:
        kubernetes.io/ingress.class: kong
      labels:
        global: 'true'
    plugin: key-auth
    config:
      key_in_header: true
      key_in_body: false
      key_in_query: false
    " | kubectl apply -f -
    ```
    The results should look like this:
    ```text
    kongclusterplugin.configuration.konghq.com/auth created
    ```

    The `global='true'` label tells {{site.kic_product_name}} to create a global plugin. These plugins do not need annotations on other resources for them to take effect, but they do need [an `ingress.class` annotation](/kubernetes-ingress-controller/{{ page.kong_version }}/concepts/ingress-classes/) for the controller to recognize them.

1. Send requests to any route. {{site.base_gateway}} now rejects requests, because the global plugin requires authentication for all of them.


    ```bash
    curl -si http://kong.example/lemon --resolve kong.example:80:$PROXY_IP
    ```
    The results should look like this:
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
    Note that the earlier header plugins are still applied. Plugins that affect responses can modify both proxied responses and responses generated by {{site.base_gateway}}.

1. Configure a credential Secret.

{% include_cached /md/kic/key-auth.md kong_version=page.kong_version credName='consumer-1-key-auth' key='consumer-1' %}

1. Configure a KongConsumer resource that uses the Secret.

{% include_cached /md/kic/consumer.md kong_version=page.kong_version name='consumer-1' credName='consumer-1-key-auth' %}

1. Test the global plugin by including the key that now satisfies the authentication requirement enforced by the global plugin.

    ```bash
    curl -sI http://kong.example/lemon --resolve kong.example:80:$PROXY_IP -H 'apikey: consumer-1'
    ```
    The results should look like this:
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

1. Create a two KongPlugin resources `add-header-consumer` and  `add-header-multi` that adds a response header `x-added-consumer: demo` and `x-added-multi: demo` respectively.

    ```bash
   echo '
   ---
   apiVersion: configuration.konghq.com/v1
   kind: KongPlugin
   metadata:
    name: add-header-consumer
    annotations:
        kubernetes.io/ingress.class: kong
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
    annotations:
       kubernetes.io/ingress.class: kong
   config:
    add:
      headers:
      - "x-added-multi: demo"
   plugin: response-transformer
   ' | kubectl apply -f -
    ```
    ```
    The results should look like this:
    ```text
    kongplugin.configuration.konghq.com/add-header-consumer created
    kongplugin.configuration.konghq.com/add-header-multi created
    ```
1. Associate a plugin with a consumer. Similar to the other resources, consumers can use the `konghq.com/plugins` annotation to associate a plugin.

    ```bash
    kubectl annotate kongconsumer consumer-1 konghq.com/plugins=add-header-consumer
    ```
    The results should look like this:
    ```text
    kongconsumer.configuration.konghq.com/consumer-1 annotated
    ```
1. Verify by sending requests as `consumer-1`. The response now includes the `x-added-consumer: demo` header, because consumer plugins take precedence over both route and service plugins.

    ```bash
    curl -si http://kong.example/lemon --resolve kong.example:80:$PROXY_IP -H 'apikey: consumer-1' | grep x-added
    ```
    The results should look like this:
    ```text
    x-added-consumer: demo
    ```
    
### Associate a plugin with a consumer and route

Plugins can be associated with more than one resource. Although routing and
Service configuration is implicitly linked (a routing rule cannot proxy to
multiple Services), consumers are not. Assigning plugins to multiple resources
allows a consumer to use different plugin configuration depending on which
route they hit. 

1. Add the `add-header-multi` plugin to a route.

   {% capture the_code %}
{% navtabs codeblock %}
{% navtab Ingress %}
```bash
kubectl annotate ingress lemon konghq.com/plugins=add-header-multi
```
{% endnavtab %}
{% navtab Gateway API %}
```bash
kubectl annotate httproute lemon konghq.com/plugins=add-header-multi
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

    The results should look like this:

    {% capture the_code %}
{% navtabs codeblock %}
{% navtab Ingress %}
```text
ingress.networking.k8s.io/lemon annotated
```
{% endnavtab %}
{% navtab Gateway API %}
```text
httproute.gateway.networking.k8s.io/lemon annotated
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}


1. Update the consumer configuration to include both plugins.

    ```bash
    kubectl annotate kongconsumer consumer-1 konghq.com/plugins=add-header-consumer,add-header-multi --overwrite
    ```
    The results should look like this:
    ```text
    kongconsumer.configuration.konghq.com/consumer-1 annotated
    ```
1.  Send requests with the consumer credentials. The header returned now depend on which route the consumer uses.

    ```bash
    echo "lemon\!"; curl -si http://kong.example/lemon --resolve kong.example:80:$PROXY_IP -H 'apikey: consumer-1' | grep x-added
    echo "lime\!"; curl -si http://kong.example/lime --resolve kong.example:80:$PROXY_IP -H 'apikey: consumer-1' | grep x-added
    ```
    The results should look like this:
    ```text
    lemon!
    x-added-multi: demo
    lime!
    x-added-consumer: demo
    ```
1.  Send a request to the `lemon` route without the consumer credentials and it does _not_ activate the multi-resource plugin, and instead falls back to the Service plugin. When plugins are associated with multiple resources, requests must match _all_ of them.

    ```bash
    curl -si http://kong.example/lemon --resolve kong.example:80:$PROXY_IP | grep x-added
    ```
    The results should look like this:
    ```text
    x-added-service:  demo
    ```

    More specific plugins (for example, a route and consumer, versus just a consumer or just a route) always take precedence over less specific plugins.

{% if_version gte:2.11.x %}

### Associate a plugin with multiple consumers using a consumer group

{:.badge .enterprise}

{:.note}
> This feature requires {{site.ee_product_name}} 3.4 or higher.
> It is not compatible with the older consumer groups implementation introduced
> in {{site.ee_product_name}} 2.7.

[Consumer groups](/gateway/latest/kong-enterprise/consumer-groups/) allow you
to group like consumers together and apply the same plugin configuration to
them without annotating the consumers individually.

1. Create an additional plugin.

    ```bash
    echo '
    ---
    apiVersion: configuration.konghq.com/v1
    kind: KongPlugin
    metadata:
      name: add-header-group-golden
      annotations:
        kubernetes.io/ingress.class: kong
    config:
      add:
        headers:
       - "x-added-consumer-group: demo"
    plugin: response-transformer-advanced
    ' | kubectl apply -f -
    ```
    The results should look like this:
    ```text
    kongplugin.configuration.konghq.com/add-header-group-golden created
    ```
1. Create a KongConsumerGroup resource with that plugin applied.

    ```bash
    echo '
    ---
    apiVersion: configuration.konghq.com/v1beta1
    kind: KongConsumerGroup
    metadata:
      name: golden
      annotations:
        kubernetes.io/ingress.class: kong
        konghq.com/plugins: add-header-group-golden
    ' | kubectl apply -f -
    ```
    The results should look like this:
    ```text
     kongconsumergroup.configuration.konghq.com/golden created
    ```
1. Create a second credential and KongConsumer.

{% include_cached /md/kic/key-auth.md kong_version=page.kong_version credName='consumer-2-key-auth' key='consumer-2' %}

{% include_cached /md/kic/consumer.md kong_version=page.kong_version name='consumer-2' credName='consumer-2-key-auth' %}

1.  Add both consumers to this group by adding a `consumerGroups` array to their KongConsumers.

    ```bash
     kubectl patch --type json kongconsumer consumer-1 -p='[{
        "op":"add",
    	"path":"/consumerGroups",
    	"value":["golden"],
    }]'

    kubectl patch --type json kongconsumer consumer-2 -p='[{
        "op":"add",
    	"path":"/consumerGroups",
    	"value":["golden"],
    }]'
    ```
    The results should look like this:
    ```text
    kongconsumer.configuration.konghq.com/consumer-1 patched
    kongconsumer.configuration.konghq.com/consumer-2 patched
     ```
1. Send requests as the `consumer-1` consumer to the `lime` route.

    ```bash
    curl -si http://kong.example/lime --resolve kong.example:80:$PROXY_IP -H 'apikey: consumer-1' | grep x-added
    ```

    The results should look like this:
    ```text
    x-added-consumer-group: demo
    x-added-consumer: demo
    ```
1. Send requests from `consumer-2` consumer to the `lime` route.
    ```bash
    curl -si http://kong.example/lime --resolve kong.example:80:$PROXY_IP -H 'apikey: consumer-2' | grep x-added
    ```
    
    The results should look like this:
    ```text
    x-added-consumer-group:  demo
    x-added-service:  demo
    ```
1. Delete the consumer-level annotation to let the group-level configuration take effect.

    ```bash
    kubectl annotate kongconsumer consumer-1 konghq.com/plugins-
    curl -si http://kong.example/lime --resolve kong.example:80:$PROXY_IP -H 'apikey: consumer-1' | grep x-added
    ```

    The results should look like this:
    ```text
    kongconsumer.configuration.konghq.com/consumer-1 annotated
    x-added-consumer-group:  demo
    x-added-service:  demo
    ```

    {% endif_version %}

## Next steps

There's a lot more you can do with Kong plugins. Check the [Plugin Hub](/hub/) to see all of the available plugins and how to use them.

Next, you might want to learn more about Ingress with the
[KongIngress resource guide](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-kongingress-resource/).
