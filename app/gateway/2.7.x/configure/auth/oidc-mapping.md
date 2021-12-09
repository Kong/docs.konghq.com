---
title: OIDC Authenticated Group Mapping
badge: enterprise
---

Using Kong's OpenID Connect plugin (OIDC), you can map identity provider (IdP)
groups to Kong roles. Adding a user to Kong in this way gives them access to
Kong based on their group in the IdP.

Starting with {{site.base_gateway}} version 2.7, you can create Admin accounts for 
Kong Manager when you map your identity provider (IdP) groups to Kong roles. You do 
not need to create the users separately. These users then accept invitations to join 
Kong Manager and log in with their IdP credentials.

If an admin's group changes in the IdP, their Kong admin account's associated
role also changes in {{site.base_gateway}} the next time they log in through Kong
Manager. The mapping removes the task of manually managing access in
{{site.base_gateway}}, as it makes the IdP the system of record.

Here's how OIDC authenticaticated group mapping works:

1. Create roles in {{site.base_gateway}} using either the Kong Admin API or Kong
Manager.
2. Create groups and associate roles with the groups.
3. Configure the OIDC plugin to connect with your IdP.
4. When users log in to Kong Manager, they get permissions based on the IdP
 group(s) they belong to.

## Prerequisites
* An IdP with an authorization server and users with groups assigned
* [{{site.ee_product_name}} installed and configured](/gateway/{{page.kong_version}}/install-and-run)
* Kong Manager enabled
* RBAC enabled
* (Kubernetes) [Helm](https://helm.sh/docs/intro/install/) installed

## Apply OIDC Auth Mapping to Kong Gateway

{% navtabs %}
{% navtab Kubernetes with Helm %}

1. Create a configuration file for the OIDC plugin and save it as
`admin_gui_auth_conf`. 

   Specify the `admin_claim` and `authenticated_groups_claim` parameters 
   to identify which admin value and role name to map from the IdP to {{site.base_gateway}}.

   The `admin_claim` value specifies which IdP username value should map to Kong Manager. 
   Note that the username and password are required for the user to log into the IdP.

   The `authenticated_groups_claim` value specifies which IdP role should be assigned to the
   specified user. This value must be specified in the format provided in the example.

    The configuration should look something like this:

    ```json
    {                                      
        "issuer": "https://accounts.google.com/",        
        "admin_claim": "email",
        "client_id": ["<YOUR_CLIENT_ID>"],                 
        "client_secret": ["<YOUR_CLIENT_SECRET_HERE>"],
        "admin_by": "username",
        "authenticated_groups_claim": ["<WORKSPACE_NAME>:ROLE_NAME>"],
        "ssl_verify": false,
        "leeway": 60,
        "redirect_uri": ["http://localhost:8002"],
        "login_redirect_uri": ["http://localhost:8002"],
        "logout_methods": ["GET", "DELETE"],
        "logout_query_arg": "logout",
        "logout_redirect_uri": ["http://localhost:8002"],
        "scopes": ["openid","profile","email","offline_access"],
        "auth_methods": ["authorization_code"]
    }
    ```

    For detailed descriptions of all OIDC parameters, see the 
    [OpenID Connect parameter reference](/hub/kong-inc/openid-connect/#configuration-parameters).

2. Create a secret from the file you just created:

    ```sh
    $ kubectl create secret generic kong-idp-conf --from-file=admin_gui_auth_conf -n kong
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
    $ helm upgrade --install kong-ee kong/kong -f ./myvalues.yaml -n kong
    ```
{% endnavtab %}
{% navtab Docker %}

If you have a Docker installation, run the following command to set the needed
environment variables and reload the {{site.base_gateway}} configuration.

Substitute all variables in angled brackets (`< >`) with your own values:

```sh
$ echo "
  KONG_ENFORCE_RBAC=on \
  KONG_ADMIN_GUI_AUTH=openid-connect \
  KONG_ADMIN_GUI_AUTH_CONF='{
      \"issuer\": \"<https://my-auth-url>\",
      \"client_id\": [\"<someid>\"],
      \"client_secret\": [\"<somesecret>\"],
      \"consumer_by\": [\"username\",\"custom_id\"],
      \"ssl_verify\": false,
      \"consumer_claim\": [\"sub\"],
      \"leeway\": 60,
      \"redirect_uri\": [\"<http://manager.admin-hostname.com>\"],
      \"login_redirect_uri\": [\"<http://manager.admin-hostname.com>\"],
      \"logout_methods\": [\"GET\", \"DELETE\"],
      \"logout_query_arg\": \"logout\",
      \"logout_redirect_uri\": [\"<http://manager.admin-hostname.com>\"],
      \"scopes\": [\"openid\",\"profile\",\"email\",\"offline_access\"],
      \"authenticated_groups_claim\": [\"groups\"],
      \"auth_methods\": [\"authorization_code\"]
    }' kong reload exit" | docker exec -i <kong-container-id> /bin/sh
```

Replace `<kong-container-id>` with the ID of your container.

{% endnavtab %}
{% navtab kong.conf %}

1. Navigate to your `kong.conf` file.

2. With RBAC enabled, add the `admin_gui_auth` and `admin_gui_auth_conf`
properties to the file:

    ```
    enforce_rbac = on
    admin_gui_auth = openid-connect
    admin_gui_auth_conf = {                                      
        "issuer": "https://accounts.google.com/",        
        "admin_claim": "email",
        "client_id": ["<YOUR_CLIENT_ID>"],                 
        "client_secret": ["<YOUR_CLIENT_SECRET_HERE>"],
        "admin_by": "username",
        "authenticated_groups_claim": ["<WORKSPACE_NAME>:ROLE_NAME>"],
        "ssl_verify": false,
        "leeway": 60,
        "redirect_uri": ["http://localhost:8002"],
        "login_redirect_uri": ["http://localhost:8002"],
        "logout_methods": ["GET", "DELETE"],
        "logout_query_arg": "logout",
        "logout_redirect_uri": ["http://localhost:8002"],
        "scopes": ["openid","profile","email","offline_access"],
        "auth_methods": ["authorization_code"]
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
