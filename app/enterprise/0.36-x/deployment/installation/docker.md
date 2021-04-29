---
title: Install Kong Enterprise with Docker
---

## Introduction

This guide walks through downloading, installing, and starting Kong Enterprise
using Docker. The configuration shown in this guide is intended only as an
example. You will want to modify and take additional measures to secure your
Kong Enterprise system before moving to a production environment.

## Prerequisites

To complete this guide you will need:

- Docker
{% include /md/enterprise/license.md license='prereq' %}

## Step 1. Download Kong Enterprise

{% include /md/enterprise/install.md install='docker' %}

5. Create a Docker network (_optional_)

    Containers require a network in order to discover and communicate with each other.
    To use this functionality create a network using the following command,
    replacing kong-ee-net with the name of your network:

    ```
    $ docker network create kong-ee-net
    ```

## Step 2. Export your Kong Enterprise License

{% include /md/enterprise/license.md license='<1.3' %}

1. Download your license file.

2. Copy the license data in its entirety and export it as a shell variable:

    ```sh
    export KONG_LICENSE_DATA='{"license":{"signature":"LS0tLS1CRUdJTiBQR1AgTUVTU0FHRS0tLS0tClZlcnNpb246IEdudVBHIHYyCgpvd0did012TXdDSFdzMTVuUWw3dHhLK01wOTJTR0tLWVc3UU16WTBTVTVNc2toSVREWk1OTFEzVExJek1MY3dTCjA0ek1UVk1OREEwc2pRM04wOHpNalZKVHpOTE1EWk9TVTFLTXpRMVRVNHpTRXMzTjA0d056VXdUTytKWUdNUTQKR05oWW1VQ21NWEJ4Q3NDc3lMQmorTVBmOFhyWmZkNkNqVnJidmkyLzZ6THhzcitBclZtcFZWdnN1K1NiKzFhbgozcjNCeUxCZzdZOVdFL2FYQXJ0NG5lcmVpa2tZS1ozMlNlbGQvMm5iYkRzcmdlWFQzek1BQUE9PQo9b1VnSgotLS0tLUVORCBQR1AgTUVTU0FHRS0tLS0tCg=","payload":{"customer":"Test Company Inc","license_creation_date":"2017-11-08","product_subscription":"Kong Enterprise","admin_seats":"5","support_plan":"None","license_expiration_date":"2017-11-10","license_key":"00141000017ODj3AAG_a1V41000004wT0OEAU"},"version":1}}'
    ```


## Step 3. Configure the Database

Kong Enterprise requires a database and supports either Cassandra or PostgreSQL.

1. Instantiate a database:

    If you are using Cassandra:

    ```bash
    $ docker run -d --name kong-ee-database \
        --network=kong-ee-net \
        - p 9042:9042 \
        cassandra:3
    ```

    If you are using PostgreSQL:

    ```bash
    $ docker run -d --name kong-ee-database \
        --network=kong-ee-net \
        -p 5432:5432 \
        -e "POSTGRES_USER=kong" \
        -e "POSTGRES_DB=kong" \
        -e "POSTGRES_PASSWORD=kong" \
        -e "POSTGRES_HOST_AUTH_METHOD=trust" \
        postgres:9.6
    ```

2. Run Kong migrations:

   Cassandra:

   ```bash
    $ docker run --rm --network=kong-ee-net \
      -e "KONG_DATABASE=cassandra" \
      -e "KONG_PG_HOST=kong-ee-database" \
      -e "KONG_CASSANDRA_CONTACT_POINTS=kong-ee-database" \
      -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" \
      kong-ee kong migrations bootstrap
    ```

    PostgreSQL:

    ```bash
    $ docker run --rm --network=kong-ee-net \
      -e "KONG_DATABASE=postgres" \
      -e "KONG_PG_HOST=kong-ee-database" \
      -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" \
      kong-ee kong migrations bootstrap
    ```

    **Docker on Windows users:** Instead of the `KONG_LICENSE_DATA` environment
    variable, use the [volume bind](https://docs.docker.com/engine/reference/commandline/run/#options) option.
    For example, assuming you've saved your `license.json` file into `C:\temp`,
    use `--volume /c/temp/license.json:/etc/kong/license.json` to specify the
    license file.


## Step 5. Configure and Start Kong Enterprise

1. Configure and Start Kong Enterprise:

    Cassandra:

    ```bash
    $ docker run -d --name kong-ee --network=kong-ee-net \
        -e "KONG_DATABASE=cassandra" \
        -e "KONG_PG_HOST=kong-ee-database" \
        -e "KONG_CASSANDRA_CONTACT_POINTS=kong-ee-database" \
        -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
        -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
        -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
        -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
        -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
        -e "KONG_PORTAL=on" \
        -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" \
        -p 8000:8000 \
        -p 8443:8443 \
        -p 8001:8001 \
        -p 8444:8444 \
        -p 8002:8002 \
        -p 8445:8445 \
        -p 8003:8003 \
        -p 8004:8004 \
        kong-ee
    ```

    PostgreSQL:

    ```bash
    $ docker run -d --name kong-ee --network=kong-ee-net \
        -e "KONG_DATABASE=postgres" \
        -e "KONG_PG_HOST=kong-ee-database" \
        -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
        -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
        -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
        -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
        -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
        -e "KONG_PORTAL=on" \
        -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" \
        -p 8000:8000 \
        -p 8443:8443 \
        -p 8001:8001 \
        -p 8444:8444 \
        -p 8002:8002 \
        -p 8445:8445 \
        -p 8003:8003 \
        -p 8004:8004 \
        kong-ee
    ```

    **Docker on Windows users:** Instead of the `KONG_LICENSE_DATA` environment
    variable, use the [volume bind](https://docs.docker.com/engine/reference/commandline/run/#options) option.
    For example, assuming you've saved your `license.json` file into `C:\temp`,
    use `--volume /c/temp/license.json:/etc/kong/license.json` to specify the
    license file.

2. Test that Kong Enterprise is running:

    Visit the Kong Manager at [http://localhost:8002](http://localhost:8002)
    (replace `localhost` with your server IP or hostname when running Kong on a
    remote system).



## Troubleshooting

The Admin API only listens on the local interface by default. This was done as a
security enhancement. Note that we are overriding that in the above example with
`KONG_ADMIN_LISTEN=0.0.0.0:8001` because Docker container networking benefits from
more open settings and enables Kong Manager and Dev Portal to talk with the Kong
Admin API.

Without a license properly referenced, you’ll get errors running migrations:

    $ docker run -ti --rm ... kong migrations bootstrap
    nginx: [alert] Error validating Kong license: license path environment variable not set

Also, without a license, you will get no output if you do a `docker run` in
"daemon mode"—the `-d` flag to `docker run`:


    $ docker run -d ... kong start
    26a995171e23e37f89a4263a10bb084120ab0dbed1aa11a71c888c8e0d74a0b6


When you check the container, it won’t be running. Doing a `docker logs` will
show you:


    $ docker logs <container name>
    nginx: [alert] Error validating Kong license: license path environment variable not set


As awareness, another error that can occur due to the vagaries of the interactions
between text editors and copy & paste changing straight quotes (" or ') into curly
ones (“ or ” or ’ or ‘) is:

​```
nginx: [alert] Error validating Kong license: could not decode license json
​```

Your license data must contain only straight quotes to be considered valid JSON.
