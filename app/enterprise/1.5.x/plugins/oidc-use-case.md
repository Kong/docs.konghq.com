---
title: OpenID Connect Use Case
---

## What does OpenID Connect do? 

OpenID Connect provides a way to form a *federation* with *identity providers*. Identity providers are third parties that store account credentials. If the identity provider authenticates a user, the application trusts that provider and allows access to the user. The *identity provider* bears some responsibility for protecting the user’s credentials and ensuring authenticity, so applications no longer need to on their own.

Besides delegating responsibility to an identity provider, OpenID Connect also makes single sign-on possible without storing any credentials on a user’s local machine. 

Finally, enterprises may want to manage access control for many applications from one central system of record. For example, they may want employees to be able to access many different applications using their email address and password. They may want to also change access (e.g. if an employee separates or changes roles) from one central point. OpenID Connect addresses this challenge by providing a way for many different applications to authenticate users through the same third-party identity provider. 

## What does Kong’s OpenID Connect Plugin do? 

Just as OpenID Connect enables developers to offload authentication to another party, Kong enables developers to separate entire processes from their applications. Rather than needing to hand write the code for OpenID Connect *within* a service, developers can place Kong in front of the service and have Kong handle authentication. This separation allows developers to focus on the business logic within their application. It also allows them to easily swap out services while preserving authentication at the front door, and to effortlessly spread the same authentication to *new* services.

Kong users may prefer OpenID Connect to other authentication types, such as Key Auth and Basic Auth, because they will not need to manage the database storing passwords. Instead, they can offload the task to a trusted identity provider of their choice.

While the OpenID Connect Plugin can suit many different use cases and extends to other Plugins such as JWT (JSON Web Token) and 0Auth 2.0, the most common use case is the Authorization Code flow. 

## How does the Authorization Code flow work with the OpenID Connect Plugin and Okta? 

**Sign In**

![OIDC signin flow](/assets/images/docs/ee/plugins/oidc-use-case/OIDCsignin.png)

1. If the client does not have a session cookie, it initiates sign in with Kong.
2. Kong responds to the client with an **authorization cookie** and a location to redirect (with Okta as the header).
3. the client redirects to Okta so the user can sign in.
4. Okta responds with an **authorization code** and a location to redirect (with Kong as the header).

At this point, the client has successfully signed in and has an **authorization code** (from Okta) and an **authorization cookie** (from Kong).

**Access**

![OIDC access flow](/assets/images/docs/ee/plugins/oidc-use-case/OIDCaccess.png)

1. The client redirects to Kong and automatically sends the **authorization code** (from Okta) and an **authorization cookie** (from Kong).
2. Kong verifies the **authorization code** with Okta.
3. Okta sends and **access token** and **ID token** to Kong.
4. Kong proxies the client request with the **access token** from Okta.
5. Kong receives a service response.
6. Kong sends the service response to the client, along with a **session cookie** for future access.

At this point, the client now has a **session** with Kong that allows mediated access to the service. 

**Session**

![OIDC session flow](/assets/images/docs/ee/plugins/oidc-use-case/OIDCsession.png)

1. The client sends requests with a **session cookie**.
2. Kong matches the session cookie to the associate **access token** and proxies the request.
3. Kong gets a response from the service.
4. Kong sends the response to the client.

Kong’s session with the client ensures that the client does not need to make constant requests to Okta. The duration of the session can be configured.

## Example of configuring the OIDC Plugin with Okta

### Order of configuration

* Prerequisites
* Steps in Okta
* Steps in Enterprise
  * Using Kong Manager
  * Using Admin API

### Prerequisites

The steps in the guide offer an example of configuring OIDC with Okta on a specific route. To follow this guide, you need the following:

* A developer account with Okta.
* A running version of Kong Enterprise.
* Access to the OpenID Connect plugin.
* A route in Kong Enterprise whose access you want to protect with Okta. For this guide, assume the route is in the default Workspace.
* If using Kong Enterprise locally, you need Internet access.
* Any network access control to your Kong node must allow traffic to and from Okta, the upstream service, and the client.

### Steps in Okta

