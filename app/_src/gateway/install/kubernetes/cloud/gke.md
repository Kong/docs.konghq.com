---
title: Google GKE
---

Google GKE is a supported runtime for {{ site.base_gateway }}.

## Prerequisites

This guide creates a Google Cloud load balancer using the Kubernetes `Ingress` resource. Clusters running GKE versions 1.18 and later automatically provision load balancers in response to `Ingress` resources being created.

GKE requires a `BackendConfig` resource to be created for Kong deployments to be marked as healthy.

1. Create a `BackendConfig` [resource](https://cloud.google.com/kubernetes-engine/docs/concepts/ingress#interpreted_hc) to configure health checks.

    ```yaml
    echo "apiVersion: cloud.google.com/v1
    kind: BackendConfig
    metadata:
      name: kong-hc
      namespace: kong
    spec:
      healthCheck:
        checkIntervalSec: 15
        port: 8100
        type: HTTP
        requestPath: /status" | kubectl apply -f -
    ```

## Configuring Kong

{:.important}
> GKE provisions one load balancer per `Ingress` definition. Following this guide will result in multiple load balancers being created.

### Expose the Proxy

> This ingress requires [{{ site.base_gateway }}](/gateway/{{ page.release }}/install/kubernetes/proxy/) to be installed

1. Annotate the `kong-dp-kong-proxy` service to indicate that GKE should use the `kong-hc` `BackendConfig` to configure healthchecks for this service.

    ```bash
    kubectl annotate -n kong service kong-dp-kong-proxy beta.cloud.google.com/backend-config='{"default": "kong-hc"}'
    ```

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
        annotations:
          kubernetes.io/ingress.class: "gce"
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
    > `kubernetes.io/ingress.class` annotation to `gce` to add a public IP.
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
        annotations:
          kubernetes.io/ingress.class: "gce-internal"
    ```

1. Run `helm upgrade` to update the release.

    ```bash
    helm upgrade kong-cp kong/kong -n kong --values ./values-cp.yaml
    ```

1. Annotate the `kong-cp-kong-admin` service to indicate that GKE should use the `kong-hc` `BackendConfig` to configure healthchecks for this service.

    ```bash
    kubectl annotate -n kong service kong-cp-kong-admin beta.cloud.google.com/backend-config='{"default": "kong-hc"}'
    ```

### Expose Kong Manager

> This ingress requires [Kong Manager](/gateway/{{ page.release }}/install/kubernetes/manager/) to be installed

1. Update your `values-cp.yaml` file and configure the `manager.ingress` section:

    {:.note}
    > If you are testing and do not have a VPN set up, you may change the
    > `kubernetes.io/ingress.class` annotation to `gce` to add a public IP.
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
        annotations:
          kubernetes.io/ingress.class: "gce-internal"
    ```

1. Run `helm upgrade` to update the release.

    ```bash
    helm upgrade kong-cp kong/kong -n kong --values ./values-cp.yaml
    ```

1. Annotate the `kong-cp-kong-manager` service to indicate that GKE should use the `kong-hc` `BackendConfig` to configure healthchecks for this service.

    ```bash
    kubectl annotate -n kong service kong-cp-kong-manager beta.cloud.google.com/backend-config='{"default": "kong-hc"}'
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
        annotations:
          kubernetes.io/ingress.class: "gce"
    portalapi:
      enabled: true
      tls:
        enabled: false
      ingress:
        enabled: true
        hostname: portalapi.example.com
        path: /
        pathType: Prefix
        annotations:
          kubernetes.io/ingress.class: "gce"
    ```

1. Run `helm upgrade` to update the release.

    ```bash
    helm upgrade kong-cp kong/kong -n kong --values ./values-cp.yaml
    ```

1. Annotate the `kong-cp-kong-portal` and `kong-cp-kong-portalapi` services to indicate that GKE should use the `kong-hc` `BackendConfig` to configure healthchecks for these services.

    ```bash
    kubectl annotate -n kong service kong-cp-kong-portal beta.cloud.google.com/backend-config='{"default": "kong-hc"}'
    kubectl annotate -n kong service kong-cp-kong-portalapi beta.cloud.google.com/backend-config='{"default": "kong-hc"}'
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