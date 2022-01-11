---
title: Install Kong Gateway on macOS
badge: oss
---
<!-- Banner with links to latest downloads -->
<!-- The install-link and install-listing-link classes are used for tracking, do not remove -->

{:.install-banner}
> See the MacOS
> [**Homebrew formula**]({{ site.repos.homebrew }}){:.install-listing-link}
>
> (latest version: {{page.kong_versions[page.version-index].ce-version}})

{{site.ce_product_name}} is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

## Prerequisites

You have a supported system with root or [root-equivalent](/gateway/{{page.kong_version}}/plan-and-deploy/kong-user) access.

## Download and install

Install {{site.base_gateway}}:

Use the [Homebrew](https://brew.sh/) package manager to add Kong as a tap and install it:

```bash
brew tap kong/kong
brew install kong
```

## Prepare your configs

Kong can run either with or without a database.

When using a database, you will use the `kong.conf` configuration file for setting Kong's
configuration properties at start-up and the database as storage of all configured entities,
such as the Routes and Services to which Kong proxies.

When not using a database, you will use `kong.conf`'s configuration properties and a `kong.yml`
file for specifying the entities as a declarative configuration.

### Using a database


{% include_cached /md/enterprise/cassandra-deprecation.md %}

[Configure][configuration] Kong so it can connect to your database. Kong supports
[PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/) and
[Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/) as datastores, and
can also run in [DB-less mode](/gateway/latest/reference/db-less-and-declarative-config/)

1. If you are using Postgres, provision a database and a user before starting Kong:

    ```sql
    CREATE USER kong; CREATE DATABASE kong OWNER kong;
    ```

2. Run the Kong migrations:

    ```bash
    kong migrations bootstrap [-c /path/to/kong.conf]
    ```

    By default, Kong is configured to communicate with a local Postgres instance.
    If you are using Cassandra, or need to modify any settings, download the [`kong.conf.default`](https://raw.githubusercontent.com/Kong/kong/master/kong.conf.default) file and [adjust][configuration] it as necessary.

3. As root, add `kong.conf.default` to `/etc`:

    ```bash
    sudo mkdir -p /etc/kong
    sudo cp kong.conf.default /etc/kong/kong.conf
    ```

### Without a database

If you are going to run Kong in [DB-less mode](/gateway/latest/reference/db-less-and-declarative-config/),
you should start by generating a declarative config file.

1. Generate a `kong.yml` file in your current folder using the following command:

    ``` bash
    kong config init
    ```

    The file contains instructions about how to populate it.

2. Edit your `kong.conf` file. Set the `database` option
    to `off` and the `declarative_config` option to the path of your `kong.yml` file:

    ``` conf
    database = off
    declarative_config = /path/to/kong.yml
    ```

## Run Kong Gateway

1. Start {{site.base_gateway}}:

    ```bash
    kong start [-c /path/to/kong.conf]
    ```

2.  Verify that {{site.base_gateway}} is running:

    ```bash
    curl -i http://localhost:8001/
    ```

## Next steps

Check out {{site.base_gateway}}'s series of
[Getting Started](/gateway/{{page.kong_version}}/get-started/comprehensive) guides to get the most
out of {{site.base_gateway}}.

[configuration]: /gateway/{{page.kong_version}}/reference/configuration#database
