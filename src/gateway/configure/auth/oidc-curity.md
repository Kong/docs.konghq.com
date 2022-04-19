---
title: OpenID Connect with Curity
badge: enterprise
---

## Phantom Token Integration

This guide describes how to integrate {{site.ee_product_name}} and the Curity Identity Server using the Kong [OpenID Connect](/hub/kong-inc/openid-connect/) plugin.

This guide focuses on configuring the plugin for introspection, and especially as it relates to the introspection using the [Phantom Token pattern][curity-phantom-token-pattern]. Some tweaks are made so that a phantom token is provided in the introspection response and then passed on to the upstream API.

Configuring the Curity Identity Server to provide a Phantom Token in the introspection response is outlined in more detail in this [Introspection and Phantom Tokens][curity-phantom-token-introspection] article.

### Prerequisites

* An installation of the [Curity Identity Server][curity-getting-started]
* An introspection endpoint configured with the [Token Procedure Approach][curity-phantom-token-introspection]

### Configure Kong

The Kong OpenID Connect plugin is configured to introspect an incoming opaque access token and in return receive a JWT in the introspection response from the Curity Identity Server. The plugin is enabled for a [service or a route][kong-add-service].

As part of the introspection, the OpenID Connect plugin also has the ability to validate that required scopes are available in the introspected token. Access to the requested API are denied if the correct scopes are missing.

If access is granted, the JWT from the introspection response is added to a header and forwarded to the upstream API where it can be consumed.

#### Create a service

Create a service that can be used to test the integration.

```bash
curl -i -X POST http://kong:8001/services/ \
  --data name="httpbin" \
  --data protocol="http" \
  --data url="http://httpbin.org"
```

#### Create a route

Add a route to the service.

```bash
curl -i -X POST http://kong:8001/services/httpbin/routes \
  --data "paths[]=/httpbin"
```

#### Configure the plugin

The Kong OpenID Connect plugin is enabled for the previously created service. In the example below, the `openid` scope is required in order for access to be granted. As noted by the `config.upstream_headers_claims` configuration, the plugin looks for the `JWT` (the phantom token) claim in the introspection response. The `config.upstream_headers_names` configuration extracts the `JWT` from the introspection response and adds it to a `phantom_token` header in the call to the upstream API.

```bash
curl -X POST http://kong:8001/services/httpbin/plugins \
--data name="openid-connect" \
--data config.issuer="https://idsvr.example.com/oauth/v2/oauth-anonymous" \
--data config.client_id="gateway-client" \
--data config.client_secret="Password1" \
--data config.scopes_required="openid" \
--data config.hide_credentials="true" \
--data config.upstream_access_token_header= \
--data config.upstream_headers_claims="phantom_token" \
--data config.upstream_headers_names="phantom_token" \
--data config.auth_methods="introspection"
```

Parameter | Description | Example | Required for integration
--- |--- |--- |---
`config.issuer` | Used for discovery. Kong appends `/.well-known/openid-configuration`. Should be set to the `realm` or `iss` if no discovery endpoint is available. | `https://idsvr.example.com/oauth/v2/oauth-anonymous` | Yes
`config.client_id` | The ID of a client with the introspection capability | `gateway-client`| Yes
`config.client_secret` | Secret of the client used for introspection| `Password1` | Yes
`config.scopes_required`| Optional scopes required in introspection result for coarse grained authorization. By default the plugin looks for the scopes in the `scopes` claim in the introspection result. This could be overridden with the `config.scopes_claim` configuration. | `openid email records_read`  | No
`config.hide_credentials` | Boolean value. This will prevent the incoming Access Token from being forwarded to the upstream API. |`true` | No
`config.upstream_access_token_header` | In order to prevent the plugin from adding the Access Token back in the upstream request, actively set this value to nothing (aka, `nil`) by setting `config.upstream_access_token_header=` as in the example above . This configuration works in conjunction with `config.hide_credentials` to prevent the incoming Access Token from being passed to the upstream API. | `authorization:bearer` | No
`config.upstream_headers_claims` | Contains claim that holds Phantom Token in the introspection result. | `phantom_token` | Yes  
`config.upstream_headers_names` | Contains upstream header name that will hold the Phantom Token from the introspection result. | `phantom_token` | Yes
`config.auth_methods` | Several methods are supported for authenticating the request. For this use case, this should be limited to `introspection`. |`introspection` | No
`config.cache_introspection` | Boolean value that controls whether an introspection result should be cached. | `true` | No
`config.introspect_jwt_tokens` | Boolean value that controls if JWTs sent in an Authorization header should also be introspected. | `false` | No
`config.introspection_endpoint` | Endpoint for introspection. Might be needed if discovery is not possible. | `https://idsvr.example.com/oauth/v2/oauth-introspect` | No

