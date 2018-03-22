---
id: page-install-method
title: Install - Ubuntu
header_title: Ubuntu Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

### Packages

Start by downloading the corresponding package for your configuration:

- [12.04 Precise]({{ site.links.download }}/kong-community-edition-deb/download_file?file_path=dists/kong-community-edition-{{site.data.kong_latest.version}}.precise.all.deb)
- [14.04 Trusty]({{ site.links.download }}/kong-community-edition-deb/download_file?file_path=dists/kong-community-edition-{{site.data.kong_latest.version}}.trusty.all.deb)
- [16.04 Xenial]({{ site.links.download }}/kong-community-edition-deb/download_file?file_path=dists/kong-community-edition-{{site.data.kong_latest.version}}.xenial.all.deb)
- [17.04 Zesty]({{ site.links.download }}/kong-community-edition-deb/download_file?file_path=dists/kong-community-edition-{{site.data.kong_latest.version}}.zesty.all.deb)

**Enterprise trial users** should download their package from their welcome email and save their license to `/etc/kong/license.json` after step 1.

### APT Repositories

You can also install Kong via APT; follow the instructions on the "Set Me Up"
section on the page below, setting  *distribution* to the appropriate value
(e.g., `precise`) and *components* to `main`.

- [Deb Repository](https://bintray.com/kong/kong-community-edition-deb)

----

### Installation

1. **Install Kong**

    If you are downloading the [package](#packages), execute:

    ```bash
    $ sudo apt-get update
    $ sudo apt-get install openssl libpcre3 procps perl
    $ sudo dpkg -i kong-community-edition-{{site.data.kong_latest.version}}.*.deb
    ```

2. **Prepare your database**

    [Configure][configuration] Kong so it can connect to your database. Kong supports both [PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/) and [Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/) as its datastore.

    If you are using Postgres, please provision a database and a user before starting Kong, ie:

    ```sql
    CREATE USER kong; CREATE DATABASE kong OWNER kong;
    ```

    Now, run the Kong migrations:

    ```bash
    $ kong migrations up [-c /path/to/kong.conf]
    ```

    **Note**: migrations should never be run concurrently; only
    one Kong nodes should be performing migrations at a time.

3. **Start Kong**

    ```bash
    $ kong start [-c /path/to/kong.conf]
    ```

4. **Use Kong**

    Kong is running:

    ```bash
    $ curl -i http://localhost:8001/
    ```

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/latest/getting-started/quickstart).

[configuration]: /docs/{{site.data.kong_latest.release}}/configuration#database
