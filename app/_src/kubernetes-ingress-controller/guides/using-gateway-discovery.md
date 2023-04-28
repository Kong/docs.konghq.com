---
title: Using Gateway Discovery
content_type: tutorial
---

## Prerequisites

This guide will use [helm v3][helm] to deploy [Kong's helm chart][kong-chart]
with Kong and {{site.kic_product_name}}.

With helm v3 installed we can run:

```terminal
$ helm repo add kong https://charts.konghq.com
$ helm repo update
```

to get Kong's chart in its latest version.

Most of what is covered by this guide refers to Kong's helm chart options
defined in [gateway discovery section][kong-chart-gd].

This guide will be also using [`stern`][stern-gh] for easy pod logs querying.

[helm]: https://helm.sh/
[kong-chart]: https://github.com/Kong/charts/tree/main/charts/kong
[kong-chart-gd]: https://github.com/Kong/charts/tree/main/charts/kong#the-gatewaydiscovery-section
[stern-gh]: https://github.com/stern/stern

## Installation

In order to use Gateway Discovery we need to deploy {{site.kic_product_name}}
so that it knows where to find {{site.base_gateway}}s deployed in the cluster.

### {{site.kic_product_name}}

In order to make KIC aware of deployed Gateway(s) we need to provide the name of
the Admin service as well as the Proxy service.

This is being derived from the helm release name. Let's store it in a variable so
that we can use it in helm installation steps:

```terminal
$ export GATEWAY_RELEASE_NAME=gateway
```

As {{site.kic_product_name}} and {{site.base_gateway}} deployments are separate, you
should enable TLS client verification for the Admin API service so that no one
from inside the cluster can access it without a valid certificate. This can be done
by setting `ingressController.adminApi.tls.client.enabled` option in the Helm chart 
to `true`. It will create a CA certificate and a CA-signed certificate for the 
client, and respective Kubernetes TLS Secrets for both.

The CA certificate secret's name can be set
with `ingressController.adminApi.tls.client.caSecretName` option. We will use that
to have a static name for the CA certificate secret, so that we can refer to it in the
{{site.base_gateway}} deployment.

{:.note}
> **Note**: It is possible to provide your own certificates for client 
> verification. `ingressController.adminApi.tls.client.certProvided=true`
> and `ingressController.adminApi.tls.client.secretName` can be used 
> for that purpose, in the {{site.kic_product_name}} release, and 
> `admin.tls.client.secretName` or `admin.tls.client.caBundle` in the 
> {{site.base_gateway}} release.
> For more information, see the [helm chart's readme][kong-chart].

Now we're ready to deploy controller's helm release:

```sh
$ helm upgrade --install controller kong/kong -n kong --create-namespace \
  --set ingressController.enabled=true \
  --set ingressController.gatewayDiscovery.enabled=true \
  --set ingressController.gatewayDiscovery.adminApiService.name=${GATEWAY_RELEASE_NAME}-kong-admin \
  --set ingressController.adminApi.tls.client.enabled=true \
  --set ingressController.adminApi.tls.client.caSecretName=admin-api-ca-cert \
  --set deployment.kong.enabled=false \
  --set proxy.nameOverride=${GATEWAY_RELEASE_NAME}-kong-proxy \
  --set replicaCount=2
```

At this point you should be able to see a {{site.kic_product_name}} deployment with 
2 replicas, waiting for {{site.base_gateway}} to be deployed:

```sh
$ kubectl get deployment -n kong
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
controller-kong   0/2     2            2           1m
```

### {{site.base_gateway}}

After enabling TLS client verification for the Admin API service, you need to provide a CA
certificate to the {{site.base_gateway}} deployment. You can do that by setting
`admin.tls.client.secretName` to the CA certificate Secret's name, which was set in the
{{site.kic_product_name}} deployment.

Now you can deploy {{site.base_gateway}}. In order to do that we can run:

```terminal
$ helm upgrade --install gateway kong/kong -n kong --create-namespace \
  --set ingressController.enabled=false \
  --set admin.enabled=true \
  --set admin.type=ClusterIP \
  --set admin.clusterIP=None \
  --set admin.tls.client.secretName=admin-api-ca-cert \
  --set replicaCount=2
```

which will deploy {{site.base_gateway}} with 2 replicas, without {{site.kic_product_name}}.

Once installed, set an environment variable, `$PROXY_IP` with the External IP address of
the `gateway-kong-proxy` service in `kong` namespace:

```sh
$ export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong gateway-kong-proxy)
```

At this point you should be able to see both deployments ready:

```sh
$ kubectl get deployment -n kong
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
controller-kong   2/2     2            2           1m
gateway-kong      2/2     2            2           1m
```

You can also access the proxy service now:

```sh
$ curl $PROXY_IP
{"message":"no Route matched with those values"}%
```

## Scaling deployments

Both {{site.base_gateway}}'s and {{site.kic_product_name}}'s deployments can be scaled
independently.

Additional replicas, will:

- In case of the controller, stand by to take over when elected leader gets shut down.
- In case of the gateway, share the traffic with the other gateways from the deployment.

We can test scaling those 2 deployments by invoking:

```sh
$ kubectl scale deployment -n kong gateway-kong --replicas 4
$ kubectl scale deployment -n kong controller-kong --replicas 3
```

At this point we should see 4 instances of gateway and 3 instances of controller:

```sh
$ kubectl get deployment -n kong
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
controller-kong   3/3     3            3           5m
gateway-kong      4/4     4            4           5m
```

## Testing configuration

In order to verify that the configuration is indeed sent to all the Gateways we
can deploy a simple HTTP Service:

```yaml
echo "
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpbin
  labels:
    app: httpbin
spec:
  selector:
    matchLabels:
      app: httpbin
  template:
    metadata:
      labels:
        app: httpbin
    spec:
      containers:
      - name: httpbin
        image: kong/httpbin:0.1.0
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: httpbin
  name: httpbin
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: httpbin
  type: ClusterIP
" | kubectl apply -f -
```

with an `Ingress` with an `IngressClass`:

```yaml
echo "
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: kong
spec:
  controller: ingress-controllers.konghq.com/kong
 ---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: echo
  annotations:
    konghq.com/strip-path: 'true'
spec:
  ingressClassName: kong
  rules:
  - host: kong.example
    http:
      paths:
      - path: /echo
        pathType: Prefix
        backend:
          service:
            name: httpbin
            port:
              number: 80
" | kubectl apply -f -
```

With those manifests applied we can observe controller logs for entries that
indicate successful configuration of all the discovered Gateways:

```sh
$ stern -n kong -lapp=controller-kong --since 1m --include "synced configuration"
...
controller-kong-545d798874-q6h7m ingress-controller time="2023-03-02T15:11:42Z" level=info msg="successfully synced configuration to kong" kong_url="https://10.244.0.29:8444"
controller-kong-545d798874-q6h7m ingress-controller time="2023-03-02T15:11:42Z" level=info msg="successfully synced configuration to kong" kong_url="https://10.244.0.15:8444"
controller-kong-545d798874-q6h7m ingress-controller time="2023-03-02T15:11:42Z" level=info msg="successfully synced configuration to kong" kong_url="https://10.244.0.16:8444"
controller-kong-545d798874-q6h7m ingress-controller time="2023-03-02T15:11:42Z" level=info msg="successfully synced configuration to kong" kong_url="https://10.244.0.30:8444"
```

At this point we should be able to access the `/echo` endpoint from our `htptbin` service:

```sh
$ curl -i http://kong.example/echo --resolve kong.example:80:$PROXY_IP
<!DOCTYPE html>
<html lang="en">

<head>
...
```

Through the means of Kubernetes Service, the traffic is load balanced across
all Gateway pods that back the proxy service.

After issuing several queries against that service we can see in Gateway logs
that we're hitting all Pods which proxy the traffic as configured (mark the first
column that contains the pod name):

```sh
$ stern -n kong -lapp=gateway-kong --since 1m --include "/echo"
gateway-kong-5c98495ff7-rnq5c proxy 10.244.0.1 - - [02/Mar/2023:15:16:09 +0000] "GET /echo HTTP/1.1" 200 9593 "-" "curl/7.86.0"
gateway-kong-5c98495ff7-s6rcw proxy 10.244.0.1 - - [02/Mar/2023:15:16:09 +0000] "GET /echo HTTP/1.1" 200 9593 "-" "curl/7.86.0"
gateway-kong-5c98495ff7-fdmz4 proxy 10.244.0.1 - - [02/Mar/2023:15:16:09 +0000] "GET /echo HTTP/1.1" 200 9593 "-" "curl/7.86.0"
gateway-kong-5c98495ff7-hx77j proxy 10.244.0.1 - - [02/Mar/2023:15:16:10 +0000] "GET /echo HTTP/1.1" 200 9593 "-" "curl/7.86.0"
gateway-kong-5c98495ff7-s6rcw proxy 10.244.0.1 - - [02/Mar/2023:15:16:10 +0000] "GET /echo HTTP/1.1" 200 9593 "-" "curl/7.86.0"
gateway-kong-5c98495ff7-fdmz4 proxy 10.244.0.1 - - [02/Mar/2023:15:16:10 +0000] "GET /echo HTTP/1.1" 200 9593 "-" "curl/7.86.0"
gateway-kong-5c98495ff7-fdmz4 proxy 10.244.0.1 - - [02/Mar/2023:15:16:10 +0000] "GET /echo HTTP/1.1" 200 9593 "-" "curl/7.86.0"
gateway-kong-5c98495ff7-rnq5c proxy 10.244.0.1 - - [02/Mar/2023:15:16:11 +0000] "GET /echo HTTP/1.1" 200 9593 "-" "curl/7.86.0"
gateway-kong-5c98495ff7-fdmz4 proxy 10.244.0.1 - - [02/Mar/2023:15:16:11 +0000] "GET /echo HTTP/1.1" 200 9593 "-" "curl/7.86.0"
gateway-kong-5c98495ff7-hx77j proxy 10.244.0.1 - - [02/Mar/2023:15:16:12 +0000] "GET /echo HTTP/1.1" 200 9593 "-" "curl/7.86.0"
gateway-kong-5c98495ff7-hx77j proxy 10.244.0.1 - - [02/Mar/2023:15:16:12 +0000] "GET /echo HTTP/1.1" 200 9593 "-" "curl/7.86.0"
```
