---
nav_title: Overview
---

Using the Request Callout plugin, you can insert arbitrary API calls before
proxying the request to the upstream service. 

This plugin comprises of Callout objects, where each object specifies the 
API callout declaratively, with customizations to query params, headers, and 
body components of the request. 

API callout responses are stored in the {{site.base_gateway}} shared context 
under a `kong.ctx.shared.callouts.<name>`. Responses can be cached with a TTL.

{:.note}
> Content modifications in both callout and upstream bodies assume a JSON content 
type.

## Examples

### Callout that requests a token upstream and inserts it in the upstream request

This configuration has two main parts: `callouts` and `upstream`. 
* `callouts` is an array of HTTP requests to be made and stored in the shared context
* `upstream` contains customizations to the upstream request components

Within a callout, all request components can be tuned: for example, the `query` component 
in this example has `forward` configuration, which causes all the downstream request 
headers to be forwarded as callout request headers.


```json
{
	"name": "request-callout",
	"config": {
		"callouts": [
			{
				"name": "auth1",
				"request": {
					"url": "https://run.mocky.io/v3/3d380788-e25f-4101-970b-70e95eacf892",
					"method": "GET",
					"query": {
						"forward": true
					}
				},
				"response": {
					"body": {
						"store": true,
						"decode": true
					}
				}
			}
		],
		"upstream": {
			"headers": {
				"custom": {
					"Authorization": "Bearer $(callouts.auth1.response.body.token)"
				}
			}
		}
	}
}
```
### Callout that retries a failed request

In the following example, note the presence of an `error` field, specifying the status 
codes considered errors and the number of retries to make. `error_response_code` 
and `error_response_msg` determine the status code and message to response with 
in case of failures, both if the error policy is `retry` or `fail`. 
`error_response_msg` supports Lua expressions, with the same syntax and 
semantics as Request Transformer Advanced plugin [templates](/hub/kong-inc/request-transformer-advanced/templates).


The [schema reference](/hub/kong-inc/request-callout/configuration/) contains the full 
list of supported configurations.

```json
{
	"name": "request-callout",
	"config": {
		"callouts": [
			{
				"name": "auth1",
				"request": {
					"url": "https://run.mocky.io/v3/3d380788-e25f-4101-970b-70e95eacf892",
					"method": "GET",
					"query": {
						"forward": true
					},
					"error": {
						"on_error": "retry",
						"http_statuses": [500, 502, 503],
						"retries": 3,
						"error_response_code": 500,
						"error_response_msg": "internal server error"
					}
				},
				"response": {
					"body": {
						"store": true,
						"decode": true
					}
				}
			}
		],
		"upstream": {
			"headers": {
				"custom": {
					"Authorization": "Bearer $(callouts.auth1.response.body.token)"
				}
			}
		}
	}
}
```



### Callout that caches the result

Each callout object may also contain a `cache` component. In the following example, 
the storage strategy in use is `memory`, meaning that data is stored in
{{site.base_gateway}}'s local shared dictionary storage. Redis storage is also supported.

The [schema reference](/hub/kong-inc/request-callout/configuration/) contains the full 
list of supported configurations.

The following example will result in the callout response being cached for 360 seconds:

```json
{
	"name": "request-callout",
	"config": {
		"callouts": [
			{
				"name": "auth1",
				"request": {
					"url": "https://run.mocky.io/v3/3d380788-e25f-4101-970b-70e95eacf892",
					"method": "GET",
					"query": {
						"forward": true
					},
					"error": {
						"http_statuses": [500, 502, 503],
						"retries": 3
					}
				},
				"response": {
					"body": {
						"store": true,
						"decode": true
					}
				}
			}
		],
		"upstream": {
			"headers": {
				"custom": {
					"Authorization": "Bearer $(callouts.auth1.response.body.token)"
				}
			}
		},
		"cache": {
			"strategy": "memory",
			"cache_ttl": 360
		}
	}
}
```

### "Request Collapsing" callout

You can build a callout to issue requests to multiple APIs and build a response 
from {{site.base_gateway}}.

In this example, we take one field of the first callout, another from 
the second, and building a full response:

```json
{
	"name": "request-callout",
	"config": {
		"callouts": [
			{
				"name": "c1",
				"request": {
					"url": "http://httpbin.org/uuid",
					"method": "GET"
				},
				"response": {
					"body": {
						"decode": true
					}
				}
			},
			{
				"name": "c2",
				"request": {
					"url": "http://httpbin.org/anything",
					"method": "GET"
				},
				"response": {
					"body": {
						"decode": true
					}
				}
			}
		],
		"upstream": {
			"by_lua": "kong.response.exit(200, { uuid = kong.ctx.shared.callouts.c1.response.body.uuid, origin = kong.ctx.shared.callouts.c2.response.body.url})"
		}
	}
}
```

### Callout that dynamically customizes the cache key via Lua code

In this callout example:
* The `cache` top-level object defines global caching behavior
* The `by_lua` field in `callout.response.by_lua` runs Lua code modifying the callout cache key

This example is crafted to execute Lua code in the response `by_lua`. 
A similar use case could customize the `url` field of the callout request by 
running Lua code setting `kong.ctx.shared.callouts.<name>` in the request `by_lua` field.
 
```json
{
	"name": "request-callout",
	"config": {
		"callouts": [
			{
				"name": "auth1",
				"request": {
					"url": "https://run.mocky.io/v3/3d380788-e25f-4101-970b-70e95eacf892",
					"method": "GET",
					"query": {
						"forward": true
					},
					"error": {
						"http_statuses": [500],
						"retries": 3
					}
				},
				"response": {
					"body": {
						"store": true,
						"decode": true
					},
					"by_lua": "kong.ctx.shared.callouts.auth1.caching.cache_key = 'some_key'"
				}
			}
		],
		"upstream": {
			"headers": {
				"custom": {
					"Authorization": "Bearer $(callouts.auth1.response.body.token)"
				}
			}
		},
		"cache": {
			"strategy": "redis",
			"redis": {
				"host": "localhost",
				"port": 6379
			},
			"cache_ttl": 360
		}
	}
}
```

