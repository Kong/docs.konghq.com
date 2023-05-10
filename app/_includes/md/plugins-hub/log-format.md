<!---shared with logging plugins: file-log, http-log, loggly, syslog, tcp-log, udp-log
This example is from 2.2.1 per DOCS-1617 --->

Every request is logged separately in a JSON object, separated by a new line `\n`, with the following format:

```json
{
  "service": {
    "host": "httpbin.org",
    "created_at": 1614232642,
    "connect_timeout": 60000,
    "id": "167290ee-c682-4ebf-bdea-e49a3ac5e260",
    "protocol": "http",
    "read_timeout": 60000,
    "port": 80,
    "path": "/anything",
    "updated_at": 1614232642,
    "write_timeout": 60000,
    "retries": 5,
    "ws_id": "54baa5a9-23d6-41e0-9c9a-02434b010b25"
  },
  "route": {
    "id": "78f79740-c410-4fd9-a998-d0a60a99dc9b",
    "paths": [
      "/log"
    ],
    "protocols": [
      "http"
    ],
    "strip_path": true,
    "created_at": 1614232648,
    "ws_id": "54baa5a9-23d6-41e0-9c9a-02434b010b25",
    "request_buffering": true,
    "updated_at": 1614232648,
    "preserve_host": false,
    "regex_priority": 0,
    "response_buffering": true,
    "https_redirect_status_code": 426,
    "path_handling": "v0",
    "service": {
      "id": "167290ee-c682-4ebf-bdea-e49a3ac5e260"
    }
  },
  "request": {
    "querystring": {},
    "size": 138,
    "uri": "/log",
    "url": "http://localhost:8000/log",
    "headers": {
      "host": "localhost:8000",
      "accept-encoding": "gzip, deflate",
      "user-agent": "HTTPie/2.4.0",
      "accept": "*/*",
      "connection": "keep-alive"
    },
    "method": "GET"
  },
  "response": {
    "headers": {
      "content-type": "application/json",
      "date": "Thu, 25 Feb 2021 05:57:48 GMT",
      "connection": "close",
      "access-control-allow-credentials": "true",
      "content-length": "503",
      "server": "gunicorn/19.9.0",
      "via": "kong/2.2.1.0-enterprise-edition",
      "x-kong-proxy-latency": "57",
      "x-kong-upstream-latency": "457",
      "access-control-allow-origin": "*"
    },
    "status": 200,
    "size": 827
  },
  "latencies": {
    "request": 515,
    "kong": 58,
    "proxy": 457
  },
  "tries": [
    {
      "balancer_latency": 0,
      "port": 80,
      "balancer_start": 1614232668399,
      "ip": "18.211.130.98"
    }
  ],
  "client_ip": "192.168.144.1",
  "workspace": "54baa5a9-23d6-41e0-9c9a-02434b010b25",
  "upstream_uri": "/anything",
	"authenticated_entity": {
		"id": "c62c1455-9b1d-4f2d-8797-509ba83b8ae8"
	},
	"consumer": {
		"id": "ae974d6c-0f8a-4dc5-b701-fa0aa38592bd",
		"created_at": 1674035962,
		"username_lower": "foo",
		"username": "foo",
		"type": 0
	},
  "started_at": 1614232668342
}
```
