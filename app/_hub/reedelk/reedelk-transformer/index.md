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

source_url: https://github.com/reedelk/kong-plugin-reedelk-transformer

license_type: Apache-2.0
  # (Optional) For open source, use the abbreviations in parentheses at:
  # https://opensource.org/licenses/alphabetical

license_url: https://github.com/reedelk/kong-plugin-reedelk-transformer/blob/master/LICENSE.txt

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
        The URL of the Reedelk REST flow endpoint to invoke for the Upstream
        request transformation.

    - name: downstream_transformer_url
      required: no
      default:
      value_in_examples: http://myhost/downstream/transform
      description:
        The URL of the Reedelk REST flow endpoint to invoke for the Downstream
        request transformation.

  extra:
    The `upstream_transformer_url` and `downstream_transformer_url` are the URLs
    of the Reedelk REST flow endpoint to invoke for the Upstream/Downstream
    request/response transformations; e.g., `http://localhost:8888/apiabledev/transform`.
###############################################################################
# END YAML DATA

###############################################################################
# BEGIN MARKDOWN CONTENT
---

## Installation

### Prerequisites

To use the Reedelk plugin for Kong, you must first install the Reedelk IntelliJ
IDEA flow designer plugin:

- **IntelliJ Marketplace**: From **IntelliJ Preferences > Plugin > Marketplace**,
  search for `Reedelk`, install the plugin, and restart IntelliJ.

- **Manual install**: From **IntelliJ Preferences > Plugin > Settings icon >
  Install Plugin From Disk**, and restart IntelliJ.

Also, the LuaRocks package manager must be installed. See
https://github.com/luarocks/luarocks/wiki/Download.

### Install Steps

1. Clone the `kong-plugin-reedelk-transformer`:

   ```bash
      git clone https://github.com/reedelk/kong-plugin-reedelk-transformer.git
      cd kong-plugin-reedelk-transformer
   ```

2. Install the module `kong-plugin-reedelk-transformer`:

   ```bash
   luarocks install kong-plugin-reedelk-transformer-0.1.0-1.all.rock
   ```

3. Add the custom plugin to `kong.conf`:

   ```
   plugins = ...,reedelk-transformer
   ```

4. Restart Kong.
