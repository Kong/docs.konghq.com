---
id: page-install-method
title: Install - CentOS
header_title: CentOS Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

### Packages:

Start by downloading the corresponding package for your configuration:

- [CentOS 5]({{ site.links.download }}/el5.noarch.rpm)
- [CentOS 6]({{ site.links.download }}/el6.noarch.rpm)
- [CentOS 7]({{ site.links.download }}/el7.noarch.rpm)

----

### Installation:

1. **Install the Package:**

    After downloading the [package](#packages), execute:

    ```bash
    $ sudo yum install epel-release
    $ sudo yum install kong-{{site.data.kong_latest.version}}.*.noarch.rpm --nogpgcheck
    ```

2. **Configure your database**

    [Configure][configuration] Kong so it can connect to your database. Kong supports both [PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/) and [Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/) as its datastore.

3. **Start Kong:**

    ```bash
    $ kong start

    # Kong is running
    $ curl 127.0.0.1:8001
    ```

4. **Use Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/latest/getting-started/quickstart).

[configuration]: /docs/{{page.kong_version}}/configuration#database
