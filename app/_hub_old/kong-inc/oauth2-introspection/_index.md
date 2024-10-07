---
name: OAuth 2.0 Introspection
publisher: Kong Inc.
version: 1.3-x
desc: Integrate Kong with a third-party OAuth 2.0 Authorization Server
description: |
  Validate access tokens sent by developers using a third-party OAuth 2.0
  Authorization Server, by leveraging its Introspection Endpoint
  ([RFC 7662](https://tools.ietf.org/html/rfc7662)). This plugin assumes that
  the Consumer already has an access token that will be validated against a
  third-party OAuth 2.0 server.

  **Note**: The [OpenID Connect Plugin][oidcplugin] supports
  OAuth 2.0 Token Introspection as well and offers functionality beyond
  this plugin, such as restricting access by scope.

  [oidcplugin]: /hub/kong-inc/openid-connect/
enterprise: true
plus: true
type: plugin
categories:
  - authentication
kong_version_compatibility:
  community_edition:
    compatible: null
  enterprise_edition:
    compatible:
      - 2.8.x
      - 2.7.x
      - 2.6.x
      - 2.5.x
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x
      - 1.5.x
      - 1.3-x
      - 0.36-x
params:
  name: oauth2-introspection
  service_id: true
  route_id: true
  konnect_examples: false
  dbless_compatible: 'yes'
  config:
    - name: introspection_url
      required: true
      default: null
      value_in_examples: 'https://example-url.com'
      datatype: string
      description: |
        The full URL to the third-party introspection endpoint.
    - name: authorization_value
      required: true
      default: null
      value_in_examples: Basic MG9hNWlpbjpPcGVuU2VzYW1l
      datatype: string
      description: |
        The value to set as the `Authorization` header when querying the introspection endpoint. This depends on the OAuth 2.0 server, but usually is the `client_id` and `client_secret` as a Base64-encoded Basic Auth string (`Basic MG9hNWl...`).
    - name: token_type_hint
      required: false
      default: null
      value_in_examples: null
      datatype: string
      description: |
        The `token_type_hint` value to associate to introspection requests.
    - name: ttl
      required: false
      default: 30
      value_in_examples: null
      datatype: number
      description: |
        The TTL in seconds for the introspection response. Set to 0 to disable the expiration.
    - name: hide_credentials
      required: true
      default: null
      value_in_examples: null
      datatype: boolean
      description: |
        An optional boolean value telling the plugin to hide the credential to the upstream API server. It will be removed by Kong before proxying the request.
    - name: timeout
      required: false
      default: 10000
      value_in_examples: null
      datatype: integer
      description: |
        An optional timeout in milliseconds when sending data to the upstream server.
    - name: keepalive
      required: false
      default: 60000
      value_in_examples: null
      datatype: integer
      description: |
        An optional value in milliseconds that defines how long an idle connection lives before being closed.
    - name: anonymous
      required: false
      default: null
      value_in_examples: null
      datatype: string
      description: |
        An optional string (consumer uuid) value to use as an "anonymous" consumer if authentication fails. If empty (default), the request will fail with an authentication failure 4xx.
    - name: run_on_preflight
      required: false
      default: true
      value_in_examples: null
      datatype: boolean
      description: |
        A boolean value that indicates whether the plugin should run (and try to authenticate) on `OPTIONS` preflight requests. If set to `false`, then `OPTIONS` requests will always be allowed.
    - name: consumer_by
      required: true
      default: CONSUMER_BY_DEFAULT
      value_in_examples: username
      datatype: string
      description: |
        A string indicating whether to associate OAuth2 `username` or `client_id`
        with the consumer's username. OAuth2 `username` is mapped to a consumer's
        `username` field, while an OAuth2 `client_id` maps to a consumer's
        `custom_id`.
    - name: introspect_request
      required: true
      default: false
      value_in_examples: null
      datatype: boolean
      description: |
        A boolean indicating whether to forward information about the current
        downstream request to the introspect endpoint. If true, headers
        `X-Request-Path` and `X-Request-Http-Method` will be inserted into the
        introspect request.
    - name: custom_introspection_headers
      required: true
      default: null
      value_in_examples: null
      datatype: map of string keys and string values
      description: |
        A list of custom headers to be added in the introspection request.
    - name: custom_claims_forward
      required: true
      default: null
      value_in_examples: null
      datatype: set of string elements
      description: |
        A list of custom claims to be forwarded from the introspection response
        to the upstream request. Claims are forwarded in headers with prefix
        `X-Credential-{claim-name}`.
---

### Flow

![OAuth2 Introspection Flow](/assets/images/docs/oauth2/oauth2-introspection.png)

### Associate the response to a Consumer

To associate the introspection response resolution to a Kong Consumer, you will have to provision a Kong Consumer with the same `username` returned by the Introspection Endpoint response.

### Upstream Headers

When a client has been authenticated, the plugin will append some headers to the request before proxying it to the upstream API/Microservice, so that you can identify the consumer in your code:

- `X-Consumer-ID`, the ID of the Consumer on Kong (if matched)
- `X-Consumer-Custom-ID`, the `custom_id` of the Consumer (if matched and if existing)
- `X-Consumer-Username`, the `username of` the Consumer (if matched and if existing)
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

Additionally, any claims specified in `config.custom_claims_forward` will also be forwarded with the `X-Credential-` prefix.

Note: Aforementioned `X-Credential-*` headers are not set when authentication failed, and the 'anonymous' consumer was set instead.
