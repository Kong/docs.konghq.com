---
name: Moesif API Analytics
publisher: Moesif

categories: 
  - analytics-monitoring
  - logging

type: plugin

desc: User-centric API analytics and logging  

description: |
  Monitor API traffic and analyze customer usage in [Moesif's API Analytics](https://www.moesif.com/solutions/track-api-program?language=kong-api-gateway&utm_medium=docs&utm_campaign=partners&utm_source=kong) platform, enabling:

  * [Understand customer API usage](https://www.moesif.com/features/api-analytics?utm_medium=docs&utm_campaign=partners&utm_source=kong) with user behavior analytics.
  * [Debug issues quickly](https://www.moesif.com/features/api-logs?utm_medium=docs&utm_campaign=partners&utm_source=kong) with high-cardinality API logs and metrics.
  * [Get alerted](https://www.moesif.com/features/api-monitoring?utm_medium=docs&utm_campaign=partners&utm_source=kong) of problems impacting customers.
  * [Track API KPIs](https://www.moesif.com/features/api-dashboards?utm_medium=docs&utm_campaign=partners&utm_source=kong) with custom dashboards.
  * [Trigger behavioral emails](https://www.moesif.com/features/user-behavioral-emails?utm_medium=docs&utm_campaign=partners&utm_source=kong) that keep customers informed.
  * [Detect and Block API threats](https://www.moesif.com/solutions/api-security?utm_medium=docs&utm_campaign=partners&utm_source=kong) and abuse including OWASP Top 10 API threats.

  This plugin supports automatic analysis of REST, GraphQL, and other APIs with zero latency.

support_url: https://www.moesif.com/implementation/log-http-calls-from-kong-api-gateway?utm_medium=docs&utm_campaign=partners&utm_source=kong

source_url: https://github.com/Moesif/kong-plugin-moesif

license_url: https://raw.githubusercontent.com/Moesif/kong-plugin-moesif/master/LICENSE

privacy_policy_url: https://www.moesif.com/privacy?utm_medium=docs&utm_campaign=partners&utm_source=kong

terms_of_service_url: https://www.moesif.com/terms?utm_medium=docs&utm_campaign=partners&utm_source=kong

kong_version_compatibility: # required
  community_edition: # optional
    compatible:
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
      - 2.1.x-x
      - 1.5.x-x
      - 1.3.x-x
      - 0.36-x
      - 0.35-x
      - 0.34-x
      - 0.33-x
      - 0.32-x
      - 0.31-x
      - 0.30-x
    #incompatible:

params:
  name: kong-plugin-moesif
  api_id: true
  service_id: true
  consumer_id: true
  route_id: true
  config:
    - name: application_id
      required: true
      default:
      value_in_examples: MY_MOESIF_APPLICATION_ID
      description: Your Moesif Application Id from your [Moesif](http://www.moesif.com) dashboard. Go to Top Right Menu -> Installation.
    - name: api_endpoint
      required: false
      default: "`https://api.moesif.net`"
      description: URL for the Moesif Collection API (Only modify if secure proxy is used).
    - name: timeout
      required: false
      default: "`10000`"
      description: An optional timeout in milliseconds when sending data to Moesif.
    - name: keepalive
      required: false
      default: "`10000`"
      description: An optional value in milliseconds that defines for how long an idle connection will live before being closed.
    - name: api_version
      required: false
      default: "`1.0`"
      description: An optional API Version you want to tag this request with
    - name: disable_capture_request_body
      required: false
      default: "`false`"
      description: Set to true to disable logging of request body.
    - name: disable_capture_response_body
      required: false
      default: "`false`"
      description: Set to true to disable logging of response body.
    - name: request_header_masks
      required: false
      default: "`{}`"
      description: An array of request header fields to mask.
    - name: request_header_masks
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
    - name: debug
      required: false
      default: false
      description: An option if set to true, prints internal log messages for debugging integration issues.
    - name: user_id_header
      required: false
      default: ""
      description: An optional field name to identify a User from a request or response header.
    - name: company_id_header
      required: false
      default: ""
      description: An optional field name to identify a Company (Account) from a request or response header.
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

When enabled, this plugin will capture API traffic and log to
[Moesif API Analytics](https://www.moesif.com/?language=kong-api-gateway&utm_medium=docs&utm_campaign=partners&utm_source=kong). 
This plugin adds zero latency and does not sit in line to API traffic.

[Package on Luarocks](http://luarocks.org/modules/moesif/kong-plugin-moesif)

Moesif natively supports REST, GraphQL, Web3, SOAP, JSON-RPC, and more.

### How to install

The `.rock` file is a self-contained package that can be installed locally or from a remote server.

If the luarocks utility is installed in your system (this is likely the case if you used one of the official installation packages), you can install the 'rock' in your LuaRocks tree (a directory in which LuaRocks installs Lua modules).

It can be installed from luarocks repository by doing:

```shell
luarocks install --server=http://luarocks.org/manifests/moesif kong-plugin-moesif
```
