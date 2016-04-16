---
id: page-plugin
title: Plugins - Galileo
header_title: Galileo
header_icon: /assets/images/icons/plugins/galileo.png
redirect_from: /plugins/mashape-analytics/
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Configuration
  - label: Documentation
    items:
      - label: How it works
      - label: Logging bodies
      - label: FAQ
---

Logs request and response data to [Galileo][galileo], the analytics platform for monitoring, visualizing and inspecting API & microservice traffic.

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins/ \
    --data "name=galileo" \
    --data "config.service_token=YOUR_SERVICE_TOKEN"
```

`api`: The `id` or `name` of the API that this plugin configuration will target


form parameter      | required     | description
---                 | ---          | ---
`name`              | *required*   | The name of the plugin to use, in this case: `galileo`
`consumer_id`       | *optional*   | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`service_token`     | *required*   | The service token provided to you by [Galileo][galileo].
`environment`       | *optional*   | Slug of your Galileo environment name. None by default.
`log_bodies`        | *optional*   | Capture and send request/response bodies. Defaults to `false`.
`retry_count`       | *optional*   | Number of retries in case of failure to send data to Galileo. Defaults to `10`.
`connection_timeout` | *optional*  | Timeout in seconds before aborting a connection to Galileo. Defaults to `30`.
`flush_timeout`     | *optional*   | Timeout in seconds before flushing the current data to Galileo in case of inactivity. Defaults to `2`.
`queue_size`        | *optional*   | Number of calls to trigger a flush of the buffered data to Galileo. Defaults to `1000`.
`host`              | *optional*   | Host address of the Galileo collector. Defaults to `collector.galileo.mashape.com`
`port`              | *optional*   | Port of the Galileo collector. Defaults to `443`.
`https`             | *optional*   | Use of HTTPs to connect with the Galileo collector. Defaults to `true`.

[galileo]: https://getgalileo.io/
[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?

----

## How it works

When enabled, this plugin will create a buffer for each of the APIs it is monitoring. The buffer accumulates the logs of this API's traffic. When the API received no traffic for `flush_timeout` or if the number of calls reaches `queue_size`, the buffer is queued for sending to the Galileo collector.

The Galileo collector then processes your logs before you are able to see your traffic on your Galileo dashboard.

## Logging bodies

This plugin can have a performance impact when the `log_bodies` option is enabled. Buffering the bodies is an expansive operation for Kong and depending on their size, can put pressure on the LuaJIT VM.

The buffer will only allow for bodies up to `20MB`, and for up to `200MB` of data queued for sending at once.

When logging bodies, make sure to configure your `queue_size` so that Kong flushes frequently enough to the Galileo collector.

## FAQ

#### Why can't I see my API logs on my Galileo dashboard?

First of all, check the Kong logs for errors at:

```
{nginx_working_dir}/logs/error.log
```

If you don't see anything useful, you can reload Kong with the `debug` log level by editing your configuration file:

```
error_log logs/error.log debug;
```

Now, you should see logs telling you what the plugin is doing, as well as responses from the Galileo collector. If the collector is able to process your data, it means Galileo is correctly receiving it. You'll want to make sure you have configured your plugin to send your data to the right `environment`.
