---
title: Using KongPlugin resource
---

This guide walks you through using the {{site.kic_product_name}} 
KongPlugin Custom Resource to control proxied requests, including
restricting paths and transforming requests.

## Installation

Please follow the [deployment](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/overview) documentation to install
the {{site.kic_product_name}} onto your Kubernetes cluster.

## Testing connectivity to Kong

This guide assumes that `PROXY_IP` environment variable is
set to contain the IP address or URL pointing to Kong.
If you've not done so, please follow one of the
[deployment guides](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/overview) to configure this environment variable.

If everything is set up correctly, making a request to Kong should return
`HTTP 404 Not Found`.

```sh
curl -i $PROXY_IP
```

In this document, the expected output follows each command:

```sh
HTTP/1.1 404 Not Found
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Content-Length: 48
X-Kong-Response-Latency: 1
Server: kong/2.8.1

{"message":"no Route matched with those values"}
```

This message is expected as Kong does not yet know how to proxy the request.

## Installing sample services

Start by installing two services. First, install an `httpbin` service:

```sh
kubectl apply -f https://bit.ly/k8s-httpbin
```

```sh
service/httpbin created
deployment.apps/httpbin created
```

And then an `echo` service:

```sh
kubectl apply -f https://bit.ly/echo-service
```

```sh
service/echo created
deployment.apps/echo created
```

## Setup Ingress rules

Let's expose these services outside the Kubernetes cluster
by defining Ingress rules.

```sh
echo '
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo
  annotations:
    konghq.com/strip-path: "true"
spec:
  ingressClassName: kong
  rules:
  - http:
      paths:
      - path: /foo
        pathType: ImplementationSpecific
        backend:
          service:
            name: httpbin
            port:
              number: 80
      - path: /bar
        pathType: ImplementationSpecific
        backend:
          service:
            name: echo
            port:
              number: 80
' | kubectl apply -f -
```

```sh
ingress.networking.k8s.io/demo created
```

Let's test these endpoints. First the `/foo` route:

```sh
curl -i $PROXY_IP/foo/status/200
```

```sh
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Content-Length: 0
Connection: keep-alive
Server: gunicorn/19.9.0
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
X-Kong-Upstream-Latency: 2
X-Kong-Proxy-Latency: 0
Via: kong/2.8.1
```

Next the `/bar` route:

```sh
curl -i $PROXY_IP/bar
```

```sh
HTTP/1.1 200 OK
Content-Type: text/plain; charset=UTF-8
Transfer-Encoding: chunked
Connection: keep-alive
Server: echoserver
X-Kong-Upstream-Latency: 1
X-Kong-Proxy-Latency: 0
Via: kong/2.8.1

Hostname: echo-5fc5b5bc84-n7lhg
...
```

Let's add another Ingress resource which proxies requests to `/baz` to httpbin
service:

```sh
echo '
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo-2
  annotations:
    konghq.com/strip-path: "true"
spec:
  ingressClassName: kong
  rules:
  - http:
      paths:
      - path: /baz
        pathType: ImplementationSpecific
        backend:
          service:
            name: httpbin
            port:
              number: 80
' | kubectl apply -f -
```

```sh
ingress.networking.k8s.io/demo-2 created
```

We will use this Ingress path later.

## Configuring plugins on Ingress resource

Next, we will configure two plugins on the Ingress resource.

First, we will create a KongPlugin resource:

```sh
echo '
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: add-response-header
config:
  add:
    headers:
    - "demo: injected-by-kong"
plugin: response-transformer
' | kubectl apply -f -
```

```sh
kongplugin.configuration.konghq.com/add-response-header created
```

Next, we will associate it with our Ingress rules:

```sh
kubectl patch ingress demo -p '{"metadata":{"annotations":{"konghq.com/plugins":"add-response-header"}}}'
```

```sh
ingress.networking.k8s.io/demo patched
```

Here, we are asking the {{site.kic_product_name}} to execute the response-transformer
plugin whenever a request matching the Ingress rule is processed.

Let's test it out, first on `/foo`:

```sh
curl -i $PROXY_IP/foo/status/200
```

```sh
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Content-Length: 0
Connection: keep-alive
Server: gunicorn/19.9.0
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
demo:  injected-by-kong
X-Kong-Upstream-Latency: 1
X-Kong-Proxy-Latency: 0
Via: kong/2.8.1
```

Then on `/bar`:

```sh
curl -I $PROXY_IP/bar
```

```sh
HTTP/1.1 200 OK
Content-Type: text/plain; charset=UTF-8
Connection: keep-alive
Server: echoserver
demo:  injected-by-kong
X-Kong-Upstream-Latency: 1
X-Kong-Proxy-Latency: 0
Via: kong/2.8.1
```

As can be seen in the output, the `demo` header is injected by Kong when
the request matches the Ingress rules defined in the `demo` Ingress resource.

If we send a request to `/baz`, then we can see that the header is not injected
by Kong:

```sh
curl -I $PROXY_IP/baz
```

```sh
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Content-Length: 9593
Connection: keep-alive
Server: gunicorn/19.9.0
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
X-Kong-Upstream-Latency: 13
X-Kong-Proxy-Latency: 1
Via: kong/2.8.1
```

