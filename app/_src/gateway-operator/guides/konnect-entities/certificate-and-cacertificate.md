---
title: Certificate and CA Certificate
---

In this guide you'll learn how to use the `KongCertificate` and `KongCACertificate` custom resources to
manage Konnect [Certificates](/konnect/gateway-manager/configuration/#certificates)
and CA Certificates natively from your Kubernetes cluster.

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=false version=page.version release=page.release
with-control-plane=true %}

## Create a Certificate

Creating the `KongCertificate` object in your Kubernetes cluster will provision a Konnect Certificate in
your [Gateway Manager](/konnect/gateway-manager).
You can refer to the CR [API](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongcertificate)
to see all the available fields.

Your `KongCertificate` must be associated with a `KonnectGatewayControlPlane` object that you've created in your
cluster.
It will make it part of the Gateway control plane's configuration.

You can create a `KongCertificate` by applying the following YAML manifest:

```yaml
echo '
kind: KongCertificate
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  name: cert
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
  key: | # Sample private key in PEM format, replace with your own
    -----BEGIN PRIVATE KEY-----
    MIIBVAIBADANBgkqhkiG9w0BAQEFAASCAT4wggE6AgEAAkEAyzipjrbAaLO/yPg7
    lL1dLWzhqNdc3S4YNR7f1RG9whWhbsPE2z42e6WGFf9hggP6xjG4qbU8jFVczpd1
    UPwGbQIDAQABAkB4pTPsOMxznDrAWbYtcFovzJMPRIOp/2J5rtGdUcIAxP2rsdqh
    Y1Nj2MV91UPsWjM0OpTD694T5mVR92oTUIvVAiEA7D1L8dCNc4pwZD7tpNLhZVh9
    BhCHPVVQ2RUwBype4FsCIQDcOFV7eD6LWTGLQfCcATr4qYLQ96Xu84F/CyqRIXvu
    1wIhAM3glYDFuaBJs60JUl1kEl4aAcr5OILxCSZGWrbD7C8lAiBtERF1JyaCyVf6
    SlwqR4m3YezCJgTuhXdbPmKEonrI3QIgIh52IOxTS7+ETXY1JjbouTR5irPEWgTM
    +qqDoIn8JJI=
    -----END PRIVATE KEY-----
  ' | kubectl apply -f -
```

{% include md/kgo/check-condition.md name='cert' kind='KongCertificate' %}

At this point, you should see the certificate in the Gateway Manager UI.

### Assign an SNI to the Certificate

You can assign multiple SNIs to a `KongCertificate`. To do so, you need to create a `KongSNI` object and associate it
with
the `KongCertificate`. Please refer to the CR [API](/gateway-operator/{{ page.release
}}/reference/custom-resources/#kongsni)
to see all the available fields.

You can create a `KongSNI` by applying the following YAML manifest:

```yaml
echo '
apiVersion: configuration.konghq.com/v1alpha1
kind: KongSNI
metadata:
  name: example-sni
  namespace: default
spec:
  certificateRef:
    name: cert # Reference to the KongCertificate object
  name: "sni.example.com"
  ' | kubectl apply -f -
```

You can ensure the `KongCertificate` reference is valid by checking the `KongSNI`'s `KongCertificateRefValid` condition.

{% include md/kgo/check-condition.md name='example-sni' kind='KongSNI' conditionType='KongCertificateRefValid' reason='Valid' disableDescription=true %}

{% include md/kgo/check-condition.md name='example-sni' kind='KongSNI' %}

At this point, you should see the SNI in the Certificate's SNIs in the Gateway Manager UI.

## Create a CA Certificate

Creating the `KongCACertificate` object in your Kubernetes cluster will provision a Konnect CA Certificate in
your [Gateway Manager](/konnect/gateway-manager). You can refer to the CR [API](/gateway-operator/{{ page.release
}}/reference/custom-resources/#kongcacertificate) to see all the available fields.

Your `KongCACertificate` must be associated with a `KonnectGatewayControlPlane` object that you've created in your
cluster.

You can create a `KongCACertificate` by applying the following YAML manifest:

```yaml
echo '
kind: KongCACertificate
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  name: ca-cert
  namespace: default
spec:
  controlPlaneRef:
    type: konnectNamespacedRef # This indicates that an in cluster reference is used
    konnectNamespacedRef:
      name: gateway-control-plane # Reference to the KonnectGatewayControlPlane object
  cert: | # Sample CA certificate in PEM format, replace with your own
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

{% include md/kgo/check-condition.md name='ca-cert' kind='KongCACertificate' %}

At this point, you should see the CA Certificate in the Gateway Manager UI.
