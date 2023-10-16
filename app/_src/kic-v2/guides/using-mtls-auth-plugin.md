---
title: Using mtls-auth plugin
---

This guide walks through how to configure the {{site.kic_product_name}} to
verify client certificates using CA certificates and
[mtls-auth](/hub/kong-inc/mtls-auth/) plugin
for HTTPS requests.

> Note: You need an Enterprise license to use this feature.

{% include_cached /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=true enterprise=true %}

## Provision a CA certificate in Kong

CA certificates in Kong are provisioned by create a `Secret` resource in
Kubernetes.

The secret resource must have a few properties:
- It must have the `konghq.com/ca-cert: "true"` label.
- It must have a `cert` data property which contains a valid CA certificate
  in PEM format.
- It must have an `id` data property which contains a random UUID.
- It must have a `kubernetes.io/ingress.class` annotation whose value matches
  the value of the controller's `--ingress-class` argument. By default, that
  value is `kong`.

Note that a self-signed CA certificate is being used for the purpose of this
guide. You should use your own CA certificate that is backed by
your PKI infrastructure.

To generate self-signed CA certificates using OpenSSL, follow these instructions:

```bash
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365 -nodes\
 -subj "/C=US/ST=California/L=San Francisco/O=Kong/OU=Org/CN=www.example.com"
```

```bash
$ kubectl create secret generic my-ca-cert --from-literal=id=cce8c384-721f-4f58-85dd-50834e3e733a --from-file=cert=./cert.pem
$ kubectl label secret my-ca-cert 'konghq.com/ca-cert=true'
$ kubectl annotate secret my-ca-cert 'kubernetes.io/ingress.class=kong'
secret/my-ca-cert created
secret/my-ca-cert labeled
secret/my-ca-cert annotated
```

Please note the ID, you can use this ID one or use a different one but
the ID is important in the next step when we create the plugin.
Each CA certificate that you create needs a unique ID.
Any random UUID will suffice here and it doesn't have an security
implication.

You can use [uuidgen](https://linux.die.net/man/1/uuidgen) (Linux, OS X) or
[New-Guid](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/new-guid)
(Windows) to generate an ID.

For example:
```bash
$ uuidgen
907821fc-cd09-4186-afb5-0b06530f2524
```

## Configure mtls-auth plugin

Next, we are going to create an `mtls-auth` KongPlugin resource which references
CA certificate provisioned in the last step:

```bash
$ echo "
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: mtls-auth
config:
  ca_certificates:
  - cce8c384-721f-4f58-85dd-50834e3e733a
  skip_consumer_lookup: true
  revocation_check_mode: SKIP
plugin: mtls-auth
" | kubectl apply -f -
kongplugin.configuration.konghq.com/mtls-auth created
```

## Install a dummy service

Let's deploy an echo service which we wish to protect
using TLS client certificate authentication.

```bash
$ kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/echo-service.yaml
```

You can deploy a different service or skip this step if you already
have a service deployed in Kubernetes.

## Set up Ingress

Let's expose the echo service outside the Kubernetes cluster
by defining an Ingress.

```bash
$ echo "
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo
  annotations:
    konghq.com/plugins: mtls-auth
spec:
  ingressClassName: kong
  rules:
  - http:
      paths:
      - path: /foo
        pathType: ImplementationSpecific
        backend:
          service:
            name: echo
            port:
              number: 1027
" | kubectl apply -f -
ingress.extensions/demo created
```

## Test the endpoint

Now, let's test to see if Kong is asking for client certificate
or not when we make the request:

```
$ curl -i -k https://$PROXY_IP/foo
HTTP/2 401
content-type: application/json; charset=utf-8
content-length: 50
x-kong-response-latency: 0
server: kong/2.0.4.0-enterprise-k8s

{"message":"No required TLS certificate was sent"}
```

As we can see, Kong is restricting the request because it doesn't
have the necessary authentication information.

Two things to note here:
- `-k` is used because Kong is set up to serve a self-signed certificate
  by default. For full mutual authentication in production use cases,
  you must configure Kong to serve a certificate that is signed by a trusted CA.
- For some deployments `$PROXY_IP` might contain a port that points to
  `http` port of Kong. In others, it might happen that it contains a DNS name
  instead of an IP address. If needed, please update the
  command to send an `https` request to the `https` port of Kong or
  the load balancer in front of it.


## Provisioning credential
Now, use the key and certificate to authenticate against Kong and use the
service:

```bash
$ curl --key key.pem --cert cert.pem  https://$PROXY_IP/foo -k -I
HTTP/2 200
content-type: text/plain; charset=UTF-8
server: echoserver
x-kong-upstream-latency: 1
x-kong-proxy-latency: 1
via: kong/2.0.4.0-enterprise-k8s
```

## Conclusion

This guide demonstrates how to implement client TLS authentication
using Kong.
You are free to use other features that mtls-auth plugin in Kong to
achieve more complicated use-cases.
