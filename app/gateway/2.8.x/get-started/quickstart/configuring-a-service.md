---
title: Configuring a Service
---

In this section, you'll be adding an API to Kong. In order to do this, you'll
first need to add a [Service](/gateway/{{page.kong_version}}/admin-api/#service-object); that is the name Kong uses to refer to the upstream APIs and microservices
it manages.

For the purpose of this guide, we'll create a Service pointing to the [httpbin API][httpbin]. Httpbin is
an "echo" type public website which returns the requests it gets back to the requester, as responses. This
makes it helpful for learning how Kong proxies your API requests.

Before you can start making requests against the Service, you will need to add a [Route](/gateway/{{page.kong_version}}/admin-api/#route-object) to it.
Routes specify how (and if) requests are sent to their Services after they reach Kong. There can be multiple Routes to a Service.

After configuring the Service and a Route, you'll be able to proxy a request through Kong to httpbin.

By default, Kong exposes a [RESTful Admin API][API] on port `8001`. 
You can use the Admin API to modify Kong's configuration, including adding 
Services and Routes.

## Before you start
You have installed and started {{site.base_gateway}}, either through the [Docker quickstart](/gateway/{{page.kong_version}}/get-started/quickstart/) or a more [comprehensive installation](/gateway/{{page.kong_version}}/install-and-run/). 

## 1. Add a Service using the Admin API

Issue the following `POST` request to add your first Service to Kong.
This instructs Kong to create a new Service named `example-service` which will accept traffic at `http://httpbin.org`.

```bash
curl -i -X POST \
  --url http://localhost:8001/services/ \
  --data 'name=example-service' \
  --data 'url=http://httpbin.org'
```

You should receive a response similar to:

```http
HTTP/1.1 201 Created
Content-Type: application/json
Connection: keep-alive

{
   "host":"httpbin.org",
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


## 2. Add a Route for the Service

Issue the following `POST` request to add a Route to the `example-service`.
Here, we are instructing Kong to proxy requests with a `Host` header that contains
`example.com` to the `example-service`.

```bash
curl -i -X POST \
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

## 3. Forward your requests through Kong

Issue the following request to verify that Kong is properly forwarding
requests with the `Host` header to the `example-service`. Take note that proxy requests are handled on port `8000` [by default][proxy-port].

```bash
curl -i -X GET \
  --url http://localhost:8000/ \
  --header 'Host: example.com'
```

A successful response means Kong is now forwarding requests with a `Host: example.com` header to the httpbin Service we configured in step #1.

<hr>

## Next Steps

Now that you've added your Service to Kong, let's learn how to enable plugins.

Go to [Enabling Plugins &rsaquo;][enabling-plugins]

[API]: /gateway/{{page.kong_version}}/admin-api
[enabling-plugins]: /gateway/{{page.kong_version}}/get-started/quickstart/enabling-plugins
[proxy-port]: /gateway/{{page.kong_version}}/reference/configuration/#nginx-section
[httpbin]: https://httpbin.org/
