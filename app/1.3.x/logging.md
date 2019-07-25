---
title: Logging Reference
toc: false
---

## Removing Certain Elements From Your Kong Logs

With new regulations surrounding protecting private data like GDPR, there is a chance you may need to change your logging habits. If you use Kong as your API Gateway, this can be done in a single location to take effect on all of your APIs. This guide will walk you through one approach to accomplishing this, but there are always different approaches for different needs. Please note, these changes will effect the output of the NGINX access logs. This will not have any effect on Kong's logging plugins.

For this example, let’s say you want to remove any instances of an email address from your kong logs. The emails addresses may come through in different ways, for example something like `/apiname/v2/verify/alice@example.com` or `/v3/verify?alice@example.com`. In order to keep these from being added to the logs, we will need to use a custom NGINX template.

## Log Levels

Log levels are set in [Kong's configuration](/{{page.kong_version}}/configuration/#log_level). Following are the log levels in increasing order of their severity, `debug`, `info`,
`notice`, `warn`, `error` and `crit`.

- *`debug`:* It provides debug information about the plugin's runloop and each individual plugin or other components. Only to be used during debugging since it is too chatty.
- *`info`/`notice`:* Kong does not make a big difference between both these levels. Provides information about normal behavior most of which can be ignored.
- *`warn`:* To log any abnormal behavior that doesn't result in dropped transactions but requires further investigation, `warn` level should be used.
- *`error`:* Used for logging errors that result in a request being dropped (for example getting  an HTTP 500 error). The rate of such logs need to be monitored.
- *`crit`:* This level is used when Kong is working under critical conditions and not working properly thereby affecting several clients. Nginx also provides `alert` and `emerg` levels but currently Kong doesn't make use of these levels making `crit` the highest severity log level.

By default `notice` is the log level that used and also recommended. However if the logs turn out to be too chatty they can be bumped up to a higher level like `warn`.

## Removing Certain Elements From Your Kong Logs

With new regulations surrounding protecting private data like GDPR, there is a chance you may need to change your logging habits. If you use Kong as your API Gateway, this can be done in a single location to take effect on all of your Services. This guide will walk you through one approach to accomplishing this, but there are always different approaches for different needs. Please note, these changes will effect the output of the NGINX access logs. This will not have any effect on Kong's logging plugins.

For this example, let’s say you want to remove any instances of an email address from your kong logs. The emails addresses may come through in different ways, for example something like `/servicename/v2/verify/alice@example.com` or `/v3/verify?alice@example.com`. In order to keep these from being added to the logs, we will need to use a custom NGINX template.

To start using a custom NGINX template, first get a copy of our template. This can be found [https://docs.konghq.com/latest/configuration/#custom-nginx-templates-embedding-kong](https://docs.konghq.com/latest/configuration/#custom-nginx-templates-embedding-kong) or copied from below

```
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

In order to control what is placed in the logs, we will be using the NGINX map module in our template. For more detailed information abut using the map directive, please see [this guide](http://nginx.org/en/docs/http/ngx_http_map_module.html). This will create a new variable whose value depends on values of one or more of the source variables specified in the first parameter. The format is:

```

map $paramater_to_look_at $variable_name {
    pattern_to_look_for 0;
    second_pattern_to_look_for 0;

    default 1;
}
```

For this example, we will be mapping a new variable called `keeplog` which is dependent on certain values appearing in the `$request_uri`. We will be placing our map directive right at the start of the http block, this must be before `include 'nginx-kong.conf';`. So, for our example, we will add something along the lines of:

```
map $request_uri $keeplog {
    ~.+\@.+\..+ 0;
    ~/servicename/v2/verify 0;
    ~/v3/verify 0;

    default 1;
}
```

You’ll probably notice that each of those lines start with a tilde. This is what tells NGINX to use RegEx when evaluating the line. We have three things to look for in this example:
- The first line uses regex to look for any email address in the x@y.z format
- The second line looks for any part of the URI which is /servicename/v2/verify
- The third line looks at any part of the URI which contains /v3/verify

Because all of those have a value of something other than 0, if a request has one of those elements, it will not be added to the log.

Now, we need to set the log format for what we will keep in the logs. We will use the `log_format` module and assign our new logs a name of show_everything. The contents of the log can be customized for you needs, but for this example, I will simply change everything back to the Kong standards. To see the full list of options you can use, please refer to [this guide](https://nginx.org/en/docs/http/ngx_http_core_module.html#variables).

```
log_format show_everything '$remote_addr - $remote_user [$time_local] '
    '$request_uri $status $body_bytes_sent '
    '"$http_referer" "$http_user_agent"';
```

Now, our custom NGINX template is all ready to be used. If you have been following along, your file should now be look like this:

```
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

The last thing we need to do is tell Kong to use the newly created log, `show_everything`. To do this, we will be altering the Kong variable `prpxy_access_log`. Either by opening and editing `etc/kong/kong.conf` or by using an environmental variable `KONG_PROXY_ACCESS_LOG=` you will want to mend the default location to show

```
proxy_access_log=logs/access.log show_everything if=$keeplog
```

The final step in the process to make all the changes take effect is to restart kong. you can use the `kong restart` command to do so.

Now, any requests made with an email address in it will no longer be logged. Of course, we can use this logic to remove anything we want from the logs on a conditional manner.
