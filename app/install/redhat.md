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

- [RHEL 6]({{ site.links.download }}/kong-community-edition-rpm/download_file?file_path=centos/6/kong-community-edition-{{site.data.kong_latest.version}}.el6.noarch.rpm)
- [RHEL 7]({{ site.links.download }}/kong-community-edition-rpm/download_file?file_path=centos/7/kong-community-edition-{{site.data.kong_latest.version}}.el7.noarch.rpm)

**Enterprise trial users** should download their package from their welcome email and save their license to `/etc/kong/license.json` after step 1.

### YUM Repositories

You can also install Kong via YUM; follow the instructions on the "Set Me Up"
section on the page below.

- [RPM Repository](https://bintray.com/kong/kong-community-edition-rpm)

**NOTE**: ensure that the `baseurl` field of the generated `.repo` file contains
your RHEL version; for instance:

```
baseurl=https://kong.bintray.com/kong-community-edition-rpm/centos/6
```
or

```
baseurl=https://kong.bintray.com/kong-community-edition-rpm/centos/7
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
    $ sudo yum install kong-community-edition-{{site.data.kong_latest.version}}.*.noarch.rpm --nogpgcheck
    ```

3. **Prepare your database**

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

4. **Start Kong**

    ```bash
    $ kong start [-c /path/to/kong.conf]
    ```

5. **Use Kong**

    Kong is running:

    ```bash
    $ curl -i http://localhost:8001/
    ```

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/latest/getting-started/quickstart).

[configuration]: /{{site.data.kong_latest.release}}/configuration#database
