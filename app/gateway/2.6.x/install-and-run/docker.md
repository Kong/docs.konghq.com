---
title: Install Kong Gateway on Docker
---

<!-- Banner with links to latest downloads -->
<!-- The install-link and install-listing-link classes are used for tracking, do not remove -->

{:.install-banner}
> See the list of Docker tags and pull the
> [**Kong Gateway Docker image**](https://hub.docker.com/r/kong/kong-gateway/tags){:.install-listing-link}
>
> (latest {{site.base_gateway}} version: {{site.data.kong_latest_ee.version}})

Details about how to use Kong in Docker can also be found on the DockerHub repository hosting the image: [kong](https://hub.docker.com/_/kong/). We also have a [Docker Compose template](https://github.com/Kong/docker-kong/tree/master/compose) with built-in orchestration and scalability.

{{site.base_gateway}} supports both PostgreSQL 9.5+ and Cassandra 3.11.* as its datastore. This guide provides steps to configure PostgreSQL.

This software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense/).

## Deployment options

The following instructions assume that you are deploying {{site.base_gateway}} in [classic embedded mode](/enterprise/{{include.kong_version}}/deployment/deployment-options).

If you want to run {{site.base_gateway}} in Hybrid mode, the instructions in this topic will walk you though setting up a Control Plane instance. Afterward, you will need to bring up additional gateway instances for the Data Planes, and perform further configuration steps. See [Hybrid Mode Setup](/enterprise/{{include.kong_version}}/deployment/hybrid-mode-setup) for details.

## Prerequisites

For this installation, you'll need a Docker-enabled system with proper Docker access.

## Install Gateway with a database

1. **Pull the Docker image**

   ```bash
   docker pull kong/kong-gateway:{{include.kong_versions[13].version}}-alpine
   ```

   {:.important}
   > Some [older {{site.base_gateway}} images](https://support.konghq.com/support/s/article/Downloading-older-Kong-versions)
   are not publicly accessible. If you need a specific patch version and can't
   find it on [Kong's public Docker Hub page](https://hub.docker.com/r/kong/kong-gateway), contact
   [Kong Support](https://support.konghq.com/).

   You should now have your {{site.base_gateway}} image locally.

2. **Tag the image**

   ```bash
   docker tag kong/kong-gateway:{{include.kong_versions[13].version}}-alpine kong
   ```

3. **Create a Docker network**

   Create a custom network to allow the containers to discover and communicate with each other.

   ```bash
   docker network create kong-net
   ```

4. **Start a database**

   Start a PostgreSQL container:

   ```p
   docker run -d --name kong-database \
     --network=kong-net \
     -p 5432:5432 \
     -e "POSTGRES_USER=kong" \
     -e "POSTGRES_DB=kong" \
     -e "POSTGRES_PASSWORD=kong" \
     postgres:9.6
   ```

5. **Prepare the Kong database**

   <pre><code>docker run --rm --network=kong-net \
     -e "KONG_DATABASE=postgres" \
     -e "KONG_PG_HOST=kong-ee-database" \
     -e "KONG_PG_PASSWORD=kong" \
     -e "KONG_PASSWORD=<div contenteditable="true">{PASSWORD}</div>" \
     kong kong migrations bootstrap</code></pre>

6. **Start Gateway with Kong Manager**

   <pre><code>docker run -d --name kong --network=kong-net \
     -e "KONG_DATABASE=postgres" \
     -e "KONG_PG_HOST=kong-database" \
     -e "KONG_PG_PASSWORD=kong" \
     -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
     -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
     -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
     -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
     -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
     -e "KONG_ADMIN_GUI_URL=http://<div contenteditable="true">{HOSTNAME}</div>:8002" \
       -p 8000:8000 \
       -p 8443:8443 \
       -p 8001:8001 \
       -p 8444:8444 \
       -p 8002:8002 \
       -p 8445:8445 \
       -p 8003:8003 \
       -p 8004:8004 \
       kong</code></pre>

   {:.note}
   > **Note**: The `HOSTNAME` for `KONG_PORTAL_GUI_HOST` should be preceded by a protocol, for example, `http://`.

7. **Verify your installation**

    Access the `/services` endpoint using the Admin API:

    <pre><code>curl -i -X GET --url http://<div contenteditable="true">{HOSTNAME}</div>:8001/services</code></pre>

    You should receive a `200` status code.

    Verify that Kong Manager is running by accessing it using the URL specified in `KONG_ADMIN_GUI_URL`:

    <pre><code>http://<div contenteditable="true">{HOSTNAME}</div>:8002</code></pre>

## Install Gateway in DB-less mode

The steps involved in starting Kong in [DB-less mode] are the following:

1. **Create a Docker network**

    This is the same as in the Pg/Cassandra guide. We're also using `kong-net` as the
    network name and it can also be changed to something else.

    ```bash
    docker network create kong-net
    ```

    This step is not strictly needed for running Kong in DB-less mode, but it is a good
    precaution in case you want to add other things in the future (like a rate-limiting plugin
    backed up by a Redis cluster).

2. **Create a Docker volume**

    For the purposes of this guide, a [Docker Volume] is a folder inside the host machine which
    can be mapped into a folder in the container. Volumes have a name. In this case we're going
    to name ours `kong-vol`

    ```bash
    docker volume create kong-vol
    ```

    You should be able to inspect the volume now:

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

    Notice the `MountPoint` entry. We will need that path in the next step.

3. **Prepare your declarative configuration file**

    The syntax and properties are described on the [Declarative Configuration Format] guide.

    Add whatever core entities (Services, Routes, Plugins, Consumers, etc) you need there.

    On this guide we'll assume you named it `kong.yml`.

    Save it inside the `MountPoint` path mentioned in the previous step. In the case of this
    guide, that would be `/var/lib/docker/volumes/kong-vol/_data/kong.yml`


4. **Start Kong in DB-less mode**

   Although it's possible to start the Kong container with just `KONG_DATABASE=off`, it is usually
   desirable to also include the declarative configuration file as a parameter via the
   `KONG_DECLARATIVE_CONFIG` variable name. In order to do this, we need to make the file
   "visible" from within the container. We achieve this with the `-v` flag, which maps
   the `kong-vol` volume to the `/usr/local/kong/declarative` folder in the container.

    ```bash
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

4. **Use Kong**

    Kong should be running and it should contain some of the entities added in kong.yml:

    ```bash
    curl -i http://localhost:8001/
    ```

    For example, get a list of services:

    ```bash
    curl -i http://localhost:8001/services
    ```

[DB-less mode]: /gateway-oss/latest/db-less-and-declarative-config/
[Declarative Configuration Format]: /gateway-oss/latest/db-less-and-declarative-config/#the-declarative-configuration-format
[Docker Volume]: https://docs.docker.com/storage/volumes/

## Troubleshooting

If you did not receive a `200 OK` status code or need assistance completing
setup, reach out to your support contact or head over to the
[Support Portal](https://support.konghq.com/support/s/).

## Next Steps

Check out {{site.base_gateway}}'s series of
[Getting Started](/getting-started-guide/latest/overview) guides to get the most
out of {{site.base_gateway}}.

If you have an Enterprise subscription, add the license using the
[`/licenses` Admin API endpoint](/enterprise/{{page.kong_version}}/deployment/licenses/deploy-license).
