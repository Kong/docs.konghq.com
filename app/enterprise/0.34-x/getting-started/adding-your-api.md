---
title: Adding your API
---

## Introduction

In this section, you'll be adding your API to Kong Enterprise. This is the first
step to having Kong Enterprise manage your API. For purposes of this Getting 
Started guide, we suggest adding the [Mockbin API][mockbin] to Kong, as Mockbin 
is helpful for learning how Kong Enterprise proxies your API requests.

Kong exposes a [RESTful Admin API][API] on ports `:8001` and `:8444` and 
Kong Manager on ports `:8002` and `:8445` for managing the configuration of 
your Kong instance or cluster. Kong Manager makes requests to the Admin API, 
and you can use either interface for configuring and managing Kong Enterprise.

## 1. Add Your API Using the Admin API or Kong Manager

If you'd like to use the Admin API, issue the following cURL request to add
your first API ([Mockbin][mockbin]) to Kong Enterprise:

```bash
$ curl -i -X POST \
  --url http://localhost:8001/apis/ \
  --data 'name=example-api' \
  --data 'hosts=example.com' \
  --data 'upstream_url=http://mockbin.org'
```

Alternatively, add your first API in Kong Manager via Services & Routes:

<video width="100%" autoplay loop controls>
  <source src="https://konghq.com/wp-content/uploads/2019/02/first-service-enterprise-34.mov" type="video/mp4">
  Your browser does not support the video tag.
</video>


## 2. Verify Your API Has Been Added

You'll get a confirmation message in Kong Manager, or if you used cURL
you should see a response similar to the following:

```http
HTTP/1.1 201 Created
Content-Type: application/json
Connection: keep-alive

{
  "created_at": 1488830759000,
  "hosts": [
      "example.com"
  ],
  "http_if_terminated": false,
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

## 3. Forward Requests through Kong Enterprise

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
the header defined in the above cURL request `Host: example.com`

---

## Next Steps

Now that you've added your API to Kong Enterprise, let's learn how to enable plugins.

Go to [Enabling Plugins &rsaquo;][enabling-plugins]

[API]: /enterprise/{{page.kong_version}}/admin-api
[enabling-plugins]: /enterprise/{{page.kong_version}}/getting-started/enabling-plugins
[proxy-port]: /enterprise/{{page.kong_version}}/property-reference/#nginx-section
[mockbin]: https://mockbin.com/
