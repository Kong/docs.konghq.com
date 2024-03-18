---
title: Build your own Docker images
content_type: how-to
---

Kong is distributed as prebuilt {% if_version lte:3.3.x %}`apk`, {% endif_version %}`deb` and `rpm` packages, in addition to official Docker images hosted on [DockerHub](https://hub.docker.com/r/kong)

Kong builds and verifies [Debian](#dockerhub-debian-link-here) and [RHEL](#dockerhub-rhel-link-here) images for use in production. {% if_version lte:3.3.x %}[Alpine](#dockerhub-alpine-link-here) images are provided for **development purposes only** as they contain development tooling such as `git` for plugin development purposes.{%- endif_version %}

The Debian and RHEL images are built with minimal dependencies (as of {{ site.base_gateway }} 3.0) and run through automated security scanners before being published. Any vulnerabilities detected in supported images will be addressed in the next available patch release.

If you would like to build your own images to further customise the base image and any dependencies, follow the instructions below:

1. Download [docker-entrypoint.sh](https://raw.githubusercontent.com/Kong/docker-kong/master/docker-entrypoint.sh) script from `docker-kong` and make it executable:
```bash
chmod +x docker-entrypoint.sh
```

1. Download the {{site.base_gateway}} package:
    * **Debian**: [.deb]({{ site.links.direct }}/gateway-{{ page.major_minor_version }}/deb/debian/pool/bullseye/main/k/ko/kong-enterprise-edition_{{page.versions.ee}}/kong-enterprise-edition_{{page.versions.ee}}_amd64.deb).
    {% if_version lte:3.0.x -%}
    * **Ubuntu**: [.deb]({{ site.links.direct }}/gateway-{{ page.major_minor_version }}/deb/ubuntu/pool/focal/main/k/ko/kong-enterprise-edition_{{page.versions.ee}}/kong-enterprise-edition_{{page.versions.ee}}_amd64.deb).
    {% endif_version -%}
    {% if_version gte:3.1.x -%}
    * **Ubuntu**: [.deb]({{ site.links.direct }}/gateway-{{ page.major_minor_version }}/deb/ubuntu/pool/jammy/main/k/ko/kong-enterprise-edition_{{page.versions.ee}}/kong-enterprise-edition_{{page.versions.ee}}_amd64.deb).
    {% endif_version -%}
    {%- comment -%}
    not all of the older alpine "packages" met Cloudsmith's definition for what an alpine package must be
    so some are uploaded there as "raw" artifacts instead and must be linked to differently
    this page doesn't exist for lte:2.8.x
    {%- endcomment -%}
    {% if_version lte:3.3.x -%}
    {% if_version eq:3.0.x -%}
    * **Alpine**: [.apk.tar.gz]({{ site.links.direct }}/gateway-{{ page.major_minor_version }}/raw/names/kong-enterprise-edition-x86_64/versions/{{page.versions.ee}}/kong-enterprise-edition-{{page.versions.ee}}.x86_64.apk.tar.gz)
    {% endif_version -%}
    {% if_version gte:3.1.x -%}
    * **Alpine**: [.apk]({{ site.links.direct }}/gateway-{{ page.major_minor_version }}/alpine/any-version/main/x86_64/kong-enterprise-edition-{{page.versions.ee}}.apk)
    {% endif_version -%}
    {% endif_version -%}
    * **RHEL**:[ .rpm]({{ site.links.direct }}/gateway-{{ page.major_minor_version }}/rpm/el/8/x86_64/kong-enterprise-edition-{{page.versions.ee}}.el8.x86_64.rpm)

1. Create a `Dockerfile`, ensuring you replace the filename by the first `COPY` with the name of the {{site.base_gateway}} file you downloaded in step 2:

{% capture dockerfile_run_steps %}COPY docker-entrypoint.sh /docker-entrypoint.sh

USER kong

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8000 8443 8001 8444 8002 8445 8003 8446 8004 8447

STOPSIGNAL SIGQUIT

HEALTHCHECK --interval=10s --timeout=10s --retries=10 CMD kong health

CMD ["kong", "docker-start"]{% endcapture %}

{% capture dockerfile %}
{% navtabs codeblock indent %}

{% navtab Debian %}
```dockerfile

FROM debian:bullseye-slim

COPY kong.deb /tmp/kong.deb

RUN set -ex; \
    apt-get update \
    && apt-get install --yes /tmp/kong.deb \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/kong.deb \
    && chown kong:0 /usr/local/bin/kong \
    && chown -R kong:0 /usr/local/kong \
    && ln -s /usr/local/openresty/luajit/bin/luajit /usr/local/bin/luajit \
    && ln -s /usr/local/openresty/luajit/bin/luajit /usr/local/bin/lua \
    && ln -s /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/nginx \
    && kong version

{{ dockerfile_run_steps }}
```
{% endnavtab %}

{% navtab Ubuntu %}
```dockerfile

{% if_version lte:3.0.x %}
FROM ubuntu:20.04
{% endif_version %}
{% if_version gte:3.1.x %}
FROM ubuntu:22.04
{% endif_version %}

COPY kong.deb /tmp/kong.deb

RUN set -ex; \
    apt-get update \
    && apt-get install --yes /tmp/kong.deb \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/kong.deb \
    && chown kong:0 /usr/local/bin/kong \
    && chown -R kong:0 /usr/local/kong \
    && ln -s /usr/local/openresty/luajit/bin/luajit /usr/local/bin/luajit \
    && ln -s /usr/local/openresty/luajit/bin/luajit /usr/local/bin/lua \
    && ln -s /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/nginx \
    && kong version

{{ dockerfile_run_steps }}
```
{% endnavtab %}

{% navtab RHEL %}
```dockerfile

FROM registry.access.redhat.com/ubi8/ubi:8.1

COPY kong.rpm /tmp/kong.rpm

RUN set -ex; \
    yum install -y /tmp/kong.rpm \
    && rm /tmp/kong.rpm \
    && chown kong:0 /usr/local/bin/kong \
    && chown -R kong:0 /usr/local/kong \
    && ln -s /usr/local/openresty/luajit/bin/luajit /usr/local/bin/luajit \
    && ln -s /usr/local/openresty/luajit/bin/luajit /usr/local/bin/lua \
    && ln -s /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/nginx \
    && kong version

{{ dockerfile_run_steps }}
```
{% endnavtab %}

{% if_version lte:3.3.x %}
{% navtab Alpine %}
```dockerfile

FROM alpine:latest

COPY kong.apk.tar.gz /tmp/kong.apk.tar.gz

RUN set -ex; \
    apk add --no-cache --virtual .build-deps tar gzip \
    && tar -C / -xzf /tmp/kong.apk.tar.gz \
    && apk add --no-cache libstdc++ libgcc openssl pcre perl tzdata libcap zlib zlib-dev bash curl ca-certificates \
    && adduser -S kong \
    && addgroup -S kong \
    && mkdir -p "/usr/local/kong" \
    && chown -R kong:0 /usr/local/kong \
    && chown kong:0 /usr/local/bin/kong \
    && chmod -R g=u /usr/local/kong \
    && rm -rf /tmp/kong.tar.gz \
    && ln -s /usr/local/openresty/luajit/bin/luajit /usr/local/bin/luajit \
    && ln -s /usr/local/openresty/luajit/bin/luajit /usr/local/bin/lua \
    && ln -s /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/nginx \
    && apk del .build-deps \
    && kong version

{{ dockerfile_run_steps }}
```
{% endnavtab %}
{% endif_version %}

{% endnavtabs %}
{% endcapture %}
{{ dockerfile | indent }}

1. Build your image:

    ```bash
    docker build --platform linux/amd64 --no-cache -t kong-image .
    ```

1. Test that the image built correctly:

    ```
    docker run -it --rm kong-image kong version
    ```

1. To run {{ site.base_gateway }} and process traffic, follow the [Docker install instructions](/gateway/latest/install/docker/), replacing the image name with your custom name.
