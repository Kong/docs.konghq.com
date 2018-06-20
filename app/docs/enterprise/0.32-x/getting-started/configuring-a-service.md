---
title: Configuring a Service
redirect_from: "/docs/enterprise/0.32-x/getting-started/adding-your-api/"
---

# Configuring a Service

In this section, you'll be adding an API to Kong Enterprise Edition (EE). In order to do this, you'll
first need to add a _Service_: this is the name Kong uses to refer to the upstream APIs and microservices
it manages.

For the purpose of this guide, we'll create a Service pointing to the [Mockbin API][mockbin]. Mockbin is
an "echo" type public website which returns the requests it gets back to the requester as reponses. This
makes it helpful for learning how Kong proxies your API requests.

Before you can start making requests against the Service, you will need to add a _Route_ to it.
Routes specify how (and _if_) requests are sent to their Services after they reach Kong. A single
Service can have many Routes.

After configuring the Service and the Route, you'll be able to make requests through Kong using them.

Kong exposes a [RESTful Admin API][API] on port `8001`. Kong's configuration, including adding Services and
Routes, is made via requests on that API.

1. ### Add your Service using the Admin API

    Issue the following cURL request to add your first Service (pointing to the [Mockbin API][mockbin])
    to Kong:

    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/services/ \
      --data 'name=example-service' \
      --data 'url=http://mockbin.org'
    ```

    You should receive a response similar to:

    ```http
    HTTP/1.1 201 Created
    Content-Type: application/json
    Connection: keep-alive

    {
       "host":"mockbin.org",
       "created_at":1519130509,
       "connect_timeout":60000,
       "id":"92956672-f5ea-4e9a-b096-667bf55bc40c",
       "protocol":"http",
       "name":"example-service",
       "read_timeout":60000,
       "port":80,
       "path":null,
       "updated_at":1519130509,
       "retries":5,
       "write_timeout":60000
    }
    ```

    Alternately, add your first Service via the Admin GUI:
    
    <video width="100%" autoplay loop controls>
      <source src="https://konghq.com/wp-content/uploads/2018/06/0_32_create_service.mp4" type="video/mp4">
      Your browser does not support the video tag.
    </video>


2. ### Add a Route for the Service

    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/services/example-service/routes \
      --data 'hosts[]=example.com'
    ```

    The answer should be similar to:

    ```http
    HTTP/1.1 201 Created
    Content-Type: application/json
    Connection: keep-alive

    {
       "created_at":1519131139,
       "strip_path":true,
       "hosts":[
          "example.com"
       ],
       "preserve_host":false,
       "regex_priority":0,
       "updated_at":1519131139,
       "paths":null,
       "service":{
          "id":"79d7ee6e-9fc7-4b95-aa3b-61d2e17e7516"
       },
       "methods":null,
       "protocols":[
          "http",
          "https"
       ],
       "id":"f9ce2ed7-c06e-4e16-bd5d-3a82daef3f9d"
    }
    ```

    Alternately, add your Route via the Admin GUI:
    
    <video width="100%" autoplay loop controls>
      <source src="https://konghq.com/wp-content/uploads/2018/06/0_32_create_route.mp4" type="video/mp4">
      Your browser does not support the video tag.
    </video>

    Kong is now aware of your Service and ready to proxy requests.

3. ### Forward your requests through Kong

    Issue the following cURL request to verify that Kong is properly forwarding
    requests to your Service. Note that [by default][proxy-port] Kong handles proxy
    requests on port `:8000`:

    ```bash
    $ curl -i -X GET \
      --url http://localhost:8000/ \
      --header 'Host: example.com'
    ```

    A successful response means Kong is now forwarding requests made to
    `http://localhost:8000` to the `url` we configured in step #1,
    and is forwarding the response back to us. Kong knows to do this through
    the header defined in the above cURL request:

    <ul>
      <li><strong>Host: &lt;given host></strong></li>
    </ul>

<hr>

## Next Steps

Now that you've added your Service to Kong, let's learn how to enable plugins.

Go to [Enabling Plugins &rsaquo;][enabling-plugins]

[API]: /docs/latest/admin-api
[enabling-plugins]: /docs/enterprise/{{page.kong_version}}/getting-started/enabling-plugins
[proxy-port]: /docs/latest/configuration/#nginx-section
[mockbin]: https://mockbin.com/
