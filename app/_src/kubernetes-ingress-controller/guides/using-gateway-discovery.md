---
title: Using Gateway Discovery
content_type: tutorial
---

Learn to use Gateway Discovery that allows {{site.kic_product_name}} to dynamically detect Gateways while it's running. You can scale Gateway deployment based on the requirements and {{site.kic_product_name}} discovers the instance.

## Before you begin

1. Install [helm v3][helm] to deploy [Kong's helm chart][kong-chart]
1. Install [`stern`][stern-gh] to query the logs of the Pod.
1. Set the environment variable `GATEWAY_RELEASE_NAME` to `gateway`. So that {{site.kic_product_name}} is aware of deployed Gateway(s) you need to provide the name of the Admin service and the Proxy service. These names of these services are derived from the name of the release in helm.



Most of what is covered by this guide refers to Kong's helm chart options
defined in [gateway discovery section][kong-chart-gd].

[helm]: https://helm.sh/
[kong-chart]: https://github.com/Kong/charts/tree/main/charts/kong
[kong-chart-gd]: https://github.com/Kong/charts/tree/main/charts/kong#the-gatewaydiscovery-section
[stern-gh]: https://github.com/stern/stern

## Install {{site.kic_product_name}}

To use Gateway Discovery you need to deploy {{site.kic_product_name}}
so that it knows where to find {{site.base_gateway}}s deployed in the cluster.

As {{site.kic_product_name}} and {{site.base_gateway}} deployments are separate, you
should enable TLS client verification for the Admin API service so that no one
from inside the cluster can access it without a valid certificate. This can be done
by setting `ingressController.adminApi.tls.client.enabled` option in the Helm chart 
to `true`. It will create a CA certificate and a CA-signed certificate for the 
client, and respective Kubernetes TLS Secrets for both.

The CA certificate secret's name can be set with `ingressController.adminApi.tls.client.caSecretName` option. You can use that to have a static name for the CA certificate secret and refer to it in the {{site.base_gateway}} deployment.

{:.note}
> **Note**: It is possible to provide your own certificates for client 
> verification. `ingressController.adminApi.tls.client.certProvided=true`
> and `ingressController.adminApi.tls.client.secretName` can be used 
> for that purpose, in the {{site.kic_product_name}} release, and 
> `admin.tls.client.secretName` or `admin.tls.client.caBundle` in the 
> {{site.base_gateway}} release.
> For more information, see the [helm chart's readme][kong-chart].

1. Deploy controller's helm release.

    ```bash
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

1. Check the status of the deployment using `kubectl get deployment -n kong`.

   The results should look like this
    ```text
    NAME              READY   UP-TO-DATE   AVAILABLE   AGE
    controller-kong   0/2     2            2           1m
    ```

## Install {{site.base_gateway}}

After enabling TLS client verification for the Admin API service, you need to provide a CA
certificate to the {{site.base_gateway}} deployment. You can do that by setting
`admin.tls.client.secretName` to the CA certificate Secret's name, you set this during the deployment of {{site.kic_product_name}}.

1. Deploy {{site.base_gateway}} with 2 replicas, without {{site.kic_product_name}}.

    ```bash
    $ helm upgrade --install gateway kong/kong -n kong --create-namespace \
      --set ingressController.enabled=false \
      --set admin.enabled=true \
      --set admin.type=ClusterIP \
      --set admin.clusterIP=None \
      --set admin.tls.client.secretName=admin-api-ca-cert \
      --set replicaCount=2
    ```
1. Set the environment variable, `$PROXY_IP` to the External IP address of
the `gateway-kong-proxy` service in `kong` namespace.

    ```bash
    $ export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong gateway-kong-proxy)
    ```
1. Check the status of the deployments using `kubectl get deployment -n kong`.
   
   The results should look like this:  
   ```text
    NAME              READY   UP-TO-DATE   AVAILABLE   AGE
    controller-kong   2/2     2            2           1m
    gateway-kong      2/2     2            2           1m
    ```

1. Access the proxy service using `curl $PROXY_IP`.

   The results should look like this:
   ```text
    {"message":"no Route matched with those values"}%
    ```

## Scale the deployments
You can scale both {{site.base_gateway}} and {{site.kic_product_name}} deployments independently. Additional replicas for:
- The controller, stand by to take over when elected leader gets shut down.
- The gateway, share the traffic with the other gateways from the deployment.

1. Scale {{site.base_gateway}} and {{site.kic_product_name}} deployments.

    ```bash
    $ kubectl scale deployment -n kong gateway-kong --replicas 4
    $ kubectl scale deployment -n kong controller-kong --replicas 3
    ```
    The results should look like this:
    ```text
    deployment.apps/gateway-kong scaled
    deployment.apps/controller-kong scaled
    ```

1. Check the status of the deployments using `kubectl get deployment -n kong`.    
    
    The results should look like this:
    ```text
    NAME              READY   UP-TO-DATE   AVAILABLE   AGE
    controller-kong   3/3     3            3           5m
    gateway-kong      4/4     4            4           5m
    ```

## Test the configuration

1. Deploy a simple HTTP Service to verify that the configuration is indeed sent to all the Gateways. 

    ```bash
    kubectl apply -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/v2.11.0/deploy/manifests/httpbin.yaml
    ```
    The results should look like this:

    ```text
    service/httpbin created
    deployment.apps/httpbin created
    ```

1. Setup `Ingress` rules with an `IngressClass`.

    ```bash
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

    The results should look like this:
    ```text
    ingressclass.networking.k8s.io/kong configured
    ingress.networking.k8s.io/echo created
    ```

1. Observe controller logs for entries that indicate successful configuration of all the discovered Gateways.

    ```bash
    $ stern -n kong -lapp=controller-kong --since 1m --include "synced configuration"
    ```
    The results should look like this:
    ```text
    ...
    controller-kong-545d798874-q6h7m ingress-controller time="2023-03-02T15:11:42Z" level=info msg="successfully synced configuration to kong" kong_url="https://10.244.0.29:8444"
    controller-kong-545d798874-q6h7m ingress-controller time="2023-03-02T15:11:42Z" level=info msg="successfully synced configuration to kong" kong_url="https://10.244.0.15:8444"
    controller-kong-545d798874-q6h7m ingress-controller time="2023-03-02T15:11:42Z" level=info msg="successfully synced configuration to kong" kong_url="https://10.244.0.16:8444"
    controller-kong-545d798874-q6h7m ingress-controller time="2023-03-02T15:11:42Z" level=info msg="successfully synced configuration to kong" kong_url="https://10.244.0.30:8444"
    ```

1. Access the `/echo` endpoint from the `htptbin` service.

    ```bash
    $ curl -i http://kong.example/echo --resolve kong.example:80:$PROXY_IP
    ```
    The results should look like this:
    ```text
    <!DOCTYPE html>
    <html lang="en">
    
    <head>
    ...
    ```

    Through the Kubernetes Service, the traffic is load balanced across all Gateway Pods that back the proxy service.

1. Check the Gateway logs after issuing several queries against that service.
    ```bash
    $ stern -n kong -lapp=gateway-kong --since 1m --include "/echo"
    ```
    The results should look like this:
    ```text
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

    In Gateway logs you can see that all Pods proxy the traffic as configured. The first column in the log contains the Pod name.
