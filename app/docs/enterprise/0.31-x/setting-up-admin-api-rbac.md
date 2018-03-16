---
title: Setting Up Admin API RBAC
---
# Setting Up Admin API RBAC
## Overview
Kong Enterprise provides an additional layer of security for the Admin API in the form of role-based access control (RBAC). RBAC allows for fine-grained control over resource access based on a model of user roles and permissions. Users are assigned to one or more roles, which each in turn possess one or more permissions granting or denying access to a particular resource. In this way, fine-grained control over specific Admin API resources can be enforced, while scaling to allow complex, case-specific uses.

## Terms and Concepts

This document makes use of several key terms, related to RBAC concepts and implementation whose definitions fall below.

### Resource

A resource defines a logical grouping of one or more Admin API endpoints. These are human-readable terms, such as "apis" or "plugins", and form the basis for which endpoints in the Admin API a given user will have access to. Third-party plugin developers have the option to register their own RBAC resources as part of their plugin's Admin API extension (details on this noted below). The Admin API following endpoint provides a full list of RBAC resources available for the current running configuration:

<div class="endpoint get">/rbac/resources</div>

```json
[
 "kong", 
 "snis", 
 "acls", 
 "cache", 
 "consumers", 
 "certificates", 
 "upstreams", 
 "hmac-auth", 
 "rbac", 
 "status", 
 "apis", 
 "key-auth", 
 "plugins", 
 "basic-auth", 
 "oauth2", 
 "targets", 
 "jwt"
] 
```

#### User

A user identifies the actor sending the current request. Users are identified by Kong via the user_token element, sent to the Admin API as a request header. A user is assigned one or more roles, the permissions of which determine what resources the user has access to. Users can be quickly enabled or disabled via the "enabled" flag on the User object in the Admin API. This allows Kong administrators to quickly enable and disable users without removing their tokens or metadata.

#### Role

Roles tie together users and permissions, effectively assignment permissions to a user based on the assignment of permissions to the roles. Roles have a many-to-many relationship with both users, meaning that more than one user may be assigned to any given role, and a user may be assigned to more than one role. Likewise, roles also have a many to many relationship with permissions; a role may be associated with more than one permission, and a permission may have many roles associated with it. Roles are defined by a human-readable name, such as "read-only".

#### Permissions

The final piece of the puzzle, permissions determine what portions of the Admin API (resources) a role, and therefore a user, has access to. Permissions contain two elements: resources (the same resources defined above), and actions (one or more of "read", "create", "update", or "delete"). A permission may contain one or more actions, and one or more resources, allowing for granular control of resources. For example, a permission may assign only the "read" action to one, several, or all resources, or it could allow all actions to only a single resource (or any permutation thereof). Permissions may also be "negative", in which case the associated roles are explicitly disallowed from accessing the assigned permissions. This can be used to override resource access granted from another role/permission. An example of this is noted below in the discussion of default roles and permissions.

## Default Roles and Permissions

For convenience, Kong Enterprise is shipped with several roles and permissions built-in. This allows for quick bootstrapping of RBAC integrations without the need to create many boilerplate RBAC entities. The default permissions are:

- **read-only.** This permission has read access to all default Kong resources (that is, resources not exposed by a third-party plugin).
- **full-access.** This permission has read, create, update, and delete access to all default Kong resources.
- **no-rbac.** This is a negative permission with read, create, update, and delete actions, and the rbac resource. Assigning this permission to a role will explicitly disallow access to rbac resources, even if the role (or another role assigned to the user in question) has a role enabling rbac resource access.

Kong also provides several out-of-the-box roles that leverage these permissions:

- **read-only.** This role is assigned the read-only permission, and as such as read access to all default Kong resources.
- **admin.** This role is assigned the full-access and no-rbac role, meaning that it has read, create, update, and delete access to all default Kong resources, except for the rbac resource.
- **super-admin.** This role is assigned the full-access role. It has complete access to every default Kong resource.

Kong does not provide any users by default, as this would essentially be a backdoor into Admin API security. As such, it the administrator's responsibility to configure the appropriate RBAC users and user/role relationships.

