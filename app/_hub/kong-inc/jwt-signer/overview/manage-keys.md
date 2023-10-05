---
nav_title: Manage key signing
---

What is key signing and why does the JWT plugin require it?

With the JWT signer plugin, you have the option to either use signing keys that are externally managed by you or to use Kong-generated signing keys. If you're using the JWT signer plugin with {{site.konnect_short_name}}, you *must* manage your signing keys externally. If you're using {{site.base_gateway}}, you can either manage your signing keys externally or use Kong-generated keys.

Are there any reasons why someone who is using {{site.base_gateway}} might choose one mode over the other?

## Externally manage signing keys

This section provides instructions that explain how to host key sets using the library of your choice and configure the JWT plugin to load your externally managed keys.

### Prerequisites

* A keys host (for example, a Docker container) for the keys. This host must be accessible from both {{site.base_gateway}} and upstreams with NGINX installed on it
* An environment where you can generate signing keys
What does this mean? What do we need in the environment?
* A TLS certificate to secure the key server

### Host key sets

1. Generate server certificates using your organization's certificate authority (CA).

1. Generate JWKs using any of the [standard libraries](https://jwt.io/libraries) that align with your organization's security requriements. 
    The key size (the modulo) for RSA keys is currently hard-coded to 2048 bits.

1. Copy the generated keys in a directory on the host machine. Also, copy your server certificate and key to the host machine as well. 

1. Configure your host server with the certificate, certificate key, signing keys, and JSON Web Key Set (JWKS). 
    
    {:.note}
    > **Note:** External URLs that contain private keys should be protected so that only Kong can access them. Currently, Kong doesn't add any authentication headers when it loads the keys from an external endpoint, so you have to do it with network level restrictions. If you commonly need to manage private keys externally instead of allowing Kong to autogenerate them, you can add another parameter for adding an authentication header (possibly similar to `config.channel_token_introspection_authorization`).

### Configure the JWT plugin with your self-hosted key sets

To configure the JWT plugin with your self-hosted key sets, you must specify `config.access_token_keyset` or `config.channel_token_keyset` with either an `http://` or `https://` prefix:

```bash
curl -X POST \
https://{us|eu}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/services/{serviceId}/plugins \
    --header "accept: application/json" \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer TOKEN" \
    --data '{"name":"jwt-signer","config":{"access_token_keyset":http://keyserverexample.internal/signingkeys}}'
```

In this case, the plugin loads the keys just like it does for `config.access_token_jwks_uri`
and `config.channel_token_jwks_uri`.

External JWKS specified with `config.access_token_keyset` or
`config.channel_token_keyset` should also contain private keys with supported `alg`,
either `"RS256"` or `"RS512"` for now.

## Generate signing keys with Kong

If you specify `config.access_token_keyset` or `config.channel_token_keyset` without either an
`http://` or `https://` prefix (such as `"my-company"` or `"kong"`), Kong autogenerates JWKS for supported algorithms.