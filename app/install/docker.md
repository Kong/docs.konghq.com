---
id: page-install-method
title: Install - Docker
header_title: Docker Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

Details about how to use Kong in Docker can be found on the Dockerhub repo hosting the image: [kong](https://hub.docker.com/_/kong/). We also have a [Docker Compose template](https://github.com/Mashape/docker-kong/tree/master/compose) with built-in orchestration and scalability.

Here is a quick example showing how to link a Kong container to a Cassandra or PostgreSQL container:

1. **Start your database**

    If you wish to use a Cassandra container:

    ```bash
    $ docker run -d --name kong-database \
                  -p 9042:9042 \
                  cassandra:3
    ```

    If you wish to use a PostgreSQL container:

    ```bash
    $ docker run -d --name kong-database \
                  -p 5432:5432 \
                  -e "POSTGRES_USER=kong" \
                  -e "POSTGRES_DB=kong" \
                  postgres:9.4
    ```

2. **Prepare your database**

    Run the migrations with an ephemeral Kong container:

    ```bash
    $ docker run -it --rm \
        --link kong-database:kong-database \
        -e "KONG_DATABASE=postgres" \
        -e "KONG_PG_HOST=kong-database" \
        -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
        kong:latest kong migrations up
    ```

    In the above example, both Cassandra and PostgreSQL are configured, but you
    should update the `KONG_DATABASE` environment variable with either
    `cassandra` or `postgres`.

    **Note**: migrations should never be run concurrently; only
    one Kong nodes should be performing migrations at a time.

3. **Start Kong**

    When the migrations have run and your database is ready, start a Kong
    container and link it to your database container, just like the ephemeral
    migrations container:

    ```bash
    $ docker run -d --name kong \
        --link kong-database:kong-database \
        -e "KONG_DATABASE=postgres" \
        -e "KONG_PG_HOST=kong-database" \
        -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
        -p 8000:8000 \
        -p 8443:8443 \
        -p 8001:8001 \
        -p 8444:8444 \
        kong:latest
    ```

4. **Use Kong**

    Kong is running:

    ```bash
    $ curl -i http://localhost:8001/
    ```

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/latest/getting-started/quickstart).
