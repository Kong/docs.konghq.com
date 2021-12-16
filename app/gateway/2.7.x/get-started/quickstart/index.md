---
title: Start Kong Gateway
---

In this section, you'll learn how to install and manage your Kong Gateway instance. First, you'll start Kong Gateway to gain access to its Admin
API, where you'll manage entities including Services, Routes, and Consumers.

## Start Kong Gateway using Docker with a database

One quick way to get Kong Gateway up and running is by using [Docker with a PostgreSQL database](/gateway/{{page.kong_version}}/install-and-run/docker). We recommend this method to test out basic Kong Gateway functionality.

For a comprehensive list of installation options, see our [Install page](/gateway/{{page.kong_version}}/install-and-run/).

1. Create a Docker network:

   ```bash
   docker network create kong-net
   ```

2. Run a PostGreSQL container:

   ```bash
   docker run -d --name kong-database \
     --network=kong-net \
     -p 5432:5432 \
     -e "POSTGRES_USER=kong" \
     -e "POSTGRES_DB=kong" \
     -e "POSTGRES_PASSWORD=kong" \
     postgres:9.6
   ```


{% include_cached /md/enterprise/cassandra-deprecation.md %}


   Data sent through the Admin API is stored in Kong's [datastore][datastore-section] (Kong
   supports PostgreSQL and Cassandra).

3. Prep your database:

   ```bash
   docker run --rm \
     --network=kong-net \
     -e "KONG_DATABASE=postgres" \
     -e "KONG_PG_HOST=kong-database" \
     -e "KONG_PG_USER=kong" \
     -e "KONG_PG_PASSWORD=kong" \
     -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
     kong:latest kong migrations bootstrap
   ```

4. Start Kong:

   ```bash
   docker run -d --name kong \
        --network=kong-net \
        -e "KONG_DATABASE=postgres" \
        -e "KONG_PG_HOST=kong-database" \
        -e "KONG_PG_USER=kong" \
        -e "KONG_PG_PASSWORD=kong" \
        -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
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

5. Navigate to `http://localhost:8001/`.

## Kong default ports

By default, Kong listens on the following ports:

- `8000`: listens for incoming `HTTP` traffic from your
  clients, and forwards it to your upstream services.
- `8001`: [Admin API][API] listens for calls from the command line over `HTTP`.
- `8443`: listens for incoming HTTPS traffic. This port has a
  similar behavior to `8000`, except that it expects `HTTPS`
  traffic only. This port can be disabled via the configuration file.
- `8444`: [Admin API][API] listens for `HTTPS` traffic.

## Lifecycle commands

{:.note}
> **Note**: If you are using Docker, [`exec`](https://docs.docker.com/engine/reference/commandline/exec) into the Docker container to use these commands.

Stop Kong Gateway using the [stop][CLI] command:

```bash
kong stop
```

Reload Kong Gateway using the [reload][CLI] command:

```bash
kong reload
```

Start Kong Gateway using the [start][CLI] command:

```bash
kong start
```

## Next Steps

Now that you have Kong Gateway running, you can interact with the Admin API.

To begin, go to [Configuring a Service &rsaquo;][configuring-a-service]

[configuration-loading]: /gateway/{{page.kong_version}}/reference/configuration/#configuration-loading
[CLI]: /gateway/{{page.kong_version}}/reference/cli
[API]: /gateway/{{page.kong_version}}/admin-api
[datastore-section]: /gateway/{{page.kong_version}}/reference/configuration/#datastore-section
[configuring-a-service]: /gateway/{{page.kong_version}}/get-started/quickstart/configuring-a-service
