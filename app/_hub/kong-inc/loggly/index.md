---
name: Loggly
publisher: Kong Inc.

desc: Send request and response logs to Loggly
description: |
  Log request and response data over UDP to [Loggly](https://www.loggly.com).

type: plugin
categories:
  - logging

kong_version_compatibility:
    community_edition:
      compatible:
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
    enterprise_edition:
      compatible:
        - 0.34-x
        - 0.33-x
        - 0.32-x
        - 0.31-x

params:
  name: loggly
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: host
      required: false
      default: "`logs-01.loggly.com`"
      description: The IP address or host name of Loggly server
    - name: port
      required: false
      default: "`514`"
      description: The UDP port to send data to on the Loggly server
    - name: key
      required: true
      default:
      value_in_examples: YOUR_LOGGLY_SERVICE_TOKEN
      description: |
        Loggly [customer token](https://www.loggly.com/docs/customer-token-authentication-token/).
    - name: tags
      required: false
      default: "`kong`"
      description: |
        An optional list of [tags](https://www.loggly.com/docs/tags/) to support segmentation & filtering of logs.
    - name: timeout
      required: false
      default: "`10000`"
      description: An optional timeout in milliseconds when sending data to the Loggly server
    - name: successful_severity
      required: false
      default: "`info`"
      description: |
        An optional logging severity assigned to the all successful requests with response status code 400 .
    - name: client_errors_severity
      required: false
      default: "`info`"
      description: |
        An optional logging severity assigned to the all failed requests with response status code 400 or higher but less than 500.
    - name: server_errors_severity
      required: false
      default: "`info`"
      description: |
        An optional logging severity assigned to the all failed requests with response status code 500 or higher.
    - name: log_level
      required: false
      default: "`info`"
      description: |
        An optional logging severity, any request with equal or higher severity will be logged to Loggly.

---

## Log Format

Every request will be transmitted to Loggly in [SYSLOG](https://en.wikipedia.org/wiki/Syslog) standard, with `message` component in the following format:

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

* `request` contains properties about the request sent by the client
* `response` contains properties about the response sent to the client
* `tries` contains the list of (re)tries (successes and failures) made by the load balancer for this request
* `route` contains Kong properties about the specific Route requested
* `service` contains Kong properties about the Service associated with the requested Route
* `authenticated_entity` contains Kong properties about the authenticated credential (if an authentication plugin has been enabled)
* `workspaces` contains Kong properties of the Workspaces associated with the requested Route. **Only in Kong Enterprise version >= 0.34**.
* `consumer` contains the authenticated Consumer (if an authentication plugin has been enabled)
* `latencies` contains some data about the latencies involved:
  * `proxy` is the time it took for the final service to process the request
  * `kong` is the internal Kong latency that it took to run all the plugins
  * `request` is the time elapsed between the first bytes were read from the client and after the last bytes were sent to the client. Useful for detecting slow clients.
* `client_ip` contains the original client IP address
* `started_at` contains the UTC timestamp of when the API transaction has started to be processed.

----

## Kong Process Errors

This logging plugin will only log HTTP request and response data. If you are looking for the Kong process error file (which is the nginx error file), then you can find it at the following path: {[prefix](/{{site.data.kong_latest.release}}/configuration/#prefix)}/logs/error.log
