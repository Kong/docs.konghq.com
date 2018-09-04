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

name: Upstream HTTP Basic Authentication # (required) The name of your extension.
  # Use capitals and spaces as needed.
id: upstream-auth-basic # a slug-formatted string to represent your extension
  # Use only lowercase letters, numerals, and hyphens (-).

categories: # (required) Uncomment all that apply.
  - authentication
  #- security
  #- traffic-control
  #- serverless
  #- analytics-monitoring
  #- transformations
  #- logging
# Array format only; uncomment one or more applicable categories.
# If you would like to add a category, you may do so here.

type: plugin # (required) String or Array of strings if multiple fit.
# options:
  # plugin          | extensions of the core platform
  # api-integration | extensions of the Kong Admin API
  # dev-mod         | enhancements of the Long dev portal
# for multiple, list like so: [api-integration,dev-mod]

desc: Add HTTP Basic Authentication header to upstream service request # (required) 1-liner description; max 80 chars
description: |
  Kong Plugin to add HTTP Basic Authentication to the upstream request header.

support_url: https://github.com/revolsys/kong-plugin-upstream-auth-basic/issues
  # (Optional) A specific URL of your own for this extension.
  # Defaults to the url setting in your publisher profile.

source_url: https://github.com/revolsys/kong-plugin-upstream-auth-basic
  # (Optional) If your extension is open source, provide a link to your code.

license_type: Apache-2.0
  # (Optional) For open source, use the abbreviations in parentheses at:
  # https://opensource.org/licenses/alphabetical

#license_url:
  # (Optional) Link to your custom license.

#privacy_policy:
  # (Optional) If you have a custom privacy policy, place it here

#privacy_policy_url:
  # (Optional) Link to a remote privacy policy

#terms_of_service: |
  # (Optional) Text describing your terms of service.

#terms_of_service_url:
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


  # If your plugin uses the old API, change this to true

params: # metadata about your plugin
  name: upstream-auth-basic # name of the plugin in Kong
  api_id: true
    # boolean - whether this plugin can be applied to an API [[this needs more]]
  service_id: true
    # boolean - whether this plugin can be applied to a Service.
    # Affects generation of examples and config table.
  consumer_id: false
    # boolean - whether this plugin can be applied to a Consumer.
    # Affects generation of examples and config table.
  route_id: true
    # whether this plugin can be applied to a Route.
    # Affects generation of examples and config table.

  config:
    - name: username
      required: true
      value_in_examples: kingkong
      urlencode_in_examples:
      default:
      description: The username to send in the Authorization header to the upstream service
    - name: password
      required: true
      value_in_examples: 1-big-ape
      urlencode_in_examples:
      default:
      description: The password to send in the Authorization header to the upstream service
  #extra: If I had more to say about the configuration of this plugin, I'd say it here.
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

### Installation

1. The [LuaRocks](http://luarocks.org) package manager must be [Installed](https://github.com/luarocks/luarocks/wiki/Download).
2. [Kong](https://konghq.com) must be [Installed](https://konghq.com/install/) and you must be familiar with using and configuring Kong.
3. Install the module kong-plugin-upstream-auth-basic.

```
luarocks install kong-plugin-upstream-auth-basic
```

4. Add the custom plugin to the `kong.conf` file (e.g. `/etc/kong/kong.conf`)

```
custom_plugins = ...,upstream-auth-basic
```

5. Restart kong
