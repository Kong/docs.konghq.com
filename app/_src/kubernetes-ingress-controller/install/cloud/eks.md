---
title: Amazon EKS
type: reference
purpose: |
  Additional information needed to install KIC on Amazon EKS
---

## Prerequisites

* [Set up an EKS cluster](https://aws.amazon.com/getting-started/projects/deploy-kubernetes-app-amazon-eks/).
* Inatall `kubectl` and connect to the EKS Kubernetes cluster. 

{% include_cached /md/kic/deploy-kic.md version=page.version %}

## Setup environment variables

Create an environment variable with the IP address at which Kong is accessible. This IP address sends requests to the
Kubernetes cluster.

1. Get the IP address at which Kong is accessible:

    ```bash
    $ kubectl get services -n kong
    ```
   The results should look like this:
   ```text
   NAME         TYPE           CLUSTER-IP      EXTERNAL-IP                           PORT(S)                      AGE
   kong-proxy   LoadBalancer   10.63.250.199   example.eu-west-1.elb.amazonaws.com   80:31929/TCP,443:31408/TCP   57d
   ```
1. Create an environment variable to hold the ELB hostname:

    ```bash
    $ export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].hostname}" service -n kong kong-gateway-proxy)
    ```

> Note: It may take some time for Amazon to associate the IP address to the `kong-gateway-proxy` Service.

After you've installed the {{site.kic_product_name}}, learn to use Ingress Controller, see the [getting started](/kubernetes-ingress-controller/{{page.kong_version}}/guides/getting-started) tutorial.

## Troubleshooting

In versions of Kong earlier than 2.0.0 default to using [the "modern" cipher suite
list](https://wiki.mozilla.org/Security/Server_Side_TLS). This is not compatible with ELBs when the ELB terminates TLS at the edge and establishes a new session with Kong. This error appears in the logs:

```
*7961 SSL_do_handshake() failed (SSL: error:1417A0C1:SSL routines:tls_post_process_client_hello:no shared cipher) while SSL handshaking
```

The solution is to set `KONG_SSL_CIPHER_SUITE=intermediate` in your environment variables.
