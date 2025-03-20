---
nav_title: Overview
---

Insert arbitrary API calls before the request to the upstream service. This 
plugin comprises Callout objects, where each one specifies the API callout 
declaratively, with customizations to query params, headers, and body components 
of the request. API callout responses are stored in the Kong shared context 
under a `kong.ctx.shared.callouts.<name>`. Responses can be cached with a TTL.

{:.note}
> Content modifications in both callout and upstream bodies assume a JSON content 
type.

## Examples

#### A callout that requests a token upstream and inserts it in the upstream request.

```
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

The configuration above has 2 main parts: `callouts` and `upstream`. `callouts` 
is an array of HTTP requests to be made and stored in the shared context; 
upstream contains customizations to the upstream request components. Within a 
callout, all request components can be tuned; for example, the `query` component 
above has `forward` configuration, which causes all the downstream request 
headers to be forwarded as callout request headers.

#### A callout that retries a failed request

```
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
		}
	}
}
```

Note the presence of an `error` field, specifying the status codes considered 
errors and the number of retries to make. The schema reference contains the full 
list of supported configurations.

#### A callout that caches the result

```
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

This will result in the callout response being cached for 360 seconds. Each 
callout object may also contain a `cache` component. The schema reference
contains the full list of supported configurations.

#### A "Request Collapsing" callout

A callout can be built to issue requests to multiple APIs and build a response 
from Kong.

```
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

In this toy example, we are taking one field of the first callout, another from 
the second and building a full response.

## The callout context

Callout request and response context is stored in 
`kong.ctx.shared.callouts.<name>`. The request context contains:
- `.<name>.params`: the full config for the callout request, including `url`, 
  `method`, `query`, `headers`, `body`, `decode`, `ssl_verify`, `proxy`, 
  `timeouts`, and others (as specified in the plugin schema);
- `.<name>.retries`: the list of request retries, if `error` is set to `retry`. 
  Contains `reason`, which can be `error`, for TCP errors, or `code`, if the 
  retry was caused by an HTTP status code; `err`, with the specific error, and 
  `http_code`;
- `.<name>.n_retries`: the total number of retries.
- `caching`: list of cache-related configurations, as specified in the plugin's 
  schema; additionally, if a `cache_key` field is set, it overrides the cache 
  key for the current callout (this is useful in dynamic customizations of cache 
  key, via `by_lua` Lua code).
  
The response context contains:
- `status`
- `headers`
- `body`

Note that headers and body storage can be disabled via the 
`callout.response.headers.store` and `callout.response.body.store` boolean.

## Lua code

All `custom` fields support Lua expressions in the value portion; any PDK method 
or Lua function available within the Kong sandbox can be used. The syntax is the 
same as the request-transformer-advanced plugin uses for Lua expressions. In 
`custom` values, callouts can be referenced via the shorthand `callouts.<name>`
table, which is a syntax sugar for `kong.ngx.shared.callouts.<name>`. Lua 
expressions do not carry side effects.

`by_lua` fields work in a similar fashion, but do not support 
request-transformer-style shortcuts, neither the `callouts` syntax sugar; 
however, `by_lua` code can produce side effects and modify callout and upstream 
requests.

Both request and response callout objects may contain a `by_lua` field; 
`request.by_lua` runs before the callout request is performed and is useful to 
further customize aspects of the request; `response.by_lua` runs after a 
response is obtained, and is useful to customize aspects of the response such as 
caching.

The upstream object may also contain a `by_lua` field, for Lua code 
that runs before the upstream request runs; this is useful to further customize 
the upstream request, or even to bypass it completely, shortcircuiting the 
request and responding from Kong.

Lua code may contain references and modify values in the callout context; one 
example is customizing the cache key used to store a callout:

```
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

Note both the `cache` top-level object and the `by_lua` field in 
`callout.response.by_lua`. The former defines global caching behavior, while the 
latter runs Lua code modifying the callout cache key. This example is crafted to 
execute Lua code in the response `by_lua`; a similar use-case could customize 
the `url` field of the callout request by running Lua code setting
`kong.ctx.shared.callouts.<name>` in the request `by_lua` field.
