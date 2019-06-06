---
id: page-install-method
title: Install - Red Hat
header_title: Red Hat Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

{% capture cassandra_version %}{{site.data.kong_latest.dependencies.cassandra}}{% endcapture %}

### Packages

Start by downloading the corresponding package for your configuration:

- [RHEL 6]({{ site.links.download }}/kong-rpm/download_file?file_path=rhel/6/kong-{{site.data.kong_latest.version}}.rhel6.noarch.rpm)
- [RHEL 7]({{ site.links.download }}/kong-rpm/download_file?file_path=rhel/7/kong-{{site.data.kong_latest.version}}.rhel7.noarch.rpm)

**Enterprise trial users** should download their package from their welcome email and save their license to `/etc/kong/license.json` after step 1.

### YUM Repositories

You can also install Kong via YUM; follow the instructions on the "Set Me Up"
section on the page below.

- [RPM Repository](https://bintray.com/kong/kong-rpm)

**NOTE**: ensure that the `baseurl` field of the generated `.repo` file contains
your RHEL version; for instance:

```
baseurl=https://kong.bintray.com/kong-rpm/rhel/6
```
or

```
baseurl=https://kong.bintray.com/kong-rpm/rhel/7
```

----

### Installation

1. **Enable the EPEL repository**

    Before installing Kong, you need to install the `epel-release` package for right version of your operating system, so that Kong can fetch all the required dependencies:

    ```bash
    $ EL_VERSION=`cat /etc/redhat-release | grep -oE '[0-9]+\.[0-9]+'` && \
      sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-${EL_VERSION%.*}.noarch.rpm
    ```

2. **Install Kong**

    If you are downloading the [package](#packages), execute:

    ```bash
    $ sudo yum install kong-{{site.data.kong_latest.version}}.*.noarch.rpm --nogpgcheck
    ```

    If you are using the repository, execute:
    ```bash
    $ sudo yum install -y wget
    $ wget https://bintray.com/kong/kong-rpm/rpm -O bintray-kong-kong-rpm.repo
    $ export major_version=`grep -oE '[0-9]+\.[0-9]+' /etc/redhat-release | cut -d "." -f1`
    $ sed -i -e 's/baseurl.*/&\/rhel\/'$major_version''/ bintray-kong-kong-rpm.repo
    $ sudo mv bintray-kong-kong-rpm.repo /etc/yum.repos.d/
    $ sudo yum update -y
    $ sudo yum install -y kong
    ```

3. **Prepare your database or declarative configuration file**

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

4. **Start Kong**

    ```bash
    $ kong start [-c /path/to/kong.conf]
    ```

5. **Use Kong**

    Kong is running:

    ```bash
    $ curl -i http://localhost:8001/
    ```

    Quickly learn how to use Kong with the [5-minute Quickstart](/latest/getting-started/quickstart).

[configuration]: /{{site.data.kong_latest.release}}/configuration#database
