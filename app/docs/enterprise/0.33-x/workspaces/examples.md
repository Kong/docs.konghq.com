---
title: Examples
book: workspaces
chapter: 3
---

# Workspaces Examples

This chapter aims to provide a step-by-step tutorial of how to set up
workspaces, entities, and see it in action.

## RBAC & Workspaces

TODO: explain how RBAC and workspaces complement each other: Workspaces
segmenting different "domains" of operation and RBAC locking these down
to authorized admins/users.

## The Default workspace

Kong creates a default workspace - unsurprisingly named `default` - whose goal
is to group all existing entities in Kong, where "exisisting entities" refers to:

- Entities that were created in operation in previous versions &amp; in case
one is migrating from an older Kong version;
- Entities that Kong creates at migration time - e.g., RBAC credentials, which
are provisioned at migration time as a convenience

It will also hold entities that are created without being explicitly assigned to
a specific workspace.

That said, it's worth noting that the default workspace is a workspace as any
other, the only difference being that it's created by Kong, at migration time.

(Examples will be shown using the httpie HTTP command line client.)

## Listing workspaces and its entities

In a fresh Kong Enterprise install - or one just migrated to 0.33 - issue the
following request:

```
http GET :8001/workspaces
{
  "total": 1,
  "data": [
    {
      "created_at": 1529627841000,
      "id": "a43fc3f9-98e4-43b0-b703-c3b1004980d5",
      "name": "default"
    }
  ]
}
```

## List entities in the default workspace

To get a list of entities contained in - or referenced by - the default workspace,
let's issue the following request:

```
http GET :8001/workspaces/default/entities
{
  "data": [
    {
      "workspace_id": "a43fc3f9-98e4-43b0-b703-c3b1004980d5",
      "entity_id": "a43fc3f9-98e4-43b0-b703-c3b1004980d5",
      "entity_type": "workspaces",
    },
    {
      "workspace_id": "a43fc3f9-98e4-43b0-b703-c3b1004980d5",
      "entity_id": "e6b5f24a-8914-40b3-a1f5-02e88b33b1d3",
      "entity_type": "portal_files",
    },
    {
      "workspace_id": "a43fc3f9-98e4-43b0-b703-c3b1004980d5",
      "entity_id": "ee7a43f0-c4e5-4533-8000-5e8bd459049f",
      "entity_type": "portal_files",
    },
    ...
    {
      "workspace_id": "a43fc3f9-98e4-43b0-b703-c3b1004980d5",
      "entity_id": "74e706b6-4f0d-411c-9369-55a61ecc5fa8",
      "entity_type": "portal_files",
    },
  ],
  "total": 42
}
```

As can be seen, a total of 42 entities were part of the default workspace - for
brevity, most of them were redacted here.

## Creating a workspace and adding entities to it

A more interesting example would be segmenting entities by teams; for the sake of
example, let's say they are teamA, teamB, and teamC.

Each of these teams has its own set of entities - say, upstream services and
routes - and want to segregate their configurations and traffic; they can
achieve that with workspaces.

```
http POST :8001/workspaces name=teamA
{
    "created_at": 1528843468000,
    "id": "735af96e-206f-43f7-88f0-b930d5fd4b7e",
    "name": "teamA"
}
```

```
http POST :8001/workspaces name=teamB
{
  "name": "teamB",
  "created_at": 1529628574000,
  "id": "a25728ac-6036-497c-82ee-524d4c22fcae"
}
```

```
http POST :8001/workspaces name=teamC
{
  "name": "teamC",
  "created_at": 1529628622000,
  "id": "34b28f10-e1ec-4dad-9ac0-74780baee182"
}
```

At this point, if we list workspaces, we will get a total of 4 - remember,
Kong provisions a "default" workspace and, on top of that, we created other
3.

```
{
  "data": [
    {
      "created_at": 1529627841000,
      "id": "a43fc3f9-98e4-43b0-b703-c3b1004980d5",
      "name": "default"
    },
    {
      "created_at": 1529628818000,
      "id": "5ed1c043-78cc-4fe2-924e-40b17ecd97bc",
      "name": "teamA"
    },
    {
      "created_at": 1529628574000,
      "id": "a25728ac-6036-497c-82ee-524d4c22fcae",
      "name": "teamB"
    },
    {
      "created_at": 1529628622000,
      "id": "34b28f10-e1ec-4dad-9ac0-74780baee182",
      "name": "teamC"
    }
  ]
  "total": 4,
}

```

