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

- [CentOS 6]({{ site.links.download }}/kong-community-edition-rpm/download_file?file_path=centos/6/kong-community-edition-{{site.data.kong_latest.version}}.el6.noarch.rpm)
- [CentOS 7]({{ site.links.download }}/kong-community-edition-rpm/download_file?file_path=centos/7/kong-community-edition-{{site.data.kong_latest.version}}.el7.noarch.rpm)

**Enterprise trial users** should download their package from their welcome email and save their license to `/etc/kong/license.json` after step 1.

### YUM Repositories

You can also install Kong via YUM; follow the instructions on the "Set Me Up"
section on the page below.

- [RPM Repository](https://bintray.com/kong/kong-community-edition-rpm)

**NOTE**: ensure that the `baseurl` field of the generated `.repo` file contains
your CentOS version; for instance:

```
baseurl=https://kong.bintray.com/kong-community-edition-rpm/centos/6
```
or

```
baseurl=https://kong.bintray.com/kong-community-edition-rpm/centos/7
```

----

### Installation

1. **Install Kong**

    If you are downloading the [package](#packages), execute:

    ```bash
    $ sudo yum install epel-release
    $ sudo yum install kong-community-edition-{{site.data.kong_latest.version}}.*.noarch.rpm --nogpgcheck
    ```

2. **Prepare your database**

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
