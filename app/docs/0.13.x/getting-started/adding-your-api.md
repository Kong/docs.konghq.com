---
title: Adding your API
---

# Adding your API

<div class="alert alert-warning">
  <strong>Before you start:</strong>
  <ol>
    <li>Make sure you've <a href="/install/">installed Kong</a> &mdash; It should only take a minute!</li>
    <li>Make sure you've <a href="/docs/{{page.kong_version}}/getting-started/quickstart">started Kong</a>.</li>
  </ol>
</div>

In this section, you'll be adding your Service to the Kong layer. This is the first
step to having Kong manage your API. For purposes of this Getting Started
guide, we suggest adding the [Mockbin Service][mockbin] to Kong, as Mockbin is
helpful for learning how Kong proxies your API requests.

Kong exposes a [RESTful Admin API][API] on port `:8001` for managing the
configuration of your Kong instance or cluster.

1. ### Add your Service using the Admin API

    Issue the following cURL request to add your first Service ([Mockbin][mockbin])
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

[API]: /docs/{{page.kong_version}}/admin-api
[enabling-plugins]: /docs/{{page.kong_version}}/getting-started/enabling-plugins
[proxy-port]: /docs/{{page.kong_version}}/configuration/#nginx-section
[mockbin]: https://mockbin.com/
