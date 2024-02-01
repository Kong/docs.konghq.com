---
title: Audit Logging in Kong Gateway
badge: enterprise
---

{{site.base_gateway}} provides a granular logging facility through its Admin API. This
allows cluster administrators to keep detailed track of changes made to the
cluster configuration throughout its lifetime, aiding in compliance efforts and
providing valuable data points during forensic investigations. Generated audit
log trails are [Workspace](/gateway/{{page.release}}/admin-api/workspaces/reference/) and [RBAC](/gateway/{{page.release}}/admin-api/rbac/reference/)-aware,
providing Kong operators a deep and wide look into changes happening within
the cluster.

## Enable audit logging
Audit logging is disabled by default. Configure it through {{site.base_gateway}} configuration in `kong.conf`:

```bash
audit_log = on # audit logging is enabled
audit_log = off # audit logging is disabled
```

or via environment variables:

```bash
export KONG_AUDIT_LOG=on
export KONG_AUDIT_LOG=off
```

As with other Kong configurations, changes take effect on `kong reload` or `kong
restart`.

## Request audits

### Generating and viewing audit logs

Audit logging provides granular details of each HTTP request that was handled by
Kong's Admin API. Audit log data is written to Kong's database. As a result,
request audit logs are available via the Admin API (in addition to via direct
database query). 

For example, consider a query to the Admin API to the `/status`
endpoint:

```sh
curl -i -X GET http://localhost:8001/status
```

You get the following response:

```sh
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Type: application/json; charset=utf-8
Date: Tue, 13 Nov 2018 17:32:47 GMT
Server: kong/ kong/{{page.versions.ee}}-enterprise-edition
Transfer-Encoding: chunked
X-Kong-Admin-Request-ID: ZuUfPfnxNn7D2OTU6Xi4zCnQkavzMUNM

{
    "database": {
        "reachable": true
    },
    
    "memory": {
        "lua_shared_dicts": {
            ...
        },
         "workers_lua_vms": [
            ...
         ]
    }

    "server": {
        "connections_accepted": 1,
        "connections_active": 1,
        "connections_handled": 1,
        "connections_reading": 0,
        "connections_waiting": 0,
        "connections_writing": 1,
        "total_requests": 1
    }
}
```

The above interaction with the Admin API generates a correlating entry in
the audit log table. Querying the audit log via the Admin API returns the details of the previous interaction:

```sh
curl -i -X GET http://localhost:8001/audit/requests
```

{% if_version lte:3.1.x %}
```sh
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Type: application/json; charset=utf-8
Date: Tue, 13 Nov 2018 17:35:24 GMT
Server: kong/{{page.versions.ee}}-enterprise-edition
Transfer-Encoding: chunked
X-Kong-Admin-Request-ID: VXgMG1Y3rZKbjrzVYlSdLNPw8asVwhET

{
    "data": [
        {
            "client_ip": "127.0.0.1",
            "method": "GET",
            "path": "/status",
            "payload": null,
            "rbac_user_id": null,
            "removed_from_payload": null,
            "request_id": "OjOcUBvt6q6XJlX3dd6BSpy1uUkTyctC",
            "request_timestamp": 1676424547,
            "signature": null,
            "status": 200,
            "ttl": 2591997,
            "workspace": "1065b6d6-219f-4002-b3e9-334fc3eff46c"
        }
    ],
    "total": 1
}
```
{% endif_version %}

{% if_version gte:3.2.x %}
```sh
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Type: application/json; charset=utf-8
Date: Tue, 13 Nov 2018 17:35:24 GMT
Server: kong/{{page.versions.ee}}-enterprise-edition
Transfer-Encoding: chunked
X-Kong-Admin-Request-ID: VXgMG1Y3rZKbjrzVYlSdLNPw8asVwhET

{
    "data": [
        {
            "client_ip": "127.0.0.1",
            "method": "GET",
            "path": "/status",
            "payload": null,
            "rbac_user_id": null,
            "rbac_user_name": null,
            "removed_from_payload": null,
            "request_id": "OjOcUBvt6q6XJlX3dd6BSpy1uUkTyctC",
            "request_source": null,
            "request_timestamp": 1676424547,
            "signature": null,
            "status": 200,
            "ttl": 2591997,
            "workspace": "1065b6d6-219f-4002-b3e9-334fc3eff46c"
        }
    ],
    "total": 1
}
```
{% endif_version %}

