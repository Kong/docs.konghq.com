---
# This file is for profiling an individual Kong extension.
# Duplicate this file in your own *publisher path* on your own branch.
# Your publisher path is relative to _app/_catalog/.
# The path must consist only of alphanumeric characters and hyphens (-).
#
# The following YAML data must be filled out as prescribed by the comments
# on individual parameters. Also see documentation at:
# https://github.com/Kong/docs.konghq.com
# Remove inapplicable entries and superfluous comments as needed

name: SignalFx # (required) The name of your extension.
  # Use capitals and spaces as needed.

categories: analytics-monitoring # (required) Uncomment all that apply.
  #- authentication
  #- security
  #- traffic-control
  #- serverless
  #- analytics-monitoring
  #- transformations
  #- logging
# Array format only; uncomment one or more applicable categories.
# If you would like to add a category, you may do so here.

type: plugin # (required) String, one of:
  # plugin          | extensions of the core platform
  # api-integration | extensions of the Kong Admin API
  # dev-mod         | enhancements of the Kong dev portal

desc: Monitor and analyze Kong in SignalFx # (required) 1-liner description; max 80 chars
description: |
  This Kong plugin is intended for SignalFx users to obtain performance metrics from their Kong deployments for aggregation and reporting via the [Smart Agent](https://github.com/signalfx/signalfx-agent) or the [collectd-kong](https://github.com/signalfx/collectd-kong) collectd plugin. It works similarly to other Kong logging plugins and provides connection state and request/response count, latency, status, and size metrics available through a `/signalfx` Admin API endpoint.

support_url: https://support.signalfx.com/hc/en-us
  # (Optional) A specific URL of your own for this extension.
  # Defaults to the url setting in your publisher profile.

source_url: https://github.com/signalfx/kong-plugin-signalfx
  # (Optional) If your extension is open source, provide a link to your code.

license_type: Apache-2.0
  # (Optional) For open source, use the abbreviations in parentheses at:
  # https://opensource.org/licenses/alphabetical

license_url: https://github.com/signalfx/kong-plugin-signalfx/blob/master/LICENSE
  # (Optional) Link to your custom license.

#privacy_policy:
  # (Optional) If you have a custom privacy policy, place it here

privacy_policy_url: https://signalfx.com/privacy-policy/
  # (Optional) Link to a remote privacy policy

#terms_of_service:
  # (Optional) Text describing your terms of service.

terms_of_service_url: https://signalfx.com/terms-and-conditions/
  # (Optional) Link to your online TOS.

# COMPATIBILITY
# In the following sections, list Kong versions as array items
# Versions are categorized by Kong edition and their known compatibility.
# Unlisted Kong versions will be noted as "unknown" compatibility.
# Uncomment at least one of 'community_edition' or 'enterprise_edition'.
# Add array-formatted lists of versions under their appropriate subsection.

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


#########################
# PLUGIN-ONLY SETTINGS below this line
# If your extension is a plugin, ALL of the following lines must be completed.
# If NOT an plugin, delete all lines up to '# BEGIN MARKDOWN CONTENT'

params: # metadata about your plugin
  name: signalfx # name of the plugin in Kong (may differ from name: above)
  api_id: true
    # boolean - whether this plugin can be applied to an API [[this needs more]]
  service_id: true
    # boolean - whether this plugin can be applied to a Service.
    # Affects generation of examples and config table.
  consumer_id: true
    # boolean - whether this plugin can be applied to a Consumer.
    # Affects generation of examples and config table.
  route_id: true
    # whether this plugin can be applied to a Route.
    # Affects generation of examples and config table.

  config: # Configuration settings for your plugin
    - name: aggregate_by_http_method # setting name
      required: yes # string - setting required status
        # options are 'yes', 'no', or 'semi'
        # 'semi' means dependent on other settings
      default: true # any type - the default value (non-required settings only)
      value_in_examples:
        # If the field is to appear in examples, this is the value to use.
        # A required field with no value_in_examples entry will resort to
        # the one in default.
      description: |
        By default, metrics for each Service/API-fielded request cycle will be aggregated by a context determined partially by the request's HTTP method and by its response's status code.
        If you are monitoring a large infrastructure with hundreds of routes, grouping by HTTP method can be too granular or costly for performant ``/signalfx` requests on a 1s interval, depending on the server resources.
        This context grouping can be disabled with the boolean configuration option `aggregate_by_http_method`.

  #  - name: # add additional setting blocks as needed, each demarcated by -
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

### Installation and configuration

See details on https://github.com/signalfx/kong-plugin-signalfx and https://github.com/signalfx/collectd-kong.
