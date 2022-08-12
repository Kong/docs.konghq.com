---
title: Mapping LDAP Service Directory Groups to Kong Roles
badge: enterprise
---

Service directory mapping allows organizations to use their LDAP Directory for authentication and authorization in {{site.base_gateway}}.

After starting {{site.base_gateway}} with the desired configuration, you can create new admins whose usernames match those in your LDAP directory. Those users will then be able to accept invitations to join Kong Manager and log in with their LDAP credentials.

How service directory mapping works in Kong:
* Roles are created in {{site.base_gateway}} using the Admin API or Kong Manager.
* Groups are created and roles are associated with the groups.
* When users log in to Kong Manager, they get permissions based on the group(s) they belong to.

For example, if a user's group changes in the service directory, their Kong admin account's associated role also changes in {{site.base_gateway}} the next time they log in to Kong Manager. The mapping removes the task of manually managing access in {{site.base_gateway}}, as it makes the service directory the system of record.

## Prerequisites

* {{site.base_gateway}} installed and configured
* Kong Manager access
* A local LDAP directory

## Configure service directory mapping

Configure service directory mapping to use your LDAP directory for authentication and authorization.

## Start {{site.base_gateway}}

From the shell, enter:

```
$ kong start [-c /path/to/kong/conf]
```

## Enable LDAP Authentication and enforce RBAC

To enable LDAP Authentication and enforce RBAC for Kong Manager, configure Kong with the following properties:

```
admin_gui_auth = ldap-auth-advanced
enforce_rbac = on
```

When enabling LDAP authentication in this step, you are enabling and configuring the LDAP Authentication Advanced plugin for Kong Manager.
No other configuration for the plugin is needed.

## Configure the Sessions plugin

Configure the Sessions plugin for Kong Manager:

```
admin_gui_session_conf = { "secret":"example-secret-string" }
```

The **Sessions plugin** requires a **secret** and is configured securely by default:

