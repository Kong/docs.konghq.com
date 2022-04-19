---
title: Mapping LDAP Service Directory Groups to Kong Roles
badge: enterprise
---

Service Directory Mapping allows organizations to use their LDAP Directory for authentication and authorization in {{site.base_gateway}}.

After starting {{site.base_gateway}} with the desired configuration, you can create new Admins whose usernames match those in your LDAP directory. Those users will then be able to accept invitations to join Kong Manager and log in with their LDAP credentials.

How Service Directory Mapping works in Kong:
* Roles are created in {{site.base_gateway}} using the Admin API or Kong Manager.
* Groups are created and roles are associated with the groups.
* When users log in to Kong Manager, they get permissions based on the group(s) they belong to.

For example, if a User's Group changes in the Service Directory, their Kong Admin account's associated Role also changes in {{site.base_gateway}} the next time they log in to Kong Manager. The mapping removes the task of manually managing access in {{site.base_gateway}}, as it makes the Service Directory the system of record.

## Prerequisites

* {{site.base_gateway}} installed and configured
* Kong Manager access
* A local LDAP directory

## Configure Service Directory Mapping

Configure Service Directory Mapping to use your LDAP Directory for authentication and authorization.

## Start {{site.base_gateway}}

From a terminal window, enter:

```
$ kong start [-c /path/to/kong/conf]
```

## Enable LDAP Authentication and enforce RBAC

To enable LDAP Authentication and enforce RBAC for Kong Manager, configure Kong with the following properties:

```
admin_gui_auth = ldap-auth-advanced
enforce_rbac = on
```

**Note**: When enabling LDAP Authentication in this step, you are enabling and configuring the LDAP Authentication Advanced Plugin for Kong Manager. No other configuration for the plugin is needed.

## Configure the Sessions plugin

Configure the Sessions Plugin for Kong Manager:

```
admin_gui_session_conf = { "secret":"set-your-string-here" }
```

>Note: The **Sessions Plugin** requires a **secret** and is configured securely by default:

