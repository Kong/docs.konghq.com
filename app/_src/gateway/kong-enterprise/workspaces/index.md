---
title: Workspace Examples
badge: enterprise
---

Workspaces provide a way to segment Kong entities. Entities in a workspace
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
  or modification proceeds.
  - If Services or Routes with matching routing rules are found **within the same
  workspace**, the action proceeds.
  - If Services or Routes are found **in a different workspace**:
    * If the matching Service or Route **does not have an associated
      `host` value**—`409 Conflict`
    * If the matching Service or Route's `host` is a wildcard
      - If they are the same, the action fails with a `409 Conflict`
      - If they are not equal, the action proceeds.
    * If the matching Service or Route's `host` is an absolute value, a
      conflict is reported—`409 Conflict`

Some entities are **global** entities, which means they don't belong to any workspace.
In particular, CA certificates (`ca_certificates` entity) are global and are used to verify the client
certificates in mTLS handshakes. The SSL handshake takes place before receiving
an HTTP request when the workspace is unknown.

Some entities reside in a workspace but contain fields that should be unique
across workspaces to avoid conflict:
*  The `name` field of the `snis` entity should be unique across workspaces because it is used in the
SSL handshaking phase before the workspace is determined.
* The `prefix` field of the `vaults` entity is the host part of the
vault reference URI which may be used in a context where no workspace information
is available, for example, when loading the `kong.conf` during Kong startup.

## The default workspace

Kong starts with a default workspace named `default`. This workspace
groups all existing entities in Kong:

- Entities that were created in operation in previous versions &amp; in case
one is migrating from an older Kong version;
- Entities that Kong creates at migration time—e.g., RBAC credentials, which
are provisioned at migration time as a convenience

It will also hold entities that are created without being explicitly assigned to
a specific workspace.

That said, it's worth noting that the default workspace is a workspace as any
other, the only difference being that it's created by Kong, at migration time.

## Using the API in workspaces

{% include_cached /md/gateway/admin-api-workspaces.md %}

## Listing workspaces and its entities

In a fresh {{site.base_gateway}} install, submit the
following request:

```sh
curl -i -X GET http://localhost:8001/workspaces
```

Response:
```json
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
example, let's say they are teamA and teamB.

Each of these teams has its own set of entities—say, upstream services and
routes—and want to segregate their configurations and traffic; they can
achieve that with workspaces.


1. Create teamA:

    ```sh
    curl -i -X POST http://localhost:8001/workspaces \
      --data name=teamA
    ```

    Response:
    ```json
    {
        "created_at": 1528843468000,
        "id": "735af96e-206f-43f7-88f0-b930d5fd4b7e",
        "name": "teamA"
    }
    ```

1. Create teamB:

    ```sh
    curl -i -X POST http://localhost:8001/workspaces \
      --data name=teamB
    ```

    Response:
    ```json
    {
      "name": "teamB",
      "created_at": 1529628574000,
      "id": "a25728ac-6036-497c-82ee-524d4c22fcae"
    }
    ```

1. At this point, if you list workspaces, you get a total of three: 
the default workspace and the two team workspaces.

    ```json
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
        }
      ]
      "total": 3,
    }

    ```

## Use the same name with different workspaces

Different teams—belonging to different workspaces—are allowed to give any
name to their entities. To provide an example of that, let's say that Teams A and
B want a particular consumer named `guest`—a different consumer for each
team, sharing the same username.

1. Create a consumer named `guest` in teamA:

    ```sh
    curl -i -X POST http://localhost:8001/teamA/consumers \
      --data username=guest
    ```

    Response:
    ```json
    {
        "created_at": 1529703386000,
        "id": "2e230275-2a4a-41fd-b06b-bae37008aed2",
        "type": 0,
        "username": "guest"
    }
    ```


1. Create a consumer named `guest` in teamB:
    ```sh
    curl -i -X POST http://localhost:8001/teamB/consumers \
      --data username=guest
    ```

    Response:
    ```json
    {
        "created_at": 1529703390000,
        "id": "8533e404-8d56-4481-a919-0ee35b8a768c",
        "type": 0,
        "username": "guest"
    }
    ```

With this, Teams A and B will have the freedom to operate their `guest`
consumer independently, choosing authentication plugins or doing any other
operation that is allowed in the non-workspaced Kong world.

## See also

* [Workspaces API reference](/gateway/api/admin-ee/latest/#/Workspaces)

---

[services]: /gateway/{{page.release}}/admin-api/#service-object
