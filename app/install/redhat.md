---
id: page-install-method
title: Install - Red Hat
header_title: Red Hat Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

{% capture cassandra_version %}{{site.data.kong_latest.dependencies.cassandra}}{% endcapture %}

### Packages:

Start by downloading the corresponding package for your configuration:

- [RHEL 6]({{ site.links.download }}/{{site.data.kong_latest.version}}/kong-{{site.data.kong_latest.version}}.el6.noarch.rpm)
- [RHEL 7]({{ site.links.download }}/{{site.data.kong_latest.version}}/kong-{{site.data.kong_latest.version}}.el7.noarch.rpm)

### YUM Repositories

You can also install Kong by using the following YUM repositories and following the Bintray instructions:

- [RHEL 6 YUM](https://bintray.com/mashape/kong-rpm-el6-{{site.data.kong_latest.release}})
- [RHEL 7 YUM](https://bintray.com/mashape/kong-rpm-el7-{{site.data.kong_latest.release}})

----

### Installation:

1. **Enable the EPEL repository:**

    Before installing Kong, you need to install the `epel-release` package for right version of your operating system, so that Kong can fetch all the required dependencies:

    ```bash
    $ EL_VERSION=`cat /etc/redhat-release | grep -oE '[0-9]+\.[0-9]+'` && \
      sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-${EL_VERSION%.*}.noarch.rpm
    ```

2. **Install the Package:**

    If you are downloading the [package](#packages), execute:

    ```bash
    $ sudo yum install kong-{{site.data.kong_latest.version}}.*.noarch.rpm --nogpgcheck
    ```

3. **Configure your database**

    [Configure][configuration] Kong so it can connect to your database. Kong supports both [PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/) and [Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/) as its datastore.

    If you are using Postgres, please provision a database and a user before starting Kong, ie:

    ```sql
    CREATE USER kong; CREATE DATABASE kong OWNER kong;
    ```

4. **Start Kong:**

    ```bash
    $ kong start

    # Kong is running
    $ curl 127.0.0.1:8001
    ```

5. **Use Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/latest/getting-started/quickstart).

[configuration]: /docs/{{site.data.kong_latest.release}}/configuration#database
