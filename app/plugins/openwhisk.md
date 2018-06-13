---
id: page-plugin
title: Plugins - OpenWhisk
header_title: Apache OpenWhisk
header_icon: /assets/images/icons/plugins/openwhisk.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Usage
    items:
      - label: Demonstration
      - label: Limitations

description: |

  This plugin invokes
  [OpenWhisk Action](https://github.com/openwhisk/openwhisk/blob/master/docs/actions.md).
  It can be used in combination with other request plugins to secure, manage
  or extend the function.

installation: |

  You can either use the LuaRocks package manager to install the plugin

  ```bash
  $ luarocks install kong-plugin-openwhisk
  ```

  or install it from [source](https://github.com/Mashape/kong-plugin-openwhisk).
  For more infomation on Plugin installation, please see the documentation
  [Plugin Development - (un)Install your plugin](/latest/plugin-development/distribution/)

params:
  name: openwhisk
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: host
      required: true
      default:
      value_in_examples: OPENWHISK_HOST
      description: Host of the OpenWhisk server.
    - name: port
      required: false
      default: "`443`"
      description: Port of the OpenWhisk server.
    - name: path
      required: true
      default:
      value_in_examples: PATH_TO_ACTION
      description: |
        The path to `Action` resource.
    - name: action
      required: true
      default:
      value_in_examples: ACTION_NAME
      description: |
        Name of the `Action` to be invoked by the plugin.
    - name: service_token
      required: true
      default:
      value_in_examples: AUTHENTICATION_TOKEN
      description: The service token to access Openwhisk resources.
    - name: https_verify
      required: false
      default: "`false`"
      description: |
        Set it to `true` to authenticate Openwhisk server.
    - name: https
      required: false
      default: "`true`"
      description: Use of HTTPS to connect with the OpenWhisk server.
    - name: result
      required: false
      default: "`true`"
      description: |
        Return only the result of the `Action` invoked.
    - name: timeout
      required: false
      default: "`60000`"
      description: Timeout in milliseconds before aborting a connection to OpenWhisk server.
    - name: keepalive
      required: false
      default: "`60000`"
      description: Time in milliseconds for which an idle connection to OpenWhisk server will live before being closed.

  extra: |
    Note: If `config.https_verify` is set as `true` then the server certificate
    will be verified according to the CA certificates specified by the
    `lua_ssl_trusted_certificate` directive in your Kong configuration.

---

## Demonstration

For this demonstration we are running Kong and
[Openwhisk platform](https://github.com/openwhisk/openwhisk) locally on a
Vagrant machine on a MacOS.

1. Create a javascript Action `hello` with the following code snippet on the
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

2. Create a Service or Route (or use the depreciated API entity)

    Create a Service.

    ```bash
    $ curl -i -X  POST http://localhost:8001/services/ \
      --data "name=openwhisk-test" \
      --data "url=http://example.com"

    HTTP/1.1 201 Created
    ...

    ```

    Create a Route that uses the Service.

    ```bash
    $ curl -i -f -X  POST http://localhost:8001/services/openwhisk-test/routes/ \
      --data "paths[]=/"

    HTTP/1.1 201 Created
    ...

    ```

    Or you could use the API entity.

    ```bash
    $ curl -i -X  POST http://localhost:8001/apis/ \
      --data "name=openwhisk-test" -d "hosts=example.com" \
      --data "upstream_url=http://example.com"

    HTTP/1.1 201 Created
    ...

    ```

3. Enable the `openwhisk` plugin on the Route

Plugins can be enabled on a Service or a Route. This example uses a Service.

    ```bash
    $ curl -i -X POST http://localhost:8001/services/openwhisk-test/plugins \
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
      $ curl -i -X POST http://localhost:8000/ -H "Host:example.com"
      HTTP/1.1 200 OK
      ...

      {
        "payload": "Hello, World!"
      }
      ```

    **Parameters as form-urlencoded**

      ```bash
      $ curl -i -X POST http://localhost:8000/ -H "Host:example.com" --data "name=bar"
      HTTP/1.1 200 OK
      ...

      {
        "payload": "Hello, bar!"
      }
      ```

    **Parameters as JSON body**

      ```bash
      $ curl -i -X POST http://localhost:8000/ -H "Host:example.com" \
        -H "Content-Type:application/json" --data '{"name":"bar"}'
      HTTP/1.1 200 OK
      ...

      {
        "payload": "Hello, bar!"
      }
      ```

    **Parameters as multipart form**

      ```bash
      $ curl -i -X POST http://localhost:8000/ -H "Host:example.com"  -F name=bar
      HTTP/1.1 100 Continue

      HTTP/1.1 200 OK
      ...

      {
        "payload": "Hello, bar!"
      }
      ```

    **Parameters as querystring**

      ```bash
      $ curl -i -X POST http://localhost:8000/?name=foo -H "Host:example.com"
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
      $ curl -i -X POST http://localhost:8000/?name=foo -H "Host:example.com"
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

### Limitations

#### Use a fake upstream service

When using the OpenWhisk plugin, the response will be returned by the plugin
itself without proxying the request to any upstream service. This means that
a Service's `host`, `port`, `path` properties will be ignored, but must still
be specified for the entity to be validated by Kong. The `host` property in
particular must either be an IP address, or a hostname that gets resolved by
your nameserver.

When the plugin is added to an API entity (which is deprecated as of 0.13.0),
it is the `upsream_url` property which must be specified and resolvable as well
(but ignored).

#### Response plugins

There is a known limitation in the system that prevents some response plugins
from being executed. We are planning to remove this limitation in the future.

[api-object]: /latest/admin-api/#api-object
