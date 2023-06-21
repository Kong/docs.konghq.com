---
title: DB-less and Declarative Configuration
---


Traditionally, {{site.base_gateway}} has always required a database, to store its configured entities such as routes,
services and plugins. Kong uses its configuration file, `kong.conf`, to
specify the use of the database and its [various settings](/gateway/{{page.kong_version}}/reference/configuration/#datastore-section).

{{site.base_gateway}} can be run without a database using only in-memory storage for entities. We call this DB-less mode. When running {{site.base_gateway}} DB-less, the configuration of entities is done in a second configuration file, in YAML or JSON, using declarative configuration.

The combination of DB-less mode and declarative configuration has a number
of benefits:

* Reduced number of dependencies: No need to manage a database installation
  if the entire setup for your use-cases fits in memory.
* Automation in CI/CD scenarios: Configuration for
  entities can be kept in a single source of truth managed via a Git
  repository.
* Enables more deployment options for {{site.base_gateway}}.

## Declarative configuration

The key idea in declarative configuration is the notion
that it is *declarative*, as opposed to an *imperative* style of
configuration. "Imperative" means that a configuration is given as a series of
orders: "do this, then do that". "Declarative" means that the configuration is
given all at once: "I declare this to be the state of the world".

The Kong Admin API is an example of an imperative configuration tool. The
final state of the configuration is attained through a sequence of API calls:
one call to create a Service, another call to create a Route, another call to
add a Plugin, and so on.

Performing the configuration incrementally like this has the undesirable
side-effect that *intermediate states* happen. In the above example, there is
a window of time in between creating a Route and adding the Plugin in which
the Route did not have the Plugin applied.

A declarative configuration file, on the other hand, contains the settings
for all desired entities in a single file. Once that file is loaded into
{{site.base_gateway}}, it replaces the entire configuration. When incremental changes are
desired, they are made to the declarative configuration file, which is then
reloaded in its entirety. At all times, the configuration described in the
file loaded into Kong is the configured state of the system.

## Set up Kong in DB-less mode

To use {{site.base_gateway}} in DB-less mode, set the `database` directive of `kong.conf` to `off`. As usual, you can do this by editing `kong.conf` and setting
`database=off` or via environment variables. You can then start Kong
as usual:

```
export KONG_DATABASE=off
kong start -c kong.conf
```

Once Kong starts, access the `/` endpoint of the Admin API to verify that it
is running without a database. It will return the entire Kong configuration;
verify that `database` is set to `off`.

Command:

```sh
curl -i -X GET http://localhost:8001
```

Sample response:

```json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 6342
Content-Type: application/json; charset=utf-8
Date: Wed, 27 Mar 2019 15:24:58 GMT
Server: kong/{{page.versions.ce}}
{
    "configuration:" {
       ...
       "database": "off",
       ...
    },
    ...
    "version": "{{page.versions.ce}}"
}
```

{{site.base_gateway}} is running, but no declarative configuration has been loaded yet. This
means that the configuration of this node is empty. There are no routes,
services, or entities of any kind.

Command:

```sh
curl -i -X GET http://localhost:8001/routes
```

Sample response:

```json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 23
Content-Type: application/json; charset=utf-8
Date: Wed, 27 Mar 2019 15:30:02 GMT
Server: kong/{{page.versions.ce}}

{
    "data": [],
    "next": null
}
```

## Creating a declarative configuration file

{:.note}
> **Note:** We recommend using decK to manage your declarative configuration.
See the [decK documentation](/deck/) for more information.

To load entities into DB-less Kong, you need a declarative configuration
file. The following command creates a skeleton file to get you
started:

```
kong config -c kong.conf init
```

This command creates a `kong.yml` file in the current directory,
containing examples of the syntax for declaring entities and their
relationships. All examples in the generated file are commented-out
by default. You can experiment by uncommenting the examples
(removing the `#` markers) and modifying their values.

## Declarative configuration format

The {{site.base_gateway}} declarative configuration format consists of lists of
entities and their attributes. This is a small yet complete
example that illustrates a number of features:

```yaml
_format_version: "3.0"
_transform: true

services:
- name: my-service
  url: https://example.com
  plugins:
  - name: key-auth
  routes:
  - name: my-route
    paths:
    - /

consumers:
- username: my-user
  keyauth_credentials:
  - key: my-key
```

See the [declarative configuration schema](https://github.com/Kong/deck/blob/main/file/kong_json_schema.json)
for all configuration options.

The only mandatory piece of metadata is `_format_version: "3.0"`, which
specifies the version number of the declarative configuration syntax format.
This also matches the minimum version of Kong required to parse the file.

The `_transform` metadata is an optional boolean (defaults to `true`), which
controls whether schema transformations will occur while importing. The rule
of thumb for using this field is: if you are importing plain-text credentials
(i.e. passwords), you likely want to set it to `true`, so that Kong will
encrypt/hash them before storing them in the database. If you are importing
**already hashed/encrypted** credentials, set `_transform` to `false` so that
the encryption does not happen twice.

At the top level, you can specify any Kong entity, be it a core entity such as
`services` and `consumers` as in the above example, or custom entities created
by plugins, such as `keyauth_credentials`. This makes the declarative
configuration format inherently extensible, and it is the reason why `kong
config` commands that process declarative configuration require `kong.conf` to
be available, so that the `plugins` directive is taken into account.

When entities have a relationship, such as a route that points to a service,
this relationship can be specified via nesting.

Only one-to-one relationships can be specified by nesting: a plugin that is
applied to a service can have its relationship depicted via nesting, as in the
example above. Relationships involving more than two entities, such as a
plugin that is applied to both a service and a consumer, must be done via a
top-level entry. In that case, the entities can be identified by their primary keys
or identifying names (the same identifiers that can be used to refer to them
in the Admin API). This is an example of a plugin applied to a service and
a consumer:

```yml
plugins:
- name: syslog
  consumer: my-user
  service: my-service
```

## Check the file

Once you are done editing the file, you can check the syntax
for any errors before attempting to load it into {{site.base_gateway}}:

```
kong config -c kong.conf parse kong.yml
```

Response:
```
parse successful
```

## Load the file

There are two ways to load a declarative configuration file into Kong: using
`kong.conf` or the Admin API.

To load a declarative configuration file at Kong start-up, use the
`declarative_config` directive in `kong.conf` (or, as usual to all `kong.conf`
entries, the equivalent `KONG_DECLARATIVE_CONFIG` environment variable):

```
export KONG_DATABASE=off \
export KONG_DECLARATIVE_CONFIG=kong.yml \
kong start -c kong.conf
```

You can also load a declarative configuration file into a running
Kong node with the Admin API, using the `/config` endpoint. The
following example loads `kong.yml`:

```sh
curl -i -X GET http://localhost:8001/config \
  --data config=@kong.yml
```

{:.important}
> The `/config` endpoint replaces the entire set of entities in memory
with the ones specified in the given file.

Another way you can start Kong in DB-less mode is by including the entire
declarative configuration in a string using the `KONG_DECLARATIVE_CONFIG_STRING`
environment variable:

```
export KONG_DATABASE=off
export KONG_DECLARATIVE_CONFIG_STRING='{"_format_version":"1.1", "services":[{"host":"mockbin.com","port":443,"protocol":"https", "routes":[{"paths":["/"]}]}],"plugins":[{"name":"rate-limiting", "config":{"policy":"local","limit_by":"ip","minute":3}}]}'
kong start
```

## DB-less with Helm (KIC disabled)

When deploying {{site.base_gateway}} on Kubernetes in DB-less mode (`env.database: "off"`) and without the Ingress Controller (`ingressController.enabled: false`), you have to provide a declarative configuration for {{site.base_gateway}} to run. You can provide an existing ConfigMap (`dblessConfig.configMap`) or place the whole configuration into a `values.yaml` (`dblessConfig.config`) parameter. See the example configuration in the [default `values.yaml`](https://github.com/Kong/charts/blob/main/charts/kong/values.yaml) for more detail.

Use `--set-file dblessConfig.config=/path/to/declarative-config.yaml` in Helm commands to substitute in a complete declarative config file.

Externally supplied ConfigMaps are not hashed or tracked in deployment annotations. Subsequent ConfigMap updates require user-initiated deployment rollouts to apply the new configuration. Run `kubectl rollout restart deploy` after updating externally supplied ConfigMap content.

## Using Kong in DB-less mode

There are a number of things to be aware of when using Kong in DB-less
mode.

### Memory cache requirements

The entire configuration of entities must fit inside the Kong
cache. Make sure that the in-memory cache is configured appropriately:
see the `mem_cache_size` directive in `kong.conf`.

### No central database coordination

Since there is no central database, multiple Kong nodes have no
central coordination point and no cluster propagation of data:
nodes are completely independent of each other.

This means that the declarative configuration should be loaded into each node
independently. Using the `/config` endpoint does not affect other Kong
nodes, since they have no knowledge of each other.

### Read-only Admin API

Since the only way to configure entities is via declarative configuration,
the endpoints for CRUD operations on entities are effectively read-only
in the Admin API when running Kong in DB-less mode. `GET` operations
for inspecting entities work as usual, but attempts to `POST`, `PATCH`
`PUT` or `DELETE` in endpoints such as `/services` or `/plugins` will return
`HTTP 405 Not Allowed`.

This restriction is limited to what would be otherwise database operations. In
particular, using `POST` to set the health state of targets is still enabled,
since this is a node-specific in-memory operation.

#### Plugin compatibility

Not all Kong plugins are compatible with DB-less mode. By design, some plugins
require central database coordination or dynamic creation of
entities.

For current plugin compatibility, see [Plugin compatibility](/hub/plugins/compatibility/).

## See also
* [Declarative configuration schema](https://github.com/Kong/deck/blob/main/file/kong_json_schema.json)
* [decK documentation](/deck/latest/)
* [Using decK with {{site.ee_product_name}}](/deck/latest/guides/kong-enterprise/)
