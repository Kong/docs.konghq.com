---
title: Datakit examples
badge: enterprise
alpha: true
---

Example configuration by use case.

## Authenticating Kong to a third party service

```yaml
plugins:
- name: datakit
  service: my-service
  config:
    debug: true
    nodes:
    - name: BUILD_AUTH_HEADERS
      jq: |
        {
            "Authorization": "Basic YGA8NNu8877lkOmNsagsdWAyZXQ=",   
        }
      type: jq
    - name: BUILD_AUTH_BODY
      type: handlebars
      template: |
          grant_type=client_credentials
    - name: AUTH_CALL
      type: call
      inputs:
      - headers: BUILD_AUTH_HEADERS
      - body: BUILD_AUTH_BODY
      url:  http://auth-server:5000/token
      method: post
    - name: BUILD_UPSTREAM_AUTH_HEADERS
      type: jq
      inputs:
      - auth: AUTH_CALL
      output:
        service_request.headers
      jq: |
        {
        "Authorization":$auth.token_type + " " +    $auth.access_token
        }
```

## Manipulate request headers

```yaml
plugins:
- name: datakit
  service: my-service
  config:
    debug: true
    nodes:
    - name: MY_HEADERS
      type: jq
      inputs:
      - req: request.headers
      jq: |
        {
          "X-My-Call-Header": $req.apikey // "default value"
        }
    - name: CALL
      type: call
      inputs:
      - headers: MY_HEADERS
      url: https://httpbin.konghq.com/anything
    - name: EXIT
      type: exit
      inputs:
      - body: CALL.body
      status: 200
```

## Combine two APIs into one response

```yaml
plugins:
- name: datakit
  service: my-service
  config:
    debug: true
    nodes:
    - name: CAT_FACT
      type: call
      url:  https://catfact.ninja/fact
    - name: DOG_FACT
      type: call
      url:  https://dogapi.dog/api/v1/facts
    - name: JOIN
      type: jq
      inputs:
      - cat: CAT_FACT.body
      - dog: DOG_FACT.body
      jq: |
        {
          "cat_fact": $cat.fact,
          "dog_fact": $dog.facts
        }
    - name: EXIT
      type: exit
      inputs:
      - body: JOIN
      status: 200
```

## Pass API response data into templates using handlebars

```yaml
services:
- name: demo
  url: http://httpbin.konghq.com
  routes:
  - name: my-route
    paths:
    - /anything
    strip_path: false
    methods:
    - GET
    - POST
    plugins:
    - name: datakit
      config:
        debug: true
        nodes:
        - name: FIRST
          type: call
          url: https://api.zippopotam.us/br/93000-000
        - name: MY_HEADERS
          type: jq
          inputs:
          - first: FIRST.body
          output: service_request.headers
          jq: |
            {
              "X-Hello": "World",
              "X-Foo": "Bar",
              "X-Country": $first.country
            }
        - name: MY_BODY
          type: handlebars
          content_type: text/plain
          inputs:
          - first: FIRST.body
          output: service_request.body
          template: |
            {% raw %} Coordinates for {{ first.places.0.[place name] }}, {{ first.places.0.state }}, {{ first.country }} are ({{ first.places.0.latitude }}, {{ first.places.0.longitude }}){% endraw %}.
```

## Adjust Kong service and route properties

