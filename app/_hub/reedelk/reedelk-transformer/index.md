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

name: Reedelk Transformer

publisher: Reedelk

categories:
  - transformations

type:
  plugin        

desc: # (required) 1-liner description; max 80 chars
description: |
  The Reedelk transformer plugin allows transforming the upstream request body or
  downstream response body by invoking a Reedelk REST flow before hitting the
  upstream server, or before sending the downstream response back to the client.
  The plugin allows applying upstream and downstream transformations together as well.

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

kong_version_compatibility: # required
  #community_edition: # optional
    #compatible:
  enterprise_edition:
    compatible:
      - 2.1.x
      - 1.5.x

#########################
# PLUGIN-ONLY SETTINGS below this line
# If your plugin is an extension of the core platform, ALL of the following
# lines must be completed.
# If NOT defined as a 'plugin' in line 32, delete all lines up to '# BEGIN MARKDOWN CONTENT'

params: # metadata about your plugin
  name: reedelk-transformer
  api_id:
    # boolean - whether this plugin can be applied to an API [[this needs more]]
  service_id: true
  consumer_id:
    # boolean - whether this plugin can be applied to a Consumer.
    # Affects generation of examples and config table.
  route_id: true
  protocols: ["http", "https"]
  dbless_compatible: yes
  dbless_explanation:
    # Optional free-text explanation, usually containing details about the degree of
    # compatibility with DB-less.

  config: # Configuration settings for your plugin
    - name: upstream_transformer_url
      required: no
      default: # any type - the default value (non-required settings only)
      value_in_examples: http://myhost/upstream/transform
      description:
        The URL of the Reedelk REST flow endpoint to be invoked for the Upstream
        request transformation.

    - name: downstream_transformer_url
      required: no
      default: # any type - the default value (non-required settings only)
      value_in_examples: http://myhost/downstream/transform
      description:
        The URL of the Reedelk REST flow endpoint to be invoked for the Downstream
        request transformation.
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

## Your first heading will go here
