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

You can create a `Deployment` running the go-echo server and a `Service` pointing to the pods, then use the `Service` as the backend:

  ```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-echo-server
  labels:
    app: echo
spec:
  selector:
    matchLabels:
      app: echo
  template:
    metadata:
      labels:
        app: echo
    spec:
      containers:
      - name: echo
        image: kong/go-echo:0.5.0
        env:
          - name: POD_NAME
            valueFrom:
              fieldRef:
                fieldPath: metadata.name
        ports:
          - containerPort: 1027
            name: "echo-http"
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: echo
  name: echo
spec:
  ports:
  - port: 1027
    protocol: TCP
    targetPort: 1027
  selector:
    app: echo
  type: ClusterIP

  ```

For TLS termination, you need to configure a `Secret` for listener certificate on the `Gateway`. or for the certificate on `spec.tls` of the `Ingress`. This certificate will be used in setting up TLS connection between your client and {{site.base_gateway}}.

```bash
$ kubectl create secret tls demo-example-com-cert --cert=example.com-tls.crt --key=example.com-tls.key
```

{% navtabs %}
{% navtab Gateway API %}

1. Create a `Gateway` resource.

    ```yaml
    apiVersion: gateway.networking.k8s.io/v1
    kind: GatewayClass
    metadata:
      name: kong
      annotations:
        konghq.com/gatewayclass-unmanaged: "true"
    spec:
      controllerName: konghq.com/kic-gateway-controller
    ---
    apiVersion: gateway.networking.k8s.io/{{ gwapi_version }}
    kind: Gateway
    metadata:
      name: example-gateway
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
              name: demo-example-com-cert
    ```

2. Bind an `HTTPRoute` to the `Gateway`.

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
     - secretName: demo-example-com-cert
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

### TLS Passthrough

For TLS passthrough, you also need to create a `Secret` for the TLS secret that is used for creating TLS connection between your client and the backend server.

```bash
$ kubectl create secret tls demo-example-com-cert --cert=example.com-tls.crt --key=example.com-tls.key
```

Then you can create a `Deployment` to run a server accepting TLS connections with the certificate created previously, and a `Service` to expose the server:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tlsecho
  labels:
    app: tlsecho
spec:
  selector:
    matchLabels:
      app: tlsecho
  template:
    metadata:
      labels:
        app: tlsecho
    spec:
      containers:
      - name: tlsecho
        image: kong/go-echo:0.5.0
        ports:
        - containerPort: 1030
        env:
        - name: POD_NAME
          value: example-tlsroute-manifest
        - name: TLS_PORT
          value: "1030"
        - name: TLS_CERT_FILE
          value: /var/run/certs/tls.crt
        - name: TLS_KEY_FILE
          value: /var/run/certs/tls.key
        volumeMounts:
        - mountPath: /var/run/certs
          name: secret-test
          readOnly: true
      volumes:
      - name: secret-test
        secret:
          defaultMode: 420
          secretName: demo-example-com-cert
---
apiVersion: v1
kind: Service
metadata:
  name: tlsecho
spec:
  ports:
  - port: 8899
    protocol: TCP
    targetPort: 1030
  selector:
    app: tlsecho
  type: ClusterIP
```

{% navtabs %}
{% navtab Gateway API %}
1. Create a `Gateway` resource.

    ```yaml
    apiVersion: gateway.networking.k8s.io/v1
    kind: GatewayClass
    metadata:
      name: kong
      annotations:
        konghq.com/gatewayclass-unmanaged: "true"
    spec:
      controllerName: konghq.com/kic-gateway-controller
    ---
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
      - name: example-gateway-passthrough
        sectionName: https
      hostnames:
      - demo.example.com
      rules:
      - backendRefs:
        - name: tlsecho
          port: 8899
    ```

    You cannot use any `matches` rules on a `TLSRoute` as the TLS traffic has not been decrypted.

    {{ site.base_gateway }} will **not** terminate TLS traffic before sending the request upstream.
{% endnavtab %}
{% navtab Ingress %}
{:.important}
> The Ingress API does not support TLS passthrough
{% endnavtab %}
{% endnavtabs %}
