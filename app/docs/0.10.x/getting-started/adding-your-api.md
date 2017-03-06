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

In this section, you'll be adding your API to the Kong layer. This is the first
step to having Kong manage your API. Kong exposes a [RESTful Admin API][API]
for managing the details of your Kong instances.

1. ### Add your API using the RESTful API

    Issue the following cURL request to add your first API ([Mockbin][mockbin])
    to Kong:

    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/apis/ \
      --data 'name=example-api' \
      --data 'hosts=example.com' \
      --data 'upstream_url=http://httpbin.org'
    ```

    **Note:** Kong handles API configuration requests on port `:8001`

2. ### Verify that your API has been added

    You should see a similar response from the initial request:

    ```http
    HTTP/1.1 201 Created
    Content-Type: application/json
    Connection: keep-alive

    {
      "created_at": 1488830759000,
      "hosts": [
          "example.org"
      ],
      "http_if_terminated": true,
      "https_only": false,
      "id": "6378122c-a0a1-438d-a5c6-efabae9fb969",
      "name": "example-api",
      "preserve_host": false,
      "retries": 5,
      "strip_uri": true,
      "upstream_connect_timeout": 60000,
      "upstream_read_timeout": 60000,
      "upstream_send_timeout": 60000,
      "upstream_url": "http://httpbin.org"
    }
    ```

    Kong is now aware of your API and ready to proxy requests.

3. ### Forward your requests through Kong

    Issue the following cURL request to verify that Kong is properly forwarding
    requests to your API:

    ```bash
    $ curl -i -X GET \
      --url http://localhost:8000/ \
      --header 'Host: example.com'
    ```

    A successful response means Kong is now forwarding requests to the
    `upstream_url` we passed in the first step and giving us the response back.
    Kong knows to do this through the header defined in the above cURL request:

    <ul>
      <li><strong>Host: &lt;given host></strong></li>
    </ul>

    **Note:** Kong handles proxy requests on port `:8000`. To better understand
    the routing capabilities of Kong, consult the [Proxy Reference][proxy].

<hr>

## Next Steps

Now that you've got your API added to Kong lets learn how to enable plugins.

Go to [Enabling Plugins &rsaquo;][enabling-plugins]

[API]: /docs/{{page.kong_version}}/admin-api
[proxy]: /docs/{{page.kong_version}}/proxy
[enabling-plugins]: /docs/{{page.kong_version}}/getting-started/enabling-plugins
