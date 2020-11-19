---
name: OAuth2 Audience
publisher: Telkom Indonesia
version: 0.2.2

desc: Authenticate Kong consumer using a third-party OAuth 2.0 / OpenID Connect provider.
description: |
  Validate access tokens from a third-party OAuth 2.0 Authorization Server (including OpenID Connect)
  by leveraging JWT verification ([RFC 7519](https://tools.ietf.org/html/rfc7519)) and/or OAuth2 Introspection ([RFC 7662](https://tools.ietf.org/html/rfc7662))
  and associate the external OAuth2 client with an existing Kong consumer based on the [audience parameter](https://tools.ietf.org/html/rfc7519#section-4.1.3). 
  
  Each consumer can have multiple audiences. At the same time, each registered audience can only be associated with a specific issuer (`iss` claim) and client id (`client_id` claim). This allow for complete control over the list of extenal OAuth2 Client that can be associated with the consumer.

type: plugin
categories: 
  - authentication

support_url: https://github.com/TelkomIndonesia/kong-plugin-oauth2-audience
source_url: https://github.com/TelkomIndonesia/kong-plugin-oauth2-audience

kong_version_compatibility: 
  community_edition: 
    compatible: 
      - 2.0.x

params: 
  name: oauth2-audience
  service_id: true
  route_id: true
  consumer_id: false
  protocols: ["http", "https"]
  yaml_examples: false
  k8s_examples: false
  dbless_compatible: partially
  dbless_explanation: |
    Consumers and Credentials can be created with declarative configuration.

    Admin API endpoints which do POST, PUT, PATCH or DELETE on Credentials are not available on DB-less mode.

  config:
    - name: issuer
      required: true
      value_in_examples: https://issuer.tld
      description: |
        OAuth2 issuer identifier that needs to be present in `iss` claim on the OAuth2 token.
    - name: oidc_conf_discovery
      required: false
      default: "`true`"
      description: |
        A boolean value that indicates whether the plugin should send [OpenID Connect Discovery](https://openid.net/specs/openid-connect-discovery-1_0.html#ProviderConfig) request to obtain information regarding JWT Verfication or OAuth2 Token Instropection. If set to `false` then appropriate `jwt_*` or `introspection_*` settings are required.
    - name: required_scope
      required: false
      default:
      description: |
        Describes an array of scope names that must be available on the OAuth2 token.
    - name: required_audiences
      required: false
      default:
      description: |
        Describes an array of audience value that must be available in the OAuth2 token `aud` claim.
    - name: audience_prefix
      required: false
      default:
      description: |
        Prefix string that must be added in the `aud` claim to be recognized as kong credential. For example if the audience associated with a consumer is `nCztu5Jrz18YAWmkwOGJkQe9T8lB99l4` and the prefix is `kong:`, then `aud` claim should contains `kong:nCztu5Jrz18YAWmkwOGJkQe9T8lB99l4`

    - name: jwt_signature_secret
      required: semi
      default:
      description: |
        Secret key used in Symmetric JWT verification.
    - name: jwt_signature_public_key
      required: semi
      default: 
      description: |
        Public key used in Asymmetric JWT verification. If left empty and `oidc_conf_discovery` is not false, then this plugin will try to extract it from endpoint specified in `jwks_uri` metadata in OpenID Connect Discovery response.
    - name: jwt_signature_algorithm
      required: false
      default: |
        `["HS256", "HS512", "RS256"]`
      description: |
        A list of allowed JWT signature algorithm. This plugin only support `HS256`, `HS512`, and `RS256` algorithm.
    - name: jwt_introspection
      required: false
      default: false
      description: |
        If `true` and `introspection_endpoint` is available, then verified JWT will also be introspected.

    - name: introspection_endpoint
      required: semi
      default:
      description: |
        Oauth2 Instrospection Endpoint for introspecting non-JWT token or if `jwt_introspection` is set to `true`. If left empty and `oidc_conf_discovery` is not false, then this plugin will use `introspection_endpoint` metadata in OpenID Connect Discovery response. 
    - name: introspection_auth_method
      required: semi
      default: "`client_secret_basic`"
      description: |
        Authentication method used to contact the introspection endpoint. The valid value is one of (1) `client_secret_basic` for basic auth, (2) `client_secret_post` for using credential in URL-Encoded body, (3) `private_key_jwt` for using Asymetric JWT or (4) `client_secret_jwt` for using Symetric JWT.
    - name: introspection_client_id
      required: semi
      default:
      description: |
        Client ID information to be used in introspection request. Depending on `introspection_auth_method`, it will be used as basic auth username, `client_id` form param, or `iss` JWT claim.
    - name: introspection_client_secret
      required: semi
      default:
      description: |
        Client Secret information to be used in introspection request when using `client_secret_basic`, `client_secret_post`, or `client_secret_jwt` authentication method.
    - name: introspection_client_rsa_private_key
      required: semi
      default:
      description: |
        Client Secret information to be used in introspection request when using `private_key_jwt` authentication method.
    - name: introspection_client_rsa_private_key_id
      required: semi
      default:
      description: |
        The value of `kid` JWT Header when using `private_key_jwt` authentication method.
    - name: introspection_param_name_token
      required: false
      default: "`token`"
      description: |
        URL-Encoded Form parameter name to contain the OAuth2 token to be introspected.
    - name: introspection_params
      required: false
      default:
      description: |
        Additional parameter to be included in OAuth2 Token Introspection request.
    - name: introspection_claim_expiry
      required: false
      default: "`exp`"
      description: |
        OAuth2 Token expiry claim. The value will be used in caching mechanism.
    - name: introspection_cache_max_ttl
      required: false
      default: 900
      description: |
        Maximum TTL to cache introspection result.

    - name: auth_header_map
      required: false
      default: |
        `{"consumer_id":"X-Consumer-ID","consumer_custom_id":"X-Consumer-Custom-ID","consumer_username":"X-Consumer-Username","credential":"x-authenticated-audience","anonymous":"X-Anonymous-Consumer"}`
      description: |
        Map containing upstream header name to be passed to upstream server.
    - name: claim_header_map
      required: false
      default: |
        `{"iss":"x-oauth2-issuer","client_id":"x-oauth2-client","sub":"x-oauth2-subject"}`
      description: |
        OAuth2 Token claim to upstream header map to be passed to upstream server.

    - name: auth_header_name
      required: false
      default: "`authorization`"
      description: |
        The name of the header supposed to carry the access token. Default: `authorization`.
    - name: hide_credentials
      required: false
      default: "`false`"
      description: |
        An optional boolean value telling the plugin to show or hide the credential from the upstream service. If `true`, the plugin will strip the credential from the request (i.e. the header or querystring containing the key) before proxying it.
    - name: anonymous
      required: false
      default:
      description: |
        An optional string (consumer uuid) value to use as an "anonymous" consumer if authentication fails. If empty (default), the request will fail with an authentication failure `4xx`. Please note that this value must refer to the Consumer `id` attribute which is internal to Kong, and **not** its `custom_id`.
    - name: run_on_preflight
      required: false
      default: "`true`"
      description: |
        A boolean value that indicates whether the plugin should run (and try to authenticate) on `OPTIONS` preflight requests, if set to `false` then `OPTIONS` requests will always be allowed.

    - name: ssl_verify
      required: false
      default: "`true`"
      description: |
        A boolean value that indicates whether the plugin should do SSL/TLS verification when sending OAuth2 Token Instrospection or OpenID Connect Discovery request

  extra: |
    Once applied, any user with a valid credential can access the Service.
    To restrict usage to only some of the authenticated users, also add the
    [ACL](/plugins/acl/) plugin (not covered here) and create allowed or
    denied groups of users.

---

## Installation

From Luarocks:

```bash
luarocks install kong-plugin-oauth2-audience
```

From source:

```bash
git clone https://github.com/TelkomIndonesia/kong-plugin-oauth2-audience
cd kong-plugin-oauth2-audience
luarocks make *.rockspec
```

## Usage

### Create a Consumer

You need to associate an audience to an existing [Consumer][consumer-object] object.
A Consumer can have many audiences.

{% tabs %}
{% tab With a Database %}
To create a Consumer, you can execute the following request:

```bash
curl -d "username=user123&custom_id=SOME_CUSTOM_ID" http://kong:8001/consumers/
```
{% tab Without a Database %}
Your declarative configuration file will need to have one or more Consumers. You can create them
on the `consumers:` yaml section:

``` yaml
consumers:
- username: user123
  custom_id: SOME_CUSTOM_ID
```
{% endtabs %}

In both cases, the parameters are as described below:

parameter                       | description
---                             | ---
`username`<br>*semi-optional*   | The username of the consumer. Either this field or `custom_id` must be specified.
`custom_id`<br>*semi-optional*  | A custom identifier used to map the consumer to another database. Either this field or `username` must be specified.

If you are also using the [ACL](/plugins/acl/) plugin and allow lists with this
service, you must add the new consumer to the allowed group. See
[ACL: Associating Consumers][acl-associating] for details.

### Create an OAuth2 Audience

{% tabs %}
{% tab With a database %}
You can provision new audience by making the following HTTP request:

```bash
$ curl -X POST http://kong:8001/consumers/{consumer}/oauth2-audiences \
  --data  "audience=62eb165c070a41d5c1b58d9d3d725ca1" \
  --data  "issuer=https://issuer.in.iss.claim.tld" \
  --data  "client_id=value-of-client-id-claim"

HTTP/1.1 201 Created

{
    "consumer": { "id": "876bf719-8f18-4ce5-cc9f-5b5af6c36007" },
    "created_at": 1443371053000,
    "id": "62a7d3b7-b995-49f9-c9c8-bac4d781fb59",
    "audience": "62eb165c070a41d5c1b58d9d3d725ca1",
    "issuer": "https://issuer.in.iss.claim.tld",
    "client_id": "value-of-client-id-claim"
}
```

{% tab Without a database %}
You can add audience on your declarative config file on the `oauth2_audiences` yaml entry:

``` yaml
oauth2_audiences:
- consumer: {consumer}
  audience: "62eb165c070a41d5c1b58d9d3d725ca1"
  issuer: "https://issuer.in.iss.claim.tld"
  client_id: "value-of-client-id-claim
```

<div class="alert alert-warning">
  <strong>Note:</strong> It is recommended to let Kong auto-generate the audience.
</div>
{% endtabs %}

In both cases the fields/parameters work as follows:

field/parameter     | description
---                 | ---
`{consumer}`        | The `id` or `username` property of the [Consumer][consumer-object] entity to associate the audience to.
`audience`<br>*optional* | This value that must be available in `aud` claim of the OAuth2 token. You can optionally set your own unique `audience` to associate the external OAuth2 client. If missing, the plugin will generate one.
`issuer`            | The issuer identifier that must be available in `iss` claim of the OAuth2 token.
`client_id`         | The client id that must be available in `client_id` claim of the OAuth2 token.

### Delete an OAuth2 Audience

You can delete an OAuth2 Audience by making the following HTTP request:

```bash
$ curl -X DELETE http://kong:8001/consumers/{consumer}/oauth2-audiences/{id}
HTTP/1.1 204 No Content
```

* `consumer`: The `id` or `username` property of the [Consumer][consumer-object] entity to associate the credentials to.
* `id`: The `id` attribute of the OAuth2 Audience object.

### Upstream Headers

When a client has been authenticated, the plugin will append some headers to the request before proxying it to the upstream service, so that you can identify the Consumer in your code:

* `X-Consumer-ID`, the ID of the Consumer on Kong
* `X-Consumer-Custom-ID`, the `custom_id` of the Consumer (if set)
* `X-Consumer-Username`, the `username` of the Consumer (if set)
* `x-authenticated-audience`, the identifier of the Credential (only if the consumer is not the 'anonymous' consumer)
* `X-Anonymous-Consumer`, will be set to `true` when authentication failed, and the 'anonymous' consumer was set instead.
* `x-oauth2-issuer`, the value of `iss` claim from the OAauth2 Token.
* `x-oauth2-client`, the value of `client_id` claim from the OAauth2 Token.

You can use this information on your side to implement additional logic. You can use the `X-Consumer-ID` value to query the Kong Admin API and retrieve more information about the Consumer. Additonally you can control the name of headers used and additional claims to be forwarded via `auth_header_map` and `claim_header_map` configuration.

### Paginate through OAuth2 Audiences

<div class="alert alert-warning">
  <strong>Note:</strong> This endpoint was introduced in Kong 0.11.2.
</div>

You can paginate through the OAuth2 Audiences for all Consumers using the following
request:

```bash
$ curl -X GET http://kong:8001/oauth2-audiences

{
   "data":[
      {
         "id":"17ab4e95-9598-424f-a99a-ffa9f413a821",
         "created_at":1507941267000,
         "audience":"Qslaip2ruiwcusuSUdhXPv4SORZrfj4L",
         "issuer": "https://issuer.in.iss.claim.tld",
         "client_id": "value-of-client-id-claim",
         "consumer": { "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880" }
      },
      {
         "id":"6cb76501-c970-4e12-97c6-3afbbba3b454",
         "created_at":1507936652000,
         "audience":"nCztu5Jrz18YAWmkwOGJkQe9T8lB99l4",
         "issuer": "https://issuer.in.iss.claim.tld",
         "client_id": "value-of-client-id-claim",
         "consumer": { "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880" }
      },
      {
         "id":"b1d87b08-7eb6-4320-8069-efd85a4a8d89",
         "created_at":1507941307000,
         "audience":"26WUW1VEsmwT1ORBFsJmLHZLDNAxh09l",
         "issuer": "https://issuer.in.iss.claim.tld",
         "client_id": "value-of-client-id-claim",
         "consumer": { "id": "3c2c8fc1-7245-4fbb-b48b-e5947e1ce941" }
      }
   ]
   "next":null,
}
```

You can filter the list by consumer by using this other path:

```bash
$ curl -X GET http://kong:8001/consumers/{username or id}/oauth2-audiences

{
    "data": [
       {
         "id":"6cb76501-c970-4e12-97c6-3afbbba3b454",
         "created_at":1507936652000,
         "audience":"nCztu5Jrz18YAWmkwOGJkQe9T8lB99l4",
         "issuer": "https://issuer.in.iss.claim.tld",
         "client_id": "value-of-client-id-claim",
         "consumer": { "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880" }
       }
    ]
    "next":null,
}
```

`username or id`: The username or id of the consumer whose credentials need to be listed

### Retrieve the Consumer associated with an OAuth2 Audience

<div class="alert alert-warning">
  <strong>Note:</strong> This endpoint was introduced in Kong 0.11.2.
</div>

It is possible to retrieve a [Consumer][consumer-object] associated with an API
Key using the following request:

```bash
curl -X GET http://kong:8001/oauth2-audiences/{audience or id}/consumer

{
   "created_at":1507936639000,
   "username":"foo",
   "id":"c0d92ba9-8306-482a-b60d-0cfdd2f0e880"
}
```

* `audience or id`: The `id` or `audience` property of the OAuth2 Audience for which to get the
associated Consumer.

[configuration]: /latest/configuration
[consumer-object]: /latest/admin-api/#consumer-object
[acl-associating]: /plugins/acl/#associating-consumers
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
