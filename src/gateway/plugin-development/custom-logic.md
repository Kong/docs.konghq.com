---
title: Plugin Development - Implementing Custom Logic
book: plugin_dev
chapter: 3
---

{:.note}
> **Note**: This chapter assumes that you are familiar with
[Lua](http://www.lua.org/).

A {{site.ce_product_name}} plugin allows you to inject custom logic (in Lua) at several
entry-points in the life-cycle of a request/response or a tcp stream
connection as it is proxied by {{site.ce_product_name}}. To do so, the file
`kong.plugins.<plugin_name>.handler` must return a table with one or
more functions with predetermined names. Those functions will be
invoked by {{site.ce_product_name}} at different phases when it processes traffic.

The first parameter they take is always `self`. All functions except `init_worker`
can receive a second parameter which is a table with the plugin configuration.

## Module

```
kong.plugins.<plugin_name>.handler
```

## Available contexts

If you define any of the following functions in your `handler.lua`
file you'll implement custom logic at various entry-points
of {{site.ce_product_name}}'s execution life-cycle:

- **[HTTP Module]** *is used for plugins written for HTTP/HTTPS requests*

| Function name   | Phase             | Description
|-----------------|-------------------|------------
| `init_worker`   | [init_worker]     | Executed upon every Nginx worker process's startup.
| `certificate`   | [ssl_certificate] | Executed during the SSL certificate serving phase of the SSL handshake.
| `rewrite`       | [rewrite]         | Executed for every request upon its reception from a client as a rewrite phase handler. <br> In this phase, neither the `Service` nor the `Consumer` have been identified, hence this handler will only be executed if the plugin was configured as a global plugin.
| `access`        | [access]          | Executed for every request from a client and before it is being proxied to the upstream service.
| `response` | [access] | Replaces both `header_filter()` and `body_filter()`. Executed after the whole response has been received from the upstream service, but before sending any part of it to the client.
| `header_filter` | [header_filter]   | Executed when all response headers bytes have been received from the upstream service.
| `body_filter`   | [body_filter]     | Executed for each chunk of the response body received from the upstream service. Since the response is streamed back to the client, it can exceed the buffer size and be streamed chunk by chunk. This function can be called multiple times if the response is large. See the [lua-nginx-module] documentation for more details.
| `log`           | [log]             | Executed when the last response byte has been sent to the client.

{:.note}
> **Note:** If a module implements the `response` function, {{site.ce_product_name}} will automatically activate the "buffered proxy" mode, as if the [`kong.service.request.enable_buffering()` function][enable_buffering] had been called. Because of a current Nginx limitation, this doesn't work for HTTP/2 or gRPC upstreams.

To reduce unexpected behaviour changes, {{site.ce_product_name}} does not start if a plugin implements both `response` and either `header_filter` or `body_filter`.

- **[Stream Module]** *is used for Plugins written for TCP and UDP stream connections*

| Function name   | Phase                                                                        | Description
|-----------------|------------------------------------------------------------------------------|------------
| `init_worker`   | [init_worker]                                                                | Executed upon every Nginx worker process's startup.
| `preread`       | [preread]                                                                    | Executed once for every connection.
| `log`           | [log](https://github.com/openresty/stream-lua-nginx-module#log_by_lua_block) | Executed once for each connection after it has been closed.
| `certificate`   | [ssl_certificate] | Executed during the SSL certificate serving phase of the SSL handshake.

All of those functions, except `init_worker`, take one parameter which is given
by {{site.ce_product_name}} upon its invocation: the configuration of your plugin. This parameter
is a Lua table, and contains values defined by your users, according to your
plugin's schema (described in the `schema.lua` module). More on plugins schemas
in the [next chapter]({{page.book.next}}).

Note that UDP streams don't have real connections.  {{site.ce_product_name}} will consider all
packets with the same origin and destination host and port as a single
connection.  After a configurable time without any packet, the connection is
considered closed and the `log` function is executed.

[HTTP Module]: https://github.com/openresty/lua-nginx-module
[Stream Module]: https://github.com/openresty/stream-lua-nginx-module
[init_worker]: https://github.com/openresty/lua-nginx-module#init_worker_by_lua_by_lua_block
[ssl_certificate]: https://github.com/openresty/lua-nginx-module#ssl_certificate_by_lua_block
[rewrite]: https://github.com/openresty/lua-nginx-module#rewrite_by_lua_block
[access]: https://github.com/openresty/lua-nginx-module#access_by_lua_block
[header_filter]: https://github.com/openresty/lua-nginx-module#header_filter_by_lua_block
[body_filter]: https://github.com/openresty/lua-nginx-module#body_filter_by_lua_block
[log]: https://github.com/openresty/lua-nginx-module#log_by_lua_block
[preread]: https://github.com/openresty/stream-lua-nginx-module#preread_by_lua_block
[enable_buffering]: /gateway/{{page.kong_version}}/pdk/kong.service.request/#kongservicerequestenable_buffering


## handler.lua specifications

{{site.ce_product_name}} processes requests in **phases**. A plugin is a piece of code that gets
activated by {{site.ce_product_name}} as each phase is executed while the request gets proxied.

Phases are limited in what they can do. For example, the `init_worker` phase
does not have access to the `config` parameter because that information isn't
available when kong is initializing each worker.

A plugin's `handler.lua` must return a table containing the functions it must
execute on each phase.

{{site.ce_product_name}} can process HTTP and stream traffic. Some phases are executed
only when processing HTTP traffic, others when processing stream,
and some (like `init_worker` and `log`) are invoked by both kinds of traffic.

In addition to functions, a plugin must define two fields:

* `VERSION` is an informative field, not used by {{site.ce_product_name}} directly. It usually
  matches the version defined in a plugin's Rockspec version, when it exists.
* `PRIORITY` is used to sort plugins before executing each of their phases.
  Plugins with a higher priority are executed first. See the
  [plugin execution order](#plugins-execution-order) below
  for more info about this field.

The following example `handler.lua` file defines custom functions for all
the possible phases, in both http and stream traffic. It has no functionality
besides writing a message to the log every time a phase is invoked. Note
that a plugin doesn't need to provide functions for all phases.

```lua
local CustomHandler = {
  VERSION  = "1.0.0",
  PRIORITY = 10,
}

function CustomHandler:init_worker()
  -- Implement logic for the init_worker phase here (http/stream)
  kong.log("init_worker")
end


function CustomHandler:preread(config)
  -- Implement logic for the preread phase here (stream)
  kong.log("preread")
end


function CustomHandler:certificate(config)
  -- Implement logic for the certificate phase here (http/stream)
  kong.log("certificate")
end

function CustomHandler:rewrite(config)
  -- Implement logic for the rewrite phase here (http)
  kong.log("rewrite")
end

function CustomHandler:access(config)
  -- Implement logic for the rewrite phase here (http)
  kong.log("access")
end

function CustomHandler:header_filter(config)
  -- Implement logic for the header_filter phase here (http)
  kong.log("header_filter")
end

function CustomHandler:body_filter(config)
  -- Implement logic for the body_filter phase here (http)
  kong.log("body_filter")
end

function CustomHandler:log(config)
  -- Implement logic for the log phase here (http/stream)
  kong.log("log")
end

-- return the created table, so that Kong can execute it
return CustomHandler
```

Note that in the example above we are using Lua's `:` shorthand syntax for
functions taking `self` as a first parameter. An equivalent unshortened version
of the `access` function would be:

``` lua
function CustomHandler.access(self, config)
  -- Implement logic for the rewrite phase here (http)
  kong.log("access")
end
```

The plugin's logic doesn't need to be all defined inside the `handler.lua` file.
It can be be split into several Lua files (also called *modules*).
The `handler.lua` module can use `require` to include other modules in your plugin.

For example, the following plugin splits the functionality into three files.
`access.lua` and `body_filter.lua` return functions. They are in the same
folder as `handler.lua`, which requires and uses them to build the plugin:

```lua
-- handler.lua
local access = require "kong.plugins.my-custom-plugin.access"
local body_filter = require "kong.plugins.my-custom-plugin.body_filter"

local CustomHandler = {
  VERSION  = "1.0.0",
  PRIORITY = 10
}

CustomHandler.access = access
CustomHandler.body_filter = body_filter

return CustomHandler
```

```lua
-- access.lua
return function(self, config)
  kong.log("access phase")
end
```

```lua
-- body_filter.lua
return function(self, config)
  kong.log("body_filter phase")
end
```

See [the source code of the Key-Auth Plugin](https://github.com/Kong/kong/blob/master/kong/plugins/key-auth/handler.lua)
for an example of a real-life handler code.

### Migrating from BasePlugin module

The `BasePlugin` module is deprecated and has been removed from
{{site.base_gateway}}. If you have an old plugin that uses this module, replace
the following section:

```lua
--  DEPRECATED --
local BasePlugin = require "kong.plugins.base_plugin"
local CustomHandler = BasePlugin:extend()
CustomHandler.VERSION  = "1.0.0"
CustomHandler.PRIORITY = 10
```

with the current equivalent:
```lua
local CustomHandler = {
  VERSION  = "1.0.0",
  PRIORITY = 10,
}
```

You don't need to add a `:new()` method or call any of the `CustomHandler.super.XXX:(self)`
methods.


## Plugin Development Kit

Logic implemented in those phases will most likely have to interact with the
request/response objects or core components (e.g. access the cache, and
database). {{site.ce_product_name}} provides a [Plugin Development Kit][pdk] (or "PDK") for such
purposes: a set of Lua functions and variables that can be used by Plugins to
execute various gateway operations in a way that is guaranteed to be
forward-compatible with future releases of {{site.ce_product_name}}.

When you are trying to implement some logic that needs to interact with {{site.ce_product_name}}
(e.g. retrieving request headers, producing a response from a plugin, logging
some error or debug information), you should consult the [Plugin Development
Kit Reference][pdk].


## Plugins execution order

Some plugins might depend on the execution of others to perform some
operations. For example, plugins relying on the identity of the consumer have
to run **after** authentication plugins. Considering this, {{site.ce_product_name}} defines
**priorities** between plugins execution to ensure that order is respected.

Your plugin's priority can be configured via a property accepting a number in
the returned handler table:

```lua
CustomHandler.PRIORITY = 10
```

The higher the priority, the sooner your plugin's phases will be executed in
regard to other plugins' phases (such as `:access()`, `:log()`, etc.).

{% navtabs %}
{% navtab Open-source or Free mode %}

The following list includes all plugins bundled with open-source
{{site.base_gateway}} or {{site.base_gateway}} running in Free mode.

{:.note}
> **Note:** The correlation-id plugin's execution order is different depending
on whether you're running {{site.base_gateway}} in Free mode or using the
open-source package.

The current order of execution for the bundled plugins is:

Plugin                      | Priority
----------------------------|----------
pre-function                | `+inf`
correlation-id <span class="badge free"></span> | 100001
zipkin                      | 100000
bot-detection               | 2500
cors                        | 2000
session                     | 1900
jwt                         | 1005
oauth2                      | 1004
key-auth                    | 1003
ldap-auth                   | 1002
basic-auth                  | 1001
hmac-auth                   | 1000
grpc-gateway                | 998
ip-restriction              | 990
request-size-limiting       | 951
acl                         | 950
rate-limiting               | 901
response-ratelimiting       | 900
request-transformer         | 801
response-transformer        | 800
aws-lambda                  | 750
azure-functions             | 749
prometheus                  | 13
http-log                    | 12
statsd                      | 11
datadog                     | 10
file-log                    | 9
udp-log                     | 8
tcp-log                     | 7
loggly                      | 6
syslog                      | 4
grpc-web                    | 3
request-termination         | 2
correlation-id <span class="badge oss"></span> | 1
post-function               | -1000

{% endnavtab %}
{% navtab Enterprise %}
The following list includes all plugins bundled with a {{site.base_gateway}}
Enterprise subscription.

The current order of execution for the bundled plugins is:

Plugin                      | Priority
----------------------------|----------
pre-function                | `+inf`
correlation-id              | 100001 <!--  CE priority is 1, EE priority is 100001 -->
zipkin                      | 100000
exit-transformer            | 9999
bot-detection               | 2500
cors                        | 2000
route-by-header             | 2000
session                     | 1900
oauth2-introspection        | 1700
acme                        | 1007
mtls-auth                   | 1006
jwt                         | 1005
degraphql                   | 1005
oauth2                      | 1004
vault-auth                  | 1003
key-auth                    | 1003
key-auth-enc                | 1003
ldap-auth                   | 1002
ldap-auth-advanced          | 1002
basic-auth                  | 1001
openid-connect              | 1000
hmac-auth                   | 1000
request-validator           | 999
jwt-signer                  | 999
grpc-gateway                | 998
application-registration    | 995
ip-restriction              | 990
request-size-limiting       | 951
acl                         | 950
opa                         | 920
rate-limiting-advanced      | 902
graphql-rate-limiting-advanced | 902
rate-limiting               | 901
response-ratelimiting       | 900
jq                          | 811
request-transformer-advanced | 802
request-transformer         | 801
response-transformer-advanced | 800
route-transformer-advanced  | 800
response-transformer        | 800
kafka-upstream              | 751
aws-lambda                  | 750
azure-functions             | 749
graphql-proxy-cache-advanced | 100
proxy-cache-advanced        | 100
proxy-cache                 | 100
forward-proxy               | 50
prometheus                  | 13
canary                      | 13
http-log                    | 12
statsd                      | 11
statsd-advanced             | 11
datadog                     | 10
file-log                    | 9
udp-log                     | 8
tcp-log                     | 7
loggly                      | 6
kafka-log                   | 5
syslog                      | 4
grpc-web                    | 3
request-termination         | 2
mocking                     | -1
post-function               | -1000

{% endnavtab %}
{% endnavtabs %}
---

Next: [Plugin configuration &rsaquo;]({{page.book.next}})

[lua-nginx-module]: https://github.com/openresty/lua-nginx-module
[pdk]: /gateway/{{page.kong_version}}/pdk
