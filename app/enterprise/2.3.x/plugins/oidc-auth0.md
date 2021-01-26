---
title: OpenID Connect with Auth0
---

## Introduction

This guide covers an example OpenID Connect plugin configuration to authenticate headless service consumers using Auth0's identity provider.

## Auth0 IDP Configuration

This configuration will use a [client credentials grant][client-credentials-grant] as it is non-interactive, and because we expect clients to authenticate on behalf of themselves, not an end-user. To do so, you will need to [create an Auth0 API][create-auth0-api] and a [non-interactive client][non-interactive-client].

### API Configuration

When creating your API, you will need to specify an Identifier. Using the URL that your consumer makes requests to is generally appropriate, so this will typically be the hostname/path combination configured as an API in Kong.

After creating your API, you will also need to add the `openid` scope at `https://manage.auth0.com/#/apis/<API ID>/scopes`.

### Client Configuration

You will need to authorize your client to access your API. Auth0 will prompt you to do so after client creation if you select the API you created previously from the client's Quick Start menu. After toggling the client to Authorized, expand its authorization settings and enable the `openid` scope.

## Kong Configuration

If you have not done so already, [create a **Service**][add-service] to protect. The `url` configuration should match the Identifier you used when configuring Auth0.

Add an OpenID plugin configuration using the parameters in the example below using an HTTP client or Kong Manager. Auth0's token endpoint [requires passing the API identifier in the `audience` parameter][audience-required], which must be added as a custom argument:

```bash
$ curl -i -X POST http://kong:8001/kong-admin/apis/<API name>/plugins --data name="openid-connect" \
  --data config.auth_methods="client_credentials" \
  --data config.issuer="https://<auth0 API name>.auth0.com/.well-known/openid-configuration" \
  --data config.token_post_args_names="audience" \
  --data config.token_post_args_values="https://example.com/"
```

## Downstream configuration

The service accessing your resource will need to pass its credentials to Kong. It can do so via HTTP basic authentication, query string arguments, or parameters in the request body. Basic authentication is generally preferable, as credentials in a query string will be present in Kong's access logs (and possibly in other infrastructure's access logs, if you have HTTP-aware infrastructure in front of Kong) and credentials in request bodies are limited to request methods that expect
client payloads.

For basic authentication, use your client ID as the username and your client secret as the password. For the other methods, pass them as parameters named `client_id` and `client_secret`, respectively.


[client-credentials-grant]: https://auth0.com/docs/api-auth/tutorials/client-credentials
[create-auth0-api]: https://auth0.com/docs/apis#how-to-configure-an-api-in-auth0
[non-interactive-client]: https://auth0.com/docs/clients
[add-service]: /enterprise/{{page.kong_version}}/kong-manager/add-service
[audience-required]: https://auth0.com/docs/api/authentication#client-credentials
