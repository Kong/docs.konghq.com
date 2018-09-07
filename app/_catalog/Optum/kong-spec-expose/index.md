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

name: Kong Spec Expose # (required) The name of your extension.
  # Use capitals and spaces as needed.

categories: # (required) Uncomment all that apply.
  #- authentication
  - security
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

desc: Expose OAS/Swagger/etc. specifications of auth protected APIs proxied by Kong
description: |
  This plugin will expose the OpenAPI Spec (OAS), Swagger, or other specification of auth protected API services fronted by the Kong gateway.

  API providers need a means of exposing the specifications of their services while maintaining authentication on the service itself - this plugin solves this problem by:

  1. Plugin enables Kong Admin to specify the endpoint of their API specification.

  2. Plugin will validate the Proxy request is GET method, and will validate the proxy request ends with "/specz". If these two requirements are met, the endpoint will return the specification of the API Service with Content-Type header identical to what the API Service exposes.

# (required) extended description.
# Use YAML piple notation for extended entries.

support_url: https://github.com/Optum/kong-spec-expose/issues
  # (Optional) A specific URL of your own for this extension.
  # Defaults to the url setting in your publisher profile.

source_url: https://github.com/Optum/kong-spec-expose/
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
  #(Optional) Text describing your terms of service.

#terms_of_service_url:
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
      - 0.14.x
      - 0.13.x
      - 0.12.x
    incompatible:
      - 0.11.x
      - 0.10.x
      - 0.9.x
      - 0.8.x
      - 0.7.x
      - 0.6.x
      - 0.5.x
      - 0.3.x
      - 0.2.x
  enterprise_edition:
    compatible:
      - 0.34-x
      - 0.33-x
      - 0.32-x
      - 0.31-x
      - 0.30-x
    incompatible:
      - 0.29-x


#########################
# PLUGIN-ONLY SETTINGS below this line
# If your extension is a plugin, ALL of the following lines must be completed.
# If NOT an plugin, delete all lines up to '# BEGIN MARKDOWN CONTENT'

params: # metadata about your plugin
  name: kong-spec-expose # name of the plugin in Kong
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
    - name: spec_url
      required: true
      value_in_examples: https://github.com/OAI/OpenAPI-Specification/blob/master/examples/v2.0/json/petstore.json
      urlencode_in_examples: false
      default:
      description: The full path to the specification/documentation of your service.

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

Recommended:

```
$ luarocks install kong-spec-expose
```

Other:

```
$ git clone https://github.com/Optum/kong-spec-expose.git /path/to/kong/plugins/kong-spec-expose
$ cd /path/to/kong/plugins/kong-spec-expose
$ luarocks make *.rockspec
```

### Maintainers

[jeremyjpj0916](https://github.com/jeremyjpj0916)  
[rsbrisci](https://github.com/rsbrisci)  

Feel free to [open issues](https://github.com/Optum/kong-spec-expose/issues), or refer to our [Contribution Guidelines](https://github.com/Optum/kong-spec-expose/blob/master/CONTRIBUTING.md) if you have any questions.
