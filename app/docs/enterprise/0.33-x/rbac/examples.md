---
title: Examples
book: rbac
chapter: 3
---

This chapter provides some examples of common RBAC use cases.

### RBAC Configuration

RBAC is turned off by default. The flags that control RBAC behavior
are:

- `RBAC`: defaults to `off`. Possible values:
  - `off`: Disabled, No RBAC authorization will be performed.
  - `endpoint`: Enabled RBAC checks based on endpoints (paths)
  - `entity`: Enabled RBAC checks based on entities.
  - `on`: Enabled RBAC checks based on both endpoints and entities.
- `RBAC_AUTH_HEADER`: Header used for RBAC authorization. Defaults to
    `Kong-RBAC-Token`.

These options can be set via the `kong.conf` configuration file
(`rbac` and `rbac_auth_header`) or via environment variables
(`KONG_RBAC` and `KONG_RBAC_AUTH_HEADER`)

### Users, Roles, and Endpoints

By default, 3 roles are created:

- `read-only`: Read access to all endpoints, across all workspaces.
- `admin`: Full access to all endpoints, across all workspaces - except
  RBAC Admin API.
- `super-admin`: Full access to all endpoints, across all workspaces.

First, let's create 2 users: Alice, which is the super-admin user, and
Bob, which represents a developer.

- `http :8001/rbac/users name=alice user_token=alice`
- `http :8001/rbac/users name=bob user_token=bob`
- `http :8001/rbac/users/alice/roles roles=super-admin`
- `http :8001/rbac/users/bob/roles roles=read-only`

We are going to authorize based only on endpoints,
giving Alice superpowers and bob only read-only rights for the general
case AND full powers for anything inside workspace `ws1`.

- `http :8001/workspaces name=ws1`

- `http :8001/rbac/roles name=ws1-dev`

- `http :8001/rbac/roles/ws1-dev/endpoints endpoint=* workspace=ws1 actions=read,update,create,delete`

- `http :8001/rbac/users/bob/roles roles=ws1-dev`

At this point we'll restart Kong with endpoint RBAC enabled.

- `KONG_RBAC=endpoint kong restart`

Let's try some commands and check why they work/fail.

- `http :8001/` fails with 401 because the request has not been authenticated.

- `http :8001/ Kong-RBAC-Token:bob` Works because bob has `read`
  permissions over all api space.

- `http :8001/services name=s1 host=httpbin.org Kong-RBAC-Token:bob`
Fails because bob does not have write permission to the default workspace.

- `http :8001/ws1/services name=s1 host=httpbin.org Kong-RBAC-Token:bob`
- `http :8001/ws1/services name=s2 host=httpbin.org Kong-RBAC-Token:bob`
Succeeds because bob does have write permission to the ws1 workspace.


#### Wildcards

`endpoints` can contain asterisks (`*`) , Where `*` replaces exactly
one segment between slashes (or the end of the path).

This is how to give read permissions to plugins for all apis
- `http :8001/rbac/roles/ws1-dev/endpoints endpoint=/apis/*/plugins workspace=ws1 actions=read`

### Entities

A more advanced and fine grained RBAC consists in authorizations per
entity. Let's continue on the same example.

#### Access a single entity
First of all, let's restart kong disabling all RBAC.

- `kong restart`

Now all endpoints and entities are accessible again.

*Assuming service s1 id is 11111111-1111-1111-1111-111111111111*

- `http :8001/rbac/roles/developer/entities entity_id=11111111-1111-1111-1111-111111111111 actions=read,update,delete`

- `KONG_RBAC=entity kong restart`

Now every user in the developer role will be able to acces the entity_id=11111111-1111-1111-1111-111111111111

- `http :8001/ws1/services Kong-RBAC-Token:bob`

The only result returned is s1 in the listing.

#### Access all but one entity in a workspace

Another common scenario is having access to everything except for one
entity.

In that case, we'll give read permissions to all entities inside a
workspace, and then explicitly cut the permission for a single entity.

- `http :8001/rbac/roles/developer/entities entity_id=<workspace_id> actions=read`

Gives read rights to all entities that belong to workspace `workspace_id`.

- `http :8001/rbac/roles/developer/entities entity_id=<entity_id> negate=true actions=read`

Explicitly cut off permission to entity `entity_id`.
