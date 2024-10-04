<!-- Shared between all Linux installation topics, including Amazon Linux, CentOS, Ubuntu, and RHEL,
located in the app/gateway/{version}/install folder.
-->

## Set up configs

{{site.base_gateway}} comes with a default configuration property file that can be found
at `/etc/kong/kong.conf.default` if you installed {{site.base_gateway}} with one of the official packages.
This configuration file is used for setting {{site.base_gateway}}’s configuration properties at startup.

{{site.base_gateway}} offers two options for storing the configuration properties for all of
{{site.base_gateway}}'s configured entities, a database or a yaml declarative configuration file.
Before starting {{site.base_gateway}} you must update the `kong.conf.default` configuration property file with a reference
to your data store.

To alter the default properties listed in the `kong.conf.default` file and configure {{site.base_gateway}},
make a copy of the file, rename it (for example `kong.conf`), make your updates, and save it to the same location.

### Using a database

First, configure {{site.base_gateway}} using the `kong.conf` configuration file so it can connect to your database.
See the data store section of the [Configuration Property Reference](/gateway/{{ include.release}}/reference/configuration/#datastore-section) for all relevant configuration parameters.

{% if_version lte:2.6.x %}

{{site.base_gateway}} supports both [PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/)
and [Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/) as its data store.

{% endif_version %}

{% if_version gte:2.7.x lte:3.3.x %}

{% include_cached /md/enterprise/cassandra-deprecation.md length='short' release=page.release %}

{% endif_version %}

The following instructions use [PostgreSQL](http://www.postgresql.org/) as a database to store Kong configuration.

1. Provision a database and a user before starting {{site.base_gateway}}:

    ```sql
    CREATE USER kong WITH PASSWORD 'super_secret'; CREATE DATABASE kong OWNER kong;
    ```

2. Run one of the following {{site.base_gateway}} migrations:
    * <span class="badge enterprise"></span> In Enterprise environments, we strongly recommend seeding a password for the **Super Admin** user with the ```kong migrations``` command. This allows you to use RBAC (Role Based Access Control) at a later time, if needed. Create an environment variable with the desired **Super Admin** password and store the password in a safe place:
    ```bash
    KONG_PASSWORD={PASSWORD} kong migrations bootstrap -c {PATH_TO_KONG.CONF_FILE}
    ```
    > **Important**: Setting your Kong password (`KONG_PASSWORD`) using a value containing four ticks (for example, `KONG_PASSWORD="a''a'a'a'a"`) causes a PostgreSQL syntax error on bootstrap. To work around this issue, do not use special characters in your password.

    * If you aren't using Enterprise, run the following:
    ```bash
    kong migrations bootstrap -c {PATH_TO_KONG.CONF_FILE}
    ```

{:.note}
> **Note:** Older versions of PostgreSQL use `ident` authentication by default, newer versions (PSQL 10+)
 use `scram-sha-256`. To allow the `kong` user to communicate with the database locally, change the
 authentication method to `md5` by modifying the PostgreSQL configuration file.

### Using a yaml declarative config file

If you want to store the configuration properties for all of {{site.base_gateway}}'s configured entities
in a yaml declarative configuration file, also referred to as DB-less mode, you must create a `kong.yml` file
and update the `kong.conf` configuration file to include the file path to the `kong.yml` file.

First, the following command will generate a `kong.yml` declarative configuration file in your current folder:

```bash
kong config init
```

The generated `kong.yml` file contains instructions for how to configure {{site.base_gateway}} using the file.

Second, you must configure {{site.base_gateway}} using the `kong.conf` configuration file so it is aware of
your declarative configuration file.

Set the `database` option to `off` and the `declarative_config` option to the path of your `kong.yml` file as in the following example:

```
database = off
declarative_config = {PATH_TO_KONG.CONF_FILE}
```

## Start {{site.base_gateway}}

{% include_cached /md/gateway/root-user-note.md release=page.release %}

Start {{site.base_gateway}} using the following command:

```
kong start -c {PATH_TO_KONG.CONF_FILE}
```

## Verify install

If everything went well, you should see a message (`Kong started`) informing you that {{site.base_gateway}} is running.

You can also check using the Admin API:

```
curl -i http://localhost:8001
```

You should receive a `200` status code.

By default, {{site.kong_gateway}} listens on the following ports:

- `:8000`: Port on which {{site.kong_gateway}} listens for incoming HTTP traffic from your clients, and
   forwards it to your upstream services.
- `:8443`: Port on which {{site.kong_gateway}} listens for incoming HTTPS traffic. This port has similar
   behavior as the `:8000` port, except that it expects HTTPS traffic only. This port can be disabled
   with the `kong.conf`configuration file.
- `:8001`: Port on which the Admin API used to configure {{site.kong_gateway}} listens.
- `:8444`: Port on which the Admin API listens for HTTPS traffic.

## Post-install configuration

The following steps are all optional and depend on the choices you want to make
for your environment.

### Apply Enterprise license
{:.badge .enterprise}

If you have an Enterprise license for {{site.base_gateway}}, apply it using one
of the methods below, depending on your environment.

{% navtabs %}
{% navtab With a database %}

Apply the license using the Admin API. The license data must contain straight
quotes to be considered valid JSON (`'` and `"`, not `’` or `“`).

`POST` the contents of the provided `license.json` license to your
{{site.base_gateway}} instance:

{:.note}
> **Note:**
The following license is only an example. You must use the following format,
but provide your own content.

```bash
curl -i -X POST http://localhost:8001/licenses \
  -d payload='{"license":{"payload":{"admin_seats":"1","customer":"Example Company, Inc","dataplanes":"1","license_creation_date":"2017-07-20","license_expiration_date":"2017-07-20","license_key":"00141000017ODj3AAG_a1V41000004wT0OEAU","product_subscription":"Konnect Enterprise","support_plan":"None"},"signature":"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b","version":"1"}}'
```

{% endnavtab %}
{% navtab Without a database %}

Securely copy the `license.json` file to your home directory on the filesystem
where you have installed
{{site.base_gateway}}:

```sh
$ scp license.json <system_username>@<server>:~
```

Then, copy the license file again, this time to the `/etc/kong` directory:

```sh
$ scp license.json /etc/kong/license.json
```

{{site.base_gateway}} will look for a valid license in this location.

{% endnavtab %}
{% endnavtabs %}

{% if_version lte:3.3.x %}
### Enable Kong Manager
{:.badge .free}
{% endif_version %}
{% if_version gte:3.4.x %}
### Enable Kong Manager
{% endif_version %}

{% if_version gte:3.0.x %}

If you're running {{site.base_gateway}} with a database (either in traditional
or hybrid mode), you can enable {{site.base_gateway}}'s graphical user interface
(GUI), Kong Manager.

See the [Kong Manager setup guide](/gateway/{{page.release}}/kong-manager/enable/){% if_version gte:3.4.x %} or the [Kong Manager OSS guide](/gateway/{{page.release}}/kong-manager-oss){% endif_version %} for more information.

{% endif_version %}
{% if_version lte:2.8.x %}

1. Update the `admin_gui_url` property
   in the `kong.conf` configuration file to the DNS, or IP address, of your system. For example:

    ```
    admin_gui_url = http://localhost:8002
    ```

    This setting needs to resolve to a network path that will reach the operating system (OS) host.

2. Update the Admin API setting in the `kong.conf` file to listen on the needed network interfaces on the OS host.
   A setting of `0.0.0.0:8001` will listen on port `8001` on all available network interfaces.

    {% include_cached /md/admin-listen.md release=page.release desc='long' %}

    Example configuration:

    ```conf
    admin_listen = 0.0.0.0:8001, 0.0.0.0:8444 ssl
    ```

    You may also list network interfaces separately as in this configuration example:

    ```conf
    admin_listen = 0.0.0.0:8001, 0.0.0.0:8444 ssl, 127.0.0.1:8001, 127.0.0.1:8444 ssl
    ```

3. Restart {{site.base_gateway}} for the setting to take effect, using the following command:

    ```bash
    kong restart -c {PATH_TO_KONG.CONF_FILE}
    ```

5. Access Kong Manager on port `8002`.

{% endif_version %}

{% if_version lte:3.4.x %}

### Enable Dev Portal
{:.badge .enterprise}

If you're running {{site.base_gateway}} with a database (either in traditional
or hybrid mode), you can enable the {% if_version lte:2.8.x %}[Dev Portal](/gateway/{{page.release}}/developer-portal/).{% endif_version %}{% if_version gte:3.0.x lte:3.4.x %}[Dev Portal](/gateway/{{page.release}}/kong-enterprise/dev-portal/){% endif_version %}

