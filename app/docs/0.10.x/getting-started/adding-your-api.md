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

In this section, you'll be adding your API to the Kong layer. This is the first step to having Kong manage your API. For purposes of this Getting Started guide, we suggest adding the [Mockbin API][mockbin] to Kong, as Mockbin is helpful for learning how Kong proxies your API requests. 

Kong exposes a [RESTful Admin API][API] on port `:8001` for managing the configuration of your Kong instance or cluster.

1. ### Add your API using the Admin API

    Issue the following cURL request to add your first API ([Mockbin][mockbin]) to Kong:

    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/apis/ \
      --data 'name=mockbin' \
      --data 'upstream_url=http://mockbin.com/' \
      --data 'request_host=mockbin.com'
    ```

2. ### Verify that your API has been added

    You should see a response that is similar to your initial request:

    ```http
    HTTP/1.1 201 Created
    Content-Type: application/json
    Connection: keep-alive

    {
      "request_host": "mockbin.com",
      "upstream_url": "http://mockbin.com/",
      "id": "2eec1cb2-7093-411a-c14e-42e67142d2c4",
      "created_at": 1428456369000,
      "name": "mockbin"
    }
    ```

    Kong is now aware of your API and ready to proxy requests.

3. ### Forward your requests through Kong

    Issue the following cURL request to verify that Kong is properly forwarding requests to your API. Note that [by default][proxy-port] Kong handles proxy requests on port `:8000`:

    ```bash
    $ curl -i -X GET \
      --url http://localhost:8000/ \
      --header 'Host: mockbin.com'
    ```

    A successful response means Kong is now forwarding requests made to `http://localhost:8000/` to the `upstream_url` we configured in step #1, and is forwarding the response back to us. Kong knows to do this through the header defined in the above cURL request:

    <ul>
      <li><strong>Host: &lt;request_host></strong></li>
    </ul>

    <div class="alert alert-warning">
      For security reasons we suggest <a href="/docs/{{page.kong_version}}/getting-started/enabling-plugins">enabling</a> the <a href="/plugins/request-size-limiting/">Request Size Limiting</a> plugin for all APIs you add to Kong to prevent a DOS (Denial of Service) attack. 
    </div>

<hr>

## Next Steps

Now that you've added your API to Kong, let's learn how to enable plugins.

Go to [Enabling Plugins &rsaquo;][enabling-plugins]

[mockbin]: https://mockbin.com
[API]: /docs/{{page.kong_version}}/admin-api
[enabling-plugins]: /docs/{{page.kong_version}}/getting-started/enabling-plugins
[proxy-port]: /docs/{{page.kong_version}}/configuration/#nginx-section

