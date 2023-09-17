---
title: Configuring a fallback service
---

This guide walks through how to setup a fallback service using Ingress
resource. The fallback service will receive all requests that don't
match against any of the defined Ingress rules.
This can be useful for scenarios where you would like to return a 404 page
to the end user if the user clicks on a dead link or inputs an incorrect URL.

{% include_cached /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=true %}

## Setup a Sample Service

{% include_cached /md/kic/http-test-service.md skip_title=true %}

Create an Ingress rule to proxy the echo service we just created:

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
ingress.extensions/demo created
```

Test the Ingress rule:

```bash
$ curl -i $PROXY_IP/echo
```

```bash
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

Let's deploy another sample service service:

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

Result:

```bash
deployment.apps/fallback-svc created
service/fallback-svc created
```

Next, let's set up an Ingress rule to make it the fallback service
to send all requests to it that don't match any of our Ingress rules:

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

## Test it

Now send a request with a request property that doesn't match against
any of the defined rules:

```bash
$ curl $PROXY_IP/random-path
This is not the path you are looking for. - Fallback service
```

The above message comes from the fallback service that was deployed in the
last step.

Create more Ingress rules, some complicated regex based ones and
see how requests that don't match any rules, are forwarded to the
fallback service.

You can also use Kong's request-termination plugin on the `fallback`
Ingress resource to terminate all requests at Kong, without
forwarding them inside your infrastructure.
