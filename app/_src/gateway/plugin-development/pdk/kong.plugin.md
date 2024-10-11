---
#
#  WARNING: this file was auto-generated by a script.
#  DO NOT edit this file directly. Instead, send a pull request to change
#  https://github.com/Kong/kong/tree/master/kong/pdk
#  or its associated files
#
title: kong.plugin
pdk: true
toc: true
source_url: https://github.com/Kong/kong/tree/master/kong/pdk/plugin.lua
---

<!-- Plugin related APIs -->

<!-- vale off -->

## kong.plugin.get_id()

Returns the instance ID of the plugin.

**Phases**

* rewrite, access, header_filter, response, body_filter, log

**Returns**

* `string`:  The ID of the running plugin


**Usage**


``` lua
kong.plugin.get_id() -- "123e4567-e89b-12d3-a456-426614174000"
```