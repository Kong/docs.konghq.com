---
title: Authentication Reference
---

## Introduction

Traffic to your upstream services (APIs or microservices) is typically controlled by the application and
configuration of various Kong [authentication plugins][plugins]. Since Kong's Service entity represents
a 1-to-1 mapping of your own upstream services, the simplest scenario is to configure authentication
plugins on the Services of your choosing.

## Generic authentication

The most common scenario is to require authentication and to not allow access for any unauthenticated request.
To achieve this any of the authentication plugins can be used. The generic scheme/flow of those plugins
works as follows:

1. Apply an auth plugin to a Service, or globally (you cannot apply one on consumers)
2. Create a `consumer` entity
3. Provide the consumer with authentication credentials for the specific authentication method
4. Now whenever a request comes in Kong will check the provided credentials (depends on the auth type) and
it will either block the request if it cannot validate, or add consumer and credential details
in the headers and forward the request

The generic flow above does not always apply, for example when using external authentication like LDAP,
then there is no consumer to be identified, and only the credentials will be added in the forwarded headers.

The authentication method specific elements and examples can be found in each [plugin's documentation][plugins].

## Consumers

The easiest way to think about consumers is to map them one-on-one to users. Yet, to Kong this does not matter.
The core principle for consumers is that you can attach plugins to them, and hence customize request behaviour.
So you might have mobile apps, and define one consumer for each app, or version of it. Or have a consumer per
platform, e.g. an android consumer, an iOS consumer, etc.

It is an opaque concept to Kong and hence they are called "consumers" and not "users".

## Anonymous Access

Kong has the ability to configure a given Service to allow **both** authenticated **and** anonymous access.
You might use this configuration to grant access to anonymous users with a low rate-limit, and grant access
to authenticated users with a higher rate limit.

To configure a Service like this, you first apply your selected authentication plugin, then create a new
consumer to represent anonymous users, then configure your authentication plugin to allow anonymous
access. Here is an example, which assumes you have already configured a Service named `example-service` and
the corresponding route:

1. ### Create an example Service and a Route

    Issue the following cURL request to create `example-service` pointing to mockbin.org, which will echo
    the request:

    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/services/ \
      --data 'name=example-service' \
      --data 'url=http://mockbin.org/request'
    ```

    Add a route to the Service:

    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/services/example-service/routes \
      --data 'paths[]=/auth-sample'
    ```

    The url `http://localhost:8000/auth-sample` will now echo whatever is being requested.

2. ### Configure the key-auth Plugin for your Service

    Issue the following cURL request to add a plugin to a Service:

    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/services/example-service/plugins/ \
      --data 'name=key-auth'
    ```

    Be sure to note the created Plugin `id` - you'll need it in step 5.

3. ### Verify that the key-auth plugin is properly configured

    Issue the following cURL request to verify that the [key-auth][key-auth]
    plugin was properly configured on the Service:

    ```bash
    $ curl -i -X GET \
      --url http://localhost:8000/auth-sample
    ```

    Since you did not specify the required `apikey` header or parameter, and you have not yet
    enabled anonymous access, the response should be `403 Forbidden`:

    ```http
    HTTP/1.1 403 Forbidden
    ...

    {
      "message": "No API key found in headers or querystring"
    }
    ```

4. ### Create an anonymous Consumer

    Every request proxied by Kong must be associated with a Consumer. You'll now create a Consumer
    named `anonymous_users` (that Kong will utilize when proxying anonymous access) by issuing the
    following request:

    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/consumers/ \
      --data "username=anonymous_users"
    ```

    You should see a response similar to the one below:

    ```http
    HTTP/1.1 201 Created
    Content-Type: application/json
    Connection: keep-alive

    {
      "username": "anonymous_users",
      "created_at": 1428555626000,
      "id": "bbdf1c48-19dc-4ab7-cae0-ff4f59d87dc9"
    }
    ```

    Be sure to note the Consumer `id` - you'll need it in the next step.

5. ### Enable anonymous access

    You'll now re-configure the key-auth plugin to permit anonymous access by issuing the following
    request (**replace the sample uuids below by the `id` values from step 2 and 4**):

    ```bash
    $ curl -i -X PATCH \
      --url http://localhost:8001/plugins/<your-plugin-id> \
      --data "config.anonymous=<your-consumer-id>"
    ```

    The `config.anonymous=<your-consumer-id>` parameter instructs the key-auth plugin on this Service to permit
    anonymous access, and to associate such access with the Consumer `id` we received in the previous step. It is
    required that you provide a valid and pre-existing Consumer `id` in this step - validity of the Consumer `id`
    is not currently checked when configuring anonymous access, and provisioning of a Consumer `id` that doesn't already
    exist will result in an incorrect configuration.

6. ### Check anonymous access

    Confirm that your Service now permits anonymous access by issuing the following request:

    ```bash
    $ curl -i -X GET \
      --url http://localhost:8000/auth-sample
    ```

    This is the same request you made in step #3, however this time the request should succeed, because you
    enabled anonymous access in step #5.

    The response (which is the request as Mockbin received it) should have these elements:

    ```json
    {
      ...
      "headers": {
        ...
        "x-consumer-id": "713c592c-38b8-4f5b-976f-1bd2b8069494",
        "x-consumer-username": "anonymous_users",
        "x-anonymous-consumer": "true",
        ...
      },
      ...
    }
    ```

    It shows the request was successful, but anonymous.

## Multiple Authentication

Kong supports multiple authentication plugins for a given Service, allowing
different clients to utilize different authentication methods to access a given Service or Route.

The behaviour of the auth plugins can be set to do either a logical `AND`, or a logical `OR` when evaluating
multiple authentication credentials. The key to the behaviour is the `config.anonymous` property.

- `config.anonymous` not set <br/>
  If this property is not set (empty) then the auth plugins will always perform authentication and return
  a `40x` response if not validated. This results in a logical `AND` when multiple auth plugins are being
  invoked.
- `config.anonymous` set to a valid consumer id <br/>
  In this case the auth plugin will only perform authentication if it was not already authenticated. When
  authentication fails, it will not return a `40x` response, but set the anonymous consumer as the consumer. This
  results in a logical `OR` + 'anonymous access' when multiple auth plugins are being invoked.

**NOTE 1**: Either all or none of the auth plugins must be configured for anonymous access. The behaviour is
undefined if they are mixed.

**NOTE 2**: When using the `AND` method, the last plugin executed will be the one setting the credentials
passed to the upstream service. With the `OR` method, it will be the first plugin that successfully authenticates
the consumer, or the last plugin that will set its configured anonymous consumer.

**NOTE 3**: When using the OAuth2 plugin in an `AND` fashion, then also the OAuth2 endpoints for requesting
tokens etc. will require authentication by the other configured auth plugins.

<div class="alert alert-warning">
  When multiple authentication plugins are enabled in an <tt>OR</tt> fashion on a given Service, and it is desired that
  anonymous access be forbidden, then the <a href="/plugins/request-termination"><tt>request-termination</tt> plugin</a> should be
  configured on the anonymous consumer. Failure to do so will allow unauthorized requests.
</div>

[plugins]: https://konghq.com/plugins/
[key-auth]: /plugins/key-authentication
