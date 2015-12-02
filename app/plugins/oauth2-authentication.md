---
id: page-plugin
title: Plugins - OAuth 2.0 Authentication
header_title: OAuth 2.0 Authentication
header_icon: /assets/images/icons/plugins/oauth2-authentication.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Installation
      - label: Configuration
  - label: Usage
    items:
      - label: Endpoints
      - label: Create a Consumer
      - label: Create an Application
      - label: Upstream Headers
  - label: oAuth 2.0 Flows
    items:
      - label: Client Credentials
      - label: Authorization Code
      - label: Resource Owner Password Credentials
---

Add an OAuth 2.0 authentication layer with the [Authorization Code Grant][authorization-code-grant], [Client Credentials][client-credentials], [Implicit Grant][implicit-grant] or [Resource Owner Password Credentials Grant][password-grant] flow. This plugin **requires** the [SSL Plugin][ssl-plugin] with the `only_https` parameter set to `true` to be already installed on the API, failing to do so will result in a security weakness.

----

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file:

```yaml
plugins_available:
  - oauth2
```

Every node in the Kong cluster should have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=oauth2" \
    --data "config.scopes=email,phone,address" \
    --data "config.mandatory_scope=true"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter                                    | default | description
---                                               | ---     | ---
`name`                                            |      | The name of the plugin to use, in this case: `oauth2`
`config.scopes`                                    |      | Describes an array of comma separated scope names that will be available to the end user
`config.mandatory_scope`<br>*optional*             | `false` | An optional boolean value telling the plugin to require at least one scope to be authorized by the end user
`config.token_expiration`<br>*optional*            | `7200`  | An optional integer value telling the plugin how long should a token last, after which the client will need to refresh the token. Set to `0` to disable the expiration.
`config.enable_authorization_code`<br>*optional*   | `true`  | An optional boolean value to enable the three-legged Authorization Code flow ([RFC 6742 Section 4.1][authorization-code-grant])
`config.enable_client_credentials`<br>*optional*   | `false` | An optional boolean value to enable the Client Credentials Grant flow ([RFC 6742 Section 4.4][client-credentials])
`config.enable_implicit_grant`<br>*optional*       | `false` | An optional boolean value to enable the Implicit Grant flow which allows to provision a token as a result of the authorization process ([RFC 6742 Section 4.2][implicit-grant])
`config.enable_password_grant`<br>*optional*       | `false` | An optional boolean value to enable the Resource Owner Password Credentials Grant flow ([RFC 6742 Section 4.3][password-grant])
`config.hide_credentials`<br>*optional*            | `false` | An optional boolean value telling the plugin to hide the credential to the upstream API server. It will be removed by Kong before proxying the request
`config.accept_http_if_already_terminated`<br>*optional* | `false` | Accepts HTTPs requests that have already been terminated by a proxy or load balancer and the `x-forwarded-proto: https` header has been added to the request. Only enable this option if the Kong server cannot be publicly accessed and the only entry-point is such proxy or load balancer.

----

## Usage

In order to use the plugin, you first need to create a consumer to associate one or more credentials to. The Consumer represents a developer using the final service/API.

### Endpoints

By default the OAuth 2.0 plugin listens on the following endpoints:

Endpoint                     | description
---                         | ---
`/oauth2/authorize`          | The endpoint to the Authorization Server that provisions authorization codes for the [Authorization Code][authorization-code-grant] flow, or the access token when the [Implicit Grant][implicit-grant] flow is enabled.
`/oauth2/token`              | The endpoint to the Authorization Server that provision access tokens. This is also the only endpoint to use for the [Client Credentials][client-credentials] and [Resource Owner Password Credentials Grant][password-grant] flows.

The clients trying to authorize and request access tokens must use these endpoints.

### Create a Consumer

You need to associate a credential to an existing [Consumer][consumer-object] object, that represents a user consuming the API. To create a [Consumer][consumer-object] you can execute the following request:

```bash
$ curl -X POST http://kong:8001/consumers/ \
    --data "username=user123" \
    --data "custom_id=SOME_CUSTOM_ID"
```

parameter                       | required                                            | description
---                             | ---                                                 | ---
`username`<br>*semi-optional*   | Either this field or `custom_id` must be specified. | The username of the consumer.
`custom_id`<br>*semi-optional*  | Either this field or `username` must be specified.  | A custom identifier used to map the consumer to another database.

A [Consumer][consumer-object] can have many credentials.

### Create an Application

Then you can finally provision new OAuth 2.0 credentials (also called "OAuth applications") by making the following HTTP request:

```bash
$ curl -X POST http://kong:8001/consumers/{consumer_id}/oauth2 \
    --data "name=Test%20Application" \
    --data "client_id=SOME-CLIENT-ID" \
    --data "client_secret=SOME-CLIENT-SECRET" \
    --data "redirect_uri=http://some-domain/endpoint/"
```

`consumer_id`: The [Consumer][consumer-object] entity to associate the credentials to

