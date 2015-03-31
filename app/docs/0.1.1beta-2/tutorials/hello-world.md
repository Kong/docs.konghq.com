---
layout: docs
title: Tutorials - Hello World
version: 0.1.1beta-2
permalink: /docs/0.1.1beta-2/tutorials/hello-world/
---

# Hello World: Proxying your first API

Kong sits in front of any configured API, and it's the main entrypoint of any HTTP request. For example, let's configure Kong to support [mockbin](http://mockbin.com/) as an API:

```
$ curl -i -X POST \
  --url http://127.0.0.1:8001/apis/ \
  --data 'name=mockbin&target_url=http://mockbin.com&public_dns=api.mockbin.com'
HTTP/1.1 201 Created
```

We used the `8001` port, the administration API of Kong.

We can now make our first HTTP requests through Kong by using the `8000` port, which is the port that API consumers will use to consume any API behind Kong:

```
$ curl -i -X GET \
  --url http://127.0.0.1:8000/ \
  --header 'Host: api.mockbin.com'
HTTP/1.1 200 OK
```

Kong accepted the request and proxied it to the `target_url` property we configured when adding the API, `http://mockbin.com`, and sent us the response.

On a side note you will notice a little trick: we are requesting the API on `127.0.0.1` by manually setting the `Host` header to match the `public_dns` of the API. This will fool the system by making it believe the request has been made to `api.mockbin.com`. In production you want to setup a DNS record that will reference the domain name to your Kong servers through a CNAME or A record, thus avoiding doing this trick. If Kong is sitting behind a load balancer, then the domain should target the load balancer.

Congratulations! The API has been successfully added to Kong and now we can start adding functionalities on top of it.