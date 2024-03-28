---
title: Enterprise License
type: how-to
purpose: |
  How to get your license and apply it to KIC managed Gateways
---

{{ site.kic_product_name }} can manage {{ site.ee_product_name }} instances. This guide explains how to apply an enterprise license to running Gateways.

{% if_version gte:3.1.x %}
## Applying a license using the KongLicense CRD

{{ site.kic_product_name }} v3.1 introduced a `KongLicense` CRD ([reference](/kubernetes-ingress-controller/{{page.release}}/reference/custom-resources/#konglicense)) that applies a license to {{ site.ee_product_name }} using the Admin API.

1. Create a file named `license.json` containing your {{site.ee_product_name}} license.

1. Create a `KongLicense` object with the `rawLicenseString` field set to your license:

   ```bash
   echo "
   apiVersion: configuration.konghq.com/v1alpha1
   kind: KongLicense
   metadata:
     name: kong-license
   rawLicenseString: '$(cat ./license.json)'
   " | kubectl apply -f -
   ```

1. Verify that {{ site.kic_product_name }} is using the license:

   ```bash
   kubectl describe konglicense kong-license
   ```

   The results should look like this, including the `Programmed` condition with `True` status:

   ```text
   Name:         kong-license
   Namespace:
   Labels:       <none>
   Annotations:  <none>
   API Version:  configuration.konghq.com/v1alpha1
   Enabled:      true
   Kind:         KongLicense
   Metadata:
    Creation Timestamp:  2024-02-06T15:37:58Z
    Generation:          1
    Resource Version:    2888
   Raw License String:   <your-license-string>   
   Status:
    Controllers:
     Conditions:
      Last Transition Time:  2024-02-06T15:37:58Z
      Message:
      Reason:                PickedAsLatest
      Status:                True
      Type:                  Programmed
     Controller Name:        konghq.com/kong-ingress-controller/5b374a9e.konghq.com
   ```

All {{ site.base_gateway }} instances that are configured by the {{ site.kic_product_name }} will have the license provided in `KongLicense` applied. To update your license, update the `KongLicense` resource and {{ site.kic_product_name }} will dynamically propagate it to all {{site.ee_product_name}} instances with no downtime. There is no need to restart your Pods when updating a license.
{% endif_version %}

## Applying a static license

{% if_version gte:3.1.x %}
An alternative option is to use a static license Secret that will be used to populate {{ site.ee_product_name }}'s `KONG_LICENSE_DATA` environment variable. This option allows you to store the license in Kubernetes secrets, but requires a Pod restart when the value of the secret changes.
{% endif_version %}

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
