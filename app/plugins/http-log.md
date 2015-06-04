---
sitemap: true
id: page-plugin
title: Plugins - HTTP Log
header_title: HTTP Log
header_icon: /assets/images/icons/plugins/http-log.png
header_btn_text: Report Bug
header_btn_href: https://github.com/Mashape/kong/issues/new
header_btn_target: _blank
breadcrumbs:
  Plugins: /plugins
---

Send request and response logs to an HTTP server.

---

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file:

```yaml
plugins_available:
  - httplog
```

Every node in the Kong cluster should have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/plugins_configurations/ \
    --data "name=httplog" \
    --data "api_id=API_ID" \
    --data "value.http_endpoint=http://mockbin.org/bin/:id/" \
    --data "value.method=POST" \
    --data "value.timeout=1000" \
    --data "value.keepalive=1000"
```

parameter                               | description
 ---                                    | ---
`name`                                  | The name of the plugin to use, in this case: `httplog`
`api_id`                                | The API ID that this plugin configuration will target
`consumer_id`<br>*optional*             | The CONSUMER ID that this plugin configuration will target
`value.host`                            | The host name of the http server to send data to
`value.method`                            | Default `POST`. An optional method used to send data to the http server, other supported values are PUT, PATCH
`value.timeout`                         | Default `10000`. An optional timeout in milliseconds when sending data to the final server
`value.keepalive`                       | Default `60000`. An optional value in milliseconds that defines for how long an idle connection will live before being closed

[api-object]: /docs/{{site.data.kong_latest.version}}/admin-api/#api-object
[configuration]: /docs/{{site.data.kong_latest.version}}/configuration
[consumer-object]: /docs/{{site.data.kong_latest.version}}/admin-api/#consumer-object

## Log Format

Every request will be logged separately in a JSON object separated by a new line `\n`, in the following format:

```json
{
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
    "api": {
        "public_dns": "test.com",
        "target_url": "http://httpbin.org/",
        "created_at": 1432855823000,
        "name": "test.com",
        "id": "fbaf95a1-cd04-4bf6-cb73-6cb3285fef58"
    },
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
    "started_at": 1433209822425,
    "client_ip": "127.0.0.1"
}
```
