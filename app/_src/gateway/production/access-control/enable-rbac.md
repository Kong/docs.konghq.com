---
title: RBAC Examples
badge: enterprise
---

This chapter aims to provide a step-by-step tutorial on how to set up
RBAC and see it in action, with an end-to-end use case. The chosen
use case demonstrates how **RBAC with workspaces** can be coupled
to achieve a flexible organization of teams and users in complex
hierarchies. 

## Use case

For the sake of example, let's say a given company has a {{site.base_gateway}}
cluster to be shared with two teams: teamA and teamB. While the Kong
clusters are shared among these teams, they want to be able to segment
their entities in such a way that management of entities in one team doesn't
disrupt operation in some other team. As shown in the
[Workspaces Page][workspaces-examples], such a use case is possible
with workspaces. On top of workspaces, though, each team wants to enforce
access control over their Workspace, which is possible with RBAC. 

To sum up, workspaces and RBAC are complementary: workspaces provide segmentation of
Admin API entities, while RBAC provides access control.

{:.note}
> **Note:** The example responses in this guide are often excerpts of full responses,
focusing on the most relevant part of the response, as the full response can be very long.

## Bootstrapping the first RBAC user

The first RBAC user is called the super admin.

Kong recommends that you create a super admin
user before actually enforcing RBAC and restarting {{site.base_gateway}} 
with RBAC enabled.

