---
title: OpenID Connect with Amazon Cognito
badge: enterprise
---

## Amazon Cognito Configuration

Amazon Cognito has two significant components: Identity Pools and User Pools. Identity Pools are the original functionality deployed in 2014; they mainly use proprietary AWS interfaces and libraries to accomplish the task of authenticating users. Furthermore, Identity Pools have no concept of claims (standard or custom) stored in the system; it is entirely a federated identity construct. User Pools are the more recent addition to the Cognito feature set; User Pools are a multi-tenant LDAP-like user repository combined with an OAuth2 and an OpenID Connect interface.

In this configuration, we use User Pools.

1. Log in to AWS Console.
1. Navigate to the Amazon Cognito Service.

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito1.png">

1. Click on **Manage User Pools**.

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito2.png">

1. Click the **Create a user pool** button on the right-hand side.

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito3.png">

1. Enter a pool name; we use “test-pool” for this example.

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito4.png">

1. Click **Step Through Settings**.

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito5.png">

1. Select **Email address or phone number**, and under that, select **Allow email addresses**. Select the following standard attributes as required: email, family name, given name.

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito6.png">

1. Click **Next step**.
1. Accept the defaults for **Password settings**, then click **Next step**.
1. Accept the defaults for **MFA and verifications**, then click **Next step**.
1. Accept the defaults for **Message customizations**, click **Next step**.
1. On the next screen, we are not going to create any tags. Click **Next step**.
1. Select **No** for **Do you want to remember your user’s devices**, then click **Next step**.
1. We can create an application definition later. Keep things simple for now and click **Next step**.
1. We don’t have any need for Triggers or customized Sign Up/Sign In behavior for this example. Scroll down and click **Save Changes**.

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito7.png">

1. Click **Create pool**. Wait a moment for the success message.
1. Make a note of the **Pool ID**. You will need this when configuring the application later.

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito8.png">

## Application Definition

You need to add an OAuth2 application definition to the User Pool we just created.

1. Go to the App clients screen in the AWS Cognito management screen for the User Pool we just created.

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito9.png">

1. Click “Add an app client”.

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito10.png">

1. Enter an App client name. This demo is using “kong-api”

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito11.png">

1. Enter a Refresh token expiration (in days). We will use the default of 30 days.
1. Do not select “Generate client secret”. This example will use a public client.

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito12.png">

1. Do not select any other checkboxes.

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito13.png">

1. Click the “Set attribute read and write permissions” button.

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito14.png">

1. Let’s make this simple and only give the user read and write access to the required attributes. So, uncheck everything except the email, given name, and family name fields.

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito15.png">

1. Click “Create app client”

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito16.png">

1. Click “Show Details”.

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito17.png">

1. Take note of the App client ID. We will need that later.
1. Go to the App integration -> App client settings screen.
1. Click the “Cognito User Pool” checkbox under Enabled Identity Providers.
1. Add the following to the Callback URLs field:

    ```
    “https://kong-ee:8446/default, https://kong-ee:8447/default/, https://kong-ee:8447/default/auth, https://kong-ee:8443/cognito”
    ```

    Note that AWS Cognito doesn’t support HTTP callback URLs. This field should
    include the API and Dev Portal URLs that you want to secure using AWS Cognito.

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito18.png">

1. Click the “Authorization code grant” checkbox under Allowed OAuth Flows.

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito19.png">

1. Click the checkboxes next to email, OpenID, aws.cognito.signin.user.admin, and profile.
1. Click the “Save changes” button.
1. Click on the domain name tab.
1. Add a sub-domain name.
1. Click the Check Availability button.
1. As long as it reports “This domain is available”, the name you have chosen will work.

    <img src="https://doc-assets.konghq.com/oidc/cognito/cognito21.png">

1. Click the “Save changes” button.

Now that you have created an Amazon Cognito User Pool and Application Definition, we can configure the OpenID Connect plugin in Kong. We can then test integration between Dev Portal and Amazon Cognito.

Amazon’s OIDC discovery endpoint is available from:
```
https://cognito-idp.<REGION>.amazonaws.com/<USER-POOL-ID>
```

For example, in this demo, the OIDC discovery endpoint is:

```
https://cognito-idp.ap-southeast-1.amazonaws.com/ap-southeast-1_ie577myCv/.well-known/openid-configuration
```

