---
title: OpenID Connect with Okta
---
## Introduction

This guide covers an example OpenID Connect plugin configuration to authenticate browser clients using an Okta identity provider.

For information about configuring OIDC using Okta as an Identity provider
in conjunction with the Application Registration plugin, see
[Set Up External Portal Application Authentication with Okta and OIDC](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/okta-config).

## Prerequisites

Because OpenID Connect deals with user credentials, all transactions should take place over HTTPS.
Although user passwords for third party identity providers are only submitted to
those providers and not Kong, authentication tokens grant access to a subset of
user account data and protected APIs, and should be secured. As such, you should
make Kong's proxy available via a fully-qualified domain name and [add a certificate][add-certificate] for it.

## Kong Configuration

If you have not yet [added a **Route** and a **Service**][add-service], go ahead
and do so. Again, note that you should be able to secure this route with HTTPS,
so use a hostname you have a certificate for. Add a location handled by your route
as an authorized redirect URI in Okta (under the **Authentication** section of your app registration).

## Okta IdP Configuration

### Sample Okta Configuration Steps

1. [Register an Application][okta-register-app]. Select the **Applications** page, click **Add Application**.

2. Select **Web** as the platform.

3. Fill out the Application's Settings.

    **Login re-direct URIs** is a URI that corresponds to a Route you have configured in Kong that will use Okta to authenticate. **Group Assignment** defines who is allowed to use this application. **Grant Type Allowed** indicates the Grant types to allow for your application.

4. After submitting the Application configuration, the client credentials will display on the **General** page.

5. [Define and configure an Authorization server][okta-authorization-server]. Select the **API** page and add an Authorization Server if you don't have an existing one to use.

6. Click **Save** and view your Authorization Server Settings.

## Plugin Configuration

Add a plugin with the configuration below to your Route using an HTTP client or [Kong Manager][enable-plugin].

```bash
$ curl -i -X POST https://admin.kong.example/routes/ROUTE_ID/plugins --data name="openid-connect" \
  --data config.issuer="https://YOUR_OKTA_DOMAIN/oauth2/YOUR_AUTH_SERVER/.well-known/openid-configuration" \
  --data config.client_id="YOUR_CLIENT_ID" \
  --data config.client_secret="YOUR_CLIENT_SECRET" \
  --data config.redirect_uri="https://kong.com/api" \
  --data config.scopes="openid" \
  --data config.scopes="email" \
  --data config.scopes="profile"
```

Some of the configurations above must use values specific to your environment:

* The `issuer` URL can be found from your Authorization Server settings.
* The `redirect_uri` should be the URI you specified earlier when configuring your app.
You can view and edit this from the **General** page for your application.
* For `client_id` and `client_secret`, replace `YOUR_CLIENT_ID` and `YOUR_CLIENT_SECRET`
with the client ID and secret shown in your Okta application's **General** page.

Visiting a URL matched by that route in a browser will now redirect to Okta's authentication
site and return you to the redirect URI after authenticating.

Additional plugin parameter to consider:

* The `auth_methods` parameter defines a lists of all the authentication methods
that you want the plugin to accept. By default, its value is a list of all the supported methods.
It is advisable to define this parameter with only the methods you want to allow.

### Access Restrictions

The configuration above allows users to authenticate and access the Route even though
no Consumer was created for them: any user with a valid account in the directory
will have access to the Route. The OIDC plugin allows this as the simplest authentication option,
but you may wish to restrict access further. There are several options for this:

- Consumer Mapping
- Pseudo-Consumer Mapping

#### Consumer Mapping

If you need to interact with other Kong plugins using consumer information, you
can add configuration that maps account data received from the identity provider to a Kong consumer.
For this example, the user's Okta's AD account GUID is mapped to a Consumer by setting it
as the `custom_id` on their consumer:

```bash
$ curl -i -X POST http://admin.kong.example/consumers/ \
  --data username="Yoda" \
  --data custom_id="e5634b31-d67f-4661-a6fb-b6cb77849bcf"

$ curl -i -X PATCH http://admin.kong.example/plugins/OIDC_PLUGIN_ID \
  --data config.consumer_by="custom_id" \
  --data config.consumer_claim="sub"
```

Now, if a user logs into an Okta account with the GUID `e5634b31-d67f-4661-a6fb-b6cb77849bcf`, Kong will apply configuration associated with the Consumer `Yoda` to their requests.

This also requires that clients login using an account mapped to some Consumer, which might
not be desirable (e.g., you apply OpenID Connect to a service, but only use plugins
requiring a Consumer on some Routes). To deal with this, you can set the `anonymous` parameter
in your OIDC plugin configuration to the ID of a generic Consumer, which will
then be used for all authenticated users that cannot be mapped to some other Consumer.
You can alternately set `consumer_optional` to `true` to allow similar logins
without mapping an anonymous Consumer.

#### Pseudo-consumers

For plugins that typically require consumers, the OIDC plugin can provide a consumer ID based on the value of a claim without mapping to an actual Consumer. Setting `credential_claim` to a claim [in your plugin configuration][credential-claim] will extract the value of that claim and use it where Kong would normally use a consumer ID. Note that this may not work with all consumer-related functionality.

Similarly, setting `authenticated_groups_claim` will extract that claim's value and use it as a group for the ACL plugin.

[okta-authorization-server]: https://developer.okta.com/docs/guides/customize-authz-server/create-authz-server/
[okta-register-app]: https://developer.okta.com/docs/guides/add-an-external-idp/openidconnect/register-app-in-okta/
[add-certificate]: /gateway/latest/admin-api/#add-certificate
[add-service]: /enterprise/{{page.kong_version}}/kong-manager/add-service
[credential-claim]: https://docs.konghq.com/hub/kong-inc/openid-connect/#configcredential_claim
[enable-plugin]: /enterprise/{{page.kong_version}}/kong-manager/enable-plugin/
