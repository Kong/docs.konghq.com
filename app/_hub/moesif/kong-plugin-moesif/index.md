---
name: Moesif API Insights
publisher: Moesif

categories:
  - analytics-monitoring

type: plugin

desc: User-centric API analytics and monitoring  

description: |
  Monitor API traffic and understand usage with [Moesif's](https://www.moesif.com/solutions/track-api-program?language=kong-api-gateway) user-centric 
  API analytics, including:

  * [Understand API adoption and usage](https://www.moesif.com/features/api-analytics) with user behavior analytics
  * [Quickly debug](https://www.moesif.com/features/api-logs) functional and performance issues
  * [Monitor for issues](https://www.moesif.com/features/api-monitoring) impacting customers
  * [Create live dashboards](https://www.moesif.com/features/api-dashboards) and share with colleagues
  * [Embed API logs](https://www.moesif.com/features/embedded-api-logs) in your app to improve developer experience

support_url: https://www.moesif.com/implementation/log-http-calls-from-kong-api-gateway

source_url: https://github.com/Moesif/kong-plugin-moesif

license_url: https://raw.githubusercontent.com/Moesif/kong-plugin-moesif/master/LICENSE

privacy_policy_url: https://www.moesif.com/privacy

terms_of_service_url: https://www.moesif.com/terms

kong_version_compatibility: # required
  community_edition: # optional
    compatible:
      - 0.14.x
      - 0.13.x
      - 0.12.x
      - 0.11.x
      - 0.10.x
    #incompatible:
  enterprise_edition: # optional
    compatible:
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

When enabled, this plugin will monitor API traffic and log to
[Moesif API Analytics](https://www.moesif.com/?language=kong-api-gateway). Use Moesif
to understand API adoption and resolve issues quickly.

[Package on Luarocks](http://luarocks.org/modules/moesif/kong-plugin-moesif)

Moesif natively supports REST, GraphQL, Web3, SOAP, JSON-RPC, and more.

### How to install

The `.rock` file is a self-contained package that can be installed locally or from a remote server.

If the luarocks utility is installed in your system (this is likely the case if you used one of the official installation packages), you can install the 'rock' in your LuaRocks tree (a directory in which LuaRocks installs Lua modules).

It can be installed from luarocks repository by doing:

```shell
luarocks install --server=http://luarocks.org/manifests/moesif kong-plugin-moesif
```
