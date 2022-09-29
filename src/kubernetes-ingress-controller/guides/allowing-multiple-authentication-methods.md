---
title: Allowing Multiple Authentication Methods
content-type: how-to
---

This guide walks you through the steps for configuring multiple authentication options for consumers using the {{site.kic_product_name}}.
The default behavior for Kong authentication plugins is to require credentials
for all requests without regard for whether a request has been authenticated
via another plugin. Configuring an anonymous consumer on your authentication
plugins allows you to offer clients authentication options.

## Installation

Please follow the [deployment](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/overview) documentation to install
the {{site.kic_product_name}} onto your Kubernetes cluster.

## Testing connectivity to Kong

This guide assumes that the `PROXY_IP` environment variable is
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

## Create a Kubernetes service

Let's create a Kubernetes service using the hostname of the application we want to expose.

```sh
echo '
apiVersion: v1
kind: Service
metadata:
  annotations:
    konghq.com/protocol: https
  name: httpbin
spec:
  externalName: httpbin.org
  ports:
    - port: 443
      protocol: TCP
  type: ExternalName
' | kubectl apply -f -
```

```sh
service/httpbin created
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
    kubernetes.io/ingress.class: kong
spec:
  rules:
  - http:
      paths:
      - path: /foo
        pathType: Prefix
        backend:
          service:
            name: httpbin
            port:
              number: 443
' | kubectl apply -f -
```

```sh
ingress.networking.k8s.io/demo created
```

Let's test these endpoints:

```sh
curl -i $PROXY_IP/foo/status/200
```

```sh
HTTP/2 200 
content-type: text/html; charset=utf-8
content-length: 0
server: gunicorn/19.9.0
access-control-allow-origin: *
access-control-allow-credentials: true
x-kong-upstream-latency: 151
x-kong-proxy-latency: 2
via: kong/2.8.1
```

Next, let's create three consumers.

```sh
echo '
apiVersion: configuration.konghq.com/v1
kind: KongConsumer
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  name: medvezhonok
username: medvezhonok
' | kubectl apply -f -
```

```sh
kongconsumer.configuration.konghq.com/medvezhonok created
```

```sh
echo '
apiVersion: configuration.konghq.com/v1
kind: KongConsumer
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  name: ezhik
username: ezhik
' | kubectl apply -f -
```

```sh
kongconsumer.configuration.konghq.com/ezhik created
```

```sh
echo '
apiVersion: configuration.konghq.com/v1
kind: KongConsumer
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  name: anonymous
username: anonymous
' | kubectl apply -f -
```

```sh
kongconsumer.configuration.konghq.com/anonymous created
```

The `anonymous` consumer does not correspond to any real user, and will only serve as a fallback.

Let's create Key Auth and Basic Auth plugins and set the anonymous fallback to the consumer we created earlier.

```sh
echo '
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: httpbin-basic-auth
config:
  anonymous: anonymous
  hide_credentials: true
plugin: basic-auth
' | kubectl apply -f -
```

```
kongplugin.configuration.konghq.com/httpbin-basic-auth created
```

```sh
echo '
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: httpbin-key-auth
config:
  key_names:
    - apikey
  anonymous: anonymous
  hide_credentials: true
plugin: key-auth
' | kubectl apply -f -
```

```
kongplugin.configuration.konghq.com/httpbin-key-auth created
```

Now, associate both Key Auth and Basic Auth plugins with the previous Ingress rule we created using the konghq.com/plugins annotation:

```sh
echo '
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo
  annotations:
    konghq.com/strip-path: "true"
    kubernetes.io/ingress.class: kong
    konghq.com/plugins: httpbin-basic-auth, httpbin-key-auth
spec:
  rules:
  - http:
      paths:
      - path: /foo
        pathType: Prefix
        backend:
          service:
            name: httpbin
            port:
              number: 443
' | kubectl apply -f -
```

```sh
ingress.networking.k8s.io/demo configured
```

At this point unauthenticated requests and requests with invalid credentials are still allowed. The anonymous consumer is allowed, and will be applied to any request that does not pass a set of credentials associated with some other consumer.


```sh
curl -i $PROXY_IP/foo/status/200
```

