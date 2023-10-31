---
title: Enterprise License
type: how-to
purpose: |
  How to get your license and apply it to KIC managed Gateways
---

{{ site.kic_product_name }} can manage {{ site.ee_product_name }} instances. To deploy {{ site.ee_product_name }} create a Kubernetes secret containing your license key and set the `LICENSE_DATA` environment variable on your {{ site.base_gateway }} pods.

## Applying a license

1. Create a file named `license.json` containing your {{site.ee_product_name}} license and store it in a Kubernetes secret:

    ```bash
    kubectl create namespace kong
    kubectl create secret generic kong-enterprise-license --from-file=license=./license.json -n kong
    ```

1. Create a `values.yaml` file:

    ```yaml
    gateway:
      image:
        repository: kong/kong-gateway
      env:
        LICENSE_DATA:
          valueFrom:
            secretKeyRef:
              name: kong-enterprise-license
              key: license
    ```

1. Install {{site.kic_product_name}} and {{ site.base_gateway }} with Helm:

    ```bash
    helm upgrade --install kong kong/ingress -n kong --create-namespace --values ./values.yaml
    ```