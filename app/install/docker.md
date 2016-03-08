---
id: page-install-method
title: Install - Docker
header_title: Docker Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

Details about how to use Kong in Docker can be found on the Dockerhub repo hosting the image: [mashape/kong](https://hub.docker.com/r/mashape/kong/).

Here is a quick example showing how to link a Kong container to a Cassandra or PostgreSQL container:

1. **Start your database:**

    If you wish to use a Cassandra container:

    ```bash
    $ docker run -d --name kong-datastore \
                 -p 9042:9042 \
                 cassandra:2.2.5
    ```

    If you wish to use a PostgreSQL container:

    ```bash
    $ docker run -d --name kong-datastore \
                 -p 5432:5432 \
                 -e POSTGRES_USER=kong \
                 postgres:9.4
    ```

2. **Start Kong:**

    Start a Kong container and link it to your database container:

    ```bash
    $ docker run -d --name kong \
                 --link kong-datastore:kong-datastore \
                 -p 8000:8000 \
                 -p 8443:8443 \
                 -p 8001:8001 \
                 -p 7946:7946 \
                 -p 7946:7946/udp \
                 --security-opt seccomp:unconfined \
                 mashape/kong
    ```

3. **Kong is running:**

    ```bash
    $ curl http://127.0.0.1:8001
    ```

4. **Start using Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/latest/getting-started/quickstart).