Having our teams' workspaces set up, let's add some entities to them. Say
they have a common Service - represented by the [Service][services] Kong
entity - and different routes associated with this upstream service.

Creating the shared service:

```
http :8001/services url=http://httpbin.org/ name=shared-service
{
  "host": "httpbin.org",
  "created_at": 1529699798,
  "connect_timeout": 60000,
  "id": "86608199-e3d8-48aa-b76d-d9ec36d8d445",
  "protocol": "http",
  "name": "shared-service",
  "read_timeout": 60000,
  "port": 80,
  "path": "/",
  "updated_at": 1529699798,
  "retries": 5,
  "write_timeout": 60000
}
```

Notice the endpoint `/services` does not include a workspace prefix - which
is how one specifies the workspace under which a given API call applies to.
In such cases, the call applies to the `default` workspace. Let's confirm that
by listing all entities under the `default` workspace:

```
http :8001/workspaces/default/entities
{
  "data": [
    ...
    {
      "workspace_id": "dd516707-919e-4e72-9fd8-12f63a80a662",
      "unique_field_name": "name",
      "entity_id": "86608199-e3d8-48aa-b76d-d9ec36d8d445",
      "entity_type": "services",
      "unique_field_value": "shared-service"
    }
  ],
  "total": 43
}
```

Again, entities not relevant for this example were redacted; notice, though,
that our shared service is in the list.

The next step is to add the shared service to our teams' workspaces. This can be
done as follows:

```
http :8001/workspaces/teamA/entities entities=86608199-e3d8-48aa-b76d-d9ec36d8d445
http :8001/workspaces/teamB/entities entities=86608199-e3d8-48aa-b76d-d9ec36d8d445
http :8001/workspaces/teamC/entities entities=86608199-e3d8-48aa-b76d-d9ec36d8d445
```

To confirm the shared service was added,

```
http :8001/teamA/services
{
  "next": null,
  "data": [
    {
      "host": "httpbin.org",
      "created_at": 1529699798,
      "connect_timeout": 60000,
      "id": "86608199-e3d8-48aa-b76d-d9ec36d8d445",
      "protocol": "http",
      "name": "shared-service",
      "read_timeout": 60000,
      "port": 80,
      "path": "/",
      "updated_at": 1529699798,
      "retries": 5,
      "write_timeout": 60000
    }
  ]
}
```

The next step is to set up each team's routes to the shared service. Let's say
Team A, B, and C have routes `/headers`, `/ip`, and `/user-agent`, respectively.

Putting into action, we have:

```
http POST :8001/teamA/routes paths[]=/headers service.id=86608199-e3d8-48aa-b76d-d9ec36d8d445 strip_path=false -f
{
    "created_at": 1529702016,
    "hosts": null,
    "id": "1850216b-35a2-4038-8544-34f58c7701f1",
    "methods": null,
    "paths": [
        "/headers"
    ],
    "preserve_host": false,
    "protocols": [
        "http",
        "https"
    ],
    "regex_priority": 0,
    "service": {
        "id": "86608199-e3d8-48aa-b76d-d9ec36d8d445"
    },
    "strip_path": false,
    "updated_at": 1529702016
}
```

```
http POST :8001/teamB/routes paths[]=/ip service.id=86608199-e3d8-48aa-b76d-d9ec36d8d445 strip_path=false -f
{
    "created_at": 1529702211,
    "hosts": null,
    "id": "c804699c-e492-4e33-96e1-c2398bc79986",
    "methods": null,
    "paths": [
        "/ip"
    ],
    "preserve_host": false,
    "protocols": [
        "http",
        "https"
    ],
    "regex_priority": 0,
    "service": {
        "id": "86608199-e3d8-48aa-b76d-d9ec36d8d445"
    },
    "strip_path": false,
    "updated_at": 1529702211
}
```

```
http POST :8001/teamC/routes paths[]=/user-agent service.id=86608199-e3d8-48aa-b76d-d9ec36d8d445 strip_path=false -f
{
    "created_at": 1529702339,
    "hosts": null,
    "id": "bbaac9db-52b3-46fe-bb2a-e9af2968aee9",
    "methods": null,
    "paths": [
        "/user-agent"
    ],
    "preserve_host": false,
    "protocols": [
        "http",
        "https"
    ],
    "regex_priority": 0,
    "service": {
        "id": "86608199-e3d8-48aa-b76d-d9ec36d8d445"
    },
    "strip_path": false,
    "updated_at": 1529702339
}
```

