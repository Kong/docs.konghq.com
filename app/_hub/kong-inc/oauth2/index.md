---
name: OAuth 2.0 Authentication
publisher: Kong Inc.

desc: Add OAuth 2.0 authentication to your Services
description: |
  Add an OAuth 2.0 authentication layer with the [Authorization Code Grant](https://tools.ietf.org/html/rfc6749#section-4.1), [Client Credentials](https://tools.ietf.org/html/rfc6749#section-4.4),
  [Implicit Grant](https://tools.ietf.org/html/rfc6749#section-4.2) or [Resource Owner Password Credentials Grant](https://tools.ietf.org/html/rfc6749#section-4.3) flow.

  ----

  <div class="alert alert-warning">
    <strong>Note:</strong> As per the OAuth2 specs, this plugin requires the
    underlying service to be served over HTTPS. To avoid any
    confusion, we recommend that you configure the Route used to serve the
    underlying Service to only accept HTTPS traffic (via its `protocols`
    property).
  </div>

  <div class="alert alert-warning">
    <strong>Note:</strong> The functionality of this plugin as bundled
    with versions of Kong prior to 0.12.0
    differs from what is documented herein. Refer to the
    <a href="https://github.com/Kong/kong/blob/master/CHANGELOG.md">CHANGELOG</a>
    for details.
  </div>



type: plugin
categories:
  - authentication

kong_version_compatibility:
    community_edition:
      compatible:
        - 1.0.x
        - 0.14.x
        - 0.13.x
        - 0.12.x
        - 0.11.x
        - 0.10.x
        - 0.9.x
        - 0.8.x
        - 0.7.x
        - 0.6.x
        - 0.5.x
        - 0.4.x
    enterprise_edition:
      compatible:
        - 0.34-x
        - 0.33-x
        - 0.32-x
        - 0.31-x

params:
  name: oauth2
  service_id: true
  route_id: false
  consumer_id: false
  protocols: ["http", "https"]
  config:
    - name: scopes
      required: true
      default:
      value_in_examples: email,phone,address
      description: Describes an array of comma separated scope names that will be available to the end user
    - name: mandatory_scope
      required: false
      default: "`false`"
      value_in_examples: true
      description: An optional boolean value telling the plugin to require at least one scope to be authorized by the end user
    - name: token_expiration
      required: false
      default: "`7200`"
      description: |
        An optional integer value telling the plugin how many seconds a token should last, after which the client will need to refresh the token. Set to `0` to disable the expiration.
    - name: enable_authorization_code
      required: false
      default: "`false`"
      value_in_examples: true
      description: |
        An optional boolean value to enable the three-legged Authorization Code flow ([RFC 6742 Section 4.1](https://tools.ietf.org/html/rfc6749#section-4.1))
    - name: enable_client_credentials
      required: false
      default: "`false`"
      description: |
        An optional boolean value to enable the Client Credentials Grant flow ([RFC 6742 Section 4.4](https://tools.ietf.org/html/rfc6749#section-4.4))
    - name: enable_implicit_grant
      required: false
      default: "`false`"
      description: |
        An optional boolean value to enable the Implicit Grant flow which allows to provision a token as a result of the authorization process ([RFC 6742 Section 4.2](https://tools.ietf.org/html/rfc6749#section-4.2))
    - name: enable_password_grant
      required: false
      default: "`false`"
      description: |
        An optional boolean value to enable the Resource Owner Password Credentials Grant flow ([RFC 6742 Section 4.3](https://tools.ietf.org/html/rfc6749#section-4.3))
    - name: auth_header_name
      required: false
      default: "`authorization`"
      description: |
        The name of the header supposed to carry the access token. Default: `authorization`.
    - name: hide_credentials
      required: false
      default: "`false`"
      description: |
        An optional boolean value telling the plugin to show or hide the credential from the upstream service. If `true`, the plugin will strip the credential from the request (i.e. the header containing the client credentials) before proxying it.
    - name: accept_http_if_already_terminated
      required: false
      default: "`false`"
      description: |
        Accepts HTTPs requests that have already been terminated by a proxy or load balancer and the `x-forwarded-proto: https` header has been added to the request. Only enable this option if the Kong server cannot be publicly accessed and the only entry-point is such proxy or load balancer.
    - name: anonymous
      required: false
      default:
      description: |
        An optional string (consumer uuid) value to use as an "anonymous" consumer if authentication fails. If empty (default), the request will fail with an authentication failure `4xx`. Please note that this value must refer to the Consumer `id` attribute which is internal to Kong, and **not** its `custom_id`.
    - name: global_credentials
      required: false
      default: "`false`"
      description: |
        An optional boolean value that allows to use the same OAuth credentials generated by the plugin with any other Service whose OAuth 2.0 plugin configuration also has `config.global_credentials=true`.
    - name: refresh_token_ttl
      required: false
      default: "`1209600`"
      description: |
        An optional integer value telling the plugin how many seconds a token/refresh token pair is valid for, and can be used to generate a new access token. Default value is 2 weeks. Set to `0` to keep the token/refresh token pair indefinitely valid.

  extra: |
    <div class="alert alert-warning">
        <center>The option <code>config.refresh_token_ttl</code> is only available from version 0.12.0 and later</center>
    </div>

    Once applied, any user with a valid credential can access the Service.
    To restrict usage to only some of the authenticated users, also add the
    [ACL](/plugins/acl/) plugin (not covered here) and create whitelist or
    blacklist groups of users.

---

## Usage

In order to use the plugin, you first need to create a consumer to associate one or more credentials to. The Consumer represents a developer using the upstream service.

### Endpoints

By default the OAuth 2.0 plugin listens on the following endpoints when a client consumes the underlying Service via the [proxy port][proxy-port]:

Endpoint                     | description
---                         | ---
`/oauth2/authorize`          | The endpoint to the Authorization Server that provisions authorization codes for the [Authorization Code](https://tools.ietf.org/html/rfc6749#section-4.1) flow, or the access token when the [Implicit Grant](https://tools.ietf.org/html/rfc6749#section-4.2) flow is enabled. Only `POST` is supported.
`/oauth2/token`              | The endpoint to the Authorization Server that provision access tokens. This is also the only endpoint to use for the [Client Credentials](https://tools.ietf.org/html/rfc6749#section-4.4) and [Resource Owner Password Credentials Grant](https://tools.ietf.org/html/rfc6749#section-4.3) flows. Only `POST` is supported.

The clients trying to authorize and request access tokens must use these endpoints. Remember that the endpoints above must be combined with the right URI path or headers that you normally use to match a configured Route through Kong.

### Create a Consumer

You need to associate a credential to an existing [Consumer][consumer-object] object. To create a Consumer, you can execute the following request:

```bash
$ curl -X POST http://kong:8001/consumers/ \
    --data "username=user123" \
    --data "custom_id=SOME_CUSTOM_ID"
```

parameter                       | default | description
---                             | ---     | ---
`username`<br>*semi-optional*   |         | The username of the consumer. Either this field or `custom_id` must be specified.
`custom_id`<br>*semi-optional*  |         | A custom identifier used to map the consumer to another database. Either this field or `username` must be specified.

A [Consumer][consumer-object] can have many credentials.

### Create an Application

Then you can finally provision new OAuth 2.0 credentials (also called "OAuth applications") by making the following HTTP request:

```bash
$ curl -X POST http://kong:8001/consumers/{consumer_id}/oauth2 \
    --data "name=Test%20Application" \
    --data "client_id=SOME-CLIENT-ID" \
    --data "client_secret=SOME-CLIENT-SECRET" \
    --data "redirect_uris[]=http://some-domain/endpoint/"
```

`consumer_id`: The [Consumer][consumer-object] entity to associate the credentials to

form parameter                | default | description
---                           | ---     | ---
`name`                        |         | The name to associate to the credential. In OAuth 2.0 this would be the application name.
`client_id`<br>*optional*     |         | You can optionally set your own unique `client_id`. If missing, the plugin will generate one.
`client_secret`<br>*optional* |         | You can optionally set your own unique `client_secret`. If missing, the plugin will generate one.
`redirect_uris`               |         | An array with one or more URLs in your app where users will be sent after authorization ([RFC 6742 Section 3.1.2](https://tools.ietf.org/html/rfc6749#section-3.1.2))

## Migrating Access Tokens

If you are migrating your existing OAuth 2.0 applications and access tokens over to Kong, then you can:

* Migrate consumers and applications by creating OAuth 2.0 applications as explained above.
* Migrate access tokens using the `/oauth2_tokens` endpoints in the Kong's Admin API. For example:

```bash
$ curl -X POST http://kong:8001/oauth2_tokens \
    --data 'credential={"id": "KONG-APPLICATION-ID" }' \
    --data "token_type=bearer" \
    --data "access_token=SOME-TOKEN" \
    --data "refresh_token=SOME-TOKEN" \
    --data "expires_in=3600"
```

form parameter                        | default | description
---                                   | ---     | ---
`credential`                          |         | Contains the ID of the OAuth 2.0 application created on Kong.
`token_type`<br>*optional*            | `bearer`| The [token type](https://tools.ietf.org/html/rfc6749#section-7.1).
`access_token`<br>*optional*          |         | You can optionally set your own access token value, otherwise a random string will be generated.
`refresh_token`<br>*optional*         |         | You can optionally set your own unique refresh token value, otherwise a random string will be generated.
`expires_in`                          |         | The expiration time (in seconds) of the access token.
`scope`<br>*optional*                 |         | The authorized scope associated with the token.
`authenticated_userid`<br>*optional*  |         | The custom ID of the user who authorized the application.

## Upstream Headers

When a client has been authenticated and authorized, the plugin will append some headers to the request before proxying it to the upstream service, so that you can identify the consumer and the end-user in your code:

* `X-Consumer-ID`, the ID of the Consumer on Kong
* `X-Consumer-Custom-ID`, the `custom_id` of the Consumer (if set)
* `X-Consumer-Username`, the `username` of the Consumer (if set)
* `X-Authenticated-Scope`, the comma-separated list of scopes that the end user has authenticated, if available (only if the consumer is not the 'anonymous' consumer)
* `X-Authenticated-Userid`, the logged-in user ID who has granted permission to the client (only if the consumer is not the 'anonymous' consumer)
* `X-Anonymous-Consumer`, will be set to `true` when authentication failed, and the 'anonymous' consumer was set instead.

You can use this information on your side to implement additional logic. You can use the `X-Consumer-ID` value to query the Kong Admin API and retrieve more information about the Consumer.

----

## OAuth 2.0 Flows

## Client Credentials

The [Client Credentials](https://tools.ietf.org/html/rfc6749#section-4.4) flow will work out of the box, without building any authorization page. The clients will need to use the `/oauth2/token` endpoint to request an access token.

### Authorization Code

After provisioning Consumers and associating OAuth 2.0 credentials to them, it is important to understand how the OAuth 2.0 authorization flow works. As opposed to most of the Kong plugins, the OAuth 2.0 plugin requires some little additional work on your side to make everything work well:

* You **must** implement an authorization page on your web application, that will talk with the plugin server-side.
* *Optionally* you need to explain on your website/documentation how to consume your OAuth 2.0 protected services, so that developers accessing your service know how to build their client implementations

#### The flow explained

Building the authorization page is going to be the primary task that the plugin itself cannot do out of the box, because it requires to check that the user is properly logged in, and this operation is strongly tied with your authentication implementation.

The authorization page is made of two parts:

* The frontend page that the user will see, and that will allow him to authorize the client application to access his data
* The backend that will process the HTML form displayed in the frontend, that will talk with the OAuth 2.0 plugin on Kong, and that will ultimately redirect the user to a third party URL.

<div class="alert alert-warning">
  <div class="container" style="text-align: center;">
    <a href="{{ site.repos.oauth2_hello_world }}">You can see a sample implementation in node.js + express.js on GitHub</a>
  </div>
</div>

A diagram representing this flow:

<div class="alert alert-info">
  <a title="OAuth 2.0 Flow" href="/assets/images/docs/oauth2/oauth2-flow.png" target="_blank"><img src="/assets/images/docs/oauth2/oauth2-flow.png"/></a>
</div>

1. The client application will redirect the end user to the authorization page on your web application, passing `client_id`, `response_type` and `scope` (if required) as querystring parameters. This is a sample authorization page:
    <div class="alert alert-info">
      <center><img title="OAuth 2.0 Prompt" src="/assets/images/docs/oauth2/oauth2-prompt.png"/></center>
    </div>

2. Before showing the actual authorization page, the web application will make sure that the user is logged in.

3. The client application will send the `client_id` in the querystring, from which the web application can retrieve both the OAuth 2.0 application name, and developer name, by making the following request to Kong:

    ```bash
    $ curl kong:8001/oauth2?client_id=XXX
    ```

4. If the end user authorized the application, the form will submit the data to your backend with a `POST` request, sending the `client_id`, `response_type` and `scope` parameters that were placed in `<input type="hidden" .. />` fields.

5. The backend must add the `provision_key` and `authenticated_userid` parameters to the `client_id`, `response_type` and `scope` parameters and it will make a `POST` request to Kong at your Service address, on the `/oauth2/authorize` endpoint. If an `Authorization` header has been sent by the client, that must be added too. The equivalent of:

    ```bash
    $ curl https://your.service.com/oauth2/authorize \
        --header "Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW" \
        --data "client_id=XXX" \
        --data "response_type=XXX" \
        --data "scope=XXX" \
        --data "provision_key=XXX" \
        --data "authenticated_userid=XXX"
    ```

    The `provision_key` is the key the plugin has generated when it has been added to the Service while `authenticated_userid` is the ID of the logged-in end user who has granted the permission.

6. Kong will respond with a JSON response:

    ```json
    {
      "redirect_uri": "http://some/url"
    }
    ```

    With either a `200 OK` or `400 Bad Request` response code depending if the request was successful or not.
7. In **both** cases, ignore the response status code and just redirect the user to whatever URI is being returned in the `redirect_uri` property.

8. The client application will take it from here, and will continue the flow with Kong with no other interaction with your web application. Like exchanging the authorization code for an access token if it's an Authorization Code Grant flow.

9. Once the Access Token has been retrieved, the client application will make requests on behalf of the user to your upstream service.

10. Access Tokens can expire, and when that happens the client application needs to renew the Access Token with Kong and retrieve a new one.

In this flow, the steps that you need to implement are:

* The login page, you probably already have it (step 2)
* The Authorization page, with its backend that will simply collect the values, make a `POST` request to Kong and redirect the user to whatever URL Kong has returned (steps 3 to 7).

----

## Resource Owner Password Credentials

The [Resource Owner Password Credentials Grant](https://tools.ietf.org/html/rfc6749#section-4.3) is a much simpler version of the Authorization Code flow, but it still requires to build an authorization backend (without the frontend) in order to make it work properly.

![OAuth 2.0 Flow](/assets/images/docs/oauth2/oauth2-flow2.png)

1. On the first request, the client application make a request including some OAuth2 parameters, including `username` and `password` parameters, to your web-application.

2. The backend of your web-application will authenticate the `username` and `password` sent by the client, and if successful will add the `provision_key`, `authenticated_userid` and `grant_type` parameters to the parameters originally sent by the client, and it will make a `POST` request to Kong at, on the `/oauth2/token` endpoint of the configured plugin. If an `Authorization` header has been sent by the client, that must be added too. The equivalent of:

    ```bash
    $ curl https://your.service.com/oauth2/token \
        --header "Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW" \
        --data "client_id=XXX" \
        --data "client_secret=XXX" \
        --data "grant_type=password" \
        --data "scope=XXX" \
        --data "provision_key=XXX" \
        --data "authenticated_userid=XXX" \
        --data "username=XXX" \
        --data "password=XXX"
    ```

    The `provision_key` is the key the plugin has generated when it has been added to the Service, while `authenticated_userid` is the ID of the end user whose `username` and `password` belong to.

3. Kong will respond with a JSON response

4. The JSON response sent by Kong must be sent back to the original client as it is. If the operation is successful, this response will include an access token, otherwise it will include an error.

In this flow, the steps that you need to implement are:

* The backend endpoint that will process the original request and will authenticate the `username` and `password` values sent by the client, and if the authentication is successful, make the request to Kong and return back to the client whatever response Kong has sent back.

----

## Refresh Token

When your access token expires, you can generate a new access token using the refresh token you received in conjunction to your expired access token.

```bash
$ curl -X POST https://your.service.com/oauth2/token \
    --data "grant_type=refresh_token" \
    --data "client_id=XXX" \
    --data "client_secret=XXX" \
    --data "refresh_token=XXX"
```

[consumer-object]: /latest/admin-api/#consumer-object
[proxy-port]: https://docs.konghq.com/latest/configuration/#proxy_listen