form parameter                | description
---                           | ---
`name`                        | The name to associate to the credential. In OAuth 2.0 this would be the application name.
`client_id`<br>*optional*     | You can optionally set your own unique `client_id`. If missing, the plugin will generate one.
`client_secret`<br>*optional* | You can optionally set your own unique `client_secret`. If missing, the plugin will generate one.
`redirect_uri`                | The URL in your app where users will be sent after authorization ([RFC 6742 Section 3.1.2][redirect-uri])

## Upstream Headers

When a client has been authenticated and authorized, the plugin will append some headers to the request before proxying it to the upstream API/Microservice, so that you can identify the consumer and the end-user in your code:

* `X-Consumer-ID`, the ID of the Consumer on Kong
* `X-Consumer-Custom-ID`, the `custom_id` of the Consumer (if set)
* `X-Consumer-Username`, the `username` of the Consumer (if set)
* `X-Authenticated-Scope`, the comma-separated list of scopes that the end user has authenticated (if available)
* `X-Authenticated-Userid`, the logged-in user ID who has granted permission to the client

You can use this information on your side to implement additional logic. You can use the `X-Consumer-ID` value to query the Kong Admin API and retrieve more information about the Consumer.

----

## oAuth 2.0 Flows

## Client Credentials

The [Client Credentials][client-credentials] flow will work out of the box, without building any authorization page. The clients will need to use the `/oauth2/token` endpoint to request an access token.

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

A diagram repreenting this flow:

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

5. The backend must add the `provision_key` and `authenticated_userid` parameters to the `client_id`, `response_type` and `scope` parameters and it will make a `POST` request to Kong at your API address, on the `/oauth2/authorize` endpoint. If an `Authorization` header has been sent by the client, that must be added too. The equivalent of:

    ```bash
    $ curl https://your.api.com/oauth2/authorize \
        --header "Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW" \
        --data "client_id=XXX" \
        --data "response_type=XXX" \
        --data "scope=XXX" \
        --data "provision_key=XXX" \
        --data "authenticated_userid=XXX"
    ```

    The `provision_key` is the key the plugin has generated when it has been added to the API, while `authenticated_userid` is the ID of the logged-in end user who has granted the permission.

6. Kong will respond with a JSON response:

    ```json
    {
      "redirect_uri": "http://some/url"
    }
    ```

    With either a `200 OK` or `400 Bad Request` response code depending if the request was successful or not.
7. In **both** cases, ignore the response status code and just redirect the user to whatever URI is being returned in the `redirect_uri` property.

8. The client appication will take it from here, and will continue the flow with Kong with no other interaction with your web application. Like exchaging the authorization code for an access token if it's an Authorization Code Grant flow.

9. Once the Access Token has been retrieved, the client application will make requests on behalf of the user to your final API.

10. Access Tokens can expire, and when that happens the client application needs to renew the Access Token with Kong and retreive a new one.

In this flow, the steps that you need to implement are:

* The login page, you probably already have it (step 2)
* The Authorization page, with its backend that will simply collect the values, make a `POST` request to Kong and redirect the user to whatever URL Kong has returned (steps 3 to 7).

## Resource Owner Password Credentials

The [Resource Owner Password Credentials Grant][password-grant] is a much simpler version of the Authorization Code flow, but it still requires to build an authorization backend (without the frontend) in order to make it work properly.

![OAuth 2.0 Flow](/assets/images/docs/oauth2/oauth2-flow2.png)

1. The client application make a request including some OAuth2 parameters, including `username` and `password` parameters.

2. The backend will authenticate the `username` and `password` sent by the client, and if successful will add the `provision_key` and `authenticated_userid` parameters to the parameters originally sent by the client, and it will make a `POST` request to Kong at your API address, on the `/oauth2/token` endpoint. If an `Authorization` header has been sent by the client, that must be added too. The equivalent of:

    ```bash
    $ curl https://your.api.com/oauth2/token \
        --header "Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW" \
        --data "client_id=XXX" \
        --data "client_secret=XXX" \
        --data "scope=XXX" \
        --data "provision_key=XXX" \
        --data "authenticated_userid=XXX" \
        --data "username=XXX" \
        --data "password=XXX"
    ```

    The `provision_key` is the key the plugin has generated when it has been added to the API, while `authenticated_userid` is the ID of the end user whose `username` and `password` belong to.

3. Kong will respond with a JSON response

4. The JSON response sent by Kong must be sent back to the original client as it is. If the operation is successful, this response will include an access token, otherwise it will include an error.

In this flow, the steps that you need to implement are:

* The backend endpoint that will process the original request and will authenticate the `username` and `password` values sent by the client, and if the authentication is successful, make the request to Kong and return back to the client whatever response Kong has sent back.

[ssl-plugin]: /plugins/ssl/
[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
[authorization-code-grant]: https://tools.ietf.org/html/rfc6749#section-4.1
[client-credentials]: https://tools.ietf.org/html/rfc6749#section-4.4
[implicit-grant]: https://tools.ietf.org/html/rfc6749#section-4.2
[password-grant]: https://tools.ietf.org/html/rfc6749#section-4.3
[redirect-uri]: https://tools.ietf.org/html/rfc6749#section-3.1.2
