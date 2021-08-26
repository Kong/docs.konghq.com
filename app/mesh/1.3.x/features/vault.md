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

{{site.mesh_product_name}} adds:

* `vault`: {{site.mesh_product_name}} generates data plane certificates
using a CA root certificate and key stored in a HashiCorp Vault
server.

## Vault mode

In `vault` mTLS mode, {{site.mesh_product_name}} communicates with the HashiCorp Vault PKI,
which generates the data plane proxy certificates automatically.
{{site.mesh_product_name}} does not retrieve private key of the CA to generate data plane proxy certificates,
which means that private key of the CA is secured by Vault and not exposed to third parties.

In `vault` mode, you point {{site.mesh_product_name}} to the
Vault server and provide the appropriate credentials. {{site.mesh_product_name}}
uses these parameters to authenticate the control plane and generate the
data plane certificates.

When {{site.mesh_product_name}} is running in `vault` mode, the backend communicates with Vault and ensures 
that Vault's PKI automatically issues data plane certificates and rotates them for
each proxy.

### Configure Vault

<<<<<<< HEAD
The `vault` mTLS backend expects a `kuma-pki-${MESH_NAME}` PKI already
configured in Vault. For example, the PKI path for a mesh named `default` is `kuma-pki-default`.
=======
The `vault` mTLS backend expects a configured PKI and role for generating data plane proxy certificates.
>>>>>>> 00a2b3b8794585096e12f54414e12df484aabec7

The following steps show how to configure Vault for {{site.mesh_product_name}} with a mesh named 
`default`. For your environment, replace `default` with the appropriate mesh name.

#### Step 1. Configure the Certificate Authority

{{site.mesh_product_name}} works with a Root CA or an Intermediate CA.

{% navtabs %}
{% navtab Root CA %}

<<<<<<< HEAD
Create a new PKI for the `default` Mesh called `kuma-pki-default`:

```sh
vault secrets enable -path=kuma-pki-default pki
=======
Create a new PKI for the `default` Mesh called `kmesh-pki-default`:

```sh
vault secrets enable -path=kmesh-pki-default pki
>>>>>>> 00a2b3b8794585096e12f54414e12df484aabec7
```

Generate a new Root Certificate Authority for the `default` Mesh:

```sh
<<<<<<< HEAD
vault secrets tune -max-lease-ttl=87600h kuma-pki-default
```

```sh
vault write -field=certificate kuma-pki-default/root/generate/internal \
  common_name="Kuma Mesh Default" \
=======
vault secrets tune -max-lease-ttl=87600h kmesh-pki-default
```

```sh
vault write -field=certificate kmesh-pki-default/root/generate/internal \
  common_name="Kong Mesh Mesh Default" \
>>>>>>> 00a2b3b8794585096e12f54414e12df484aabec7
  uri_sans="spiffe://default" \
  ttl=87600h
```

{% endnavtab %}
{% navtab Intermediate CA %}

Create a new Root Certificate Authority and save it to a file called `ca.pem`:

```sh
vault secrets enable pki
```

```sh
vault secrets tune -max-lease-ttl=87600h pki
```

```sh
vault write -field=certificate pki/root/generate/internal \
  common_name="Organization CA" \
  ttl=87600h > ca.pem
```

You can also use your current Root CA, retrieve the PEM-encoded certificate, and save it to `ca.pem`.

Create a new PKI for the `default` Mesh:

```sh
<<<<<<< HEAD
vault secrets enable -path=kuma-pki-default pki
=======
vault secrets enable -path=kmesh-pki-default pki
>>>>>>> 00a2b3b8794585096e12f54414e12df484aabec7
```

Generate the Intermediate CA for the `default` Mesh:

```sh
<<<<<<< HEAD
vault write -format=json kuma-pki-default/intermediate/generate/internal \
    common_name="Kuma Mesh Default" \
=======
vault write -format=json kmesh-pki-default/intermediate/generate/internal \
    common_name="Kong Mesh Mesh Default" \
>>>>>>> 00a2b3b8794585096e12f54414e12df484aabec7
    uri_sans="spiffe://default" \
    | jq -r '.data.csr' > pki_intermediate.csr
```

Sign the Intermediate CA with the Root CA. Make sure to pass the right path for the PKI that has the Root CA.
In this example, the path  value is `pki`:

```sh
vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr \
  format=pem_bundle \
  ttl="43800h" \
  | jq -r '.data.certificate' > intermediate.cert.pem
