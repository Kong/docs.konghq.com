---
title: OpenID Connect with Google
---

## Introduction

This guide covers an example OpenID Connect plugin configuration to authenticate browser clients using Google's identity provider.

## Prerequisites

Because OpenID Connect deals with user credentials, all transactions should take place over HTTPS. Although user passwords for third party identity providers are only submitted to those providers and not Kong, authentication tokens do grant access to a subset of user account data and protected APIs, and should be secured. As such, you should make Kong's proxy available via a fully-qualified domain name and [add a certificate][add-certificate] for it.

## Google IDP configuration

Before configuring Kong, you'll need to set up a Google APIs project and create a credential set. Following [Google's instructions][google-oidc], [create a new set of OAuth client ID credentials][google-create-credentials] with the Web application class. Add an authorized redirect URI for part of the API you wish to protect (more complex applications may redirect to a resource that sets additional
application-specific state on the client, but for our purposes, any protected URI will work). Authorized JavaScript origins can be left blank.

You can optionally customize the consent screen to inform clients who/what application is requesting authentication, but this is not required for testing. All steps after can be ignored, as Kong handles the server-side authentication request and token validation.

## Kong configuration

If you have not yet [added an API][add-api], go ahead and do so. Again, note that you should be able to secure this API with HTTPS, so if you are configuring a host, use a hostname you have a certificate for.

### Basic plugin configuration

Add a plugin with the configuration below to your API using an HTTP client or the Admin GUI. Make sure to use the same redirect URI as configured earlier:

```bash
$ curl -i -X POST http://kong:8001/apis/example/plugins --data name="openid-connect" \
  --data config.issuer="https://accounts.google.com/.well-known/openid-configuration" \
  --data config.client_id="YOUR_CLIENT_ID" \
  --data config.client_secret="YOUR_CLIENT_SECRET" \
  --data config.redirect_uri="https://example.com/api" \
  --data config.scopes="openid,email"
```

Visiting a URL matched by that API in a browser will now redirect to Google's authentication site and return you to the redirect URI after authenticating. You'll note, however, that we did not configure anything to map authentication to consumers and that no consumer is associated with the subsequent request. Indeed, if you have configured other plugins that rely on consumer information, such as the ACL plugin, you will not have access. At present, the plugin configuration confirms that
users have a Google account, but doesn't do anything with that information.

Depending on your needs, it may not be necessary to associate clients with a consumer. You can, for example, configure the `domains` parameter to limit access to a internal users if you have a G Suite hosted domain, or configure `upstream_headers_claims` to send information about the user upstream (e.g. their email, a profile picture, their name, etc.) for use in your applications or for analytics.

### Consumer mapping

If you need to interact with other Kong plugins using consumer information, you must add configuration that maps account data received from the identity provider to a Kong consumer. For this example, we'll map the user's Google account email by setting a `custom_id` on their consumer, e.g.

```bash
$ curl -i -X POST http://kong:8001/consumers/ \
  --data username="Yoda" \
  --data custom_id="user@example.com"

$ curl -i -X PATCH http://kong:8001/apis/example/plugins/<OIDC plugin ID> \
  --data config.consumer_by="custom_id" \
  --data config.consumer_claim="email"
```

Now, if a user logs into a Google account with the email `user@example.com`, Kong will apply configuration associated with the consumer `Yoda` to their requests. Note that while Google provides account emails, not all identity providers will. OpenID Connect does not have many required claims--the [only required user identity claim][oidc-id-token] is `sub`, a unique subscriber ID. Many optional claims [are
standardized][oidc-standard-claims], however--if a provider returns an `email` claim, the contents will always be an email address.

This also requires that clients login using an account mapped to some consumer, which may not be desirable (e.g. you apply OpenID Connect to a service, but only use plugins requiring a consumer on some routes). To deal with this, you can set the `anonymous` parameter in your OIDC plugin configuration to the ID of a generic consumer, which will then be used for all authenticated users that cannot be mapped to some other consumer.


[add-certificate]: /0.13.x/admin-api/#add-certificate
[google-oidc]: https://developers.google.com/identity/protocols/OpenIDConnect
[google-create-credentials]: https://console.developers.google.com/apis/credentials
[add-api]: /enterprise/{{page.kong_version}}/getting-started/adding-your-api/
[oidc-id-token]: http://openid.net/specs/openid-connect-core-1_0.html#IDToken
[oidc-standard-claims]: http://openid.net/specs/openid-connect-core-1_0.html#StandardClaims
