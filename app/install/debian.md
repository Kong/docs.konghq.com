---
id: page-install-method
title: Install - Debian
header_title: Debian Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

### Packages

Start by downloading the corresponding package for your configuration:

- [7 Wheezy]({{ site.links.download }}/kong-deb/download_file?file_path=kong-{{site.data.kong_latest.version}}.wheezy.all.deb)
- [8 Jessie]({{ site.links.download }}/kong-deb/download_file?file_path=kong-{{site.data.kong_latest.version}}.jessie.all.deb)
- [9 Stretch]({{ site.links.download }}/kong-deb/download_file?file_path=kong-{{site.data.kong_latest.version}}.stretch.all.deb)

**Enterprise trial users** should download their package from their welcome email and save their license to `/etc/kong/license.json` after step 1.

### APT Repositories

You can also install Kong via APT; follow the instructions on the "Set Me Up"
section on the page below, setting  *distribution* to the appropriate value
(e.g., `wheezy`) and *components* to `main`.

- [Deb Repository](https://bintray.com/kong/kong-deb)

----

### Installation

1. **Install Kong**

    If you are downloading the [package](#packages), execute:

    ```bash
    $ sudo apt-get update
    $ sudo apt-get install openssl libpcre3 procps perl
    $ sudo dpkg -i kong-{{site.data.kong_latest.version}}.*.deb
    ```
    
    If you are using the apt repository execute:
    ```bash
    $ sudo apt-get update
    $ sudo apt-get install -y apt-transport-https curl lsb-core
    $ echo "deb https://kong.bintray.com/kong-deb `lsb_release -sc` main" | sudo tee -a /etc/apt/sources.list
    $ curl -o bintray.key https://bintray.com/user/downloadSubjectPublicKey?username=bintray
    $ sudo apt-key add bintray.key
    $ sudo apt-get update
    $ sudo apt-get install -y kong
    ```

2. **Prepare your database**

    [Configure][configuration] Kong so it can connect to your database. Kong supports both [PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/) and [Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/) as its datastore.

    If you are using PostgreSQL, please provision a database and a user before starting Kong, ie:

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

3. **Start Kong**

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
