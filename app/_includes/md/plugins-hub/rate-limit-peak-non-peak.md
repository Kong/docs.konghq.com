
You can set the rate limit based on peak or non-peak time by using the [Pre-function](/hub/kong-inc/pre-function/) and the [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) plugins together.

This example creates two {{site.base_gateway}} routes: one to handle peak traffic, and one to handle off-peak traffic. 
Each route has a different rate limit, which gets applied by the Rate Limiting Advanced plugin.
The Pre-function plugin runs a Lua function in the rewrite phase, sending traffic to one of these {{site.base_gateway}} routes based on your defined peak and off-peak settings.

## Configure rate limit for peak and non-peak times

Set up two routes and apply separate rate limits to each one using the Rate Limiting Advanced plugin.

The names and values of any entities and attributes (service, route, header name, header value, and so on) 
in the following examples are entirely up to you.

1. Create a service named `httpbin`:

    ```bash
    curl -i -X POST http://localhost:8001/services \
      --data "name=httpbin" \
      --data "url=http://httpbin.org/anything"
    ```

1. Create a route to handle peak traffic.
Name the route `peak`, attach it to the service `httpbin`, and set a header with the name `X-Peak` and the value `true`:
 
    ```bash
    curl -i -X POST http://localhost:8001/services/httpbin/routes \
      --data "name=peak" \
      --data "paths=/httpbin" \
      --data "headers.X-Peak=true"
    ```

1. Apply a rate limit to the `peak` route by enabling the Rate Limiting Advanced plugin. 
This example sets the limit to 10 requests per 30 second window:

    ```bash
    curl -i -X POST http://localhost:8001/routes/peak/plugins/  \
      --data "name=rate-limiting-advanced" \
      --data "config.limit=10" \
      --data "config.window_size=30"
    ```

1. Create another route to handle off-peak traffic. 
Name the route `off-peak`, attach it to the service `httpbin`, and set a header with the name `X-Off-Peak` and the value `true`:

    ```bash
    curl -i -X POST http://localhost:8001/services/httpbin/routes \
      --data "name=off-peak" \
      --data "paths=/httpbin" \
      --data "headers.X-Off-Peak=true"
    ```

1. Apply a rate limit to the `off-peak` route by enabling the Rate Limiting Advanced plugin. 
This example sets the limit to 5 requests per 30 second window:

    ```bash
    curl -i -X POST http://localhost:8001/routes/off-peak/plugins/  \
      --data "name=rate-limiting-advanced" \
      --data "config.limit=5" \
      --data "config.window_size=30"
    ```

## Apply the Pre-function plugin to route peak and off-peak traffic

1. Create a `ratelimit.lua` file with the following code:

    ```lua
    local hour = os.date("*t").hour 
    if hour >= 8 and hour <= 17 
    then
        kong.service.request.set_header("X-Peak","true") 
    else
        kong.service.request.set_header("X-Off-Peak","true") 
    end
    ```

    This function determines the time of day based on the operating system's time, 
    then sets a request header based on the determined time.

    Set the hours based on your own preferred peak times.

1. Apply the Pre-function plugin globally and run it in the rewrite phase:
   
    ```bash
    curl -i -X POST http://localhost:8001/plugins \
        --form "name=pre-function" \
        --form "config.rewrite[1]=@ratelimit.lua"
    ```  

This plugin will now pass each request to the correct route based on the time of 
day defined in the `ratelimit.lua` function.