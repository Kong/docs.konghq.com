---
title: DB-less and Declarative Configuration
---


## Introduction

Traditionally, Kong has always required a database, which could be either
Postgres or Cassandra, to store its configured entities such as Routes,
Services and Plugins. Kong uses its configuration file, `kong.conf`, to
specify the use of Postgres and Cassandra and its various settings.

Kong 1.1 added the capability to run Kong without a database, using only
in-memory storage for entities: we call this **DB-less mode**. When running
Kong DB-less, the configuration of entities is done in a second configuration
file, in YAML or JSON, using **declarative configuration**.

The combination of DB-less mode and declarative configuration has a number
of benefits:

* Reduced number of dependencies: no need to manage a database installation
  if the entire setup for your use-cases fits in memory
* it is a good fit for automation in CI/CD scenarios: configuration for
  entities can be kept in a single source of truth managed via a Git
  repository
* It enables more deployment options for Kong: for example, DB-less Kong
  is a natural fit for a lightweight sidecar in a Service Mesh scenario

## What Is Declarative Configuration

<i>If you are already familiar with the concept of declarative configuration you
may skip this section.</i>

The key idea in declarative configuration is, as its name shows, the notion
that it is *declarative*, as opposed to an *imperative* style of
configuration. "Imperative" means that a configuration is given as a series of
orders: "do this, then to that". "Declative" means that the configuration is
given all at once: "I declare this to be the state of the world".

The Kong Admin API is an example of an imperative configuration tool: the
final state of the configuration is obtain through a sequence of API calls:
one call to create a Service, another call to create a Route, another call to
add a Plugin, and so on.

Performing the configuration incrementally like this has the undesirable
side-effect that *intermediate states* happen. In the above example, there is
a window of time in between creating a Route and adding the Plugin in which
the Route did not have the Plugin applied.

A declarative configuration file, on the other hand, will contain the settings
for all desired entities in a single file, and once that file is loaded into
Kong, it replaces the entire configuration. When incremental changes are
desired, they are made to the declarative configuration file, which is then
reloaded in its entirety. At all times, the configuration described in the
file loaded into Kong is the configured state of the system.

## Setting Up Kong in DB-less mode

To use Kong in DB-less mode, set the `database` directive of `kong.conf`
to `off`. As usual, you can do this by editing `kong.conf` and setting
`database=off` or via environment variables. You can then start Kong
as usual:

```
$ export KONG_DATABASE=off
$ kong start -c kong.conf
```

Once Kong starts, access the `/` endpoint of the Admin API to verify that it
is running without a database. It will return the entire Kong configuration;
verify that `database` is set to `off`:

```
$ http :8001/

HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 6342
Content-Type: application/json; charset=utf-8
Date: Wed, 27 Mar 2019 15:24:58 GMT
Server: kong/1.1.0
{
    "configuration:" {
       ...
       "database": "off",
       ...
    },
    ...
    "version": "1.1.0"
}
```

Kong is running, but no declarative configuration was loaded yet. This 
means that the configuration of this node is empty. There are no Routes,
Services or entities of any kind:

```
$ http :8001/routes

HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 23
Content-Type: application/json; charset=utf-8
Date: Wed, 27 Mar 2019 15:30:02 GMT
Server: kong/1.1.0

{
    "data": [], 
    "next": null
}
```

## Creating a Declarative Configuration File

To load entities into DB-less Kong, we need a declarative configuration
file. The following command will create a skeleton file to get you
started:

```
$ kong config -c kong.conf init
```

This command creates a `kong.yml` file in the current directory,
containing examples of the syntax for declaring entities and their
relationships. All examples in the generated file are commented-out
by default. You can experiment by uncommenting the examples
(removing the `#` markers) and modifying their values.

## The Declarative Configuration Format

The Kong declarative configuration format consists of lists of
entities and their attributes. This is a small, yet, complete
example, which illustrates a number of features:

```yaml
_format_version: "1.1"

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

The only mandatory piece of metadata is `_format_version: "1.1"`, which
specifies the version number of the declarative configuration syntax format.
This also matches the minimum version of Kong required to parse the file.

At the top level, you can specify any Kong entity, be it a core entity such as
`services` and `consumers` as in the above example, or custom entities created
by Plugins, such as `keyauth_credentials`. (This makes the declarative
configuration format inherently extensible, and it is the reason why `kong
config` commands that process declarative configuration require `kong.conf` to
be available, so that the `plugins` directive is taken into account.)

When entities have a relationship, such as a Route which points to a Service,
this relationship can be specified via nesting.

Only one-to-one relationships can be specified by nesting: a Plugin that is
applied to a Service can have its relationship depicted via nesting, as in the
example above. Relationships involving more than two entities, such as a
Plugin that is applied to both a Service and a Consumer must be done via a
top-level entry, where the entities can be identified by their primary keys
or identifying names (the same identifiers that can be used to refer to them
in the Admin API). This is an example of a plugin applied to a Service and
a Consumer:

```yml
plugins:
- name: syslog
  consumer: my-user
  service: my-service
