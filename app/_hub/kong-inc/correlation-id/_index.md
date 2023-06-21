## How it works

When you enable this plugin, it adds a new header to all of the requests processed by Kong. This header bears the name configured in `config.header_name`, and a unique value is generated according to `config.generator`.

This header is always added in calls to your upstream services, and optionally echoed back to your clients according to the `config.echo_downstream` setting.

If a header with the same name is already present in the client request, the plugin honors it and does **not** tamper with it.

## Generators

### uuid

Format:
```
xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

This format generates a heaxadecimal UUID for each request.
### uuid#counter

Format:
```
xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx#counter
```

This format generates a single UUID on a per-worker basis, and further the requests simply append a counter to the UUID after a `#` character. The `counter` value starts at `0` for each worker, and gets incremented independently of the others.

This format provides better performance, but might be harder to store or process for analyzing (due to its format and low cardinality).

### tracker

Format:
```
ip-port-pid-connection-connection_requests-timestamp
```

This correlation id contains more practical implications for each request.

The following is a detailed description of the field

form parameter      | description
---                 | ---
`ip` | an address of the server that accepts a request
`port` | port of the server that accepts a request
`pid` | pid of the nginx worker process
`connection` | connection serial number
`connection_requests` | current number of requests made through a connection
`timestamp` | a floating-point number for the elapsed time in seconds (including milliseconds as the decimal part) from the epoch for the current timestamp from the nginx cached time

## FAQ

### Can I see my correlation IDs in my Kong logs?

You can see your correlation ID in the Nginx access log if you edit your Nginx logging parameters.

To edit your Nginx parameters, do the following:

1. Locate [{{site.base_gateway}}'s template files](/gateway/latest/reference/configuration/#custom-nginx-templates) and make a copy of `nginx_kong.lua`.
1. Add a `log_format` section on the root level of the config file which includes the
  `$http_Kong_Request_ID` variable.

   In the following example, we create a new log format named `customformat`.
   It's a copy of the default `combined` log format, but the last line adds
   `$http_Kong_Request_ID`, preceded by the string `Kong-Request-ID=`.
   Marking the variable this way is optional, and will make testing the feature easier.
   Further customize the `log_format` by adding or removing
   [variables](http://nginx.org/en/docs/http/ngx_http_log_module.html):

   ```
   log_format customformat '$remote_addr - $remote_user [$time_local] '
                 '"$request" $status $body_bytes_sent  '
                 '"$http_referer" "$http_user_agent" '
                 'Kong-Request-ID="$http_Kong_Request_ID"';
   ```

1. Use your custom log format for the proxy access log phase. Locate the following line:

   ```
   access_log ${PROXY_ACCESS_LOG};
   ```

     Modify it by adding the `customformat` format that we just created:

   ```
   access_log ${% raw %}{{PROXY_ACCESS_LOG}}{% endraw %} customformat;
   ```

     Note that the file contains several `access_log` entries. Only modify the line
     that uses `${PROXY_ACCESS_LOG}`.

2. Reload Kong:

   ```
   kong reload
   ```

3. Tail the access log:

   ```
   tail /usr/local/kong/logs/access.log
   ```

   You should now see Correlation ID entries in the access log.

Learn more in [Custom Nginx templates & embedding Kong](/gateway/latest/reference/configuration/#custom-nginx-templates--embedding-kong).

You can also use this plugin along with one of the [logging plugins](/hub/#logging), or store the ID on your backend.
