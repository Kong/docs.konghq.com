---
title: Kubernetes Gateway API
---

Kuma supports configuring [Built-in Gateway](/docs/{{ page.version }}/explore/gateway) using [Kubernetes Gateway API](https://gateway-api.sigs.k8s.io/).

## Installation

{% warning %}
Gateway API support is an experimental feature that has to be explicitly enabled.
{% endwarning %}

1. Install Gateway API CRDs

   The Gateway API CRDs are not yet available by default in Kubernetes. You must first [install them](https://gateway-api.sigs.k8s.io/v1alpha2/guides/getting-started).

2. Enable Built-in Gateway and Gateway API support

   Gateway API can only be used when Kuma built-in Gateway is enabled.

   When Kuma is installed with kumactl, use `--experimental-meshgateway` and `--experimental-gatewayapi`.

   When Kuma is installed with HELM, use `experimental.meshGateway=true` value and `experimental.gatewayAPI=true`.

## Usage

1. Setup [counter demo](https://github.com/kumahq/kuma-counter-demo) application

   ```sh
   kumactl install demo | kubectl apply -f -
   ```

2. Add GatewayClass and Gateway

   The Gateway resource represents the proxy instance that handles traffic for a set of Gateway API routes, and a GatewayClass describes characteristics shared by all Gateways of a given type.
   
   ```sh
   echo "apiVersion: gateway.networking.k8s.io/v1alpha2
   kind: GatewayClass
   metadata:
     name: kuma
   spec:
     controllerName: gateways.kuma.io/controller
   " | kubectl apply -f -
   ```
   
   ```sh
   echo "apiVersion: gateway.networking.k8s.io/v1alpha2
   kind: Gateway
   metadata:
     name: kuma
     namespace: kuma-demo
   spec:
     gatewayClassName: kuma
     listeners:
     - name: proxy
       port: 8080
       protocol: HTTP
   " | kubectl apply -f -
   ```
   
   When Gateway resource is applied, Kuma automatically creates an instance of a built-in Gateway with a corresponding Service.
   
   ```
   kubectl get pods -n kuma-demo
   NAME                          READY   STATUS    RESTARTS   AGE
   redis-59c9d56fc-6gcbc         2/2     Running   0          2m8s
   demo-app-5845d6447b-v7npw     2/2     Running   0          2m8s
   kuma-4j6wr-58998b5576-25wl6   1/1     Running   0          30s
   
   kubectl get svc -n kuma-demo
   NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
   redis        ClusterIP      10.43.223.223   <none>        6379/TCP         3m27s
   demo-app     ClusterIP      10.43.216.203   <none>        5000/TCP         3m27s
   kuma-pfh4s   LoadBalancer   10.43.122.93    172.20.0.3    8080:30627/TCP   87s
   ```
   
   Gateway can now be accessed using `172.20.0.3:8080` address.

3. Add an HTTPRoute

   HTTPRoute resources contains a set of matching criteria for HTTP requests and upstream Services to route those requests to.
   
   ```sh
   echo "apiVersion: gateway.networking.k8s.io/v1alpha2
   kind: HTTPRoute
   metadata:
     name: echo
     namespace: kuma-demo
   spec:
     parentRefs:
     - group: gateway.networking.k8s.io
       kind: Gateway
       name: kuma
       namespace: kuma-demo
     rules:
     - backendRefs:
       - group: ''
         kind: Service
         name: demo-app
         port: 5000
         weight: 1
       matches:
       - path:
           type: PathPrefix
           value: /
   " | kubectl apply -f -
   ```
   
   After creating an HTTPRoute, accessing `/` forwards a request to the demo app:
   
   ```sh
   curl 172.20.0.3:8080/ -i
   ```
   
   ```
   HTTP/1.1 200 OK
   x-powered-by: Express
   accept-ranges: bytes
   cache-control: public, max-age=0
   last-modified: Tue, 20 Oct 2020 17:16:41 GMT
   etag: W/"2b91-175470350a8"
   content-type: text/html; charset=UTF-8
   content-length: 11153
   date: Fri, 18 Mar 2022 11:33:29 GMT
   x-envoy-upstream-service-time: 2
   server: Kuma Gateway
   
   <html>
   <head>
   ...
   ```

## TLS Termination

Gateway API supports TLS termination by using standard `kubernetes.io/tls` Secrets.

Here is an example

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: secret-tls
  namespace: kuma-demo
type: kubernetes.io/tls
data:
  tls.crt: "MIIEOzCCAyO..." # redacted
  tls.key: "MIIEowIBAAKC..." # redacted
```

```yaml
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: Gateway
metadata:
  name: kuma
  namespace: kuma-demo
spec:
  gatewayClassName: kuma
  listeners:
  - name: proxy
    port: 8080
    hostname: test.kuma.io
    protocol: HTTPS
    tls:
      certificateRefs:
      - name: secret-tls
```

Under the hood, Kuma CP copies the Secret to `kuma-system` namespace and converts it to [Kuma Secret](/docs/{{ page.version }}/security/secrets).
It tracks all the changes to the secret and deletes it if the original secret is deleted.

## Multizone

Gateway API is not supported with multizone deployments, use Mesh Gateway CRDs instead.

## How does it work

When the feature is enabled, Kubernetes Gateway API CRDs are automatically converted to Kuma Mesh Gateway CRDs.
This is the reason why in the GUI we will see Kuma Mesh Gateway and not Kubernetes Gateway API resources. 

When using Kubernetes Gateway API CRDs, it is a source of truth, so do not edit Kuma Mesh Gateway CRDs directly.
