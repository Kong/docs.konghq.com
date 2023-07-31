---
nav_title: Send Kong Logs to Splunk
---

You can use the HTTP Log plugin to send {{site.base_gateway}} logs to Splunk.

{:.note}
> **Note**: The following example uses Splunk 9.0.2. If you are using a different version of Splunk,
check the Splunk documentation for the appropriate method.

## Prerequisites

You have a Splunk authorization token.

{% if_plugin_version gte:3.0.x %}
## Send raw text to HEC

To send raw text, use the [`/services/collector/raw`](https://docs.splunk.com/Documentation/Splunk/9.1.0/RESTREF/RESTinput#services.2Fcollector.2Fraw) Splunk endpoint.

For example, assuming that Splunk is running at `https://example.splunkcloud.com:8088/` and its secure token is `123456`,
enable an HTTP Log plugin instance using the following configuration: 

{% plugin_example %}
plugin: kong-inc/http-log
name: http-log
config:
  headers:
    - Authorization: "Splunk 123456"
  http_endpoint: "https://example.splunkcloud.com:8088/services/collector/raw"
  method: POST
  timeout: 3000
  retry_count: 1
targets:
  - service
  - route
  - consumer
  - global
formats:
  - curl
  - yaml
  - kubernetes
{% endplugin_example %}

Based on this configuration, the HTTP Log plugin sends the logs to `https://example.splunkcloud.com:8088/services/collector/raw` with a secure token.

Logs are sent as JSON objects. See the [Log Format](/hub/kong-inc/http-log/how-to/log-format/) reference for details.
{% endif_plugin_version %}

## More information

* [Splunk documentation: Send raw text to HEC](https://docs.splunk.com/Documentation/Splunk/9.0.2/Data/HECExamples#Example_3:_Send_raw_text_to_HEC)