---
id: page-install-method
title: Install - CentOS
header_title: CentOS Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

### Packages

Start by downloading the corresponding package for your configuration:

- [CentOS 6]({{ site.links.download }}/{{site.data.kong_latest.version}}/kong-{{site.data.kong_latest.version}}.el6.noarch.rpm)
- [CentOS 7]({{ site.links.download }}/{{site.data.kong_latest.version}}/kong-{{site.data.kong_latest.version}}.el7.noarch.rpm)

### YUM Repositories

You can also install Kong by using the following YUM repositories and following the Bintray instructions:

- [CentOS 6 YUM](https://bintray.com/mashape/kong-rpm-el6-{{site.data.kong_latest.release}})
- [CentOS 7 YUM](https://bintray.com/mashape/kong-rpm-el7-{{site.data.kong_latest.release}})

----

### Installation

1. **Install Kong**

    If you are downloading the [package](#packages), execute:

    ```bash
    $ sudo yum install epel-release
    $ sudo yum install kong-{{site.data.kong_latest.version}}.*.noarch.rpm --nogpgcheck
    ```

2. **Prepare your database**

    [Configure][configuration] Kong so it can connect to your database. Kong supports both [PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/) and [Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/) as its datastore.

    If you are using PostgreSQL, please provision a database and a user, ie:

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
