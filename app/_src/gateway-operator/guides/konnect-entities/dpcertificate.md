---
title: Data Plane Client Certificate
---

In this guide you'll learn how to use the `KongDataPlaneClientCertificate` custom resource to manage
Konnect [Vault](/konnect/gateway-manager/configuration/#vaults) natively from your Kubernetes cluster.

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=false version=page.version release=page.release
with-control-plane=true %}

## Create a Data Plane Client Certificate 

Creating the `KongDataPlaneClientCertificate` object in your Kubernetes cluster will provision a Data Plane Client Certificate in
your [Gateway Manager](/konnect/gateway-manager). You can refer to the CR [API](/gateway-operator/{{ page.release
}}/reference/custom-resources/#kongdataplaneclientcertificate) to see all the available fields.

Your `KongDataPlaneClientCertificate` must be associated with a `KonnectGatewayControlPlane` object that you've created in your cluster.
It will make it part of the Gateway Control Plane's configuration.

To create a `KongDataPlaneClientCertificate`, you can apply the following YAML manifest:

```yaml
echo '
kind: KongDataPlaneClientCertificate
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  name: dp-cert
  namespace: default
spec:
  controlPlaneRef:
    type: konnectNamespacedRef # This indicates that an in cluster reference is used
    konnectNamespacedRef:
      name: gateway-control-plane # Reference to the KonnectGatewayControlPlane object
  cert: | # Sample certificate in PEM format, replace with your own
      -----BEGIN CERTIFICATE-----
      MIIB4TCCAYugAwIBAgIUAenxUyPjkSLCe2BQXoBMBacqgLowDQYJKoZIhvcNAQEL
      BQAwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoM
      GEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDAeFw0yNDEwMjgyMDA3NDlaFw0zNDEw
      MjYyMDA3NDlaMEUxCzAJBgNVBAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEw
      HwYDVQQKDBhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGQwXDANBgkqhkiG9w0BAQEF
      AANLADBIAkEAyzipjrbAaLO/yPg7lL1dLWzhqNdc3S4YNR7f1RG9whWhbsPE2z42
      e6WGFf9hggP6xjG4qbU8jFVczpd1UPwGbQIDAQABo1MwUTAdBgNVHQ4EFgQUkPPB
      ghj+iHOHAKJlC1gLbKT/ZHQwHwYDVR0jBBgwFoAUkPPBghj+iHOHAKJlC1gLbKT/
      ZHQwDwYDVR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQsFAANBALfy49GvA2ld+u+G
      Koxa8kCt7uywoqu0hfbBfUT4HqmXPvsuhz8RinE5ltxId108vtDNlD/+bKl+N5Ub
      qKjBs0k=
      -----END CERTIFICATE-----
  ' | kubectl apply -f -
```

You can verify the `KongDataPlaneClientCertificate` was reconciled successfully by checking its `Programmed` condition.

```shell
kubectl get kongdataplaneclientcertificate dp-cert -o=jsonpath='{.status.conditions}' | jq '.[] | select(.type == "Programmed")'
```

The output should look similar to this:

```console
{
  "observedGeneration": 1,
  "reason": "Programmed",
  "status": "True",
  "type": "Programmed"
}
```

At this point, you should see the Data Plane Client Certificate in the Gateway Manager UI.
