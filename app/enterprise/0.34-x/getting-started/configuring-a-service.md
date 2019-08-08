---
title: Configuring a Service
redirect_from: "/enterprise/0.34-x/getting-started/adding-your-api/"
---

## Introduction

<div class="alert alert-warning">
  <strong>Before you start:</strong>
  <ol>
    <li>Make sure you've <a href="https://konghq.com/install/">installed Kong</a> &mdash; It should only take a minute!</li>
    <li>Make sure you've <a href="/enterprise/{{page.kong_version}}/getting-started/quickstart">started Kong</a>.</li>
  </ol>
</div>

In this section, you'll be adding an API to Kong. In order to do this, you'll
first need to add a _Service_; that is the name Kong uses to refer to the upstream APIs and microservices
it manages.

For the purpose of this guide, we'll create a Service pointing to the [Mockbin API][mockbin]. Mockbin is
an "echo" type public website which returns the requests it gets back to the requester, as responses. This
makes it helpful for learning how Kong proxies your API requests.

Before you can start making requests against the Service, you will need to add a _Route_ to it.
Routes specify how (and _if_) requests are sent to their Services after they reach Kong. A single
Service can have many Routes.

After configuring the Service and the Route, you'll be able to make requests through Kong using them.

Kong exposes a [RESTful Admin API][API] on port `:8001`. Kong's configuration, including adding Services and
Routes, is made via requests on that API.

## 1. Add Your Service Using the Admin API or Kong Manager

If you'd like to use the Admin API, issue the following cURL request to add
your first API ([Mockbin][mockbin]) to Kong Enterprise:

```bash
$ curl -i -X POST \
  --url http://localhost:8001/services/ \
  --data 'name=example-service' \
  --data 'url=http://mockbin.org'
```

After adding your Service, add a Route linked to it:

```bash
$ curl -i -X POST \
  --url http://localhost:8001/services/example-service/routes \
  --data 'hosts[]=example.com'
```

Alternatively, add your first API in Kong Manager via Services & Routes:

<video width="100%" autoplay loop controls>
  <source src="https://konghq.com/wp-content/uploads/2018/07/first-api-ee-0.33.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

Kong is now aware of your Service and ready to proxy requests.

## 2. Verify Your API Has Been Added

You'll get a confirmation message in Kong Manager, or if you used cURL
you should see responses similar to the following:

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

[API]: /0.13.x/admin-api
[enabling-plugins]: /enterprise/{{page.kong_version}}/getting-started/enabling-plugins
[proxy-port]: /0.13.x/configuration/#nginx-section
[mockbin]: https://mockbin.com/
