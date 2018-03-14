---
title: Forward Proxy
---
# Forward Proxy Plugin

## Synopsis
This plugins allows Kong to connect through an intermediary HTTP proxy instead of directly to the upstream server.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an existing API by executing the following request on your Kong server:

```
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=forward-proxy" \
    --data "config.proxy_host=<proxy_host>"
    --data "config.proxy_port=<proxy_port>"
```

`api`: The `id` or `name` of the API that this plugin configuration will target.

You can also apply it for every API using the `http://kong:8001/plugins/` endpoint.

| Form Parameter | Default | Description
| -------------- | ------- | -----------
|`name` | | The name of the plugin to use, in this case: `forward-proxy`
| `config.proxy_host` | | The hostname or IP address of the forward proxy to which to connect
| `config.proxy_port` | | The TCP port of the forward proxy to which to connect
| `config.proxy_scheme` | `http`|	The proxy scheme to use when connecting. Currently only http is supported

## Notes

he plugin attempts to transparently replace upstream connections made by Kong core, sending the request instead to an intermediary forward proxy. Currently only transparent HTTP proxies are supported; TLS connections (via `CONNECT`) are not yet supported.
