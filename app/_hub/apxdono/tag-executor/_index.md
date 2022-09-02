---
name: Tag Executor Plugin
publisher: Apxdono
categories:
  - traffic-control
type: plugin
desc: Execute plugins on Route path by matching its tags
description: |
  The main goal of this plugin is to reduce duplication of huge plugin
  configurations in cases when same plugin configs must be applied only to
  a subset of various routes in your Kong configuration.
  It's especially useful if you're trying to avoid extra
  maintenance burden when using Kong with database, opting for a `DB-less`
  option instead, but number of services and routes in your Kong
  configuration is constantly growing.

  Instead of duplicating plugin configurations on each required `route`,
  you can configure `tag-executor` to invoke plugin phases if matched `route`
  has specified `tag`. Just add the `tag` in question to routes as needed
  and enjoy a minimal declarative config.

  This plugin is primarily designed for `DB-less` Kong. If you're using Kong
  with DB and (most likely) have outside tools/pipelines to manage
  Kong's DB configuration this plugin is of little use to you.
  **Theoretically** It will still work as expected.

support_url: https://github.com/Apxdono/kong-plugin-tag-executor/issues
source_url: https://github.com/Apxdono/kong-plugin-tag-executor
license_type: Apache-2.0
license_url: https://github.com/Apxdono/kong-plugin-tag-executor/blob/master/LICENSE
kong_version_compatibility:
  community_edition:
    compatible:
      - 2.7.x
      - 2.8.x
params:
  name: tag-executor
  service_id: false
  consumer_id: false
  route_id: false
  protocols:
    - http
    - https
  dbless_compatible: "yes"
  dbless_explanation: Fully compatible with DB and DB-less Kong implementations.

  konnect_examples: false

  config:
    - name: tag_execute_steps
      required: true
      default: null
      datatype: array of record elements
      description: |
        List of steps for each `tag`. Configuration reference described
        in [Execute Step Schema](#execute-step-schema) section.
---


## Installation

Install the plugin using [LuaRocks](https://luarocks.org/)

```sh
luarocks install kong-plugin-tag-executor
```
[LuaRocks plugin page](https://luarocks.org/modules/Apxdono/kong-plugin-tag-executor)


## Enable plugin in Kong

To guarantee that all other plugin configurations are properly picked up, ensure
that this plugin is enabled last in `kong.conf`

**Example:**
```properties
plugins = bundled,<another-plugin>,tag-executor
```

## Capabilities

- Plugin can use configuration of any other plugin installed in Kong instance
([reference docs](https://docs.konghq.com/gateway/latest/reference/configuration/#plugins)).
- Plugin is designed to work with `declarative_config` only (Tested only
against `dbless` Kong). *In theory can work in 'Kong with DB' environments*.
- Execution of nested plugins and their phases respects Kong's
[plugin execution order](https://docs.konghq.com/gateway/latest/plugin-development/custom-logic/#plugins-execution-order).
- Plugin is executed before any other plugin (has pretty High Priority)
- Plugin is supposed to be global (targeting tags provides really
fine grained control).
- Can be used on specific `routes`, `services`, `consumers`
(which defeats the purpose).


## Limitations

- Providing nested plugin configuration for `tag-executor` itself (self-config)
has no effect. `tag-executor` plugin is omitted from phase executions to avoid
potential overflows due to recursive calls.
- Works only with `HTTP/HTTPS` requests (No `stream` support yet?).


## Usage

Below is the example configuration one might use in `declarative_config`:

```yaml

services:
  - name: service-A
    # Service config
    # ....
    routes:
      - name: route-A
        paths:
          - /srv/a/path/
        tags:
          - tracing # invoke plugins on this route and add tracing info
          - other-tag
      - name: route-A-admin
        paths:
          - /srv/a/admin/
        tags:
          - admin

  # Even more services
  # ....

  - name: service-X
    # Service config
    # ....
    routes:
      - name: route-X
        paths:
          - /srv/x/path/
        tags:
          - tracing # invoke plugins on this route and add tracing info

plugins:
  - name: tag-executor
    config:
      tag_execute_steps:
        - name: service-tracing-step
          target_tag: tracing
          plugins:
            - name: correlation-id
              config:
                header_name: correlation-id
                generator: uuid
                echo_downstream: true
            - name: request-transformer
              config:
                add:
                  headers:
                    - X-Traced-With:correlation
        - name: another-step
            # More and more configurations
```

Whenever Kong receives a request this plugin invokes each of `tag_execute_steps`.
In this example when `route.tags` contain `tracing` tag, `correlation-id`
and `request-transformer` plugins are invoked and request to upstream gets
modified by these plugins.


## Execute Step Schema

|Field                                          |Description    |
|----                                           |----           |
|`name`<br/>*required*<br/><br/>**Type:** string|Name of execution step that will be invoked. Used in debug logs.|
|`target_tag`<br/>*optional*<br/><br/>**Type:** string|Tag to match on `route`. If not specified applies steps to all routes (plugins behave like `global` plugins).|
|`plugins`<br/>*required*<br/><br/>**Type:** array of record elements|Array of plugin configurations. For config guide refer to documentation of particular plugin.|
