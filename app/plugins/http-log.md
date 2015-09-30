---
id: page-plugin
title: Plugins - HTTP Log
header_title: HTTP Log
header_icon: /assets/images/icons/plugins/http-log.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Installation
      - label: Configuration
  - label: Usage
    items:
      - label: Log Format
---

Send request and response logs to an HTTP server.

----

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file:

```yaml
plugins_available:
  - http-log
```

Every node in the Kong cluster should have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=http-log" \
    --data "config.http_endpoint=http://mockbin.org/bin/:id/" \
    --data "config.method=POST" \
    --data "config.timeout=1000" \
    --data "config.keepalive=1000"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter              | description
---                         | ---
`name`                      | The name of the plugin to use, in this case: `http-log`
`consumer_id`<br>*optional* | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`config.http_endpoint`       | The HTTP endpoint (including the protocol to use) where to send the data to
`config.method`              | Default `POST`. An optional method used to send data to the http server, other supported values are PUT, PATCH
`config.timeout`             | Default `10000`. An optional timeout in milliseconds when sending data to the upstream server
`config.keepalive`           | Default `60000`. An optional value in milliseconds that defines for how long an idle connection will live before being closed

[api-object]: /docs/{{site.data.kong_latest.release}}/admin-api/#api-object
[configuration]: /docs/{{site.data.kong_latest.release}}/configuration
[consumer-object]: /docs/{{site.data.kong_latest.release}}/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?

## Log Format

Every request will be logged separately in a JSON object, with the following format:

```json
{
    "request": {
        "method": "GET",
        "uri": "/get",
        "size": "75",
        "request_uri": "http://httpbin.org:8000/get",
        "querystring": {},
        "headers": {
            "accept": "*/*",
            "host": "httpbin.org",
            "user-agent": "curl/7.37.1"
        }
    },
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
    "authenticated_entity": {
        "consumer_id": "80f74eef-31b8-45d5-c525-ae532297ea8e",
        "created_at":	1437643103000,
        "id": "eaa330c0-4cff-47f5-c79e-b2e4f355207e",
        "key": "2b64e2f0193851d4135a2e885cd08a65"
    },
    "api": {
        "request_host": "test.com",
        "upstream_url": "http://mockbin.org/",
        "created_at": 1432855823000,
        "name": "test.com",
        "id": "fbaf95a1-cd04-4bf6-cb73-6cb3285fef58"
    },
    "latencies": {
        "proxy": 1430,
        "kong": 9,
        "request": 1921
    },
    "started_at": 1433209822425,
    "client_ip": "127.0.0.1"
}
```

A few considerations on the above JSON object:

* `request` contains properties about the request sent by the client
* `response` contains properties about the response sent to the client
* `api` contains Kong properties about the specific API requested
* `authenticated_entity` contains Kong properties about the authenticated consumer (if an authentication plugin has been enabled)
* `latencies` contains some data about the latencies involved:
  * `proxy` is the time it took for the final service to process the request
  * `kong` is the internal Kong latency that it took to run all the plugins
  * `request` is the time elapsed between the first bytes were read from the client and after the last bytes were sent to the client. Useful for detecting slow clients.

----

## Note

This logging plugin will only log HTTP request and response data. If you are looking for the Kong process error file (which is the nginx error file), then you can find it at the following path: {[nginx_working_dir](/docs/{{site.data.kong_latest.version}}/configuration/#nginx_working_dir)}/logs/error.log
