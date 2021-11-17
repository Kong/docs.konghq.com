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
to your datastore.

To alter the default properties listed in the `kong.conf.default` file and configure {{site.base_gateway}},
make a copy of the file, rename it (for example `kong.conf`), make your updates, and save it to the same location.

For more information on how to configure {{site.base_gateway}} to connect to your datastore, see the Datastore section of the
[Configuration property Reference](/gateway/{{ include.kong_version }}/reference/configuration/#datastore-section).

### Using a database

First, you must configure {{site.base_gateway}} using the `kong.conf` configuration file so it can connect to your database.

For more information on how to configure {{site.base_gateway}} to connect to your database, see the Datastore section of the
[Configuration property Reference](/gateway/{{ include.kong_version }}/reference/configuration/#datastore-section).

{{site.base_gateway}} supports both [PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/)
and [Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/) as its datastore.

If you are using Postgres, provision a database and a user before starting {{site.base_gateway}}, for example:

```sql
CREATE USER kong; CREATE DATABASE kong OWNER kong;
```

Then, run the {{site.base_gateway}} migrations, using the following command:

<div class="copy-code-snippet"><pre><code>kong migrations bootstrap -c <div contenteditable="true">{PATH_TO_KONG.CONF_FILE}</div></code></pre></div>

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

<div class="copy-code-snippet"><pre><code>database = off
declarative_config = <div contenteditable="true">{PATH_TO_KONG.CONF_FILE}</div></code></pre></div>

## Seed Super Admin
{:.badge .enterprise}

Setting a password for the **Super Admin** before initial start-up is strongly recommended. This will permit the use of RBAC (Role Based Access Control) at a later time, if needed.

1. Create an environment variable with the desired **Super Admin** password and store the password in a safe place.
   Run migrations to prepare the Kong database, using the following command:

    <div class="copy-code-snippet"><pre><code>KONG_PASSWORD=<div contenteditable="true">{PASSWORD}</div> kong migrations bootstrap -c <div contenteditable="true">{PATH_TO_KONG.CONF_FILE}</div></code></pre></div>

2. Start {{site.base_gateway}}:

    <div class="copy-code-snippet"><pre><code>kong start -c <div contenteditable="true">{PATH_TO_KONG.CONF_FILE}</div></code></pre></div>

3. Verify {{site.base_gateway}} is working:

    <div class="copy-code-snippet"><pre><code>curl -i -X GET --url http://<div contenteditable="true">{DNS_OR_IP}</div>:8001/services</code></pre></div>

    You should receive a `HTTP/1.1 200 OK` message.

## Start Kong Gateway

{% include_cached /md/gateway/root-user-note.md kong_version=page.kong_version %}

Start {{site.base_gateway}} using the following command:

<div class="copy-code-snippet"><pre><code>kong start -c <div contenteditable="true">{PATH_TO_KONG.CONF_FILE}</div></code></pre></div>

## Verify install

If everything went well, you should see a message (`Kong started`) informing you that {{site.base_gateway}} is running.

By default, {{site.kong_gateway}} listens on the following ports:

- `:8000`: Port on which {{site.kong_gateway}} listens for incoming HTTP traffic from your clients, and
   forwards it to your upstream services.
- `:8443`: Port on which {{site.kong_gateway}} listens for incoming HTTPS traffic. This port has similar
   behavior as the `:8000` port, except that it expects HTTPS traffic only. This port can be disabled
   with the `kong.conf`configuration file.
- `:8001`: Port on which the Admin API used to configure {{site.kong_gateway}} listens.
- `:8444`: Port on which the Admin API listens for HTTPS traffic.

## Post-install configuration
### Enable and configure Kong Manager
{:.badge .free}

1. To access {{site.base_gateway}}'s graphical user interface (GUI), Kong Manager, update the `admin_gui_url` property
   in the `kong.conf` configuration file to the DNS, or IP address, of your system. For example:

   <div class="copy-code-snippet"><pre><code>admin_gui_url = http://<div contenteditable="true">{DNS_OR_IP}</div>:8002</code></pre></div>

    This setting needs to resolve to a network path that will reach the operating system (OS) host.

2. Update the Admin API setting in the `kong.conf` file to listen on the needed network interfaces on the OS host.
   A setting of `0.0.0.0:8001` will listen on port `8001` on all available network interfaces.

    {% include_cached /md/admin-listen.md desc='long' %}

    Example configuration:

    ```conf
    admin_listen = 0.0.0.0:8001, 0.0.0.0:8444 ssl
    ```

    You may also list network interfaces separately as in this configuration example:

    ```conf
    admin_listen = 0.0.0.0:8001, 0.0.0.0:8444 ssl, 127.0.0.1:8001, 127.0.0.1:8444 ssl
    ```

3. Restart {{site.base_gateway}} for the setting to take effect, using the following command:

    <div class="copy-code-snippet"><pre><code>kong restart -c <div contenteditable="true">{PATH_TO_KONG.CONF_FILE}</div></code></pre></div>

5. Access Kong Manager on port `8002`.

### Deploy a license
{:.badge .enterprise}

If you have an Enterprise subscription, follow the instructions to 
[deploy a license](/gateway/{{include.kong_version}}/plan-and-deploy/licenses/deploy-license).

### Enable Dev Portal
{:.badge .enterprise}

1. Enable the Dev Portal in the `kong.conf` file by setting the `portal` property to `on` and the
   `portal_gui_host` property to the DNS or IP address of the Amazon Linux system.
   For example:

    <div class="copy-code-snippet"><pre><code>portal = on
    portal_gui_host = <div contenteditable="true">{DNS_OR_IP}</div>:8003</code></pre></div>

1. Restart {{site.base_gateway}} for the setting to take effect, using the following command:

    <div class="copy-code-snippet"><pre><code>kong restart -c <div contenteditable="true">{PATH_TO_KONG.CONF_FILE}</div></code></pre></div>

1. To enable the Dev Portal for a workspace, execute the following command,
   updating `DNSorIP` to reflect the IP or valid DNS for the OS system:

    <div class="copy-code-snippet"><pre><code>curl -X PATCH http://<div contenteditable="true">{DNS_OR_IP}</div>:8001/workspaces/default \
    --data "config.portal=true"</code></pre></div>

1. Access the Dev Portal for the default workspace using the following URL,
   substituting your own DNS or IP:

    <div class="copy-code-snippet"><pre><code>http://<div contenteditable="true">{DNS_OR_IP}</div>:8003/default</code></pre></div>

## Support
{:.badge .enterprise}

If you did not receive an `HTTP/1.1 200 OK` message or need assistance completing
your setup, reach out to your Kong Support contact or go to the
[Support Portal](https://support.konghq.com/support/s/).

## Next Steps

Check out {{site.base_gateway}}'s series of
[Getting Started](/gateway/{{include.kong_version}}/get-started/comprehensive) guides to get the most
out of {{site.base_gateway}}.
