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

name: Kong Splunk Log # (required) The name of your extension.
  # Use capitals and spaces as needed.

categories: # (required) Uncomment all that apply.
  #- authentication
  #- security
  #- traffic-control
  #- serverless
  #- analytics-monitoring
  #- transformations
  - logging
# Array format only; uncomment one or more applicable categories.
# If you would like to add a category, you may do so here.

type: plugin # (required) String or Array of strings if multiple fit.
# options:
  # plugin          | extensions of the core platform
  # api-integration | extensions of the Kong Admin API
  # dev-mod         | enhancements of the Long dev portal
# for multiple, list like so: [api-integration,dev-mod]

desc: Log API transactions to Splunk using the Splunk HTTP collector # (required) 1-liner description; max 80 chars
description: |
  Kong provides many great logging tools out of the box - this is a modified version of the Kong HTTP logging plugin that has been refactored and tailored to work with Splunk.

# (required) extended description.
# Use YAML piple notation for extended entries.

support_url: https://github.com/Optum/kong-splunk-log/issues
  # (Optional) A specific URL of your own for this extension.
  # Defaults to the url setting in your publisher profile.

source_url: https://github.com/Optum/kong-splunk-log
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
  name: kong-splunk-log # name of the plugin in Kong
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
    - name: splunk_access_token
      required: true
      value_in_examples: aaaaaaaa-bbbb-cccc-dddd-ffffffffffff
      urlencode_in_examples: false
      default:
      description: Passes required Splunk header `Authorization Splunk:aaaaaaaa-bbbb-cccc-dddd-ffffffffffff`
    - name: method
      required: false
      value_in_examples: POST
      urlencode_in_examples: false
      default: POST
      description: HTTP Method to send to Splunk
    - name: content_type
      required: false
      value_in_examples: application/json
      urlencode_in_examples: false
      default: application/json
      description: Defines the Content-Type header to send to Splunk
    - name: timeout
      required: false
      value_in_examples: 10000
      urlencode_in_examples: false
      default: 10000
      description: The amount of time to wait on a Splunk transaction before timing out
    - name: keepalive
      required: false
      value_in_examples: 60000
      urlencode_in_examples: false
      default: 60000
      description: The amount of time to keep plugin connections with Splunk active
  extra: We recommend enabling the Splunk Logging plugin at a global level.

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

### Example Log in Splunk UI

![Splunk UI screen shot](https://konghq.com/wp-content/uploads/2018/09/SplunkLogSample.png)

### Installation

Recommended:

```
$ luarocks install kong-splunk-log
```

Other:

```
$ git clone https://github.com/Optum/kong-splunk-log.git /path/to/kong/plugins/kong-splunk-log
$ cd /path/to/kong/plugins/kong-splunk-log
$ luarocks make *.rockspec
```

### Configuration

The plugin requires an environment variable `SPLUNK_HOST`. This is how we define the `host=""` Splunk field in the example log picture embedded above in our README.

#### Example Plugin Configuration

![Splunk Config](https://konghq.com/wp-content/uploads/2018/09/SplunkConfig.png)

If not already set, it can be done so as follows:

```
$ export SPLUNK_HOST="gateway.company.com"
```

**One last step** is to make the environment variable accessible by an nginx worker. To do this, simply add this line to your _nginx.conf_

```
env SPLUNK_HOST;
```

### Maintainers

[jeremyjpj0916](https://github.com/jeremyjpj0916)  
[rsbrisci](https://github.com/rsbrisci)  

Feel free to [open issues](https://github.com/Optum/kong-splunk-log/issues), or refer to our [Contribution Guidelines](https://github.com/Optum/kong-splunk-log/blob/master/CONTRIBUTING.md) if you have any questions.
