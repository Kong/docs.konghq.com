---
name: Reedelk Transformer

publisher: codecentric AG

categories:
  - transformations

type:
  plugin        

desc: Kong plugin to transform Reedelk requests and responses

description: |
  The Reedelk Transformer plugin transforms the upstream request body or
  downstream response body by invoking a Reedelk REST flow before hitting the
  upstream server, or before sending the downstream response back to the client.
  The plugin can apply both upstream and downstream transformations in the same flow.

support_url: https://github.com/codecentric/kong-plugin-reedelk-transformer/issues
  # (Optional) A specific URL of your own for this extension.
  # Defaults to the url setting in your publisher profile.

source_code: https://github.com/codecentric/kong-plugin-reedelk-transformer

license_type: Apache-2.0
  # (Optional) For open source, use the abbreviations in parentheses at:
  # https://opensource.org/licenses/alphabetical

license_url: https://github.com/codecentric/kong-plugin-reedelk-transformer/blob/master/LICENSE.txt

kong_version_compatibility:
  community_edition:
    compatible:
      - 2.1.x
      - 2.0.x
      - 1.5.x
  enterprise_edition:
    compatible:
     - 1.5.x

###############################################################################
# END YAML DATA

###############################################################################
# BEGIN MARKDOWN CONTENT
---
