---
# This file is for profiling an individual Kong extension.
# Duplicate this file in your own *publisher path* on your own branch.
# Your publisher path is relative to _app/_hub/.
# The path must consist only of alphanumeric characters and hyphens (-).
#
# The following YAML data must be filled out as prescribed by the comments
# on individual parameters. Also see documentation at:
# https://github.com/Kong/docs.konghq.com
# Remove inapplicable entries and superfluous comments as needed

name: Google Analytics Log
  # Use capitals and spaces as needed.
publisher: Yes Interactive
  # Use capitals and spaces as needed.
  # If you are an individual, you might choose to use your GitHub handle, or your name.
  # If this is being published and supported by a company, please use your company name.
  # Note that every extension by a given publisher must have the exact same value

categories: # (required) Uncomment all that apply.
  #- authentication
  #- security
  #- traffic-control
  #- serverless
  #- analytics-monitoring
  #- transformations
  - logging
  #- deployment
# Array format only; uncomment the one most-applicable category. Contact cooper@konghq.com to propose a new category, if necessary.

type: plugin
  # plugin          | extensions of the core platform
  # integration     | extensions of the Kong Admin API

desc: Log API transactions to Google Analytics
description: This plugin logs your Kong gateway transactions to Google Analytics. Plugin is a modification of the Kong HTTP Log plugin.

support_url: https://github.com/yesinteractive/kong-log-google/issues

source_url: https://github.com/yesinteractive/kong-log-google

license_type: MIT

kong_version_compatibility:
  community_edition:
    compatible:
      - 2.0-x
      - 1.5-x
      - 1.4-x
      - 1.3-x
  enterprise_edition:
    compatible:
      - 1.5-x
      - 1.3-x
params:
  name: kong-spec-expose
  api_id: true
  service_id: true
  consumer_id: false
  route_id: true

params: 
  name: kong-log-google
  api_id: false
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
  protocols: ["http", "https"]
    # List of protocols this plugin is compatible with.
    # Valid values: "http", "https", "tcp", "tls"
    # Example: ["http", "https"]
  dbless_compatible: true
    # Degree of compatibility with DB-less mode. Three values allowed:
    # 'yes', 'no' or 'partially'
  dbless_explanation: Fully compatible with DB and DB-less (K8s, Declarative) Kong implementations.
    # Optional free-text explanation, usually containing details about the degree of
    # compatibility with DB-less.
    
  config:
    - name: tid
      required: yes
      default: UA-XXXX-Y
      value_in_examples: UA-XXXX-Y
      description: The tracking ID / property ID. The format is UA-XXXX-Y. All collected data is associated by this ID.
    - name: cid
      required: yes
      default: 555
      value_in_examples: 555
      description: Client ID. This allows you to set and identify metrics in Google Analytics by a custom client ID.

  #  - name: # add additional setting blocks as needed, each demarcated by -
  extra: 
    # This is for additional remarks about your configuration.
###############################################################################
# END YAML DATA
# Beneath the next --- use Markdown (redcarpet flavor) and HTML formatting only.
#
# The remainder of this file is for free-form description, instruction, and
# reference matter.
# If you include headers, your headers MUST start at Level 2 (parsing to
# h2 tag in HTML). Heading Level 2 is represented by ## notation
# preceding the header text. Subsequent headings,
# if you choose to use them, must be properly nested (eg. heading level 2 may
# be followed by another heading level 2, or by heading level 3, but must NOT be
# followed by heading level 4)
###############################################################################
# BEGIN MARKDOWN CONTENT
---

## Installation & Usage

A tutorial, installation steps and further information can be found at [https://github.com/yesinteractive/kong-log-google](https://github.com/yesinteractive/kong-log-google).
