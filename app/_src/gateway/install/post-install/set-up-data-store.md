---
title: Set up data store
content_type: how-to
---

{{site.base_gateway}} comes with a default configuration property file that can be found
at `/etc/kong/kong.conf.default`. This configuration file is used for setting {{site.base_gateway}}’s 
configuration properties at startup.

{{site.base_gateway}} offers two options for storing the configuration properties for all of
{{site.base_gateway}}'s configured entities: a database or a YAML declarative configuration file (also known as DB-less mode).
Before starting {{site.base_gateway}}, you must update the `kong.conf.default` configuration property file with a reference
to your data store.

{:.note}
> **Note**: The following data store setup is only necessary if you installed {{site.base_gateway}} without a data store. 
If you followed one of our Docker, Kubernetes, or quickstart guides, you should already have a data store configured.

## Set up data store

To alter the default properties listed in the `kong.conf.default` file and configure {{site.base_gateway}},
make a copy of the file, rename it (for example `kong.conf`), make your updates, and save it to the same location.

Choose one of the following options to set up your data store:
* [Using a database](#using-a-database)
* [Using a YAML declarative configuration file](#using-a-yaml-declarative-config-file) (DB-less)

### Using a database

First, configure {{site.base_gateway}} using the `kong.conf` configuration file so it can connect to your database.
See the data store section of the [Configuration Property Reference](/gateway/{{ page.kong_version }}/reference/configuration/#datastore-section) 
for all relevant configuration parameters.

{% if_version gte:2.7.x lte:3.3.x %}

{% include_cached /md/enterprise/cassandra-deprecation.md length='short' kong_version=page.kong_version %}

{% endif_version %}

The following instructions use [PostgreSQL](http://www.postgresql.org/) as a database to store Kong configuration.

Provision a PostgreSQL database and a user before starting {{site.base_gateway}}:

```sql
CREATE USER kong WITH PASSWORD 'super_secret'; CREATE DATABASE kong OWNER kong;
```

Run one of the following {{site.base_gateway}} migrations:

{% navtabs %}
{% navtab Kong Gateway Enterprise %}

In Enterprise environments, we strongly recommend seeding a password for the Super Admin user with the `kong migrations` command. 
This allows you to use RBAC (Role Based Access Control) at a later time, if needed. 

Create an environment variable with the desired password and store the password in a safe place:

```bash
KONG_PASSWORD=<PASSWORD> kong migrations bootstrap -c <PATH_TO_KONG.CONF_FILE>
```

{:.important}
> **Important**: Setting your Kong password (`KONG_PASSWORD`) using a value containing four ticks 
(for example, `KONG_PASSWORD="a''a'a'a'a"`) causes a PostgreSQL syntax error on bootstrap. 
To work around this issue, do not use special characters in your password.

{% endnavtab %}
{% navtab Kong Gateway (OSS) %}

If you aren't using Enterprise, run the following:

```bash
kong migrations bootstrap -c <PATH_TO_KONG.CONF_FILE>
```
{% endnavtab %}
{% endnavtabs %}

Older versions of PostgreSQL use `ident` authentication by default, newer versions (PSQL 10+)
use `scram-sha-256`. To allow the `kong` user to communicate with the database locally, change the
authentication method to `md5` by modifying the PostgreSQL configuration file.

### Using a YAML declarative config file

Instead of using a database, you can also store the configuration properties for all of {{site.base_gateway}}'s 
configured entities in a YAML declarative configuration file (also referred to as DB-less mode).

Create a `kong.yml` file and update the `kong.conf` configuration file to include the file path to the `kong.yml` file.

1. Use the following command to generate a `kong.yml` declarative configuration file in your current folder:

    ```bash
    kong config init
    ```

    The generated `kong.yml` file contains instructions for how to configure {{site.base_gateway}} using the file.

2. Configure {{site.base_gateway}} with the path to your `kong.conf` configuration file so it is aware of
your declarative configuration file.

    Set the `database` option to `off` and the `declarative_config` option to the path of your `kong.yml` 
    file:

    ```
    database = off
    declarative_config = <PATH_TO_KONG.CONF_FILE>
    ```

## Start {{site.base_gateway}}

{% include_cached /md/gateway/root-user-note.md kong_version=page.kong_version %}

Start {{site.base_gateway}} using the following command:

```
kong start -c <PATH_TO_KONG.CONF_FILE>
```

## Verify install

If everything went well, you should see a message (`Kong started`) informing you that {{site.base_gateway}} is running.

You can also check using the Admin API:

```
curl -i http://localhost:8001
```

You should receive a `200` status code.

## Related information and next steps

Depending on your desired environment, see the following guides:
* [Add your Enterprise license](/gateway/{{ include.kong_version }}/licenses/deploy)
{% if_version gte:3.4.x %}
* Enable Kong Manager:
  * [Kong Manager Enterprise](/gateway/{{ include.kong_version }}/kong-manager/enable/)
  * [Kong Manager OSS](/gateway/{{ include.kong_version }}/kong-manager-oss/)
{% endif_version %}
{% if_version lte:3.3.x %}
* [Enable Kong Manager](/gateway/{{ include.kong_version }}/kong-manager/enable/)
{% endif_version %}
* [Default ports reference](/gateway/{{page.kong_version}}/production/networking/default-ports/)

You can also check out {{site.base_gateway}}'s series of
[Getting Started](/gateway/{{page.kong_version}}/get-started/) guides to learn how 
get the most out of {{site.base_gateway}}.