### Test the configuration

Any supported OAuth/OIDC flow can be used to obtain an opaque access token from the Curity Identity Server. Several approaches for obtaining a token are outlined in the [Curity Getting Started Guide][curity-getting-started]. Make sure that the token issued contains the `openid` scope.

Call the exposed service created earlier and pass the opaque access token in the `Authorization` header.

```bash
curl -X GET http://kong:8000/httpbin/get \
--header "Authorization: Bearer <OPAQUE ACCESS TOKEN"
```

Kong introspects the opaque token and receives the JWT in the response. The JWT is forwarded to the upstream API. Because the configured upstream API is `httpbin`, it is echoed back. The below sample response shows the `phantom_token` that contains the JWT and can be consumed by the API. The response is truncated for readability.

```json
{
    "args": {},
    "headers": {
        ...
        "Host": "httpbin.org",
        "Phantom-Token": "eyJraWQiOiIxN...",
        "X-Forwarded-Host": "localhost",
        "X-Forwarded-Path": "/httpbin/get",
        "X-Forwarded-Prefix": "/httpbin"
    },
    "origin": "172.27.0.1, 69.181.2.136",
    "url": "http://localhost/get"
}
```

### Resources
* Overview of the [Phantom Token Pattern][curity-phantom-token-pattern]
* Information on the [Introspection and Phantom Tokens][curity-phantom-token-introspection] flow
* Installing the [Curity Identity Server][curity-getting-started]

----

## Kong Dev Portal Authentication

The [Kong Developer Portal][kong-dev-portal-doc] is a part of {{site.ee_product_name}}. The portal enables developers to access and manage configured services and documentation to provide a streamlined onboarding process. The Kong Dev Portal supports various options for user authentication and access control. This guide outlines how to configure the Kong OpenID Connect Plugin to leverage the Curity Identity Server as a third-party Identity Provider for user Authentication to the Dev Portal.

### Curity Setup

The Kong Dev Portal needs a client configured in the Curity Identity Server. The [Curity Getting Started Guide][curity-getting-started] outlines details on how to configure a client. The configuration details below should be sufficient:

- Authentication method: `secret`. Make note of the Secret and use it in the `client_secret` field in the Developer Portal configuration (see below).
- Capabilities: `Code Flow`.
- Following scopes: `openid`, `profile`, and `email`.
- Choose suitable authentication methods.
- Add redirect URI (by default `http://kong:8004/<WORKSPACE_NAME>/auth`).

{:.note}
> **NOTE:** There is an issue with short-lived access tokens that is under investigation. Increase the `Access Token Time to Live` in the client configuration to `3000` as a temporary workaround.

More information is available in the [Code Flow][curity-code-flow-tutorial] tutorial.

### Configure OpenID Connect in the Kong Developer Portal

Enabling the Kong Developer Portal is outlined in the [Kong Dev Portal Documentation][kong-dev-portal-doc] and not covered in this article. The documentation also covers how to configure the [OpenID Connect Plugin][kong-dev-portal-doc-oidc].

#### Example Configuration Object

Below is an example configuration object that is used to configure the OIDC plugin for the Dev Portal.

