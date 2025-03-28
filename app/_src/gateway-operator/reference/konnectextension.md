---
title: Overview
---

Kong Dataplane instances can be configured in Konnect by means of the [`KonnectExtension`][konnect_extension_crd] resource. This resource can be used to provision isolated `DataPlane`s or pairs of `ControlPlane`s  and `DataPlane`s. The `KonnectExtension` resource can be referenced by `ControlPlane`s, `DataPlane`s, or `GatewayConfiguration`s from the extension point in their spec. Dedicated guides will guide you to through these kinds of setup.

[konnect_extension_crd]: /gateway-operator/{{page.release}}/reference/custom-resources/#konnectextension-1

## Konnect ControlPlane reference

`KonnectExtension` can be attached to Konnect `ControlPlane`s of type Hybrid or KIC. This reference can be performed in two different ways: via Konnect ID or via Kubernetes object reference to an in cluster `KonnectGatewayControlPlane`.

### Reference by Konnect ID

The Konnect ControlPlane can be referenced by its ID, without having any `KonnectGatewayControlPlane` resource deployed in the cluster. The ControlPlane ID can be fetched by the Konnect UI, in the ControlPlane page. Whit this configuration, the `KonnectExtension` object requires to have the `konnect.configuration.authref` field set, as follows in the snippet below:

```yaml
spec:
  konnect:
    controlPlane:
      ref:
        type: konnectID
        konnectID: a6554c4c-79a6-4db7-b7a4-201c0cf746ba # The Konnect controlPlane ID
    configuration:
      authRef:
        name: konnect-api-auth # Reference to the KonnectAPIAuthConfiguration object
```

The `authRef.name` fields refers to an object of type [`KonnectAPIAuthConfiguration`][konnect_api_auth_crdref] that needs to exist in the same namespace as the `KonnectExtension`. Such objects contains all the data (server, token, etc.) to interact with konnect.

[konnect_api_auth_crdref]: /gateway-operator/{{page.release}}/reference/custom-resources/#konnectapiauthconfiguration

### Reference By Kubernetes object

Alternatively, the `KonnectExtension` can reference an object in the cluster. This reference allows to attach the `DataPlane`s to the Konnect ControlPlane via a local object [(a.k.a. `KonnectGatewayControlPlane`)](/gateway-operator/{{page.release}}/guides/konnect-entities/gatewaycontrolplane). When this type of reference is used, the `KonnectAPIAuthConfiguration` data is inferred by the `KonnectGatewayControlPlane` objects. For this reason, it's not possible to set the `konnect.configuration.authref` field in this scenario.

```yaml
spec:
  konnect:
    controlPlane:
      ref:
        type: konnectNamespacedRef
        konnectNamespacedRef:
          name: gateway-control-plane # The KonnectGatewayControlPlane resource name
```

## DataPlane authentication

The `DataPlane`, in order to be configured in Konnect, needs a client certificate. This certificate can be manually created and managed by the user, or automatically provisioned by KGO.

### Manual certificate provisioning

In order to manually create and set up a certificate to be used for Konnect `DataPlane`s, you can perform type the following commands:

1. Generate a new certificate and key:

    ```bash
    openssl req -new -x509 -nodes -newkey rsa:2048 -subj "/CN=kongdp/C=US" -keyout ./tls.key -out ./tls.crt
    ```

1. Create a Kubernetes secret that contains the previously created certificate:

    ```bash
    kubectl create secret tls konnect-client-tls --cert=./tls.crt --key=./tls.key
    ```

1. Label the secret to tell KGO to reconcile it:

    ```bash
    kubectl label secret konnect-client-tls konghq.com/konnect-dp-cert=true
    ```

Once the secret containing your certificate has been created in the cluster, you can set up your `KonnectExtension` as follows:

```yaml
spec:
  clientAuth:
    certificateSecret:
      provisioning: Manual
        secretRef:
          name: konnect-client-tls # The name of the secret containing your certificate
```

### Automatic certificate provisioning

Alternatively, you can leave the certificate provisioning and management to KGO, which will take care of creating a new certificate, write it into a Kubernetes `Secret` and manage the `Secret`'s lifecycle on behalf of you. To do so, you can configure a `KonnectExtension` as follows:

```yaml
spec:
  clientAuth:
    certificateSecret:
      provisioning: Automatic
```

or you can just leave the `spec.clientAuth` field empty, and the automatic provisioning will be automatically defaulted.

## DataPlane labels

Multiple labels can be configured to the Konnect `DataPlane` via the following field:

```yaml
spec:
  konnect:
    dataPlane:
      foo: bar
      foo2: bar2
```

Please note that the amount of labels that can be set on `DataPlane`s via `KonnectExtension` is limited to 5.
