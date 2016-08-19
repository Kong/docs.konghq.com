---
id: page-install-method
title: Install - OS X
header_title: OS X Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

### Packages:

- [.pkg Installer]({{ site.links.download }}/{{site.data.kong_latest.version}}/kong-{{site.data.kong_latest.version}}.osx.pkg)
- [Homebrew Formula]({{ site.repos.homebrew }})

----

### Installation:

1. **Install the Package:**

    Use the `.pkg` installer or the Homebrew formula. For the Homebrew formula, follow the instructions described in the repository.

    **Note**: After downloading the `.pkg` installer, you will have to **right click**, select "Open" and authorize it.

2. **Configure your database**

    [Configure][configuration] Kong so it can connect to your database. Kong supports both [PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/) and [Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/) as its datastore.

    If you are using Postgres, please provision a database and a user before starting Kong, ie:

    ```sql
    CREATE USER kong; CREATE DATABASE kong OWNER kong;
    ```

3. **Start Kong:**

    ```bash
    $ kong start

    # Kong is running
    $ curl 127.0.0.1:8001
    ```

4. **Use Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/latest/getting-started/quickstart).

[configuration]: /docs/{{site.data.kong_latest.release}}/configuration#database
