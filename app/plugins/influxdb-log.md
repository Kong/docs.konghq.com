---
id: page-plugin
title: Plugins - InfluxDB Log
header_title: InfluxDB Log
header_icon: /assets/images/icons/plugins/influxdb-log.png
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

Send request and response logs to an InfluxDB server.

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=influxdb-log" \
    --data "config.http_endpoint=http://127.0.0.1:8086/write?db=kongdb" \
    --data "config.timeout=1000" \
    --data "config.keepalive=1000"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter              | description
---                         | ---
`name`                      | The name of the plugin to use, in this case: `influxdb-log`
`consumer_id`<br>*optional* | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`config.http_endpoint`       | The InfluxDB endpoint (including the protocol to use) where to send the data to
`config.timeout`             | Default `10000`. An optional timeout in milliseconds when sending data to the upstream server
`config.keepalive`           | Default `60000`. An optional value in milliseconds that defines for how long an idle connection will live before being closed

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?

----

## Log Format

Every request will be logged to InfluxDB log in [InfluxDB](https://docs.influxdata.com/influxdb/) standard, with message component in the following format:

```json


{
  "tag": {
    "scheme": "https",
    "host": "localhost",
    "uri": "/",
    "request_method": "GET",
    "response_status": 200,
    "client_ip": "127.0.0.1",
    "api_id": "fbaf95a1-cd04-4bf6-cb73-6cb3285fef58",
    "authenticated_entity_id": "eaa330c0-4cff-47f5-c79e-b2e4f355207e",
    "authenticated_entity_consumer_id": "80f74eef-31b8-45d5-c525-ae532297ea8e"
  },
  "field": {
    "request_size": 75,
    "response_size": 434,
    "latencies_kong": 9,
    "latencies_proxy": 1430,
    "latencies_request": 1921,
    "started_at": 1433209822425
  }
}
```

A few considerations on the above JSON object:

* `tag` The tag(s) that you want to include with your data point
  * `scheme` request scheme, "http" or "https"
  * `host` in this order of precedence: host name from the request line, or host name from the “Host” request header field, or the server name matching a request
  * `request_method` request method, usually "GET" or "POST"
  * `response_status` the current request's response status
  * `client_ip` client address
  * `api_id` contains Kong properties about the specific API requested id
  * `authenticated_entity_*` contains Kong properties about the authenticated consumer (if an authentication plugin has been enabled)
* `field` The field(s) for your data point.
  * `request_size` request length (including request line, header, and request body)
  * `response_size` number of bytes sent to a client
  * `latencies_proxy` is the time it took for the final service to process the request
  * `latencies_kong` is the internal Kong latency that it took to run all the plugins
  * `latencies_request` is the time elapsed between the first bytes were read from the client and after the last bytes were sent to the client. Useful for detecting slow clients.
  * `started_at` Returns a integer number representing the timestamp (microseconds) when the current request was created

----

## Kong Process Errors

This logging plugin will only log InfluxDB request and response data. If you are looking for the Kong process error file (which is the nginx error file), then you can find it at the following path: {[nginx_working_dir](/docs/{{site.data.kong_latest.release}}/configuration/#nginx_working_dir)}/logs/error.log
