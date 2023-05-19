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
wsk action create hello hello.js
```

```
ok: created action hello
```

### Step 2. Create a service or route

{% navtabs %}
{% navtab With a database %}

Create a service:

```bash
curl -i -X  POST http://localhost:8001/services/ \
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
curl -i -f -X  POST http://localhost:8001/services/openwhisk-test/routes/ \
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
curl -i -X POST http://localhost:8001/services/openwhisk-test/plugins \
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
  curl -i -X POST http://localhost:8000/ -H "Host:example.com"
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
  curl -i -X POST http://localhost:8000/ -H "Host:example.com" --data "name=bar"
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
  curl -i -X POST http://localhost:8000/ -H "Host:example.com" \
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
  curl -i -X POST http://localhost:8000/ -H "Host:example.com"  -F name=bar
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
  curl -i -X POST http://localhost:8000/?name=foo -H "Host:example.com"
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
  curl -i -X POST http://localhost:8000/?name=foo -H "Host:example.com"
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
