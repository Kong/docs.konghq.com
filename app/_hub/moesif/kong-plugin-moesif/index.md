---
name: Moesif API Insights
publisher: Moesif

categories:
  - analytics-monitoring

type: plugin

desc: AI-powered analytics and monitoring for APIs  

description: |
  Moesif is an AI-powered API insights platform for:

  * API Debugging
  * API Monitoring
  * API Analytics

  Support for REST, GraphQL, Ethereum Web3, JSON-RPC, SOAP, & more

  Get real-time visibility into your (or your 3rd party) live API traffic saving you debug time.

  * Understand how your customers actually use your API
  * Root cause issues quickly with ML powered features like Smart Diff
  * Get Slack and PagerDuty alerts of anomalous API behavior that pings tests don’t catch

support_url: https://www.moesif.com/docs/server-integration/kong-api-gateway/

source_url: https://github.com/Moesif/kong-plugin-moesif

license_url: https://raw.githubusercontent.com/Moesif/moesif-express/master/LICENSE

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
      description: The Moesif application token provided to you by [Moesif](http://www.moesif.com).
    - name: api_endpoint
      required: false
      default: "`https://api.moesif.net`"
      description: URL for the Moesif API.
    - name: timeout
      required: false
      default: "`10000`"
      description: An optional timeout in milliseconds when sending data to Moesif.
    - name: keepalive
      required: false
      default: "`5000`"
      description: An optional value in milliseconds that defines for how long an idle connection will live before being closed.
    - name: api_version
      required: false
      default: "`1.0`"
      description: An optional API Version you want to tag this request with
    - name: disable_capture_request_body
      required: false
      default: "`false`"
      description: An option to disable logging of request body
    - name: disable_capture_response_body
      required: false
      default: "`false`"
      description: An option to disable logging of response body
    - name: request_masks
      required: false
      default: "`{}`"
      description: An option to mask a specific request body field
    - name: response_masks
      required: false
      default: "`{}`"
      description: An option to mask a specific response body field
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

When enabled, this plugin will capture API requests and responses and log to
[Moesif API Insights](https://www.moesif.com) for easy inspecting and real-time
debugging of your API traffic.

Moesif natively supports REST, GraphQL, Ethereum Web3, SOAP, JSON-RPC, and more.

[Package on Luarocks](http://luarocks.org/modules/moesif/kong-plugin-moesif)

### How to install

The .rock file is a self contained package that can be installed locally or from a remote server.

If the luarocks utility is installed in your system (this is likely the case if you used one of the official installation packages), you can install the 'rock' in your LuaRocks tree (a directory in which LuaRocks installs Lua modules).

It can be installed from luarocks repository by doing:

```shell
luarocks install --server=http://luarocks.org/manifests/moesif kong-plugin-moesif
```

### Kong process errors

This logging plugin will only log HTTP request and response data. If you are looking for the Kong process error file (which is the nginx error file), then you can find it at the following path:
