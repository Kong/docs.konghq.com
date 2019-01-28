---
title: RBAC Overview
book: rbac
chapter: 1
---

## Introduction

Kong Enterprise provides an additional layer of security for the Admin API in
the form of Role-Based Access Control (RBAC). RBAC allows for fine-grained
control over resource access based on a model of User, Roles, and Permissions.
Users are assigned to one or more Roles, while each role, in turn, possesses one
or more permissions granting or denying access to endpoints or entities.
In this way, fine-grained control over specific Admin API endpoints or entities
can be enforced, while scaling to allow sophisticated, case-specific uses.

This document aims to be an introduction to Kong Admin API RBAC and its
concepts. For Admin API documentation, see the [RBAC API Chapter][rbac-api]; for
examples of RBAC operation, see the [RBAC Examples Chapter][rbac-examples].

## Enforcing RBAC

RBAC policies are of little use without enforcement. By default, RBAC policies
are not enforced by Kong, meaning that the Admin API access is available
without requiring any authorization; this allows bootstrapping new Kong clusters
with the appropriate RBAC configuration. Once RBAC has been configured, enforcing
authorization and role access requires only a single configuration change via
the Kong config file.

Previous to Kong Enterprise 0.33, Admin API RBAC was limited to "resources",
which mapped to Admin API endpoints. Starting with Kong Enterprise 0.33, RBAC
also allows Entity-Level permissions. As such, its configuration directive
`enforce_rbac`, previously a boolean, is now an enumeration, whose set of
possible values is:

- `on`: similarly to the previous RBAC implementation, applies Endpoint-level
access control
- `entity`: applies **only** Entity-level access control
- `both`: applies **both Endpoint and Entity level access control**
- `off`: disables RBAC enforcement

```
enforce_rbac = on
```

Restart Kong:

```
kong restart
```

RBAC policies are now enforced by Kong, based on the user token presented
to the request. By default, the user token is sent via the
`Kong-Admin-Token` request header; the name of this header is configurable via
the Kong configuration file. To test our setup, we can send a request
to the Admin API without sending an authentication. Because Kong does not
recognize a user associated with the requesting client, it rejects the
request:

```bash
$ curl -i http://localhost:8001/status
HTTP/1.1 401 Unauthorized
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Type: application/json; charset=utf-8
Date: Sat, 07 Jul 2018 17:59:35 GMT
Server: kong/0.33-enterprise-edition
Transfer-Encoding: chunked
{
    "message": "Invalid RBAC credentials"
}
```

By sending a request with a valid user token, we are granted read access to
the resource in question:

```bash
$ curl -H "Kong-Admin-Token: 12345" -i http://localhost:8001/status
HTTP/1.1 200 OK
Date: Fri, 04 Aug 2017 22:09:25 GMT
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Connection: keep-alive
Access-Control-Allow-Origin: *
Server: kong/0.33-enterprise-edition
```

Attempting to create a new resource which our RBAC user is also
not permitted, as it is not assigned any roles that have permissions with
create access:

```bash
$ curl -H "Kong-Admin-Token: 12345" -i http://localhost:8001/consumers -d name=alice
HTTP/1.1 403 Forbidden
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Type: application/json; charset=utf-8
Date: Sat, 07 Jul 2018 18:03:12 GMT
Server: kong/0.33-enterprise-edition
Transfer-Encoding: chunked
{
    "message": "foo, you do not have permissions to create this resource"
}
```

### User

A user identifies the actor sending the current request. Users are identified
by Kong via the `user_token` element, sent to the Admin API as a request header.
A user is assigned one or more Roles, the permissions of which determine what
resources the user is allowed access. Users can be quickly enabled or disabled via
the `enabled` flag on the User entity in the Admin API; this allows Kong
administrators to quickly enable and disable users without removing their
tokens or metadata.

### Role

Roles tie together users and permissions, effectively assignment permissions to
a user based on the assignment of permissions to the roles. Roles have a
many-to-many relationship with both users, meaning that more than one user may
be assigned to any given role, and a user may be assigned to more than one
role. Likewise, roles also have a many to many relationships with endpoints and
entities permissions; a role may be associated with more than one endpoint
or entity permission. Roles are defined by a human-readable name, such as
"read-only".

#### Role - Endpoints

Roles may have many Endpoint permissions, meaning users in that role will
effectively be allowed (or explicitly disallowed) access to a set of endpoints.
Role-Endpoint relationships carry many attributes, describing how the endpoint
permission apply to the role - e.g., the actions, such as read and write;
whether or not the permission is negative, meaning the actions are negatives,
that is, the role is not allowed to perform the actions described in `actions`,
and the endpoint itself, for instance, `/rbac/users`.

As concrete examples, let's say we want to create a role implementing the
following use cases:

- A permission that allows a Role (or, more precisely, users in that role), to
perform any action, over any workspace, and any endpoint:
  * `endpoint`: `*` - the `*` matches **any** endpoint
  * `actions`: `*` - the `*` matches **any** action
  * `workspace`: `*` - the `*` matches **any** workspace
  * `negative`: `false`

- Now, I want to explicitly **disallow** write access to the `/rbac/users`
endpoint, so that users in the Role cannot create, update, or delete my RBAC
users:
  * `endpoint`: `/rbac/users`
  * `actions`: `create,update,delete`
  * `workspace`: `*`
  * `negative`: `true`

For more examples, along with API calls, check out the
[RBAC Examples Chapter][rbac-examples].

#### Role - Entities

Roles can also associate with particular Kong entities, identified by their
ID field - a UUID, normally autogenerated by Kong at entity creation time.
Similarly to Role-Endpoint permissions, Role-Entity permissions have an
`actions` field. Additionally, Role-Entity permissions have an `entity_id`
field.

For more examples, along with API calls, check out the
[RBAC Examples Chapter][rbac-examples].

## Default Roles and Permissions

For convenience, Kong Enterprise ships with three built-in roles This allows
for quick bootstrapping of RBAC integrations without the need to create many
boilerplate RBAC entities. The default permissions are:

- **read-only** This role has read access to all default Kong endpoints
- **admin** This role has read, create, update, and delete access to all Kong
endpoints, except for the RBAC Admin API
- **super-admin** This role has read, create, update, and delete access to all
Kong endpoints, including the RBAC Admin API

Kong does not provide any users by default, as this would be a
backdoor into Admin API security. As such, it the administrator's responsibility
to configure the appropriate RBAC users and user/role relationships.

Next: [RBAC Admin API &rsaquo;]({{page.book.next}})

---

[rbac-api]: {{page.book.chapters.admin-api}}
[rbac-examples]: {{page.book.chapters.examples}}
