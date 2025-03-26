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

## Expose additional ports

{{site.base_gateway}} does not include any TCP listen configuration by default. To expose TCP listens, update the Deployment's environment variables and port configuration.

1. Update the Deployment.
    ```bash
    kubectl patch deploy -n kong kong-gateway --patch '{
      "spec": {
        "template": {
          "spec": {
            "containers": [
              {
                "name": "proxy",
                "env": [
                  {
                    "name": "KONG_STREAM_LISTEN",
                    "value": "0.0.0.0:9000, 0.0.0.0:9443 ssl"
                  }
                ],
                "ports": [
                  {
                    "containerPort": 9000,
                    "name": "stream9000",
                    "protocol": "TCP"
                  },
                  {
                    "containerPort": 9443,
                    "name": "stream9443",
                    "protocol": "TCP"
                  }
                ]
              }
            ]
          }
        }
      }
    }'
    ```
    The results should look like this:
    ```text
    deployment.apps/kong-gateway patched
    ```

    The `ssl` parameter after the 9443 listen instructs {{site.base_gateway}} to expect TLS-encrypted TCP traffic on that port. The 9000 listen has no parameters, and expects plain TCP traffic.

1.  Update the proxy Service to indicate the new ports.

    ```bash
    kubectl patch service -n kong kong-gateway-proxy --patch '{
      "spec": {
        "ports": [
          {
            "name": "stream9000",
            "port": 9000,
            "protocol": "TCP",
            "targetPort": 9000
          },
          {
            "name": "stream9443",
            "port": 9443,
            "protocol": "TCP",
            "targetPort": 9443
          }
        ]
      }
    }'
    ```
    The results should look like this:
    ```text
    service/kong-gateway-proxy patched
    ```
1.  Configure TCPRoute (Gateway API Only)

    {:.note}
    > If you are using the Gateway APIs (TCPRoute), your Gateway needs additional configuration under `listeners`. 

    ```bash
    kubectl patch --type=json gateway kong -p='[
        {
            "op":"add",
            "path":"/spec/listeners/-",
            "value":{
                "name":"stream9000",
                "port":9000,
                "protocol":"TCP"
            }
        },
        {
            "op":"add",
            "path":"/spec/listeners/-",
            "value":{
                "name":"stream9443",
                "port":9443,
                "protocol":"TLS",
                "hostname":"tls9443.kong.example",
                "tls": {
                    "certificateRefs":[{
                        "group":"",
                        "kind":"Secret",
                        "name":"tls9443.kong.example"
                     }]
                }
            }
        }
    ]'
    ```
    The results should look like this:
    ```text
    gateway.gateway.networking.k8s.io/kong patched
    ```

{% include /md/kic/test-service-echo.md release=page.release %}

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
