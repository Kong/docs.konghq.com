---
title: Admin API Audit Log
---

## Introduction

Kong Enterprise provides a granular logging facility on its Admin API. This allows cluster administrators to keep detailed track of changes made to the cluster configuration throughout its lifetime, aiding in compliance efforts and providing valuable data points during forensic investigations. Generated audit log trails are [Workspace](/enterprise/{{page.kong_version}}/workspaces/overview/)- and [RBAC](/enterprise/{{page.kong_version}}/rbac/overview/)-aware, providing Kong operators a deep and wide look into changes happening within the cluster.

[Back to TOC](#table-of-contents)

## Getting Started

Audit logging is disabled by default. It is configured via the Kong configuration:

```bash
# via Kong configuration file, e.g., kong.conf
audit_log = on # audit logging is enabled
audit_log = off # audit logging is disabled
```

```bash
# or via environmental variables
$ export KONG_AUDIT_LOG=on
$ export KONG_AUDIT_LOG=off
```

As with other Kong configurations, changes take effect on kong reload or kong restart.

[Back to TOC](#table-of-contents)

## Request Audits

### Generating and Viewing Audit Logs

Audit logging provides granular details of each HTTP request that was handled by Kong's Admin API. Audit log data is written to Kong's back database. As a result, request audit logs are available via the Admin API (in addition to via direct database query). For example, consider a query to the Admin API to the `/status` endpoint:

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

The above interaction with the Admin API would generate a correlating entry in the audit log table—querying the audit log via the Admin API returns the details of of the interaction above: 

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
            "expire": 1544722367698, 
            "method": "GET", 
            "path": "/status", 
            "request_id": "ZuUfPfnxNn7D2OTU6Xi4zCnQkavzMUNM", 
            "request_timestamp": 1542130367699, 
            "status": 200, 
            "workspace": "0da4afe7-44ad-4e81-a953-5d2923ce68ae"
        }
    ], 
    "total": 1
}
```

Note the value of the `request_id` field. This is tied to the `X-Kong-Admin-Request-ID` response header received in the first transaction. This allows close association of client requests and audit log records within the Kong cluster.

Because every audit log entry is made available via Kong's Admin API, it is possible to transport audit log entries into existing logging warehouses, SIEM solutions, or other remote services for duplication and inspection.

[Back to TOC](#table-of-contents)

### Workspaces and RBAC

Audit log entries are written with an awareness of the requested Workspace, and the RBAC user (if present). When RBAC is enforced, the RBAC user's UUID will be written to the `rbac_user_id` field in the audit log entry:

```
{
    "data": [
        {
            "client_ip": "127.0.0.1", 
            "expire": 1544722999857, 
            "method": "GET", 
            "path": "/status", 
            "rbac_user_id": "2e959b45-0053-41cc-9c2c-5458d0964331", 
            "request_id": "QUtUa3RMbRLxomqcL68ilOjjl68h56xr", 
            "request_timestamp": 1542130999858, 
            "status": 200, 
            "workspace": "0da4afe7-44ad-4e81-a953-5d2923ce68ae"
        }
    ], 
    "total": 1
}
```

Note also the presence of the `workspace` field. This is the UUID of the Workspace with which the request was associated.

[Back to TOC](#table-of-contents)

### Limiting Audit Log Generation

It may be desirable to ignore audit log generation for certain Admin API requests, such as innocuous requests to the `/status` endpoint for healthchecking, or to ignore requests for a given path prefix (e.g., a given Workspace). To this end, the `audit_log_ignore_methods` and `audit_log_ignore_paths` configuration options are presented:

```bash
audit_log_ignore_methods = GET,OPTIONS # do not generate an audit log entry for GET or OPTIONS HTTP requests
audit_log_ignore_paths = /foo,/status # do not generate an audit log entry for requests that match the strings '/foo' or '/status'
```

Note that `audit_log_ignore_paths` values matched via simple string matching; regular expression or anchored searching for ignored paths is not supported at this time.

[Back to TOC](#table-of-contents)

## Database Audits

### Generating and Viewing Audit Logs

In addition to Admin API request data, Kong will generate granular audit log entries for all insertions, updates, and deletions to the cluster database. Database updates audit logs are also associated with Admin API request unique IDs. Consider the following request to create a Consumer:

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

As seen before, a request audit log is generated with details about the request. Note the presence of the `payload` field, recorded when the request body is present:

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
            "expire": 1544723418013, 
            "method": "POST", 
            "path": "/consumers", 
            "payload": "{\"username\": \"bob\"}", 
            "request_id": "59fpTWlpUtHJ0qnAWBzQRHRDv7i5DwK2", 
            "request_timestamp": 1542131418014, 
            "status": 201, 
            "workspace": "fd51ce6e-59c0-4b6b-b991-aa708a9ff4d2"
        }
    ], 
    "total": 1
}
```

