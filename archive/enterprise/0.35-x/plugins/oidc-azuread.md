---
title: OpenID Connect with Azure AD
---
## Introduction

This guide covers an example OpenID Connect plugin configuration to authenticate browser clients using an Azure AD identity provider.

## Prerequisites

Because OpenID Connect deals with user credentials, all transactions should take place over HTTPS. Although user passwords for third party identity providers are only submitted to those providers and not Kong, authentication tokens do grant access to a subset of user account data and protected APIs, and should be secured. As such, you should make Kong's proxy available via a fully-qualified domain name and [add a certificate][add-certificate] for it.

## Kong Configuration

If you have not yet [added a **Route** and a **Service**][add-service], go ahead and do so. Again, note that you should be able to secure this route with HTTPS, so use a hostname you have a certificate for. Add a location handled by your route as an authorized redirect URI in Azure (under the **Authentication** section of your app registration).

## Azure AD IDP Configuration

You must [register an app][azure-create-app] in your Azure AD configuration and [add a client secret credential][azure-client-secret] that Kong will use to access it. You must also configure a redirect URI that is handled by your Route.

Azure AD provides two interfaces for its OAuth2/OIDC-related endpoints, v1.0 and v2.0. Support for some legacy v1.0 behavior is still available on v2.0, including use of v1.0 tokens by default, which is not compatible with Kong's OIDC implementation. To force Azure AD to use v2.0 tokens, [edit your application manifest][azure-manifest] and set `accessTokenAcceptedVersion` to `2` and include a `YOUR_CLIENT_ID/.default` scope in your plugin configuration as shown below.

## Plugin Configuration

Add a plugin with the configuration below to your route using an HTTP client or [Kong Manager][enable-plugin].

```bash
$ curl -i -X POST https://admin.kong.example/routes/ROUTE_ID/plugins --data name="openid-connect" \
  --data config.issuer="https://login.microsoftonline.com/YOUR_DIRECTORY_ID/v2.0/.well-known/openid-configuration" \
  --data config.client_id="YOUR_CLIENT_ID" \
  --data config.client_secret="YOUR_CLIENT_SECRET" \
  --data config.redirect_uri="https://example.com/api" \
  --data config.scopes="openid" \
  --data config.scopes="email" \
  --data config.scopes="profile" \
  --data config.scopes="YOUR_CLIENT_ID/.default" \
  --data config.verify_parameters="false" 
```

Several pieces of configuration above must use values specific to your environment:

* The `issuer` URL can be retrieved by pressing the **Endpoints** button on your app registration's **Overview** page.
* `redirect_uri` should be the URI you specified earlier when configuring your app. You can add one via the **Authentication** section of the app settings if you did not add one initially.
* For `client_id` and `scopes` replace `YOUR_CLIENT_ID` with the client ID shown on the app **Overview** page.
* For `client_secret` replace `YOUR_CLIENT_SECRET` with the URL-encoded representation of the secret you created earlier in the **Certificates & secrets** section. Azure AD secrets often include reserved URL characters, which cURL may handle incorrectly if they are not URL-encoded.

Visiting a URL matched by that route in a browser will now redirect to Microsoft's authentication site and return you to the redirect URI after authenticating.

### Access Restrictions

The configuration above allows users to authenticate and access the Route even though no consumer was created for them: any user with a valid account in the directory will have access to the Route. The OIDC plugin allows this as the simplest authentication option, but you may wish to restrict access further. There are several options for this:

#### Domain Restrictions

Azure AD does not provide identity tokens with the `hd` claim, and as such the OIDC plugin's `domains` configuration cannot restrict users based on their domain. Using a [single-tenant][azure-tenant] application will restrict access to users in your directory only. Multi-tenant apps allow users with Microsoft accounts from other directories and optionally any Microsoft account (e.g. live.com or Xbox accounts) to sign in.

#### Consumer Mapping

If you need to interact with other Kong plugins using consumer information, you can add configuration that maps account data received from the identity provider to a Kong consumer. For this example, the user's Azure AD account GUID is mapped to a consumer by setting it as the `custom_id` on their consumer, e.g.

```bash
$ curl -i -X POST http://admin.kong.example/consumers/ \
  --data username="Yoda" \
  --data custom_id="e5634b31-d67f-4661-a6fb-b6cb77849bcf"

$ curl -i -X PATCH http://admin.kong.example/plugins/OIDC_PLUGIN_ID \
  --data config.consumer_by="custom_id" \
  --data config.consumer_claim="oid"
```

Now, if a user logs into an Azure AD account with the GUID `e5634b31-d67f-4661-a6fb-b6cb77849bcf`, Kong will apply configuration associated with the consumer `Yoda` to their requests. 

This also requires that clients login using an account mapped to some consumer, which may not be desirable (e.g. you apply OpenID Connect to a service, but only use plugins requiring a consumer on some routes). To deal with this, you can set the `anonymous` parameter in your OIDC plugin configuration to the ID of a generic consumer, which will then be used for all authenticated users that cannot be mapped to some other consumer. You can alternately set `consumer_optional` to `true` to allow similar logins without mapping an anonymous consumer.

#### Pseudo-consumers

For plugins that typically require consumers, the OIDC plugin can provide a consumer ID based on the value of a claim without mapping to an actual consumer. Setting `credential_claim` to a claim [in your plugin configuration][credential-claim] will extract the value of that claim and use it where Kong would normally use a consumer ID. Note that this may not work with all consumer-related functionality.

Similarly, setting `authenticated_groups_claim` will extract that claim's value and use it as a group for the ACL plugin.

[azure-client-secret]: https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-configure-app-access-web-apis#add-credentials-to-your-web-application
[azure-create-app]: https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app
[azure-manifest]: https://docs.microsoft.com/en-us/azure/active-directory/develop/reference-app-manifest#configure-the-app-manifest
[azure-tenants]: https://docs.microsoft.com/en-us/azure/active-directory/develop/single-and-multi-tenant-apps
[add-certificate]: /1.0.x/admin-api/#add-certificate
[add-service]: /enterprise/{{page.kong_version}}/getting-started/add-service
[oidc-id-token]: http://openid.net/specs/openid-connect-core-1_0.html#IDToken
[credential-claim]: https://docs.konghq.com/hub/kong-inc/openid-connect/#configcredential_claim
[enable-plugin]: /enterprise/{{page.kong_version}}/getting-started/enable-plugin/