```

Set the certificate of signed Intermediate CA to the `default` Mesh PKI. You must include the public certificate of the Root CA
so that data plane proxies can verify the certificates:

```sh
cat intermediate.cert.pem > bundle.pem
echo "" >> bundle.pem
cat ca.pem >> bundle.pem
<<<<<<< HEAD
vault write kuma-pki-default/intermediate/set-signed certificate=@bundle.pem
=======
vault write kmesh-pki-default/intermediate/set-signed certificate=@bundle.pem
>>>>>>> 00a2b3b8794585096e12f54414e12df484aabec7
```

{% endnavtab %}
{% endnavtabs %}

#### Step 2. Create a role for generating data plane proxy certificates:

```sh
<<<<<<< HEAD
vault write kuma-pki-default/roles/dataplanes \
=======
vault write kmesh-pki-default/roles/dataplane-proxies \
>>>>>>> 00a2b3b8794585096e12f54414e12df484aabec7
  allowed_uri_sans="spiffe://default/*,kuma://*" \
  key_usage="KeyUsageKeyEncipherment,KeyUsageKeyAgreement,KeyUsageDigitalSignature" \
  ext_key_usage="ExtKeyUsageServerAuth,ExtKeyUsageClientAuth" \
  client_flag=true \
  require_cn=false \
  basic_constraints_valid_for_non_ca=true \
  max_ttl="720h" \
  ttl="720h"
```

#### Step 3. Create a policy to use the new role:

```sh
<<<<<<< HEAD
cat > kuma-default-dataplanes.hcl <<- EOM
path "/kuma-pki-default/issue/dataplanes"
=======
cat > kmesh-default-dataplane-proxies.hcl <<- EOM
path "/kmesh-pki-default/issue/dataplane-proxies"
>>>>>>> 00a2b3b8794585096e12f54414e12df484aabec7
{
  capabilities = ["create", "update"]
}
EOM
<<<<<<< HEAD
vault policy write kuma-default-dataplanes kuma-default-dataplanes.hcl
=======
vault policy write kmesh-default-dataplane-proxies kmesh-default-dataplane-proxies.hcl
>>>>>>> 00a2b3b8794585096e12f54414e12df484aabec7
```

#### Step 4. Create a Vault token:

```sh
<<<<<<< HEAD
vault token create -format=json -policy="kuma-default-dataplanes" | jq -r ".auth.client_token"
=======
vault token create -format=json -policy="kmesh-default-dataplane-proxies" | jq -r ".auth.client_token"
>>>>>>> 00a2b3b8794585096e12f54414e12df484aabec7
```

The output should print a Vault token that you then provide as the `conf.fromCp.auth.token` value of the `Mesh` object.

### Configure Mesh

`kuma-cp` communicates directly with Vault. To connect to
Vault, you must provide credentials in the configuration of the `mesh` object of `kuma-cp`.

You can authenticate with the `token` or with client certificates by providing `clientKey` and `clientCert`.

You can provide these values inline for testing purposes only, as a path to a file on the
same host as `kuma-cp`, or contained in a `secret`. See [the Kuma Secrets documentation](https://kuma.io/docs/latest/documentation/secrets/).

Here's an example of a configuration with a `vault`-backed CA:

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
<<<<<<< HEAD
=======
            pki: kmesh-pki-default # name of the configured PKI
            role: dataplane-proxies # name of the role that will be used to generate data plane proxy certificates
>>>>>>> 00a2b3b8794585096e12f54414e12df484aabec7
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

Apply the configuration with `kumactl apply -f [..]`, or with the [HTTP API](https://kuma.io/docs/latest/documentation/http-api).

{% endnavtab %}
{% endnavtabs %}
<<<<<<< HEAD
=======

## Multizone and Vault

In a multizone environment, the global control plane provides the `Mesh` to the zone control planes. However, you must make sure that each zone control plane communicates with Vault over the same address. This is because certificates for data plane proxies are issued from the zone control plane, not from the global control plane.

You must also make sure the global control plane communicates with Vault. When a new Vault backend is configured, Kong Mesh validates the connection by issuing a test certificate. In a multizone environment, validation is performed on the global control plane.
>>>>>>> 00a2b3b8794585096e12f54414e12df484aabec7
