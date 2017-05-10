---
id: page-plugin
title: Plugins - Runscope
header_title: Runscope
header_icon: /assets/images/icons/plugins/runscope.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: How it works
      - label: Configuration
  - label: Kong Process Errors
---

Logs request and response data to [Runscope][runscope]. Using the Runscope Traffic Inspector, each API call can be fully viewed in it's entirety. All traffic can be searched by keyword (headers and bodies are indexed) and attribute (i.e. status code, response size, response time, etc.). Using Runscope [Live Traffic Alerts][live-traffic-alerts], API failures and exceptions can be caught, notifying your team about problems before your customers find out. Trigger alerts based on any part of the HTTP request or response, including header values, JSON or XML data, connection details and more. Alerts can be sent to Slack, HipChat, PagerDuty, email, or webhook notifications. Live Traffic Alerts is available on all medium and larger plans.

----

## How it works

This plugin sends API traffic data to your Runscope bucket using the [Runscope API][runscope-api]. 

It is important to be aware of performance when configuring this plugin. For example, be aware that logging the request and response bodies might slow down your traffic if your API is under heavy load. If your API works with significantly large request or response bodies, consider turning off this feature by updating the `log_body` configuration.

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins/ \
    --data "name=runscope" \
    --data "config.bucket_key=YOUR_BUCKET_KEY" \
    --data "config.access_token=YOUR_ACCESS_TOKEN"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

You can also apply it for every API using the `http://kong:8001/plugins/` endpoint. Read the [Plugin Reference](/docs/latest/admin-api/#add-plugin) for more information.

parameter                          | default | description
---                                | ---     | ---
`name`                             |         | The name of the plugin to use, in this case: `runscope`
`config.access_token`              |         | The Runscope [access token][generate-access-token] (or personal access token) for the Runscope API.
`config.bucket_key`                |         | Your Runscope [bucket][runscope-buckets] ID where traffic data will be stored.
`config.log_body`<br>*optional*    | `false` | Whether or not the request and response bodies should be sent to Runscope.
`config.api_endpoint`<br>*optional* | `https://api.runscope.com` | URL for the Runscope API.
`config.timeout`<br>*optional*      | `10000` | An optional timeout in milliseconds when sending data to Runscope.
`config.keepalive`<br>*optional*    | `30` | An optional value in milliseconds that defines for how long an idle connection will live before being closed.

## Kong Process Errors

This logging plugin will only log HTTP request and response data. If you are looking for the Kong process error file (which is the nginx error file), then you can find it at the following path: {[prefix](/docs/{{site.data.kong_latest.release}}/configuration/#prefix)}/logs/error.log

[runscope]: https://www.runscope.com/?utm_source=getkong&utm_content=plugin
[live-traffic-alerts]: https://www.runscope.com/docs/alerts
[runscope-api]: https://www.runscope.com/docs/api
[generate-access-token]: http://blog.runscope.com/posts/getting-started-with-the-runscope-api
[runscope-buckets]: https://www.runscope.com/docs/buckets
[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