```yaml
services:
- name: demo
  url: http://httpbin.konghq.com
  routes:
  - name: my-route
    paths:
    - /anything
    strip_path: false
    methods:
    - GET
    - POST
    plugins:
    - name: post-function
      config:
        access:
        - |
          local cjson = require("cjson")

          kong.ctx.shared.from_lua = cjson.encode({
            nested = {
              message = "hello from lua land!",
            },
          })
        header_filter:
        - |
          local cjson = require("cjson")
          local ctx = kong.ctx.shared

          local api_response = ctx.api_response or "null"
          local res = cjson.decode(api_response)

          kong.response.set_header("X-Lua-Encoded-Object", api_response)
          kong.response.set_header("X-Lua-Plugin-Country", res.country)
          kong.response.set_header("X-Lua-Plugin-My-String", ctx.my_string)
          kong.response.set_header("X-Lua-Plugin-My-Encoded-String", ctx.my_encoded_string)
    - name: datakit
      config:
        debug: true
        nodes:
        #
        # read "builtin" kong properties
        #
        - name: ROUTE_ID
          type: property
          property: kong.route_id

        - name: SERVICE
          type: property
          property: kong.router.service
          content_type: application/json

        #
        # read some properties set by a Lua plugin
        #
        # NOTE: these depend on the fact that they are being set during the
        # access phase and because Lua plugins run before wasm filters
        #
        - name: LUA_VALUE_ENCODED
          type: property
          property: kong.ctx.shared.from_lua

        - name: LUA_VALUE_DECODED
          type: property
          property: kong.ctx.shared.from_lua
          content_type: application/json

        #
        # make an external API call and stash the result in kong.ctx.shared
        #
        - name: API
          type: call
          url: https://api.zippopotam.us/br/93000-000

        - name: SET_API_RESPONSE
          type: property
          property: kong.ctx.shared.api_response
          input: API.body

        #
        # fetch a property that we know does not exist
        #
        - name: UNSET_PROP
          type: property
          # should return `null`
          property: kong.ctx.shared.nothing_here

        #
        # emit a JSON-encoded string from jq and store it to kong.ctx.shared
        #
        - name: JSON_ENCODED_STRING
          type: jq
          jq: '"my string"'

        # encoded as `my string`
        - name: SET_MY_STRING_PLAIN
          type: property
          input: JSON_ENCODED_STRING
          property: kong.ctx.shared.my_string

        # [JSON-]encoded as `"my string"`
        - name: SET_MY_STRING_ENCODED
          type: property
          input: JSON_ENCODED_STRING
          property: kong.ctx.shared.my_encoded_string
          content_type: application/json

        # get `my string`, return `my string`
        - name: GET_PLAIN_STRING
          type: property
          property: kong.ctx.shared.my_string

        # get `"my string"`, return `"my string"`
        - name: GET_JSON_STRING_ENCODED
          type: property
          property: kong.ctx.shared.my_encoded_string

        # get `"my string"`, decode, return `my string`
        - name: GET_JSON_STRING_DECODED
          type: property
          property: kong.ctx.shared.my_encoded_string
          content_type: application/json

        #
        # assemble a response
        #
        - name: BODY
          type: jq
          inputs:
            # value is also fetched after being set
            API_body: API.body
            SERVICE: SERVICE
            ROUTE_ID: ROUTE_ID
            LUA_VALUE_ENCODED: LUA_VALUE_ENCODED
            LUA_VALUE_DECODED: LUA_VALUE_DECODED
            UNSET_PROP: UNSET_PROP
            GET_PLAIN_STRING: GET_PLAIN_STRING
            GET_JSON_STRING_ENCODED: GET_JSON_STRING_ENCODED
            GET_JSON_STRING_DECODED: GET_JSON_STRING_DECODED
          jq: |
            {
              "API.body": $API_body,
              SERVICE: $SERVICE,
              ROUTE_ID: $ROUTE_ID,
              LUA_VALUE_ENCODED: $LUA_VALUE_ENCODED,
              LUA_VALUE_DECODED: $LUA_VALUE_DECODED,
              UNSET_PROP: $UNSET_PROP,
              GET_PLAIN_STRING: $GET_PLAIN_STRING,
              GET_JSON_STRING_ENCODED: $GET_JSON_STRING_ENCODED,
              GET_JSON_STRING_DECODED: $GET_JSON_STRING_DECODED,
            }

        - name: exit
          type: exit
          inputs:
            body: BODY
```