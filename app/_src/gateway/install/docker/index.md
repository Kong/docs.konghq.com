---
title: Install Kong Gateway on Docker
konnect_cta_card: true
---

This guide provides steps to configure {{site.base_gateway}} on Docker with or without a database.
The database used in this guide is PostgreSQL.

If you prefer to use the open-source {{site.base_gateway}} image with Docker
Compose, Kong also provides a
[Docker Compose template](https://github.com/Kong/docker-kong/tree/master/compose)
with built-in orchestration and scalability.

Some [older {{site.base_gateway}} images](https://support.konghq.com/support/s/article/Downloading-older-Kong-versions)
are not publicly accessible. If you need a specific patch version and can't
find it on [Kong's public Docker Hub page](https://hub.docker.com/r/kong/kong-gateway), contact
[Kong Support](https://support.konghq.com/).

The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense).
{{site.ce_product_name}} is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

## Prerequisites

{:.note}
> **Note:**
> If you want to run {{ site.base_gateway }} without managing a control plane or a database, [you can get started with Konnect](https://konghq.com/products/kong-konnect/register?utm_medium=referral&utm_source=docs&utm_campaign=gateway-konnect&utm_content=docker-install) in under 5 minutes using our Docker quick start script.

* A Docker-enabled system with proper Docker access
* (Enterprise only) A `license.json` file from Kong

Choose a path to install {{site.base_gateway}}:
* [With a database](#install-kong-gateway-with-a-database): Use a database to
store Kong entity configurations. Can use the Admin API or declarative
configuration files to configure Kong.
* [Without a database (DB-less mode)](#install-kong-gateway-in-db-less-mode):
Store Kong configuration in-memory on the node. In this mode, the Admin API is
read only, and you have to manage Kong using declarative configuration.

If you're not sure which option to use, we recommend starting [with a database](#install-kong-gateway-with-a-database)

## Install {{site.base_gateway}} with a database

Set up a {{site.base_gateway}} container with a PostgreSQL database to store
Kong configuration.

{% if_version lte:3.3.x %}
{% include_cached /md/enterprise/cassandra-deprecation.md length='short' release=page.release %}
{% endif_version %}

### Prepare the database

1. Create a custom Docker network to allow the containers to discover and
communicate with each other:

    ```sh
    docker network create kong-net
    ```

    You can name this network anything you want. We use `kong-net` as
    an example throughout this guide.

1. Start a PostgreSQL container:

    ```sh
    docker run -d --name kong-database \
     --network=kong-net \
     -p 5432:5432 \
     -e "POSTGRES_USER=kong" \
     -e "POSTGRES_DB=kong" \
     -e "POSTGRES_PASSWORD=kongpass" \
     postgres:13
    ```

    * `POSTGRES_USER` and `POSTGRES_DB`: Set these values to `kong`. This is
    the default value that {{site.base_gateway}} expects.
    * `POSTGRES_PASSWORD`: Set the database password to any string.

    In this example, the Postgres container named `kong-database` can
    communicate with any containers on the `kong-net` network.

1. Prepare the Kong database:

{% capture migrations %}
{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
```sh
docker run --rm --network=kong-net \
 -e "KONG_DATABASE=postgres" \
 -e "KONG_PG_HOST=kong-database" \
 -e "KONG_PG_PASSWORD=kongpass" \
 -e "KONG_PASSWORD=test" \
kong/kong-gateway:{{page.versions.ee}} kong migrations bootstrap
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```sh
docker run --rm --network=kong-net \
 -e "KONG_DATABASE=postgres" \
 -e "KONG_PG_HOST=kong-database" \
 -e "KONG_PG_PASSWORD=kongpass" \
kong:{{page.versions.ce}} kong migrations bootstrap
```
<!-- vale off -->
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}
{{ migrations | indent | replace: " </code>", "</code>" }}

    Where:
    * [`KONG_DATABASE`](/gateway/{{page.release}}/reference/configuration/#database):
     Specifies the type of database that Kong is using.
    * [`KONG_PG_HOST`](/gateway/{{page.release}}/reference/configuration/#postgres-settings):
    The name of the Postgres Docker container that is communicating over the
    `kong-net` network, from the previous step.
    * [`KONG_PG_PASSWORD`](/gateway/{{page.release}}/reference/configuration/#postgres-settings):
    The password that you set when bringing up the Postgres container in the
    previous step.
    * `KONG_PASSWORD` (Enterprise only): The default password for the admin
    super user for Kong Gateway.
    * `{IMAGE-NAME:TAG} kong migrations bootstrap`:
    In order, this is the Kong Gateway container name and tag, followed by the
    command to Kong to prepare the Postgres database.
<!-- vale on -->

### Start {{site.base_gateway}}

{% include_cached /md/admin-listen.md desc='long' release=page.release %}

1. (Optional) If you have an Enterprise license for {{site.base_gateway}},
export the license key to a variable:

    The license data must contain straight quotes to be considered valid JSON
    (`'` and `"`, not `’` or `“`).

    {:.note}
    > **Note:**
    The following license is only an example. You must use the following format,
    but provide your own content.

    ```bash
    export KONG_LICENSE_DATA='{"license":{"payload":{"admin_seats":"1","customer":"Example Company, Inc","dataplanes":"1","license_creation_date":"2017-07-20","license_expiration_date":"2017-07-20","license_key":"00141000017ODj3AAG_a1V41000004wT0OEAU","product_subscription":"Konnect Enterprise","support_plan":"None"},"signature":"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b","version":"1"}}'
    ```
<!-- vale off -->
1. Run the following command to start a container with {{site.base_gateway}}:
{% capture start_container %}
{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}

```sh
docker run -d --name kong-gateway \
 --network=kong-net \
 -e "KONG_DATABASE=postgres" \
 -e "KONG_PG_HOST=kong-database" \
 -e "KONG_PG_USER=kong" \
 -e "KONG_PG_PASSWORD=kongpass" \
 -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
 -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
 -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
 -e "KONG_ADMIN_GUI_URL=http://localhost:8002" \
 -e KONG_LICENSE_DATA \
 -p 8000:8000 \
 -p 8443:8443 \
 -p 8001:8001 \
 -p 8444:8444 \
 -p 8002:8002 \
 -p 8445:8445 \
 -p 8003:8003 \
 -p 8004:8004 \
 kong/kong-gateway:{{page.versions.ee}}
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
{% if_version lte:3.3.x %}
```sh
docker run -d --name kong-gateway \
 --network=kong-net \
 -e "KONG_DATABASE=postgres" \
 -e "KONG_PG_HOST=kong-database" \
 -e "KONG_PG_USER=kong" \
 -e "KONG_PG_PASSWORD=kongpass" \
 -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
 -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
 -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
 -p 8000:8000 \
 -p 8443:8443 \
 -p 127.0.0.1:8001:8001 \
 -p 127.0.0.1:8444:8444 \
 kong:{{page.versions.ce}}
 ```
{% endif_version %}
{% if_version gte:3.4.x %}
```sh
docker run -d --name kong-gateway \
 --network=kong-net \
 -e "KONG_DATABASE=postgres" \
 -e "KONG_PG_HOST=kong-database" \
 -e "KONG_PG_USER=kong" \
 -e "KONG_PG_PASSWORD=kongpass" \
 -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
 -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
 -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
 -e "KONG_ADMIN_GUI_URL=http://localhost:8002" \
 -p 8000:8000 \
 -p 8443:8443 \
 -p 127.0.0.1:8001:8001 \
 -p 127.0.0.1:8002:8002 \
 -p 127.0.0.1:8444:8444 \
 kong:{{page.versions.ce}}
 ```
{% endif_version %}
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}
{{ start_container | indent | replace: " </code>", "</code>" }}

    Where:
    * `--name` and `--network`: The name of the container to create,
    and the Docker network it communicates on.
    * [`KONG_DATABASE`](/gateway/{{page.release}}/reference/configuration/#database):
    Specifies the type of database that Kong is using.
    * [`KONG_PG_HOST`](/gateway/{{page.release}}/reference/configuration/#postgres-settings):
    The name of the Postgres Docker container that is communicating over the
    `kong-net` network.
    * [`KONG_PG_USER` and `KONG_PG_PASSWORD`](/gateway/{{page.release}}/reference/configuration/#postgres-settings):
     The Postgres username and password. Kong Gateway needs the login information
     	to store configuration data in the `KONG_PG_HOST` database.
    * All [`_LOG`](/gateway/{{page.release}}/reference/configuration/#general-section)
    parameters: set filepaths for the logs to output to, or use the values in
    the example to  print messages and errors to `stdout` and `stderr`.
    * [`KONG_ADMIN_LISTEN`](/gateway/{{page.release}}/reference/configuration/#admin_listen):
    The port that the Kong Admin API listens on for requests.
    * [`KONG_ADMIN_GUI_URL`](/gateway/{{page.release}}/reference/configuration/#admin_gui_url): {% if_version lte:3.3.x %}(Not available in OSS) {% endif_version %}The URL for accessing Kong Manager, preceded by a protocol
    (for example, `http://`).
    * `KONG_LICENSE_DATA`: (Enterprise only) If you have a license file and have saved it
    as an environment variable, this parameter pulls the license from your environment.

1. Verify your installation:

    Access the `/services` endpoint using the Admin API:

    ```sh
    curl -i -X GET --url http://localhost:8001/services
    ```

    You should receive a `200` status code.
<!-- vale on -->
{% if_version lte:3.3.x %}
1. (Not available in OSS) Verify that Kong Manager is running by accessing it
using the URL specified in `KONG_ADMIN_GUI_URL`:

    ```
    http://localhost:8002
    ```
{% endif_version %}
{% if_version gte:3.4.x %}
1. Verify that Kong Manager is running by accessing it
using the URL specified in `KONG_ADMIN_GUI_URL`:

    ```
    http://localhost:8002
    ```
{% endif_version %}
### Get started with {{site.base_gateway}}

Now that you have a running Gateway instance, Kong provides a series of
[getting started guides](/gateway/{{page.release}}/get-started/services-and-routes/)
 to help you set up and enhance your first Service.


In particular, right after installation you might want to:
* [Create a service and a route](/gateway/{{page.release}}/get-started/services-and-routes/)
* [Configure a plugin](/gateway/{{page.release}}/get-started/rate-limiting/)
* [Secure your services with authentication](/gateway/{{page.release}}/get-started/key-authentication/)

### Clean up containers

If you're done testing {{site.base_gateway}} and no longer need the containers, you
can clean them up using the following commands:

```
docker kill kong-gateway
docker kill kong-database
docker container rm kong-gateway
docker container rm kong-database
docker network rm kong-net
```

## Install {{site.base_gateway}} in DB-less mode

The following steps walk you through starting {{site.base_gateway}} in
[DB-less mode](/gateway/{{page.release}}/production/deployment-topologies/db-less-and-declarative-config).

### Create a Docker network

Run the following command:

```bash
docker network create kong-net
```

You can name this network anything you want. We use `kong-net` as
an example throughout this guide.

This step is not strictly needed for running Kong in DB-less mode, but it is a good
precaution in case you want to add other things in the future (like a Rate Limiting plugin
backed up by a Redis cluster).

### Prepare your configuration file

1. Prepare your declarative configuration file in `.yml` or `.json` format.

    The syntax and properties are
    described in the [Declarative Configuration format] guide. Add whatever core
    entities (Services, Routes, Plugins, Consumers, etc) you need to this file.

    For example, a simple file with a Service and a Route
    could look something like this:

    ```yaml
    _format_version: "3.0"
    _transform: true

    services:
    - host: httpbin.org
      name: example_service
      port: 80
      protocol: http
      routes:
      - name: example_route
        paths:
        - /mock
        strip_path: true
    ```

    This guide assumes you named the file `kong.yml`.

1.  Save your declarative configuration locally, and note the filepath.

### Start {{site.base_gateway}} in DB-less mode

{% include_cached /md/admin-listen.md desc='long' release=page.release %}

1. (Optional) If you have an Enterprise license for {{site.base_gateway}},
export the license key to a variable:

    The license data must contain straight quotes to be considered valid JSON
    (`'` and `"`, not `’` or `“`).

    {:.note}
    > **Note:**
    The following license is only an example. You must use the following format,
    but provide your own content.

    ```bash
    export KONG_LICENSE_DATA='{"license":{"payload":{"admin_seats":"1","customer":"Example Company, Inc","dataplanes":"1","license_creation_date":"2017-07-20","license_expiration_date":"2017-07-20","license_key":"00141000017ODj3AAG_a1V41000004wT0OEAU","product_subscription":"Konnect Enterprise","support_plan":"None"},"signature":"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b","version":"1"}}'
    ```

1. From the same directory where you just created the `kong.yml` file,
run the following command to start a container with {{site.base_gateway}}:

{% capture start_container %}
{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
```sh
docker run -d --name kong-dbless \
 --network=kong-net \
 -v "$(pwd):/kong/declarative/" \
 -e "KONG_DATABASE=off" \
 -e "KONG_DECLARATIVE_CONFIG=/kong/declarative/kong.yml" \
 -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
 -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
 -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
 -e "KONG_ADMIN_GUI_URL=http://localhost:8002" \
 -e KONG_LICENSE_DATA \
 -p 8000:8000 \
 -p 8443:8443 \
 -p 8001:8001 \
 -p 8444:8444 \
 -p 8002:8002 \
 -p 8445:8445 \
 -p 8003:8003 \
 -p 8004:8004 \
 kong/kong-gateway:{{page.versions.ee}}
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
{% if_version lte:3.3.x %}
```sh
docker run -d --name kong-dbless \
 --network=kong-net \
 -v "$(pwd):/kong/declarative/" \
 -e "KONG_DATABASE=off" \
 -e "KONG_DECLARATIVE_CONFIG=/kong/declarative/kong.yml" \
 -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
 -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
 -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
 -p 8000:8000 \
 -p 8443:8443 \
 -p 127.0.0.1:8001:8001 \
 -p 127.0.0.1:8444:8444 \
 kong:{{page.versions.ce}}
 ```
{% endif_version %}
{% if_version gte:3.4.x %}
```sh
docker run -d --name kong-dbless \
 --network=kong-net \
 -v "$(pwd):/kong/declarative/" \
 -e "KONG_DATABASE=off" \
 -e "KONG_DECLARATIVE_CONFIG=/kong/declarative/kong.yml" \
 -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
 -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
 -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
 -e "KONG_ADMIN_GUI_URL=http://localhost:8002" \
 -p 8000:8000 \
 -p 8443:8443 \
 -p 127.0.0.1:8001:8001 \
 -p 127.0.0.1:8444:8444 \
 kong:{{page.versions.ce}}
 ```
{% endif_version %}
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}
{{ start_container | indent | replace: " </code>", "</code>" }}

    Where:
    * `--name` and `--network`: The name of the container to create,
    and the Docker network it communicates on.
    * `-v $(pwd):/path/to/target/`: Mount the current directory on your
    local filesystem to a directory in the Docker container. This makes the
    `kong.yml` file visible from the Docker container.
    * [`KONG_DATABASE`](/gateway/{{page.release}}/reference/configuration/#database):
     Sets the database to `off` to tell Kong not to use any
    backing database for configuration storage.
    * [`KONG_DECLARATIVE_CONFIG`](/gateway/{{page.release}}/reference/configuration/#declarative_config):
    The path to a declarative configuration file inside the container.
    This path should match the target path that you're mapping with `-v`.
    * All [`_LOG`](/gateway/{{page.release}}/reference/configuration/#general-section)
    parameters: set filepaths for the logs to output to, or use the values in
    the example to  print messages and errors to `stdout` and `stderr`.
    * [`KONG_ADMIN_LISTEN`](/gateway/{{page.release}}/reference/configuration/#admin_listen):
    The port that the Kong Admin API listens on for requests.
    * [`KONG_ADMIN_GUI_URL`](/gateway/{{page.release}}/reference/configuration/#admin_gui_url): {% if_version lte:3.3.x %}(Not available in OSS) {% endif_version %}The URL for accessing Kong Manager, preceded by a protocol
    (for example, `http://`).
    * `KONG_LICENSE_DATA`: (Enterprise only) If you have a license file and have saved it
    as an environment variable, this parameter pulls the license from your environment.

1. Verify that {{site.base_gateway}} is running:

    ```sh
    curl -i http://localhost:8001
    ```

    Test an endpoint. For example, get a list of services:

    ```sh
    curl -i http://localhost:8001/services
    ```

[DB-less mode]: /gateway/{{page.release}}/production/deployment-topologies/db-less-and-declarative-config/
[Declarative Configuration format]: /gateway/{{page.release}}/production/deployment-topologies/db-less-and-declarative-config/#the-declarative-configuration-format
[Docker Volume]: https://docs.docker.com/storage/volumes/

### Get started with {{site.base_gateway}}

Now that you have a running Gateway instance, Kong provides a series of
[getting started guides](/gateway/{{page.release}}/get-started/services-and-routes/)
to help you set up and enhance your first Service.

If you use the sample `kong.yml` in this guide, you already have a Service and
a Route configured. Here are a few more things to check out:
* [Configure a plugin](/gateway/{{page.release}}/get-started/rate-limiting?tab=using-deck-yaml/)
* [Secure your services with authentication](/gateway/{{page.release}}/get-started/key-authentication?tab=using-deck-yaml/)
* [Load balance traffic across targets](/gateway/{{page.release}}/get-started/load-balancing/?tab=using-deck-yaml/)

### Clean up containers

If you're done testing {{site.base_gateway}} and no longer need the containers, you
can clean them up using the following commands:

```
docker kill kong-dbless
docker container rm kong-dbless
docker network rm kong-net
```

## Running Kong in read-only mode

Starting with {{site.base_gateway}} 3.2.0, you can run the container in read-only mode. To do so, mount a Docker volume to the locations where Kong needs to write data. The default configuration requires write access to `/tmp` and to the prefix path:

{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
```sh
docker run --read-only -d --name kong-dbless \
 --network=kong-net \
 -v "$(pwd)/declarative:/kong/declarative/" \
 -v "$(pwd)/tmp_volume:/tmp" \
 -v "$(pwd)/prefix_volume:/var/run/kong" \
 -e "KONG_PREFIX=/var/run/kong" \
 -e "KONG_DATABASE=off" \
 -e "KONG_DECLARATIVE_CONFIG=/kong/declarative/kong.yml" \
 -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
 -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
 -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
 -e "KONG_ADMIN_GUI_URL=http://localhost:8002" \
 -e KONG_LICENSE_DATA \
 -p 8000:8000 \
 -p 8443:8443 \
 -p 8001:8001 \
 -p 8444:8444 \
 -p 8002:8002 \
 -p 8445:8445 \
 -p 8003:8003 \
 -p 8004:8004 \
 kong/kong-gateway:{{page.versions.ee}}
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```sh
docker run --read-only -d --name kong-dbless \
 --network=kong-net \
 -v "$(pwd)/declarative:/kong/declarative/" \
 -v "$(pwd)/tmp_volume:/tmp" \
 -v "$(pwd)/prefix_volume:/var/run/kong" \
 -e "KONG_PREFIX=/var/run/kong" \
 -e "KONG_DATABASE=off" \
 -e "KONG_DECLARATIVE_CONFIG=/kong/declarative/kong.yml" \
 -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
 -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
 -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
 -p 8000:8000 \
 -p 8443:8443 \
 -p 127.0.0.1:8001:8001 \
 -p 127.0.0.1:8444:8444 \
 kong:{{page.versions.ce}}
 ```
{% endnavtab %}
{% endnavtabs_ee %}

## Troubleshooting

For troubleshooting license issues, see:
* [Deployment options for licenses](/gateway/{{page.release}}/licenses/deploy/)
* [`/licenses` API reference](/gateway/{{page.release}}/admin-api/licenses/reference/)
* [`/licenses` API examples](/gateway/{{page.release}}/licenses/examples/)

If you did not receive a `200 OK` status code or need assistance completing
setup, reach out to your support contact or head over to the
[Support Portal](https://support.konghq.com/support/s/).
