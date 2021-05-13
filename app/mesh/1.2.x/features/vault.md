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
{{site.mesh_product_name}} does not retrieve private key of the CA to generate data plane proxy certificates,
which means that private key of the CA is secured by Vault and not exposed to third parties.

To use this feature, you also need to point {{site.mesh_product_name}} to the
Vault server and provide the appropriate credentials. {{site.mesh_product_name}}
will use these parameters to authenticate the control plane and generate the
data plane certificates.

Once running, this backend is responsible for communicating with Vault and for
using Vault's PKI to automatically issue and rotate data plane certificates for
each proxy.

### Configure Vault

The `vault` mTLS backend expects a `kuma-pki-${MESH_NAME}` PKI already
configured in Vault. For example, the PKI path for a mesh named `default` would
be `kuma-pki-default`.

Follow the steps below to configure Vault for {{site.mesh_product_name}}.
The steps will consider configuring PKI for the mesh `default`.
To configure Vault for a different mesh, replace `default` with the mesh name of your choice.

1. Configure the Certificate Authority

    {{site.mesh_product_name}} can work with either Root CA or with Intermediate CA.
    
    {% navtabs %}
    {% navtab Root CA %}
    Create a new PKI for the `default` Mesh called `kuma-pki-default`
    ```sh
    vault secrets enable -path=kuma-pki-default pki
    ```
    Generate a new Root Certificate Authority for the `default` Mesh
    ```
    vault secrets tune -max-lease-ttl=87600h kuma-pki-default
    vault write -field=certificate kuma-pki-default/root/generate/internal \
      common_name="Kuma Mesh Default" \
      uri_sans="spiffe://default" \
      ttl=87600h
    ```
    {% endnavtab %}
    {% navtab Intermediate CA %}
    Create a new Root Certificate Authority and save it to a file called `ca.pem`.
    ```sh
    vault secrets enable pki
    vault secrets tune -max-lease-ttl=87600h pki
    vault write -field=certificate pki/root/generate/internal \
      common_name="Organization CA" \
      ttl=87600h > ca.pem
    ```
    You can also use your current Root CA, retrieve PEM-encoded certificate and save it to `ca.pem`
    
    Create a new PKI for the `default` Mesh
    ```sh
    vault secrets enable -path=kuma-pki-default pki
    ```
    
    Generate Intermediate CA for the `default` Mesh
    ```sh
    vault write -format=json kuma-pki-default/intermediate/generate/internal \
        common_name="Kuma Mesh Default" \
        uri_sans="spiffe://default" \
        | jq -r '.data.csr' > pki_intermediate.csr
    ```
    
    Sign the Intermediate CA with the Root CA. Make sure to pass the right path for the PKI that has the Root CA.
    In this example, the path is just `pki`, if the PKI of you root CA is called `root-pki` the path would be `root-pki/root/sign-intermediate`   
    ```sh
    vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr \
      format=pem_bundle \
      ttl="43800h" \
      | jq -r '.data.certificate' > intermediate.cert.pem
    ```
    
    Set the certificate of signed Intermediate CA to the `default` Mesh PKI.
    We have to include the public certificate of the Root CA, otherwise data plane proxies won't be able to verify the certificates.
    ```sh
    cat intermediate.cert.pem > bundle.pem
    echo "" >> bundle.pem
    cat ca.pem >> bundle.pem
    vault write kuma-pki-default/intermediate/set-signed certificate=@bundle.pem
    ```
    {% endnavtab %}
    {% endnavtabs %}
    
2. Create a role for generating data plane proxy certificates

    ```sh
    vault write kuma-pki-default/roles/dataplanes \
      allowed_uri_sans="spiffe://default/*,kuma://*" \
      key_usage="KeyUsageKeyEncipherment,KeyUsageKeyAgreement,KeyUsageDigitalSignature" \
      ext_key_usage="ExtKeyUsageServerAuth,ExtKeyUsageClientAuth" \
      client_flag=true \
      require_cn=false \
      basic_constraints_valid_for_non_ca=true \
      max_ttl="720h" \
      "ttl"="720h"
    ```

3. Create a policy to use a new role

    ```sh
    cat > kuma-default-dataplanes.hcl <<- EOM
    path "/kuma-pki-default/issue/dataplanes"
    {
      capabilities = ["create", "update"]
    }
    EOM
    vault policy write kuma-default-dataplanes kuma-default-dataplanes.hcl
    ```

4. Create a Vault token

    ```sh
    vault token create -format=json -policy="kuma-default-dataplanes" | jq -r ".auth.client_token"
    ```
    The output of the command should print a Vault token that can be then used in the `conf.fromCp.auth.token` setting on the `Mesh` object

### Configure Mesh

The communication to Vault happens directly from `kuma-cp`. To connect to
Vault, you must provide credential in the configuration of the `Mesh` in `kuma-cp`.

You can either authenticate with the `token` or with client certificates by providing `clientKey` and `clientCert`.

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
                secret: token-1  # can be file, secret or inlineString
              tls:
                clientKey:
                  secret: sec-2  # can be file, secret or inline
                clientCert:
                  file: /tmp/cert.pem # can be file, secret or inlineString
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
            secret: token-1  # can be file, secret or inlineString
          tls:
            clientKey:
              secret: sec-2  # can be file, secret or inlineString
            clientCert:
              file: /tmp/cert.pem # can be file, secret or inline
```

Apply the configuration with `kumactl apply -f [..]`, or using the [HTTP API](https://kuma.io/docs/latest/documentation/http-api).

{% endnavtab %}
{% endnavtabs %}
