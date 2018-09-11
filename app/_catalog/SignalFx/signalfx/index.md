---
name: SignalFx

categories: analytics-monitoring

type: plugin

desc: Monitor and analyze Kong in SignalFx
description: |
  This Kong plugin is intended for SignalFx users to obtain performance metrics from their Kong deployments for aggregation and reporting via the [Smart Agent](https://github.com/signalfx/signalfx-agent) or the [collectd-kong](https://github.com/signalfx/collectd-kong) collectd plugin. It works similarly to other Kong logging plugins and provides connection state and request/response count, latency, status, and size metrics available through a `/signalfx` Admin API endpoint.

support_url: https://support.signalfx.com/hc/en-us

source_url: https://github.com/signalfx/kong-plugin-signalfx

license_type: Apache-2.0

license_url: https://github.com/signalfx/kong-plugin-signalfx/blob/master/LICENSE

privacy_policy_url: https://signalfx.com/privacy-policy/

terms_of_service_url: https://signalfx.com/terms-and-conditions/

kong_version_compatibility:
  community_edition:
    compatible:
      - 0.12.x
      - 0.13.x
      - 0.14.x
    incompatible:
  enterprise_edition:
    compatible:
      - 0.32-x
      - 0.33-x
      - 0.34-x
    incompatible:

params:
  name: signalfx
  api_id: true
  service_id: true
  consumer_id: true
  route_id: true

  config:
    - name: aggregate_by_http_method
      required: yes
      default: true
      value_in_examples:
      description: |
        By default, metrics for each Service/API-fielded request cycle will be aggregated by a context determined partially by the request's HTTP method and by its response's status code.
        If you are monitoring a large infrastructure with hundreds of routes, grouping by HTTP method can be too granular or costly for performant ``/signalfx` requests on a 1s interval, depending on the server resources.
        This context grouping can be disabled with the boolean configuration option `aggregate_by_http_method`.

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

### Installation and configuration

See details on https://github.com/signalfx/kong-plugin-signalfx and https://github.com/signalfx/collectd-kong.
