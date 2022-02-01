---
title: Install Kong Gateway on Docker
---

<!-- Banner with links to latest downloads -->
<!-- The install-link and install-listing-link classes are used for tracking, do not remove -->

{:.install-banner}
> See the list of Docker tags and pull the Docker image:
> * [**Kong Gateway**](https://hub.docker.com/r/kong/kong-gateway/tags){:.install-listing-link}
> * [**Kong Gateway (OSS)**](https://hub.docker.com/_/kong){:.install-listing-link}
>
> (latest {{site.base_gateway}} version: {{page.kong_versions[page.version-index].ee-version}})

{{site.base_gateway}} supports both PostgreSQL 9.5+ and Cassandra 3.11.* as its
datastore. This guide provides steps to configure PostgreSQL.

If you prefer to use the open-source {{site.base_gateway}} image with Docker
Compose, Kong also provides a
[Docker Compose template](https://github.com/Kong/docker-kong/tree/master/compose)
with built-in orchestration and scalability.

Some [older {{site.base_gateway}} images](https://support.konghq.com/support/s/article/Downloading-older-Kong-versions)
are not publicly accessible. If you need a specific patch version and can't
find it on [Kong's public Docker Hub page](https://hub.docker.com/r/kong/kong-gateway), contact
[Kong Support](https://support.konghq.com/).

The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense/).
{{site.ce_product_name}} is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

## Prerequisites

* A Docker-enabled system with proper Docker access
* (Enterprise only) A `license.json` file from Kong

## Pull the Kong Gateway image

Pull the Docker image:

{% navtabs codeblock %}
{% navtab Kong Gateway %}
```bash
docker pull kong/kong-gateway:{{page.kong_versions[page.version-index].ee-version}}-alpine
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
docker pull kong:{{page.kong_versions[page.version-index].ce-version}}-alpine
```
{% endnavtab %}
{% endnavtabs %}

You should now have your {{site.base_gateway}} image locally.

Next, choose a path and install Kong Gateway:
* [With a database](#install-kong-gateway-with-a-database)
* [Without a database (DB-less mode)](#install-kong-gateway-in-db-less-mode)

## Install Kong Gateway with a database

Set up a {{site.base_gateway}} container with a PostgreSQL database to store
Kong configuration.

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
     postgres:9.6
    ```

    * `POSTGRES_USER` and `POSTGRES_DB`: Set these values to `kong`. This is
    the default value that Kong Gateway expects.
    * `POSTGRES_PASSWORD`: Set the database password to any string.

    In this example, the Postgres container named `kong-database` can
    communicate with any containers on the `kong-net` network.

1. Prepare the Kong database:

{% capture migrations %}
{% navtabs codeblock %}
{% navtab Kong Gateway %}
```sh
docker run --rm --network=kong-net \
 -e "KONG_DATABASE=postgres" \
 -e "KONG_PG_HOST=kong-database" \
 -e "KONG_PG_PASSWORD=kongpass" \
 -e "KONG_PASSWORD=test" \
kong/kong-gateway kong migrations bootstrap
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```sh
docker run --rm --network=kong-net \
 -e "KONG_DATABASE=postgres" \
 -e "KONG_PG_HOST=kong-database" \
 -e "KONG_PG_PASSWORD=kongpass" \
kong kong migrations bootstrap
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ migrations | indent | replace: " </code>", "</code>" }}

    Where:
    * [`KONG_DATABASE`](/gateway/{{page.kong_version}}/reference/configuration/#database)
     is the database type, or `off` if setting up a data plane for [hybrid mode](/gateway/{{page.kong_version}}/plan-and-deploy/hybrid-mode/hybrid-mode-setup).
    * [`KONG_PG_HOST`](/gateway/{{page.kong_version}}/reference/configuration/#postgres-settings)
    is the name of the Postgres Docker container that is communicating over the
    `kong-net` network, from the previous step.
    * [`KONG_PG_PASSWORD`](/gateway/{{page.kong_version}}/reference/configuration/#postgres-settings)
    The password that you set when bringing up the Postgres container in the
    previous step.
    * `KONG_PASSWORD` (Enterprise only): The default password for the admin
    super user for Kong Gateway.
    * `kong/kong-gateway kong migrations bootstrap` or `kong kong migrations bootstrap`:
    In order, this is the Kong Gateway container tag, followed by the command
    to Kong to prepare the Postgres database.

### Start Kong Gateway

{% include_cached /md/admin-listen.md desc='long' %}

1. Run the following command to start a container with {{site.base_gateway}}:
{% capture start_container %}
{% navtabs codeblock %}
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
 -p 8000:8000 \
 -p 8443:8443 \
 -p 8001:8001 \
 -p 8444:8444 \
 -p 8002:8002 \
 -p 8445:8445 \
 -p 8003:8003 \
 -p 8004:8004 \
 kong/kong-gateway
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```sh
docker run -d --name kong \
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
 kong:latest
 ```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ start_container | indent | replace: " </code>", "</code>" }}

    Where:
    * `--name` and `--network`: The tag of the {{site.base_gateway}} image that
    you're using, and the Docker network it communicates on.
    * [`KONG_DATABASE`](/gateway/{{page.kong_version}}/reference/configuration/#database):
    Specifies whether this node connects directly to a database.
    * [`KONG_PG_HOST`](/gateway/{{page.kong_version}}/reference/configuration/#postgres-settings):
    The name of the Postgres Docker container that is communicating over the
    `kong-net` network.
    * [`KONG_PG_USER` and `KONG_PG_PASSWORD`](/gateway/{{page.kong_version}}/reference/configuration/#postgres-settings):
     The Postgres username and password. Kong Gateway needs the login information
     to store configurations in this database.
    * All [`_LOG`](/gateway/{{page.kong_version}}/reference/configuration/#general-section)
    parameters: set filepaths for the logs to output to, or use the values in
    the example to  print messages and errors to `stdout` and `stderr`.
    * [`KONG_ADMIN_LISTEN`](/gateway/{{page.kong_version}}/reference/configuration/#admin_listen):
    The port that the Kong Admin API listens on for requests.
    * [`KONG_ADMIN_GUI_URL`](/gateway/{{page.kong_version}}/reference/configuration/#admin_gui_url):
    (Enterprise only) The URL for accessing Kong Manager, preceded by a protocol
    (for example, `http://`).

1. Verify your installation:

    Access the `/services` endpoint using the Admin API:

    ```sh
    curl -i -X GET --url http://localhost:8001/services
    ```

    You should receive a `200` status code.

1. (Not available in OSS) Verify that Kong Manager is running by accessing it using the URL specified in `KONG_ADMIN_GUI_URL`:

    ```
    http://localhost:8002
    ```

## Install Kong Gateway in DB-less mode

The steps involved in starting Kong in [DB-less mode](/gateway/{{page.kong_version}}/reference/db-less-and-declarative-config) are the following:

### Set up a Docker volume

1. Create a Docker network:

    ```bash
    docker network create kong-net
    ```

    You can name this network anything you want. We use `kong-net` as
    an example throughout this guide.

    This step is not strictly needed for running Kong in DB-less mode, but it is a good
    precaution in case you want to add other things in the future (like a Rate Limiting plugin
    backed up by a Redis cluster).

1. Create a Docker volume:

    ```bash
    docker volume create kong-vol
    ```

    For the purposes of this guide, a [Docker Volume][Docker Volume] is a folder inside the host machine which
    can be mapped into a folder in the container. In this guide, we name the
    volume `kong-vol`.

1. Inspect the Docker volume:

    ```bash
    docker volume inspect kong-vol
    ```

    The result should be similar to this:

    ```json
    [
        {
            "CreatedAt": "2019-05-28T12:40:09Z",
            "Driver": "local",
            "Labels": {},
            "Mountpoint": "/var/lib/docker/volumes/kong-vol/_data",
            "Name": "kong-vol",
            "Options": {},
            "Scope": "local"
        }
    ]
    ```

    Notice the `MountPoint` entry. You will need that path in the next step.

### Prepare your configuration file

1. Prepare your declarative configuration file in `.yml` or `.json` format.

    The syntax and properties are
    described in the [Declarative Configuration format] guide. Add whatever core
    entities (Services, Routes, Plugins, Consumers, etc) you need to this file.

    This guide assumes you named the file `kong.yml`.

1.  Save your declarative configuration file inside the `MountPoint` path
mentioned in the previous step. In the case of this
guide, that would be `/var/lib/docker/volumes/kong-vol/_data/kong.yml`.

### Start Kong Gateway in DB-less mode

{% include_cached /md/admin-listen.md desc='long' %}

1. Run the following command to start a container with {{site.base_gateway}}.

   Although it's possible to start the Kong container with just
   `KONG_DATABASE=off`, we recommend also including the declarative configuration
   file as a parameter via the `KONG_DECLARATIVE_CONFIG` variable name. To do
   this, you need to make the file visible from within the container.
   Use the `-v` flag, which maps the Docker volume to the
   `/usr/local/kong/declarative` folder in the container.

{% capture start_container %}
{% navtabs codeblock %}
{% navtab Kong Gateway %}
```sh
docker run -d --name kong-gateway \
 --network=kong-net \
 -v "kong-vol:/usr/local/kong/declarative" \
 -e "KONG_DATABASE=off" \
 -e "KONG_DECLARATIVE_CONFIG=/usr/local/kong/declarative/kong.yml" \
 -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
 -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
 -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
 -e "KONG_ADMIN_GUI_URL=http://localhost:8002" \
 -p 8000:8000 \
 -p 8443:8443 \
 -p 8001:8001 \
 -p 8444:8444 \
 -p 8002:8002 \
 -p 8445:8445 \
 -p 8003:8003 \
 -p 8004:8004 \
 kong/kong-gateway
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```sh
docker run -d --name kong \
 --network=kong-net \
 -v "kong-vol:/usr/local/kong/declarative" \
 -e "KONG_DATABASE=off" \
 -e "KONG_DECLARATIVE_CONFIG=/usr/local/kong/declarative/kong.yml" \
 -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
 -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
 -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
 -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
 -p 8000:8000 \
 -p 8443:8443 \
 -p 127.0.0.1:8001:8001 \
 -p 127.0.0.1:8444:8444 \
 kong:latest
 ```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ start_container | indent | replace: " </code>", "</code>" }}

    Where:
    * `--name` and `--network`: The tag of the {{site.base_gateway}} image that
    you're using, and the Docker network it communicates on.
    * `-v kong-vol:/usr/local/kong/declarative`: The name of the Docker volume
    you created in a previous step mapped to the location of your declarative
    configuration file.
    * [`KONG_DATABASE`](/gateway/{{page.kong_version}}/reference/configuration/#database):
     Sets the database to `off` to tell Kong not to use any
    backing database for configuration storage.
    * [`KONG_DECLARATIVE_CONFIG`](/gateway/{{page.kong_version}}/reference/configuration/#declarative_config):
    The path to a declarative configuration file inside the container.
    This path should match the path that you're mapping with `-v`.
    * All [`_LOG`](/gateway/{{page.kong_version}}/reference/configuration/#general-section)
    parameters: set filepaths for the logs to output to, or use the values in
    the example to  print messages and errors to `stdout` and `stderr`.
    * [`KONG_ADMIN_LISTEN`](/gateway/{{page.kong_version}}/reference/configuration/#admin_listen):
    The port that the Kong Admin API listens on for requests.
    * [`KONG_ADMIN_GUI_URL`](/gateway/{{page.kong_version}}/reference/configuration/#admin_gui_url):
    (Enterprise only) The URL for accessing Kong Manager, preceded by a protocol
    (for example, `http://`).

1. Verify that {{site.base_gateway}} is running:

    ```sh
    curl -i http://localhost:8001
    ```

    Test an endpoint. For example, get a list of services:

    ```sh
    curl -i http://localhost:8001/services
    ```

[DB-less mode]: /gateway/{{page.kong_version}}/reference/db-less-and-declarative-config/
[Declarative Configuration format]: /gateway/{{page.kong_version}}/reference/db-less-and-declarative-config/#the-declarative-configuration-format
[Docker Volume]: https://docs.docker.com/storage/volumes/

## Troubleshooting

If you did not receive a `200 OK` status code or need assistance completing
setup, reach out to your support contact or head over to the
[Support Portal](https://support.konghq.com/support/s/).

## Next Steps

Check out {{site.base_gateway}}'s series of
[Getting Started](/gateway/{{page.kong_version}}/get-started/comprehensive/) guides to get the most
out of {{site.base_gateway}}.
