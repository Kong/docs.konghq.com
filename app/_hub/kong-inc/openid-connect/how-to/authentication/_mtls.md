---
title:  Mutual TLS Client Authentication
nav_title: Mutual TLS Client Authentication
---

The OpenID Connect plugin supports Mutual TLS (mTLS) Client Authentication with the IdP. When the feature is enabled, Kong establishes mTLS connections with the IdP using the configured client certificate. The compatible IdP endpoints are listed below along with the corresponding flows that the feature is intended to work with:

* `token`
  * [Authorization Code Flow](#authorization-code-flow)
  * [Password Grant](#password-grant)
  * [Refresh Token Grant](#refresh-token-grant)
* `introspection`
  * [Introspection Authentication flow](#introspection-authentication)
* `revocation`
  * [Session Authentication](#session-authentication)

For all these endpoints and for the flows supported, the plugin uses mTLS Client Authentication as the authentication method when communicating with the IdP, for example, to fetch the token from the token endpoint.

### Auth Server Configuration

The feature requires the IdP to be enabled to use mTLS and X.509 client certificate authentication. For configuring this in Keycloak, refer to the [Keycloak configuration](#keycloak-configuration) section above. For different Auth servers, refer to their documentation to configure this functionality.

### Certificates

Ensure the client certificate that Kong will use for mTLS connections is configured:

```bash
http -f post :8001/certificates cert@crt.pem key@key.pem
```
```json
{
    "cert": "-----BEGIN CERTIFICATE-----...",
    "id": "1e0721c1-fd43-494c-9864-007bbba98c8c",
    "key": "-----BEGIN PRIVATE KEY-----...",
}
```

### Kong configuration

* Set the client Authentication methods appropriately, refer to the Configuration reference sections:
	* [client_auth](/hub/kong-inc/openid-connect/configuration/#config-client_auth)
	* [token_endpoint_auth_method](/hub/kong-inc/openid-connect/configuration/#config-token_endpoint_auth_method)
	* [introspection_endpoint_auth_method](/hub/kong-inc/openid-connect/configuration/#config-introspection_endpoint_auth_method)
	* [revocation_endpoint_auth_method](/hub/kong-inc/openid-connect/configuration/#config-revocation_endpoint_auth_method)
* Configure the client certificate ID as a value for the `tls_client_auth_cert_id` field as described in the [Configuration reference](/hub/kong-inc/openid-connect/configuration/#config-tls_client_auth_cert_id).

#### SSL Verify

The configuration option: [`tls_client_auth_ssl_verify`](/hub/kong-inc/openid-connect/configuration/#config-tls_client_auth_ssl_verify) controls whether the server (IdP) certificate is verified.

When set to `true` (the default value), ensure [trusted certificate](/gateway/latest/reference/configuration/#lua_ssl_trusted_certificate) and [verify depth](/gateway/latest/reference/configuration/#lua_ssl_verify_depth) are appropriately configured so that the IdP's server certificate is trusted by Kong and the handshake can be performed successfully.

### Testing

1. Set up the plugin using the `client_auth` and `tls_client_auth_cert_id` configuration options:

```bash
http -f put :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
name=openid-connect \
service.name=openid-connect \ config.issuer=https://keycloak.test:8440/auth/realms/master \ 
config.client_id=client-tls-auth \
config.auth_methods=password \
config.client_auth=tls_client_auth \
config.tls_client_auth_cert_id=1e0721c1-fd43-494c-9864-007bbba98c8c
```

2. Access the service using the `password` auth method, Kong will access the IdP's token endpoint using the mTLS Client Authentication with the configured certificate:
```bash
http -v -a john:doe :8000
```

3. Confirm the response status code is 200:
```http
    HTTP/1.1 200 OK
```