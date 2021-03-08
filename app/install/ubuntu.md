---
id: page-install-method
title: Install - Ubuntu
header_title: Ubuntu Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

## Packages

Start by downloading the corresponding package for your configuration:

- [16.04 Xenial]({{ site.links.download }}/kong-deb/download_file?file_path=kong-{{site.data.kong_latest.version}}.xenial.amd64.deb)
- [18.04 Bionic]({{ site.links.download }}/kong-deb/download_file?file_path=kong-{{site.data.kong_latest.version}}.bionic.amd64.deb)
- [20.04 Focal]({{ site.links.download }}/kong-deb/download_file?file_path=kong-{{site.data.kong_latest.version}}.focal.amd64.deb)

**Enterprise trial users** should download their package from their welcome email and save their license to `/etc/kong/license.json` after step 1.

## APT Repositories

You can also install Kong via APT; follow the instructions on the "Set Me Up"
section on the page below, setting  *distribution* to the appropriate value ( lsb_release -sc )
(e.g., `precise`) and *components* to `main`.

- [Deb Repository]({{ site.links.download }}/kong-deb)

----

## Installation

1. **Install Kong**

    If you are downloading the [package](#packages), execute:

    ```bash
    $ sudo apt-get update
    $ sudo apt-get install /absolute/path/to/package.deb
    ```

    If you are using the apt repository execute:
    ```bash
    $ sudo apt-get update
    $ sudo apt-get install -y apt-transport-https curl lsb-core
    $ echo "deb {{ site.links.download }}/kong-deb `lsb_release -sc` main" | sudo tee -a /etc/apt/sources.list
    $ curl -o bintray.key https://bintray.com/user/downloadSubjectPublicKey?username=bintray
    $ sudo apt-key add bintray.key
    $ sudo apt-get update
    $ sudo apt-get install -y kong
    ```

2. **Prepare your database or declarative configuration file**

    Kong can run either with or without a database.

    When using a database, you will use the `kong.conf` configuration file for setting Kong's
    configuration properties at start-up and the database as storage of all configured entities,
    such as the Routes and Services to which Kong proxies.

    When not using a database, you will use `kong.conf` its configuration properties and a `kong.yml`
    file for specifying the entities as a declarative configuration.

    **Using a database**

    [Configure][configuration] Kong so it can connect to your database. Kong supports both [PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/) and [Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/) as its datastore.

    If you are using Postgres, please provision a database and a user before starting Kong, ie:

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

3. **Start Kong**

    {% include /md/ce-kong-user.md %}

    ```bash
    $ kong start [-c /path/to/kong.conf]
    ```

4. **Use Kong**

    Kong is running:

    ```bash
    $ curl -i http://localhost:8001/
    ```

    Quickly learn how to use Kong with the [5-minute Quickstart](/latest/getting-started/quickstart).

[configuration]: /{{site.data.kong_latest.release}}/configuration#database
