---
title: OIDC Authenticated Group Mapping
badge: enterprise
---

Using Kong's [OpenID Connect plugin](/hub/kong-inc/openid-connect) (OIDC), you can map identity provider (IdP)
groups to Kong roles. Adding a user to Kong in this way gives them access to
Kong based on their group in the IdP.

Admin accounts are now created automatically
when you map your identity provider (IdP) groups to Kong roles. You do
not need to create the users, groups, and roles separately. These users then accept invitations to join
Kong Manager and log in with their IdP credentials.

{:.important}
> **Important:** In v2.7.x, the `admin_claim` parameter replaces the `consumer_claim` parameter required by
previous versions.

If an admin's group changes in the IdP, their Kong admin account's associated
role also changes in {{site.base_gateway}} the next time they log in to Kong
Manager. The mapping removes the task of manually managing access in
{{site.base_gateway}}, because it makes the IdP the system of record.

## Prerequisites

* An IdP with an authorization server and users with groups assigned
* [{{site.base_gateway}} installed and configured](/gateway/{{page.kong_version}}/install-and-run)
* Kong Manager enabled
* RBAC enabled
* (Kubernetes) [Helm](https://helm.sh/docs/intro/install/) installed

## Apply OIDC auth mapping to Kong Gateway

### Review important values

In the following examples, you specify the `admin_claim` and `authenticated_groups_claim` parameters
to identify which admin value and role name to map from the IdP to {{site.base_gateway}}, as well as
the `admin_auto_create_rbac_token_disabled` to specify whether an RBAC token is created for admins in Kong.

* The `admin_claim` value specifies which IdP username value should map to Kong Manager.
The username and password are required for the user to log into the IdP.

* The `authenticated_groups_claim` value specifies which IdP claim should be used to assign {{site.base_gateway}} roles to the
specified {{site.base_gateway}} admin.

  This value depends on your IdP -- for example, Okta configures claims for `groups`, and another IdP might configure them as `roles`.

  In the Idp, the group claim value must follow the format `<workspace_name>:<role_name>`.

  For example, if `"authenticated_groups_claim": ["groups"]` is specified, and in the IdP `groups:["default:super-admin"]` is specified, the administrators specified in `admin_claim` are assigned to the super-admin role in the default {{site.base_gateway}} workspace.

  If the mapping does not work as expected, decode the JWT that's created by your IdP, and make sure that the admin ID token includes the key:value pair `groups:["default:super-admin"]` for the case of this example, or the appropriate claim name and claim value as set in your IdP.

* The `admin_auto_create_rbac_token_disabled` boolean enables or disables RBAC token
creation when automatically creating admins with OpenID Connect. The default is
`false`.
  * Set to `true` to disable automatic token creation for admins
  * Set to `false` to enable automatic token creation for admins


### Set up mapping

{% navtabs %}
{% navtab Kubernetes with Helm %}

1. Create a configuration file for the OIDC plugin and save it as
`admin_gui_auth_conf`.

   Provide your own values for all fields indicated by curly braces (`{}`):

    ```json
    {                                      
        "issuer": "{YOUR_IDP_URL}",        
        "admin_claim": "email",
        "client_id": ["{CLIENT_ID}"],                 
        "client_secret": ["{CLIENT_SECRET}"],
        "authenticated_groups_claim": ["{CLAIM_NAME}"],
        "ssl_verify": false,
        "leeway": 60,
        "redirect_uri": ["{YOUR_REDIRECT_URI}"],
        "login_redirect_uri": ["{YOUR_LOGIN_REDIRECT_URI}"],
        "logout_methods": ["GET", "DELETE"],
        "logout_query_arg": "logout",
        "logout_redirect_uri": ["{YOUR_LOGOUT_REDIRECT_URI}"],
        "scopes": ["openid","profile","email","offline_access"],
        "auth_methods": ["authorization_code"],
        "admin_auto_create_rbac_token_disabled": false
    }
    ```

    For detailed descriptions of all OIDC parameters, see the
    [OpenID Connect parameter reference](/hub/kong-inc/openid-connect/#configuration-parameters).

2. Create a secret from the file you just created:

    ```sh
    kubectl create secret generic kong-idp-conf --from-file=admin_gui_auth_conf -n kong
    ```

3. Update the RBAC section of the deployment `values.yml` file with the
following parameters:

    ```yaml
    rbac:
      enabled: true
      admin_gui_auth: openid-connect
      session_conf_secret: kong-session-conf   
      admin_gui_auth_conf_secret: kong-idp-conf
    ```

4. Using Helm, upgrade the deployment with your YAML filename:

    ```sh
    helm upgrade --install kong-ee kong/kong -f ./myvalues.yaml -n kong
    ```
{% endnavtab %}
{% navtab Docker %}

If you have a Docker installation, run the following command to set the needed
environment variables and reload the {{site.base_gateway}} configuration.

   Provide your own values for all fields indicated by curly braces (`{}`):

```sh
$ echo "
  KONG_ENFORCE_RBAC=on \
  KONG_ADMIN_GUI_AUTH=openid-connect \
  KONG_ADMIN_GUI_AUTH_CONF='{
      \"issuer\": \"{YOUR_IDP_URL}\",
      \"admin_claim\": \"email\",
      \"client_id\": [\"<someid>\"],
      \"client_secret\": [\"<somesecret>\"],
      \"authenticated_groups_claim\": [\"{CLAIM_NAME}\"],,
      \"ssl_verify\": false,
      \"leeway\": 60,
      \"redirect_uri\": [\"{YOUR_REDIRECT_URI}\"],
      \"login_redirect_uri\": [\"{YOUR_LOGIN_REDIRECT_URI}\"],
      \"logout_methods\": [\"GET\", \"DELETE\"],
      \"logout_query_arg\": \"logout\",
      \"logout_redirect_uri\": [\"{YOUR_LOGOUT_REDIRECT_URI}\"],
      \"scopes\": [\"openid\",\"profile\",\"email\",\"offline_access\"],
      \"auth_methods\": [\"authorization_code\"],
      \"admin_auto_create_rbac_token_disabled\": false
    }' kong reload exit" | docker exec -i {KONG_CONTAINER_ID} /bin/sh
```

Replace `{KONG_CONTAINER_ID}` with the ID of your container.

For detailed descriptions of all the parameters used here, and many other customization options,
see the [OpenID Connect parameter reference](/hub/kong-inc/openid-connect/#configuration-parameters).

{% endnavtab %}
{% navtab kong.conf %}

1. Navigate to your `kong.conf` file.

2. With RBAC enabled, add the `admin_gui_auth` and `admin_gui_auth_conf`
properties to the file.

   Provide your own values for all fields indicated by curly braces (`{}`):

    ```
    enforce_rbac = on
    admin_gui_auth = openid-connect
    admin_gui_auth_conf = {                                      
        "issuer": "{YOUR_IDP_URL}",        
        "admin_claim": "email",
        "client_id": ["{CLIENT_ID}"],                 
        "client_secret": ["{CLIENT_SECRET}"],
        "authenticated_groups_claim": ["{CLAIM_NAME}"],
        "ssl_verify": false,
        "leeway": 60,
        "redirect_uri": ["{YOUR_REDIRECT_URI}"],
        "login_redirect_uri": ["{YOUR_LOGIN_REDIRECT_URI}"],
        "logout_methods": ["GET", "DELETE"],
        "logout_query_arg": "logout",
        "logout_redirect_uri": ["{YOUR_LOGOUT_REDIRECT_URI}"],
        "scopes": ["openid","profile","email","offline_access"],
        "auth_methods": ["authorization_code"],
        "admin_auto_create_rbac_token_disabled": false
    }
    ```

    For detailed descriptions of all the parameters used here, and many other
    customization options, see the [OpenID Connect parameter reference](/hub/kong-inc/openid-connect/#configuration-parameters).

3. Restart {{site.base_gateway}} to apply the file.

    ```sh
    $ kong restart -c /path/to/kong.conf
    ```

{% endnavtab %}
{% endnavtabs %}
