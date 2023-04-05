---
name: Serverless Functions
publisher: Kong Inc.
desc: Dynamically run Lua code from Kong
description: |
  Dynamically run Lua code from Kong.

  The Serverless Functions plugin comes as two separate plugins. Each one runs with a
  different priority in the plugin chain.

  - `pre-function`
    - Runs before other plugins run during each phase. The `pre-function` plugin can be applied to individual services, routes, or globally.
  - `post-function`
    - Runs after other plugins in each phase. The `post-function` plugin can be applied to individual services, routes, or globally.

  {:.important}
  > **Warning:** The pre-function and post-function serverless plugin
    allows anyone who can enable the plugin to execute arbitrary code.
    If your organization has security concerns about this, disable the plugin
    in your `kong.conf` file.

type: plugin
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---
