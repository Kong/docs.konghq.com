---
title: Configuring a fallback service
---

Learn to setup a fallback service using Ingress resource. The fallback service receives all requests that don't
match against any of the defined Ingress rules. This can be useful if you would like to return a 404 page
to the end user if the user clicks a dead link or inputs an incorrect URL.

{% include_cached /md/kic/prerequisites.md release=page.release disable_gateway_api=true %}

## Setup a sample service

1. Deploy an example echo service.

    ```bash
    kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/echo-service.yaml
    ```
    The results should look like this:
    ```text
    deployment.apps/echo created
    service/echo created
    ```

1. Create an Ingress rule to proxy the echo service.

    ```bash
    $ echo '
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
          - path: /echo
            pathType: ImplementationSpecific
            backend:
              service:
                name: echo
                port:
                  number: 1027
    ' | kubectl apply -f -
    ```
   The results should look like this:
    ```text
    ingress.extensions/demo created
    ```
1. Test the Ingress rule:

    ```bash
    $ curl -i $PROXY_IP/echo
    ```
    The results should look like this:
    ```text
    HTTP/1.1 200 OK
    Content-Type: text/plain; charset=utf-8
    Content-Length: 137
    Connection: keep-alive
    Date: Sun, 17 Sep 2023 19:45:02 GMT
    X-Kong-Upstream-Latency: 1
    X-Kong-Proxy-Latency: 0
    Via: kong/3.3.1
    
    Welcome, you are connected to node kind.
    Running on Pod echo-74d47cc5d9-9zbzh.
    In namespace default.
    With IP address 192.168.194.7.
    ```

## Setup a fallback service

1.  Deploy another sample service service.

    ```bash
    $ echo '
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: fallback-svc
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: fallback-svc
      template:
        metadata:
          labels:
            app: fallback-svc
        spec:
          containers:
          - name: fallback-svc
            image: hashicorp/http-echo
            args:
            - "-text"
            - "This is not the path you are looking for. - Fallback service"
            ports:
            - containerPort: 5678
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: fallback-svc
      labels:
        app: fallback-svc
    spec:
      type: ClusterIP
      ports:
      - port: 80
        targetPort: 5678
        protocol: TCP
        name: http
      selector:
        app: fallback-svc
    ' | kubectl apply -f -
    ```
    The results should look like this:
    ```bash
    deployment.apps/fallback-svc created
    service/fallback-svc created
    ```
1. Configure an Ingress rule to make it the fallback service to send all requests to it that don't match any of the Ingress rules.

    ```bash
    $ echo "
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: fallback
      annotations:
    spec:
      ingressClassName: kong
      defaultBackend:
        service:
          name: fallback-svc
          port:
            number: 80
    " | kubectl apply -f -
    ```
    The results should look like this:
    ```text
    ingress.networking.k8s.io/fallback created
    ```
## Test the fallback service

    Send a request with a request property that doesn't match any of the defined rules:

    ```bash
    $ curl $PROXY_IP/random-path
    ```
    The results should look like this:
    ```text
    HTTP/1.1 200 OK
    Content-Type: text/plain; charset=utf-8
    Content-Length: 61
    Connection: keep-alive
    X-App-Name: http-echo
    X-App-Version: 0.2.3
    Date: Wed, 20 Sep 2023 09:46:56 GMT
    X-Kong-Upstream-Latency: 16
    X-Kong-Proxy-Latency: 0
    Via: kong/3.3.1

    This is not the path you are looking for. - Fallback service
    ```
    This message is from the fallback service that you deployed.

Create more Ingress rules, some complicated regex based ones and
see how requests that don't match any rules, are forwarded to the
fallback service.

You can also use Kong's request-termination plugin on the `fallback`
Ingress resource to terminate all requests at Kong, without
forwarding them inside the infrastructure.
