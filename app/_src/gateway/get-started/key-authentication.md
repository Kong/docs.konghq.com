---
title: Key Authentication
content-type: tutorial
book: get-started
chapter: 5
---

Authentication is the process of verifying that a requester has permissions to access a resource. 
As its name implies, API gateway authentication authenticates the flow of data to and from your upstream services. 

{{site.base_gateway}} has a library of plugins that support 
the most widely used [methods of API gateway authentication](/hub/#authentication). 

Common authentication methods include:
* Key Authentication
* Basic Authentication
* OAuth 2.0 Authentication
* LDAP Authentication Advanced
* OpenID Connect

## Authentication benefits

With {{site.base_gateway}} controlling authentication, requests won't reach upstream services unless the client has successfully
authenticated. This means upstream services process pre-authorized requests, freeing them from the 
cost of authentication, which is a savings in compute time *and* development effort.

{{site.base_gateway}} has visibility into all authentication attempts, which provides the ability to build 
monitoring and alerting capabilities supporting service availability and compliance. 

For more information, see [What is API Gateway Authentication?](https://konghq.com/learning-center/api-gateway/api-gateway-authentication).

## Enable authentication

The following tutorial walks through how to enable the [Key Authentication plugin](/hub/kong-inc/key-auth/) across
various aspects in {{site.base_gateway}}.

API key authentication is a popular method for enforcing API authentication. In key authentication, 
{{site.base_gateway}} is used to generate and associate an API key with a [consumer](/gateway/latest/admin-api/#consumer-object). 
That key is the authentication secret presented by the client when making subsequent requests. {{site.base_gateway}} approves or 
denies requests based on the validity of the presented key. This process can be applied globally or to individual 
[services](/gateway/latest/key-concepts/services/) and [routes](/gateway/latest/key-concepts/routes/).

### Prerequisites

This chapter is part of the *Get Started with Kong* series. For the best experience, it is recommended that you follow the
series from the beginning. 

Start with the introduction, [Get Kong](/gateway/latest/get-started/), which includes
tool prerequisites and instructions for running a local {{site.base_gateway}}.

Step two of the guide, [Services and Routes](/gateway/latest/get-started/services-and-routes/),
includes instructions for installing a mock service used throughout this series. 

If you haven't completed these steps already, complete them before proceeding.

### Set up consumers and keys 

Key authentication in {{site.base_gateway}} works by using the consumer object. Keys are assigned to 
consumers, and client applications present the key within the requests they make.

1. **Create a new consumer**

   For the purposes of this tutorial, create a new consumer with a username `luka`:

   ```sh
   curl -i -X POST http://localhost:8001/consumers/ \
     --data username=luka
   ```

   You will receive a `201` response indicating the consumer was created.

1. **Assign the consumer a key**

   Once provisioned, call the Admin API to assign a key for the new consumer.
   For this tutorial, set the key value to `top-secret-key`:

   ```sh
   curl -i -X POST http://localhost:8001/consumers/luka/key-auth \
     --data key=top-secret-key
   ```

   You will receive a `201` response indicating the key was created.

   In this example, you have explicitly set the key contents to `top-secret-key`.
   If you do not provide the `key` field, {{site.base_gateway}} will generate the key value for you.

   {:.important}
   > **Warning**: For the purposes of this tutorial, we have assigned an example key value. It is recommended that you let the 
   API gateway autogenerate a complex key for you. Only specify a key for testing or when migrating existing systems.
   

### Global key authentication 

Installing the plugin globally means *every* proxy request to {{site.base_gateway}} is protected by key authentication.

1. **Enable key authentication**

   The Key Authentication plugin is installed by default on {{site.base_gateway}} and can be enabled
   by sending a `POST` request to the plugins object on the Admin API:

   ```sh
   curl -X POST http://localhost:8001/plugins/ \
       --data "name=key-auth"  \
       --data "config.key_names=apikey"
   ```

   You will receive a `201` response indicating the plugin was installed.

   The `key_names` configuration field in the above request defines the name of the field that the
   plugin looks for to read the key when authenticating requests. The plugin looks for the field in headers,
   query string parameters, and the request body.
  
1. **Send an unauthenticated request** 

   Try to access the service without providing the key:
   
   ```sh
   curl -i http://localhost:8000/mock/anything
   ```
   
   Since you enabled key authentication globally, you will receive an unauthorized response:
   
   ```text
   HTTP/1.1 401 Unauthorized
   ...
   {
       "message": "No API key found in request"
   }
   ```

1. **Send the wrong key**

   Try to access the service with the wrong key:
   
   ```sh
   curl -i http://localhost:8000/mock/anything \
     -H 'apikey:bad-key'
   ```
  
   You will receive an unauthorized response:
 
   ```text
   HTTP/1.1 401 Unauthorized
   ...
   {
     "message":"Invalid authentication credentials"
   }
   ```

1. **Send a valid request**

   Send a request with the valid key in the `apikey` header:

   ```sh
   curl -i http://localhost:8000/mock/anything \
     -H 'apikey:top-secret-key'
   ```

   You will receive a `200 OK` response.
   
### Service based key authentication

The Key Authentication plugin can be enabled for specific services. The request is the same as above, but the `POST` request is sent 
to the service URL:

   ```sh
   curl -X POST http://localhost:8001/services/example_service/plugins \
     --data name=key-auth
   ```
### Route based key authentication

The Key Authentication plugin can be enabled for specific routes. The request is the same as above, but the `POST` request is sent to the route URL:

   ```sh
   curl -X POST http://localhost:8001/routes/example_route/plugins \
     --data name=key-auth
   ```

## (Optional) Disable the plugin

If you are following this getting started guide section by section, you will need to use this API key 
in any requests going forward. If you don’t want to keep specifying the key, disable the plugin before moving on.


1. **Find the Key Authentication plugin ID**

   ```sh
   curl -X GET http://localhost:8001/plugins/
   ```
   
   You will receive a JSON response that contains the `id` field, similar to the following snippet:
   
   ```text
   ...
   "id": "2512e48d9-7by0-674c-84b7-00606792f96b"
   ...
   ```

1. **Disable the plugin**

   Use the plugin ID obtained above to `PATCH` the `enabled` field on the 
   installed Key Authentication plugin. Your request will look similar to this, 
   substituting the proper plugin ID:

   ```sh
   curl -X PATCH http://localhost:8001/plugins/2512e48d9-7by0-674c-84b7-00606792f96b \
     --data enabled=false
   ```

1. **Test disabled authentication**

   Now you can make a request without providing an API key:

   ```sh
   curl -i http://localhost:8000/mock/anything
   ```

   You should receive:

   ```text
   HTTP/1.1 200 OK
   ```

