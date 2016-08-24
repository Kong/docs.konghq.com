---
id: page-install-method
title: Install - Docker
header_title: Docker Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

Details about how to use Kong in Docker can be found on the Dockerhub repo hosting the image: [mashape/kong](https://hub.docker.com/r/mashape/kong/). We also have a [Docker Compose template](https://github.com/Mashape/docker-kong/tree/master/compose) with built-in orchestration and scalability.

Here is a quick example showing how to link a Kong container to a Cassandra or PostgreSQL container:

1. **Start your database:**

    If you wish to use a Cassandra container:

    ```bash
    $ docker run -d --name kong-database \
                  -p 9042:9042 \
                  cassandra:2.2
    ```

    If you wish to use a PostgreSQL container:

    ```bash
    $ docker run -d --name kong-database \
                  -p 5432:5432 \
                  -e "POSTGRES_USER=kong" \
                  -e "POSTGRES_DB=kong" \
                  postgres:9.4
    ```

2. **Start Kong:**

    Start a Kong container and link it to your database container, configuring the `KONG_DATABASE` environment variable with either `cassandra` or `postgres` depending on which database you decided to use:

    ```bash
    $ docker run -d --name kong \
                  --link kong-database:kong-database \
                  -e "KONG_DATABASE=cassandra" \
                  -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
                  -e "KONG_PG_HOST=kong-database" \
                  -p 8000:8000 \
                  -p 8443:8443 \
                  -p 8001:8001 \
                  -p 7946:7946 \
                  -p 7946:7946/udp \
                  mashape/kong
    ```

3. **Kong is running:**

    ```bash
    $ curl http://127.0.0.1:8001
    ```

4. **Start using Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/latest/getting-started/quickstart).

<div class="alert alert-warning">
  <strong>Note:</strong> If Docker complains that <code>--security-opt</code> is an invalid option, just remove it and re-execute the command (it was introduced in Docker 1.3).
</div>
