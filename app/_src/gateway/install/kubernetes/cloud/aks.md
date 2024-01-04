---
title: Azure AKS
---

Azure AKS is a supported runtime for {{ site.base_gateway }}.

## Creating an Azure Application Gateway

This guide creates Azure Application Gateways using the Kubernetes `Ingress` resource. You will need the `application-gateway-kubernetes-ingress` [installed in your cluster](https://azure.github.io/application-gateway-kubernetes-ingress/setup/install-new/) before following this guide.

1. Check that your cluster is running the `ingress-appgw-deployment`

    ```bash
    kubectl get deployments.apps -n kube-system ingress-appgw-deployment
    ```

## Configuring Kong

### Expose the Proxy

> This ingress requires [{{ site.base_gateway }}](/gateway/{{ page.release }}/install/kubernetes/proxy/) to be installed

1. Update your `values-dp.yaml` file and configure the `proxy.ingress` section:

    ```yaml
    proxy:
      enabled: true
      tls:
        enabled: false
      type: NodePort
      ingress:
        enabled: true
        hostname: example.com
        path: /
        pathType: Prefix
        ingressClassName: azure-application-gateway
        annotations:
          appgw.ingress.kubernetes.io/use-private-ip: "false"
    ```

1. Run `helm upgrade` to update the release.

    ```bash
    helm upgrade kong-dp kong/kong -n kong --values ./values-dp.yaml
    ```

### Expose the Admin API

> This ingress requires [{{ site.base_gateway }}](/gateway/{{ page.release }}/install/kubernetes/proxy/) to be installed

1. Update your `values-cp.yaml` file and configure the `admin.ingress` section:

    {:.note}
    > If you are testing and do not have a VPN set up, you may change the
    > `appgw.ingress.kubernetes.io/use-private-ip` annotation to `false` to add a public IP.
    > This is **not recommended for long running deployments**

    ```yaml
    admin:
      enabled: true
      http:
        enabled: true
      tls:
        enabled: false
      ingress:
        enabled: true
        hostname: admin.example.com
        path: /
        pathType: Prefix
        ingressClassName: azure-application-gateway
        annotations:
          appgw.ingress.kubernetes.io/use-private-ip: "true"
    ```

1. Run `helm upgrade` to update the release.

    ```bash
    helm upgrade kong-cp kong/kong -n kong --values ./values-cp.yaml
    ```

### Expose Kong Manager

> This ingress requires [Kong Manager](/gateway/{{ page.release }}/install/kubernetes/manager/) to be installed

1. Update your `values-cp.yaml` file and configure the `manager.ingress` section:

    {:.note}
    > If you are testing and do not have a VPN set up, you may change the
    > `appgw.ingress.kubernetes.io/use-private-ip` annotation to `false` to add a public IP.
    > This is **not recommended for long running deployments**

    ```yaml
    manager:
      enabled: true
      tls:
        enabled: false
      ingress:
        enabled: true
        hostname: manager.example.com
        path: /
        pathType: Prefix
        ingressClassName: azure-application-gateway
        annotations:
          appgw.ingress.kubernetes.io/use-private-ip: "true"
    ```

1. Run `helm upgrade` to update the release.

    ```bash
    helm upgrade kong-cp kong/kong -n kong --values ./values-cp.yaml
    ```


{% if_version gte:3.0.x lte:3.4.x %}
### Expose Developer Portal

This ingress requires [{{ site.base_gateway }} Dev Portal](/gateway/{{ page.release }}/install/kubernetes/portal/) to be installed

{:.important}
> Only enable the `portal` and `portalapi` services if you intend to use the Kong Developer Portal.

1. Update your `values-cp.yaml` file and configure the `portal.ingress` and `portalapi.ingress` sections:

    ```yaml
    portal:
      enabled: true
      tls:
        enabled: false
      ingress:
        enabled: true
        hostname: portal.example.com
        path: /
        pathType: Prefix
        ingressClassName: azure-application-gateway
        annotations:
          appgw.ingress.kubernetes.io/use-private-ip: "false"
    portalapi:
      enabled: true
      tls:
        enabled: false
      ingress:
        enabled: true
        hostname: portalapi.example.com
        path: /
        pathType: Prefix
        ingressClassName: azure-application-gateway
        annotations:
          appgw.ingress.kubernetes.io/use-private-ip: "false"
    ```

1. Run `helm upgrade` to update the release.

    ```bash
    helm upgrade kong-cp kong/kong -n kong --values ./values-cp.yaml
    ```

{% endif_version %}

## Test the Ingress

1. Wait until the `ADDRESS` field is populated for all ingresses.

    ```bash
    kubectl get ingress -n kong
    ```

1. Update your DNS to point to the Azure Application Gateway addresses

1. Make a request to the admin API endpoint to view your Control Plane configuration.

  ```
  curl http://admin.example.com/
  ```