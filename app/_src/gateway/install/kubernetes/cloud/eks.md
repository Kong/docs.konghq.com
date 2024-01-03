---
title: Amazon EKS
---

Amazon EKS is a supported runtime for {{ site.base_gateway }}.

## Creating an ALB

This guide creates ALBs using the Kubernetes `Ingress` resource. You will need the `aws-load-balancer-controller` [installed in your cluster](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/deploy/installation/) before following this guide.

1. Check that your cluster is running the `aws-load-balancer-controller`

    ```bash
    kubectl get deployments.apps -n kube-system aws-load-balancer-controller
    ```

## Configuring Kong

### Expose the Proxy

> This ingress requires [{{ site.base_gateway }}](/gateway/{{ page.release }}/install/kubernetes/proxy/) to be installed

1. Update your `values-dp.yaml` file and configure the `proxy.ingress` section:

    ```yaml
    proxy:
      enabled: true
      type: NodePort
      ingress:
        enabled: true
        hostname: example.com
        path: /
        pathType: Prefix
        ingressClassName: alb
        annotations:
          alb.ingress.kubernetes.io/load-balancer-name: kong-alb-public
          alb.ingress.kubernetes.io/group.name: demo.kong-group
          alb.ingress.kubernetes.io/target-type: instance
          alb.ingress.kubernetes.io/scheme: internet-facing
          alb.ingress.kubernetes.io/healthcheck-path: /healthz
          alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'
      tls:
        enabled: false
    ```

1. Run `helm upgrade` to update the release.

    ```bash
    helm upgrade kong-dp kong/kong -n kong --values ./values-dp.yaml
    ```

{% if_version gte:3.0.x lte:3.4.x %}
### Expose Developer Portal

> This ingress requires [{{ site.base_gateway }} Dev Portal](/gateway/{{ page.release }}/install/kubernetes/portal/) to be installed

1. Update your `values-portal.yaml` file and configure the `portal.ingress` and `portalapi.ingress` sections:

    ```yaml
    portal:
      enabled: true
      ingress:
        enabled: true
        hostname: portal.example.com
        path: /
        pathType: Prefix
        ingressClassName: alb
        annotations:
          alb.ingress.kubernetes.io/load-balancer-name: kong-alb-public
          alb.ingress.kubernetes.io/group.name: demo.kong-group
          alb.ingress.kubernetes.io/target-type: instance
          alb.ingress.kubernetes.io/scheme: internet-facing
          alb.ingress.kubernetes.io/healthcheck-path: /healthz
          alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'
    portalapi:
      enabled: true
      ingress:
        enabled: true
        hostname: portalapi.example.com
        path: /
        pathType: Prefix
        ingressClassName: alb
        annotations:
          alb.ingress.kubernetes.io/load-balancer-name: kong-alb-public
          alb.ingress.kubernetes.io/group.name: demo.kong-group
          alb.ingress.kubernetes.io/target-type: instance
          alb.ingress.kubernetes.io/scheme: internet-facing
          alb.ingress.kubernetes.io/healthcheck-path: /healthz
          alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'
    ```

1. Run `helm upgrade` to update the release.

    ```bash
    helm upgrade kong-portal kong/kong -n kong --values ./values-portal.yaml
    ```

{% endif_version %}

### Expose the Admin API

> This ingress requires [{{ site.base_gateway }}](/gateway/{{ page.release }}/install/kubernetes/proxy/) to be installed

1. Update your `values-cp.yaml` file and configure the `admin.ingress` section:

    {:.note}
    > If you are testing and do not have a VPN set up for your VPC, you may change the
    > `alb.ingress.kubernetes.io/scheme` annotation to `internet-facing` to add a public IP.
    > This is **not recommended for long running deployments**

    ```yaml
    admin:
      enabled: true
      ingress:
        enabled: true
        hostname: admin.example.com
        path: /
        pathType: Prefix
        ingressClassName: alb
        annotations:
          alb.ingress.kubernetes.io/load-balancer-name: kong-alb-private
          alb.ingress.kubernetes.io/group.name: demo.kong-group-private
          alb.ingress.kubernetes.io/target-type: instance
          alb.ingress.kubernetes.io/scheme: internal
          alb.ingress.kubernetes.io/healthcheck-path: /healthz
          alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'
    ```

1. Run `helm upgrade` to update the release.

    ```bash
    helm upgrade kong-cp kong/kong -n kong --values ./values-cp.yaml
    ```

### Expose Kong Manager

> This ingress requires [Kong Manager](/gateway/{{ page.release }}/install/kubernetes/manager/) to be installed

1. Update your `values-cp.yaml` file and configure the `manager.ingress` section:

    {:.note}
    > If you are testing and do not have a VPN set up for your VPC, you may change the
    > `alb.ingress.kubernetes.io/scheme` annotation to `internet-facing` to add a public IP.
    > This is **not recommended for long running deployments**

    ```yaml
    manager:
      enabled: true
      ingress:
        enabled: true
        hostname: manager.example.com
        path: /
        pathType: Prefix
        ingressClassName: alb
        annotations:
          alb.ingress.kubernetes.io/load-balancer-name: kong-alb-private
          alb.ingress.kubernetes.io/group.name: demo.kong-group-private
          alb.ingress.kubernetes.io/target-type: instance
          alb.ingress.kubernetes.io/scheme: internal
          alb.ingress.kubernetes.io/healthcheck-path: /healthz
          alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'
    ```

1. Run `helm upgrade` to update the release.

    ```bash
    helm upgrade kong-cp kong/kong -n kong --values ./values-cp.yaml
    ```

## Test the Ingress

1. Wait until the `ADDRESS` field is populated for both ingresses.

    ```bash
    kubectl get ingress -n kong
    ```

1. Update your DNS to point to the ALB addresses