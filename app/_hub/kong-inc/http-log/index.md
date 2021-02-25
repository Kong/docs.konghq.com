---
name: HTTP Log
publisher: Kong Inc.
version: 2.0.x

desc: Send request and response logs to an HTTP server
description: |
  Send request and response logs to an HTTP server.

type: plugin
categories:
  - logging

kong_version_compatibility:
    community_edition:
      compatible:
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 2.0.x
        - 1.5.x
        - 1.4.x
        - 1.3.x
        - 1.2.x
        - 1.1.x
        - 1.0.x
        - 0.14.x
        - 0.13.x
        - 0.12.x
        - 0.11.x
        - 0.10.x
        - 0.9.x
        - 0.8.x
        - 0.7.x
        - 0.6.x
        - 0.5.x
        - 0.4.x
        - 0.3.x
    enterprise_edition:
      compatible:
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 1.5.x
        - 1.3-x
        - 0.36-x

params:
  name: http-log
  service_id: true
  route_id: true
  consumer_id: true
  protocols: ["http", "https", "grpc", "grpcs", "tcp", "tls", "udp"]
  dbless_compatible: yes
  config:
    - name: http_endpoint
      required: true
      default:
      value_in_examples: http://mockbin.org/bin/:id
      datatype: string
      description: The HTTP URL endpoint (including the protocol to use) to which the data is sent.
    - name: method
      required: false
      default: "`POST`"
      value_in_examples: POST
      datatype: string
      description: |
        An optional method used to send data to the HTTP server. Supported values are
        `POST` (default), `PUT`, and `PATCH`.
    - name: content_type
      required: false
      default: "`application/json`"
      value_in_examples:
      datatype: string
      description: |
      REVIEWERS need description. The only available option is `application/json`.
    - name: timeout
      required: false
      default: "`10000`"
      value_in_examples: 1000
      datatype: number
      description: An optional timeout in milliseconds when sending data to the upstream server.
    - name: keepalive
      required: false
      default: "`60000`"
      value_in_examples: 1000
      datatype: number
      description: An optional value in milliseconds that defines how long an idle connection will live before being closed.
    - name: flush_timeout
      required: false
      default: "`2`"
      value_in_examples: 2
      datatype: number
      description: |  
        Optional time in seconds. If `queue_size` > 1, this is the max idle time before sending a log with less than `queue_size` records.    
    - name: retry_count
      required: false
      default: 10
      value_in_examples: 15
      datatype: integer
      description: Number of times to retry when sending data to the upstream server.
    - name: queue_size
      required: false
      default: 1
      datatype: integer
      description: Max number of log entries to be sent on each message to the upstream server.
    - name: headers
      required: false
      default: empty table
      datatype: array of string elements
      description: An optional table of headers added to the HTTP message to the upstream server.
  extra: |
    **NOTE:** If the `config.http_endpoint` contains a username and password (for example,
    `http://bob:password@example.com/logs`), then Kong Gateway automatically includes
    a basic-auth `Authorization` header in the log requests.

---

## Log Format

Every request is logged separately in a JSON object (or array of JSON objects if
`queue_size` argument > 1) in the following format:

```json
{
    "request": {
        "method": "GET",
        "uri": "/get",
        "url": "http://httpbin.org:8000/get",
        "size": "75",
        "querystring": {},
        "headers": {
            "accept": "*/*",
            "host": "httpbin.org",
            "user-agent": "curl/7.37.1"
        },
        "tls": {
            "version": "TLSv1.2",
            "cipher": "ECDHE-RSA-AES256-GCM-SHA384",
            "supported_client_ciphers": "ECDHE-RSA-AES256-GCM-SHA384",
            "client_verify": "NONE"
        }
    },
    "upstream_uri": "/",
    "response": {
        "status": 200,
        "size": "434",
        "headers": {
            "Content-Length": "197",
            "via": "kong/0.3.0",
            "Connection": "close",
            "access-control-allow-credentials": "true",
            "Content-Type": "application/json",
            "server": "nginx",
            "access-control-allow-origin": "*"
        }
    },
    "tries": [
        {
            "state": "next",
            "code": 502,
            "ip": "127.0.0.1",
            "port": 8000
        },
        {
            "ip": "127.0.0.1",
            "port": 8000
        }
    ],
    "authenticated_entity": {
        "consumer_id": "80f74eef-31b8-45d5-c525-ae532297ea8e",
        "id": "eaa330c0-4cff-47f5-c79e-b2e4f355207e"
    },
    "route": {
        "created_at": 1521555129,
        "hosts": null,
        "id": "75818c5f-202d-4b82-a553-6a46e7c9a19e",
        "methods": null,
        "paths": [
            "/example-path"
        ],
        "preserve_host": false,
        "protocols": [
            "http",
            "https"
        ],
        "regex_priority": 0,
        "service": {
            "id": "0590139e-7481-466c-bcdf-929adcaaf804"
        },
        "strip_path": true,
        "updated_at": 1521555129
    },
    "service": {
        "connect_timeout": 60000,
        "created_at": 1521554518,
        "host": "example.com",
        "id": "0590139e-7481-466c-bcdf-929adcaaf804",
        "name": "myservice",
        "path": "/",
        "port": 80,
        "protocol": "http",
        "read_timeout": 60000,
        "retries": 5,
        "updated_at": 1521554518,
        "write_timeout": 60000
    },
    "workspaces": [
        {
            "id":"b7cac81a-05dc-41f5-b6dc-b87e29b6c3a3",
            "name": "default"
        }
    ],
    "consumer": {
        "username": "demo",
        "created_at": 1491847011000,
        "id": "35b03bfc-7a5b-4a23-a594-aa350c585fa8"
    },
    "latencies": {
        "proxy": 1430,
        "kong": 9,
        "request": 1921
    },
    "client_ip": "127.0.0.1",
    "started_at": 1433209822425
}
```

A few considerations on the above JSON object:

* `request` contains properties about the request sent by the client.
* `response` contains properties about the response sent to the client.
* `tries` contains the list of tries and retries (successes and failures) made by the load balancer for the request.
* `route` contains {{site.base_gateway}} properties about the specific Route requested.
* `service` contains {{site.base_gateway}} properties about the Service associated with the requested Route.
* `authenticated_entity` contains {{site.base_gateway}} properties about the authenticated credential if an authentication plugin has been enabled.
* `workspaces` contains {{site.ee_gateway_name}} properties of the Workspaces associated with the requested Route. **Only in {{site.ee_gateway_name}} version >= 0.34**.
* `consumer` contains the authenticated Consumer if an authentication plugin has been enabled.
* `latencies` contains some data about the latencies involved:
  * `proxy` is the time it took for the final service to process the request.
  * `kong` is the internal {{site.base_gateway}} latency that it took to run all the plugins.
  * `request` is the time elapsed between the first bytes were read from the client and after the last bytes were sent to the client. Useful for detecting slow clients.
* `client_ip` contains the original client IP address.
* `started_at` contains the UTC timestamp of when the request started to be processed.

----

## Kong Gateway Process Errors

{% include /md/plugins-hub/kong-process-errors.md %}
