---
id: page-plugin
title: Plugins - OpenWhisk
header_title: Apache OpenWhisk
header_icon: /assets/images/icons/plugins/openwhisk.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Installation
      - label: Configuration
  - label: Usage
    items:
      - label: Demonstration
      - label: Limitations
---

This plugin invokes
[OpenWhisk action](https://github.com/openwhisk/openwhisk/blob/master/docs/actions.md).
It can be used in combination with other request plugins to secure, manage
or extend the function.

----

## Installation

You can either use the LuaRocks package manager to install the plugin

```bash
$ luarocks install kong-plugin-openwhisk
```

or install it from [source](https://github.com/Mashape/kong-plugin-openwhisk). 
For more infomation on Plugin installation, please see the documentation
[Plugin Development - (un)Install your plugin](/docs/latest/plugin-development/distribution/)

## Configuration

Method 1: apply it on top of an API by executing the following request on your
Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=openwhisk" \
    --data "config.host=OPENWHISK_HOST" \
    --data "config.service_token=AUTHENTICATION_TOKEN" \
    --data "config.action=ACTION_NAME" \
    --data "config.path=PATH_TO_ACTION"
```

Method 2: apply it globally (on all APIs) by executing the following request on
your Kong server:

```bash
$ curl -X POST http://kong:8001/plugins \
    --data "name=openwhisk" \
    --data "config.host=OPENWHISK_HOST" \
    --data "config.service_token=AUTHENTICATION_TOKEN" \
    --data "config.action=ACTION_NAME" \
    --data "config.path=PATH_TO_ACTION"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

Please read the [Plugin Reference](https://getkong.org/docs/latest/admin-api/#add-plugin)
for more information.

Attribute                                | Description
----------------------------------------:| -----------
`name`                                   | The name of the plugin to use, in this case: `openwhisk`
`config.host`                            | Host of the OpenWhisk server.
`config.port`<br>*optional*              | Port of the OpenWhisk server. Defaults to `443`.
`config.path`                            | The path to `Action` resource.
`config.action`                          | Name of the `Action` to be invoked by the plugin.
`config.service_token`<br>*optional*     | The service token to access Openwhisk resources.
`config.https_verify`<br>*optional*      | Set it to true to authenticate Openwhisk server. Defaults to `false`.
`config.https`<br>*optional*             | Use of HTTPS to connect with the OpenWhisk server. Defaults to `true`.
`config.timeout`<br>*optional*           | Timeout in seconds before aborting a connection to OpenWhisk server. Defaults to `60 seconds`.
`config.result`<br>*optional*            | Return only the result of the Action invoked. Defaults to `true`.
`config.keepalive`<br>*optional*         | Defines for how long an idle connection to OpenWhisk server will live before being closed. Defaults to `60 seconds`.


Note: If `config.https_verify` is set as `true` then the server certificate
will be verified according to the CA certificates specified by the
`lua_ssl_trusted_certificate` directive in your Kong configuration.

----

## Demonstration

For this demonstration we are running Kong and 
[Openwhisk platform](https://github.com/openwhisk/openwhisk) locally on a
Vagrant machine on a MacOS.

1. Create a javascript action `hello` with the following code snippet on the
Openwhisk platform using [`wsk cli`](https://github.com/openwhisk/openwhisk-cli).

    ```javascript
    function main(params) {
        var name = params.name || 'World';
        return {payload:  'Hello, ' + name + '!'};
    }
    ```

    ```bash
    $ wsk action create hello hello.js

    ok: created action hello
    ```

2. Create an API on Kong

    ```bash
    $ curl -i -X  POST http://localhost:8001/apis/ \
      --data "name=openwhisk-test" -d "hosts=example.com" \
      --data "upstream_url=http://nowhere.com"

    HTTP/1.1 201 Created
    ...

    ```

3. Apply the `openwhisk` plugin to the API on Kong

    ```bash
    $ curl -i -X POST http://localhost:8001/apis/openwhisk-test/plugins \
        --data "name=openwhisk" \
        --data "config.host=192.168.33.13" \
        --data "config.service_token=username:key" \
        --data "config.action=hello" \
        --data "config.path=/api/v1/namespaces/guest"

    HTTP/1.1 201 Created
    ...

    ```

4. Make a request to invoke the action

    **Without parameters**

      ```bash
      $ curl -i -X POST http://localhost:8000/ -H "Host:hello.com"
      HTTP/1.1 200 OK
      ...

      {
        "payload": "Hello, World!"
      }
      ```

    **Parameters as form-urlencoded**

      ```bash
      $ curl -i -X POST http://localhost:8000/ -H "Host:hello.com" --data "name=bar"
      HTTP/1.1 200 OK
      ...

      {
        "payload": "Hello, bar!"
      }
      ```

    **Parameters as JSON body**

      ```bash
      $ curl -i -X POST http://localhost:8000/ -H "Host:hello.com" \
        -H "Content-Type:application/json" --data '{"name":"bar"}'
      HTTP/1.1 200 OK
      ...

      {
        "payload": "Hello, bar!"
      }
      ```

    **Parameters as multipart form**

      ```bash
      $ curl -i -X POST http://localhost:8000/ -H "Host:hello.com"  -F name=bar
      HTTP/1.1 100 Continue

      HTTP/1.1 200 OK
      ...

      {
        "payload": "Hello, bar!"
      }
      ```

    **Parameters as querystring**

      ```bash
      $ curl -i -X POST http://localhost:8000/?name=foo -H "Host:hello.com"
      HTTP/1.1 200 OK
      ...

      {
        "payload": "Hello, foo!"
      }
      ```

    **OpenWhisk metadata in response**

      When Kong's `config.result` is set to false, OpenWhisk's metadata will
      be returned in response:

      ```bash
      $ curl -i -X POST http://localhost:8000/?name=foo -H "Host:hello.com"
      HTTP/1.1 200 OK
      ...

      {
        "duration": 4,
        "name": "hello",
        "subject": "guest",
        "activationId": "50218ff03f494f62abbde5dfd2fcc68a",
        "publish": false,
        "annotations": [{
          "key": "limits",
          "value": {
            "timeout": 60000,
            "memory": 256,
            "logs": 10
          }
        }, {
          "key": "path",
          "value": "guest/hello"
        }],
        "version": "0.0.4",
        "response": {
          "result": {
            "payload": "Hello, foo!"
          },
          "success": true,
          "status": "success"
        },
        "end": 1491855076125,
        "logs": [],
        "start": 1491855076121,
        "namespace": "guest"
      }
      ```

----

## Limitations

**Use a fake upstream_url**

When using the this plugin, the response will be returned by the plugin itself
without proxying the request to any upstream service. This means that whatever
`upstream_url` has been set on the [API][api-object] it will never be used.
Although `upstream_url` will never be used, it's currently a mandatory
field in Kong's data model, so feel free to set a fake value (ie, `http://localhost`)
if you are planning to use this plugin. In the future, we will provide a more
intuitive way to deal with similar use cases.

**Response plugins**

There is a known limitation in the system that prevents some response plugins
from being executed. We are planning to remove this limitation in the future.

[api-object]: /docs/latest/admin-api/#api-object