```json
{
    "redirect_uri": ["https://kong-dev-portal:8004/default/auth"],
    "consumer_by": ["username","custom_id","id"],
    "leeway": 1000,
    "scopes": ["openid","profile","email"],
    "logout_query_arg": "logout",
    "login_redirect_uri": ["https://kong-dev-portal:8003"],
    "login_action": "redirect",
    "logout_redirect_uri": ["https://kong-dev-portal:8003"],
    "ssl_verify": false,
    "client_id": ["kong-dev-portal-client"],
    "forbidden_redirect_uri": ["https://kong-dev-portal:8003/unauthorized"],
    "client_secret": ["Pa$$w0rd!"],
    "issuer": "https://idsvr.example.com/oauth/v2/oauth-anonymous/",
    "logout_methods": ["GET"],
    "consumer_claim": ["email"],
    "login_redirect_mode": "query"
}
```

![Enable OIDC in Kong Dev Portal](/assets/images/docs/dev-portal/curity/kong-dev-portal.png)

### Curity Authentication Action

An Authentication Action to automatically provision the user to the Kong Developer Portal is available in the Curity GitHub repository. Using the Action is not mandatory as the user could be provisioned in other ways, such as manually through the Kong Developer portal login page. However, using the Authentication Action would streamline the user flow since the Action takes the user's full name and the email from the Curity Authenticator and automatically provision that to the Kong Developer Portal using the exposed API.

The [The Kong Developer Portal User Provisioner][curity-kong-dev-portal-user-provisioner] action is available as open source and can be forked to fit the needs of the environment as needed.

#### Configuration

This Action is straightforward to configure. An HTTP Client is needed to communicate with the Kong Dev Portal API. By default, the **HTTP Authentication** can be left out. Only a correct scheme needs to be configured (HTTP or HTTPS).

The Action also configures the URL to the registration endpoint of the Kong Developer Portal. Here the scheme needs to match what's configured in the HTTP Client used.

![Kong Dev Portal User Provisioner](/assets/images/docs/dev-portal/curity/kong-dev-portal-action.png)

When the action is created, it can be assigned to the Authenticators used in the client configured in the Curity Identity Server as described above.

#### Action to Resolve Additional User Information

Depending on the Authenticator used, an additional Action may be needed to resolve additional information. By default, The Kong Developer portal provisioning requires `Full Name` and `email`. If the Authenticator does not provide this, it's possible to use an Action to resolve the data. This could be as simple as a **Data Source** action configured to use a Data Source that provides the information.

![Chain Actions](/assets/images/docs/dev-portal/curity/authentication-and-actions.png)

By default, the Kong Developer Portal Provisioner Action works on the default account table schema of the Curity Identity Server database. This provides `email` as a column, but the `Full Name` is not readily available. The Action operates on the `attributes` column and parse the information to pass the user's Full Name to the Kong Dev Portal.

The attributes column contains this structure:

```json
{"emails":[{"value":"alice@example.com","primary":true}],"phoneNumbers":[{"value":"555-123-1234","primary":true}],"name":{"givenName":"alice","familyName":"anderson"},"agreeToTerms":"on","urn:se:curity:scim:2.0:Devices":[]}
```

The data source used to resolve additional information needs to be configured with an appropriate **Attribute Query**. This would look similar to this:

```sql
select * from "accounts" where "username"= :subject
```

### Conclusion

With relatively simple configurations in both the Curity Identity Server and the Kong Developer Portal, it's possible to leverage Curity as the Identity Provider for the Kong Dev Portal. This provides a very seamless flow for user authentication to the Kong Dev Portal. With the added capability of an Authentication Action, it is possible to automatically provision the user to the Kong Dev Portal for an even more streamlined experience.

[kong-add-service]: /gateway/{{page.kong_version}}/admin-api/#service-object
[curity-phantom-token-introspection]: https://curity.io/resources/learn/introspect-with-phantom-token
[curity-getting-started]: https://curity.io/resources/getting-started
[curity-phantom-token-pattern]: https://curity.io/resources/learn/phantom-token-pattern
[curity-code-flow-tutorial]: https://curity.io/resources/learn/code-flow
[curity-kong-dev-portal-user-provisioner]: https://curity.io/resources/learn/provision-kong-dev-portal-user
[kong-dev-portal-doc]: /gateway/{{page.kong_version}}/developer-portal
[kong-dev-portal-doc-oidc]: /gateway/{{page.kong_version}}/developer-portal/configuration/authentication/oidc