Here, we have successfully set up a plugin which is executed only when a
request matches a specific Ingress rule.

## Configuring plugins on Service resource

Next, we will see how we can configure Kong to execute plugins for requests
which are sent to a specific service.

Let's add a KongPlugin resource for authentication on the httpbin service:

```sh
echo "apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: httpbin-auth
plugin: key-auth
" | kubectl apply -f -
```

```
kongplugin.configuration.konghq.com/httpbin-auth created
```

Next, we will associate this plugin to the httpbin service running in our
cluster:

```sh
kubectl patch service httpbin -p '{"metadata":{"annotations":{"konghq.com/plugins":"httpbin-auth"}}}'
```

```sh
service/httpbin patched
```

Now, any request sent to the service will require authentication,
no matter which Ingress rule it matched:

```sh
curl -I $PROXY_IP/baz
```

```sh
HTTP/1.1 401 Unauthorized
Content-Type: application/json; charset=utf-8
Connection: keep-alive
WWW-Authenticate: Key realm="kong"
Content-Length: 45
X-Kong-Response-Latency: 1
Server: kong/2.8.1
```

`/foo` also requires authentication:

```sh
curl -I $PROXY_IP/foo
```

```sh
HTTP/1.1 401 Unauthorized
Content-Type: application/json; charset=utf-8
Connection: keep-alive
WWW-Authenticate: Key realm="kong"
Content-Length: 45
demo:  injected-by-kong
X-Kong-Response-Latency: 1
Server: kong/2.8.1
```

You can also see how the `demo` header was injected only for `/foo`,
as the request matched one of the rules defined in the Ingress
resource, but not for `/baz` because that request does not match.

## Configure consumer and credential

Follow the [Using Consumers and Credentials](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-consumer-credential-resource)
guide to provision a user and an `apikey`.

Use the API key to pass authentication. Try it with `/baz`:

```sh
curl -I $PROXY_IP/baz -H 'apikey: my-super-secret-key'
```

```sh
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Content-Length: 9593
Connection: keep-alive
Server: gunicorn/19.9.0
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
X-Kong-Upstream-Latency: 2
X-Kong-Proxy-Latency: 1
Via: kong/2.8.1
```

Then use the API key with `/foo`:
```sh
curl -I $PROXY_IP/foo -H 'apikey: my-super-secret-key'
```

```sh
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Content-Length: 9593
Connection: keep-alive
Server: gunicorn/19.9.0
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
demo:  injected-by-kong
X-Kong-Upstream-Latency: 2
X-Kong-Proxy-Latency: 0
Via: kong/2.8.1
```

## Configure a global plugin

Follow the [Using KongClusterPlugin resource](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-kongclusterplugin-resource/#configure-a-global-plugin) guide to configure a rate limiting plugin to throttle requests coming from the same client. 

## Configure a plugin for a specific consumer

Now, let's say we would like to give a specific consumer a higher rate-limit.

For this, we can create a KongPlugin resource and then associate it with
a specific consumer.

First, create the KongPlugin resource:

```sh
echo "
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: harry-rate-limit
config:
  minute: 10
  limit_by: consumer
  policy: local
plugin: rate-limiting
" | kubectl apply -f -
```

```sh
kongplugin.configuration.konghq.com/harry-rate-limit created
```

Next, associate this with the consumer:

```sh
echo "apiVersion: configuration.konghq.com/v1
kind: KongConsumer
metadata:
  name: harry
  annotations:
    kubernetes.io/ingress.class: kong
    konghq.com/plugins: harry-rate-limit
username: harry
credentials:
- harry-apikey" | kubectl apply -f -
```

```
kongconsumer.configuration.konghq.com/harry configured
```

Note the annotation being added to the KongConsumer resource.

Now, if the request is made as the `harry` consumer, the client
is rate-limited differently:

```sh
curl -I $PROXY_IP/foo -H 'apikey: my-super-secret-key'
```

```
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Content-Length: 9593
Connection: keep-alive
X-RateLimit-Remaining-Minute: 9
X-RateLimit-Limit-Minute: 10
RateLimit-Remaining: 9
RateLimit-Reset: 42
RateLimit-Limit: 10
Server: gunicorn/19.9.0
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
demo:  injected-by-kong
X-Kong-Upstream-Latency: 2
X-Kong-Proxy-Latency: 1
Via: kong/2.8.1
```

And a regular unauthenticated request:

```sh
curl -I $PROXY_IP/bar
```

```sh
HTTP/1.1 200 OK
Content-Type: text/plain; charset=UTF-8
Connection: keep-alive
X-RateLimit-Remaining-Minute: 4
X-RateLimit-Limit-Minute: 5
RateLimit-Remaining: 4
RateLimit-Reset: 11
RateLimit-Limit: 5
Server: echoserver
demo:  injected-by-kong
X-Kong-Upstream-Latency: 1
X-Kong-Proxy-Latency: 1
Via: kong/2.8.1
```

## Next steps

There's a lot more you can do with Kong plugins. Check the [Plugin Hub](/hub) to see all of the available plugins and how to use them.

Next, you might want to learn more about Ingress with the 
[KongIngress resource guide](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-kongingress-resource/).
