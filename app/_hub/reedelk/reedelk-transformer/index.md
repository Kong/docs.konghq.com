---
name: Reedelk Transformer

publisher: Reedelk

categories:
  - transformations

type:
  plugin        

desc: Transform Upstream request body, Downstream response body, or both in an invoked
       Reedelk REST flow
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

params:
  name: reedelk-transformer
  api_id: false
  service_id: true
  consumer_id: false
  route_id: true
  protocols: ["http", "https"]
  dbless_compatible: yes
  dbless_explanation:

  config:
    - name: upstream_transformer_url
      required: no
      default:
      value_in_examples: http://myhost/upstream/transform
      description:
        The URL of the Reedelk REST flow endpoint to be invoked for the Upstream
        request transformation.

    - name: downstream_transformer_url
      required: no
      default:
      value_in_examples: http://myhost/downstream/transform
      description:
        The URL of the Reedelk REST flow endpoint to be invoked for the Downstream
        request transformation.

  extra:
    The `upstream_transformer_url` and `downstream_transformer_url` are the URLs
    of the Reedelk REST flow endpoint to invoke for the upstream/downstream
    request/response transformations; e.g., http://localhost:8888/apiabledev/transform.
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

## installation
