---
title: Embed Kong in OpenResty
content-type: how-to
---

## Embed Kong in OpenResty

If you are running your own OpenResty servers, you can embed {{site.base_gateway}}
by including the {{site.base_gateway}} Nginx sub-configuration using the `include` directive.
If you have an existing Nginx configuration, you can include the
{{site.base_gateway}}-specific portion of the configuration which is output by {{site.base_gateway}} in a separate
`nginx-kong.conf` file:

```
# my_nginx.conf

# ...your nginx settings...

http {
    include 'nginx-kong.conf';

    # ...your nginx settings...
}
```

Then start your Nginx instance:

```bash
nginx -p /usr/local/openresty -c my_nginx.conf
```

Kong will be running in that instance as configured in `nginx-kong.conf`.


## More Information

* [Setting environment variables](/gateway/latest/kong-production/environment-variables)
* [How to use `kong.conf`](/gateway/latest/kong-production/kong-conf)
* [How to serve an API and a website with Kong](/gateway/latest/kong-production/website-api-serving)