---
title: Amazon EKS
---

Amazon EKS is a supported runtime for {{ site.base_gateway }}.

## Configuring Kong

## Creating an ALB

This guide creates ALBs using the Kubernetes `Ingress` resource. You will need the `aws-load-balancer-controller` [installed in your cluster](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.6/deploy/installation/) before following this guide.

1. Check that your cluster is running the `aws-load-balancer-controller`

    ```bash
    kubectl get deployments.apps -n kube-system aws-load-balancer-controller
    ```

1. Create an `alb-public-ingress.yaml` file, replacing `example.com` with your domain.

    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: alb-ingress-public
      namespace: kong
      annotations:
        alb.ingress.kubernetes.io/load-balancer-name: kong-alb-public
        alb.ingress.kubernetes.io/group.name: demo.kong-group
        alb.ingress.kubernetes.io/target-type: instance
        alb.ingress.kubernetes.io/scheme: internet-facing
        alb.ingress.kubernetes.io/healthcheck-path: /healthz
        alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'
    spec:
      ingressClassName: alb
      rules:
        - host: example.com
          http:
            paths:
              - path: /
                pathType: Prefix
                backend:
                  service:
                    name: kong-dp-kong-proxy
                    port:
                      number: 80
    {%- if_version gte:3.0.x lte:3.4.x -%}
        - host: portal.example.com
          http:
            paths:
              - path: /
                pathType: Prefix
                backend:
                  service:
                    name: kong-portal-kong-portal
                    port:
                      number: 8003
        - host: portalapi.example.com
          http:
            paths:
              - path: /
                pathType: Prefix
                backend:
                  service:
                    name: kong-portal-kong-portalapi
                    port:
                      number: 8004
   {% endif_version %}
    ```

1. Create an `alb-private-ingress.yaml` file, replacing `example.com` with your domain.

    {:.note}
    > If you are testing and do not have a VPN set up for your VPC, you may change the
    > `alb.ingress.kubernetes.io/scheme` annotation to `internet-facing` to add a public IP.
    > This is **not recommended for long running deployments**

    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: alb-ingress-private
      namespace: kong
      annotations:
        alb.ingress.kubernetes.io/load-balancer-name: kong-alb-private
        alb.ingress.kubernetes.io/group.name: demo.kong-group-private
        alb.ingress.kubernetes.io/target-type: instance
        alb.ingress.kubernetes.io/scheme: internal
        alb.ingress.kubernetes.io/healthcheck-path: /healthz
        alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'
    spec:
      ingressClassName: alb
      rules:
        - host: manager.example.com
          http:
            paths:
              - path: /
                pathType: Prefix
                backend:
                  service:
                    name: kong-manager-kong-manager
                    port:
                      number: 8002
        - host: admin.example.com
          http:
            paths:
              - path: /
                pathType: Prefix
                backend:
                  service:
                    name: kong-cp-kong-admin
                    port:
                      number: 8001
    ```

1. Create the ALBs using `kubectl apply`

    ```bash
    kubectl apply -f alb-public-ingress.yaml
    kubectl apply -f alb-private-ingress.yaml
    ```

1. Wait until the `ADDRESS` field is populated for both ingresses.

    ```bash
    kubectl get ingress -n kong
    ```

1. Update your DNS to point to the ALB addresses