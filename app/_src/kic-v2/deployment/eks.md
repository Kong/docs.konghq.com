---
title: Kong Ingress on Elastic Kubernetes Service (EKS)
---

## Requirements

1. A fully functional EKS cluster.
   Please follow Amazon's Guide to
   [set up an EKS cluster](https://aws.amazon.com/getting-started/projects/deploy-kubernetes-app-amazon-eks/).
2. Basic understanding of Kubernetes
3. A working `kubectl`  linked to the EKS Kubernetes
   cluster we will work on. The above EKS setup guide will help
   you set this up.

{% include_cached /md/kic/deploy-kic.md version=page.version %}

## Setup environment variables

Next, create an environment variable with the IP address at which
Kong is accessible. This IP address sends requests to the
Kubernetes cluster.

Execute the following command to get the IP address at which Kong is accessible:

```bash
$ kubectl get services -n kong
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP                           PORT(S)                      AGE
kong-proxy   LoadBalancer   10.63.250.199   example.eu-west-1.elb.amazonaws.com   80:31929/TCP,443:31408/TCP   57d
```

Create an environment variable to hold the ELB hostname:

```bash
$ export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].hostname}" service -n kong kong-proxy)
```

> Note: It may take some time for Amazon to actually associate the
IP address to the `kong-proxy` Service.

Once you've installed the {{site.kic_product_name}}, please follow our
[getting started](/kubernetes-ingress-controller/{{page.release}}/guides/getting-started) tutorial to learn
about how to use the Ingress Controller.

## TLS configuration

Versions of Kong prior to 2.0.0 default to using [the "modern" cipher suite
list](https://wiki.mozilla.org/Security/Server_Side_TLS). This is not
compatible with ELBs when the ELB terminates TLS at the edge and establishes a
new session with Kong. This error will appear in Kong's logs:

```
*7961 SSL_do_handshake() failed (SSL: error:1417A0C1:SSL routines:tls_post_process_client_hello:no shared cipher) while SSL handshaking
```

To correct this issue, set `KONG_SSL_CIPHER_SUITE=intermediate` in your
environment variables.
