---
title: How to Customize Gateway Logs
content_type: how-to
---


With regulations for protecting private data like GDPR, you may need to customize what {{site.base_gateway}} is logging. If you use Kong as your API gateway, this can be done in a single location to take effect on all of your services. This guide walks you through one approach to accomplishing this, but there are always different approaches for different needs. 

These changes affect the output of the NGINX access logs. This doesn't have any effect on Kong's logging plugins.

For this example, let’s say you want to remove any instances of an email address from your Kong logs. The email addresses may come through in different ways, for example `/servicename/v2/verify/alice@example.com` or `/v3/verify?alice@example.com`. To keep all of these formats from being added to the logs, you need to use a custom NGINX template.

First, make a copy of {{site.base_gateway}}'s NGINX template. This template can be found in the [Nginx directives reference](/gateway/{{page.release}}/reference/nginx-directives/#custom-nginx-templates-and-embedding-kong-gateway/) or copied from below:

```nginx
# ---------------------
# custom_nginx.template
# ---------------------

worker_processes ${{NGINX_WORKER_PROCESSES}}; # can be set by kong.conf
daemon ${{NGINX_DAEMON}};                     # can be set by kong.conf

pid pids/nginx.pid;                      # this setting is mandatory
error_log logs/error.log ${{LOG_LEVEL}}; # can be set by kong.conf

events {
    use epoll; # custom setting
    multi_accept on;
}

http {
    # include default Kong Nginx config
    include 'nginx-kong.conf';

    # custom server
    server {
        listen 8888;
        server_name custom_server;

        location / {
          ... # etc
        }
    }
}
```

To control what is placed in the logs, you can use the [NGINX map module](https://nginx.org/en/docs/http/ngx_http_map_module.html) in the template. This creates a new variable whose value depends on values of one or more of the source variables specified in the first parameter. The format is:

```nginx

map $parameter_to_look_at $variable_name {
    pattern_to_look_for 0;
    second_pattern_to_look_for 0;

    default 1;
}
```

For this example, map a new variable called `keeplog`, which is dependent on values appearing in the `$request_uri`. Place the map directive at the start of the `http` block, before `include 'nginx-kong.conf';`:

```nginx
map $request_uri $keeplog {
    ~.+\@.+\..+ 0;
    ~/servicename/v2/verify 0;
    ~/v3/verify 0;

    default 1;
}
```

Notice that each of the lines in the example start with a tilde. This is what tells NGINX to use RegEx when evaluating the line. There are three things to look for in this example:
- The first line uses regex to look for any email address in the `x@y.z` format
- The second line looks for any part of the URI that contains `/servicename/v2/verify`
- The third line looks at any part of the URI that contains `/v3/verify`

Because all of these patterns have a value of something other than `0`, if a request has any of those elements, it will not be added to the log.

Now, use the `log_format` module to set the log format for what {{site.base_gateway}} keeps in the logs. 

The contents of the log can be customized for your needs. For the purpose of this example, you can assign the new logs with the name `show_everything` and  simply set everything to the Kong default standards. 
To see the full list of options, refer to the [NGINX core module variables reference](https://nginx.org/en/docs/http/ngx_http_core_module.html#variables).

```nginx
log_format show_everything '$remote_addr - $remote_user [$time_local] '
    '$request_uri $status $body_bytes_sent '
    '"$http_referer" "$http_user_agent"';
```

Now, the custom NGINX template is ready to be used. If you have been following along, your file should look like this:

```nginx
# ---------------------
# custom_nginx.template
# ---------------------

worker_processes ${{NGINX_WORKER_PROCESSES}}; # can be set by kong.conf
daemon ${{NGINX_DAEMON}};                     # can be set by kong.conf

pid pids/nginx.pid;                      # this setting is mandatory
error_log stderr ${{LOG_LEVEL}}; # can be set by kong.conf



events {
    use epoll; # custom setting
    multi_accept on;
}

http {


    map $request_uri $keeplog {
        ~.+\@.+\..+ 0;
        ~/v1/invitation/ 0;
        ~/reset/v1/customer/password/token 0;
        ~/v2/verify 0;

        default 1;
    }
    log_format show_everything '$remote_addr - $remote_user [$time_local] '
        '$request_uri $status $body_bytes_sent '
        '"$http_referer" "$http_user_agent"';

    include 'nginx-kong.conf';
}
```

The last thing you need to do is tell {{site.base_gateway}} to use the newly created log, `show_everything`. To do this, alter the Kong variable `proxy_access_log` by either editing `etc/kong/kong.conf` or using the environmental variable `KONG_PROXY_ACCESS_LOG`. Adjust the default location to the following:

```
proxy_access_log=logs/access.log show_everything if=$keeplog
```

Restart {{site.base_gateway}} to make all the changes take effect. You can use the `kong restart` command.

Now, any request made with an email address in it will no longer be logged. 

You can use this logic to remove anything you want from the logs in a conditional manner.
