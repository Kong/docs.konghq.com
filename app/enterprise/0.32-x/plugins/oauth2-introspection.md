---
redirect_to: /hub/kong-inc/oauth2-introspection/0.32-x.html

title: OAuth2 Introspection
---
# OAuth2 Introspection Plugin

A Kong plugin to validate OAuth 2.0 access tokens using a third-party authorization server by leveraging the Introspection Endpoint specification ([RFC 7662](https://tools.ietf.org/html/rfc7662)).

## Configuration

Method 1: apply it on top of an API by executing the following request on your Kong server:

```
$ curl -i -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=oauth2-introspection" \
    --data "config.introspection_url=https://some/url" \
    --data "config.authorization_value=SOME_AUTHORIZATION"
```

Method 2: apply it globally (on all APIs) by executing the following request on your Kong server:

```
$ curl -i -X POST http://kong:8001/plugins \
    --data "name=oauth2-introspection" \
    --data "config.introspection_url=https://some/url" \
    --data "config.authorization_value=SOME_AUTHORIZATION"
```

## Configuration Parameters

| Form Parameter | Default | Description
| -------------- | ------- | -----------
| `name` | || The name of the plugin to use, in this case: oauth2-introspection.
|`config.introspection_url` || The full URL to the third-party introspection endpoint.
|`config.authorization_value` || The value to append to the Authorization header when requesting the introspection endpoint.
|`config.token_type_hint`<br>*optional* ||	The token_type_hint value to associate to introspection requests.
|`config.ttl`<br>**optional** |	`60` | The TTL in seconds for the introspection response. Set to 0 to disable the expiration.
|`config.hide_credentials`<br>*optional*	| `false` |	An optional boolean value telling the plugin to hide the credential to the upstream API server. It will be removed by Kong before proxying the request
|`config.timeout`<br>*optional* |	`10000` |	An optional timeout in milliseconds when sending data to the upstream server
|`config.keepalive`<br>*optional*	| `60000` |	An optional value in milliseconds that defines for how long an idle connection will live before being closed
|`config.anonymous`<br>*optional*	| `` | An optional string (consumer uuid) value to use as an "anonymous" consumer if authentication fails. If empty (default), the request will fail with an authentication failure 4xx
|`config.run_on_preflight`<br>*optional* | `true`	| A boolean value that indicates whether the plugin should run (and try to authenticate) on OPTIONS preflight requests, if set to false then OPTIONS requests will always be allowed

## Flow
<img src="/assets/img/docs/ee/oauth-introspection-flow.png" alt="OAuth2 Introspection Flow" />

## Associate the response to a Consumer

To associate the introspection response resolution to a Kong Consumer, you will have to provision a Kong Consumer with the same `username` returned by the Introspection Endpoint response.

## Upstream Headers

When a client has been authenticated, the plugin will append some headers to the request before proxying it to the upstream API/Microservice, so that you can identify the consumer in your code:

- `X-Consumer-ID`, the ID of the Consumer on Kong (if matched)
- `X-Consumer-Custom-ID`, the custom_id of the Consumer (if matched and if existing)
- `X-Consumer-Username`, the username of the Consumer (if matched and if existing)
- `X-Anonymous-Consumer`, will be set to true when authentication failed, and the 'anonymous' consumer was set instead.
- `X-Credential-Scope`, as returned by the Introspection response (if any)
- `X-Credential-Client-ID`, as returned by the Introspection response (if any)
- `X-Credential-Username`, as returned by the Introspection response (if any)
- `X-Credential-Token-Type`, as returned by the Introspection response (if any)
- `X-Credential-Exp`, as returned by the Introspection response (if any)
- `X-Credential-Iat`, as returned by the Introspection response (if any)
- `X-Credential-Nbf`, as returned by the Introspection response (if any)
- `X-Credential-Sub`, as returned by the Introspection response (if any)
- `X-Credential-Aud`, as returned by the Introspection response (if any)
- `X-Credential-Iss`, as returned by the Introspection response (if any)
- `X-Credential-Jti`, as returned by the Introspection response (if any)

Note: Aforementioned `X-Credential-*` headers are not set when authentication failed, and the 'anonymous' consumer was set instead.
