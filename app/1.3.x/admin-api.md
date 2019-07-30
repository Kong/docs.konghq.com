---
title: Admin API

service_body: |
    Attributes | Description
    ---:| ---
    `name`<br>*optional* | The Service name.
    `retries`<br>*optional* | The number of retries to execute upon failure to proxy. Defaults to `5`.
    `protocol` |  The protocol used to communicate with the upstream. It can be one of `http` or `https`.  Defaults to `"http"`.
    `host` | The host of the upstream server.
    `port` | The upstream server port. Defaults to `80`.
    `path`<br>*optional* | The path to be used in requests to the upstream server.
    `connect_timeout`<br>*optional* |  The timeout in milliseconds for establishing a connection to the upstream server.  Defaults to `60000`.
    `write_timeout`<br>*optional* |  The timeout in milliseconds between two successive write operations for transmitting a request to the upstream server.  Defaults to `60000`.
    `read_timeout`<br>*optional* |  The timeout in milliseconds between two successive read operations for transmitting a request to the upstream server.  Defaults to `60000`.
    `tags`<br>*optional* |  An optional set of strings associated with the Service, for grouping and filtering. 
