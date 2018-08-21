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

name: # (required) The name of your extension.
  # Use capitals and spaces as needed.
id: # a slug-formatted string to represent your extension
  # Use only lowercase letters, numerals, and hyphens (-).

#header_icon: #FIXME # (optional) Uncomment only if you are submitting an icon
  # See icon submission instructions in the README.

categories: # (required) Uncomment all that apply.
  #- authentication
  #- security
  #- traffic-control
  #- severless
  #- analytics-monitoring
  #- transformations
  #- logging
# Array format only; uncomment one or more applicable categories.
# If you would like to add a category, you may do so here.

type: # (required) String, one of:
  # plugin          | extensions of the core platform
  # api-integration | extensions of the Kong Admin API
  # dev-mod         | enhancements of the Kong dev portal

desc: # (required) 1-liner description; max 80 chars
description: #|
  # (required) extended description.
  # Use YAML piple notation for extended entries.
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

#source_url:
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
# In the following sections, list Kong versions as array items
# Versions are categorized by Kong edition and their known compatibility.
# Unlisted Kong versions will be noted as "unknown" compatibility.
# Uncomment at least one of 'community_edition' or 'enterprise_edition'.
# Add array-formatted lists of versions under their appropriate subsection.

kong_version_compatibility: # required
  #community_edition: # optional
    #compatible:
    #incompatible:
  #enterprise_edition: # optional
    #compatible:
    #incompatible:

# EXAMPLE kong_version_compatibility blocks
# EXAMPLE 1
# kong_version_compatibility:
#   community_edition:
#     compatible:
#       - 0.13
#       - 0.14
#     incompatible:
#       - 0.12
#   enterprise_edition:
#     compatible:
#       - 0.33
#       - 0.34
#     incompatible:
#       - 0.32
#
# EXAMPLE 2
#   enterprise_edition:
#     compatible:
#       - 0.33
#       - 0.34


#########################
# PLUGIN-ONLY SETTINGS below this line
# If your extension is a plugin, ALL of the following lines must be completed.
# If NOT an plugin, delete all lines up to '# BEGIN MARKDOWN CONTENT'

params: # metadata about your plugin
  name: # name of the plugin in Kong
  api_id:
    # boolean - whether this plugin can be applied to an API [[this needs more]]
  service_id:
    # boolean - whether this plugin can be applied to a Service.
    # Affects generation of examples and config table.
  consumer_id:
    # boolean - whether this plugin can be applied to a Consumer.
    # Affects generation of examples and config table.
  route_id:
    # whether this plugin can be applied to a Route.
    # Affects generation of examples and config table.

  config: # Configuration settings for your plugin
    - name: # setting name
      required: # string - setting required status
        # options are 'yes', 'no', or 'semi'
        # 'semi' means dependent on other settings
      default: # any type - the default value (non-required settings only)
      value_in_examples:
        # If the field is to appear in examples, this is the value to use.
        # A required field with no value_in_examples entry will resort to
        # the one in default.
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
# Your headers must be Level 3 or 4 (parsing to h3 or h4 tags in HTML).
# This is represented by ### or #### notation preceding the header text.
###############################################################################
# BEGIN MARKDOWN CONTENT
---

### Your first heading will go here
