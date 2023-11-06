---
title: Multiple Backends
type: how-to
purpose: |
  Distribute requests from multiple services using HTTPRoute
---

HTTPRoute supports adding multiple Services under its `BackendRefs` field. When you add multiple Services,
requests through the HTTPRoute are distributed across the Services. This guide walks through creating an HTTPRoute with multiple backend Services.

{% include /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=false %}

## Deploy multiple Services with HTTPRoute

1. Deploy two echo Services so that you have multiple `BackendRef`s to use for traffic splitting:
    ```bash
    kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/echo-services.yaml
    ```
    The results should look like this:
    ```text
    service/echo created
    deployment.apps/echo created
    service/echo2 created
    deployment.apps/echo2 created
    ```

1. Deploy a HTTPRoute that sends traffic to both the services. By default, traffic is distributed evenly across all services:

    ```bash
   echo 'apiVersion: gateway.networking.k8s.io/v1
   kind: HTTPRoute
   metadata:
     name: echo
     annotations:
       konghq.com/strip-path: "true"
   spec:
     parentRefs:
     - name: kong
     rules:
     - matches:
       - path:
           type: PathPrefix
           value: /echo
       backendRefs:
       - name: echo
         kind: Service
         port: 80
       - name: echo2
         kind: Service
         port: 80
   ' | kubectl apply -f -
    ```
    The results should look like this:
    ```text
    httproute.gateway.networking.k8s.io/echo created
    ```

1. Send multiple requests through this route and tabulating the results to check an even distribution of requests across the Services:
    ```bash
    curl -s "$PROXY_IP/echo/hostname?iteration="{1..200} -w "\n" | sort | uniq -c
    ```
    The results should look like this:
    ```text
    100 echo2-7cb798f47-gv6hs
    100 echo-658c5ff5ff-tv275
    ```

## Add Service weights

The `weight` field overrides the default distribution of requests across Services. Each Service instead receives `weight / sum(all Service weights)` percent of the requests. 
1. Add weights to the Services in the HTTPRoute's backend list.

    ```bash
    kubectl patch --type json httproute echo -p='[
        {
          "op":"add",
          "path":"/spec/rules/0/backendRefs/0/weight",
          "value":200
        },
        {
          "op":"add",
          "path":"/spec/rules/0/backendRefs/1/weight",
          "value":100
        }
    ]'
    ```
    The results should look like this:
    ```text
    httproute.gateway.networking.k8s.io/echo patched
    ```

1. Send the same requests and roughly 1/3 of the requests go to `echo2` and 2/3 going to `echo`:

    ```bash
    curl -s "$PROXY_IP/echo/hostname?iteration="{1..200} -w "\n" | sort | uniq -c
    ```
    The results should look like this:
    ```text
     67 echo2-7cb798f47-gv6hs
    133 echo-658c5ff5ff-tv275
   ```