## Adding A User

In order to authenticate with Kong's RBAC implementation, we must first create a user (and their associated token). Note that if the user_token param is not provided, Kong will automatically create the token on your behalf. Each token must be unique:

```
curl -X POST http://localhost:8001/rbac/users/ -d name=bob -d user_token=12345
```

## Assigning Roles to the User

Once the user has been created, we can assign them to a role. We can use the default roles to quickly enforce a basic security policy for our user.

```
curl -X POST http://localhost:8001/rbac/users/bob/roles -d roles=read-only
```

Our user has now been assigned the read-only role, giving them read access to all Kong RBAC resources.

## Enforcing RBAC

RBAC policies are of little use without enforcement. By default, RBAC policies are not enforced by Kong, meaning that the Admin API access is available without requiring any authorization. This allows new Kong clusters to be bootstrapped with the appropriate RBAC configuration. Once the appropriate RBAC relationships have been defined, enforcing authorization and role access requires only a single configuration change via the Kong config file:

```
enforce_rbac = on
```

Once this is done, simply restart Kong

```
kong restart
```

RBAC policies will now be enforced by Kong, based on the user token presented to the request. By default, this user token should be presented via the Kong-Admin-Token request header; the name of this header is configurable via the Kong configuration file. In order to test our setup, we can send a request to the Admin API without sending an authentication. Because Kong does not recognize a user associated with the requesting client, it will reject the request:

```
$ curl -i http://localhost:8001/status
HTTP/1.1 401 Unauthorized
Date: Fri, 04 Aug 2017 22:06:00 GMT
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Connection: keep-alive
Access-Control-Allow-Origin: *
Server: kong/0.11.0

{"message":"Unauthorized"}
```

By sending a request with our user's token, we will be granted read access to the resource in question.

```
$ curl -H "Kong-Admin-Token: 12345" -i http://localhost:8001/status
HTTP/1.1 200 OK
Date: Fri, 04 Aug 2017 22:09:25 GMT
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Connection: keep-alive
Access-Control-Allow-Origin: *
Server: kong/0.11.0
```

We can also see that attempting to create a new resource with our RBAC user is not permitted, as they are not assigned any roles that have permissions with create access:

```
$ curl -H "Kong-Admin-Token: 12345" -i http://localhost:8001/consumers -d name=alic
HTTP/1.1 401 Unauthorized
Date: Fri, 04 Aug 2017 22:15:47 GMT
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Connection: keep-alive
Access-Control-Allow-Origin: *
Server: kong/0.11.0rc2

{"message":"Unauthorized"}
```

## Extending RBAC

The default RBAC roles and permissions shipped with Kong are a great starting point for shaping a basic enforcement policy, but they may not fit all use cases. [The Admin API](/docs/enterprise/0.31-x/plugins/rbac-api) provides a comprehensive set of endpoints to create, edit, and delete RBAC users, roles, and permissions.

Additionally, third-party plugin developers can register their own Admin API RBAC resources as part of the [Admin API extension](/docs/latest/plugin-development/admin-api). This is done by defining a "resource" value associated with each API endpoint, like so:

```
return {
  ["/mock/api/endpoint/"] = {
    resource = "mock",

    GET = function(self, dao_factory)
      crud.paginated_set(self, dao_factory.mock)
    end,
}
```

Additionally, a custom migration is needed to register this resource with Kong. This would look something like the following:

```
{
   name = "2017-07-23-100000_rbac_mock_resources",
   up = function(_, _, dao)
     local rbac = require "kong.core.rbac"
    
     local resource, err = rbac.register_resource("mock", dao)
     if not resource then
       return err 
     end 
  end,
}
```

## RBAC and the GUI

There are no specific rules in RBAC for limiting access to the GUI. If RBAC is enabled, when people go to the GUI <Kong>:8002, they will be presented with a login screen:

<img src="/assets/images/docs/ee/rbac_gui.png" alt="RBAC & the GUI" />

After using your RBAC credentials to log in, you will only be able to see what the super-admin has given you access to see. You will be able to see only the resources you have read access to and will only be able to make changes to the resources you have write access to.
