---
title: Workspace Examples
book: workspaces
---

## Introduction

This chapter aims to provide a step-by-step tutorial on how to set up
workspaces, entities, and see it in action.

## Important Note: Conflicting Services or Routes in workspaces

Workspaces provide a way to segment Kong entities—entities in a workspace
are isolated from those in other workspaces. That said, entities
such as Services and Routes have "routing rules", which are pieces of info
attached to Services or Routes—such as HTTP method, URI, or host—that allow a
given proxy-side request to be routed to its corresponding upstream service.

Admins configuring Services (or Routes) in their workspaces do not want traffic
directed to their Services or Routes to be swallowed by Services or Routes in other
workspaces; Kong allows them to prevent such undesired behavior—as long as
certain measures are taken. Below we outline the conflict detection algorithm
used by Kong to determine if a conflict occurs.

* At Service or Route **creation or modification** time, Kong runs its internal
router:
  - If no Services or Routes are found with matching routing rules, the creation
  or modification proceeds
  - If Services or Routes with matching routing rules are found **within the same
  workspace**, proceed
  - If Services or Routes are found **in a different workspace**:
    * If the matching Service or Route **does not have an associated
      `host` value**—`409 Conflict`
    * If the matching Service or Route's `host` is a wildcard
      - If they are the same, a conflict is reported—`409 Conflict`
      - If they are not equal, proceed
    * If the matching Service or Route's `host` is an absolute value, a
      conflict is reported—`409 Conflict`

## The Default workspace

Kong creates a default workspace—unsurprisingly named `default`—whose goal
is to group all existing entities in Kong, where "existing entities" refers to:

- Entities that were created in operation in previous versions &amp; in case
one is migrating from an older Kong version;
- Entities that Kong creates at migration time—e.g., RBAC credentials, which
are provisioned at migration time as a convenience

It will also hold entities that are created without being explicitly assigned to
a specific workspace.

That said, it's worth noting that the default workspace is a workspace as any
other, the only difference being that it's created by Kong, at migration time.

(Examples will be shown using the httpie HTTP command line client.)

## Listing workspaces and its entities

In a fresh Kong Enterprise install—or one just migrated to 0.33—submit the
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

## Creating a workspace

A more interesting example would be segmenting entities by teams; for the sake of
example, let's say they are teamA, teamB, and teamC.

Each of these teams has its own set of entities—say, upstream services and
routes—and want to segregate their configurations and traffic; they can
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

At this point, if we list workspaces, we will get a total of 4—remember,
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

## Entities in different workspaces can have the same name!

Different teams—belonging to different workspaces—are allowed to give any
name to their entities. To provide an example of that, let's say that Teams A, B,
and C want a particular consumer named `guest`—a different consumer for each
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
consumer independently, choosing authentication plugins or doing any other
operation that is allowed in the non-workspaced Kong world.


---

[services]: /enterprise/{{page.kong_version}}/admin-api/#service-object
