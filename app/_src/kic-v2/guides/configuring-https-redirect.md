---
title: Configuring HTTPS redirect
content_type: tutorial
---

## Overview

Learn to configure the {{site.kic_product_name}} to redirect HTTP requests to
HTTPS so that all communication from the external world to your APIs and
microservices is encrypted.

{% include_cached /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=false %}

{% include_cached /md/kic/test-service-echo.md kong_version=page.kong_version %}

{% include_cached /md/kic/class.md kong_version=page.kong_version %}

{% include_cached /md/kic/http-test-routing.md kong_version=page.kong_version %}

## Add TLS configuration

{% include_cached /md/kic/add-tls-conf.md hostname='kong.example' kong_version=page.kong_version %}

## Configure an HTTPS redirect

Kong handles HTTPS redirects by automatically issuing redirects to requests
whose characteristics match an HTTPS-only route except for the protocol. For
example, with a Kong route such as this:

```json
{ "protocols": ["https"], "hosts": ["kong.example"],
  "https_redirect_status_code": 301, "paths": ["/echo/"], "name": "example" }
```

A request for `http://kong.example/echo/green` receives a 301 response with
a `Location: https://kong.example/echo/green` header. Kubernetes resource
annotations instruct the controller to create a route with `protocols=[https]`
and `https_redirect_status_code` set to the code of your choice (the default if
unset is `426`).
1. Configure the protocols that are allowed in the `konghq.com/protocols` annotation.
   {% capture the_code %}
{% navtabs codeblock %}
{% navtab Ingress %}

```bash
kubectl annotate ingress echo konghq.com/protocols=https
```
{% endnavtab %}
{% navtab Gateway API %}

```bash
kubectl annotate httproute echo konghq.com/protocols=https
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


1. Configure the status code used to redirect in the `konghq.com/https-redirect-status-code`` annotation. 
   {% capture the_code %}
{% navtabs codeblock %}
{% navtab Ingress %}

```bash
kubectl annotate ingress echo konghq.com/https-redirect-status-code="301"
```
{% endnavtab %}
{% navtab Gateway API %}

```bash
kubectl annotate httproute echo konghq.com/https-redirect-status-code="301"
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

> **Note**: The GatewayAPI _does not_ use a [HTTPRequestRedirectFilter](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1.HTTPRequestRedirectFilter)
to configure the redirect. Using the filter to redirect HTTP to HTTPS requires
a separate HTTPRoute to handle redirected HTTPS traffic, which does not align
well with Kong's single route redirect model.

Work to support the standard filter-based configuration is ongoing. Until then,
the annotations allow you to configure HTTPS-only HTTPRoutes.

## Test the configuration

With the redirect configuration in place, HTTP requests now receive a
redirect rather than being proxied upstream:
1. Send a HTTP request.
    ```bash
    curl -ksvo /dev/null -H 'Host: kong.example' http://$PROXY_IP/echo 2>&1 | grep -i http
    ```

    The results should look like this:

    ```text
    > GET /echo HTTP/1.1
    < HTTP/1.1 301 Moved Permanently
    < Location: https://kong.example/echo
    ```

1. Send a curl request to follow redirects using the `-L` flag navigates
to the HTTPS URL and receive a proxied response from upstream.

    ```bash
    curl -Lksv -H 'Host: kong.example' http://$PROXY_IP/echo 2>&1
    ```

    The results should look like this (some output removed for brevity):

    ```text
    > GET /echo HTTP/1.1
    > Host: kong.example
    >
    < HTTP/1.1 301 Moved Permanently
    < Location: https://kong.example/echo
    < Server: kong/3.4.2
    
    * Issue another request to this URL: 'https://kong.example/echo'

    * Server certificate:
    *  subject: CN=kong.example
     
    > GET /echo HTTP/2
    > Host: kong.example
    >
    < HTTP/2 200
    < via: kong/3.4.2
    <
    Welcome, you are connected to node kind-control-plane.
    Running on Pod echo-74d47cc5d9-pq2mw.
    In namespace default.
    With IP address 10.244.0.7.
    ```

Kong correctly serves the request only on HTTPS protocol and redirects the user
if the HTTP protocol is used. The `-k` flag in cURL skips certificate
validation as the certificate served by Kong is a self-signed one. If you are
serving this traffic through a domain that you control and have configured TLS
properties for it, then the flag won't be necessary.

If you have a domain that you control but don't have TLS/SSL certificates for
it, see [Using cert-manager with
Kong](/kubernetes-ingress-controller/{{page.kong_version}}/guides/cert-manager)
guide which can get TLS certificates setup for you automatically. And it's
free, thanks to Let's Encrypt!
