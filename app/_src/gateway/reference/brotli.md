---
title: Brotli compression
content-type: reference
---

{{site.base_gateway}} supports the [`ngx_brotli`](https://github.com/google/ngx_brotli) module through its [Nginx directives injection mechanism](/gateway/{{page.release}}/reference/nginx-directives/).
[Brotli](https://github.com/google/brotli) is a compression algorithm for high-performance websites. 
It's designed to be better at compression than other commonly used algorithms such as gzip and deflate.
You can use it to speed up your applications, improve page speed, reduce data transmitted, and improve the overall performance of {{site.base_gateway}}.

## Enable Brotli compression

Set the following parameters in `kong.conf` to enable Brotli compression:

```
nginx_proxy_brotli = "on"
nginx_proxy_brotli_comp_level = 5
nginx_proxy_brotli_types = "text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript application/javascript text/x-js"
```

We recommend setting a compression level (`nginx_proxy_brotli_comp_level`) of 4 or 5 as a balanced option, as it still provides a smaller payload than the highest gzip 
compression level without compromising processing time [[1]](#more-information). 

## More information
* [Injecting Nginx directives in {{site.base_gateway}}](/gateway/{{page.release}}/reference/nginx-directives/)
* [Brotli](https://github.com/google/brotli)
* [`ngx_brotli` module](https://github.com/google/ngx_brotli)
* [1] [Brotli Compression: How Much Will It Reduce Your Content?](https://paulcalvano.com/2018-07-25-brotli-compression-how-much-will-it-reduce-your-content/)

