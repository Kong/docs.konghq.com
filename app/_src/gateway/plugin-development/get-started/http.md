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

The `lua-rest-http` library provides a simple "single shot" http request
function we can use to reach out to our 3rd party service. Here we show
invoking a `GET` request to the _httpbin.org/anything_ API which will 
echo back various information in the response.

Add the following to the top of the `MyPluginHandler:response` function inside the
`handler.lua` module:

```lua
local httpc = http.new()

local res, err = httpc:request_uri("http://httpbin.org/anything", {
  method = "GET",
})
```

If the request to the 3rd party service is successful, the `res` 
variable will contain the response. Before showing how to process the 
successful response, what about error events?
Errors will be provided in the `err` return value, let's see what 
options there are for handling them.

### 3. Handle response errors

The {{site.base_gateway}} 
[Plugin Development Kit](/gateway/{{page.release_version}}/plugin-development/pdk/)
provides you with various functions to help you handle error conditions.

In this example you are processing responses from the upstream service
and decorating your client response with values from the 3rd party service. 
If the request to the 3rd party service fails, you have a choice to make. 
You can terminate processing of the response and return to the client with 
an error, or you could continue processing the response and not complete the 
custom header logic. In this example, we show how to terminate the
response processing and return a `500` internal server error to the client.

Add the following to the `MyPluginHandler:response` function immediately
after the `httpc:request_uri` call:

```lua
if err then
  return kong.response.error(500,
    "Error when trying to access 3rd party service: " .. err,
    { ["Content-Type"] = "text/html" })
end
```

If you choose to continue processing instead, you could log an 
error message and `return` from the `MyPluginHandler:response` function, 
similar to this:

```lua
if err then
    kong.log("Error when trying to access 3rd party service:", err)
    return
end
```

### 4. Process JSON data from 3rd party response

This 3rd party service returns a JSON object in the
response body. Here we are going to show how to parse and extract a 
single value from the JSON body.

Use the `decode` function in the `lua-cjson` library passing in the
`res.body` value received from the `request_uri` function:

```lua
local body_table, err = cjson.decode(res.body)
```

The `decode` function returns a tuple of values. The first value contains the 
result of a successful decoding and represents the JSON as a table containing 
the parsed data. If an error has occurred, the second value will contain 
error information (or `nil` on success).

Same as during the HTTP processing above, in the event of an error return an 
error response to the client and stop processing. Add the following to 
the `MyPluginHandler:response` function after the previous line:

```lua
if err then
  return kong.response.error(500,
    "Error while decoding 3rd party service response: " .. err,
    { ["Content-Type"] = "text/html" })
end
```

At this point, given no error conditions, you have a valid response from the 
3rd party you can use to decorate your client response. The _httpbin_ service returns
a variety of fields including a `url` field which is an echo of the URL requested.
For this example pass the `url` field to the client response by adding the following 
after the previous error handling:

```lua
kong.response.set_header(conf.response_header_name, body_table.url)
```

We've broken down each section of the code.  The following is a full code
listing for the `handler.lua` file.

### 5. Full code listing

```lua
local http  = require("resty.http")
local cjson = require("cjson.safe")

local MyPluginHandler = {
  PRIORITY = 1000,
  VERSION = "0.0.1",
}

function MyPluginHandler:response(conf)

  kong.log("response handler")

  local httpc = http.new()

  local res, err = httpc:request_uri("http://httpbin.org/anything", {
    method = "GET",
  })

  if err then
    return kong.response.error(500,
      "Error when trying to access 3rd party service: " .. err,
      { ["Content-Type"] = "text/html" })
  end

  local body_table, err = cjson.decode(res.body)

  if err then
    return kong.response.error(500,
      "Error when decoding 3rd party service response: " .. err,
      { ["Content-Type"] = "text/html" })
  end

  kong.response.set_header(
    conf.response_header_name,
    body_table.url)

end

return MyPluginHandler
```

### 6. Update testing code

At this stage, if you re-run the `pongo run` command to execute
the integration tests previously built, you will receive errors. The
expected value in the header has changed from `response` to 
`http://httpbin.org/anything`. Update the 
`spec/my-plugin/01-integration_spec.lua` file to assert the new
value in the header.

```lua
-- validate the value of that header
assert.equal("http://httpbin.org/anything", header_value)
```

Re-run the test with `pongo run` and verify success:

```sh
...
[----------] Global test environment teardown.
[==========] 2 tests from 1 test file ran. (23171.28 ms total)
[  PASSED  ] 2 tests.
```

This guide provides examples to get you started. In a real plugin development 
scenario, you would want to build integration tests for 3rd party services by 
providing a test dependency using a mock service instead
of making network calls to the actual 3rd party service used. Pongo supports 
test dependencies for this purpose. See the 
[Pongo documentation](https://github.com/Kong/kong-pongo?tab=readme-ov-file#test-dependencies) 
for details on setting test dependencies.

## What's Next

Deploying {{site.base_gateway}} plugins is the final step in building an end to end
development pipeline. The next chapter will provide the options for deployment
and give you a step by step guide.
