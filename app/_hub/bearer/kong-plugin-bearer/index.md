---
name: Bearer
publisher: Bearer

categories: 
  - security
  - analytics-monitoring

type: plugin

desc: Remediate security & compliance risks by automatically mapping your data flows  

description: |
  [Bearer](https://bearer.sh?utm_medium=docs&utm_campaign=partners&utm_source=kong) helps security teams remediate security and compliance risks by discovering, managing, and securing their API usage.

	The Bearer Kong plugin allows you:

  * Instantly catalog your APIs.
  * Automatically map data flows to and from your APIs.

  The plugin leverages an asynchronous design to minimize its impact on the latency of your API calls. It has low CPU and memory consumption. 

	If you need help with installation, drop us a line at support@bearer.sh or contact us [here](https://www.bearer.sh/demo?utm_medium=docs&utm_campaign=partners&utm_source=kong).

support_url: https://www.bearer.sh/product?utm_medium=docs&utm_campaign=partners&utm_source=kong

source_url: https://github.com/Bearer/kong-plugin

license_url: https://raw.githubusercontent.com/Bearer/kong-plugin/main/LICENSE

privacy_policy_url: https://www.iubenda.com/privacy-policy/65368465?utm_medium=docs&utm_campaign=partners&utm_source=kong

terms_of_service_url: https://www.bearer.sh/terms?utm_medium=docs&utm_campaign=partners&utm_source=kong

kong_version_compatibility: # required
  community_edition: # optional
    compatible:
      - 2.2.x
      - 2.1.x
      - 2.0.x
      - 1.5.x
      - 1.4.x
      - 1.3.x
      - 1.2.x
      - 1.1.x
      - 1.0.x
      - 0.15.x
      - 0.14.x
      - 0.13.x
      - 0.12.x
      - 0.11.x
      - 0.10.x
    #incompatible:
  enterprise_edition: # optional
    compatible:
      - 2.1.x
      - 1.5.x
      - 1.3-x
      - 0.36-x
      - 0.35-x
      - 0.34-x
      - 0.33-x
      - 0.32-x
      - 0.31-x
      - 0.30-x
    #incompatible:

params:
  name: bearer
  api_id: true
  service_id: true
  consumer_id: true
  route_id: true
  config:
    - name: hostname
      required: false
      default: "`localhost`"
      description: The hostname of the Bearer agent.
    - name: port
      required: false
      default: "`24224`"
      description: The port number of the Bearer agent.
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

### How it works

The Bearer Kong plugin captures API traffic from Kong API Gateway and sends it to a local Bearer agent for analysis.

### How to install

If the `luarocks` utility is installed in your system (this is likely the case if you used one of the official installation packages), you can install the 'rock' in your LuaRocks tree (a directory in which LuaRocks installs Lua modules).

To install the plugin using the LuaRocks repository run:

```shell
luarocks install kong-plugin-bearer
```

For alternative installation methods [see here](https://docs.konghq.com/gateway-oss/2.3.x/plugin-development/distribution/#installing-the-plugin).

### How to enable

Add `bearer` to the `plugins` value in `kong.conf`:

```ini
plugins = bundled,bearer
```

or to the `KONG_PLUGINS` environment variable:

```sh
$ export KONG_PLUGINS=bundled,bearer
```
