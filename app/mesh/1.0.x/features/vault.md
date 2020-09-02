---
title: Kong Mesh - Vault Policy
no_search: true
redirect_from: "/mesh/1.0.x/features/"
---

## Vault CA Backend

The default [mTLS policy](https://kuma.io/docs/latest/policies/mutual-tls/) supports three backends:

* `builtin`: {{site.mesh_product_name}} automatically generates a CA root certificate and key that will be used to generate the data plane certificates.
* `provided`: the CA root certificate and key can be provided by the user.

This feature adds one more mTLS backend mode:

* `vault`: {{site.mesh_product_name}} will generate data plane certificates using a CA root certificate and key stored in a third-party HashiCorp Vault server.

## Usage

Unlike the `builtin` and `provided` backends, by using the `vault` mTLS mode {{site.mesh_product_name}} will communicate to a third-party HashiCorp Vault PKI in order to generate the data plane proxy certificates automatically.

The `vault` mTLS backend expects a `kuma-pki-${MESH_NAME}` PKI already configured in Vault. For example the PKI path for the `default` mesh would be `kuma-pki-default`.

In order to use this feature, we also need to instruct {{site.mesh_product_name}} to point to the Vault server and provide the appropriate credentials to authenticate the control plane in order to generate the data plane certificates.

Once running, this backend is responsible for communicating to Vault and utilize Vault's PKI to automatically issue and rotate data plane certificates for each proxy.

The communication to Vault happens directly from `kuma-cp`. Below an example to start using a `vault` backed CA:

{% navtabs %}
{% navtab Kubernetes %}

```yaml
apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  mtls:
    enabledBackend: vault-1
    backends:
      - name: vault-1
        type: vault
        dpCert:
          rotation:
            expiration: 1d # must be lower than max_ttl in Vault role
        conf:
          fromCp:
            address: https://vault.8200
            agentAddress: "" # optional
            namespace: "" # optional
            tls:
              caCert:
                secret: sec-1
              skipVerify: false # if set to true, caCert is optional. Set to true only for development
              serverName: "" # verify sever name
            auth: # only one auth options is allowed so it's either "token" or "tls"
              token:
                secret: token-1  # can be file, secret or inline
              tls:
                clientKey:
                  secret: sec-2  # can be file, secret or inline
                clientCert:
                  file: /tmp/cert.pem # can be file, secret or inline
```

We will apply the configuration with `kubectl apply -f [..]`.

{% endnavtab %}
{% navtab Universal %}

```yaml
type: Mesh
name: default
mtls:
  enabledBackend: vault-1
  backends:
  - name: vault-1
    type: vault
    dpCert:
      rotation:
        expiration: 24h # must be lower than max_ttl in Vault role
    conf:
      fromCp:
        address: https://vault.8200
        agentAddress: "" # optional
        namespace: "" # optional
        tls:
          caCert:
            secret: sec-1
          skipVerify: false # if set to true, caCert is optional. Set to true only for development
          serverName: "" # verify sever name
        auth: # only one auth options is allowed so it's either "token" or "tls"
          token:
            secret: token-1  # can be file, secret or inline
          tls:
            clientKey:
              secret: sec-2  # can be file, secret or inline
            clientCert:
              file: /tmp/cert.pem # can be file, secret or inline
```

We will apply the configuration with `kumactl apply -f [..]` or via the [HTTP API](https://kuma.io/docs/latest/documentation/http-api).

{% endnavtab %}
{% endnavtabs %}

## Vault Authentication

In order to connect to Vault we must authenticate `kuma-cp` via:

* A `clientKey`.
* A `clientCert`.
* A `secret` token.

These values can be inline (for testing purposes only), a path to a file on the same host as `kuma-cp`, or they can be a  `secret`. You can read the official Kuma documentation to learn more about [Kuma Secrets](https://kuma.io/docs/latest/documentation/secrets/) and how to create one.
