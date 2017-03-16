---
id: page-plugin
title: Plugins - Loggly
header_title: Loggly
header_icon: /assets/images/icons/plugins/loggly.png
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

Log request and response data over UDP to [Loggly](https://www.loggly.com).

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=loggly" \
    --data "config.key=YOUR_LOGGLY_SERVICE_TOKEN"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

You can also apply it for every API using the `http://kong:8001/plugins/` endpoint. Read the [Plugin Reference](/docs/latest/admin-api/#add-plugin) for more information.

parameter                          | default | description
---                                | ---     | ---
`name`                             |         | The name of the plugin to use, in this case: `loggly`
`consumer_id`<br>*optional*        |         | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`config.host`<br>*optional*        | `logs-01.loggly.com` | The IP address or host name of Loggly server
`config.port`<br>*optional*        |`514`    | The UDP port to send data to on the Loggly server
`config.key`                       |         | Loggly [customer token](https://www.loggly.com/docs/customer-token-authentication-token/).
`config.tags`<br>*optional*        | `kong`  | An optional list of [tags](https://www.loggly.com/docs/tags/) to support segmentation & filtering of logs.
`config.timeout`<br>*optional*     | `10000` | An optional timeout in milliseconds when sending data to the Loggly server
`config.successful_severity`<br>*optional*  | `info` | An optional logging severity assigned to the all successful requests with response status code 400 .
`config.client_errors_severity`<br>*optional* | `info` | An optional logging severity assigned to the all failed requests with response status code 400 or higher but less than 500.
`config.server_errors_severity`<br>*optional* | `info` | An optional logging severity assigned to the all failed requests with response status code 500 or higher.
`config.log_level`<br>*optional*   | `info` | An optional logging severity, any request with equal or higher severity will be logged to Loggly.

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?

----

## Log Format

Every request will be transmitted to Loggly in [SYSLOG](https://en.wikipedia.org/wiki/Syslog) standard, with `message` component in the following format:

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
        "custom_id": "foo",
        "username": "bar",
        "created_at":	1437643103000,
        "id": "eaa330c0-4cff-47f5-c79e-b2e4f355207e",
        "key": "2b64e2f0193851d4135a2e885cd08a65"
    },
    "api": {
        "request_host": "test.com",
        "upstream_url": "http://httpbin.org/",
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

## Kong Process Errors

This logging plugin will only log HTTP request and response data. If you are looking for the Kong process error file (which is the nginx error file), then you can find it at the following path: {[prefix](/docs/{{site.data.kong_latest.release}}/configuration/#prefix)}/logs/error.log
