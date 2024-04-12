---
title: Consume External Services
book: plugin_dev_getstarted
chapter: 5
---

{{site.base_gateway}} provides capabilities around security, traffic management, 
monitoring, and analytics. Additionally, {{site.base_gateway}} can be used as an 
ancillary development layer for your business logic. A common use case may be the 
desire to decorate API responses from your upstream services with data from a 
3rd party service. 

## Prerequisites

This page is the fourth chapter in the [Getting Started](/gateway/{{page.gateway_release}}/plugin-development/get-started/index) 
guide for developing custom plugins. These instructions refer to the previous chapters in the guide and require the same
developer tool prerequisites.

## Step by Step

The following are step by step instructions to show you how to consume data from external 
services using an http client and parsing JSON values. With the parsed data we will
show you how to ammend values to the response data prior to returning to your
API gateway clients.

### 1. Including HTTP and JSON support

Start by importing two new libraries to the `handler.lua` file giving us access to 
HTTP and JSON parsing support. 

You are going to use the [lua-rest-http](https://github.com/ledgetech/lua-resty-http)
library for HTTP client connectivity to the 3rd party service. The library
provides a simple interface for single-shot requests we will use here, but see the
documentation for all options when using the library.

For JSON support, use the [lua-cjson](https://github.com/mpx/lua-cjson) library
which provides fast and standards compliant JSON support. lua-cjson supports
a `safe` variant of the library that allows for exception free encoding and decoding
support. 

Add the new includes at the top `handler.lua`:

```lua
local http  = require("resty.http")
local cjson = require("cjson.safe")
```

### 2. Invoke 3rd party http request

The `lua-rest-htpp` library provides a simple "single shot" http request
function we can use to reach out to our 3rd party service. Here we show
invoking a `GET` request to the _httpbin.org/anything_ API which will 
echo back various information in the response.

Add the following to the `MyPluginHandler:response` function inside the
`handler.lua` module:

```lua
local httpc = http.new()

local res, err = httpc:request_uri("http://httpbin.org/anything", {
  method = "GET",
})
```

### 3. Handle response errors

handle errors

### 4. Process JSON data from 3rd party response

introduce CJSON library
process response
handle errors

### 5. Decorate upstream response

take JSON field and add it to response before completing
return response

### 6. Full code listing

This is now the full code listing for the `handler.lua` file:

```lua
local http  = require("resty.http")
local cjson = require("cjson.safe")

local MyPluginHandler = {
  PRIORITY = 1000,
  VERSION = "0.0.1",
}

function MyPluginHandler:response(conf)

  local httpc = http.new()

  local res, err = httpc:request_uri("http://httpbin.org/anything", {
    method = "GET",
  })
  if err then
      kong.log("request failed: ", err)
      return
  end

  local body_table, err = cjson.decode(res.body)
  if err then
      kong.log("failed to decode response body: ", err)
      return
  end

  kong.response.set_header(conf.response_header_name, body_table.origin)

end

return MyPluginHandler
```

## What's Next

Deploying {{site.base_gateway}} plugins is the final step in building an end to end
development pipeline. The next chapter will provide the options for deployment
and give you a step by step guide.