Additionally, additional audit logs are generated to track the creation of the database entity:

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
            "request_id": "59fpTWlpUtHJ0qnAWBzQRHRDv7i5DwK2"
        }, 
  ],
  "total": 1
}
```

Object audit entries contain information about the entity updated, including the entity body itself, its database primary key, and the type of operation performed (`create`, `update`, or `delete`). Note also the associated `request_id` field.

[Back to TOC](#table-of-contents)

### Limiting Audit Log Generation

As with request audit logs, it may be desirable to skip generation of audit logs for certain database tables. This is configurable via the `audit_log_ignore_tables` Kong config option:

```
audit_log_ignore_tables = consumers # do not generate database audit logs for changes to the consumers table
```

[Back to TOC](#table-of-contents)

## Digital Signatures

To provide nonrepudiation, audit logs may be signed with a private RSA key. When enabled, a lexically sorted representation of each audit log entry is signed by the defined private key; the signature is stored in an additional field within the record itself. The public key should be stored elsewhere and can be used later to validate the signature of the record.

### Setting Up Log Signing

Generate a private key via the `openssl` tool:

```bash
$ openssl genrsa -out private.pem 2048
```

Configure Kong to sign audit log records:

```
audit_log_signing_key = /path/to/private.pem
```

Audit log entries will now contain a field `signature`:

```
{
    "client_ip": "127.0.0.1", 
    "expire": 1544724298663, 
    "method": "GET", 
    "path": "/status", 
    "request_id": "Ka2GeB13RkRIbMwBHw0xqe2EEfY0uZG0", 
    "request_timestamp": 1542132298664, 
    "signature": "ctD8DXJEfuFAVdlYuhay7f4kmcZhfRPjX8Q6HlSJ+67aHjJIzzrlSxWKfmxnJ7WKRvlF7bU8PX/rtu1ytLQwmzW2LpMd/WFt34PKmyOFUByslkxCdfKKNHadZ+FfINzD+JrecFdXNJrSxKKHHTxj8g6vglAcoJMmuSB6cMsAuVUbO+CL6N/WV9RfCquxxkQUfqGoyEA09EeU4uC0xa8gcYAr1FMGcu+TdRbazfBqZayrKxn8iMV/7LUefMgzUrVdC7UFjZORo5Q0wl9U/iQWU5sRGiTo/HTQmU/a7EdyX3c6Wbmg2khYJFzUIkg9JRL/YUla+yfe3AL4KwFSH90xTw==", 
    "status": 200, 
    "workspace": "fd51ce6e-59c0-4b6b-b991-aa708a9ff4d2"
}
```

[Back to TOC](#table-of-contents)

### Validating Signatures

Record signatures can be regenerated and verified by `openssl` or other cryptographic tools to confirm the validity of the signature. Re-generating the signature requires serializing the record into a string format that can be signed. The following is a canonical implementation written in Lua:

```lua
local pl_sort = require "pl.tablex".sort

local function serialize(data)
  local p = {}

  for k, v in pl_sort(data) do
    if type(v) == "table" then
      p[#p + 1] = serialize(v)
    else
      p[#p + 1] = v
    end
  end

  return p
end

table.concat(serialize(data), "|")
```

The contents of the record itself can be fed to this implementation (minus the `signature` field) in order to derive the value passed to the RSA key signing facility. Note that the `signature` field within each record is a Base-64 encoded representation of the RSA signature itself.

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
            "expire": 1544722367698,
            "method": "GET", 
            "path": "/status", 
            "request_id": "ZuUfPfnxNn7D2OTU6Xi4zCnQkavzMUNM",
            "request_timestamp": 1542130367699,
            "status": 200, 
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
