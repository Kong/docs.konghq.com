---
title: Build your own Docker images
---

Kong is distributed as prebuilt `apk`, `deb` and `rpm` packages, in addition to official Docker images hosted on [DockerHub](https://hub.docker.com/r/kong)

Kong builds and verifies [Debian](#dockerhub-debian-link-here) and [RHEL](#dockerhub-rhel-link-here) images for use in production. [Alpine](#dockerhub-alpine-link-here) images are provided for **development purposes only**.

Our Debian and RHEL images are built with minimal dependencies (as of {{ site.base_gateway }} 3.0) and run through automated security scanners before being published. Any vulnerabilities detected in supported images will be addressed in the next available patch release.

If you would like to build your own images to further customise the base image and any dependencies, follow the instructions below:

1. Download the [docker-entrypoint.sh](https://raw.githubusercontent.com/Kong/docker-kong/master/docker-entrypoint.sh) script from `docker-kong` and make it executable with `chmod +x docker-entrypoint.sh`

1. Download the [.deb]({{ site.links.download }}/gateway-2.x-ubuntu-focal/pool/all/k/kong-enterprise-edition/kong-enterprise-edition_{{ page.kong_versions[page.version-index].ee-version }}_all.deb), [.rpm]({{ site.links.download }}/gateway-2.x-rhel-8/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.rhel8.noarch.rpm) or [.apk]({{ site.links.download }}/gateway-2.x-alpine/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.apk.tar.gz) as required 

1. Create a `Dockerfile` with the following contents:

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
    apt-get update; \
    apt-get update \
    && apt-get install --yes /tmp/kong.deb \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/kong.deb \
    && chown kong:0 /usr/local/bin/kong \
    && chown -R kong:0 /usr/local/kong \
    && ln -s /usr/local/openresty/bin/resty /usr/local/bin/resty \
    && ln -s /usr/local/openresty/luajit/bin/luajit /usr/local/bin/luajit \
    && ln -s /usr/local/openresty/luajit/bin/luajit /usr/local/bin/lua \
    && ln -s /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/nginx \
    && kong version

{{ dockerfile_run_steps }}
```
{% endnavtab %}

{% navtab Ubuntu %}
```dockerfile

FROM ubuntu:20.04

COPY kong.deb /tmp/kong.deb

RUN set -ex; \
    apt-get update; \
    apt-get update \
    && apt-get install --yes /tmp/kong.deb \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/kong.deb \
    && chown kong:0 /usr/local/bin/kong \
    && chown -R kong:0 /usr/local/kong \
    && ln -s /usr/local/openresty/bin/resty /usr/local/bin/resty \
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
    && ln -s /usr/local/openresty/bin/resty /usr/local/bin/resty \
    && ln -s /usr/local/openresty/luajit/bin/luajit /usr/local/bin/luajit \
    && ln -s /usr/local/openresty/luajit/bin/luajit /usr/local/bin/lua \
    && ln -s /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/nginx \
    && kong version

{{ dockerfile_run_steps }}
```
{% endnavtab %}

{% navtab Alpine %}
```dockerfile

FROM alpine:latest

COPY kong.apk.tar.gz /tmp/kong.apk.tar.gz

RUN set -ex; \
    apk add bash curl ca-certificates; \
    arch="$(apk --print-arch)"; \
    case "${arch}" in \
      x86_64) export ARCH='amd64'; KONG_SHA256=$KONG_AMD64_SHA ;; \
      aarch64) export ARCH='arm64'; KONG_SHA256=$KONG_ARM64_SHA ;; \
    esac; \
    apk add --no-cache --virtual .build-deps tar gzip \
    && tar -C / -xzf /tmp/kong.apk.tar.gz \
    && apk add --no-cache libstdc++ libgcc openssl pcre perl tzdata libcap zlib zlib-dev bash \
    && adduser -S kong \
    && addgroup -S kong \
    && mkdir -p "/usr/local/kong" \
    && chown -R kong:0 /usr/local/kong \
    && chown kong:0 /usr/local/bin/kong \
    && chmod -R g=u /usr/local/kong \
    && rm -rf /tmp/kong.tar.gz \
    && ln -s /usr/local/openresty/bin/resty /usr/local/bin/resty \
    && ln -s /usr/local/openresty/luajit/bin/luajit /usr/local/bin/luajit \
    && ln -s /usr/local/openresty/luajit/bin/luajit /usr/local/bin/lua \
    && ln -s /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/nginx \
    && apk del .build-deps \
    && kong version

{{ dockerfile_run_steps }}
```
{% endnavtab %}

{% endnavtabs %}
{% endcapture %}
{{ dockerfile | indent }}

1. Build your image with `docker build --no-cache -t kong-your-tag .`

1. Test that the image built correctly with `docker run -it kong-your-tag kong version`

1. To run {{ site.base_gateway }} and process traffic, follow the [Docker install instructions](/gateway/latest/kong-production/install-options/docker/), replacing the image name with your custom name
