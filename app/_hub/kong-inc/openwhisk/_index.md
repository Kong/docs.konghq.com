---
name: Apache OpenWhisk
publisher: Kong Inc.

source_code: https://github.com/Kong/kong-plugin-openwhisk

desc: Invoke and manage OpenWhisk actions from Kong
description: |
  This plugin invokes
  [OpenWhisk Action](https://github.com/openwhisk/openwhisk/blob/master/docs/actions.md).
  The Apache OpenWhisk plugin can be used in combination with other request plugins to secure, manage,
  or extend the function.

type: plugin
cloud: false
categories:
  - serverless

installation: |

  You can either use the LuaRocks package manager to install the plugin

  ```bash
  luarocks install kong-plugin-openwhisk
  ```

  or install it from [source](https://github.com/Kong/kong-plugin-openwhisk).
  For more information on plugin installation, see the documentation
  [Plugin Development - (un)Install your plugin](/gateway/latest/plugin-development/distribution/).

---
