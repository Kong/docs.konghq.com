---
name: Apache OpenWhisk
publisher: Kong Inc.
version: 1.0.x

source_url: https://github.com/Kong/kong-plugin-openwhisk

desc: Invoke and manage OpenWhisk actions from Kong
description: |
  This plugin invokes
  [OpenWhisk Action](https://github.com/openwhisk/openwhisk/blob/master/docs/actions.md).
  The Apache OpenWhisk plugin can be used in combination with other request plugins to secure, manage,
  or extend the function.

type: plugin
cloud: false
categories:
  - serverless

installation: |

  You can either use the LuaRocks package manager to install the plugin

  ```bash
  $ luarocks install kong-plugin-openwhisk
  ```

  or install it from [source](https://github.com/Kong/kong-plugin-openwhisk).
  For more information on plugin installation, see the documentation
  [Plugin Development - (un)Install your plugin](/gateway/latest/plugin-development/distribution/).

params:
  name: openwhisk
  service_id: true
  route_id: true
  consumer_id: true
  konnect_examples: false
  dbless_compatible: yes
  config:
    - name: host
      required: true
      default:
      value_in_examples: <OPENWHISK_HOST>
      datatype: string
      description: Host of the OpenWhisk server.
    - name: port
      required: true
      default: "`443`"
      datatype: integer
      description: Port of the OpenWhisk server.
    - name: path
      required: true
      default:
      value_in_examples: <PATH_TO_ACTION>
      datatype: string
      description: |
        The path to `Action` resource.
    - name: action
      required: true
      default:
      value_in_examples: <ACTION_NAME>
      datatype: string
      description: |
        Name of the `Action` to be invoked by the plugin.
    - name: service_token
      required: false
      default:
      value_in_examples: <AUTHENTICATION_TOKEN>
      datatype: string
      description: The service token to access Openwhisk resources.
    - name: https_verify
      required: false
      default: "`false`"
      datatype: boolean
      description: |
        Set to `true` to authenticate Openwhisk server.
    - name: https
      required: false
      default: "`true`"
      datatype: boolean
      description: Option to use HTTPS to connect with the OpenWhisk server.
    - name: result
      required: false
      default: "`true`"
      datatype: boolean
      description: |
        Return only the result of the invoked `Action`.
    - name: timeout
      required: false
      default: "`60000`"
      datatype: integer
      description: Timeout in milliseconds before closing a connection to OpenWhisk server.
    - name: keepalive
      required: false
      default: "`60000`"
      datatype: integer
      description: Time in milliseconds for which an idle connection to OpenWhisk server lives before being closed.

  extra: |
    Note: If `config.https_verify` is set to `true`, then the server certificate
    is verified according to the CA certificates specified by the
    `lua_ssl_trusted_certificate` directive in your Kong configuration.

---

## Demonstration

For this demonstration, we are running Kong and
[Openwhisk platform](https://github.com/openwhisk/openwhisk) locally on a
Vagrant machine on a MacOS.

### Step 1. Create a JavaScript Action

Create a JavaScript Action `hello` with the following code snippet on the
Openwhisk platform using [`wsk cli`](https://github.com/openwhisk/openwhisk-cli).

```javascript
function main(params) {
    var name = params.name || 'World';
    return {payload:  'Hello, ' + name + '!'};
}
```

```bash
$ wsk action create hello hello.js
```

```
ok: created action hello
```

### Step 2. Create a service or route

{% navtabs %}
{% navtab With a database %}

Create a service:

```bash
$ curl -i -X  POST http://localhost:8001/services/ \
  --data "name=openwhisk-test" \
  --data "url=http://example.com"
```
Response:

```
HTTP/1.1 201 Created
...
```

Create a route that uses the service:

```bash
$ curl -i -f -X  POST http://localhost:8001/services/openwhisk-test/routes/ \
  --data "paths[]=/"
```

Response:
```
HTTP/1.1 201 Created
...
```

{% endnavtab %}
{% navtab Without a database %}

Add a service and an associated route on the declarative config file:

``` yaml
services:
- name: openwhisk-test
  url: http://example.com

routes:
- service: openwhisk-test
  paths: ["/"]
```

{% endnavtab %}
{% endnavtabs %}

### Step 3. Enable the `openwhisk` plugin on the route

{% navtabs %}
{% navtab With a database %}

Plugins can be enabled on a service or a route (or globally). This example uses a service.

```bash
$ curl -i -X POST http://localhost:8001/services/openwhisk-test/plugins \
    --data "name=openwhisk" \
    --data "config.host=192.168.33.13" \
    --data "config.service_token=username:key" \
    --data "config.action=hello" \
    --data "config.path=/api/v1/namespaces/guest"
```

Response:

```
HTTP/1.1 201 Created
...
```

{% endnavtab %}
{% navtab Without a database %}

Add an entry to the `plugins: ` declarative configuration yaml entry.
It can be associated to a service or route. This example uses a service:

``` yaml
plugins:
- name: openwhisk
  config:
    host: 192.168.33.13
    service_token: username:key
    action: hello
    path: /api/v1/namespaces/guest
```

    {% endnavtab %}
    {% endnavtabs %}

### Step 4. Make a request to invoke the action

**Without parameters:**

  ```bash
  $ curl -i -X POST http://localhost:8000/ -H "Host:example.com"
  ```

  Response:

  ```
  HTTP/1.1 200 OK
  ...

  {
    "payload": "Hello, World!"
  }
  ```

**Parameters as form-urlencoded:**

  ```bash
  $ curl -i -X POST http://localhost:8000/ -H "Host:example.com" --data "name=bar"
  ```
  Response:
  ```
  HTTP/1.1 200 OK
  ...

  {
    "payload": "Hello, bar!"
  }
  ```

**Parameters as JSON body:**

  ```bash
  $ curl -i -X POST http://localhost:8000/ -H "Host:example.com" \
    -H "Content-Type:application/json" --data '{"name":"bar"}'
  ```
  Response:
  ```
  HTTP/1.1 200 OK
  ...

  {
    "payload": "Hello, bar!"
  }
  ```

**Parameters as multipart form:**

  ```bash
  $ curl -i -X POST http://localhost:8000/ -H "Host:example.com"  -F name=bar
  ```
  Response:
  ```
  HTTP/1.1 100 Continue

  HTTP/1.1 200 OK
  ...

  {
    "payload": "Hello, bar!"
  }
  ```

**Parameters as querystring:**

  ```bash
  $ curl -i -X POST http://localhost:8000/?name=foo -H "Host:example.com"
  ```
Response:
  ```
  HTTP/1.1 200 OK
  ...

  {
    "payload": "Hello, foo!"
  }
  ```

**OpenWhisk metadata in response:**

  When Kong's `config.result` is set to `false`, OpenWhisk's metadata is
  returned in the response.

  ```bash
  $ curl -i -X POST http://localhost:8000/?name=foo -H "Host:example.com"
  ```
Response:
  ```
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

When using the OpenWhisk plugin, the response is returned by the plugin
itself without proxying the request to any upstream service. This means that
a Service's `host`, `port`, `path` properties are ignored, but must still
be specified for the entity to be validated by Kong. The `host` property in
particular must either be an IP address, or a hostname that gets resolved by
your nameserver.

#### Response plugins

There is a known limitation in the system that prevents some response plugins
from being executed. We are planning to remove this limitation in the future.
