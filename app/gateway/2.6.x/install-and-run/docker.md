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

## Install Kong Gateway with a database

Set up a {{site.base_gateway}} container with a PostgreSQL database to store
Kong configuration.

### Pull and tag the Kong Gateway image

1. Pull the Docker image:

{% capture pull_image %}
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
{% endcapture %}
{{ pull_image | indent | replace: " </code>", "</code>" }}

   You should now have your {{site.base_gateway}} image locally.

2. Tag the image:

{% capture tag_image %}
{% navtabs codeblock %}
{% navtab Kong Gateway %}
<pre><code>docker tag kong/kong-gateway:{{page.kong_versions[page.version-index].ee-version}}-alpine <div contenteditable="true">{TAG_NAME}</div></code></pre>
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
<pre><code>docker tag kong:{{page.kong_versions[page.version-index].ce-version}}-alpine <div contenteditable="true">{TAG_NAME}</div></code></pre>
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ tag_image | indent | replace: " </code>", "</code>" }}

### Prepare the database

1. Create a custom Docker network to allow the containers to discover and communicate with each other:

   <pre><code>docker network create <div contenteditable="true">{NETWORK_NAME}</div></code></pre>

1. Start a PostgreSQL container:

   <pre><code>docker run -d --name <div contenteditable="true">{PG_CONTAINER_NAME}</div> \
     --network=<div contenteditable="true">{NETWORK_NAME}</div> \
     -p 5432:5432 \
     -e "POSTGRES_USER=<div contenteditable="true">{DATABASE_USER}</div>" \
     -e "POSTGRES_DB=<div contenteditable="true">{DATABASE_NAME}</div>" \
     -e "POSTGRES_PASSWORD=<div contenteditable="true">{DATABASE_PASSWORD}</div>" \
     postgres:9.6
   </code></pre>

1. Prepare the Kong database:
{% capture migrations %}
<pre><code>docker run --rm --network=<div contenteditable="true">{NETWORK_NAME}</div> \
 -e "KONG_DATABASE=postgres" \
 -e "KONG_PG_HOST=<div contenteditable="true">{PG_CONTAINER_NAME}</div>" \
 -e "KONG_PG_PASSWORD=<div contenteditable="true">{CONTAINER_PASSWORD}</div>" \
 -e "KONG_PASSWORD=<div contenteditable="true">{PASSWORD}</div>" \
 <div contenteditable="true">{TAG_NAME}</div> <div contenteditable="true">{DATABASE_NAME}</div> migrations bootstrap</code></pre>
{% endcapture %}
{{ migrations | indent | replace: " </code>", "</code>" }}

### Start Kong Gateway

{% include_cached /md/admin-listen.md desc='long' %}

1. Run the following command to start a container with {{site.base_gateway}}:
{% capture start_container %}
{% navtabs codeblock %}
{% navtab Kong Gateway %}
<div class="copy-code-snippet"><pre><code>docker run -d --name <div contenteditable="true">{GATEWAY_CONTAINER_NAME}</div> \
 --network=<div contenteditable="true">{NETWORK_NAME}</div> \
 -e "KONG_DATABASE=postgres" \
 -e "KONG_PG_HOST=<div contenteditable="true">{DATABASE_NAME}</div>" \
 -e "KONG_PG_USER=<div contenteditable="true">{PG_USER_NAME}</div>" \
 -e "KONG_PG_PASSWORD=<div contenteditable="true">{DATABASE_PASSWORD}</div>" \
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
 kong-ee</code></pre></div>
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
<div class="copy-code-snippet"><pre><code>docker run -d --name <div contenteditable="true">{GATEWAY_CONTAINER_NAME}</div> \
 --network=<div contenteditable="true">{NETWORK_NAME}</div> \
 -e "KONG_DATABASE=postgres" \
 -e "KONG_PG_HOST=<div contenteditable="true">{PG_HOST_NAME}</div>" \
 -e "KONG_PG_USER=<div contenteditable="true">{PG_USER_NAME}</div>" \
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
 kong:latest</code></pre></div>
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ start_container | indent | replace: " </code>", "</code>" }}

   {:.note}
   > **Note**: The `HOSTNAME` for `KONG_PORTAL_GUI_HOST` should be preceded by a protocol, for example, `http://`.

2. Verify your installation:

    Access the `/services` endpoint using the Admin API:

    <pre><code>curl -i -X GET --url http://<div contenteditable="true">{HOSTNAME}</div>:8001/services</code></pre>

    You should receive a `200` status code.

