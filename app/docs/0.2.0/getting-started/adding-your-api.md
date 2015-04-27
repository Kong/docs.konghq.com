---
title: Adding your API
---

# Adding your API

<div class="alert alert-warning">
  <strong>Before you start:</strong>
  <ol>
    <li>Make sure you've <a href="/download">installed Kong</a> &mdash; It should only take a minute!</li>
    <li>Make sure you've <a href="/docs/{{page.kong_version}}/getting-started/quickstart">started Kong</a>.</li>
  </ol>
</div>

In this section, you'll be adding your API to the Kong layer. This is the first step to having Kong manage your API. Kong exposes a [RESTful API][API] for managing the details of your Kong instances.

1. ### Add your API using the RESTful API

    Issue the following cURL request to add your first API ([Mockbin][mockbin]) to Kong:

    ```bash
    $ curl -i -X POST \
     --url http://localhost:8001/apis/ \
     --data 'name=mockbin' \
     --data 'target_url=http://mockbin.com/' \
     --data 'public_dns=mockbin.com'
    ```

    **Note:** Kong handles API configuration requests on port `:8001`

2. ### Verify that your API has been added

    You should see a similar response from the initial request:

    ```http
    HTTP/1.1 201 Created
    Date: Wed, 08 Apr 2015 01:26:09 GMT
    Content-Type: application/json
    Transfer-Encoding: chunked
    Connection: keep-alive
    Server: kong/0.1.1beta-2

    {
      "public_dns": "mockbin.com",
      "target_url": "http://mockbin.com/",
      "id": "2eec1cb2-7093-411a-c14e-42e67142d2c4",
      "created_at": 1428456369000,
      "name": "mockbin"
    }
    ```

    Kong is now aware of your API and ready to proxy requests.

3. ### Forward your requests through Kong

    Issue the following cURL request to verify that Kong is properly forwarding requests to your API:

    ```bash
    $ curl -i -X GET \
     --url http://localhost:8000/ \
     --header 'Host: mockbin.com'
    ```

    A successful response means Kong is now forwarding requests to the `target_url` we passed in the first step and giving us the response back. Kong knows to do this through the header defined in the above cURL request:

    <ul>
      <li><strong>Host: &lt;public_dns></strong></li>
    </ul>

    **Note:** Kong handles proxy requests on port `:8000`

<hr>

## Next Steps

Now that you've got your API added to Kong lets learn how to enable plugins.

Go to [Enabling Plugins &rsaquo;][enabling-plugins]

[mockbin]: https://mockbin.com
[CLI]: /docs/{{page.kong_version}}/cli
[API]: /docs/{{page.kong_version}}/api
[install]: /download
[configuration]: /download
[migrations]: /docs/{{page.kong_version}}/migrations
[quickstart]: /docs/{{page.kong_version}}/getting-started/quickstart
[enabling-plugins]: /docs/{{page.kong_version}}/getting-started/enabling-plugins