1. [Register](https://developer.okta.com/docs/guides/add-an-external-idp/openidconnect/register-app-in-okta/) the application you are using Kong to proxy. 
2. Select Applications > **Add Application**.

    ![Okta 1](/assets/images/docs/ee/plugins/oidc-use-case/okta1.png)

3. Select **Web** as the platform.

    ![Okta 2](/assets/images/docs/ee/plugins/oidc-use-case/okta2.png)

4. Complete the Application Settings dialog and click **Submit**.
    1. **Login redirect URIs** is a URI that corresponds to a route you have configured in Kong that uses Okta to authenticate. 
    2. **Group Assignment** defines which groups of users are allowed to use this application. 
    3. **Grant Type Allowed** indicates the grant types to allow for your application.

    ![Okta 3](/assets/images/docs/ee/plugins/oidc-use-case/okta3.png)

  Group Assignment defines who is allowed to use this application. Grant Type Allowed indicates the Grant types to allow for your application.

5. After submitting the Application configuration, the client credentials are generated and display on the Dashboard page. You will use these credentials for configuring the Kong OIDC Plugin.

    ![Okta 4](/assets/images/docs/ee/plugins/oidc-use-case/okta4.png)

6. Add an Authorization Server. Go to the **API > Authorization Server** and create a server named **Kong API Management** and include an audience and description. Click **Save**. 

    ![Okta 5](/assets/images/docs/ee/plugins/oidc-use-case/okta5.png)

    ![Okta 6](/assets/images/docs/ee/plugins/oidc-use-case/okta6.png)

7. On the **Kong API Management > Settings** page, note the **Issuer** address which you will use for configuring the Kong OIDC Plugin.

    ![Okta 7](/assets/images/docs/ee/plugins/oidc-use-case/okta7.png)

### Steps in Kong Enterprise

The following are steps you perform in Kong Enterprise to enable the OIDC Plugin using Okta as an Identity Provider for the Authorization Code flow. 

### Minimum Configuration Requirements for the Kong OIDC Plugin

For a basic out-of-the-box use case with the Authorization Code as the auth method, configure the following parameters:

* **issuer**: The issuer `url` from which OpenID Connect configuration can be discovered. Using Okta, specify the domain and server in the path:
    * `https://YOUR_OKTA_DOMAIN/oauth2/YOUR_AUTH_SERVER/.well-known/openid-configuration`
* **auth_method**: A list of authentication methods to use with the plugin, such as passwords, introspection tokens, etc. The majority of cases use `authorization_code`, and Kong falls back to `authorization_code` if no other methods are specified.
* **client_id**: The `client_id` of the OpenID Connect client registered in OpenID Connect Provider. Okta provides one to identify itself.  
* **client_secret**: The `client_secret` of the OpenID Connect client registered in OpenID Connect Provider. These credentials should never be publicly exposed.
* **redirect_uri**: The `redirect_uri` of the client defined with `client_id` (also used as a redirection URI for the authorization code flow).
* **scopes**:  The scope of what OpenID Connect checks. `openid` by default; set to `email` and `profile` for this example.

### Enable and configure the OpenID Connect Plugin with Kong Manager

1. Go to Workspaces and select the workspace where your route is configured.
2. Click **Routes** in the left navigation.
3. On the Routes page, select the route you have configured to protect with Okta and click **View**. 
4. Scroll to the bottom of the page and click the **Plugins** tab. 
5. Click **Add Plugin**. 
6. On the Plugins page, enable the **OpenID Connect** plugin.

    ![Kong Manager OIDC plugin selection](/assets/images/docs/ee/plugins/oidc-use-case/KM1.png)

7. Configure OpenID Connect’s parameters with the following values:

    1.  **config.issuer:** [https://YOUR_OKTA_DOMAIN/oauth2/YOUR_AUTH_SERVER/.well-known/openid-configuration](https://your_okta_domain/oauth2/YOUR_AUTH_SERVER/.well-known/openid-configuration)
    2. **config.client_id:** YOUR_CLIENT_ID
    3. **config.client_secret:** YOUR_CLIENT_SECRET
    4. **config.redirect_uri:** https://kong.com/api
    5. **config.scopes:** openid
    6. **config.scopes:** email
    7. **config.scopes:** profile
 
    ![Kong Manager OIDC plugin configuration](/assets/images/docs/ee/plugins/oidc-use-case/KM2.png)

8. After enabling OpenID Connect, a list of all the plugins displays.

    ![Kong Manager plugin list](/assets/images/docs/ee/plugins/oidc-use-case/KM3.png)


### Enable and configure the OpenID Connect Plugin with the Admin API

With an HTTP Client, enter the following cURL command and parameters to configure the OpenID Connect Plugin. Use this as a template, and modify according to your own environment and configuration values. 

```bash
$ curl -i -X POST https://KONG_ADMIN_URL/routes/ROUTE_ID/plugins 
  --data name="openid-connect"                                                                             \
  --data config.issuer="https://YOUR_OKTA_DOMAIN/oauth2/YOUR_AUTH_SERVER/.well-known/openid-configuration" \
  --data config.client_id="YOUR_CLIENT_ID"                                                                 \
  --data config.client_secret="YOUR_CLIENT_SECRET"                                                         \
  --data config.redirect_uri="https://kong.com/api"                                                        \
  --data config.scopes="openid"                                                                            \
  --data config.scopes="email"                                                                             \
  --data config.scopes="profile"
```

### Test Your Configuration

Test the following conditions to ensure a successful integration of the OIDC plugin with Okta. Depending on the route you are using, the actual commands might vary. The following is an example of testing your configuration.

* Unauthorized access to a route is blocked
* Authorized access is allowed after login/providing first set of credentials
    * Ensure the identity is registered with the IdP
    * Steps for debugging
* Authorized access is allowed on immediate subsequent attempts
    * Perhaps highlight where the cookie is stored
* Previously authorized access is no longer allowed after cookie terminates
    * Set a very short TTL on the session to ensure the tester doesn’t need to wait long to get locked out
