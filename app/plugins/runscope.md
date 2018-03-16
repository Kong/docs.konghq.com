---
id: page-plugin
title: Plugins - Runscope
header_title: Runscope
header_icon: /assets/images/icons/plugins/runscope.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Documentation
    items:
      - label: How it works
      - label: Kong Process Errors

description: |
  Logs request and response data to [Runscope](https://www.runscope.com/?utm_source=getkong&utm_content=plugin). Using the Runscope Traffic Inspector, each API call can be fully viewed in it's entirety. All traffic can be searched by keyword (headers and bodies are indexed) and attribute (i.e. status code, response size, response time, etc.). Using Runscope [Live Traffic Alerts](https://www.runscope.com/docs/alerts), API failures and exceptions can be caught, notifying your team about problems before your customers find out. Trigger alerts based on any part of the HTTP request or response, including header values, JSON or XML data, connection details and more. Alerts can be sent to Slack, HipChat, PagerDuty, email, or webhook notifications. Live Traffic Alerts is available on all medium and larger plans.

params:
  name: runscope
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: access_token
      required: true
      value_in_examples: YOUR_ACCESS_TOKEN
      description: The Runscope [access token](http://blog.runscope.com/posts/getting-started-with-the-runscope-api) (or personal access token) for the Runscope API.
    - name: bucket_key
      required: true
      value_in_examples: YOUR_BUCKET_KEY
      description: Your Runscope [bucket](https://www.runscope.com/docs/buckets) ID where traffic data will be stored.
    - name: log_body
      required: false
      default: "`false`"
      description: Whether or not the request and response bodies should be sent to Runscope.
    - name: api_endpoint
      required: false
      default: "`https://api.runscope.com`"
      description: URL for the Runscope API.
    - name: timeout
      required: false
      default: "`10000`"
      description: An optional timeout in milliseconds when sending data to Runscope.
    - name: keepalive
      required: false
      default: "`30`"
      description: An optional value in milliseconds that defines for how long an idle connection will live before being closed.

---

## How it works

This plugin sends API traffic data to your Runscope bucket using the [Runscope API][runscope-api]. 

It is important to be aware of performance when configuring this plugin. For example, be aware that logging the request and response bodies might slow down your traffic if your API is under heavy load. If your API works with significantly large request or response bodies, consider turning off this feature by updating the `log_body` configuration.

----

## Kong Process Errors

This logging plugin will only log HTTP request and response data. If you are looking for the Kong process error file (which is the nginx error file), then you can find it at the following path: {[prefix](/docs/{{site.data.kong_latest.release}}/configuration/#prefix)}/logs/error.log

[runscope-api]: https://www.runscope.com/docs/api
[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