Note the value of the `request_id` field. This is tied to the
`X-Kong-Admin-Request-ID` response header received in the first transaction.
This allows close association of client requests and audit log records within
the Kong cluster.

Because every audit log entry is made available via Kong's Admin API, it is
possible to transport audit log entries into existing logging warehouses, SIEM
solutions, or other remote services for duplication and inspection.

### Workspaces and RBAC

Audit log entries are written with an awareness of the requested workspace, and
the RBAC user (if present). When RBAC is enforced, the RBAC user's UUID will be
written to the `rbac_user_id` field in the audit log entry, and the username 
will be written to the `rbac_user_name` field:

{% if_version lte:3.1.x %}
```json
{
    "data": [
        {
            "client_ip": "127.0.0.1",
            "method": "GET",
            "path": "/status",
            "payload": null,
            "rbac_user_id": "2e959b45-0053-41cc-9c2c-5458d0964331",
            "request_id": "QUtUa3RMbRLxomqcL68ilOjjl68h56xr",
            "request_timestamp": 1581617463,
            "signature": null,
            "status": 200,
            "ttl": 2591995,
            "workspace": "0da4afe7-44ad-4e81-a953-5d2923ce68ae"
        }
    ],
    "total": 1
}
```
{% endif_version %}

{% if_version gte:3.2.x %}
```json
{
    "data": [
        {
            "client_ip": "127.0.0.1",
            "method": "GET",
            "path": "/status",
            "payload": null,
            "rbac_user_id": "2e959b45-0053-41cc-9c2c-5458d0964331",
            "rbac_user_name": "admin",
            "request_id": "QUtUa3RMbRLxomqcL68ilOjjl68h56xr",
            "request_source": "kong-manager",
            "request_timestamp": 1581617463,
            "signature": null,
            "status": 200,
            "ttl": 2591995,
            "workspace": "0da4afe7-44ad-4e81-a953-5d2923ce68ae"
        }
    ],
    "total": 1
}
```
{% endif_version %}

Note the presence of the `workspace` field. This is the UUID of the workspace with which the request is associated.

{% if_version gte:3.2.x %}

### Kong Manager authentication

You can track login and logout events for the Kong Manager through 
the `path`, `method`, and `request_source` audit log fields.

For example, review the following audit log entry:


```json
{
    "data": [
        {
            "client_ip": "127.0.0.1",
            "method": "GET",
            "path": "/auth",
            "payload": null,
            "rbac_user_id": "2e959b45-0053-41cc-9c2c-5458d0964331",
            "rbac_user_name": "admin",
            "request_id": "QUtUa3RMbRLxomqcL68ilOjjl68h56xr",
            "request_source": "kong-manager",
            "request_timestamp": 1581617463,
            "signature": null,
            "status": 200,
            "ttl": 2591995,
            "workspace": "0da4afe7-44ad-4e81-a953-5d2923ce68ae"
        }
    ],
    "total": 1
}
```

The `request_source` field tells you that the action occurred in Kong Manager.

The `method` and `path` fields correspond either to a login or logout event:
* Login event: `"method": "GET"`, `"path": "/auth"`
* Logout event: `"method": "DELETE"`, `"path": "/auth?session_logout=true"`

{% endif_version %}

### Limiting audit log generation

You may want to ignore audit log generation for certain Admin API
requests, such as requests to the `/status` endpoint for
health checking, or to ignore requests to a specific path prefix, for example, a given workspace.

Use the `audit_log_ignore_methods` and
`audit_log_ignore_paths` configuration options:

