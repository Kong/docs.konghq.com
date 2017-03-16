---
title: Authentication Reference
---

# Authentication Reference

Client access to upstream API services is typically controlled by the application and configuration of 
Kong authentication plugins. Authetication plugins are [documented individually][plugins]. 

## Anonymous Access

Prior to Kong 0.10.x, a given API could be configured to allow **only** authenticated access (by applying an
[auth plugin][plugins]) or **only** anonymous access - it was not possible to have a given API allow some 
users to be authenticated and others to access anonymously.

Kong 0.10.x adds the ability to configure a given API to allow **both** authenticated **and** anonymous access. 
You might use this configuration to grant access to anonymous users with a low rate-limit, and grant access 
to authenticated users with a higher rate limit. 

To configure an API like this, you first apply your selected authentication plugin, then create a new 
consumer to represent annonymous users, then configure your authentication plugin to allow annonymous access. Here is an example, which assumes you have already configured an API named `example-api`:

TODO: Try out the following steps and ensure they function as described

1. ### Configure the key-auth plugin for your API

    Issue the following cURL request on the API named `example-api`:

    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/apis/example-api/plugins/ \
      --data 'name=key-auth'
    ```
    
2. ### Verify that the key-auth plugin is properly configured

    Issue the following cURL request to verify that the [key-auth][key-auth]
    plugin was properly configured on the API:

    ```bash
    $ curl -i -X GET \
      --url http://localhost:8000/ \
      --header 'Host: example.com'
    ```

    Since you did not specify the required `apikey` header or parameter, and you have not yet
    enabled anonymous access, the response should be `403 Forbidden`:

    ```http
    HTTP/1.1 403 Forbidden
    ...

    {
      "message": "Your authentication credentials are invalid"
    }
    ```

3. ### Create an anonymous consumer

    Every request proxied by Kong must be associated with a consumer. You'll now create a consumer 
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
    
    Be sure to note the `id` - you'll need it in the next step.
    
4. ### Enable anonymous access

    You'll now configure the key-auth plugin to permit anonymous access by issuing the following request:

    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/apis/example-api/plugins/key-auth \
      --data "config.anonymous=bbdf1c48-19dc-4ab7-cae0-ff4f59d87dc9"
    ```
    
    The `config.anonymous=<consumer uuid>` parameter instructs the auth-key plugin on this API to permit 
    anonymous access, and to associate such access with the consumer id we received in the previous step. It is
    required that you provide a valid and pre-existing consumer id in this step - validity of the consumer id
    is not currently checked when configuring anonymous access, and provision of a consumer id that doesn't already
    exist will result in a incorrect configuration.
    
    TODO: Insert example response

5. ### Check anonymous access

    Confirm that your API now permits anonymous access by issuing the following request:

    ```bash
    $ curl -i -X GET \
      --url http://localhost:8000/ \
      --header 'Host: example.com'
    ```

    This is the same request you made in step #1, however this time the request should succeed, because you 
    enabled anonymous access in step #4. 
    
    TODO: Insert example response
    

## Multiple Authentication

Prior to Kong 0.10.x, only one authentication plugin could be configured for a given API. Kong 0.10.x 
introduces the ability to apply multiple authentication plugins for a given API, allowing 
different clients to utilize different authentication methods to access a given API endpoint.

Multiple authentication methods are evaluated in a logical OR fashion - requests that fail to satisfy any 
of the configured authentication methods on a given API are proxied upstream with the `X-Anonymous-Consumer` 
header set to `true`. It is currently not possible to have **both** multiple authentication enabled
**and** block anonymous requests - this will be changed in a future release of Kong.

<div class="alert alert-warning">
  Currently, when multiple authentication plugins are enabled on a given API, and it is desired that 
  anonymous access be forbidden, the upstream service MUST be configured to reject requests in 
  which the `X-Anonymous-Consumer` header is set to `true`. Failure to do so will allow unauthorized 
  requests to satisfied. 
</div>

TODO: Insert example of configuring and using multiple authentication



[plugins]: https://getkong.org/plugins/
[key-auth]: /plugins/key-authentication
