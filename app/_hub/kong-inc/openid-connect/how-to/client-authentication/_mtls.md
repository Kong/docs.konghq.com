---
title:  Mutual TLS Client Authentication
nav_title: Mutual TLS Client Authentication
---

## Mutual TLS client authentication

The OpenID Connect plugin supports mutual TLS (mTLS) client authentication with the IdP. 
When mTLS authentication is enabled, Kong establishes mTLS connections with the IdP using the configured client certificate.

You can use mTLS client authentication with the following IdP endpoints and corresponding flows:

* `token`
  * [Authorization Code Flow](/hub/kong-inc/openid-connect/how-to/authentication/authorization-code-flow/)
  * [Password Grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/)
  * [Refresh Token Grant](/hub/kong-inc/openid-connect/how-to/authentication/refresh-token/)
* `introspection`
  * [Introspection Authentication flow](/hub/kong-inc/openid-connect/how-to/authentication/introspection/)
* `revocation`
  * [Session Authentication](/hub/kong-inc/openid-connect/how-to/authentication/session/)

For all these endpoints and for the flows supported, the plugin uses mTLS client authentication as the authentication method when communicating with the IdP, for example, to fetch the token from the token endpoint.

## Requirements for an mTLS client auth configuration

### Auth server configuration

The feature requires the IdP to be enabled to use mTLS and X.509 client certificate authentication. For configuring this in Keycloak, refer to the [Keycloak configuration](#prerequisites) section below. For different auth servers, refer to their documentation to configure this functionality.

### Kong configuration

* Set the client authentication methods. Refer to the configuration reference sections:
	* [`client_auth`](/hub/kong-inc/openid-connect/configuration/#configclient_auth)
	* [`token_endpoint_auth_method`](/hub/kong-inc/openid-connect/configuration/#configtoken_endpoint_auth_method)
	* [`introspection_endpoint_auth_method`](/hub/kong-inc/openid-connect/configuration/#configintrospection_endpoint_auth_method)
	* [`revocation_endpoint_auth_method`](/hub/kong-inc/openid-connect/configuration/#configrevocation_endpoint_auth_method)
* Configure the client certificate ID as a value for the `tls_client_auth_cert_id` field as described in the [configuration reference](/hub/kong-inc/openid-connect/configuration/#config-tls_client_auth_cert_id).

#### Certificates

For mTLS connections, create a certificate and key pair for {{site.base_gateway}} to use when connecting to the IdP:

```bash
http -f post :8001/certificates cert@crt.pem key@key.pem
```

#### SSL verify

The configuration option [`tls_client_auth_ssl_verify`](/hub/kong-inc/openid-connect/configuration/#configtls_client_auth_ssl_verify) controls whether the server (IdP) certificate is verified.

When set to `true` (the default value), ensure [trusted certificate](/gateway/latest/reference/configuration/#lua_ssl_trusted_certificate) and [verify depth](/gateway/latest/reference/configuration/#lua_ssl_verify_depth) are appropriately configured so that the IdP's server certificate is trusted by Kong and the handshake can be performed successfully.

## Demo
### Prerequisites

Follow these prerequisites to set up a demo Keycloak app and a Kong service and route for testing mTLS client auth.

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

### Set up mTLS for the OIDC plugin

Using the Keycloak and {{site.base_gateway}} configuration from the [prerequisites](#prerequisites), 
set up an instance of the OpenID Connect plugin.

For the demo, we're going to set up the following:

* Issuer, client ID: Settings that connect the plugin to your IdP (in this case, the sample Keycloak app).
* `client_auth`: Must use TLS (`tls_client_auth`).
* Auth methods: For demo purposes, we use the password grant, but you can use any supported auth method.
* `tls_client_auth_cert_id`: Pass the ID of the certificate object [you created via `/certificates`](#certificates).

With all of the above in mind, let's test out mTLS client auth with the password grant, using Keycloak as the IdP. 
Enable the OpenID Connect plugin on the `openid-connect` service:

<!-- vale off -->
{% plugin_example %}
plugin: kong-inc/openid-connect
name: openid-connect
config:
  issuer: "http://keycloak.test:8080/auth/realms/master"
  client_id: "client-tls-auth"
  client_auth: "tls_client_auth"
  auth_methods:
    - "password"
  tls_client_auth_cert_id: "1e0721c1-fd43-494c-9864-007bbba98c8c"
targets:
  - service
formats:
  - konnect
  - curl
  - yaml
  - kubernetes
{% endplugin_example %}
<!-- vale on -->

### Test mTLS client auth

Access the service using the `password` auth method.
Kong will access the IdP's token endpoint using the mTLS Client Authentication with the configured certificate:
  
```sh
curl http://localhost:8000/openid-connect --user john:doe
```

If successful, you should receive a 200 status code:
```http
HTTP/1.1 200 OK
```