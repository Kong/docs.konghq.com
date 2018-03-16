---
id: page-plugin
title: Plugins - UDP Log
header_title: UDP Log
header_icon: /assets/images/icons/plugins/udp-log.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Usage
    items:
      - label: Log Format
      - label: Kong Process Errors
description: |
  Log request and response data to an UDP server.

params:
  name: udp-log
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: host
      required: true
      value_in_examples: 127.0.0.1
      description: The IP address or host name to send data to.
    - name: port
      required: true
      value_in_examples: 9999
      description: The port to send data to on the upstream server
    - name: timeout
      required: false
      default: "`10000`"
      value_in_examples: 10000
      description: An optional timeout in milliseconds when sending data to the upstream server

---

## Log Format

Every request will be logged separately in a JSON object with the following format:

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
    "api": {
        "created_at": 1488830759000,
        "hosts": [
          "example.org"
        ],
        "http_if_terminated": true,
        "https_only": false,
        "id": "6378122c-a0a1-438d-a5c6-efabae9fb969",
        "name": "example-api",
        "preserve_host": false,
        "retries": 5,
        "strip_uri": true,
        "upstream_connect_timeout": 60000,
        "upstream_read_timeout": 60000,
        "upstream_send_timeout": 60000,
        "upstream_url": "http://httpbin.org"
    },
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
* `api` contains Kong properties about the specific API requested
* `authenticated_entity` contains Kong properties about the authenticated credential (if an authentication plugin has been enabled)
* `consumer` contains the authenticated Consumer (if an authentication plugin has been enabled)
* `latencies` contains some data about the latencies involved:
  * `proxy` is the time it took for the final service to process the request
  * `kong` is the internal Kong latency that it took to run all the plugins
  * `request` is the time elapsed between the first bytes were read from the client and after the last bytes were sent to the client. Useful for detecting slow clients.
* `client_ip` contains the original client IP address
* `started_at` contains the UTC timestamp of when the API transaction has started to be processed.

----

## Kong Process Errors

This logging plugin will only log HTTP request and response data. If you are looking for the Kong process error file (which is the nginx error file), then you can find it at the following path: {[prefix](/docs/{{site.data.kong_latest.release}}/configuration/#prefix)}/logs/error.log
