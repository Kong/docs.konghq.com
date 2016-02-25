---
id: page-install-method
title: Install - Docker
header_title: Docker Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

Details about how to use Kong in Docker can be found on the Dockerhub repo hosting the image: [mashape/kong](https://hub.docker.com/r/mashape/kong/).

Here is a quick setup linking Kong to a Cassandra container:

1. **Pull the offical images from the registry:**

    ```bash
    $ docker pull cassandra:2.2.5
    $ docker pull mashape/kong
    ```

2. **Start Cassandra:**

    ```bash
    $ docker run -p 9042:9042 -d --name cassandra cassandra:2.2.5
    ```

3. **Start Kong:**

    ```bash
    $ docker run -d --name kong \
                --link cassandra:cassandra \
                -p 8000:8000 \
                -p 8443:8443 \
                -p 8001:8001 \
                -p 7946:7946 \
                -p 7946:7946/udp \
                mashape/kong
    ```

4. **Kong is running:**

    ```bash
    $ curl http://127.0.0.1:8001
    ```

6. **Start using Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/latest/getting-started/quickstart).
