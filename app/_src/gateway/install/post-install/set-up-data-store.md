---
title: Set up data store
content_type: how-to
---

{{site.base_gateway}} comes with a default configuration property file that can be found
at `/etc/kong/kong.conf.default`. This configuration file is used for setting {{site.base_gateway}}’s 
configuration properties at startup.

{{site.base_gateway}} offers two options for storing the configuration properties for all of
{{site.base_gateway}}'s configured entities: using a database (PostgreSQL), or using a 
YAML declarative configuration file, also known as DB-less mode.

Before starting {{site.base_gateway}}, you must update the `kong.conf.default` configuration 
property file with a reference to your data store.

{:.note}
> **Note**: The following data store setup is only necessary if you installed {{site.base_gateway}} without a data store. 
If you followed one of our Docker, Kubernetes, or quickstart guides, you should already have a data store configured.

## Set up data store

To alter the default properties listed in the `kong.conf.default` file and configure {{site.base_gateway}},
make a copy of the file, rename it (for example `kong.conf`), make your updates, and save it to the same location.

Then, choose one of the following options to set up your data store:
* [Using a database](#using-a-database)
* [Using a YAML declarative configuration file](#using-a-yaml-declarative-config-file) (DB-less)

### Using a database

Configure {{site.base_gateway}} using the `kong.conf.default` file so it can connect to your database.
See the data store section of the [Configuration Property Reference](/gateway/{{ page.release }}/reference/configuration/#datastore-section) 
for all relevant configuration parameters.

{% if_version gte:2.7.x lte:3.3.x %}

{% include_cached /md/enterprise/cassandra-deprecation.md length='short' release=page.release %}

{% endif_version %}

Provision a [PostgreSQL](http://www.postgresql.org/) database and a user before starting {{site.base_gateway}}:

```sql
CREATE USER kong WITH PASSWORD 'super_secret'; CREATE DATABASE kong OWNER kong;
```

Run one of the following {{site.base_gateway}} migrations:

{% navtabs %}
{% navtab Kong Gateway Enterprise %}

In Enterprise environments, we strongly recommend seeding a password for the super admin user with the `kong migrations` command. 
This allows you to use RBAC (Role Based Access Control) at a later time, if needed. 

Create an environment variable with the desired password and store the password in a safe place:

```bash
KONG_PASSWORD=<PASSWORD> kong migrations bootstrap -c <KONG_DECLARATIVE_CONFIG_PATH>
```

{:.important}
> **Important**: Setting your Kong password (`KONG_PASSWORD`) using a value containing four ticks 
(for example, `KONG_PASSWORD="a''a'a'a'a"`) causes a PostgreSQL syntax error on bootstrap. 
To work around this issue, do not use special characters in your password.

{% endnavtab %}
{% navtab Kong Gateway (OSS) %}

If you aren't using Enterprise, run the following:

```bash
kong migrations bootstrap -c <KONG_DECLARATIVE_CONFIG_PATH>
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

1. Generate a `kong.yml` declarative configuration file in your current folder:

    ```bash
    kong config init
    ```

    The generated `kong.yml` file contains instructions for configuring {{site.base_gateway}} using the file.

2. In `kong.conf`, set the `database` option to `off`, and set the `declarative_config` directive to the 
path to your `kong.yml`:

    ```
    database = off
    declarative_config = <KONG_DECLARATIVE_CONFIG_PATH>
    ```

## Start {{site.base_gateway}}

{% include_cached /md/gateway/root-user-note.md release=page.release %}

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
* [Add your Enterprise license](/gateway/{{ page.release }}/licenses/deploy)
{% if_version gte:3.4.x -%}
* Enable Kong Manager:
  * [Kong Manager Enterprise](/gateway/{{ page.release }}/kong-manager/enable/)
  * [Kong Manager OSS](/gateway/{{ page.release }}/kong-manager-oss/)
{% endif_version -%}
{% if_version lte:3.3.x -%}
* [Enable Kong Manager](/gateway/{{ page.release }}/kong-manager/enable/)
{% endif_version -%}
* [Default ports reference](/gateway/{{page.release}}/production/networking/default-ports/)

You can also check out {{site.base_gateway}}'s series of
[Getting Started](/gateway/{{page.release}}/get-started/) guides to learn how 
get the most out of {{site.base_gateway}}.
