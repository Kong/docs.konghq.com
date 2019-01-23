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

name: API Fortress HTTP Log

publisher: API Fortress

categories: 
  - logging

type: 
  plugin          | extensions of the core platform

desc: Record mock responses with API Fortress.
description:  | 
  The objective of this plugin is to provide a way to capture complete HTTP requests and responses (including the request and response bodies as required) as they transit the Kong API Gateway. Once the data is captured, the plugin will send it to a specified endpoint via HTTP.

#support_url:
  # (Optional) A specific URL of your own for this extension.
  # Defaults to the url setting in your publisher profile.

source_url:
  https://github.com/apifortress/fortress-http-log

license_type:
  Apache-2.0

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
# In the following sections, list Kong versions as array items.
# Versions are categorized by Kong edition and their known compatibility.
# Unlisted Kong versions will be considered to have "unknown" compatibility.
# Uncomment at least one of 'community_edition' or 'enterprise_edition'.
# Add array-formatted lists of versions under their appropriate subsection.

kong_version_compatibility: # required
  community_edition: # optional
    compatible:
      - 0.14.x
    #incompatible:
  #enterprise_edition: # optional
    #compatible:
    #incompatible:

#########################
# PLUGIN-ONLY SETTINGS below this line
# If your extension is a plugin, ALL of the following lines must be completed.
# If NOT an plugin, delete all lines up to '# BEGIN MARKDOWN CONTENT'

params: # metadata about your plugin
  name: Fortress-HTTP-Log
  api_id: True
  service_id: True
  consumer_id: True
  route_id: True

  config: # Configuration settings for your plugin
    - name: http_endpoint
      required: yes
      default: 
      value_in_examples:
      description: The endpoint to send data to
    - name: timeout
      required: yes
      default: ms
      value_in_examples:
      description: The request timeout for the connection to http_endpoint
    - name: keepalive
      required: yes
      default: ms
      value_in_examples:
      description: For how long should the plugin keep the connection alive.
    - name: log_bodies
      required: yes
      default: false
      value_in_examples:
      description: Set to true if you want to log request/response bodies.
    - name: api_key
      required: no
      default: 
      value_in_examples:
      description: The value for defining x-api-key header. (APIF-Specific)
    - name: secret
      required: no
      default:
      value_in_examples:
      description: The value for defining the x-secret header (APIF-Specific)
    - name: mock_domain
      required: no
      default:
      value_in_examples:
      description: The value for defining the x-mock-domain header. Set this value if you're using the plugin to create mock responses in API Fortress (APIF-Specific)
    - name: mock_log_all
      required: no
      default: 
      value_in_examples:
      description: The value for defining the x-log-all header. Set this value if you're using the plugin to create mock response in API Fortress. If set, API Fortress will log each call separately and avoid overwrites. (APIF-Specific)
    - name: mock_criterion_headers
      required: no
      default: 
      value_in_examples:
      description: The value for defining the x-mock-criterion-headers. Set this value if you're using the plugin to create mock responses in API Fortress. If set, API Fortress will use this list of headers to create expression filters. (APIF-Specific)
    - name: enable_on_header
      required: no
      default: 
      value_in_examples:
      description: If set with a header name as the value, the plugin will only operate if that header is present in the request.
    - name: disable_on_header
      required: no
      default: 
      value_in_examples:
      description: If set with a header name as the value, the plugin will disable itself if that header is present in the request. Note - This setting has higher priority than enable_on_header.

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

## Using the Plugin with API Fortress

To use the API Fortress/Kong Plugin to record mock endpoints and monitor traffic, take a look at the documentation, located here:

[Documentation](https://apifortress.com/doc/mock-recording-with-kong/)
