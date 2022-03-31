---
title: Proxy Traffic
no_version: true
---

Use the proxy URL to access a Service. By default, the URL takes the
format `http://<DNSorIP>:8000`.

## Kong Gateway runtimes

If you configure a {{site.base_gateway}} runtime using the
[Docker quick setup](/konnect/legacy/getting-started/configure-runtime) option,
the default proxy URL is `http://localhost:8000`.

<!-- To change the default URL, see [link TBA].-->

## Using the proxy URL

Paste the URL into a browser and append it with a Route path.

For example, if you have:
* A runtime running on `localhost`
* A Service that accesses `http://mockbin.org` using the path `/mock`

Add `/mock` to the end of the proxy URL:

```
http://localhost:8000/mock
```

The URL opens the page associated with the Service, in this case,
`http://mockbin.org`.
