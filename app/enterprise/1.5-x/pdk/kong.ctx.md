---
title: kong.ctx
pdk: true
toc: true
---

## kong.ctx

Current request context data



### kong.ctx.shared

A table that has the lifetime of the current request and is shared between
 all plugins.  It can be used to share data between several plugins in a given
 request.

 Since only relevant in the context of a request, this table cannot be
 accessed from the top-level chunk of Lua modules. Instead, it can only be
 accessed in request phases, which are represented by the `rewrite`,
 `access`, `header_filter`, `body_filter`, and `log` phases of the plugin
 interfaces.  Accessing this table in those functions (and their callees) is
 fine.

 Values inserted in this table by a plugin will be visible by all other
 plugins.  One must use caution when interacting with its values, as a naming
 conflict could result in the overwrite of data.


**Phases**

* rewrite, access, header_filter, body_filter, log

**Usage**

``` lua
-- Two plugins A and B, and if plugin A has a higher priority than B's
-- (it executes before B):

-- plugin A handler.lua
function plugin_a_handler:access(conf)
  kong.ctx.shared.foo = "hello world"

  kong.ctx.shared.tab = {
    bar = "baz"
  }
end

-- plugin B handler.lua
function plugin_b_handler:access(conf)
  kong.log(kong.ctx.shared.foo) -- "hello world"
  kong.log(kong.ctx.shared.tab.bar) -- "baz"
end
```

[Back to top](#kongctx)


### kong.ctx.plugin

A table that has the lifetime of the current request - Unlike
 `kong.ctx.shared`, this table is **not** shared between plugins.   Instead,
 it is only visible for the current plugin _instance_. That is, if several
 instances of the rate-limiting plugin are configured (e.g. on different
 Services), each instance has its own table, for every request.

 Because of its namespaced nature, this table is safer for a plugin to use
 than `kong.ctx.shared` since it avoids potential naming conflicts, which
 could lead to several plugins unknowingly overwrite each other's data.

 Since only relevant in the context of a request, this table cannot be
 accessed from the top-level chunk of Lua modules. Instead, it can only be
 accessed in request phases, which are represented by the `rewrite`,
 `access`, `header_filter`, `body_filter`, and `log` phases of the plugin
 interfaces.  Accessing this table in those functions (and their callees) is
 fine.

 Values inserted in this table by a plugin will be visible in successful
 phases of this plugin's instance only. For example, if a plugin wants to
 save some value for post-processing during the `log` phase:


**Phases**

* rewrite, access, header_filter, body_filter, log

**Usage**

``` lua
-- plugin handler.lua

function plugin_handler:access(conf)
  kong.ctx.plugin.val_1 = "hello"
  kong.ctx.plugin.val_2 = "world"
end

function plugin_handler:log(conf)
  local value = kong.ctx.plugin.val_1 .. " " .. kong.ctx.plugin.val_2

  kong.log(value) -- "hello world"
end
```

[Back to top](#kongctx)
