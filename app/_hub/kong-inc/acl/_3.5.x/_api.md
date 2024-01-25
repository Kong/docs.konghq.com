---
nav_title: Using the ACLs API
---

## Using the ACLs API

The ACL plugin exposes endpoints for configuring ACLs.

To configure and enable the plugin itself, [use the `/plugins` API endpoint](/hub/kong-inc/acl/how-to/basic-example/).
The `/acls` endpoints only appear once the plugin has been enabled. 

### Return ACLs

Retrieves paginated ACLs.

```bash
curl -X GET http://localhost:8001/acls
```

Result:
```json
{
    "total": 3,
    "data": [
        {
            "group": "foo-group",
            "created_at": 1511391159000,
            "id": "724d1be7-c39e-443d-bf36-41db17452c75",
            "consumer": { "id": "89a41fef-3b40-4bb0-b5af-33da57a7ffcf" }
        },
        {
            "group": "bar-group",
            "created_at": 1511391162000,
            "id": "0905f68e-fee3-4ecb-965c-fcf6912bf29e",
            "consumer": { "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880" }
        },
        {
            "group": "baz-group",
            "created_at": 1509814006000,
            "id": "ff883d4b-aee7-45a8-a17b-8c074ba173bd",
            "consumer": { "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880" }
        }
    ]
}
```

#### Retrieve ACLs by consumer

Retrieves ACLs by consumer.

```bash
curl -X GET http://localhost:8001/consumers/{CONSUMER}/acls
```

Result:
```json
{
    "total": 1,
    "data": [
        {
            "group": "bar-group",
            "created_at": 1511391162000,
            "id": "0905f68e-fee3-4ecb-965c-fcf6912bf29e",
            "consumer": { "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880" }
        }
    ]
}
```

`CONSUMER`: The `username` or `id` of the consumer.

### Retrieve ACL by ID

Retrieves ACL by ID if the ACL belongs to the specified consumer.

```bash
curl -X GET http://localhost:8001/consumers/{CONSUMER}/acls/{ID}
```

Result:
```json
{
    "group": "foo-group",
    "created_at": 1511391159000,
    "id": "724d1be7-c39e-443d-bf36-41db17452c75",
    "consumer": { "id": "89a41fef-3b40-4bb0-b5af-33da57a7ffcf" }
}
```

`CONSUMER`: The `username` property of the consumer entity.

`ID`: The `id` property of the ACL.  

#### Retrieve the consumer associated with an ACL

Retrieves a consumer associated with an ACL
using the following request:

```bash
curl -X GET http://localhost:8001/acls/{ID}/consumer
```

Result:
```json
{
   "created_at":1507936639000,
   "username":"foo",
   "id":"c0d92ba9-8306-482a-b60d-0cfdd2f0e880"
}
```

`ID`: The `id` property of the ACL.

#### Update and insert an ACL group name

Update and insert the group name of the ACL by passing a new group name.

```bash
curl -X PUT http://localhost:8001/consumers/{CONSUMER}/acls/{ID}
  --data "group=newgroupname"
```

`CONSUMER`: The `username` property of the consumer entity.

`ID`: The `id` property of the ACL.  

### Update an ACL group by ID

Updates an ACL group name by passing a new group name.

```bash
curl -X POST http://localhost:8001/consumers/{CONSUMER}/acls \
    --data "group=group1"
```

`CONSUMER`: The `username` property of the consumer entity.

#### Remove an ACL group for a consumer

Deletes an ACL group by ID or group name.

```bash
curl -X DELETE http://localhost:8001/consumers/{CONSUMER}/acls/{ID}
```

`ID`: The `id` property of the ACL.  

Deletes an ACL group by group name.

```bash
curl -X DELETE http://localhost:8001/consumers/{CONSUMER}/acls/{GROUP}
```

`GROUP`: The `group` property of the ACL.  

A successful DELETE request returns a `204` status.