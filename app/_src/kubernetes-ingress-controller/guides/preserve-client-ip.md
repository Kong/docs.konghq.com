---
title: Preserving Client IP Address
---

Kong is usually deployed behind a Load Balancer (using a
Kubernetes Service of type `LoadBalancer`). This can result
in loss of actual Client IP address and Kong observing the IP address
of the Load Balancer as the client IP address. This guide lays
out different methods of solving this problem.

Preserving the Client IP address in cloud behind Load-Balancers requires
configuration that is be specific to your use-case, cloud provider
and other architecture details.
[This document](https://kubernetes.io/docs/tutorials/services/source-ip/)
provides details on how networking works inside Kubernetes and explains
in detail of how various methods describe later in this document work.
It is recommended that you give this a read.

Following methods are possible to preserve Client IP address:

## ExternalTrafficPolicy: Local

As explained in
[Kubernetes docs](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip),
setting `service.spec.externalTrafficPolicy` to `Local` preserves the Client
IP address. You don't need to change any configuration in Kong if you
are using this method to preserve Client IP address.

Please note that this is not supported by all of the public Cloud providers.

## Proxy Protocol

If you have an L4 Load Balancer that supports Proxy Protocol, and you're
terminating TCP connections at the Load Balancer before passing traffic
onward to Kong, then you can configure Kong to pick up the Client IP
address via this protocol.

Once you have configured the Load Balancer to use Proxy Protocol, you
need to set the following environment variables in Kong for Kong to
receive the Client IP from the Proxy Protocol header.

- [`KONG_TRUSTED_IPS`](/gateway/latest/reference/configuration/#trusted_ips)
- [`KONG_PROXY_LISTEN`](/gateway/latest/reference/configuration/#proxy_listen)
- [`KONG_REAL_IP_HEADER`](/gateway/latest/reference/configuration/#real_ip_header)

For example:

```
KONG_TRUSTED_IPS=0.0.0.0/0,::/0  # This trusts all IPs
KONG_PROXY_LISTEN="0.0.0.0:8000 proxy_protocol, 0.0.0.0:8443 ssl proxy_protocol"
KONG_REAL_IP_HEADER=proxy_protocol
```

## HTTP headers

If you are using an L7 Load Balancer, i.e. HTTP requests are being terminated
at the Load Balancer, then you need to use `x-forwarded-for` or `x-real-ip`
header to preserve details of the connection between the Client and Load Balancer.

You should configure the Load Balancer to inject these headers, and then
you need to set the following environment variables in Kong for Kong to pick up
the Client IP address from HTTP headers:

- [`KONG_TRUSTED_IPS`](/gateway/latest/reference/configuration/#trusted_ips)
- [`KONG_REAL_IP_HEADER`](/gateway/latest/reference/configuration/#real_ip_header)
- Optional [`KONG_REAL_IP_RECURSIVE`](/gateway/latest/reference/configuration/#real_ip_recursive)

Please note that if you are using an L7 Load Balancer with Kong,
you cannot use the `certificates` feature in Kong as the TLS session is
already established between the Client and Load Balancer.

## Cloud-provider specific details

For the major public clouds, follow are some additional
details that can help you preserve the client IP address:

### GKE

You can use `ExternalTrafficPolicy: Local` to preserve the Client IP address.

### AKS

You can use `ExternalTrafficPolicy: Local` to preserve the Client IP address.

### EKS

You have three options:

- L4 Network Load Balancer, with [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller): 
  In this case, you can use the Proxy Protocol method to preserve the client IP
  address together with `ExternalTrafficPolicy: Cluster`.
- L4 in-tree network Load Balancer with the `service.beta.kubernetes.io/aws-load-balancer-type: nlb` annotation: 
  In this case you need to use `ExternalTrafficPolicy: Local` to preserve the client IP address.
- L7 Load Balancer: 
  In this case, you need to use the HTTP headers method to preserve the client
  IP address.

The recommended Load Balancer type for AWS is the Network Load Balancer deployed with the AWS Load Balancer Controller. 
You can choose this type of Load Balancer using the following annotations:

```
service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
service.beta.kubernetes.io/aws-load-balancer-type: "external"
service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: "instance"
```

To enable proxy protocol with the AWS Load Balancer Controller, you need to set the following annotations:

```
service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: "*"
```

A list of annotations for the AWS Load Balancer Controller can be found
[here](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/guide/service/annotations/).
