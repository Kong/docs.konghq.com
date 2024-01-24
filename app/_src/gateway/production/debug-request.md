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

Request debugging is enabled by default and has the following configurations in [`kong.conf`](/gateway/{{page.release}}/reference/configuration/):

```
request_debug = on | off # enable or disable request debugging
request_debug_token <token> # Set debug token explicitly. Otherwise, it will be generated randomly when Kong starts, restarts, and reloads. 
```

The usage of debug token (`request-debug-token`) prevents abuse of the feature as only authorized personnel are able to issue debug requests. 

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

If the `X-Kong-Request-Debug-Log` header is set to true, timing information will also be logged in the {{site.base_gateway}} error log with a log level of `notice`. By default, the `X-Kong-Request-Debug-Log` header is set to `false`. The log line will have the `[request-debug]` prefix to aid in searching.

### X-Kong-Request-Debug-Token header

The `X-Kong-Request-Debug-Token` is a token for authenticating the client and making the debug request to prevent abuse. Debug requests originating from loopback addresses don't require this header.


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
    "child": {
        "rewrite": {
            "total_time": 0
        },
        "access": {
            "child": {
                "dns": {
                    "child": {
                        "example.com": {
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
                },
                "plugins": {
                    "child": {
                        "rate-limiting": {
                            "child": {
                                "176928d4-0949-47c8-8114-19cac8f86aab": {
                                    "child": {
                                        "redis": {
                                            "total_time": 1,
                                            "child": {
                                                "connections": {
                                                    "child": {
                                                        "tcp://localhost:6379": {
                                                            "child": {
                                                                "connect": {
                                                                    "child": {
                                                                        "dns": {
                                                                            "child": {
                                                                                "localhost": {
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
                                                                    "total_time": 0
                                                                }
                                                            },
                                                            "total_time": 0
                                                        }
                                                    },
                                                    "total_time": 0
                                                }
                                            }
                                        }
                                    },
                                    "total_time": 2
                                }
                            },
                            "total_time": 2
                        },
                        "request-transformer": {
                            "child": {
                                "cfd2d953-ad82-453c-9979-b7573f52c226": {
                                    "total_time": 0
                                }
                            },
                            "total_time": 0
                        }
                    },
                    "total_time": 2
                }
            },
            "total_time": 3
        },
        "log": {
            "child": {
                "plugins": {
                    "child": {
                        "http-log": {
                            "child": {
                                "22906259-2963-4c6d-96a1-6d36d21714e3": {
                                    "total_time": 4
                                }
                            },
                            "total_time": 4
                        }
                    },
                    "total_time": 4
                }
            },
            "total_time": 4
        },
        "header_filter": {
            "child": {
                "plugins": {
                    "child": {
                        "response-transformer": {
                            "child": {
                                "dee98076-a58f-490d-8f7b-8523506bf96d": {
                                    "total_time": 1
                                }
                            },
                            "total_time": 1
                        }
                    },
                    "total_time": 1
                }
            },
            "total_time": 1
        },
        "body_filter": {
            "child": {
                "plugins": {
                    "child": {
                        "response-transformer": {
                            "child": {
                                "dee98076-a58f-490d-8f7b-8523506bf96d": {
                                    "total_time": 0
                                }
                            },
                            "total_time": 1
                        }
                    },
                    "total_time": 1
                }
            },
            "total_time": 1
        },
        "balancer": {
            "total_time": 0
        },
        "upstream": {
            "total_time": 152,
            "child": {
                "time_to_first_byte": {
                    "total_time": 151
                },
                "streaming": {
                    "total_time": 1
                }
            }
        }
    },
    "request_id": "0208903e83001d216bee5435dbc5ed25"
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