```sh
HTTP/2 200 
content-type: text/html; charset=utf-8
content-length: 0
www-authenticate: Key realm="kong"
server: gunicorn/19.9.0
access-control-allow-origin: *
access-control-allow-credentials: true
x-kong-upstream-latency: 150
x-kong-proxy-latency: 3
via: kong/2.8.1
```

```sh
curl -i $PROXY_IP/foo/status/200?apikey=nonsense
```

```sh
HTTP/2 200 
content-type: text/html; charset=utf-8
content-length: 0
www-authenticate: Key realm="kong"
server: gunicorn/19.9.0
access-control-allow-origin: *
access-control-allow-credentials: true
x-kong-upstream-latency: 155
x-kong-proxy-latency: 2
via: kong/2.8.1
```

We'll now add a Key Auth credential for one consumer, and a Basic Auth credential for another. For this we will create a [Secret](https://kubernetes.io/docs/concepts/configuration/secret/)
resource with an API-key, username and password inside it:

```sh
kubectl create secret generic medvezhonok-basic-auth  \
  --from-literal=kongCredType=basic-auth  \
  --from-literal=username=medvezhonok \
  --from-literal=password=hunter2
secret/medvezhonok-basic-auth created
```

```sh
kubectl create secret generic ezhik-key-auth \
  --from-literal=kongCredType=key-auth  \
  --from-literal=key=hunter3
secret/ezhik-key-auth created
```

The type of credential is specified via `kongCredType`.
You can create the Secret using any other method as well.

Next, we will associate these keys with the consumer we created previously.

Please note that we are not re-creating the KongConsumer resource but
only updating it to add the `credentials` array:

```sh
echo '
apiVersion: configuration.konghq.com/v1
kind: KongConsumer
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  name: medvezhonok
credentials:
  - medvezhonok-basic-auth
username: medvezhonok
' | kubectl apply -f -
```

```sh
kongconsumer.configuration.konghq.com/medvezhonok configured
```

```sh
echo '
apiVersion: configuration.konghq.com/v1
kind: KongConsumer
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  name: ezhik
credentials:
  - ezhik-key-auth
username: ezhik
' | kubectl apply -f -
```

```sh
kongconsumer.configuration.konghq.com/ezhik configured
```

Lastly, we will create a Request Termination plugin and add it to the anonymous consumer.

```sh
echo '
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: anonymous-request-termination
config:
  message: "Authentication required"
  status_code: 401
plugin: request-termination
' | kubectl apply -f -
```

```sh
kongplugin.configuration.konghq.com/anonymous-request-termination created
```

```sh
echo '
apiVersion: configuration.konghq.com/v1
kind: KongConsumer
metadata:
  annotations:
    konghq.com/plugins: anonymous-request-termination
    kubernetes.io/ingress.class: kong
  name: anonymous
username: anonymous
' | kubectl apply -f -
```

```
kongconsumer.configuration.konghq.com/anonymous configured
```

Requests with missing or invalid credentials are now rejected, whereas authorized requests using either authentication method are allowed.

```sh

curl -i $PROXY_IP/foo/status/200?apikey=nonsense
HTTP/2 401 
content-type: application/json; charset=utf-8
content-length: 37
access-control-allow-origin: *
x-kong-response-latency: 3
server: kong/2.8.1
{"message":"Authentication required"}


curl -i $PROXY_IP/foo/status/200
HTTP/2 401 
content-type: application/json; charset=utf-8
content-length: 37
access-control-allow-origin: *
x-kong-response-latency: 2
server: kong/2.8.1
{"message":"Authentication required"}


curl -i $PROXY_IP/foo/status/200?apikey=hunter3
HTTP/2 200 
content-type: text/html; charset=utf-8
content-length: 0
server: gunicorn/19.9.0
access-control-allow-origin: *
access-control-allow-credentials: true
x-kong-upstream-latency: 154
x-kong-proxy-latency: 3
via: kong/2.8.1


curl -i $PROXY_IP/foo/status/200 -u medvezhonok:hunter2
HTTP/2 200 
content-type: text/html; charset=utf-8
content-length: 0
server: gunicorn/19.9.0
access-control-allow-origin: *
access-control-allow-credentials: true
x-kong-upstream-latency: 154
x-kong-proxy-latency: 2
via: kong/2.8.1
```