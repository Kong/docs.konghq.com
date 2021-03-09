---
title: Kong Mesh - Vault Policy
---

## Vault CA Backend

The default [mTLS policy in Kuma](https://kuma.io/docs/latest/policies/mutual-tls/)
supports the following backends:

* `builtin`: {{site.mesh_product_name}} automatically generates the Certificate
Authority (CA) root certificate and key that will be used to generate the data
plane certificates.
* `provided`: the CA root certificate and key can be provided by the user.

This feature adds one more mTLS backend mode:

* `vault`: {{site.mesh_product_name}} will generate data plane certificates
using a CA root certificate and key stored in a third-party HashiCorp Vault
server.

## Using Vault Mode

Unlike the `builtin` and `provided` backends, when using the `vault` mTLS mode,
{{site.mesh_product_name}} communicates with a third-party HashiCorp Vault PKI,
which generates the data plane proxy certificates automatically.

The `vault` mTLS backend expects a `kuma-pki-${MESH_NAME}` PKI already
configured in Vault. For example, the PKI path for a mesh named `default` would
be `kuma-pki-default`.

To use this feature, you also need to point {{site.mesh_product_name}} to the
Vault server and provide the appropriate credentials. {{site.mesh_product_name}}
will use these parameters to authenticate the control plane and generate the
data plane certificates.

Once running, this backend is responsible for communicating with Vault and for
using Vault's PKI to automatically issue and rotate data plane certificates for
each proxy.

## Enabling Vault Authentication

The communication to Vault happens directly from `kuma-cp`. To connect to
Vault, you must provide the following values in the configuration for `kuma-cp`:

* A `clientKey`.
* A `clientCert`.
* A `secret` token.

These values can be inline (for testing purposes only), a path to a file on the
same host as `kuma-cp`, or contained in a `secret`. See the official Kuma
documentation to learn more about [Kuma Secrets](https://kuma.io/docs/latest/documentation/secrets/)
and how to create one.

Here's an example of a configuration using a `vault`-backed CA:

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

Apply the configuration with `kubectl apply -f [..]`.

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

Apply the configuration with `kumactl apply -f [..]`, or using the [HTTP API](https://kuma.io/docs/latest/documentation/http-api).

{% endnavtab %}
{% endnavtabs %}
