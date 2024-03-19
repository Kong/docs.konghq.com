---
title: Enterprise License
type: how-to
purpose: |
  How to get your license and apply it to KGO
---

{{ site.kgo_product_name }} can enable enterprise features using the `KongLicense` CRD.

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
     Controller Name:        konghq.com/kong-gateway-operator
   ```