1. Enable the Dev Portal in the `kong.conf` file by setting the `portal` property to `on` and the
   `portal_gui_host` property to the DNS or IP address of the system.
   For example:

    ```
    portal = on
    portal_gui_host = localhost:8003
    ```

1. Restart {{site.base_gateway}} for the setting to take effect, using the following command:

    ```
    kong restart -c {PATH_TO_KONG.CONF_FILE}
    ```

1. To enable the Dev Portal for a workspace, execute the following command,
   updating `DNSorIP` to reflect the IP or valid DNS for the system:

   ```bash
   curl -X PATCH http://localhost:8001/workspaces/default \
    --data "config.portal=true"
   ```

1. Access the Dev Portal for the default workspace using the following URL,
   substituting your own DNS or IP:

    ```
    http://localhost:8003/default
    ```
{% endif_version %}

## Troubleshooting and support
{:.badge .enterprise}

{% if_version gte:3.0.x %}

For troubleshooting license issues, see:
* [Deployment options for licenses](/gateway/{{page.release}}/licenses/deploy/)
* [`/licenses` API reference](/gateway/{{page.release}}/admin-api/licenses/reference/)
* [`/licenses` API examples](/gateway/{{page.release}}/licenses/examples/)

If you did not receive an `HTTP/1.1 200 OK` message or need assistance completing
your setup, reach out to your Kong Support contact or go to the
[Support Portal](https://support.konghq.com/support/s/).

## Next steps

Check out {{site.base_gateway}}'s series of
[Getting Started](/gateway/{{include.release}}/get-started/) guides to get the most
out of {{site.base_gateway}}.

{% endif_version %}
{% if_version lte:2.8.x %}

For troubleshooting license issues, see:
* [Deployment options for licenses](/gateway/{{page.release}}/plan-and-deploy/licenses/deploy-license/)
* [`/licenses` API reference](/gateway/{{page.release}}/admin-api/licenses/reference/)
* [`/licenses` API examples](/gateway/{{page.release}}/admin-api/licenses/examples/)

If you did not receive an `HTTP/1.1 200 OK` message or need assistance completing
your setup, reach out to your Kong Support contact or go to the
[Support Portal](https://support.konghq.com/support/s/).

## Next steps

Check out {{site.base_gateway}}'s series of
[Getting Started](/gateway/{{include.release}}/get-started/comprehensive/) guides to get the most
out of {{site.base_gateway}}.

{% endif_version %}
