---
id: page-plugin
title: Plugins - Galileo
header_title: Galileo
header_icon: /assets/images/icons/plugins/galileo.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Documentation
    items:
      - label: How it works
      - label: Logging bodies
      - label: FAQ
  - label: Kong Process Errors
redirect_to: https://support.konghq.com/hc/en-us/articles/115004916328-Kong-Integration
description: |
  Logs request and response data to [Galileo](http://getgalileo.io), the analytics platform for monitoring, visualizing and inspecting API & microservice traffic.
params:
  name: galileo
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: service_token
      required: false
      default:
      value_in_examples: YOUR_SERVICE_TOKEN
      description: |
        The service token provided to you by [Galileo](http://getgalileo.io).
    - name: environment
      required: false
      default:
      description: Slug of your Galileo environment name. None by default.
    - name: log_bodies
      required: false
      default: "`false`"
      description: Capture and send request/response bodies.
    - name: retry_count
      required: false
      default: "`10`"
      description: Number of retries in case of failure to send data to Galileo.
    - name: connection_timeout
      required: false
      default: "`30`"
      description: Timeout in seconds before aborting a connection to Galileo.
    - name: flush_timeout
      required: false
      default: "`2`"
      description: Timeout in seconds before flushing the current data to Galileo in case of inactivity.
    - name: queue_size
      required: false
      default: "`1000`"
      description: Number of calls to trigger a flush of the buffered data to Galileo.
    - name: host
      required: false
      default: "`collector.galileo.mashape.com`"
      description: Host address of the Galileo collector.
    - name: port
      required: false
      default: "`443`"
      description: Port of the Galileo collector.
    - name: https
      required: false
      default: "`true`"
      description: Use of HTTPs to connect with the Galileo collector.

---

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

## Kong Process Errors

This logging plugin will only log HTTP request and response data. If you are looking for the Kong process error file (which is the nginx error file), then you can find it at the following path: {[prefix](/{{site.data.kong_latest.release}}/configuration/#prefix)}/logs/error.log
