---
title: Backup and restore
---

Backup and restore methods described in this post only serve as general instructions. You must revise the methods in line with your infrastructure, deployment, and business requirements.

Before upgrading, you should back up data with database tools and optionally declarative tools. We highly recommend doing backup in both methods, which offers you recovery flexibility. The database tools are robust and can restore data instantly compared to the declarative tools. Consequently, in case of data corruption, try to do a database-level restore first, and otherwise bootstrap a new database and then use declarative tools.

## Database

Postgres and Cassandra have native exporting and importing tools that are reliable and performant, and that ensure consistency when backing up or restoring data. Please prioritize these tools for backup and restore.

### Database backup

The `kong migrations` commands are irrevocable, hence suggest to back up the database before command execution. Furthermore, we would restore the database in case of migration failure, like when the new cluster Y experienced any issues.

Depending on the database in use (e.g. Postgres or Cassandra), a database dump is recommended, so that you can recover the database quickly in a database-native way. Assuming Postgres is the database in use, you can dump data in text format, tar format (no compression), or directory format (with compression) with the utility pg_dump. Here is a quick example:

```sh
pg_dump -U kong -d kong -F d -f kongdb_backup_20230816
```

Please use CLI option “-d” to specify the database (e.g. “kong”) to export, especially when the Postgres instance also serves applications other than Kong Gateway.

Some managed database environments may support database snapshots, but it is beyond the scope of this post.

### Database restore

Corresponding to the Postgres database dump, we restore the data with the utility pg_restore as follows.

```sh
pg_restore -U kong -C -d postgres --if-exists --clean kongdb_backup_20230816/
```

## Declarative backup and restore

Kong Gateway ships the decK tool to support managing Kong Gateway entities in the declarative format. Backup with this tool serves as an extra layer of safeguard. If the database backup/restore corrupted the database, we can fall back on these tools for restoring data.

* In traditional and hybrid modes, decK requires that the database is ready for data export and import. To import or export data using decK, ensure the user and password are initialized, and the database is bootstrapped.
* In DB-less mode, decK is the only backup method.

However, deck has its limitations:

* **Performance**: decK uses the Admin API to read and write entities and might take longer than expected, especially when the number of entities is very large. 

  You can resolve this by increasing the number of threads by passing the flag `--parallelism` to `deck sync` or `deck diff`, or by using deck’s distributed configuration feature.

* **Entities managed by decK**: decK does not manage Enterprise-only entities, like RBAC roles, credentials, keyring, licence, etc. Configure these security related entities separately using Admin API or Kong Manager.

### Declarative backup

To back up data with deck, firstly make sure it successfully connects to Kong Gateway.

```sh
deck ping
```

The CLI option “--headers” can be used to specify the admin token as follows.

```sh
deck ping --headers “Kong-Admin-Token: <pAssW0rd>”
```

We can back up a particular workspace or all workspaces at once.

```sh
deck dump --all-workspaces -o /path/to/kong_backup.yaml
deck dump --workspace it_dept -o /path/to/kong_backup.yaml
```

### Declarative restore

Before restoring with deck, we must validate the declarative config. As discussed earlier, Kong must be online before executing the deck commands.

```sh
deck ping
deck validate [--online] -s /path/to/kong_backup.yaml
```

Once verified, restore a particular workspace or all workspaces at once.

```sh
deck sync --all-workspaces -s /path/to/kong_backup.yaml
deck sync --workspace it_dept -s /path/to/kong_backup.yaml
```

## Keyring materials backup and restore

If you happen to have enabled the Keyring and Data Encryption, you must separately back up and restore keyring materials. If the encryption key is lost, you will permanently lose access to the encrypted Kong configuration data and there is no way to recover it.

For technical details, refer to the [manual backup method](/gateway/latest/kong-enterprise/db-encryption/#manual-export-and-manual-import) and the [automatic backup method](/gateway/latest/kong-enterprise/db-encryption/#automatic-backup-and-manual-recovery). 

#### kong.conf backup

Manually back up the following files:

* Kong Gateway configuration file `kong.conf`.
* Files in the Kong Gateway prefix, such as keys, certificates, and `nginx-kong.conf`.
* Any other files you have created for your Kong Gateway deployment.

{:.note}
> **Note**: If you have built a commercial offering, here Kong is stateless i.e. everything that gets configured on either the AMI or the Docker container is defined in version control and pushed into the platform it's running on. Back up the parameters in your own operational or secure way.

Although these files do not contain Kong Gateway entities, without them, you won't be able to launch Kong Gateway.


-----



{% navtabs %}
{% navtab DB-less mode backup %}

In DB-less mode, configuration is managed declaratively, using a tool called decK. decK allows you to "dump" and "sync" configuration using YAML or JSON files. 

Backing up your configuration in this mode is simple: use decK to dump the configuration and store the resulting file in a secure location:

```sh
deck dump --all-workspaces -o <path/to/output/kong.yml>
```

If you encounter decK performance issues (for example, due to a large number of entities), use decK’s [distributed configuration](/deck/latest/guides/distributed-configuration/) feature.

If you need to roll back, simply change the DB-less Kong instance back to 2.8 LTS and sync with your backed up configuration file:

```sh
deck sync -s <path/to/backup/kong.yml>
```

{:.important}
> decK does not manage enterprise-only entities, including roles or permissions of RBAC, credentials, keyring, licenses, and others See the reference for [Entities managed by decK](/deck/latest/reference/entities/) for a full list.
Configure these security-related entities separately.

{% endnavtab %}
{% navtab Database backup %}

If you are running {{site.base_gateway}} with a database, run a database dump (raw data) so that you can recover the database quickly in a database-native way. 

If PostgreSQL is the database in use, you can dump data in text format, tar format (no compression), or directory format (with compression) using the command `pg_dump`. For example:

```sh
pg_dump -U kong -d kong -F d -f kongdb_backup_20230816
```

This method is convenient but operates on the database directly, so you must be careful, especially when the database serves applications other than {{site.base_gateway}}.

To recover Kong configuration data from a database dump, the operator must make sure the database is correctly prepared. For example, for PostgreSQL:

1. In `kong.conf`, set a database user using the `pg_user` parameter:

    ```
    pg_user = kong
    ```

2. In `kong.conf`, set a database name using the `pg_database` parameter:

    ```
    pg_database = kong
    ```

3. Bootstrap database entities by running `kong migrations bootstrap`.

  Refer to the [`kong migrations` CLI reference](/gateway/{{page.kong_version}}/reference/cli/#kong-migrations) for more information.

{% endnavtab %}
{% endnavtabs %}

#### Keyring materials backup

If you have enabled keyring and data encryption, the operator must separately backup and restore keyring materials. 

{:.important}
> **Caution**: If the encryption key is lost, you will permanently lose access to the encrypted 
{{site.base_gateway}} configuration data and there is no way to recover it.

For technical details, refer to the manual backup method and the automatic backup method. 
We will not repeat the exact steps described over there.
<!-- to do: either link or use an include here -->

#### kong.conf backup

Manually back up the following files:

* Kong Gateway configuration file `kong.conf`.
* Files in the Kong Gateway prefix, such as keys, certificates, and `nginx-kong.conf`.
* Any other files you have created for your Kong Gateway deployment.

{:.note}
> **Note**: If you have built a commercial offering, here Kong is stateless i.e. everything that gets configured on either the AMI or the Docker container is defined in version control and pushed into the platform it's running on. Back up the parameters in your own operational or secure way.

Although these files do not contain Kong configuration data, without them, you won't be able to launch Kong Gateway.