Ready - now we have all teams with their routes sharing the same service!

To make sure it's set up correctly, let's list the routes in each workspace.

```
http :8001/teamA/routes
{
  "next": null,
  "data": [
    {
      "created_at": 1529702016,
      "id": "1850216b-35a2-4038-8544-34f58c7701f1",
      "hosts": null,
      "updated_at": 1529702016,
      "preserve_host": false,
      "regex_priority": 0,
      "service": {
        "id": "86608199-e3d8-48aa-b76d-d9ec36d8d445"
      },
      "paths": [
        "/headers"
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

As we wanted, Team A has a `/headers` route pointing to the shared service.

```
http :8001/teamB/routes
{
  "next": null,
  "data": [
    {
      "created_at": 1529702211,
      "id": "c804699c-e492-4e33-96e1-c2398bc79986",
      "hosts": null,
      "updated_at": 1529702211,
      "preserve_host": false,
      "regex_priority": 0,
      "service": {
        "id": "86608199-e3d8-48aa-b76d-d9ec36d8d445"
      },
      "paths": [
        "/ip"
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

Team B has its `/ip` route.

```
http :8001/teamC/routes
{
  "next": null,
  "data": [
    {
      "created_at": 1529702339,
      "id": "bbaac9db-52b3-46fe-bb2a-e9af2968aee9",
      "hosts": null,
      "updated_at": 1529702339,
      "preserve_host": false,
      "regex_priority": 0,
      "service": {
        "id": "86608199-e3d8-48aa-b76d-d9ec36d8d445"
      },
      "paths": [
        "/user-agent"
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

and Team C has its `/user-agent` route.

With this set up, Teams A, B, and C only have access to their own Routes
entities through the Admin API. (Additionally, with RBAC's additional control,
granular read/write/delete/update rights can be further assigned to workspaces,
allowing flexible intra and inter-team permissioning schemes.)

## Important: conflicting APIs or Routes in workspaces

Workspaces provide a way to segment Kong entities - entities in a given
workspace are isolated from entities in other workspaces. That said, entities
such as APIs and Routes have "routing rules", which are pieces of info
attached to APIs or Routes - such as HTTP method, URI, or host - that allow a
given proxy-side request to be routed to its corresponding upstream service.

Admins configuring APIs (or Routes) in their workspaces do not want traffic
directed to their APIs or Routes to be swallowed by APIs or Routes in other
workspaces; Kong allows them to prevent such undesired behavior - as long as
certain measures are taken. Below we outline the conflict detection algorithm
used by Kong to determine if a conflict occurs.

* At API or Route **creation or modification** time, Kong runs its internal
router:
  - If no APIs or Routes are found with matching routing rules, the creation
  or modification proceeds
  - If APIs or Routes with matching routing rules are found **within the same
  workspace**, proceed
  - If APIs or Routes are found **in a different workspace**:
    * If the matching API or Route **does not have an associated `host` value**,
    proceed
    * If the matching API or Route **has an associated `host` value**:
      - If the `host` is a wildcard
        * If the are the same, a conflict is reported - `409 Conflict`
        * If they are not equal, proceed
      - If the `host` is an absolute value, a conflict is reported - `409 Conflict`

## Entities in different workspaces can have the same name!

Different teams - belonging to different workspaces - are allowed to give any
name to their entities. To give an example of that, let's say that Teams A, B,
and C want a special consumer named `guest` - a different consumer for each
team, sharing the same username.

```
http :8001/teamA/consumers username=guest
{
    "created_at": 1529703386000,
    "id": "2e230275-2a4a-41fd-b06b-bae37008aed2",
    "type": 0,
    "username": "guest"
}
```

```
http :8001/teamB/consumers username=guest
{
    "created_at": 1529703390000,
    "id": "8533e404-8d56-4481-a919-0ee35b8a768c",
    "type": 0,
    "username": "guest"
}
```

```
http :8001/teamC/consumers username=guest
{
    "created_at": 1529703393000,
    "id": "5fb180b0-0cd0-42e1-8d75-ce42a54b2909",
    "type": 0,
    "username": "guest"
}
```

With this, Teams A, B, and C will have the freedom to operate their `guest`
consumer independently, choosing authentication plugins, or doing any other
operation that is allowed in the non-workspaced Kong world.

Next: [RBAC Overview &rsaquo;](/docs/enterprise/{{page.kong_version}}/rbac/overview)

---

[services]: /docs/{{page.kong_version}}/admin-api/#service-object