3. (Not available in OSS) Verify that Kong Manager is running by accessing it using the URL specified in `KONG_ADMIN_GUI_URL`:

      <pre><code>http://<div contenteditable="true">{HOSTNAME}</div>:8002</code></pre>

## Install Gateway in DB-less mode

{:.important}
> **Important**: Running {{site.base_gateway}} on Docker in DB-less mode is
supported for both Enterprise and OSS images. However, there's currently no
documentation for setting up an Enterprise image in DB-less mode, so adjust the
following steps as needed for an Enterprise deploy.

The steps involved in starting Kong in [DB-less mode](/gateway/{{page.kong_version}}/reference/db-less-and-declarative-config) are the following:

1. Create a Docker network:

    This is the same as in the Pg/Cassandra guide. We're also using `kong-net` as the
    network name and it can also be changed to something else.

    <pre><code>docker network create <div contenteditable="true">{NETWORK_NAME}</div></code></pre>

    This step is not strictly needed for running Kong in DB-less mode, but it's a good
    precaution in case you want to add other things in the future (like a rate-limiting plugin
    backed up by a Redis cluster).

2. Create a Docker volume:

    For the purposes of this guide, a [Docker Volume][Docker Volume] is a folder inside the host machine, which
    can be mapped into a folder in the container.

    <pre><code>docker volume create <div contenteditable="true">{DOCKER_VOLUME_NAME}</div></code></pre>

    You should be able to inspect the volume now:

    <pre><code>docker volume inspect <div contenteditable="true">{DOCKER_VOLUME_NAME}</div></code></pre>

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

3. Prepare your declarative configuration file:

    The syntax and properties are described on the [Declarative Configuration Format] guide.

    Add whatever core entities (Services, Routes, Plugins, Consumers, etc) you need there.

    On this guide we'll assume you named it `kong.yml`.

    Save it inside the `MountPoint` path mentioned in the previous step. In the case of this
    guide, that would be `/var/lib/docker/volumes/kong-vol/_data/kong.yml`

4. Run the following command to start a container with {{site.base_gateway}}.

   Although it's possible to start the Kong container with `KONG_DATABASE=off`, it is usually
   desirable to also include the declarative configuration file as a parameter via the
   `KONG_DECLARATIVE_CONFIG` variable name. To do this, we need to make the file
   "visible" from within the container. Use the `-v` flag, which maps
   the Docker volume to the `/usr/local/kong/declarative` folder in the container.

{% capture start_container %}
{% navtabs codeblock %}
{% navtab Kong Gateway %}
<div class="copy-code-snippet"><pre><code>docker run -d --name <div contenteditable="true">{GATEWAY_CONTAINER_NAME}</div> \
 --network=<div contenteditable="true">{NETWORK_NAME}</div> \
 -v "kong-vol:/usr/local/kong/declarative" \
 -e "KONG_DATABASE=off" \
 -e "KONG_DECLARATIVE_CONFIG=/usr/local/kong/declarative/kong.yml" \
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
 kong-ee</code></pre></div>
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
<div class="copy-code-snippet"><pre><code>docker run -d --name <div contenteditable="true">{GATEWAY_CONTAINER_NAME}</div> \
 --network=<div contenteditable="true">{NETWORK_NAME}</div> \
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
 kong:latest</code></pre></div>
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ start_container | indent | replace: " </code>", "</code>" }}

5. Verify that {{site.base_gateway}} is running:

    <pre><code>curl -i http://<div contenteditable="true">{HOSTNAME}</div>:8001</code></pre>

    For example, get a list of services:

    <pre><code>curl -i http://<div contenteditable="true">{HOSTNAME}</div>:8001/services</code></pre>

[DB-less mode]: /gateway/{{page.kong_version}}/reference/db-less-and-declarative-config/
[Declarative Configuration Format]: /gateway/{{page.kong_version}}/reference/db-less-and-declarative-config/#the-declarative-configuration-format
[Docker Volume]: https://docs.docker.com/storage/volumes/

## Troubleshooting

If you didn't get a `200 OK` status code or need help completing
setup, reach out to your support contact or head over to the
[Support Portal](https://support.konghq.com/support/s/).

## Next Steps

Check out {{site.base_gateway}}'s series of
[Getting Started](/gateway/{{page.kong_version}}/get-started/comprehensive/) guides to get the most
out of {{site.base_gateway}}.
