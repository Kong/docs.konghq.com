---
nav_title: Overview
---

The JWT plugin lets you verify requests containing HS256 or RS256 signed JSON Web Tokens (JWT), 
as specified in [RFC 7519](https://tools.ietf.org/html/rfc7519).

When you enable this plugin, it grants JWT credentials (public and secret keys) 
to each of your consumers, which must be used to sign their JWTs.
You can then pass a token through any of the following:

- A query string parameter
- A cookie
- HTTP request headers

Kong will either proxy the request to your upstream services if the token's
signature is verified, or discard the request if not. Kong can also perform
verifications on some of the registered claims of RFC 7519 (`exp` and `nbf`).
If Kong finds multiple tokens that differ, even if they are valid, the request
will be rejected to prevent JWT smuggling.

## Get started with the JWT plugin

* [Configuration reference](/hub/kong-inc/jwt/configuration/)
* [Basic configuration example](/hub/kong-inc/jwt/how-to/basic-example/)
* [Configure the JWT plugin](/hub/kong-inc/jwt/how-to/setup/)
* [Use the JWT plugin with Auth0](/hub/kong-inc/jwt/how-to/auth0/)
* [Paginate through the JWTs](/hub/kong-inc/jwt/how-to/paginate/)
* [Retrieve the Consumer associated with a JWT](/hub/kong-inc/jwt/how-to/retrieve-consumer/)

[api-object]: /gateway/latest/admin-api/#api-object
[configuration]: /gateway/latest/reference/configuration
[consumer-object]: /gateway/latest/admin-api/#consumer-object
