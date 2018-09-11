---
name: Upstream HTTP Basic Authentication

categories:
  - authentication

type: plugin

desc: Add HTTP Basic Authentication header to upstream service request

description: |
  Kong Plugin to add HTTP Basic Authentication to the upstream request header.

support_url: https://github.com/revolsys/kong-plugin-upstream-auth-basic/issues

source_url: https://github.com/revolsys/kong-plugin-upstream-auth-basic

license_type: Apache-2.0

kong_version_compatibility: # required
  community_edition: # optional
    compatible:
      - 0.14.x
      - 0.13.x
      - 0.12.x
    #incompatible:
  enterprise_edition: # optional
    compatible:
      - 0.34-x
      - 0.33-x
      - 0.32-x
      - 0.31-x
      - 0.30-x
    #incompatible:

params:
  name: upstream-auth-basic
  api_id: true
  service_id: true
  consumer_id: false
  route_id: true

  config:
    - name: username
      required: true
      value_in_examples: kingkong
      urlencode_in_examples:
      default:
      description: The username to send in the Authorization header to the upstream service
    - name: password
      required: true
      value_in_examples: 1-big-ape
      urlencode_in_examples:
      default:
      description: The password to send in the Authorization header to the upstream service
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

### Installation

1. The [LuaRocks](http://luarocks.org) package manager must be [Installed](https://github.com/luarocks/luarocks/wiki/Download).
2. [Kong](https://konghq.com) must be [Installed](https://konghq.com/install/) and you must be familiar with using and configuring Kong.
3. Install the module kong-plugin-upstream-auth-basic.
```
luarocks install kong-plugin-upstream-auth-basic
```
4. Add the custom plugin to the `kong.conf` file (e.g. `/etc/kong/kong.conf`)
```
custom_plugins = ...,upstream-auth-basic
```
5. Restart kong
