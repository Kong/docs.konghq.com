---
title: Getting started with the Post-function plugin
nav_title: Getting started with Post-function
---

The following guide shows you how to set up the Post-fuction plugin to adjust request header names. In this example, we'll edit two types of headers: headers set via a plugin (in this case, 
[Rate Limiting](/hub/kong-inc/rate-limiting/)), and latency headers from {{site.base_gateway}}).

* The Rate Limiting plugin returns headers such as `X-RateLimit-Remaining-<time>` and `X-RateLimit-Limit-<time>`, 
where `<time>` is the configured time span for the limit.
* {{site.base_gateway}} adds latency headers to responses, such as `X-Kong-Upstream-Latency` and `X-Kong-Proxy-Latency`.
While you can turn these headers on or off in `kong.conf`, they have fixed names that can't be configured. 

To change any header names, set up a Post-function plugin instance that runs in the `header_filter` phase.

1. Create a {{site.base_gateway}} service:

    ```sh
    curl -i -X POST http://localhost:8001/services/ \
      --data "name=example-service" \
      --data "url=http://httpbin.org/headers"
    ```

1. Add a route to the service:

    ```sh
    curl -i -X POST http://localhost:8001/services/example-service/routes \
      --data "name=test" \
      --data "paths[]=/test"
    ```

1. Add a rate limiting plugin so that we can change its headers:

    ```sh
    curl -X POST http://localhost:8001/services/example-service/plugins \
      --data "name=rate-limiting"  \
      --data "config.second=5"  \
      --data "config.minute=30"  \
      --data "config.policy=local"
    ```

1. Create a Lua file for the plugin named `serverless.lua` (any name is fine). 
For example:

    ```lua
    return function()

    -- Rename rate-limit plugin headers
    -- X-RateLimit-Remaining-second: 1
    -- X-RateLimit-Limit-second: 2
    -- X-RateLimit-Limit-second changed to X-Rlls
    -- X-RateLimit-Remaining-second changed to X-Rlrs

      local kong_rl_headers = {}
      kong_rl_headers["x-ratelimit-limit-second"]="X-Rlls"
      kong_rl_headers["x-ratelimit-remaining-second"]="X-Rlrs"
      kong_rl_headers["x-ratelimit-limit-minute"]="X-Rllm"
      kong_rl_headers["x-ratelimit-remaining-minute"]="X-Rlrm"
      kong_rl_headers["x-ratelimit-limit-hour"]="X-Rllh"
      kong_rl_headers["x-ratelimit-remaining-hour"]="X-Rlrh"
      kong_rl_headers["x-ratelimit-limit-day"]="X-Rlld"
      kong_rl_headers["x-ratelimit-remaining-day"]="X-Rlrd"
      kong_rl_headers["x-ratelimit-limit-month"]="X-Rlln"
      kong_rl_headers["x-ratelimit-remaining-month"]="X-Rlrn"
      kong_rl_headers["x-ratelimit-limit-year"]="X-Rlly"
      kong_rl_headers["x-ratelimit-remaining-year"]="X-Rlry"

      local headers = kong.response.get_headers()
      for k, v in pairs(headers) do
        if kong_rl_headers[k] ~= nil then
          kong.response.set_header(kong_rl_headers[k], v)
          kong.response.clear_header(k)
        end
      end

      -- Add custom headers for latency
      kong.response.set_header("My-Custom-Proxy-Latency", ngx.ctx.KONG_PROXY_LATENCY)
      kong.response.set_header("My-Custom-Upstream-Latency", ngx.ctx.KONG_WAITING_TIME)

    end
    ```

1. Add the serverless function to the appropriate Kong entity by enabling the post-function plugin. 
For example, let's apply it to the `test` route:

    ```sh
    curl -i -X POST https://localhost:8001/routes/test/plugins \
      --form "name=post-function" \
      --form "config.header_filter=@/tmp/serverless.lua"
    ```

1. Verify the changes. Make a call to the Admin API and check that the response header names have been changed:

    ```sh
    curl -v http://localhost:8000/test
    ```

    The response should show the new header names:

    ```
    *   Trying 127.0.0.1)...
    * TCP_NODELAY set
    * Connected to kong (127.0.0.1)) port 8000 (#0)
    > GET /test HTTP/1.1
    > Host: localhost:8000
    > User-Agent: curl/7.86.0
    > Accept: */*
    >
    < HTTP/1.1 200 OK
    < Content-Type: application/json
    < Content-Length: 374
    < Connection: keep-alive
    < Server: gunicorn/19.9.0
    < Date: Mon, 27 Apr 2023 09:27:20 GMT
    < Access-Control-Allow-Origin: *
    < Access-Control-Allow-Credentials: true
    < X-Rlls: 2
    < X-Rllm: 5
    < X-Rlrm: 3
    < X-Rlrs: 1
    < My-Custom-Proxy-Latency: 1
    < My-Custom-Upstream-Latency: 4
    ```

This is just a small demonstration of the power this plugin grants. You were
able to dynamically inject Lua code into the header phase to dynamically
transform the request without creating a custom plugin or
reloading and redeploying {{site.base_gateway}}.
