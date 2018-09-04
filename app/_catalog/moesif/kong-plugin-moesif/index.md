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

name: Moesif API Insights # (required) The name of your extension.
  # Use capitals and spaces as needed.
id: kong-plugin-moesif # a slug-formatted string to represent your extension
  # Use only lowercase letters, numerals, and hyphens (-).

categories: # (required) Uncomment all that apply.
  #- authentication
  #- security
  #- traffic-control
  #- severless
  - analytics-monitoring
  #- transformations
  - logging
# Array format only; uncomment one or more applicable categories.
# If you would like to add a category, you may do so here.

type: plugin # (required) String or Array of strings if multiple fit.
 # options:
  # plugin          | extensions of the core platform
  # integration     | extensions of the Kong Admin API
  # dev-mod         | enhancements of the Long dev portal

desc: AI-powered analytics and monitoring for APIs  # (required) 1-liner description; max 80 chars
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
  # (Optional) A specific URL of your own for this extension.
  # Defaults to the url setting in your publisher profile.

source_url: https://github.com/Moesif/kong-plugin-moesif
  # (Optional) If your extension is open source, provide a link to your code.

# license_type:
  # (Optional) For open source, use the abbreviations in parentheses at:
  # https://opensource.org/licenses/alphabetical

license_url: https://raw.githubusercontent.com/Moesif/moesif-express/master/LICENSE
  # (Optional) Link to your custom license.

privacy_policy_url: https://www.moesif.com/privacy
  # (Optional) Link to a remote privacy policy

terms_of_service_url: https://www.moesif.com/terms
  # (Optional) Link to your online TOS.

# COMPATIBILITY
# In the following sections, list Kong versions as array items
# Versions are categorized by Kong edition and their known compatibility.
# Unlisted Kong versions will be noted as "unknown" compatibility.
# Uncomment at least one of 'community_edition' or 'enterprise_edition'.
# Add array-formatted lists of versions under their appropriate subsection.

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

#########################
# PLUGIN-ONLY SETTINGS below this line
# If your extension is a plugin, ALL of the following lines must be completed.
# If NOT an plugin, delete all lines up to '# BEGIN MARKDOWN CONTENT'

params: # metadata about your plugin
  name: kong-plugin-moesif
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
luarocks install kong-plugin-moesif
```

### Kong process errors

This logging plugin will only log HTTP request and response data. If you are looking for the Kong process error file (which is the nginx error file), then you can find it at the following path: FIXME