The OAuth + OIDC debugger is a handy utility that you may use to test the authorization flow before configurations in Kong.

## OIDC Plugin Configuration

Identify the Route or Service to be secured. In our example, we created a new route called /cognito to which we added the OpenID Connect plug-in.  
The number of options in the plug-in can seem overwhelming but the configuration is rather simple. All you need to do is configure:
* `issuer` - You can use the OIDC discovery endpoint here, e.g.
    ```
    https://cognito-idp.ap-southeast-1.amazonaws.com/ap-southeast-1_ie577myCv/.well-known/openid-configuration
    ```
* `config.client_id` - This is the client ID noted when the application was created
* `config.client_secret` - This is the client secret noted when the application was created. In this demo we are leaving this blank as we didn’t create a client secret.
* `config.auth_methods` - If this is left blank, all flows will be enabled. If only specific flows are in scope, configure the appropriate flows accordingly.  

## Validating the Flows

You can test the route by accessing URL “https://kong-ee:8443/cognito/anything”, and you should redirect to the Amazon Cognito login page. You need to click “Sign up” link to create a user first using your email address. The application sends a verification code to your email. Once you enter the verification code, Amazon Cognito acknowledges the account.

You can verify the confirmed user from the Cognito page under “General settings” -> “Users and groups”.

## Dev Portal Integration

{% include_cached /md/admin-listen.md desc='long' %}

Since AWS Cognito only supports the HTTPS protocol, when you start {{site.base_gateway}}, ensure that HTTPS protocol for Dev Portal is enabled. For example:

```
docker run -d --name kong-ee --link kong-ee-database:kong-ee-database \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-ee-database" \
  -e "KONG_CASSANDRA_CONTACT_POINTS=kong-ee-database" \
  -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
  -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
  -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_LISTEN=0.0.0.0:8001 , 0.0.0.0:8444 ssl" \
  -e "KONG_PORTAL=on" \
  -e "KONG_ENFORCE_RBAC=off" \
  -e "KONG_ADMIN_GUI_URL=http://kong-ee:8002" \
  -e "KONG_AUDIT_LOG=on" \
  -e "KONG_PORTAL_GUI_PROTOCOL=https" \
  -e "KONG_PORTAL_GUI_HOST=kong-ee:8446" \
  -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" \
  -p 8000-8004:8000-8004 \
  -p 8443-8447:8443-8447 \
  kong-ee
```

Under Dev Portal settings, select “Open ID Connect” as the authentication plugin.

Copy and paste the following Auth Config JSON object:

```
{
    "leeway": 100,
    "consumer_by": [
        "username",
        "custom_id",
        "id"
    ],
    "scopes": [
        "openid",
        "profile",
        "email"
    ],
    "logout_query_arg": "logout",
    "client_id": [
        "1pf00c5or942c2hm37mgv0u509"
    ],
    "login_action": "redirect",
    "logout_redirect_uri": [
        "https://kongdemo.auth.ap-southeast-1.amazoncognito.com/logout?client_id=1pf00c5or942c2hm37mgv0u509&logout_uri=kong-ee:8446/default"
    ],
    "login_tokens": {},
    "login_redirect_uri": [
        "https://kong-ee:8446/default"
    ],
    "forbidden_redirect_uri": [
        "https://kong-ee:8446/default/unauthorized"
    ],
    "ssl_verify": false,
    "issuer": "https://cognito-idp.ap-southeast-1.amazonaws.com/ap-southeast-1_ie577myCv/.well-known/openid-configuration",
    "logout_methods": [
        "GET"
    ],
    "consumer_claim": [
        "email"
    ],
    "login_redirect_mode": "query",
    "redirect_uri": [
        "https://kong-ee:8447/default/auth"
    ]
}
```

To log out the user completely, we need to use the logout endpoint provided by Cognito (https://docs.aws.amazon.com/cognito/latest/developerguide/logout-endpoint.html). Therefore, in the above configuration, we have passed in Cognito logout endpoint of logout redirect URL.

Please also note that the developer signed up from Dev Portal doesn’t get created in Cognito automatically. Therefore, developer signup is a two-step process:
* The developer signs up from Dev Portal itself, so a Kong Admin needs to approve the developer access.
* The developer signs up from Amazon Cognito. Please make sure that you use the _same email address_ for both signups.
Now you should be able to login to Developer Portal using the Amazon Cognito user and credential.
