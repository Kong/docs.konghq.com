---
id: page-install-method
title: Install - Docker
header_title: Docker Compose Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---


The Kong docker-compose yaml is a subdirectory on the [https://github.com/Kong/docker-kong](https://github.com/Kong/docker-kong/blob/master/compose/docker-compose.yml)
repository. Kong releases include a corresponding repository tag so replace `master` with the specific version of Kong one wants to use. The Kong docker-compose.yml
uses [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) docker container as a proxy in a production setup one likely would replace that with a load
balancer of their choosing such as a ALB or ELB if using AWS.

The Kong docker-compose yaml Kong can be provisioned via docker-compose using the following steps:


1. **Run the docker-compose**

    Presumes one already has cloned the [https://github.com/Kong/docker-kong](https://github.com/Kong/docker-kong/blob/master/compose/docker-compose.yml)
    repository.
    
    ```bash
    cd docker-kong
    git checkout {{site.data.kong_latest.version}} # OPTIONAL if one just wants latest
    export KONG_DOCKER_TAG=kong:{{site.data.kong_latest.version}} # OPTIONAL if one just wants latest
    cd compose
    docker-compose up -d
    ```

2. **Use Kong**

    Kong is running:

    ```bash
    $ curl -i http://localhost:8001/
    ```

    Quickly learn how to use Kong with the [5-minute Quickstart](/latest/getting-started/quickstart).
