---
title: RBAC Examples
book: rbac
---

## Introduction

This chapter aims to provide a step-by-step tutorial on how to set up
RBAC and see it in action, with an end-to-end use case. The chosen
use case demonstrates how **RBAC with workspaces** can be coupled
to achieve a flexible organization of teams and users in complex
hierarchies. Make sure to read the [RBAC Overview][rbac-overview] page
and to glance over the [RBAC Admin API][rbac-admin] chapter, keeping it
open as a reference.

## Use Case

For the sake of example, let's say a given company has a Kong Enterprise
cluster to be shared with 3 teams: teamA, teamB, and teamC. While the Kong
cluster are shared among these teams, they want to be able to segment
their entities in such a way that management of entities in one team doesn't
disrupt operation in some other team. As shown in the
[Workspaces Examples Page][workspaces-examples], such a use case is possible
with workspaces. On top of workspaces, though, each team wants to enforce
access control over their Workspace, which is possible with RBAC. **To sum up,
Workspaces and RBAC are complementary: Workspaces provide segmentation of
Admin API entities, while RBAC provides access control**.

## Bootstrapping the first RBAC user—the Super Admin

**Note:** It is possible to create the first Super Admin at the time
of migration as described in the [Getting Started Guide][getting-started-guide].
If you chose this option, skip to [Enforcing RBAC](#enforcing-rbac).

Before anything, we will assume the Kong Admin—or, more interestingly,
the KongOps Engineer—in charge of operating Kong, will create a Super Admin
user, before actually enforcing RBAC and restarting Kong with RBAC enabled.

As Kong ships with a handy set of default RBAC Roles—the `super-admin`,
the `admin`, and `read-only`—the task of creating a Super Admin user is
quite easy:

Create the RBAC user, named `super-admin`:

```
http :8001/rbac/users name=super-admin
{
  "user_token": "M8J5A88xKXa7FNKsMbgLMjkm6zI2anOY",
  "id": "da80838d-49f8-40f6-b673-6fff3e2c305b",
  "enabled": true,
  "created_at": 1531009435000,
  "name": "super-admin"
}
```

As the `super-admin` user name coincides with an existing `super-admin`
role, it gets automatically added to the `super-admin` role—which can be
confirmed with the following command:

```
http :8001/rbac/users/super-admin/roles
{
  "roles": [
    {
      "comment": "Full access to all endpoints, across all workspaces",
      "created_at": 1531009724000,
      "name": "super-admin",
      "id": "b924ac91-e83f-4136-a5a4-4a7ff92594a8"
    }
  ],
  "user": {
    "created_at": 1531009858000,
    "id": "e6897cc0-0c34-4a9c-9f0b-cc65b4f04d68",
    "name": "super-admin",
    "enabled": true,
    "user_token": "vajeOlkybsn0q0VD9qw9B3nHYOErgY7b8"
  }
}

```

## Enforcing RBAC

As the `super-admin` user has just been created, the Kong Admin may now
restart Kong with RBAC enforced, with, e.g.:

```
KONG_ENFORCE_RBAC=on kong restart
```

**NOTE**: This is one of the possible ways of enforcing RBAC and restarting
Kong; another possibility is editing the Kong configuration file and
restarting.

Before we move on, note that we will be using the Super Admin user, but we
could, in fact, be moving without RBAC enabled, and having our Kong Admin do
all the job of setting up the RBAC hierarchy. We want, however, to stress the
fact that RBAC is powerful enough to allow a flexible separation of tasks. To
summarize:

- **Kong Admin**: this user has physical access to Kong infrastructure; her
task is to bootstrap the Kong cluster as well as its configuration, including
initial RBAC users;
- **RBAC Super Admin**: created by the Kong Admin, has the role of managing
RBAC users, roles, etc; this could all be done by the **Kong Admin**, but let's
give him a break.

## Super Admin creates the teams Workspaces

The Super Admin will now set up our 3 teams: teamA, teamB, and teamC, creating
one workspace for each, one admin for each. Enough talking.

Creating workspaces for each team—this overlaps a bit with
[Workspaces Examples][workspaces-examples], yes, but it will make our
exploration of RBAC + Workspaces easier:

**Team A**:

```
http :8001/workspaces name=teamA Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8
{
  "name": "teamA",
  "created_at": 1531014100000,
  "id": "1412f3a6-4d9b-4b9d-964e-60d8d63a9d46"
}

```

**Team B**:

```
http :8001/workspaces name=teamB Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8
{
  "name": "teamB",
  "created_at": 1531014143000,
  "id": "7dee8c56-c6db-4125-b87a-b508baa33c66"
}
```

**Team C**:

```
http :8001/workspaces name=teamC Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8
{
  "name": "teamC",
  "created_at": 1531014171000,
  "id": "542c8662-17cc-49eb-af50-6eb14f3b2e8a"
}
```

**NOTE**: this is the RBAC Super Admin creating workspaces—note his
token being passed in through the `Kong-Admin-Token` HTTP header.

## Super Admin Creates one Admin for each Team

**Team A**:

```
http :8001/teamA/rbac/users name=adminA Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8
{
  "user_token": "qv1VLIpl8kHj7lC1QOKwRdCMXanqEDii",
  "id": "4d315ff9-8c1a-4844-9ea2-21b16204a154",
  "enabled": true,
  "created_at": 1531015165000,
  "name": "adminA"
}
```

**Team B**:

```
http :8001/teamB/rbac/users name=adminB Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8
{
  "user_token": "IX5vHVgYqM40tLcctdmzRtHyfxB4ToYv",
  "id": "49641fc0-8c9d-4507-bc7a-2acac8f2903a",
  "enabled": true,
  "created_at": 1531015221000,
  "name": "adminB"
}
```

**Team C**:

```
http :8001/teamC/rbac/users name=adminC Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8
{
  "user_token": "w2f7tsuUW4BerXocZIMRQHE84nK2ZAo7",
  "id": "74643f69-8852-49f9-b363-21971bac4f52",
  "enabled": true,
  "created_at": 1531015304000,
  "name": "teamC"
}
```

With this, all of the teams have one admin and each admin can only be seen
in his corresponding workspace. To verify:

```
http :8001/teamA/rbac/users Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8
{
  "total": 1,
  "data": [
    {
      "created_at": 1531014784000,
      "id": "1faaacd1-709f-4762-8c3e-79f268ec8faf",
      "name": "adminA",
      "enabled": true,
      "user_token": "n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG"
    }
  ]
}
```

Similarly, workspaces teamB and teamC only show their respective admins:

```
http :8001/teamB/rbac/users Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8
{
  "total": 1,
  "data": [
    {
      "created_at": 1531014805000,
      "id": "3a829408-c1ee-4764-8222-2d280a5de441",
      "name": "adminB",
      "enabled": true,
      "user_token": "C8b6kTTN10JFyU63ORjmCQwVbvK4maeq"
    }
  ]
}
```

```
http :8001/teamC/rbac/users Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8
{
  "total": 1,
  "data": [
    {
      "created_at": 1531014813000,
      "id": "84d43cdb-5274-4b74-ad22-615e50f005e3",
      "name": "adminC",
      "enabled": true,
      "user_token": "zN5Nj8U1MiGR7vVQKvl8odaGBDI6mjgY"
    }
  ]
}
```

## Super Admin Creates Admin Roles for Teams

Super Admin is now done creating RBAC Admin users for each team; his next
task is to create admin roles that will effectively grant permissions to admin
users.

The admin role must have access to all of the Admin API, restricted to his
workspace.

Setting up the Admin role—pay close attention to the request parameters:

```
http :8001/teamA/rbac/roles/ name=admin Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8
{
  "created_at": 1531016728000,
  "id": "d40e61ab-8dad-4ef2-a48b-d11379f7b8d1",
  "name": "admin"
}
```

Creating role endpoint permissions:

```
http :8001/teamA/rbac/roles/admin/endpoints/ endpoint=* workspace=teamA actions=* Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8
{
  "total": 1,
  "data": [
    {
      "endpoint": "*",
      "created_at": 1531017322000,
      "role_id": "d40e61ab-8dad-4ef2-a48b-d11379f7b8d1",
      "actions": [
        "delete",
        "create",
        "update",
        "read"
      ],
      "negative": false,
      "workspace": "teamA"
    }
  ]
}
```

Next logical step is to add the adminA user—admin of Team A—to the Admin
role in his workspace:

```
http :8001/teamA/rbac/users/adminA/roles/ roles=admin Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8
{
  "roles": [
    {
      "comment": "Default user role generated for adminA",
      "created_at": 1531014784000,
      "id": "e2941b41-92a4-4f49-be89-f1a452bdecd0",
      "name": "adminA"
    },
    {
      "created_at": 1531016728000,
      "id": "d40e61ab-8dad-4ef2-a48b-d11379f7b8d1",
      "name": "admin"
    }
  ],
  "user": {
    "created_at": 1531014784000,
    "id": "1faaacd1-709f-4762-8c3e-79f268ec8faf",
    "name": "adminA",
    "enabled": true,
    "user_token": "n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG"
  }
}
```

Note the admin role in the list above.

With these steps, Team A's admin user is now able to manage his team. To
validate that, let's try to list RBAC users in Team B using Team A's admin
user token—and see that we are not allowed to do so:

```
http :8001/teamB/rbac/users Kong-Admin-Token:n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG
{
  "message": "Invalid RBAC credentials"
}
```

Said admin is, however, allowed to list RBAC users in Team A's workspace:

```
http :8001/teamA/rbac/users Kong-Admin-Token:n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG
{
  "total": 1,
  "data": [
    {
      "created_at": 1531014784000,
      "id": "1faaacd1-709f-4762-8c3e-79f268ec8faf",
      "name": "adminA",
      "enabled": true,
      "user_token": "n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG"
    }
  ]
}
```

If the same procedure is repeated for Team B and Team C, they will end up with
a similar set up, with an admin role and an admin user, both restricted to the
team's workspace.

And so Super Admin ends his participation; individual team admins are now able
to set up his teams users and entities!

## Team Admins Create Team Regular Users

From this point on, team admins are able to drive the process; the next logical
step is for Team users to be created; such team users could be, for example,
engineers that are part of Team A (or B or C). Let's go ahead and do that,
using Admin A's user token.

Before regular users can be created, a role needs to be available for them.
Such a role needs to have permissions to all of Admin API endpoints, except
RBAC and Workspaces—regular users will not need access to these in general
and, if they do, the Admin can grant them.

**Creating the regular users role**:

```
http :8001/teamA/rbac/roles/ name=users Kong-Admin-Token:n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG
{
  "created_at": 1531020346000,
  "id": "9846b92c-6820-4741-ac31-425b3d6abc5b",
  "name": "users"
}
```

**Creating permissions in the regular users role**:

First, permission to all of Admin API—positive permission on \*:

```
http :8001/teamA/rbac/roles/users/endpoints/ endpoint=* workspace=teamA actions=* Kong-Admin-Token:n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG
{
  "endpoint": "*",
  "created_at": 1531020573000,
  "role_id": "9846b92c-6820-4741-ac31-425b3d6abc5b",
  "actions": [
    "delete",
    "create",
    "update",
    "read"
  ],
  "negative": false,
  "workspace": "teamA"
}
```

Then, filter out RBAC and workspaces with negative permissions:

```
http :8001/teamA/rbac/roles/users/endpoints/ endpoint=/rbac/* workspace=teamA actions=* Kong-Admin-Token:n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG
{
  "endpoint": "/rbac/*",
  "created_at": 1531020744000,
  "role_id": "9846b92c-6820-4741-ac31-425b3d6abc5b",
  "actions": [
    "delete",
    "create",
    "update",
    "read"
  ],
  "negative": true,
  "workspace": "teamA"
}
```

```
http :8001/teamA/rbac/roles/users/endpoints/ endpoint=/workspaces/* workspace=teamA actions=* Kong-Admin-Token:n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG
{
  "endpoint": "/workspaces/*",
  "created_at": 1531020778000,
  "role_id": "9846b92c-6820-4741-ac31-425b3d6abc5b",
  "actions": [
    "delete",
    "create",
    "update",
    "read"
  ],
  "negative": true,
  "workspace": "teamA"
}
```

**IMPORTANT**: as explained in the [Wildcards in Permissions](#wildcards-in-permissions)
section, the meaning of `*` is not the expected generic globbing one might
be used to. As such, `/rbac/*` or `/workspaces/*` do not match all of the
RBAC and Workspaces endpoints. For example, to cover all of the RBAC API,
one would have to define permissions for the following endpoints:

- `/rbac/*`
- `/rbac/*/*`
- `/rbac/*/*/*`
- `/rbac/*/*/*/*`
- `/rbac/*/*/*/*/*`

Team A just got 3 new members: foogineer, bargineer, and bazgineer. Admin A
will welcome them to the team by creating RBAC users for them and giving them
access to Kong!

Create foogineer:

```
http :8001/teamA/rbac/users name=foogineer Kong-Admin-Token:n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG
{
  "created_at": 1531019797000,
  "id": "0b4111da-2827-4767-8651-a327f7a559e9",
  "name": "foogineer",
  "enabled": true,
  "user_token": "dNeYvYAwvjOJdoReVJZXF8vLBXQioKkI"
}
```

Add foogineer to the `users` role:

```
http :8001/teamA/rbac/users/foogineer/roles roles=users Kong-Admin-Token:n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG
{
  "roles": [
    {
      "comment": "Default user role generated for foogineer",
      "created_at": 1531019797000,
      "id": "125c4212-b882-432d-a323-9cbe38b1d0df",
      "name": "foogineer"
    },
    {
      "created_at": 1531020346000,
      "id": "9846b92c-6820-4741-ac31-425b3d6abc5b",
      "name": "users"
    }
  ],
  "user": {
    "created_at": 1531019797000,
    "id": "0b4111da-2827-4767-8651-a327f7a559e9",
    "name": "foogineer",
    "enabled": true,
    "user_token": "dNeYvYAwvjOJdoReVJZXF8vLBXQioKkI"
  }
}
```

Create bargineer:

```
http :8001/teamA/rbac/users name=bargineer Kong-Admin-Token:n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG
{
  "created_at": 1531019837000,
  "id": "25dfa68e-32e8-48d8-815f-6fedfd2fb4a6",
  "name": "bargineer",
  "enabled": true,
  "user_token": "eZj3WUc46wO3zEJbLP3Y4VGvNaUgGlyv"
}
```

Add bargineer to the `users` role:

```
http :8001/teamA/rbac/users/bargineer/roles roles=users Kong-Admin-Token:n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG
{
  "roles": [
    {
      "comment": "Default user role generated for bargineer",
      "created_at": 1531019837000,
      "id": "3edb00c2-9ae1-423d-ac81-bec702c29e37",
      "name": "bargineer"
    },
    {
      "created_at": 1531020346000,
      "id": "9846b92c-6820-4741-ac31-425b3d6abc5b",
      "name": "users"
    }
  ],
  "user": {
    "created_at": 1531019837000,
    "id": "25dfa68e-32e8-48d8-815f-6fedfd2fb4a6",
    "name": "bargineer",
    "enabled": true,
    "user_token": "eZj3WUc46wO3zEJbLP3Y4VGvNaUgGlyv"
  }
}
```

Create bazgineer:

```
http :8001/teamA/rbac/users name=bazgineer Kong-Admin-Token:n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG
{
  "created_at": 1531019937000,
  "id": "ea7207d7-0d69-427b-b288-ce696b7f4690",
  "name": "bazgineer",
  "enabled": true,
  "user_token": "r8NhaT213Zm8o1woQF4ZyQyCVjFRgGp3"
}
```

Add bazgineer to the `users` role:

```
http :8001/teamA/rbac/users/bazgineer/roles roles=users Kong-Admin-Token:n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG
{
  "roles": [
    {
      "comment": "Default user role generated for bazgineer",
      "created_at": 1531019937000,
      "id": "fa409bb6-c86c-45d2-8a6b-ac8e71de2cc9",
      "name": "bazgineer"
    },
    {
      "created_at": 1531020346000,
      "name": "users",
      "id": "9846b92c-6820-4741-ac31-425b3d6abc5b"
    }
  ],
  "user": {
    "created_at": 1531019937000,
    "id": "ea7207d7-0d69-427b-b288-ce696b7f4690",
    "name": "bazgineer",
    "enabled": true,
    "user_token": "r8NhaT213Zm8o1woQF4ZyQyCVjFRgGp3"
  }
}
```

## Regular Team Users use their tokens

foogineer, bargineer, and bazgineer all have gotten their RBAC user tokens
from their Team A admin, and are now allowed to explore Kong—within the
confines of their Team A workspace. Let's validate they can in fact do anything
they wish, except over RBAC and Workspaces.

Try listing Workspaces:

```
http :8001/teamA/workspaces/ Kong-Admin-Token:dNeYvYAwvjOJdoReVJZXF8vLBXQioKkI
{
  "message": "foogineer, you do not have permissions to read this resource"
}
```

Enable some plugin—e.g., key-auth:

```
http :8001/teamA/plugins name=key-auth Kong-Admin-Token:dNeYvYAwvjOJdoReVJZXF8vLBXQioKkI
{
  "created_at": 1531021732000,
  "config": {
    "key_in_body": false,
    "run_on_preflight": true,
    "anonymous": "",
    "hide_credentials": false,
    "key_names": [
      "apikey"
    ]
  },
  "id": "cdc85ef0-804b-4f92-aafd-3ff58512e445",
  "enabled": true,
  "name": "key-auth"
}
```

List currently enabled plugins:

```
http :8001/teamA/plugins Kong-Admin-Token:dNeYvYAwvjOJdoReVJZXF8vLBXQioKkI
{
  "total": 1,
  "data": [
    {
      "created_at": 1531021732000,
      "config": {
        "key_in_body": false,
        "run_on_preflight": true,
        "anonymous": "",
        "hide_credentials": false,
        "key_names": [
          "apikey"
        ]
      },
      "id": "cdc85ef0-804b-4f92-aafd-3ff58512e445",
      "name": "key-auth",
      "enabled": true
    }
  ]
}
```

This ends our use case tutorial; it demonstrates the power of RBAC and
workspaces with a real-world scenario. Following, we will approach **Entity-Level
RBAC**, an extension of our powerful access control to entity-level granularity.

## Entity-Level RBAC: a Primer

Kong Enterprise's new RBAC implementation goes one step further in permissions
granularity: in addition to "endpoint" permissions, it supports entity-level
permissions, meaning that particular entities, identified by their unique ID,
can be allowed or disallowed access in a role.

Refreshing our minds, RBAC is [enforced](#enforcing-rbac) with the `enforce_rbac`
configuration directive—or with its `KONG_ENFORCE_RBAC` environment variable
counterpart. Such directive is an enum, with 4 possible values:

- `on`: similarly to the previous RBAC implementation, applies Endpoint-level
access control
- `entity`: applies **only** Entity-level access control
- `both`: applies **both Endpoint and Entity level access control**
- `off`: disables RBAC enforcement

If one sets it to either `entity` or `both`, Kong will enforce entity-level
access control. However, as with endpoint-level access control, permissions
must be bootstrapped before enforcement is enabled.

### Creating Entity-Level Permissions

Team A just got one new, temporary, team member: qux. Admin A, the admin of
Team A, has already created his qux RBAC user; he needs, however, to limit
access that qux has over entities in Team A workspace, giving him read access
to only a couple of entities—say, a Service and a Route. For that, he will
use Entity-Level RBAC.

**Admin A creates a role for the temporary user qux**:

```
http :8001/teamA/rbac/roles name=qux-role Kong-Admin-Token:n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG
{
  "name": "qux-role",
  "created_at": 1531065975000,
  "id": "ffe93269-7993-4308-965e-0286d0bc87b9"
}
```

We will assume the following entities exist:

A service:

```
http :8001/teamA/services Kong-Admin-Token:n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG
{
  "next": null,
  "data": [
    {
      "host": "httpbin.org",
      "created_at": 1531066074,
      "connect_timeout": 60000,
      "id": "3ed24101-19a7-4a0b-a10f-2f47bcd4ff43",
      "protocol": "http",
      "name": "service1",
      "read_timeout": 60000,
      "port": 80,
      "path": null,
      "updated_at": 1531066074,
      "retries": 5,
      "write_timeout": 60000
    }
  ]
}
```

and a Route to that Service:

```
http :8001/teamA/routes Kong-Admin-Token:n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG
{
  "next": null,
  "data": [
    {
      "created_at": 1531066253,
      "id": "d25afc46-dc59-48b2-b04f-d3ebe19f6d4b",
      "hosts": null,
      "updated_at": 1531066253,
      "preserve_host": false,
      "regex_priority": 0,
      "service": {
        "id": "3ed24101-19a7-4a0b-a10f-2f47bcd4ff43"
      },
      "paths": [
        "/anything"
      ],
      "methods": null,
      "strip_path": false,
      "protocols": [
        "http",
        "https"
      ]
    }
  ]
}
```

**Admin A creates entity permissions in qux-role**:

Add service1—whose ID is 3ed24101-19a7-4a0b-a10f-2f47bcd4ff43:

```
http :8001/teamA/rbac/roles/qux-role/entities entity_id=3ed24101-19a7-4a0b-a10f-2f47bcd4ff43 actions=read Kong-Admin-Token:n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG
{
  "created_at": 1531066684000,
  "role_id": "ffe93269-7993-4308-965e-0286d0bc87b9",
  "entity_id": "3ed24101-19a7-4a0b-a10f-2f47bcd4ff43",
  "negative": false,
  "entity_type": "services",
  "actions": [
    "read"
  ]
}
```

Add the route—whose ID is d25afc46-dc59-48b2-b04f-d3ebe19f6d4b:

```
http :8001/teamA/rbac/roles/qux-role/entities entity_id=d25afc46-dc59-48b2-b04f-d3ebe19f6d4b actions=read Kong-Admin-Token:n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG
{
  "created_at": 1531066728000,
  "role_id": "ffe93269-7993-4308-965e-0286d0bc87b9",
  "entity_id": "d25afc46-dc59-48b2-b04f-d3ebe19f6d4b",
  "negative": false,
  "entity_type": "routes",
  "actions": [
    "read"
  ]
}
```

**Admin A adds qux to his role**:

```
http :8001/teamA/rbac/users/qux/roles roles=qux-role Kong-Admin-Token:n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG
{
  "roles": [
    {
      "comment": "Default user role generated for qux",
      "created_at": 1531065373000,
      "name": "qux",
      "id": "31614171-4174-42b4-9fae-43c9ce14830f"
    },
    {
      "created_at": 1531065975000,
      "name": "qux-role",
      "id": "ffe93269-7993-4308-965e-0286d0bc87b9"
    }
  ],
  "user": {
    "created_at": 1531065373000,
    "id": "4d87bf78-5824-4756-b0d0-ceaa9bd9b2d5",
    "name": "qux",
    "enabled": true,
    "user_token": "sUnv6uBehM91amYRNWESsgX3HzqoBnR5"
  }
}
```

Checking permissions appear listed:

```
http :8001/teamA/rbac/users/qux/permissions Kong-Admin-Token:n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG
{
  "entities": {
    "d25afc46-dc59-48b2-b04f-d3ebe19f6d4b": {
      "actions": [
        "read"
      ],
      "negative": false
    },
    "3ed24101-19a7-4a0b-a10f-2f47bcd4ff43": {
      "actions": [
        "read"
      ],
      "negative": false
    }
  },
  "endpoints": {}
}
```

That is, 2 entities permissions and no endpoint permissions.

Admin A is done setting up qux, and qux can now use his user token to read
his two entities over Kong's admin API.

We will assume that Admin A [enabled entity-level enforcement](#enforcing-rbac).
Note that as qux has **no endpoint-level permissions**, if both endpoint and
entity-level enforcement is enabled, he will not be able to read his entities -
endpoint-level validation comes before entity-level.

**qux tries listing all RBAC users**

```
http :8001/teamA/rbac/users/ Kong-Admin-Token:sUnv6uBehM91amYRNWESsgX3HzqoBnR5
{
  "message": "qux, you do not have permissions to read this resource"
}
```

**qux tries listing all Workspaces**

```
http :8001/teamA/rbac/workspaces/ Kong-Admin-Token:sUnv6uBehM91amYRNWESsgX3HzqoBnR5
{
  "message": "qux, you do not have permissions to read this resource"
}
```

**qux tries to access service1**

```
http :8001/teamA/services/service1 Kong-Admin-Token:sUnv6uBehM91amYRNWESsgX3HzqoBnR5
{
  "host": "httpbin.org",
  "created_at": 1531066074,
  "connect_timeout": 60000,
  "id": "3ed24101-19a7-4a0b-a10f-2f47bcd4ff43",
  "protocol": "http",
  "name": "service1",
  "read_timeout": 60000,
  "port": 80,
  "path": null,
  "updated_at": 1531066074,
  "retries": 5,
  "write_timeout": 60000
}
```

Similarly, he can access his Route:

```
http :8001/teamA/routes/3ed24101-19a7-4a0b-a10f-2f47bcd4ff43 Kong-Admin-Token:sUnv6uBehM91amYRNWESsgX3HzqoBnR5
{
  "created_at": 1531066253,
  "strip_path": false,
  "hosts": null,
  "preserve_host": false,
  "regex_priority": 0,
  "updated_at": 1531066253,
  "paths": [
    "/anything"
  ],
  "service": {
    "id": "3ed24101-19a7-4a0b-a10f-2f47bcd4ff43"
  },
  "methods": null,
  "protocols": [
    "http",
    "https"
  ],
  "id": "d25afc46-dc59-48b2-b04f-d3ebe19f6d4b"
}
```

## Closing Remarks

We will end this chapter with a few closing remarks.

### Wildcards in Permissions

RBAC supports the use of wildcards—represented by the `*` character—in many
aspects of permissions:

**Creating endpoint permissions—`/rbac/roles/:role/endpoints`**

To create an endpoint permission, one must pass the parameters below, all of
which can be replaced by a * character:

- `endpoint`: `*` matches **any endpoint**
- `workspace`: `*` matches **any workspace**
- `actions`: `*` evaluates to **all actions—read, update, create, delete**

**Special case**: `endpoint`, in addition to a single `*`, also accepts `*`
within the endpoint itself, replacing a URL segment between `/`; for example,
all of the following are valid endpoints:

- `/rbac/*`: where `*` replaces any possible segment—e.g., `/rbac/users`,
`/rbac/roles`, etc
- `/services/*/plugins`: `*` matches any Service name or ID

Note, however, that `*` **is not** a generic, shell-like, glob pattern.

If `workspace` is ommitted, it defaults to the current request's workspace. For
example, a role-endpoint permission created with `/teamA/roles/admin/endpoints`
is scoped to workspace `teamA`.

**Creating entity permissions—`/rbac/roles/:role/entities`**

Similarly, for entity permissions, the following parameters accept a `*`
character:

- `entity_id`: `*` matches **any entity ID**

### Entities Concealing in Entity-Level RBAC

With Entity-Level RBAC enabled, endpoints that list all entities of a
particular collection will only list entities that the user has access to;
in the example above, if user qux listed all Routes, he would only get as
response the entities he has access to—even though there could be more:

```
http :8001/teamA/routes Kong-Admin-Token:sUnv6uBehM91amYRNWESsgX3HzqoBnR5
{
  "next": null,
  "data": [
    {
      "created_at": 1531066253,
      "id": "d25afc46-dc59-48b2-b04f-d3ebe19f6d4b",
      "hosts": null,
      "updated_at": 1531066253,
      "preserve_host": false,
      "regex_priority": 0,
      "service": {
        "id": "3ed24101-19a7-4a0b-a10f-2f47bcd4ff43"
      },
      "paths": [
        "/anything"
      ],
      "methods": null,
      "strip_path": false,
      "protocols": [
        "http",
        "https"
      ]
    }
  ]
}
```

Some Kong endpoints carry a `total` field in responses; with Entity-Level RBAC
enabled, the global count of entities is displayed, but only entities the user
has access to are themselves shown; for example, if Team A has a number of
plugins configured, but qux only has access to one of them, the following
would be the expected output for a GET request to `/teamA/plugins`:

```
http :8001/teamA/plugins Kong-Admin-Token:sUnv6uBehM91amYRNWESsgX3HzqoBnR5
{
  "total": 2,
  "data": [
    {
      "created_at": 1531070344000,
      "config": {
        "key_in_body": false,
        "run_on_preflight": true,
        "anonymous": "",
        "hide_credentials": false,
        "key_names": [
          "apikey"
        ]
      },
      "id": "8813dd0b-3e9d-4bcf-8a10-3112654f86e7",
      "name": "key-auth",
      "enabled": true
    }
  ]
}
```

Notice the `total` field is 2, but qux only got one entity in the response.

### Creating Entities in Entity-Level RBAC

As entity-level RBAC provides access control to individual existing entities,
it does not apply to creation of new entities; for that, endpoint-level
permissions must be configured and enforced. For example, if endpoint-level
permissions are not enforced, qux will be able to create new entities:

```
http :8001/teamA/routes paths[]=/anything service.id=3ed24101-19a7-4a0b-a10f-2f47bcd4ff43 strip_path=false Kong-Admin-Token:sUnv6uBehM91amYRNWESsgX3HzqoBnR5
{
  "created_at": 1531070828,
  "strip_path": false,
  "hosts": null,
  "preserve_host": false,
  "regex_priority": 0,
  "updated_at": 1531070828,
  "paths": [
    "/anything"
  ],
  "service": {
    "id": "3ed24101-19a7-4a0b-a10f-2f47bcd4ff43"
  },
  "methods": null,
  "protocols": [
    "http",
    "https"
  ],
  "id": "6ee76f74-3c96-46a9-ae48-72df0717d244"
}
```

and qux will automatically have permissions to perform any actions to entities
he created.

---

[rbac-overview]: /enterprise/{{page.kong_version}}/kong-manager/administration/rbac
[rbac-admin]: /enterprise/{{page.kong_version}}/admin-api/rbac/reference
[workspaces-examples]: /enterprise/{{page.kong_version}}/admin-api/workspaces/examples
[getting-started-guide]: /getting-started-guide/latest/overview
