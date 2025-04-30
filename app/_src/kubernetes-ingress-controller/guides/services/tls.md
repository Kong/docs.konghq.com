---
title: TLS Termination / Passthrough
type: how-to
purpose: |
  How to do TLS Termination and TLS Passthrough with {{site.kic_product_name}} and {{site.base_gateway}}
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

1. Deploy the `echo` service as a target for our HTTPRoutes

    ```bash
    kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/echo-service.yaml
    ```

    For TLS termination, you need to configure a `Secret` for listener certificate on the `Gateway` or for the certificate on `spec.tls` of the `Ingress`. This certificate will be used in setting up TLS connection between your client and {{site.base_gateway}}.

{% include_cached /md/kic/add-certificate.md hostname='demo.example.com' release=page.release cert_required=true %}

{% navtabs %}
{% navtab Gateway API %}

1. Update the `Gateway` resource.

    ```yaml
    echo '
    apiVersion: gateway.networking.k8s.io/{{ gwapi_version }}
    kind: Gateway
    metadata:
      name: kong
    spec:
      gatewayClassName: kong
      listeners:
      - name: https
        port: 443
        protocol: HTTPS
        hostname: "demo.example.com"
        tls:
          mode: Terminate
          certificateRefs:
            - kind: Secret
              name: demo.example.com ' | kubectl apply -f -
    ```

2. Bind an `HTTPRoute` to the `Gateway`.

    ```yaml
    echo '
    apiVersion: gateway.networking.k8s.io/{{ gwapi_version }}
    kind: HTTPRoute
    metadata:
      name: demo-example
    spec:
      parentRefs:
      - name: kong
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
          port: 1027' | kubectl apply -f -
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
    spec:
     ingressClassName: kong
     tls:
     - secretName: demo.example.com
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
                 number: 1027
    ```

    The results will look like this:

    ```text
    ingress.networking.k8s.io/demo-example-com created
    ```
{% endnavtab %}
{% endnavtabs %}

#### Verification

You can verify the configuration by using `curl`:

```bash
  curl --cacert ./server.crt -i -k -v -H "Host:demo.example.com" https://${PROXY_IP}/echo
```

You should get the following response:

```
Running on Pod example-echo-server-abcdef1-xxxxx
```

### TLS Passthrough

For TLS passthrough, you also need to create a `Secret` for the TLS secret that is used for creating TLS connection between your client and the backend server.

{% include_cached /md/kic/add-certificate.md hostname='demo.example.com' release=page.release cert_required=true %}

1. Configure {{ site.base_gateway }} to listen on a TLS port and enable `TLSRoute` in {{site.kic_product_name}}:

    Create `values-tls-passthrough.yaml`:

    ```yaml
    echo '
      gateway:
        env:
          stream_listen: "0.0.0.0:8899 ssl" # listen a TLS port
        proxy:
          stream:
          - containerPort: 8899 # configure the service to forward traffic to the TLS port
            servicePort: 8899

      controller:
        ingressController:
          env:
            feature_gates: "GatewayAlpha=true" # enable GatewayAlpha feature gate to turn on TLSRoute controller
    ' > values-tls-passthrough.yaml
    ```

1. Deploy {{ site.kic_product_name }} with:

    ```bash
    helm upgrade -i kong kong/ingress -n kong --values values-tls-passthrough.yaml --create-namespace
    ```

    Then you can create a `Deployment` to run a server accepting TLS connections with the certificate created previously, and a `Service` to expose the server:

1. Deploy the `tlsecho` service as a target for our HTTPRoutes

    ```bash
    kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/tls-echo-service.yaml
    ```

{% navtabs %}
{% navtab Gateway API %}
1. Create a `Gateway` resource.

    ```yaml
    echo '
    apiVersion: gateway.networking.k8s.io/{{ gwapi_version }}
    kind: Gateway
    metadata:
      name: example-gateway-passthrough
    spec:
      gatewayClassName: kong
      listeners:
      - name: https
        port: 8899
        protocol: TLS
        hostname: "demo.example.com"
        tls:
          mode: Passthrough ' | kubectl apply -f -
    ```

2. Bind a `TLSRoute` to the `Gateway`.

    ```yaml
    echo '
    apiVersion: gateway.networking.k8s.io/v1alpha2
    kind: TLSRoute
    metadata:
      name: demo-example-passthrough
    spec:
      parentRefs:
      - name: example-gateway-passthrough
        sectionName: https
      hostnames:
      - demo.example.com
      rules:
      - backendRefs:
        - name: tlsecho
          port: 1030' | kubectl apply -f -
    ```

    You cannot use any `matches` rules on a `TLSRoute` as the TLS traffic has not been decrypted.

    {{ site.base_gateway }} will **not** terminate TLS traffic before sending the request upstream.
{% endnavtab %}
{% navtab Ingress %}
{:.important}
> The Ingress API does not support TLS passthrough
{% endnavtab %}
{% endnavtabs %}

#### Verification

To verify that the TLS passthrough is configured correctly (for example, by `openssl`'s TLS client) use the following commands:

```bash
openssl s_client -connect ${PROXY_IP}:8899 -servername demo.example.com
```

You should receive the following content from the connection:

```
Running on Pod example-tlsroute-manifest.
Through TLS connection.
```