```bash
audit_log_ignore_methods = GET,OPTIONS
# do not generate an audit log entry for GET or OPTIONS HTTP requests
audit_log_ignore_paths = /foo,/status,^/services,/routes$,/one/.+/two,/upstreams/
# do not generate an audit log entry for requests that match the above regular expressions
```

The values of `audit_log_ignore_paths` are matched via a Perl-compatible regular expression.

For example, when `audit_log_ignore_paths = /foo,/status,^/services,/routes$,/one/.+/two,/upstreams/`, 
the following request paths do not generate an audit log entry in the database:

- `/status`
- `/status/`
- `/foo`
- `/foo/`
- `/services`
- `/services/example/`
- `/one/services/two`
- `/one/test/two`
- `/routes`
- `/plugins/routes`
- `/one/routes/two`
- `/upstreams/`
- `bad400request`

The following request paths generate an audit log entry in the database:

- `/example/services`
- `/routes/plugins`
- `/one/two`
- `/routes/`
- `/upstreams`

## Database audits

### Generating and viewing audit logs

In addition to Admin API request data, Kong can generate granular audit log
entries for all insertions, updates, and deletions to the cluster database.
Database update audit logs are also associated with Admin API request unique
IDs. Consider the following request to create a consumer:

```sh
curl -i -X POST http://localhost:8001/consumers username=bob
```

Response:
```sh
HTTP/1.1 201 Created
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Type: application/json; charset=utf-8
Date: Tue, 13 Nov 2018 17:50:18 GMT
Server: kong/{{page.versions.ee}}-enterprise-edition
Transfer-Encoding: chunked
X-Kong-Admin-Request-ID: 59fpTWlpUtHJ0qnAWBzQRHRDv7i5DwK2

{
    "created_at": 1542131418000,
    "id": "16787ed7-d805-434a-9cec-5e5a3e5c9e4f",
    "type": 0,
    "username": "bob"
}

```

As seen before, a request audit log is generated with details about the request.
Note the presence of the `payload` field, recorded when the request body is
present:

```sh
curl -i -X GET http://localhost:8001/audit/requests
```

```sh
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Type: application/json; charset=utf-8
Date: Tue, 13 Nov 2018 17:52:41 GMT
Server: kong/{{page.versions.ee}}-dev-enterprise-edition
Transfer-Encoding: chunked
X-Kong-Admin-Request-ID: SpPaxLTkDNndzKaYiWuZl3xrxDUIiGRR

{
    "data": [
        {
            "client_ip": "127.0.0.1",
            "method": "POST",
            "path": "/consumers",
            "payload": "{\"username\": \"bob\"}",
            "request_id": "59fpTWlpUtHJ0qnAWBzQRHRDv7i5DwK2",
            "request_timestamp": 1581617463,
            "signature": null,
            "status": 201,
            "ttl": 2591995,
            "workspace": "fd51ce6e-59c0-4b6b-b991-aa708a9ff4d2"
        }
    ],
    "total": 1
}
```

Additionally, audit logs are generated to track the creation of the
database entity:

```sh
curl -i -X GET http://localhost:8001/audit/objects
```

Response:
```sh
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Type: application/json; charset=utf-8
Date: Tue, 13 Nov 2018 17:53:27 GMT
Server: kong/{{page.versions.ee}}-dev-enterprise-edition
Transfer-Encoding: chunked
X-Kong-Admin-Request-ID: ZKra3QT0d3eJKl96jOUXYueLumo0ck8c

{
    "data": [
        {
            "dao_name": "consumers",
            "entity": "{\"created_at\":1542131418000,\"id\":\"16787ed7-d805-434a-9cec-5e5a3e5c9e4f\",\"username\":\"bob\",\"type\":0}",
            "entity_key": "16787ed7-d805-434a-9cec-5e5a3e5c9e4f",
            "expire": 1544723418009,
            "id": "7ebabee7-2b09-445d-bc1f-2092c4ddc4be",
            "operation": "create",
            "request_id": "59fpTWlpUtHJ0qnAWBzQRHRDv7i5DwK2",
            "request_timestamp": 1581617463,
        },
  ],
  "total": 1
}
```

