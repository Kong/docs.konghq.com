<!-- Shared between all Community Linux installation topics: Amazon Linux,
 CentOS, Debian, RedHat, and Ubuntu -->
## Prepare your configs

Kong can run either with or without a database.

When using a database, you will use the `kong.conf` configuration file for setting Kong's
configuration properties at start-up and the database as storage of all configured entities,
such as the Routes and Services to which Kong proxies.

When not using a database, you will use `kong.conf` its configuration properties and a `kong.yml`
file for specifying the entities as a declarative configuration.

### Using a database

[Configure][configuration] Kong so it can connect to your database. Kong supports both [PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/) and [Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/) as its datastore.

1. If you are using Postgres, provision a database and a user before starting Kong:

    ```sql
    CREATE USER kong; CREATE DATABASE kong OWNER kong;
    ```

2. Run the Kong migrations:

    ```bash
    $ kong migrations bootstrap [-c /path/to/kong.conf]
    ```

### Without a database

If you are going to run Kong in [DB-less mode](/gateway/{{include.kong_version}}/reference/db-less-and-declarative-config/),
you should start by generating declarative config file.

1. Generate a `kong.yml` file in your current folder using the following command:

    ``` bash
    kong config init
    ```

    The file contains instructions about how to populate it.

2. Edit your `kong.conf` file. Set the `database` option
to `off` and the `declarative_config` option to the path of your `kong.yml` file:

    ```conf
    database = off
    declarative_config = /path/to/kong.yml
    ```

## Run Kong Gateway

{:.note}
> **Note:** When you start Kong, the NGINX master process runs
as `root` and the worker processes as `kong` by default.
If this is not the desired behavior, you can switch the NGINX master process to run on the built-in
`kong` user or to a custom non-root user before starting Kong. For more
information, see [Running Kong as a Non-Root User](/gateway/{{page.kong_version}}/plan-and-deploy/kong-user).

1. Start {{site.base_gateway}}:
    ```bash
    kong start [-c /path/to/kong.conf]
    ```

2. Check that {{site.base_gateway}} is running:

    ```bash
    curl -i http://localhost:8001/
    ```

## Next steps

Check out {{site.base_gateway}}'s series of
[Getting Started](/gateway/{{include.kong_version}}/get-started/comprehensive) guides to get the most
out of {{site.base_gateway}}.

[configuration]: /gateway/{{include.kong_version}}/reference/configuration/#database
