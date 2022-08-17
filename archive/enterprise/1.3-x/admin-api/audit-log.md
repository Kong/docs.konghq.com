---
title: Admin API Audit Log
---

## Introduction

Kong Enterprise provides a granular logging facility on its Admin API. This 
allows cluster administrators to keep detailed track of changes made to the 
cluster configuration throughout its lifetime, aiding in compliance efforts and 
providing valuable data points during forensic investigations. Generated audit 
log trails are [Workspace](/enterprise/{{page.kong_version}}/admin-api/workspaces/reference) and [RBAC](/enterprise/{{page.kong_version}}/admin-api/rbac/reference)-aware, 
providing Kong operators a deep and wide look into changes happening within 
the cluster.

[Back to TOC](#table-of-contents)

## Getting Started

Audit logging is disabled by default. It is configured via the Kong configuration (e.g. `kong.conf`):

```bash
audit_log = on # audit logging is enabled
audit_log = off # audit logging is disabled
```

or via environment variables:

```bash
$ export KONG_AUDIT_LOG=on
$ export KONG_AUDIT_LOG=off
```

As with other Kong configurations, changes take effect on `kong reload` or `kong 
restart`.

[Back to TOC](#table-of-contents)

## Request Audits

### Generating and Viewing Audit Logs

Audit logging provides granular details of each HTTP request that was handled by 
Kong's Admin API. Audit log data is written to Kong's back database. As a result, 
request audit logs are available via the Admin API (in addition to via direct 
database query). For example, consider a query to the Admin API to the `/status` 
endpoint:

```
vagrant@ubuntu-xenial:/kong$ http :8001/status
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Type: application/json; charset=utf-8
Date: Tue, 13 Nov 2018 17:32:47 GMT
Server: kong/0.34-enterprise-edition
Transfer-Encoding: chunked
X-Kong-Admin-Request-ID: ZuUfPfnxNn7D2OTU6Xi4zCnQkavzMUNM

{
    "database": {
        "reachable": true
    }, 
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
the audit log table. Querying the audit log via Admin API returns the details of the interaction above: 

```
$ http :8001/audit/requests
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Type: application/json; charset=utf-8
Date: Tue, 13 Nov 2018 17:35:24 GMT
Server: kong/0.34-enterprise-edition
Transfer-Encoding: chunked
X-Kong-Admin-Request-ID: VXgMG1Y3rZKbjrzVYlSdLNPw8asVwhET

{
    "data": [
        {
            "client_ip": "127.0.0.1",
            "method": "GET",
            "path": "/status",
            "payload": null,
            "request_id": "ZuUfPfnxNn7D2OTU6Xi4zCnQkavzMUNM",
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

Note the value of the `request_id` field. This is tied to the 
`X-Kong-Admin-Request-ID` response header received in the first transaction. 
This allows close association of client requests and audit log records within 
the Kong cluster.

Because every audit log entry is made available via Kong's Admin API, it is 
possible to transport audit log entries into existing logging warehouses, SIEM 
solutions, or other remote services for duplication and inspection.

[Back to TOC](#table-of-contents)

### Workspaces and RBAC

Audit log entries are written with an awareness of the requested Workspace, and 
the RBAC user (if present). When RBAC is enforced, the RBAC user's UUID will be 
written to the `rbac_user_id` field in the audit log entry:

```
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

Note also the presence of the `workspace` field. This is the UUID of the Workspace with which the request was associated.

[Back to TOC](#table-of-contents)

### Limiting Audit Log Generation

It may be desirable to ignore audit log generation for certain Admin API 
requests such as innocuous requests to the `/status` endpoint for 
healthchecking or to ignore requests for a given path prefix (e.g. a given 
Workspace). To this end, the `audit_log_ignore_methods` and 
`audit_log_ignore_paths` configuration options are presented:

```bash
audit_log_ignore_methods = GET,OPTIONS 
# do not generate an audit log entry for GET or OPTIONS HTTP requests
audit_log_ignore_paths = /foo,/status,^/services,/routes$,/one/.+/two,/upstreams/
# do not generate an audit log entry for requests that match the above regular expressions
```

The values of `audit_log_ignore_paths` are matched via a Perl-compatible regular expression.

For example, when `audit_log_ignore_paths = /foo,/status,^/services,/routes$,/one/.+/two,/upstreams/`, the following request paths do not generate an audit-log entry in the databse:

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

[Back to TOC](#table-of-contents)

### Audit Log Retention

Request audit records are kept in the database for a duration defined by the
`audit_log_record_ttl` [Kong configuration property](https://docs.konghq.com/enterprise/1.3-x/property-reference/#audit_log_record_ttl).
Records in the database older than `audit_log_record_ttl` seconds are automatically
purged. In Cassandra databases, record deletion is handled automatically via the
Cassandra TTL mechanism. In Postgres databases, records are purged via the stored
procedure that is executed on insert into the record database. Thus, request
audit records may exist in the database longer than the configured TTL, if no new
records are inserted to the audit table following the expiration timestamp.

[Back to TOC](#table-of-contents)

## Database Audits

### Generating and Viewing Audit Logs

In addition to Admin API request data, Kong will generate granular audit log 
entries for all insertions, updates, and deletions to the cluster database. 
Database update audit logs are also associated with Admin API request unique 
IDs. Consider the following request to create a Consumer:

```
$ http :8001/consumers username=bob
HTTP/1.1 201 Created
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Type: application/json; charset=utf-8
Date: Tue, 13 Nov 2018 17:50:18 GMT
Server: kong/0.34-enterprise-edition
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

```
$ http :8001/audit/requests
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Type: application/json; charset=utf-8
Date: Tue, 13 Nov 2018 17:52:41 GMT
Server: kong/0.34-dev-enterprise-edition
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

```
$ http :8001/audit/objects
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Type: application/json; charset=utf-8
Date: Tue, 13 Nov 2018 17:53:27 GMT
Server: kong/0.34-dev-enterprise-edition
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

[Back to TOC](#table-of-contents)

### Limiting Audit Log Generation

As with request audit logs, it may be desirable to skip generation of audit logs 
for certain database tables. This is configurable via the 
`audit_log_ignore_tables` Kong config option:

```
audit_log_ignore_tables = consumers 
# do not generate database audit logs for changes to the consumers table
```

[Back to TOC](#table-of-contents)

### Audit Log Retention

Database audit records are kept in the database for a duration defined by the
`audit_log_record_ttl` [Kong configuration property](https://docs.konghq.com/enterprise/1.3-x/property-reference/#audit_log_record_ttl).
Records in the database older than `audit_log_record_ttl` seconds are automatically
purged. In Cassandra databases, record deletion is handled automatically via the
Cassandra TTL mechanism. In Postgres databases, records are purged via the stored
procedure that is executed on insert into the record database. Thus, database
audit records may exist in the database longer than the configured TTL, if no new
records are inserted to the audit table following the expiration timestamp.

[Back to TOC](#table-of-contents)

## Digital Signatures

To provide non-repudiation, audit logs may be signed with a private RSA key. When
enabled, a lexically sorted representation of each audit log entry is signed by 
the defined private key; the signature is stored in an additional field within 
the record itself. The public key should be stored elsewhere and can be used 
later to validate the signature of the record.

### Setting Up Log Signing

Generate a private key via the `openssl` tool:

```bash
$ openssl genrsa -out private.pem 2048
```

Extract the public key for future audit verification:

```
$ openssl rsa -in private.pem -outform PEM -pubout -out public.pem
```

Configure Kong to sign audit log records:

```
audit_log_signing_key = /path/to/private.pem
```

Audit log entries will now contain a field `signature`:

```
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

[Back to TOC](#table-of-contents)

### Validating Signatures

To verify record signatures, use the `openssl` utility, or other cryptographic
tools that are capable of validating RSA digital signatures.

Signatures are generated using a 256-bit SHA digest. The following example
demonstrates how to verify the audit log record shown above. First, store the
record signature on disk after stripping the Base64
encoding:

```bash
$ cat <<EOF | base64 -d > record_signature
> l2LWYaRIHfXglFa5ehFc2j9ijfERazxisKVtJnYa+QUz2ckcytxfOLuA4VKEWHgY7cCLdn5C7uRJzE6es5V2SoOV59NOpskkr5lTt9kzao64UEw5UNOdeZYZKwyhG9Ge7IsxTK6haW0iG3a9dHqlKlwvnHZTbFM8TUV/umg8sJ1QJ/5ivXecbyHYtD5luKAI6oEgIdZPtQexRkwxlzvfR8lzeC/dDc2slSrjWRbBxNFlgfRKhDdVzVzgu8pEucgKggu67PKLkJ+bQEkxX1+Yg3czIpJyC3t6cgoggb0UNtBq1uUpswe0wdueKh6G5Gzz6XrmOjlv7zSz4gtVyEHZgg==
> EOF
```

Next, the audit record must be transformed into its canonical format used for
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
$ cat canonical_record.txt
127.0.0.1|1544724298663|GET|/status|Ka2GeB13RkRIbMwBHw0xqe2EEfY0uZG0|1542132298664|200|fd51ce6e-59c0-4b6b-b991-aa708a9ff4d2
```

<div class="alert alert-warning">
Ensure that the contents of the canonical record file on disk match the expected
canonical record format exactly. The presence of any addditional bytes, such as
a trailing newline `\n`, will cause a validation failure in the next step.
</div>

Once these two elements are in place, the signature can be verified:

```bash
$ openssl dgst -sha256 -verify public.pem -signature record_signature canonical_record.txt
Verified OK
```


[Back to TOC](#table-of-contents)

---

## Reference

### API Reference

#### List Request Audit Logs

##### Endpoint

<div class="endpoint get">/audit/requests</div>

##### Response

```
HTTP 200 OK
```

```json
{
    "data": [
        {
            "client_ip": "127.0.0.1",
            "method": "GET",
            "path": "/status",
            "payload": null,
            "request_id": "ZuUfPfnxNn7D2OTU6Xi4zCnQkavzMUNM",
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

#### List Database Audit Logs

##### Endpoint

<div class="endpoint get">/audit/objects</div>

##### Response

```
HTTP 200 OK
```

```json
{
    "data": [
        {
            "dao_name": "consumers",
            "entity": "{\"created_at\":1542131418000,\"id\":\"16787ed7-d805-434a-9cec-5e5a3e5c9e4f\",\"username\":\"bob\",\"type\":0}",
            "entity_key": "16787ed7-d805-434a-9cec-5e5a3e5c9e4f",
            "expire": 1544723418009,
            "id": "7ebabee7-2b09-445d-bc1f-2092c4ddc4be",
            "operation": "create",
            "request_id": "59fpTWlpUtHJ0qnAWBzQRHRDv7i5DwK2"
        },
  ],
  "total": 1
}
```

[Back to TOC](#table-of-contents)

### Configuration Reference

See the [Data & Admin Audit](/enterprise/{{page.kong_version}}/property-reference#data--admin-audit) 
section of Kong Enterprise's Configuration Property Reference.

[Back to TOC](#table-of-contents)
