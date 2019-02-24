---
title: Adding your API
---

## Introduction

<div class="alert alert-warning">
  <strong>Before you start:</strong>
  <ol>
    <li>Make sure you've <a href="https://konghq.com/install/">installed Kong</a> &mdash; It should only take a minute!</li>
    <li>Make sure you've <a href="/{{page.kong_version}}/getting-started/quickstart">started Kong</a>.</li>
  </ol>
</div>

In this section, you'll be adding your API to the Kong layer. This is the first
step to having Kong manage your API. For purposes of this Getting Started
guide, we suggest adding the [Mockbin API][mockbin] to Kong, as Mockbin is
helpful for learning how Kong proxies your API requests.

Kong exposes a [RESTful Admin API][API] on port `:8001` for managing the
configuration of your Kong instance or cluster.

### 1. Add your API using the Admin API

    Issue the following cURL request to add your first API ([Mockbin][mockbin])
    to Kong:

    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/apis/ \
      --data 'name=example-api' \
      --data 'hosts=example.com' \
      --data 'upstream_url=http://mockbin.org'
    ```

### 2. Verify that your API has been added

    You should see a similar response from that request:

    ```http
    HTTP/1.1 201 Created
    Content-Type: application/json
    Connection: keep-alive

    {
      "created_at": 1488830759000,
      "hosts": [
          "example.com"
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
      "upstream_url": "http://mockbin.org"
    }
    ```

    Kong is now aware of your API and ready to proxy requests.

### 3. Forward your requests through Kong

    Issue the following cURL request to verify that Kong is properly forwarding
    requests to your API. Note that [by default][proxy-port] Kong handles proxy
    requests on port `:8000`:

    ```bash
    $ curl -i -X GET \
      --url http://localhost:8000/ \
      --header 'Host: example.com'
    ```

    A successful response means Kong is now forwarding requests made to
    `http://localhost:8000` to the `upstream_url` we configured in step #1,
    and is forwarding the response back to us. Kong knows to do this through
    the header defined in the above cURL request:

    <ul>
      <li><strong>Host: &lt;given host></strong></li>
    </ul>

<hr>

## Next Steps

Now that you've added your API to Kong, let's learn how to enable plugins.

Go to [Enabling Plugins &rsaquo;][enabling-plugins]

[API]: /{{page.kong_version}}/admin-api
[enabling-plugins]: /{{page.kong_version}}/getting-started/enabling-plugins
[proxy-port]: /{{page.kong_version}}/configuration/#nginx-section
[mockbin]: https://mockbin.com/
