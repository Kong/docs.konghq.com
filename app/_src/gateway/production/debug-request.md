---
title: Debug requests
content_type: explanation
---

{{site.base_gateway}} admins can debug requests by collecting timing information about a given request, on demand. 
Request debugging is triggered using a secure token and the resulting data is returned in a response header named `X-Kong-Request-Debug-Output`. 

Request debugging provides the following insights:
* Time spent in various {{site.base_gateway}} components, such as plugins, DNS resolution, and load balancing. 
* Contextual information, such as the domain name tried during these processes.

{:.note}
> **Note:** This feature is meant for live debugging. The JSON schema of the header containing the timing should never be considered static and is always subject to change.

## Enable request debugging

Request debugging is enabled by default and has the following configurations in [`kong.conf`](/gateway/{{page.kong_version}}/reference/configuration/):

```
request_debug = on | off # enable or disable request debugging
request_debug_token <token> # Set debug token explicitly. Otherwise, it will be generated randomly when Kong starts, restarts, and reloads. 
```

The debug token (`X-Kong-Request-Debug-Token`) is used to authenticate the client and send the debug request, preventing abuse. 

You can find the debug token in the following locations:
* **{{site.base_gateway}} error log:** The debug token is logged in the error log (notice level) when {{site.base_gateway}} starts, restarts, or reloads. The log line will have the `[request-debug]` prefix to aid in searching.
* **Filesystem:** The debug token is also stored in a file at `{prefix}/.request_debug_token` and updated when {{site.base_gateway}} starts, restarts, or reloads.

## Debug request configuration

To debug a request, add the following request headers:
* At a minimum, you should set the `X-Kong-Request-Debug` header. 
* If the requests originate from loopback addresses, the `X-Kong-Request-Debug-Token` header also needs to be set.

### X-Kong-Request-Debug header

If the `X-Kong-Request-Debug` header is set to `*`, timing information will be collected and exported for the current request.

In {{site.ee_product_name}}, you can also specify a list of filters, separated by commas, to filter the scope of the time information that is collected. Each filters specifies which phase to collect timing information from. The following filters are supported:

* `rewrite`
* `access`
* `balancer`
* `response`
* `header_filter`
* `body_filter`
* `upstream`
* `log`

If this header isn't present or contains an unknown value, timing information will not be collected for the current request.

### X-Kong-Request-Debug-Log header

If the `X-Kong-Request-Debug-Token` header is set to true, timing information will also be logged in the {{site.base_gateway}} error log with a log level of `notice`. By default, the `X-Kong-Request-Debug-Token` header is set to `false`. The log line will have the `[request-debug]` prefix to aid in searching.

## Debug request example 

The following is an example debug request:

```bash
curl http://localhost:8000/example \
    -H "X-Kong-Request-Debug: *" \
    -H "X-Kong-Request-Debug-Token: xxxxxx"
```

Here's an example of the output of the response header:

```json
{
    "request_id": "2effa21fb2d36d31f80ed02635cde86b",
    "workspace_id": "7b7f79f2-8d52-470c-a307-e76f986041cf",
    "child": {
        "rewrite": {
            "total_time": 0
        },
        "access": {
            "child": {
                "dns": {
                    "child": {
                        "example.host": {
                            "child": {
                                "resolve": {
                                    "total_time": 0,
                                    "cache_hit": true
                                }
                            },
                            "total_time": 0
                        }
                    },
                    "total_time": 0
                }
            },
            "total_time": 1
        },
        "header_filter": {
            "total_time": 0
        },
        "balancer": {
            "total_time": 0
        },
        "upstream": {
            "total_time": 100,
            "child": {
                "time_to_first_byte": {
                    "total_time": 20
                },
                "streaming": {
                    "Total_time": 80
                }
            }
        }
    }
}
```

If you analyze the example debug output, you can see that:
* The unit of `total_time` is `millisecond`.
* The DNS resolution for `example.host` was cached, which is why it's so fast in the example.
* The upstream took 100ms in this request.
    * The elapsed time from {{site.base_gateway}} sending the request to the upstream to {{site.base_gateway}} receiving the first byte is 20ms.
    * The elapsed time from the first byte to the last byte from the upstream is 80ms.

You can also filter the debug output:

```bash
curl http://localhost:8000/example \
    -H "X-Kong-Request-Debug: upstream" \
    -H "X-Kong-Request-Debug-Token: xxxxxx"
```

This will return something like the following:

```json
{
  "request_id": "a1a1530f8ddb6f6f2462916ae002b715",
  "child": {
    "upstream": {
      "total_time": 363,
      "child": {
        "time_to_first_byte": {
          "total_time": 363
        }
      }
    }
  }
}
```

### Truncation for large debugging output

The downstream system may impose a size restriction on response headers, leading {{site.base_gateway}} to truncate the `X-Kong-Request-Output` if it exceeds 2KB. This truncated output will be unconditionally logged in the `error_log`.

```bash
curl http://localhost:8000/large_debugging_output \
    -H "X-Kong-Request-Debug: *" \
    -H "X-Kong-Request-Debug-Token: xxxxxx"
```

This will return something like the following:

```json
{
  "request_id": "60ca0a4f8e5e936c43692f49b27d2932",
  "truncated": true,
  "message": "Output is truncated, please check the error_log for full output by filtering with the request_id."
}
```

Debug request outputs that exceed 3KB are split into multiple parts with the `request_id` as an identifier.

{:.note}
> **Note:** The debug output doesn't have a consistent pattern and may change in the future. It wasn't designed to be processed by automated tools. Rather, it was intended for human readability.