```

## Checking The Declarative Configuration File

Once you are done editing the file, it is possible to check the syntax
for any errors before attempting to load it into Kong:

```
$ kong config -c kong.conf parse kong.yml

parse successful
```

## Loading The Declarative Configuration File

There are two ways to load a declarative configuration into Kong: via
`kong.conf` and via the Admin API.

To load a declarative configuration at Kong start-up, use the
`declarative_config` directive in `kong.conf` (or, as usual to all `kong.conf`
entries, the equivalent `KONG_DECLARATIVE_CONFIG` environment variable).

```
$ export KONG_DATABASE=off
$ export KONG_DECLARATIVE_CONFIG=kong.yml
$ kong start -c kong.conf
```

Alternatively, you can load a declarative config into a running
Kong node via its Admin API, using the `/config` endpoint. The 
following example loads `kong.yml` using HTTPie:

```
$ http :8001/config config=@kong.yml
```

The `/config` endpoint replaces the entire set of entities in memory
with the ones specified in the given file.

## Using Kong in DB-less Mode

There are a number of things to be aware of when using Kong in DB-less
mode.

#### Memory Cache Requirements

The entire configuration of entities must fit inside the Kong
cache. Make sure that the in-memory cache is configured appropriately:
see the `mem_cache_size` directive in `kong.conf`.

#### No Central Database Coordination

Since there is no central database, multiple Kong nodes have no
central coordination point and no cluster propagation of data:
nodes are completely independent of each other.

This means that the declarative configuration should be loaded into each node
independently. Using the `/config` endpoint does not affect other Kong
nodes, since they have no knowledge of each other.

#### Read-Only Admin API

Since the only way to configure entities is via declarative config,
the endpoints for CRUD operations on entities are effectively read-only
in the Admin API when running Kong in DB-less mode. `GET` operations
for inspecting entities work as usual, but attempts to `POST`, `PATCH`
`PUT` or `DELETE` in endpoints such as `/services` or `/plugins` will return
`HTTP 405 Not Allowed`.

This restriction is limited to what would be otherwise database operations. In
particular, using `POST` to set the health state of Targets is still enabled,
since this is a node-specific in-memory operation.

#### Plugin Compatibility

Not all Kong plugins are compatible with DB-less mode, since some of them
by design require a central database coordination and/or dynamic creation of
entities.

##### Fully Compatible

The following plugins only read from the database (most of them just to read
their initial config) so they are fully compatible with DB-less:

* `aws-lambda`
* `azure-functions`
* `bot-detection`
* `correlation-id`
* `cors`
* `datadog`
* `file-log`
* `http-log`
* `tcp-log`
* `udp-log`
* `syslog`
* `ip-restriction`
* `prometheus`
* `zipkin`
* `request-transformer`
* `response-transformer`
* `request-termination`
* `kubernetes-sidecar-injector`

##### Partial Compatibility

Authentication plugins can be used insofar as the set of credentials
used is static and specified as part of the declarative configuration.
Admin API endpoints to dynamically create, update or delete credentials
are not available in DB-less mode. Plugins that fall into this 
category are:

* `acl`
* `basic-auth`
* `hmac-auth`
* `jwt`
* `key-auth`

Rate limiting plugins bundled with Kong offer different policies for
storing and coordinating counters: a `local` policy which stores counters
the Nodes's memory, applying limits in a per-node fashion; a `redis`
policy which uses Redis as an external key-value store for coordinating
counters across nodes; and a `cluster` policy which uses the Kong database
as a central coordination point for cluster-wide limits. In DB-less mode
the `local` and `redis` policies are available, and `cluster` cannot be
used. Plugins that fall into this category are:

* `rate-limiting`
* `response-ratelimiting`

The `pre-function` and `post-function` plugins for serverless can be used
in DB-less mode, with the caveat that if any configured functions attempt to
write to the database, the writes will fail.

##### Not Compatible

* `oauth2` - For its regular work, the plugin needs to both generate and delete
  tokens, and commit those changes to the database, which is not compatible with
  DB-less.

