---
id: page-install-method
title: Install - Docker
header_title: Docker Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

Details about how to use Kong in Docker can be found on the DockerHub repository hosting the image: [kong](https://hub.docker.com/_/kong/). We also have a [Docker Compose template](https://github.com/Kong/docker-kong/tree/master/compose) with built-in orchestration and scalability.

Here is a quick example showing how to connect a Kong container to a Cassandra or PostgreSQL container:

1. **Create a Docker network**

    You will need to create a custom network to allow the containers to
    discover and communicate with each other. In this example `kong-net` is the
    network name, you can use any name.

    ```bash
    $ docker network create kong-net
    ```

2. **Start your database**

    If you wish to use a Cassandra container:

    ```bash
    $ docker run -d --name kong-database \
                  --network=kong-net \
                  -p 9042:9042 \
                  cassandra:3
    ```

    If you wish to use a PostgreSQL container:

    ```bash
    $ docker run -d --name kong-database \
                  --network=kong-net \
                  -p 5432:5432 \
                  -e "POSTGRES_USER=kong" \
                  -e "POSTGRES_DB=kong" \
                  postgres:9.6
    ```

3. **Prepare your database**

    Run the migrations with an ephemeral Kong container:

    ```bash
    $ docker run --rm \
        --network=kong-net \
        -e "KONG_DATABASE=postgres" \
        -e "KONG_PG_HOST=kong-database" \
        -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
        kong:latest kong migrations bootstrap
    ```

    In the above example, both Cassandra and PostgreSQL are configured, but you
    should update the `KONG_DATABASE` environment variable with either
    `cassandra` or `postgres`.

    **Note for Kong < 0.15**: with Kong versions below 0.15 (up to 0.14), use
    the `up` sub-command instead of `bootstrap`. Also note that with Kong <
    0.15, migrations should never be run concurrently; only one Kong node
    should be performing migrations at a time. This limitation is lifted for
    Kong 0.15, 1.0, and above.

4. **Start Kong**

    When the migrations have run and your database is ready, start a Kong
    container that will connect to your database container, just like the
    ephemeral migrations container:

    ```bash
    $ docker run -d --name kong \
        --network=kong-net \
        -e "KONG_DATABASE=postgres" \
        -e "KONG_PG_HOST=kong-database" \
        -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
        -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
        -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
        -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
        -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
        -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
        -p 8000:8000 \
        -p 8443:8443 \
        -p 8001:8001 \
        -p 8444:8444 \
        kong:latest
    ```

5. **Use Kong**

    Kong is running:

    ```bash
    $ curl -i http://localhost:8001/
    ```

    Quickly learn how to use Kong with the [5-minute Quickstart](/latest/getting-started/quickstart).
