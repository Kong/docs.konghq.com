---
title: Provisioning Consumers and Credentials
content_type: tutorial
---

Learn how to use the KongConsumer custom resource and use Secret resources to associate credentials with those consumers.

{% include_cached /md/kic/installation.md kong_version=page.kong_version %}

{% include_cached /md/kic/test-service-echo.md kong_version=page.kong_version %}

{% include_cached /md/kic/class.md kong_version=page.kong_version %}

{% include_cached /md/kic/http-test-routing.md kong_version=page.kong_version %}

## Add authentication to the service

With Kong, adding authentication for an API is as simple as
enabling a plugin.

1. To enforce authentication requirements on the route you've created, create a KongPlugin resource with an authentication plugin, such as `key-auth`:

{% capture the_code %}
```bash
echo "
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: example-auth
plugin: key-auth
" | kubectl apply -f -
```
{% endcapture %}
{{ the_code | indent }}

    The results should look like this:
    ```text
    kongplugin.configuration.konghq.com/example-auth created
    ```

1. Associate this plugin with the Ingress rule that you created
using the `konghq.com/plugins` annotation:

{% capture the_code %}
{% navtabs codeblock %}
{% navtab Ingress %}
```bash
kubectl annotate ingress echo konghq.com/plugins=example-auth
```
{% endnavtab %}
{% navtab Gateway API %}
```bash
kubectl annotate httproute echo konghq.com/plugins=example-auth
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
ingress.networking.k8s.io/echo annotated
```
{% endnavtab %}
{% navtab Gateway API %}
```text
httproute.gateway.networking.k8s.io/echo annotated
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

1. Test the routing configuration by sending a request that matches the proxying rules defined in the `echo` routing configuration. It now requires a valid API key:

    ```bash
    curl -si http://kong.example/echo --resolve kong.example:80:$PROXY_IP
    ```
    The results should look like this:
    ```
    HTTP/1.1 401 Unauthorized
    Content-Type: application/json; charset=utf-8
    Connection: keep-alive
    WWW-Authenticate: Key realm="kong"
    Content-Length: 41
    Server: kong/3.0.1
    
    {"message":"No API key found in request"}
    ```

    Requests that do not include a key receive a 401 Unauthorized response.

## Provision a consumer and credential

Credential Secrets include a `kongCredType` key, whose value indicates what authentication plugin the credential is for, and keys corresponding to the fields necessary to configure that credential type (`key` for `key-auth` credentials).

1. Create a credential Secret:

{% include_cached /md/kic/key-auth.md kong_version=page.kong_version credName='kotenok-key-auth' %}

1. Create a KongConsumer resource that uses the Secret:

{% include_cached /md/kic/consumer.md kong_version=page.kong_version credName='kotenok-key-auth' %}
  
## Use the credential

Now, send a request including the credential (`key-auth` expects an `apikey`
header with the key by default):

```bash
curl -si http://kong.example/echo --resolve kong.example:80:$PROXY_IP -H "apikey: gav"
```
The results should look like this:
```text
HTTP/1.1 200 OK                
Content-Type: text/plain; charset=UTF-8
Transfer-Encoding: chunked
Connection: keep-alive
Date: Fri, 09 Dec 2022 22:16:24 GMT
Server: echoserver
x-added-service:  demo
X-Kong-Upstream-Latency: 0
X-Kong-Proxy-Latency: 1
Via: kong/3.1.1

Hostname: echo-fc6fd95b5-8tn52
...
```

In this guide, you learned how to leverage an authentication plugin in Kong
and provision credentials. This enables you to offload authentication into
your Ingress layer and keeps the application logic simple.

All other authentication plugins bundled with Kong work in this
way and can be used to quickly add an authentication layer on top of
your microservices.
