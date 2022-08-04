---
title: Embedding Kong in OpenResty
content-type: how-to
---

## Embedding Kong in OpenResty

If you are running your own OpenResty servers, you can embed Kong
by including the Kong Nginx sub-configuration using the `include` directive.
If you have an existing Nginx configuration, you can include the
Kong-specific portion of the configuration which is output by Kong in a separate
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
