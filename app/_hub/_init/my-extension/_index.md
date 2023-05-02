---
# This file is for documenting an individual Kong plugin.
#
# 1. Duplicate this file in your own *publisher path* on your own branch.
# Your publisher path is relative to app/_hub/.
# The path must consist only of alphanumeric characters and hyphens (-).
#
# 2. (Kong Inc. internal plugins only) Duplicate the versions.yml file into your new plugin directory.
# Set the Kong Gateway version that the plugin is being added to.

# 3. Add a 64x64px icon for the plugin to app/_assets/images/icons/hub.
# The name of the file must be in the following format: <publisher>_<plugin-directory-name>.png
# For example, for the rate limiting plugin the icon name is kong-inc_rate-limiting.png
# If your plugin doesn't have an icon yet, you can duplicate the default_icon.png file.
#
# 4. Fill in the template in this file.
#
# The following YAML data must be filled out as prescribed by the comments
# on individual parameters. Also see documentation at:
# https://github.com/Kong/docs.konghq.com/app/_hub for examples.
# Remove inapplicable entries and comments as needed.

name: # (required) The name of your plugin.
  # Use capitals and spaces as needed.
publisher: # (required) The name of the entity publishing this plugin.
  # Use capitals and spaces as needed.
  # If you are an individual, you might choose to use your GitHub handle, or your name.
  # If this is being published and supported by a company, please use your company name.
  # Note that every plugin by a given publisher must have the exact same value.

categories: # (required) Uncomment ONE that applies.
  #- authentication
  #- security
  #- traffic-control
  #- serverless
  #- analytics-monitoring
  #- transformations
  #- logging
  #- deployment
# Array format only; if your plugin applies to multiple categories,
# uncomment the most applicable category.

type: # (required) String, one of:
  # plugin          | extensions of the core platform
  # integration     | extensions of the Kong Admin API

desc: # (required) 1-liner description; max 80 chars
description: #|
  # (required) extended description.
  # Use YAML pipe notation for extended entries.
  # EXAMPLE long text format (do not use this entry)
  # description: |
  #   Maintain an indentation of two (2) spaces after denoting a block with
  #   YAML pipe notation.
  #
  #   Lorem Ipsum is simply dummy text of the printing and typesetting
  #   industry. Lorem Ipsum has been the industry's standard dummy text ever
  #   since the 1500s.

#support_url:
  # (Optional) A specific URL of your own for this extension.
  # Defaults to the url setting in your publisher profile.

#source_code:
  # (Optional) If your extension is open source, provide a link to your code.

#license_type:
  # (Optional) For open source, use the abbreviations in parentheses at:
  # https://opensource.org/licenses/alphabetical

#license_url:
  # (Optional) Link to your custom license.

#privacy_policy:
  # (Optional) If you have a custom privacy policy, place it here

#privacy_policy_url:
  # (Optional) Link to a remote privacy policy

#terms_of_service:
  # (Optional) Text describing your terms of service.

#terms_of_service_url:
  # (Optional) Link to your online TOS.

# COMPATIBILITY
# Uncomment at least one of 'community_edition' (Kong Gateway open-source) or
# 'enterprise_edition' (Kong Gateway Enterprise) and set `compatible: true`.

kong_version_compatibility: # required
  #community_edition: # optional
    #compatible: true
  #enterprise_edition: # optional
    #compatible: true

# SUBSCRIPTION TIERS (KONG INC PLUGINS ONLY)
# Set the subscription tiers that your plugin is restricted to.
# If your plugin is free/open-source, set `false` for both the enterprise and plus tiers.

enterprise: # (Kong Inc internal plugins only) Boolean
  # Specifies if your plugin is an Enterprise-tier plugin.
  # Set true if only available in Enterprise, or false if available in other tiers.

plus: # (Kong Inc internal and Konnect only) Boolean
  # Specifies if your plugin is a Plus-tier plugin in Konnect.
  # Set true if the plugin is available in the Plus and Enterprise tiers, or false if available for free/in open-source.


#########################
# PLUGIN-ONLY SETTINGS below this line
# If your plugin is an extension of the core platform, ALL of the following
# lines must be completed.
# If NOT defined as a 'plugin' in line 32, delete all lines up to '# BEGIN MARKDOWN CONTENT'

params: # Metadata about your plugin
  name: # Name of the plugin in Kong (may differ from name: above)
  service_id: # Boolean
    # Specifies whether this plugin can be applied to a Service.
    # Affects generation of examples and config table.
  consumer_id: # Boolean
    # Specifies whether this plugin can be applied to a Consumer.
    # Affects generation of examples and config table.
  route_id: # Boolean
    # Specifies whether this plugin can be applied to a Route.
    # Affects generation of examples and config table.
  protocols:
    # List of protocols this plugin is compatible with, in array format.
    # Valid values: "http", "https", "tcp", "tls", "tls_passthrough", "grpc",
    # "grpcs", "udp", "ws", and "wss".
    # Example:
    # - name: http
    # - name: https
  dbless_compatible:
    # Degree of compatibility with DB-less mode. Three values allowed:
    # 'yes', 'no' or 'partially'.
  dbless_explanation:
    # Optional free-text explanation, usually containing details about the degree of
    # compatibility with DB-less.
  yaml_examples: # Boolean
    # Enables or disables autogenerated examples in declarative YAML
    # format. Default is `true`; set to `false` to disable only declarative
    # YAML examples.
  k8s_examples: # Boolean
    # Enables or disables autogenerated examples in Kubernetes YAML
    # format. Default is `true`; set to `false` to disable only K8s examples.
  konnect_examples: # Boolean
    # Enables or disables autogenerated examples for the Konnect UI
    # Default is `true`; set to `false` to disable only Konnect UI examples.
  manager_examples: # Boolean
    # Enables or disables autogenerated examples for the Kong Manager UI
    # Default is `true`; set to `false` to disable only Kong Manager UI examples.
  examples: # Boolean
    # Enables or disables all autogenerated examples (cURL, YAML, and
    # Kubernetes). Default is `true`; set to `false` to disable ALL
    # autogenerated examples.

  config: # Configuration settings for your plugin
    - name: # Parameter name
      required: # String - set required status
        # options are 'yes', 'no', or 'semi'
        # 'semi' means dependent on other settings
      default: # Any type - the default value (non-required settings only)
      datatype: # Specify the type of the value: e.g., string, array, boolean, etc.
      encrypted: # Boolean - specify whether this value can be keyring-encrypted in Kong Enterprise
      value_in_examples:
        # If the field is to appear in examples, this is the value to use.
        # A required field with no value_in_examples entry will resort to
        # the one in default.
        # If providing an array, use the following format: [ "value1", "value2" ].
      minimum_version:
        # Set the first major Kong Gateway version that this parameter appears in.
        # For example: "2.1.0"
      maximum_version:
        # Optional field.
        # If this parameter has been deprecated and removed from the plugin,
        # set the last major Kong Gateway version that this value appears in.
        # For example: "2.8.0"
      description:
        # Explain what this setting does.
        # Use YAML's pipe (|) notation for longer entries.

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

## Usage
<!-- Any information that the user needs to know about using this plugin:
examples, limitations, use cases, etc. -->

## Changelog

<!-- Add a changelog entry in the following format for every change to the plugin:

**Kong Gateway <version number>**

* Added X parameter for doing XYZ.
* Removed the deprecated Z parameter.
-->
