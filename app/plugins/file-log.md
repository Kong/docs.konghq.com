---
id: page-plugin
title: Plugins - File Log
header_title: File Log
header_icon: /assets/images/icons/plugins/file-log.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Configuration
  - label: Usage
    items:
      - label: Log Format
      - label: Kong Process Errors
---

Append request and response data to a log file on disk.

It is not recommended to use this plugin in production, it would be better to
use another logging plugin, for example `syslog`, in those cases. Due to system
limitations this plugin uses blocking file i/o, which will hurt performance,
and hence is an anti-pattern for Kong installations.

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of
a [Service][service-object], a [Route][route-object], an [API][api-object]
or a [Consumer][consumer-object] by executing the following request on
your Kong server:

```bash
$ curl -X POST http://kong:8001/plugins \
    --data "name=file-log" \
    --data "consumer_id={consumer}"  \
    --data "service_id={service}"  \
    --data "route_id={route}"  \
    --data "api_id={api}"  \
    --data "config.path=/tmp/file.log"
```

`consumer`: The `id` of the Consumer that this plugin configuration will target
`service`: The `id` of the Service that this plugin configuration will target
`route`: The `id` of the Route that this plugin configuration will target
`api`: The `id` of the API that this plugin configuration will target

The term `target` is used to refer any of the possible targets for the plugin.

You can also apply it globally using the `http://kong:8001/plugins/` by not
specifying the target. Read the [Plugin Reference](/docs/latest/admin-api/#add-plugin)
for more information.

form parameter                | default | description
---                           | ---     | ---
`name`                        |         | The name of the plugin to use, in this case: `file-log`
`consumer_id`<br>*optional*   |         | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`config.path`                 |         | The file path of the output log file. The plugin will create the file if it doesn't exist yet. Make sure Kong has write permissions to this file.
`reopen`                      | `false` | Introduced in Kong `0.10.2`. Determines whether the log file is closed and reopened on every request. If the file is not reopened, and has been removed/rotated, the plugin will keep writing to the stale file descriptor, and hence lose information.

----

## Log Format

Every request will be logged separately in a JSON object separated by a new line `\n`, with the following format:

```json
{
  "latencies": {
    "request": 485,
    "kong": 187,
    "proxy": 295
  },
  "service": {
    "host": "httpbin.org",
    "created_at": 1519230721,
    "connect_timeout": 60000,
    "id": "4d789165-1200-4bdb-b38a-61d160710dce",
    "protocol": "http",
    "name": "example-api",
    "read_timeout": 60000,
    "port": 80,
    "path": null,
    "updated_at": 1519230721,
    "retries": 5,
    "write_timeout": 60000
  },
  "request": {
    "querystring": {},
    "size": "132",
    "uri": "/",
    "url": "http://example.org:8000/",
    "headers": {
      "host": "example.org",
      "accept-encoding": "gzip, deflate",
      "user-agent": "HTTPie/0.9.9",
      "accept": "*/*",
      "connection": "keep-alive"
    },
    "method": "GET"
  },
  "tries": [
    {
      "balancer_latency": 0,
      "port": 80,
      "ip": "54.204.47.4"
    }
  ],
  "client_ip": "127.0.0.1",
  "api": {},
  "upstream_uri": "/",
  "response": {
    "headers": {
      "content-type": "text/html; charset=utf-8",
      "date": "Wed, 21 Feb 2018 18:34:16 GMT",
      "x-powered-by": "Flask",
      "connection": "close",
      "access-control-allow-credentials": "true",
      "content-length": "13129",
      "x-kong-proxy-latency": "187",
      "server": "meinheld/0.6.1",
      "x-kong-upstream-latency": "295",
      "via": "kong/0.12.1",
      "x-processed-time": "0",
      "access-control-allow-origin": "*"
    },
    "status": 200,
    "size": "13485"
  },
  "route": {
    "created_at": 1519230788,
    "strip_path": true,
    "hosts": [
      "example.org"
    ],
    "preserve_host": false,
    "regex_priority": 0,
    "updated_at": 1519230788,
    "paths": null,
    "service": {
      "id": "4d789165-1200-4bdb-b38a-61d160710dce"
    },
    "methods": null,
    "protocols": [
      "http",
      "https"
    ],
    "id": "e9e1c773-7bc0-47c1-a612-2424ee8c4703"
  },
  "started_at": 1519238070344
}
```

A few considerations on the above JSON object:

* `request` contains properties about the request sent by the client
* `response` contains properties about the response sent to the client
* `tries` contains the list of (re)tries (successes and failures) made by the load balancer for this request
* `service` contains Kong properties about the specific service requested
* `route` contains Kong properties about the specific route requested
* `api` contains Kong properties about the specific API requested
* `authenticated_entity` contains Kong properties about the authenticated credential (if an authentication plugin has been enabled)
* `consumer` contains the authenticated Consumer (if an authentication plugin has been enabled)
* `latencies` contains some data about the latencies involved:
  * `proxy` is the time it took for the final service to process the request
  * `kong` is the internal Kong latency that it took to run all the plugins
  * `request` is the time elapsed between the first bytes were read from the client and after the last bytes were sent to the client. Useful for detecting slow clients.
* `client_ip` contains the original client IP address
* `started_at` contains the UTC timestamp of when the service transaction has started to be processed.

----

## Kong Process Errors

This logging plugin will only log HTTP request and response data. If you are looking for the Kong process error file (which is the nginx error file), then you can find it at the following path: {[prefix](/docs/{{site.data.kong_latest.release}}/configuration/#prefix)}/logs/error.log

[consumer-object]: /docs/latest/admin-api/#consumer-object
[service-object]: /docs/latest/admin-api/#service-object
[route-object]: /docs/latest/admin-api/#route-object
[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
