---
id: page-install-method
title: Install - macOS
header_title: macOS Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

### Packages

- [Homebrew Formula]({{ site.repos.homebrew }})

----

### Installation

1. **Install Kong**

    Use the [Homebrew](https://brew.sh/) package manager to add Kong as a tap and install it:

    ```bash
    $ brew tap kong/kong
    $ brew install kong
    ```

1. **Add `kong.conf`**

    **Note**: This step is **required** if you are using Cassandra; it is **optional** for Postgres users.

    By default, Kong is configured to communicate with a local Postgres instance.
    If you are using Cassandra, or need to modify any settings, download the [`kong.conf.default`](https://raw.githubusercontent.com/Kong/kong/master/kong.conf.default) file and [adjust][configuration] it as necessary.
    Then, as root, add it to `/etc`:

    ```bash
    $ sudo mkdir -p /etc/kong
    $ sudo cp kong.conf.default /etc/kong/kong.conf
    ```

1. **Prepare your database**

    [Configure][configuration] Kong so it can connect to your database. Kong supports both [PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/) and [Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/) as its datastore.

    If you are using Postgres, provision a database and a user before starting Kong:

    ```sql
    CREATE USER kong; CREATE DATABASE kong OWNER kong;
    ```

    Next, run the Kong migrations:

    ```bash
    $ kong migrations bootstrap [-c /path/to/kong.conf]
    ```

    **Note for Kong < 0.15**: with Kong versions below 0.15 (up to 0.14), use
    the `up` sub-command instead of `bootstrap`. Also note that with Kong <
    0.15, migrations should never be run concurrently; only one Kong node
    should be performing migrations at a time. This limitation is lifted for
    Kong 0.15, 1.0, and above.

1. **Start Kong**

    ```bash
    $ kong start [-c /path/to/kong.conf]
    ```

1. **Use Kong**

    Verify that Kong is running:

    ```bash
    $ curl -i http://localhost:8001/
    ```

    Quickly learn how to use Kong with the [5-minute Quickstart](/latest/getting-started/quickstart).

[configuration]: /{{site.data.kong_latest.release}}/configuration#database
