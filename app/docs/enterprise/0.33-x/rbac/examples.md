---
title: Examples
book: rbac
chapter: 3
---

The following are some examples of common use cases for RBAC.

### Why do I need it. Common use cases


### Turn on/off RBAC

RBAC is turned off by default. The flags that control RBAC behavior
are:

- `RBAC`: defaults to `off`. Possible values:
  - `off`: Disabled, No RBAC authorization will be performed.
  - `endpoint`: Enabled RBAC checks based on endpoints (paths)
  - `entity`: Enabled RBAC checks based on entities.
  - `on`: Enabled RBAC checks based on both endpoints and entities.
- `RBAC-Token`: Header used for RBAC authorization. Defaults to
  `Kong-RBAC-Token`.

These options can be set via the `kong.conf` file or via environment
variables (`KONG_RBAC` and `KONG_RBAC-Token`)

### Users, Roles, Endpoints and Entities

By default, 4 roles are created:

- read-only: Read access to all endpoints, across all workspaces.
- admin: Full access to all endpoints, across all workspaces - except
  RBAC Admin API.
- super-admin: Full access to all endpoints, across all workspaces.

### Users

First let's create 2 users, Alice which is the super-admin user, and
Bob which represents a developer.

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

- `http :8001/ws1/services name=hola host=httpbin.org Kong-RBAC-Token:bob`
Succeeds because bob does have write permission to the ws1 workspace.

<!-- Let's say that a new manager is hired and she'll have the role of -->
<!-- supervising and testing all development. We'll give her rights to -->
<!-- everything except modifying or deleting our production service. -->

<!-- At this point we have a basic structure and as we have Alice that has -->
<!-- superadmin powers we can restart Kong and keep configuring it through -->
<!-- Alice user. -->
