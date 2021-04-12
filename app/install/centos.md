---
id: page-install-method
title: Install - CentOS
header_title: CentOS Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

## Installation

1. **Installation**

    Kong can be installed by downloading an installation package or from our yum repository
    
    **Packages**
    
    - [CentOS 6]({{ site.links.download }}/gateway-community/centos/6/Packages/k/kong-{{site.data.kong_latest.version}}.el6.amd64.rpm)
    - [CentOS 7]({{ site.links.download }}/gateway-community/centos/7/Packages/k/kong-{{site.data.kong_latest.version}}.el7.amd64.rpm)
    - [CentOS 8]({{ site.links.download }}/gateway-community/centos/8/Packages/k/kong-{{site.data.kong_latest.version}}.el8.amd64.rpm)
    
    To install from the command line
    
    ```bash
    $ sudo yum install $(rpm --eval "{{ site.links.download }}/gateway-community/centos/%{centos_ver}/Packages/k/kong-{{site.data.kong_latest.version}}.el%{centos_ver}.amd64.rpm")
    ```
    
    **Enterprise trial users** should download their package from their welcome email and save their license to `/etc/kong/license.json` after step 1.
    
    **YUM Repositories**
    
    - [CentOS 6]({{ site.links.download }}/gateway-community/centos/6/)
    - [CentOS 7]({{ site.links.download }}/gateway-community/centos/7/)
    - [CentOS 8]({{ site.links.download }}/gateway-community/centos/8/)
    
    To install from the command line
    
    ```bash
    $ curl $(rpm --eval "{{ site.links.download }}/gateway-community/centos/%{centos_ver}/config.repo") | sudo tee /etc/yum.repos.d/kong.repo
    $ sudo yum info kong
    $ sudo yum install -y kong-{{site.data.kong_latest.version}}
    ```

## Setup

1. **Prepare your database or declarative configuration file**

    Kong can run either with or without a database.

    When using a database, you will use the `kong.conf` configuration file for setting Kong's
    configuration properties at start-up and the database as storage of all configured entities,
    such as the Routes and Services to which Kong proxies.

    When not using a database, you will use `kong.conf` its configuration properties and a `kong.yml`
    file for specifying the entities as a declarative configuration.

    **Using a database**

    [Configure][configuration] Kong so it can connect to your database. Kong supports both [PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/) and [Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/) as its datastore.

    If you are using PostgreSQL, please provision a database and a user, ie:

    ```sql
    CREATE USER kong; CREATE DATABASE kong OWNER kong;
    ```

    Now, run the Kong migrations:

    ```bash
    $ kong migrations bootstrap [-c /path/to/kong.conf]
    ```

    **Note for Kong < 0.15**: with Kong versions below 0.15 (up to 0.14), use
    the `up` sub-command instead of `bootstrap`. Also note that with Kong <
    0.15, migrations should never be run concurrently; only one Kong node
    should be performing migrations at a time. This limitation is lifted for
    Kong 0.15, 1.0, and above.

    **Without a database**

    If you are going to run Kong in [DB-less mode](/{{site.data.kong_latest.release}}/db-less-and-declarative-config/),
    you should start by generating declarative config file. The following command will generate a `kong.yml`
    file in your current folder. It contains instructions about how to fill it up.

    ``` bash
    $ kong config init
    ```

    After filling up the `kong.yml` file, edit your `kong.conf` file. Set the `database` option
    to `off` and the `declarative_config` option to the path of your `kong.yml` file:

    ``` conf
    database = off
    declarative_config = /path/to/kong.yml
    ```

## Run Kong

1. **Start Kong**

    {% include /md/ce-kong-user.md %}

    ```bash
    $ kong start [-c /path/to/kong.conf]
    ```

## Use Kong

1. **Use Kong**

    Kong is running

    ```bash
    $ curl -i http://localhost:8001/
    ```

    Quickly learn how to use Kong with the [5-minute Quickstart](/latest/getting-started/quickstart).

[configuration]: /{{site.data.kong_latest.release}}/configuration#database
