---
title: Rewriting hosts and paths
---
This guide demonstrates host and path rewrites using Ingress and Service configuration.

{% include_cached /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=false%}

## Create a test Deployment

To test our requests, we create an echo server Deployment, which responds to
HTTP requests with a summary of the request contents:

```bash
kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/echo-service.yaml
```

```bash
service/echo created
deployment.apps/echo created
```

## Create an Ingress

```bash
echo '
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app
spec:
  ingressClassName: kong
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /echo
        pathType: ImplementationSpecific
        backend:
          service:
            name: echo
            port:
              number: 1027
' | kubectl apply -f -
```

This Ingress will create a Kong route attached to the service we created above.
It will preserve its path but honor the service's hostname, so this request:

```bash
$ curl -v -H 'Host: myapp.example.com' $PROXY_IP/echo
GET /echo HTTP/1.1
Host: myapp.example.com
User-Agent: curl/7.70.0
Accept: */*
```
will appear upstream as:

```
GET /echo HTTP/1.1
Host: 10.16.4.8
User-Agent: curl/7.70.0
Accept: */*
```

We'll use this same cURL command in other examples as well.

Actual output from cURL and the echo server will be more verbose. These
examples are condensed to focus primarily on the path and Host header.

Note that this default behavior uses `strip_path=false` on the route. This
differs from Kong's standard default to conform with expected ingress
controller behavior.

## Rewriting the host

There are two options to override the default `Host` header behavior:

- Add the [`konghq.com/host-header` annotation][1] to your Service, which sets
  the `Host` header directly:
  ```bash
  $ kubectl patch -n echo service echo -p '{"metadata":{"annotations":{"konghq.com/host-header":"internal.myapp.example.com"}}}'
  ```
  The request upstream will now use the header from that annotation:
  ```
  GET /myapp/foo HTTP/1.1
  Host: internal.myapp.example.com
  User-Agent: curl/7.70.0
  Accept: */*
  ```
- Add the [`konghq.com/preserve-host` annotation][0] to your Ingress, which
  sends the route/Ingress hostname:
  ```bash
  $ kubectl patch -n echo ingress my-app -p '{"metadata":{"annotations":{"konghq.com/preserve-host":"true"}}}'
  ```
  The request upstream will now include the hostname from the Ingress rule:
  ```
  GET /myapp/foo HTTP/1.1
  Host: myapp.example.com
  User-Agent: curl/7.70.0
  Accept: */*
  ```

The `preserve-host` annotation takes precedence, so if you add both annotations
above, the upstream host header will be `myapp.example.com`.

## Rewriting the path

There are three options to rewrite the default path handling behavior:


- Add the [`konghq.com/rewrite` annotation][2] to your Ingress, allows you set a specific path for the upstream request. Any regex matches defined in your route definition are usable (see the [annotation documentation][2] for more information):
  ```bash
  $ kubectl patch -n echo ingress my-app -p '{"metadata":{"annotations":{"konghq.com/rewrite":"/hello/world"}}}'
  ```
  The request upstream will now contain the value of the rewrite annotation:
  ```
  GET /hello/world HTTP/1.1
  Host: 10.16.4.8
  User-Agent: curl/7.70.0
  Accept: */*
  ```
- Add the [`konghq.com/strip-path` annotation][3] to your Ingress, which strips
  the path component of the route/Ingress, leaving the remainder of the path at
  the root:
  ```bash
  $ kubectl patch -n echo ingress my-app -p '{"metadata":{"annotations":{"konghq.com/strip-path":"true"}}}'
  ```
  The request upstream will now only contain the path components not in the
  Ingress rule:
  ```
  GET /foo HTTP/1.1
  Host: 10.16.4.8
  User-Agent: curl/7.70.0
  Accept: */*
  ```
- Add the [`konghq.com/path` annotation][4] to your Service, which prepends
  that value to the upstream path:
  ```bash
  $ kubectl patch -n echo service echo -p '{"metadata":{"annotations":{"konghq.com/path":"/api"}}}'
  ```
  The request upstream will now contain a leading `/api`:
  ```
  GET /api/myapp/foo HTTP/1.1
  Host: 10.16.4.8
  User-Agent: curl/7.70.0
  Accept: */*
  ```
`strip-path` and `path` can be combined together, with the `path` component
coming first. Adding both annotations above will send requests for `/api/foo`.

[0]: /kubernetes-ingress-controller/{{page.kong_version}}/references/annotations/#konghqcompreserve-host
[1]: /kubernetes-ingress-controller/{{page.kong_version}}/references/annotations/#konghqcomhost-header
[2]: /kubernetes-ingress-controller/{{page.kong_version}}/references/annotations/#konghqcomrewrite
[3]: /kubernetes-ingress-controller/{{page.kong_version}}/references/annotations/#konghqcomstrip-path
[4]: /kubernetes-ingress-controller/{{page.kong_version}}/references/annotations/#konghqcompath
