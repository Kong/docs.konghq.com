---
title: Kong Mesh - Vault Policy
no_search: true
---

# Vault CA Integration

The default [mTLS policy](https://kuma.io/docs/latest/policies/mutual-tls/) supports three backends:

* `builtin`: {{site.mesh_product_name}} automatically generates a CA root certificate and key that will be used to generate the data plane certificates.
* `provided`: the CA root certificate and key can be provided by the user.

This features adds one more mTLS backend mode:

* `vault`: {{site.mesh_product_name}} will generate data plane certificates using a CA root certificate and key stored in a third-party HashiCorp Vault server.

## Usage

Unlike the `builtin` and `provided` backends, by using the `vault` mTLS mode {{site.mesh_product_name}} will communicate to a third-party HashiCorp Vault deployment in order to generate the data plane proxy certificates automatically.

In order to use this feature, we need to instruct {{site.mesh_product_name}} to point to the Vault server and provided the appropriate credentials to autenticate the control plane in order to generate the data plane certificates which will be automatically 

We are responsible for providing the CA root certificate + key and also to manage their lifecycle. Kuma will then use our CA root certificate + Key to automatically provision (and rotate) data plane certificates for every replica of every service.

First we need to upload our CA root certificate and key as Kuma Secrets so that we can later reference them.

Once the secrets have been created, to enable a provided mTLS for the entire Mesh we can apply the following configuration:

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
      config:
        fromCp:
          address: https://vault.8200
          agentAddress: "" # optional
          namespace: "" # optional
          tls:
            caCert:
              secret: sec-1
            skipVerify: false # if set to true, caCert is optional. Set to true only for development
            serverName: "" # verify sever name
            clientKey:
              secret: sec-2  # can be file, secret or inline
            clientCert:
              file: /tmp/cert.pem # can be file, secret or inline
            auth:
              token:
                secret: token-1  # can be file, secret or inline
```

We will apply the configuration with `kubectl apply -f [..]`.

{% endnavtab %}
{% navtab Another Universal %}

```yaml
type: Mesh
name: default
mtls:
  enabledBackend: vault-1
  backends:
  - name: vault-1
    type: vault
    config:
      fromCp:
        address: https://vault.8200
        agentAddress: "" # optional
        namespace: "" # optional
        tls:
          caCert:
            secret: sec-1
          skipVerify: false # if set to true, caCert is optional. Set to true only for development
          serverName: "" # verify sever name
          clientKey:
            secret: sec-2  # can be file, secret or inline
          clientCert:
            file: /tmp/cert.pem # can be file, secret or inline
          auth:
            token:
              secret: token-1  # can be file, secret or inline
```

We will apply the configuration with `kumactl apply -f [..]` or via the [HTTP API](https://kuma.io/docs/latest/documentation/http-api).

{% endnavtab %}
{% endnavtabs %}

## Vault Authentication

* In order to connect to Vault we must authenticate `kuma-cp` via a `clientKey`, `clientCert` and a `secret`. 

These values can be a path to a file on the same host as `kuma-cp`, or they can be a  `secret`. Read the official Kuma documentation to learn more about [Kuma Secrets](https://kuma.io/docs/latest/documentation/secrets/).
