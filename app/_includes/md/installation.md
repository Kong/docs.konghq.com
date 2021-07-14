<!-- Shared between all Community Linux installation topics: Amazon Linux,
 CentOS, Debian, RedHat, and Ubuntu -->
## Setup

### Prepare your database or declarative configuration file

Kong can run either with or without a database.

When using a database, you will use the `kong.conf` configuration file for setting Kong's
configuration properties at start-up and the database as storage of all configured entities,
such as the Routes and Services to which Kong proxies.

When not using a database, you will use `kong.conf` its configuration properties and a `kong.yml`
file for specifying the entities as a declarative configuration.

#### Using a database

[Configure][configuration] Kong so it can connect to your database. Kong supports both [PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/) and [Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/) as its datastore.

If you are using Postgres, please provision a database and a user before starting Kong, ie:

```sql
CREATE USER kong; CREATE DATABASE kong OWNER kong;
```

Now, run the Kong migrations:

```bash
$ kong migrations bootstrap [-c /path/to/kong.conf]
```

#### Without a database

If you are going to run Kong in [DB-less mode](/gateway-oss/{{site.data.kong_latest.release}}/db-less-and-declarative-config/),
you should start by generating declarative config file. The following command will generate a `kong.yml`
file in your current folder. It contains instructions about how to fill it up.

```bash
$ kong config init
```

After filling up the `kong.yml` file, edit your `kong.conf` file. Set the `database` option
to `off` and the `declarative_config` option to the path of your `kong.yml` file:

```conf
database = off
declarative_config = /path/to/kong.yml
```

## Run Kong

### Start Kong

<div class="alert alert-ee blue">
    <strong>Note:</strong> When you start Kong, the NGINX master process runs
    as <code>root</code> and the worker processes as <code>kong</code> by default.
    If this is not the desired behavior, you can switch the NGINX master process to run on the built-in
    <code>kong</code> user or to a custom non-root user before starting Kong. For more
    information, see <a href="/gateway-oss/{{site.data.kong_latest.release}}/kong-user">Running Kong as a Non-Root User</a>.
</div>

```bash
$ kong start [-c /path/to/kong.conf]
```

## Use Kong

Check that Kong is running:

```bash
$ curl -i http://localhost:8001/
```

Quickly learn how to use Kong with the [5-minute Quickstart](/gateway-oss/{{site.data.kong_latest.release}}/getting-started/quickstart).

[configuration]: /gateway-oss/{{site.data.kong_latest.release}}/configuration/#database