* Under all circumstances, the secret must be manually set to a string.
*  If using HTTP instead of HTTPS, cookie_secure must be manually set to false.
*  If using different domains for the Admin API and Kong Manager, cookie_samesite must be set to off. Learn more about these properties in [_Session Security in Kong Manager_](/gateway/{{page.kong_version}}/configure/auth/kong-manager/sessions), and see [_example configurations_](/gateway/{{page.kong_version}}/configure/auth/kong-manager/sessions/#example-configurations).

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
    * Used to perform LDAP search of user. This bind_dn should have permissions to search for the user being authenticated.
    * For example, `uid=einstein,ou=scientists,dc=ldap,dc=com`
* `base_dn`:`<ENTER_YOUR_BASE_DN_HERE>`: LDAP Base DN (Distinguished Name)
    * For example, `ou=scientists,dc=ldap,dc=com`
* `ldap_host`:`<ENTER_YOUR_LDAP_HOST_HERE>`: LDAP host domain.
    * For example, `ec2-XX-XXX-XX-XXX.compute-1.amazonaws.com`
* `ldap_port`: The default LDAP port is 389. 636 is the port required for SSL LDAP and AD.
   If ldaps is configured, you must use port 636. For more complex Active Directory (AD) environments,
   instead of Domain Controller and port 389, consider using a Global Catalog host and port, which is port 3268 by default.    
* `ldap_password`:`<ENTER_YOUR_LDAP_PASSWORD_HERE>`: LDAP password
    * *Important*: As with any configuration property, sensitive information may be set as an environment variable instead of being written directly in the configuration file.
* `group_base_dn`:`<ENTER_YOUR_BASE_DN_HERE>`: Sets a distinguished name for the entry where LDAP searches for groups begin. The default is the value from `conf.base_dn`.
* `group_name_attribute`: `<ENTER_YOUR_GROUP_NAME_ATTRIBUTE_HERE>`: Sets the attribute holding the name of a group, typically called `name` (in Active Directory) or `cn` (in OpenLDAP). The default is the value from `conf.attribute`.
* `group_member_attribute`:`<ENTER_YOUR_GROUP_MEMBER_ATTRIBUTE_HERE>`: Sets the attribute holding the members of the LDAP group. The default is `memberOf`.

## Define Roles with Permissions

Define Roles with Permissions in {{site.base_gateway}}, using the Admin API's [_RBAC endpoints_](/gateway/{{page.kong_version}}/admin-api/rbac/reference/#update-or-create-a-role) or using Kong Manager's Teams > [Admins tab](/gateway/{{page.kong_version}}/configure/auth/rbac/add-user/). You must manually define which Kong Roles correspond to each of the Service Directory's Groups using either of the following:

In Kong Manager's Directory Mapping section. Go to Teams > Groups tab.
With the Admin API's Directory Mapping endpoints.

{{site.base_gateway}} will not write to the Service Directory, for example, a {{site.base_gateway}} Admin cannot create Users or Groups in the directory. You must create Users and Groups independently before mapping them to {{site.base_gateway}}.

## User-Admin Mapping

To map a Service Directory User to a Kong Admin, you must configure the Admin's username as the value of the User's name from their LDAP Distinguished Name (DN) corresponding the attribute configured in admin_gui_auth_conf. Creating an Admin account in [_Kong Manager_](/gateway/{{page.kong_version}}/configure/auth/rbac/add-admin) or using the [_Admin API_](/gateway/{{page.kong_version}}/admin-api/admins/reference/#invite-an-admin).

For instructions on how to pair the bootstrapped Super Admin with a Directory User, see [_How to Set Up a Service Directory User as the First Super Admin_](/gateway/{{page.kong_version}}/configure/auth/service-directory-mapping/#set-up-a-directory-user-as-the-first-super-admin).

If you already have Admins with assigned Roles and want to use Group mapping instead, it is necessary to first remove all of their Roles. The Service Directory will serve as the system of record for User privileges. Assigned Roles will affect a user's privileges in addition to any roles mapped from Groups.

## Group-Role Assignment

Using Service Directory Mapping, Groups to Roles are mapped. When a user logs in, they are identified with their Admin username and then authenticated with the matching User credentials in the Service Directory. The Groups in the Service Directory are then automatically matched to the associated Roles that the organization has defined.

### Example

1. Wayne Enterprises maps the Service Directory Group, T1-Mgmt, to the Kong Role super-admin.
2. Wayne Enterprises maps a Service Directory User, named bruce-wayne, to a Kong Admin account with the same name, bruce-wayne.
3. The User, bruce-wayne, is assigned to the Group T1-Mgmt in the LDAP Directory.


When bruce-wayne logs in as an Admin to Kong Manager, they will automatically have the Role of super-admin as a result of the mapping.

If Wayne Enterprises decides to revoke bruce-wayne's privileges by removing their assignment to T1-Mgmt, they will no longer have the super-admin Role when they attempt to log in.

## Set Up a Directory User as the First Super Admin

**Important**: Setting up a Directory User as the first Super Admin is recommended by Kong.


The following is an example of setting up a Directory User as the first Super Admin.
The example shows an attribute is configured with a unique identifier (UID), and the Directory User you want to make the Super Admin has a distinguished name (DN) entry of UID=bruce-wayne:

```
HTTPie
$ http PATCH :8001/admins/kong_admin username="bruce-wayne"
Kong-Admin-Token:<RBAC_TOKEN>
cURL
$ curl --request 'PATCH' --header 'Kong-Admin-Token: <RBAC_TOKEN>' --header
'Content-Type: application/json' --data '{"username":"bruce-wayne"}'
'localhost:8001/admins/kong_admin'
```

This User will be able to log in, but until you map a Group belonging to bruce-wayne to a Role, the User will only use the Directory for authentication. Once you map the super-admin Role to a Group that bruce-wayne is in, then you can delete the super-admin Role from the bruce-wayne Admin. Note the group you pick needs to be “super” in your directory, otherwise as other admins log in with a generic group, for example the “employee” group, they will also become super-admins.

**Important**: If you delete the super-admin Role from your only Admin, and have not yet mapped the super-admin Role to a Group that Admin belongs to, then you will not be able to log in to Kong Manager.

Alternatives:

* Start Kong with RBAC turned off, map a Group to the super-admin Role, and then create an Admin to correspond to a User belonging to that Group. Doing so ensures that the Super Admin's privileges are entirely tied to the Directory Group, whereas bootstrapping a Super Admin only uses the Directory for authentication.

Create all Admin accounts for matching Directory Users and ensure that their existing Groups map to appropriate Roles before enforcing RBAC.
