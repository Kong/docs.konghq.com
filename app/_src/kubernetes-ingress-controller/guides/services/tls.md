---
title: TLS Termination / Passthrough
type: how-to
purpose: |
  How to do TLS Termination and TLS Passthrough with KIC and Kong Gateway
---


## Gateway API

The Gateway API supports both [TLS termination](
https://gateway-api.sigs.k8s.io/guides/migrating-from-ingress/#tls-termination) and TLS passthrough. TLS handling is configured via a combination of a Gateway's `listeners[].tls.mode` and the attached route type:

- `Passthrough` mode listeners inspect the TLS stream hostname via server name indication and pass the TLS stream unaltered upstream. These listeners do not use certificate configuration. They only accept `TLSRoutes`.
- `Terminate` mode listeners decrypt the TLS stream and inspect the request it wraps before passing it upstream. They require certificate [Secret reference](https://gateway-api.sigs.k8s.io/reference/spec/#gateway.networking.k8s.io/v1.SecretObjectReference) in the `listeners[].tls.[]certificateRefs` field. They accept `HTTPRoutes`, `TCPRoutes`, and `GRPCRoutes`.

To terminate TLS, create a `Gateway` with a listener with `.tls.mode: "Terminate"`, create a [TLS Secret](https://kubernetes.io/docs/concepts/configuration/secret/#tls-secrets) and add it to the listener `.tls.certificateRefs` array, and then create one of the supported route types with matching criteria that will bind it to the listener.

For `HTTPRoute` or `GRPCRoute`, the route's `hostname` must match the listener hostname. For `TCPRoute` the route's `port` must match the listener `port`.

## Ingress

The Ingress API supports TLS termination using the `.spec.tls` field. To terminate TLS with the Ingress API, provide `.spec.tls.secretName` that contains a TLS certificate and a list of `.spec.tls.hosts` to match in your Ingress definition. 

## Examples

{% include /md/kic/prerequisites.md release=page.release disable_gateway_api=false gateway_api_experimental=true %}

### TLS Termination
{% assign gwapi_version = "v1" %}
{% if_version lte:2.12.x %}
{% assign gwapi_version = "v1beta1" %}
{% endif_version %}

{% navtabs %}
{% navtab Gateway API %}

1. Create a `Gateway` resource.

    ```yaml
    apiVersion: gateway.networking.k8s.io/{{ gwapi_version }}
    kind: Gateway
    metadata:
      name: example-gateway
    spec:
      gatewayClassName: kong 
      listeners:
      - name: https
        port: 8899
        protocol: HTTPS
        hostname: "demo.example.com"
        tls:
          mode: Terminate
          certificateRefs:
            - kind: Secret
              name: demo-example-com-cert
    ```

2. Bind a `HTTPRoute` to the `Gateway`.

    ```yaml
    apiVersion: gateway.networking.k8s.io/{{ gwapi_version }}
    kind: HTTPRoute
    metadata:
      name: demo-example 
    spec:
      parentRefs:
      - name: example-gateway
        sectionName: https
      hostnames:
      - demo.example.com
      rules:
      - matches:
        - path:
            type: PathPrefix
            value: /echo
        backendRefs:
        - name: echo
          port: 1027
    ```

    {{ site.base_gateway }} will terminate TLS traffic before sending the request upstream.
{% endnavtab %}
{% navtab Ingress %}
1. Specify a `secretName` and list of `hosts` in `.spec.tls`.

    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
     name: demo-example-com
     annotations:
       cert-manager.io/cluster-issuer: letsencrypt-prod
    spec:
     ingressClassName: kong
     tls:
     - secretName: demo-example-com
       hosts:
       - demo.example.com
     rules:
     - host: demo.example.com
       http:
         paths:
         - path: /
           pathType: ImplementationSpecific
           backend:
             service:
               name: echo
               port:
                 number: 80
    ```
    
    The results will look like this:
    
    ```text
    ingress.extensions/demo-example-com configured
    ```
{% endnavtab %}
{% endnavtabs %}

### TLS Passthrough

{% navtabs %}
{% navtab Gateway API %}
1. Create a `Gateway` resource.

    ```yaml
    apiVersion: gateway.networking.k8s.io/{{ gwapi_version }}
    kind: Gateway
    metadata:
      name: example-gateway
    spec:
      gatewayClassName: kong 
      listeners:
      - name: https
        port: 8899
        protocol: TLS
        hostname: "demo.example.com"
        tls:
          mode: Passthrough
    ```

2. Bind a `TLSRoute` to the `Gateway`.

    ```yaml
    apiVersion: gateway.networking.k8s.io/v1alpha2
    kind: TLSRoute
    metadata:
      name: demo-example-passthrough
    spec:
      parentRefs:
      - name: example-gateway
        sectionName: https
      hostnames:
      - demo.example.com
      rules:
      - backendRefs:
        - name: tlsecho
          port: 1989
    ```

    You cannot use any `matches` rules on a `TLSRoute` as the TLS traffic has not been decrypted.

    {{ site.base_gateway }} will **not** terminate TLS traffic before sending the request upstream.
{% endnavtab %}
{% navtab Ingress %}
{:.important}
> The Ingress API does not support TLS passthrough
{% endnavtab %}
{% endnavtabs %}
