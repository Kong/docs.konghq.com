---
name: Moesif API Analytics
publisher: Moesif

categories: 
  - analytics-monitoring
  - logging

type: plugin

desc: User Behavior API analytics and observability  

description: |
  Monitor API logs and usage metrics in [Moesif](https://www.moesif.com/solutions/track-api-program?language=kong-api-gateway&utm_medium=docs&utm_campaign=partners&utm_source=kong){:target="_blank"}{:rel="noopener noreferrer"}, which enables you to:

  * [Understand customer API usage](https://www.moesif.com/features/api-analytics?utm_medium=docs&utm_campaign=partners&utm_source=kong){:target="_blank"}{:rel="noopener noreferrer"} and the value they bring.
  * [Debug issues quickly](https://www.moesif.com/features/api-logs?utm_medium=docs&utm_campaign=partners&utm_source=kong){:target="_blank"}{:rel="noopener noreferrer"} with high-cardinality API logs and metrics.
  * [Get alerted](https://www.moesif.com/features/api-monitoring?utm_medium=docs&utm_campaign=partners&utm_source=kong){:target="_blank"}{:rel="noopener noreferrer"} of problems and anomalous behavior.
  * [Trigger behavioral emails](https://www.moesif.com/features/user-behavioral-emails?utm_medium=docs&utm_campaign=partners&utm_source=kong){:target="_blank"}{:rel="noopener noreferrer"} warning customers of issues.
  * [Detect and Block API threats](https://www.moesif.com/solutions/api-security?utm_medium=docs&utm_campaign=partners&utm_source=kong){:target="_blank"}{:rel="noopener noreferrer"} and abuse including OWASP Top 10 API threats.

  This plugin supports automatic analysis of high-volume REST, GraphQL, and other APIs without adding latency.

support_url: https://www.moesif.com/implementation/log-http-calls-from-kong-api-gateway?utm_medium=docs&utm_campaign=partners&utm_source=kong

source_url: https://github.com/Moesif/kong-plugin-moesif

license_url: https://raw.githubusercontent.com/Moesif/kong-plugin-moesif/master/LICENSE

privacy_policy_url: https://www.moesif.com/privacy?utm_medium=docs&utm_campaign=partners&utm_source=kong

terms_of_service_url: https://www.moesif.com/terms?utm_medium=docs&utm_campaign=partners&utm_source=kong

kong_version_compatibility: # required
  community_edition: # optional
    compatible:
      - 2.2.x
      - 2.1.x
      - 2.0.x
      - 1.5.x
      - 1.4.x
      - 1.3.x
      - 1.2.x
      - 1.1.x
      - 1.0.x
      - 0.15.x
      - 0.14.x
      - 0.13.x
      - 0.12.x
      - 0.11.x
      - 0.10.x
    #incompatible:
  enterprise_edition: # optional
    compatible:
      - 2.1.x
      - 1.5.x
      - 1.3-x
      - 0.36-x
      - 0.35-x
      - 0.34-x
      - 0.33-x
      - 0.32-x
      - 0.31-x
      - 0.30-x
    #incompatible:

params:
  name: moesif
  api_id: true
  service_id: true
  consumer_id: true
  route_id: true
  dbless_compatible: yes
  config:
    - name: application_id
      required: true
      default:
      value_in_examples: MY_MOESIF_APPLICATION_ID
      description: Your Moesif Application Id from your [Moesif](http://www.moesif.com){:target="_blank"}{:rel="noopener noreferrer"} dashboard. Go to Top Right Menu -> Installation.
    - name: api_endpoint
      required: false
      default: "`https://api.moesif.net`"
      description: URL for the Moesif Collection API (Change to your secure proxy hostname if client-side encryption is used).
    - name: connect_timeout
      required: false
      default: "`1000`"
      description: Timeout in milliseconds when connecting to Moesif.
    - name: send_timeout
      required: false
      default: "`2000`"
      description: Timeout in milliseconds when sending data to Moesif.
    - name: timeout
      required: false
      default: "`1000`"
      description: (Deprecated) timeout in milliseconds when connecting/sending to Moesif.
    - name: keepalive
      required: false
      default: "`5000`"
      description: Value in milliseconds that defines for how long an idle connection will live before being closed.
    - name: api_version
      required: false
      default: "`1.0`"
      description: API Version you want to tag this request with in Moesif.
    - name: user_id_header
      required: false
      default: "X-Consumer-Custom-Id"
      description: Request or response header to use to identify the User in Moesif.
    - name: company_id_header
      required: false
      default: ""
      description: Request or response header to use to identify the Company (Account) in Moesif.
    - name: disable_capture_request_body
      required: false
      default: "`false`"
      description: Disable logging of request body.
    - name: disable_capture_response_body
      required: false
      default: "`false`"
      description: Disable logging of response body.
    - name: request_header_masks
      required: false
      default: "`{}`"
      description: An array of request header fields to mask.
    - name: request_query_masks
      required: false
      default: "`{}`"
      description: An array of query string parameter fields to mask.
    - name: request_body_masks
      required: false
      default: "`{}`"
      description: An array of request body fields to mask.
    - name: response_header_masks
      required: false
      default: "`{}`"
      description: An array of response header fields to mask.
    - name: response_body_masks
      required: false
      default: "`{}`"
      description: An array of response body fields to mask.
    - name: batch_size
      required: false
      default: "`200`"
      description: Maximum batch size when sending to Moesif.
    - name: event_queue_size
      required: false
      default: "`5000`"
      description: Maximum number of events to hold in the queue before sending to Moesif. In case of network issues where the plugin is unable to connect or send an event to Moesif, skips adding new events to the queue to prevent memory overflow.
    - name: disable_gzip_payload_decompression
      required: false
      default: "`false`"
      description: If set to `true`, disables decompressing body in Kong.
    - name: max_callback_time_spent
      required: false
      default: "`2000`"
      description: Limits the amount of time in milliseconds to send events to Moesif per worker cycle.
    - name: request_max_body_size_limit
      required: false
      default: "`100000`"
      description: Maximum request body size in bytes to log in Moesif.
    - name: response_max_body_size_limit
      required: false
      default: "`100000`"
      description: Maximum response body size in bytes to log in Moesif.
    - name: debug
      required: false
      default: false
      description: An option if set to true, prints internal log messages for debugging integration issues.
  extra:
    # This is for additional remarks about your configuration.
###############################################################################
# END YAML DATA
# Beneath the next --- use Markdown (redcarpet flavor) and HTML formatting only.
#
# The remainder of this file is for free-form description, instruction, and
# reference matter.
# Your headers must be Level 3 or 4 (parsing to h3 or h4 tags in HTML).
# This is represented by ### or #### notation preceding the header text.
###############################################################################
# BEGIN MARKDOWN CONTENT
---

### How it works

When enabled, this plugin captures API traffic and logs it to
[Moesif API Analytics](https://www.moesif.com/?language=kong-api-gateway&utm_medium=docs&utm_campaign=partners&utm_source=kong){:target="_blank"}{:rel="noopener noreferrer"}. 
This plugin logs to Moesif with an [asynchronous design](https://www.moesif.com/enterprise/api-analytics-infrastructure?language=kong-api-gateway&utm_medium=docs&utm_campaign=partners&utm_source=kong){:target="_blank"}{:rel="noopener noreferrer"} and doesn't add any latency to your API calls.

[Package on Luarocks](http://luarocks.org/modules/moesif/kong-plugin-moesif){:target="_blank"}{:rel="noopener noreferrer"}

Moesif natively supports REST, GraphQL, Web3, SOAP, JSON-RPC, and more.

### How to install

The `.rock` file is a self-contained package that can be installed locally or from a remote server.

If the luarocks utility is installed in your system (this is likely the case if you used one of the official installation packages), you can install the 'rock' in your LuaRocks tree (a directory in which LuaRocks installs Lua modules).

It can be installed from luarocks repository by doing:

```shell
luarocks install --server=http://luarocks.org/manifests/moesif kong-plugin-moesif
```