### Callout that dynamically customizes URL via Lua code

Similar to the previous example, the following callout uses Lua code to 
customize the request. Now, instead of running after the response is received, 
the Lua code executes before the request is made.

```json
{
	"name": "request-callout",
		"config": {
			"callouts": [
			{
				"name": "c1",
				"request": {
					"url": "http://httpbin.org/status/400",
					"method": "GET",
					"query": {
						"forward": true
					},
					"by_lua": "kong.ctx.shared.callouts.c1.request.params.url = 'http://httpbin.org/status/200'"
				},
				"response": {
					"body": {
						"store": true,
						"decode": false
					}
				}
			}
			],
			"upstream": {
				"headers": {
					"custom": {
						"Status-Code": "$(callouts.c1.response.status)"
					}
				}
			}
		}
}
```

### Send a request containing form data

Configure the plugin to send a request in the `x-www-form-urlencoded` format.
In this example, we’re sending a form containing credentials, including a client secret using a Vault reference.

```json
{
	"name": "request-callout",
	"config": {
		"callouts": [
			{
				"name": "auth",
				"request": {
					"body": {
						"custom": {}
					},
					"url": "https://test.com/bearer",
					"by_lua": "kong.ctx.shared.callouts.auth.request.params.body = ngx.encode_args({grant_type=\"client_credentials\",client_id=\"myclientid\",scope=\"scope\",client_secret=kong.vault.get(\"{vault://env/TEST_SECRET}\")})"
				}
			}
		]
	}
}
```

### Dynamically change the request URL

Configure the plugin to send a request to a different URL based on a header value.
In this example, we’re expecting the client to provide a `x-custom-header` header with a value to append to the specified URL.

```json
{
	"name": "request-callout",
	"config": {
		"callouts": [
			{
				"name": "call",
				"request": {
					"url": "http://httpbin.org/",
					"method": "GET",
					"by_lua": "kong.ctx.shared.callouts.callout1.request.params.url = 'http://httpbin.org/' .. (kong.request.get_header('x-custom-header') or '')"
				}
			}
		]
	}
}
```

## The callout context

Callout request and response context is stored in 
`kong.ctx.shared.callouts.<name>`. 

The request context contains:
- `.<name>.request.params`: The full configuration for the callout request, including `url`, 
  `method`, `query`, `headers`, `body`, `decode`, `ssl_verify`, `proxy`, 
  `timeouts`, and others (as specified in the HTTP options plugin schema).
  The `headers` key is case sensitive.
- `.<name>.request.retries`: The list of request retries, if `error` is set to `retry`. 
  Contains `reason`, which can be `error`, for TCP errors, or `code`, if the 
  retry was caused by an HTTP status code, `err`, with the specific error, and 
  `http_code`, with the specific HTTP status code that caused the retry.
- `.<name>.request.n_retries`: the total number of retries.
- `.<name>.caching`: List of cache-related configurations, as specified in the plugin's 
  schema. If a `cache_key` field is set, it overrides the cache 
  key for the current callout (this is useful in dynamic customizations of cache 
  key, via `by_lua` Lua code).

The response context contains:
- `status`
- `headers`
- `body`

Headers and body storage can be disabled via the 
[`config.callouts.response.headers.store`](/hub/kong-inc/request-callout/configuration/#config-callouts-response-headers-store)
and [`config.callouts.response.body.store`](/hub/kong-inc/request-callout/configuration/#config-callouts-response-body-store)
parameters.

## Lua code

All `custom` fields support Lua expressions in the value portion, and any PDK method 
or Lua function available within the Kong sandbox can be used. The syntax is the 
same as the [Request Transformer Advanced plugin](/hub/kong-inc/request-transformer-advanced/)
uses for Lua expressions. In  `custom` values, callouts can be referenced via the shorthand `callouts.<name>`
table, which is a syntax sugar for `kong.ngx.shared.callouts.<name>`. 
Lua expressions do not carry side effects.

`by_lua` fields work in a similar fashion, but do not support 
Request Transformer-style shortcuts, neither the `callouts` syntax sugar.
However, `by_lua` code can produce side effects and modify callout and upstream 
requests.

Both request and response callout objects may contain a `by_lua` field:
* `request.by_lua` runs before the callout request is performed and is useful to 
further customize aspects of the request
* `response.by_lua` runs after a response is obtained, and is useful to
customize aspects of the response such as caching.

The upstream object may also contain a `by_lua` field for Lua code 
that runs before the upstream request runs. This is useful to further customize 
the upstream request, or even to bypass it completely, short-circuiting the 
request and responding from {{site.base_gateway}}.

As seen in the examples on this page, Lua code may contain references and modify values 
in the callout context. 

{:.important}
> Schema validation will detect syntax issues. Other errors, such as 
> nil references, happen at runtime and lead to an `Internal Server Error`. 
> Lua code must be thoroughly tested to ensure correctness and that it meets 
> performance requirements.

## `forward` flag

Callout request and upstream request configuration blocks contain a `forward` 
flag that controls whether specific request components are used to build the 
callout or upstream request. If `config.upstream.headers.forward` is set to `false`, 
this effectively clears all incoming request headers, including essential 
headers such as `Content-Type`, `Host`, and others. 
These headers can be reinserted via the `config.upstream.headers.custom` configuration parameter.