* Under all circumstances, the secret must be manually set to a string.
* If using HTTP instead of HTTPS, `cookie_secure` must be manually set to `false`.
* If using different domains for the Admin API and Kong Manager, `cookie_samesite` must be set to `off`. Learn more about these properties in [Session Security in Kong Manager](/gateway/{{page.kong_version}}/configure/auth/kong-manager/sessions), and see [example configurations](/gateway/{{page.kong_version}}/configure/auth/kong-manager/sessions/#example-configurations).

## Configure LDAP Authentication for Kong Manager

Configure LDAP Authentication for Kong Manager with the following properties. Note the attribute variables are defined below:

```
admin_gui_auth_conf = {
 "anonymous":"", \
 "attribute":"<ENTER_YOUR_ATTRIBUTE_HERE>", \
 "bind_dn":"<ENTER_YOUR_BIND_DN_HERE>", \
 "base_dn":"<ENTER_YOUR_BASE_DN_HERE>", \
 "cache_ttl": 2, \
 "header_type":"Basic", \
 "keepalive":60000, \
 "ldap_host":"<ENTER_YOUR_LDAP_HOST_HERE>", \
 "ldap_password":"<ENTER_YOUR_LDAP_PASSWORD_HERE>", \
 "ldap_port":389, \
 "start_tls":false, \
 "timeout":10000, \
 "verify_ldap_host":true, \
 "consumer_by":["username", "custom_id"], \
 "group_base_dn":"<ENTER_YOUR_GROUP_BASE_DN_HERE>",
 "group_name_attribute":"<ENTER_YOUR_GROUP_NAME_ATTRIBUTE_HERE>",
 "group_member_attribute":"<ENTER_YOUR_GROUP_MEMBER_ATTRIBUTE_HERE>",
}
```

* `attribute`:`<ENTER_YOUR_ATTRIBUTE_HERE>`: The attribute used to identify LDAP users
    * For example, to map LDAP users to admins by their username, `attribute":"uid`
* `bind_dn`:`<ENTER_YOUR_BIND_DN_HERE>`: LDAP Bind DN (Distinguished Name)
    * Used to perform LDAP search of user. This `bind_dn` should have permissions to search for the user being authenticated.
    * For example, `uid=einstein,ou=scientists,dc=ldap,dc=com`
* `base_dn`:`<ENTER_YOUR_BASE_DN_HERE>`: LDAP Base DN (Distinguished Name)
    * For example, `ou=scientists,dc=ldap,dc=com`
* `ldap_host`:`<ENTER_YOUR_LDAP_HOST_HERE>`: LDAP host domain.
    * For example, `ec2-XX-XXX-XX-XXX.compute-1.amazonaws.com`
* `ldap_port`: The default LDAP port is 389. 636 is the port required for SSL LDAP and AD.
   If `ldaps` is configured, you must use port 636. For more complex Active Directory (AD) environments,
   instead of Domain Controller and port 389, consider using a Global Catalog host and port, which is port 3268 by default.    
* `ldap_password`:`<ENTER_YOUR_LDAP_PASSWORD_HERE>`: LDAP password
    * *Important*: As with any configuration property, sensitive information may be set as an environment variable instead of being written directly in the configuration file.
* `group_base_dn`:`<ENTER_YOUR_BASE_DN_HERE>`: Sets a distinguished name for the entry where LDAP searches for groups begin. The default is the value from `conf.base_dn`.
* `group_name_attribute`: `<ENTER_YOUR_GROUP_NAME_ATTRIBUTE_HERE>`: Sets the attribute holding the name of a group, typically called `name` (in Active Directory) or `cn` (in OpenLDAP). The default is the value from `conf.attribute`.
* `group_member_attribute`:`<ENTER_YOUR_GROUP_MEMBER_ATTRIBUTE_HERE>`: Sets the attribute holding the members of the LDAP group. The default is `memberOf`.

## Define roles with permissions

Define roles with permissions in {{site.base_gateway}}, using the Admin API's [RBAC endpoints](/gateway/{{page.kong_version}}/admin-api/rbac/reference/#update-or-create-a-role) or using Kong Manager's Teams > [Admins tab](/gateway/{{page.kong_version}}/kong-manager/auth/rbac/add-user/). You must manually define which Kong Roles correspond to each of the service directory's groups using either of the following:

* In Kong Manager's directory mapping section. Find it under **Teams** > **Groups** tab.
* With the Admin API's directory mapping endpoints.

{{site.base_gateway}} will not write to the service directory. For example, a {{site.base_gateway}} admin cannot create users or groups in the directory. You must create users and groups independently before mapping them to {{site.base_gateway}}.

## User-admin mapping

To map a service directory user to a Kong admin, map the admin's username to the **name** value corresponding to the attribute configured in `admin_gui_auth_conf`. Create an admin account in [Kong Manager](/gateway/{{page.kong_version}}/kong-manager/auth/rbac/add-admin) or use the [Admin API](/gateway/{{page.kong_version}}/admin-api/admins/reference/#invite-an-admin).

For instructions on how to pair the bootstrapped super admin with a directory user, see [Set up a directory user as the first super admin](#set-up-a-directory-user-as-the-first-super-admin).

If you already have admins with assigned roles and want to use group mapping instead, it is necessary to first remove all of their roles. The service directory will serve as the system of record for user privileges. Assigned roles will affect a user's privileges in addition to any roles mapped from groups.

## Group-role assignment

Using service directory mapping, groups are mapped to roles. When a user logs in, they are identified with their admin username and authenticated with the matching user credentials in the service directory.
The groups in the service directory are then automatically matched to the associated roles that the organization has defined.

### Example

1. Wayne Enterprises maps the service directory group, `T1-Mgmt`, to the Kong role super-admin.
2. Wayne Enterprises maps a service directory user, named `bruce-wayne`, to a Kong admin account with the same name, `bruce-wayne`.
3. The user, `bruce-wayne`, is assigned to the group `T1-Mgmt` in the LDAP Directory.


When `bruce-wayne` logs in as an admin to Kong Manager, they will automatically have the role of super-admin as a result of the mapping.

If Wayne Enterprises decides to revoke `bruce-wayne`'s privileges by removing their assignment to `T1-Mgmt`, they will no longer have the super-admin role when they attempt to log in.

## Set up a directory user as the first super admin

Setting up a directory user as the first super admin is recommended by Kong.

The example shows an attribute configured with a unique identifier (UID), and the directory user you want to make the super admin has a distinguished name (DN) entry of `UID=bruce-wayne`:

```sh
curl -i -X PATCH https://localhost:8001/admins/kong_admin \
  --header 'Kong-Admin-Token: <RBAC_TOKEN>' \
  --header 'Content-Type: application/json' \
  --data '{"username":"bruce-wayne"}'
```

This user will be able to log in, but until you map a group belonging to `bruce-wayne` to a role, the user will only use the directory for authentication. Once you map the super-admin role to a group that `bruce-wayne` is in, then you can delete the super-admin role from the `bruce-wayne` admin. The group you pick needs to be “super” in your directory, otherwise as other admins log in with a generic group, for example the “employee” group, they will also become super-admins.

{:.important}
> **Important**: If you delete the super-admin role from your only admin, and have not yet mapped the super-admin role to a group that admin belongs to, then you will not be able to log in to Kong Manager.

Alternatives:

* Start Kong with RBAC turned off, map a group to the super-admin role, and then create an admin to correspond to a user belonging to that group. Doing so ensures that the super admin's privileges are entirely tied to the directory group, whereas bootstrapping a super admin only uses the directory for authentication.

* Create all admin accounts for matching directory users and ensure that their existing groups map to appropriate roles before enforcing RBAC.
