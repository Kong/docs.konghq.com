---
id: page-plugin
title: Plugins - TCP Log
header_title: TCP Log
header_icon: /assets/images/icons/plugins/tcp-log.png
breadcrumbs:
  Plugins: /plugins
---

Log request and response data to a TCP server.

---

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file

```yaml
plugins_available:
  - tcplog
```

Every node in the Kong cluster should have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/plugins_configurations/ \
    --data "name=tcplog" \
    --data "api_id=API_ID" \
    --data "value.host=127.0.0.1" \
    --data "value.port=9999" \
    --data "value.timeout=1000" \
    --data "value.keepalive=1000"
```

parameter                               | description
 ---                                    | ---
`name`                                  | The name of the plugin to use, in this case: `tcplog`
`api_id`                                | The API ID that this plugin configuration will target
`consumer_id`<br>*optional*             | The CONSUMER ID that this plugin configuration will target
`value.host`                            | The IP address or host name to send data to
`value.port`                            | The port to send data to on the final server
`value.timeout`                         | Default `10000`. An optional timeout in milliseconds when sending data to the final server
`value.keepalive`                       | Default `60000`. An optional value in milliseconds that defines for how long an idle connection will live before being closed

[api-object]: /docs/{{site.data.kong_latest.version}}/admin-api/#api-object
[configuration]: /docs/{{site.data.kong_latest.version}}/configuration
[consumer-object]: /docs/{{site.data.kong_latest.version}}/admin-api/#consumer-object

## Log Format

Every request will be logged separately in a JSON object separated by `\r\n`, with the following format:

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