{:.note}
> It's possible to create the first super admin at installation time.
If you chose this option, skip to [Enforcing RBAC](#enforcing-rbac).

{{site.base_gateway}} ships with a set of default RBAC roles: `super-admin`,
the `admin`, and `read-only`, which makes the task of creating a super admin user easy:

1. Create the RBAC user, named `super-admin`:

    ```sh
    curl -i -X POST http://localhost:8001/rbac/users \
      -H 'Kong-Admin-Token:secureadmintoken' \
      --data name=super-admin \
      --data user_token=exampletoken
    ```

    Response:
    ```json
    {
      "user_token": "M8J5A88xKXa7FNKsMbgLMjkm6zI2anOY",
      "id": "da80838d-49f8-40f6-b673-6fff3e2c305b",
      "enabled": true,
      "created_at": 1531009435,
      "updated_at": 1531009435,
      "name": "super-admin"
    }
    ```

    As the `super-admin` username coincides with an existing `super-admin`
    role, it gets automatically added to the `super-admin` role. 

1. Confirm using the following command:

    ```sh
    curl -i -X GET http://localhost:8001/rbac/users/super-admin/roles
    ```

    Response:
    ```json
    {
      "roles": [
        {
          "comment": "Full access to all endpoints, across all workspaces",
          "created_at": 1531009724,
          "updated_at": 1531009724,
          "name": "super-admin",
          "id": "b924ac91-e83f-4136-a5a4-4a7ff92594a8"
        }
      ],
      "user": {
        "created_at": 1531009435,
        "updated_at": 1531009724,
        "id": "e6897cc0-0c34-4a9c-9f0b-cc65b4f04d68",
        "name": "super-admin",
        "enabled": true,
        "user_token": "vajeOlkybsn0q0VD9qw9B3nHYOErgY7b8"
      }
    }
    ```

## Enforcing RBAC

With the `super-admin` user created, the Kong admin can now restart 
{{site.base_gateway}} with RBAC enforced:

```
KONG_ENFORCE_RBAC=on kong restart
```

This is one of the possible ways of enforcing RBAC and restarting
Kong. Another option is editing the {{site.base_gateway}} configuration file and
restarting.

Before moving on, note that this guide uses the super admin user, but you 
could move on without RBAC enabled, and have the Kong admin set up the whole RBAC hierarchy. 

However, we want to stress the fact that RBAC is powerful enough to allow a flexible separation of tasks.
To summarize:

- **Kong admin**: This user has physical access to Kong infrastructure. Their
task is to bootstrap the Kong cluster as well as its configuration, including
initial RBAC users.
- **RBAC super admin**: Created by the Kong admin, has the role of managing
RBAC users, roles, and permissions. While this could all be done by the Kong admin, 
we recommend separating the responsibility for better security.

## Super admin creates the team workspaces

The super admin now sets up two teams: teamA and teamB, creating
one workspace for each and one admin for each.

1. Create the workspace for `teamA`:

    ```sh
    curl -i -X POST http://localhost:8001/workspaces \
      --data name=teamA \
      -H 'Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8'
    ```

    Response:
    ```json
    {
      "name": "teamA",
      "created_at": 1531014100,
      "updated_at": 1531014100,
      "id": "1412f3a6-4d9b-4b9d-964e-60d8d63a9d46"
    }
    ```

1. Create the workspace for `teamB`:

    ```sh
    curl -i -X POST http://localhost:8001/workspaces \
      --data name=teamB \
      -H 'Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8'
    ```

    Response:
    ```json
    {
      "name": "teamB",
      "created_at": 1531014143,
      "updated_at": 1531014143,
      "id": "7dee8c56-c6db-4125-b87a-b508baa33c66"
    }
    ```

## Super admin creates one admin for each team

1. Create an admin for `teamA`:

    ```sh
    curl -i -X POST http://localhost:8001/teamA/rbac/users \
      --data name=adminA \
      --data user_token=exampletokenA \
      -H 'Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8'
    ```

    Response:
    ```json
    {
      "user_token": "qv1VLIpl8kHj7lC1QOKwRdCMXanqEDii",
      "id": "4d315ff9-8c1a-4844-9ea2-21b16204a154",
      "enabled": true,
      "created_at": 1531015165,
      "updated_at": 1531015165,
      "name": "adminA"
    }
    ```

1. Create an admin for `teamB`:

    ```sh
    curl -i -X POST http://localhost:8001/teamB/rbac/users \
      --data name=adminB \
      --data user_token=exampletokenB \
      -H 'Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8'
    ```

    Response:
    ```json
    {
      "user_token": "IX5vHVgYqM40tLcctdmzRtHyfxB4ToYv",
      "id": "49641fc0-8c9d-4507-bc7a-2acac8f2903a",
      "enabled": true,
      "created_at": 1531015221,
      "updated_at": 1531015221,
      "name": "adminB"
    }
    ```

1. Both of the teams now have one admin and each admin can only be seen
in their corresponding workspace. To verify, run:

    ```sh
    curl -i -X GET http://localhost:8001/teamA/rbac/users \
      -H 'Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8'
    ```

    Response:

    ```json
    {
      "total": 1,
      "data": [
        {
          "created_at": 1531014784,
          "updated_at": 1531014784,
          "id": "1faaacd1-709f-4762-8c3e-79f268ec8faf",
          "name": "adminA",
          "enabled": true,
          "user_token": "n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG"
        }
      ]
    }
    ```

    Similarly, workspace `teamB` only shows its own admin:

    ```sh
    curl -i -X GET http://localhost:8001/teamB/rbac/users \
      -H 'Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8'
    ```

    Response:

    ```json
    {
      "total": 1,
      "data": [
        {
          "created_at": 1531014805,
          "updated_at": 1531014805,
          "id": "3a829408-c1ee-4764-8222-2d280a5de441",
          "name": "adminB",
          "enabled": true,
          "user_token": "C8b6kTTN10JFyU63ORjmCQwVbvK4maeq"
        }
      ]
    }
    ```

## Super admin creates admin roles for teams

The super admin is now done creating RBAC admin users for each team. The next
task is to create admin roles that will effectively grant permissions to admin
users.

The admin role must have access to all of the Admin API, restricted to its
workspace.

1. Set up the admin role, paying close attention to the request parameters:

    ```sh
    curl -i -X POST http://localhost:8001/teamA/rbac/roles/ \
      --data name=admin \
      -H 'Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8'
    ```

    Response:
    ```json
    {
      "created_at": 1531016728,
      "updated_at": 1531016728,
      "id": "d40e61ab-8dad-4ef2-a48b-d11379f7b8d1",
      "name": "admin"
    }
    ```

1. Create role endpoint permissions:

    ```sh
    curl -i -X POST http://localhost:8001/teamA/rbac/roles/admin/endpoints/ \
      --data 'endpoint=*' \
      --data 'workspace=teamA' \
      --data 'actions=*' \
      -H 'Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8'
    ```

    Response:
    ```json
    {
      "total": 1,
      "data": [
        {
          "endpoint": "*",
          "created_at": 1531017322,
          "updated_at": 1531017322,
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

1. Add the `adminA` user to the admin role in their workspace:

    ```sh
    curl -i -X POST http://localhost:8001/teamA/rbac/users/adminA/roles/ \
      --data roles=admin \
      -H 'Kong-Admin-Token:vajeOlkbsn0q0VD9qw9B3nHYOErgY7b8'
    ```

    Response: 

    ```json
    {
      "roles": [
          {
              "created_at": 1685551877,
              "updated_at": 1531014805,
              "id": "42809ada-650c-4575-b0a0-d464a64ffb70",
              "name": "admin",
              "ws_id": "9dc7adbb-9b64-4121-bf76-653cf5871bc2"
          }
      ],
      "user": {
          "comment": "null",
          "created_at": 1685552809,
          "updated_at": 1531014805,
          "enabled": true,
          "id": "bca4e390-fbbf-4a46-b55d-f4642efc14bb",
          "name": "adminA",
          "user_token": "$2b$09$oLyKTIDuKriPZ.SD5wYtxeMclGYNDn4udJkQG0NGx/Aq3j9j/tWsa",
          "user_token_ident": "0ebb5"
            }
    }
    ```

1. Team A's admin user is now able to manage their team. To
validate that, let's try to list RBAC users in Team B using Team A's admin
user token:

    ```sh
    curl -i -X GET http://localhost:8001/teamB/rbac/users \
      -H 'Kong-Admin-Token:exampletokenA'
    ```

    Notice that you can't access the endpoint:
    ```json
    {
      "message": "Invalid RBAC credentials"
    }
    ```

1. Now try listing RBAC users in Team A's workspace:

    ```sh
    curl -i -X GET http://localhost:8001/teamA/rbac/users \
      -H 'Kong-Admin-Token:exampletokenA'
    ```

    Response:
    ```json
    {
      "total": 1,
      "data": [
        {
          "created_at": 1531014784,
          "updated_at": 1531014784,
          "id": "1faaacd1-709f-4762-8c3e-79f268ec8faf",
          "name": "adminA",
          "enabled": true,
          "user_token": "n5bhjgv0speXp4N7rSUzUj8PGnl3F5eG"
        }
      ]
    }
    ```

If the same procedure is repeated for Team B, they will end up with
a similar set up, with an admin role and an admin user, both restricted to the
team's workspace.

The super admin's job is now done. 
Individual team admins are now able to set up their team's users and entities!

## Team admins create regular users

From this point on, team admins are able to drive the process. The next
step is to create team users, such as engineers that are part of Team A or B. 
Let's go ahead and do that, using Admin A's user token.

Before regular users can be created, a role needs to be available for them.
This role needs to have permissions to all of the Admin API endpoints, except
RBAC and workspaces. Regular users don't need access to these endpoints,
and if they do, the admin can grant them individually.

### Create the users role

1. As a team admin, create the regular `users` role:

    ```sh
    curl -i -X POST http://localhost:8001/teamA/rbac/roles/ \
      --data name=users \
      -H 'Kong-Admin-Token:exampletokenA'
    ```

    Response:
    ```json
    {
      "created_at": 1531020346,
      "updated_at": 1531020346,
      "id": "9846b92c-6820-4741-ac31-425b3d6abc5b",
      "name": "users"
    }
    ```

1. Create a permission for all of the Admin API, which requires a positive permission on `\*`:

    ```sh
    curl -i -X POST http://localhost:8001/teamA/rbac/roles/users/endpoints/ \
      --data 'endpoint=*' \
      --data 'workspace=teamA' \
      --data 'actions=*' \
      -H 'Kong-Admin-Token:exampletokenA'
    ```

    Response:
    ```json
    {
      "endpoint": "*",
      "created_at": 1531020573,
      "udpated_at": 1531020573,
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

1. Then, filter out RBAC and workspaces with negative permissions:

    Filter out RBAC endpoints:

    ```sh
    curl -i -X POST http://localhost:8001/teamA/rbac/roles/users/endpoints/ \
      --data 'endpoint=/rbac/*' \
      --data 'workspace=teamA' \
      --data 'actions=*' \
      --data 'negative=true' \
      -H 'Kong-Admin-Token:exampletokenA'
    ```

    Response:
    ```json
    {
      "endpoint": "/rbac/*",
      "created_at": 1531020744,
      "updated_at": 1531020744,
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

    Filter out workspaces endpoints:

    ```sh
    curl -i -X POST http://localhost:8001/teamA/rbac/roles/users/endpoints/ \
      --data 'endpoint=/workspaces/*' \
      --data 'workspace=teamA' \
      --data 'actions=*' \
      --data 'negative=true' \
      -H 'Kong-Admin-Token:exampletokenA'
    ```

    Response:
    ```json
    {
      "endpoint": "/workspaces/*",
      "created_at": 1531020778,
      "updated_at": 1531020778,
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

{:.important}
> **Important**: As explained in the [Wildcards in Permissions](#wildcards-in-permissions)
section, the meaning of `*` is not the same as generic globbing.
 As such, `/rbac/*` or `/workspaces/*` do not match all of the
RBAC and Workspaces endpoints. For example, to cover all of the RBAC API,
you would have to define permissions for the following endpoints:
>
> - `/rbac/*`
> - `/rbac/*/*`
> - `/rbac/*/*/*`
> - `/rbac/*/*/*/*`
> - `/rbac/*/*/*/*/*`

### Add members to a team

Team A just got two new members: `foogineer` and `bargineer`. Admin A
welcomes them to the team by creating RBAC users for them and giving them
access to Kong.

1. Create `foogineer`:

    ```sh
    curl -i -X POST http://localhost:8001/teamA/rbac/users \
      --data name=foogineer \
      --data user_token=exampletokenfoo \
      -H 'Kong-Admin-Token:exampletokenA'
    ```

    Response:
    ```json
    {
      "created_at": 1531019797,
      "updated_at": 1531019797,
      "id": "0b4111da-2827-4767-8651-a327f7a559e9",
      "name": "foogineer",
      "enabled": true,
      "user_token": "dNeYvYAwvjOJdoReVJZXF8vLBXQioKkI"
    }
    ```

1. Add `foogineer` to the `users` role:

    ```sh
    curl -i -X POST http://localhost:8001/teamA/rbac/users/foogineer/roles \
      --data roles=users \
      -H 'Kong-Admin-Token:exampletokenA'
    ```

    Response:
    ```json
    {
      "roles": [
        {
          "comment": "Default user role generated for foogineer",
          "created_at": 1531019797,
          "updated_at": 1531019797,
          "id": "125c4212-b882-432d-a323-9cbe38b1d0df",
          "name": "foogineer"
        },
        {
          "created_at": 1531020346,
          "updated_at": 1531020346,
          "id": "9846b92c-6820-4741-ac31-425b3d6abc5b",
          "name": "users"
        }
      ],
      "user": {
        "created_at": 1531019797,
        "updated_at": 1531019797,
        "id": "0b4111da-2827-4767-8651-a327f7a559e9",
        "name": "foogineer",
        "enabled": true,
        "user_token": "dNeYvYAwvjOJdoReVJZXF8vLBXQioKkI"
      }
    }
    ```

1. Create `bargineer`:

    ```sh
    curl -i -X POST http://localhost:8001/teamA/rbac/users \
      --data name=bargineer \
      --data user_token=exampletokenbar \
      -H 'Kong-Admin-Token:exampletokenA'
    ```

    Response:
    ```json
    {
      "created_at": 1531019797,
      "updated_at": 1531019797,
      "id": "e8926efa-11b4-43a3-9a28-767c05d8e9d8",
      "name": "bargineer",
      "enabled": true,
      "user_token": "dNeYvYAwvjOJdoReVJZXF8vLBXQioKkI"
    }
    ```

1. Add `bargineer` to the `users` role:

    ```sh
    curl -i -X POST http://localhost:8001/teamA/rbac/users/foogineer/roles \
      --data roles=users \
      -H 'Kong-Admin-Token:exampletokenA'
    ```

    Response:
    ```json
    {
      "roles": [
        {
          "comment": "Default user role generated for bargineer",
          "created_at": 1531019797,
          "updated_at": 1531019797,
          "id": "125c4212-b882-432d-a323-9cbe38b1d0df",
          "name": "bargineer"
        },
        {
          "created_at": 1531020346,
          "updated_at": 1531020346,
          "id": "9846b92c-6820-4741-ac31-425b3d6abc5b",
          "name": "users"
        }
      ],
      "user": {
        "created_at": 1531019797,
        "updated_at": 1531019797,
        "id": "e8926efa-11b4-43a3-9a28-767c05d8e9d8",
        "name": "bargineer",
        "enabled": true,
        "user_token": "dNeYvYAwvjOJdoReVJZXF8vLBXQioKkI"
      }
    }
    ```

## Regular team users use their tokens

`foogineer` and `bargineer` have gotten their RBAC user tokens
from their Team A admin, and are now allowed to explore {{site.base_gateway}} within the
confines of their Team A workspace. Let's validate this.

1. As `foogineer`, try listing workspaces:

    ```sh
    curl -i -X GET http://localhost:8001/teamA/workspaces/ \
      -H 'Kong-Admin-Token:dNeYvYAwvjOJdoReVJZXF8vLBXQioKkI'
    ```

    Response:
    ```json
    {
      "message": "foogineer, you do not have permissions to read this resource"
    }
    ```

1. Enable some plugin, for example `key-auth`:

    ```sh
    curl -i -X POST http://localhost:8001/teamA/plugins \
      --data name=key-auth \
      -H 'Kong-Admin-Token:dNeYvYAwvjOJdoReVJZXF8vLBXQioKkI'
    ```

    Response:
    ```json
    {
      "created_at": 1531021732,
      "updated_at": 1531021732,
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

1. List currently enabled plugins:

    ```sh
    curl -i -X GET http://localhost:8001/teamA/plugins \
      -H 'Kong-Admin-Token:dNeYvYAwvjOJdoReVJZXF8vLBXQioKkI'
    ```

    Response:
    ```json
    {
      "total": 1,
      "data": [
        {
          "created_at": 1531021732,
          "updated_at": 1531021732,
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

This ends the use case tutorial, which demonstrates the power of RBAC and
workspaces with a real-world scenario.

## Entity-level RBAC

In addition to endpoint permissions, RBAC in {{site.base_gateway}} supports entity-level
permissions, meaning that particular entities, identified by their unique ID,
can be allowed or disallowed access in a role.

RBAC is [enforced](#enforcing-rbac) with the `enforce_rbac`
configuration directive, or with its `KONG_ENFORCE_RBAC` environment variable
counterpart. The directive is an enum, with the following possible values:

- `on`: Applies endpoint-levelaccess control
- `entity`: Applies **only** Entity-level access control
- `both`: Applies **both Endpoint and Entity level access control**
- `off`: disables RBAC enforcement

If set to `entity` or `both`, Kong enforces entity-level
access control. However, as with endpoint-level access control, permissions
must be bootstrapped before enforcement is enabled.

### Creating entity-level permissions

Team A just got one new, temporary, team member: `qux`. Admin A, the admin of
Team A, has already created the `qux` RBAC user. 

Next, the admin needs to limit the access that `qux` has over entities in the Team A workspace, 
giving the user read access to only a couple of entities. For that, the admin needs
to use entity-level RBAC.

1. As Admin A, create a role for the temporary user `qux`:

    ```sh
    curl -i -X POST http://localhost:8001/teamA/rbac/roles \
      --data name=qux-role \
      -H Kong-Admin-Token:exampletokenA
    ```

    Response:
    ```json
    {
      "name": "qux-role",
      "created_at": 1531065975,
      "updated_at": 1531065975,
      "id": "ffe93269-7993-4308-965e-0286d0bc87b9"
    }
    ```

1. Grant the user read access to two entities: a service and a route. Reference each entity by its ID:

    For example, using `service1` with the ID `3ed24101-19a7-4a0b-a10f-2f47bcd4ff43` and `route1` with the ID `d25afc46-dc59-48b2-b04f-d3ebe19f6d4b`:

    ```sh
    curl -i -X POST http://localhost:8001/teamA/rbac/roles/admin/entities \
      --data entity_id=3ed24101-19a7-4a0b-a10f-2f47bcd4ff43 \
      --data entity_type=services \
      --data actions=read \
      -H 'Kong-Admin-Token:exampletokenA'
    ```

    Response:
    ```json
    {
      "created_at": 1531066684,
      "updated_at": 1531066684,
      "role_id": "ffe93269-7993-4308-965e-0286d0bc87b9",
      "entity_id": "3ed24101-19a7-4a0b-a10f-2f47bcd4ff43",
      "negative": false,
      "entity_type": "services",
      "actions": [
        "read"
      ]
    }
    ```

    ```sh
    curl -i -X POST http://localhost:8001/teamA/rbac/roles/qux-role/entities \
      --data entity_id=d25afc46-dc59-48b2-b04f-d3ebe19f6d4b \
      --data entity_type=routes \
      --data actions=read \
      -H 'Kong-Admin-Token:exampletokenA'
    ```

    Response:
    ```json
    {
      "created_at": 1531066684,
      "updated_at": 1531066684,
      "role_id": "ffe93269-7993-4308-965e-0286d0bc87b9",
      "entity_id": "d25afc46-dc59-48b2-b04f-d3ebe19f6d4b",
      "negative": false,
      "entity_type": "routes",
      "actions": [
        "read"
      ]
    }
    ```

1. Add the user `qux` to `qux-role`:

    ```sh
    curl -i -X POST http://localhost:8001/teamA/rbac/users/qux/roles \
      --data roles=qux-role \
      -H 'Kong-Admin-Token:exampletokenA'
    ```

    Response:
    ```json
    {
      "roles": [
        {
          "comment": "Default user role generated for qux",
          "created_at": 1531065373,
          "updated_at": 1531065373,
          "name": "qux",
          "id": "31614171-4174-42b4-9fae-43c9ce14830f"
        },
        {
          "created_at": 1531065975,
          "updated_at": 1531065975,
          "name": "qux-role",
          "id": "ffe93269-7993-4308-965e-0286d0bc87b9"
        }
      ],
      "user": {
        "created_at": 1531065373,
        "created_at": 1531065373,
        "id": "4d87bf78-5824-4756-b0d0-ceaa9bd9b2d5",
        "name": "qux",
        "enabled": true,
        "user_token": "sUnv6uBehM91amYRNWESsgX3HzqoBnR5"
      }
    }
    ```

1. Check that the correct permissions are listed for `qux`:

    ```sh
    curl -i -X GET http://localhost:8001/teamA/rbac/users/qux/permissions \
      -H 'Kong-Admin-Token:exampletokenA'
    ```

    Response:
    ```json
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
    
    `qux` should have two entity permissions and no endpoint permissions.

Admin A is done setting up `qux`, and `qux `can now use their user token to read
the two entities over Kong's admin API.

Let's assume that Admin A [enabled entity-level enforcement](#enforcing-rbac) as well.
Note that as `qux` has **no endpoint-level permissions**. If both endpoint and
entity-level enforcement is enabled, `qux` won't be able to read their entities, as
endpoint-level validation comes before entity-level.

1. As `qux`, try listing all RBAC users:

    ```sh
    curl -i -X GET http://localhost:8001/teamA/rbac/users/ \
      -H Kong-Admin-Token:sUnv6uBehM91amYRNWESsgX3HzqoBnR5
    ```

    Response:
    ```json
    {
      "message": "qux, you do not have permissions to read this resource"
    }
    ```

1. As `qux`, try to access `service1`:

    ```
    curl -i -X GET http://localhost:8001/teamA/services/service1 \
      -H Kong-Admin-Token:sUnv6uBehM91amYRNWESsgX3HzqoBnR5
    ```

    Response:
    ```json
    {
      "host": "httpbin.org",
      "created_at": 1531066074,
      "updated_at": 1531066074,
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

## Wildcards in permissions

RBAC supports the use of wildcards (`*`) in many aspects of permissions.

### Creating endpoint permissions

To create an endpoint permission via `/rbac/roles/:role/endpoints`, 
you must pass the parameters below, all of which can be replaced by a `*` character:

- `endpoint`: `*` matches **any endpoint**
- `workspace`: `*` matches **any workspace**
- `actions`: `*` evaluates to **all actions—read, update, create, delete**

**Special case**: `endpoint`, in addition to a single `*`, also accepts `*`
within the endpoint itself, replacing a URL segment between `/`. For example,
all of the following are valid endpoints:

- `/rbac/*`: where `*` replaces any possible segment, for example `/rbac/users` 
and `/rbac/roles`
- `/services/*/plugins`: `*` matches any service name or ID

{:.note}
> **Note** `*` **is not** a generic, shell-like, glob pattern.

If `workspace` is omitted, it defaults to the current request's workspace. For
example, a role-endpoint permission created with `/teamA/roles/admin/endpoints`
is scoped to workspace `teamA`.

### Creating entity permissions

For entity permissions created via `/rbac/roles/:role/entities`,
the following parameter accepts a `*` character:

- `entity_id`: `*` matches **any entity ID**

## Entities nested in entity-level RBAC

With entity-level RBAC enabled, endpoints that list all entities of a
particular collection will only list entities that the user has access to.

In the example above, if user `qux` listed all routes, they would only get 
the entities they have access to in the response, even though there 
could be more in the workspace:

```sh
curl -i -X GET http://localhost:8001/teamA/routes \
  -H 'Kong-Admin-Token:sUnv6uBehM91amYRNWESsgX3HzqoBnR5'
```

Response:
```json
{
  "next": null,
  "data": [
    {
      "created_at": 1531066253,
      "updated_at": 1531066253,
      "id": "d25afc46-dc59-48b2-b04f-d3ebe19f6d4b",
      "hosts": null,
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

Some Kong endpoints carry a `total` field in responses. With entity-level RBAC
enabled, the global count of entities is displayed, but only entities the user
has access to are themselves shown. 

For example, if Team A has a number of plugins configured, but `qux` only has access to one of them, 
the following would be the expected output for a GET request to `/teamA/plugins`:

```sh
curl -i -X GET http://localhost:8001/teamA/plugins \
  -H 'Kong-Admin-Token:sUnv6uBehM91amYRNWESsgX3HzqoBnR5'
```

Response:
```json
{
  "total": 2,
  "data": [
    {
      "created_at": 1531070344,
      "updated_at": 1531070344,
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

Notice the `total` field is 2, but `qux` only got one entity in the response.

### Creating entities in entity-level RBAC

As entity-level RBAC provides access control to individual existing entities,
it does not apply to creation of new entities. For that, endpoint-level
permissions must be configured and enforced. 

For example, if endpoint-level
permissions are not enforced, `qux` will be able to create new entities, and
will automatically have permissions to perform any actions to entities 
they create:

```sh
curl -i -X POST http://localhost:8001/teamA/routes \
  --data paths[]=/anything \
  --data service.id=3ed24101-19a7-4a0b-a10f-2f47bcd4ff43 \
  --data strip_path=false \
  -H 'Kong-Admin-Token:sUnv6uBehM91amYRNWESsgX3HzqoBnR5'
```

Response:
```json
{
  "created_at": 1531070828,
  "updated_at": 1531070828,
  "strip_path": false,
  "hosts": null,
  "preserve_host": false,
  "regex_priority": 0,
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

[workspaces-examples]: /gateway/{{page.release}}/kong-enterprise/workspaces
[getting-started-guide]: /gateway/{{page.release}}/get-started/