Object audit entries contain information about the entity updated, including the
entity body itself, its database primary key, and the type of operation
performed (`create`, `update`, or `delete`). Note also the associated
 `request_id` field.

### Limiting audit log generation

As with request audit logs, you may want to skip generation of audit logs
for certain database tables. This is configurable via the
`audit_log_ignore_tables` Kong config option:

```
audit_log_ignore_tables = consumers
# do not generate database audit logs for changes to the consumers table
```

## Audit log retention

Audit log records are kept in the database for a duration defined by the
[`audit_log_record_ttl`](/gateway/{{page.release}}/reference/configuration/#audit_log_record_ttl)
Kong configuration property. Records in the database older than `audit_log_record_ttl` 
seconds are automatically purged.

{% if_version lte:3.3.x %}
PostgreSQL and Cassandra handle record deletion in different ways:
* In Cassandra databases, record deletion is handled automatically via the
Cassandra TTL mechanism. 
* In PostgreSQL databases, records are purged via the stored
procedure that is executed on insert into the record database. 
{% endif_version %}

{% if_version gte:3.4.x %}
PostgreSQL purges records via the stored procedure that is executed on insert into the 
record database.
{% endif_version %}
Therefore, request audit records may exist in the database longer than the configured TTL, 
if no new records are inserted to the audit table following the expiration timestamp.

## Digital signatures

To provide non-repudiation, audit logs may be signed with a private RSA key. When
enabled, a lexically sorted representation of each audit log entry is signed by
the defined private key; the signature is stored in an additional field within
the record itself. The public key should be stored elsewhere and can be used
later to validate the signature of the record.

### Setting up log signing

1. Generate a private key via the `openssl` tool:

    ```sh
    openssl genrsa -out private.pem 2048
    ```

1. Extract the public key for future audit verification:

    ```sh
    openssl rsa -in private.pem -outform PEM -pubout -out public.pem
    ```

1. Configure Kong to sign audit log records:

    ```
    audit_log_signing_key = /path/to/private.pem
    ```

1. Audit log entries will now contain the field `signature`:

    {% if_version lte:3.1.x %}
    ```json
    {
        "client_ip": "127.0.0.1",
        "method": "GET",
        "path": "/status",
        "payload": null,
        "request_id": "Ka2GeB13RkRIbMwBHw0xqe2EEfY0uZG0",
        "request_timestamp": 1581617463,
        "signature": "l2LWYaRIHfXglFa5ehFc2j9ijfERazxisKVtJnYa+QUz2ckcytxfOLuA4VKEWHgY7cCLdn5C7uRJzE6es5V2SoOV59NOpskkr5lTt9kzao64UEw5UNOdeZYZKwyhG9Ge7IsxTK6haW0iG3a9dHqlKlwvnHZTbFM8TUV/umg8sJ1QJ/5ivXecbyHYtD5luKAI6oEgIdZPtQexRkwxlzvfR8lzeC/dDc2slSrjWRbBxNFlgfRKhDdVzVzgu8pEucgKggu67PKLkJ+bQEkxX1+Yg3czIpJyC3t6cgoggb0UNtBq1uUpswe0wdueKh6G5Gzz6XrmOjlv7zSz4gtVyEHZgg==",
        "status": 200,
        "ttl": 2591995,
        "workspace": "fd51ce6e-59c0-4b6b-b991-aa708a9ff4d2"
    }
    ```
    {% endif_version %}

    {% if_version gte:3.2.x %}
    ```json
    {
        "client_ip": "127.0.0.1",
        "method": "GET",
        "path": "/status",
        "payload": null,
        "rbac_user_id": "2e959b45-0053-41cc-9c2c-5458d0964331",
        "rbac_user_name": null,
        "request_id": "Ka2GeB13RkRIbMwBHw0xqe2EEfY0uZG0",
        "request_source": null,
        "request_timestamp": 1581617463,
        "signature": "l2LWYaRIHfXglFa5ehFc2j9ijfERazxisKVtJnYa+QUz2ckcytxfOLuA4VKEWHgY7cCLdn5C7uRJzE6es5V2SoOV59NOpskkr5lTt9kzao64UEw5UNOdeZYZKwyhG9Ge7IsxTK6haW0iG3a9dHqlKlwvnHZTbFM8TUV/umg8sJ1QJ/5ivXecbyHYtD5luKAI6oEgIdZPtQexRkwxlzvfR8lzeC/dDc2slSrjWRbBxNFlgfRKhDdVzVzgu8pEucgKggu67PKLkJ+bQEkxX1+Yg3czIpJyC3t6cgoggb0UNtBq1uUpswe0wdueKh6G5Gzz6XrmOjlv7zSz4gtVyEHZgg==",
        "status": 200,
        "ttl": 2591995,
        "workspace": "fd51ce6e-59c0-4b6b-b991-aa708a9ff4d2"
    }
    ```
    {% endif_version %}

### Validating signatures

To verify record signatures, use the `openssl` utility, or other cryptographic
tools that are capable of validating RSA digital signatures.

Signatures are generated using a 256-bit SHA digest. The following example
demonstrates how to verify the audit log record shown above. 

1. First, store the
record signature on disk after stripping the Base64
encoding:

    ```bash
    cat <<EOF | base64 -d > record_signature
    > l2LWYaRIHfXglFa5ehFc2j9ijfERazxisKVtJnYa+QUz2ckcytxfOLuA4VKEWHgY7cCLdn5C7uRJzE6es5V2SoOV59NOpskkr5lTt9kzao64UEw5UNOdeZYZKwyhG9Ge7IsxTK6haW0iG3a9dHqlKlwvnHZTbFM8TUV/umg8sJ1QJ/5ivXecbyHYtD5luKAI6oEgIdZPtQexRkwxlzvfR8lzeC/dDc2slSrjWRbBxNFlgfRKhDdVzVzgu8pEucgKggu67PKLkJ+bQEkxX1+Yg3czIpJyC3t6cgoggb0UNtBq1uUpswe0wdueKh6G5Gzz6XrmOjlv7zSz4gtVyEHZgg==
    > EOF
    ```

1. Next, the audit record must be transformed into its canonical format used for
signature generation. This transformation requires serializing the record into
a string format that can be verified. The format is a lexically-sorted,
pipe-delimited string of each audit log record part, _without_ the `signature`,
`ttl`, or `expire` fields. The following is a canonical
implementation written in Lua:

    ```lua
    local cjson = require "cjson"
    local pl_sort = require "pl.tablex".sort

    local function serialize(data)
    local p = {}

    data.signature = nil
    data.expire = nil
    data.ttl = nil

    for k, v in pl_sort(data) do
        if type(v) == "table" then
        p[#p + 1] = serialize(v)
        elseif v ~= cjson.null then
        p[#p + 1] = v
        end
    end

    return p
    end

    table.concat(serialize(data), "|")
    ```

    For example, the canonical format of the audit record above is:

    ```
    cat canonical_record.txt
    127.0.0.1|1544724298663|GET|/status|Ka2GeB13RkRIbMwBHw0xqe2EEfY0uZG0|1542132298664|200|fd51ce6e-59c0-4b6b-b991-aa708a9ff4d2
    ```

    {:.important}
    > Ensure that the contents of the canonical record file on disk match the expected
    canonical record format exactly. The presence of any additional bytes, such as
    a trailing newline `\n`, will cause a validation failure in the next step.

1. Once these two elements are in place, the signature can be verified:

    ```bash
    openssl dgst -sha256 -verify public.pem -signature record_signature canonical_record.txt
    Verified OK
    ```

## More information

* For {{site.base_gateway}} `kong.conf` options, 
see the [Data & Admin Audit](/gateway/{{page.release}}/reference/configuration/#data--admin-audit-section)
section of the Configuration Property Reference.
* For the `/audit` API reference, see [Audit Logs](/gateway/{{page.release}}/admin-api/audit-logs/).
