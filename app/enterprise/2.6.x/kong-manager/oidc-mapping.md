---
title: OIDC Authenticated Group Mapping
---
## Introduction

Using Kong's OpenID Connect plugin (OIDC), you can map identity provider (IdP)
groups to Kong roles. Adding a user to Kong in this way gives them access to
Kong based on their group in the IdP.

After starting {{site.base_gateway}} with the desired configuration, you can
create new admins whose usernames match those in your IdP. Those
users will then be able to accept invitations to join Kong Manager and log in
with their IdP credentials.

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
* [{{site.ee_product_name}} installed and configured](/enterprise/{{page.kong_version}}/deployment/installation/overview)
* Kong Manager enabled
* RBAC enabled
* (If using Kubernetes) [Helm](https://helm.sh/docs/intro/install/) installed

## Create Kong Groups and Assign Roles

<div class="alert alert-ee blue">
<b>Note:</b> The following examples assume that you have RBAC enabled with
Basic Auth and are transitioning to OpenID Connect.
</div>

{% navtabs %}
{% navtab Kong Manager %}

Create a group and assign a role to it:

1. Open **Teams** from the top navigation.
2. Click the **Groups** tab.
3. Click **Create New Group**.
4. Set the **Group Name** to match your IdP group.

    **Note:** Group names are case-sensitive. Make sure to match your IdP
    group name exactly.

5. (Optional) In the **Comment** field, enter a description for the group.
6. Click on **Add/Edit Roles**, then choose a workspace and a role.
7. Save the role assignment, then click **Create**.

Create an admin for the group:
1. Open the **Teams** from the top navigation.
2. Click the **Admins** tab.
3. Click **Invite Admin**.
4. Enter a username and email, and optionally a custom ID to make the admin
easy for you to identify.

    **Note**: Make sure the username exactly matches the admin's name in
    your IdP.

5. Ensure the **Enable RBAC token** checkbox is checked.
6. Save the role assignment, then click **Invite Admin**.

{% endnavtab %}
{% navtab Kong Admin API %}

1. Create a group, making sure the group `name` parameter matches your IdP group
name:

    ```sh
    $ curl -X POST --url http://<admin-hostname>:8001/groups \
      --header 'content-type: application/json' \
      --header 'kong-admin-token: <yourtoken>' \
      --data '{
          "comment": "example group",      
          "name": "examplegroup"      
        }'
    ```

    **Note:** Group names are case-sensitive. Make sure to match your IdP group
    name exactly.

2. Assign a role to the group:

    ```sh
    $ curl -X POST --url http://<admin-hostname>:8001/groups/{group-id}/roles \
      --header 'content-type: application/json' \
      --header 'kong-admin-token: <yourtoken>' \
      --data '{   
          "rbac_role_id": "e948171e-699c-4035-9b74-2b2b576d9644",
    	    "workspace_id": "236bfa99-cf09-4389-afa8-e2bd6da89fd3"
        }'
    ```

    Where:
    * [`rbac_role_id`](/enterprise/{{page.kong_version}}/admin-api/rbac/reference/#list-roles):
    UUID of the role you want to assign.
    * [`workspace_id`](/enterprise/{{page.kong_version}}/admin-api/workspaces/reference/#list-workspaces):
    UUID of the workspace to add the role to.

3. Create an admin for the group:

    ```sh
    $ curl -X POST --url http://<admin-hostname>:8001/admins \
      --header 'content-type: application/json' \
      --header 'kong-admin-token: <yourtoken>' \
      --data '{
      "username": "<someusername>",
      "custom_id": "<examplename>",
      "email": "<your-email@company.com>",
      "rbac_token_enabled": true
    }'
    ```

{% endnavtab %}
{% endnavtabs %}

Notice how in the instructions above, you did not assign a role to your
admin. The role will be matched with the role assigned to them in the IdP.

## Apply OIDC Auth Mapping to Kong Gateway

{% navtabs %}
{% navtab Kubernetes with Helm %}

1. Create a configuration file for the OIDC plugin and save it as
`admin_gui_auth_conf`. For group mapping, you must include the
`authenticated_groups_claim` parameter as part of this configuration.

    For example, the configuration should look something like this:

    ```json
    {
      "issuer": "<https://my-auth-url>",
      "client_id": ["<someid>"],
      "client_secret": ["<somesecret>"],
      "consumer_by": ["username","custom_id"],
      "ssl_verify": false,
      "consumer_claim": ["sub"],
      "leeway": 60,
      "redirect_uri": ["<http://manager.admin-hostname.com>"],
      "login_redirect_uri": ["<http://manager.admin-hostname.com>"],
      "logout_methods": ["GET", "DELETE"],
      "logout_query_arg": "logout",
      "logout_redirect_uri": ["<http://manager.admin-hostname.com>"],
      "scopes": ["openid","profile","email","offline_access"],
      "authenticated_groups_claim": ["groups"],
      "auth_methods": ["authorization_code"]
    }
    ```

    For detailed descriptions of all the parameters used here, and many other
    customization options, see the [OpenID Connect parameter reference](/hub/kong-inc/openid-connect/#configuration-parameters).

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
        "issuer": "<https://my-auth-url>",
        "client_id": ["<someid>"],
        "client_secret": ["<somesecret>"],
        "consumer_by": ["username","custom_id"],
        "ssl_verify": false,
        "consumer_claim": ["sub"],
        "leeway": 60,
        "redirect_uri": ["<http://manager.admin-hostname.com>"],
        "login_redirect_uri": ["<http://manager.admin-hostname.com>"],
        "logout_methods": ["GET", "DELETE"],
        "logout_query_arg": "logout",
        "logout_redirect_uri": ["<http://manager.admin-hostname.com>"],
        "scopes": ["openid","profile","email","offline_access"],
        "authenticated_groups_claim": ["groups"],
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
