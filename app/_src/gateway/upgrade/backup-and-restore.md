---
title: Backup and restore
content_type: how-to
purpose: Learn how to back up and restore Kong Gateway
---

Before any upgrade, back up your {{site.base_gateway}} data. 
Kong supports two back up methods for Gateway entities: database backup and declarative backup.

We recommend backing up data using both methods, as this offers recovery flexibility.
* The native database tools are robust and can restore data instantly, compared to the declarative tool. 
* In case of data corruption, try to do a database-level restore first, otherwise bootstrap a new database and use decK to load in entity data.

Keyring materials and {{site.base_gateway}} configuration files must be backed up separately. 
See their respective sections for details.

The backup and restore methods described in this guide serve as general instructions.
Revise the methods as necessary to fit your infrastructure, deployment, and business requirements.

## Using decK for backup and restore

Kong ships a tool named [decK](/deck/), which supports managing {{site.base_gateway}} entities in the declarative format. For database-backed deployments, backups taken with this tool serve as an extra safeguard layer. If the database backup or restore corrupts the database, you can fall back to declarative files for restoring data.

* In **traditional and hybrid modes**, decK requires that the database is ready for data export and import. To import or export data using decK, ensure the user and password are initialized, and the database is bootstrapped.
* In **DB-less mode**, decK is the only backup method, as configuration is already managed declaratively.

However, decK has its limitations:

* **Performance**: decK uses the Admin API to read and write entities and might take longer than expected, especially when the number of entities is very large. 

  You can resolve this by increasing the number of threads by passing the flag `--parallelism` to [`deck sync`](/deck/latest/reference/deck_sync/) 
  or [`deck diff`](/deck/latest/reference/deck_diff/), or use decK’s 
  [distributed configuration](/deck/latest/guides/distributed-configuration/) feature.

* **Entities managed by decK**: decK does not manage Enterprise-only entities, like RBAC roles, credentials, keyring, licence, etc. Configure these security related entities separately using Admin API or Kong Manager.
See the reference for [Entities managed by decK](/deck/latest/reference/entities/) for a full list.

Due to these limitations, we recommend always using the [database dump method](#database-backup) in deployments using a database.

## Backup Gateway entities

### Database backup

When upgrading your {{site.base_gateway}} to a newer version, you have to perform a database migration using the `kong mnigrations` utility. The `kong migrations` commands are not reversible. We recommend backing up data before any starting any upgrade in case of any migration issues.

If you are running {{site.base_gateway}} with a database, run a database dump of raw data so that you can recover the database quickly in a database-native way. 

With PostgreSQL, you can dump data in text format, tar format (no compression), or directory format (with compression) using the utility `pg_dump`. For example:

```sh
pg_dump -U kong -d kong -F d -f kongdb_backup_20230816
```

Use the CLI option `-d` to specify the database (for example, `kong`) to export, especially when the PostgreSQL instance also serves applications other than {{site.base_gateway}}.

### Declarative backup

1. To back up data with decK, first make sure it successfully connects to {{site.base_gateway}}:

    ```sh
    deck ping
    ```

    If you have RBAC enabled, use the CLI option `--headers` to 
    specify the admin token. You can specify this token with any decK command:

    ```sh
    deck ping --headers “Kong-Admin-Token: <password>”
    ```

2. Use decK to dump the configuration and store the resulting file in a secure location.
You can back up a particular workspace or all workspaces at once:

    ```sh
    deck dump --all-workspaces -o /path/to/kong_backup.yaml
    deck dump --workspace it_dept -o /path/to/kong_backup.yaml
    ```

    Store the resulting file or files in a safe location.

## Restore Gateway entities

### Database restore

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

4. Corresponding to the Postgres database dump, you can now restore the data with the utility `pg_restore`:

    ```sh
    pg_restore -U kong -C -d postgres --if-exists --clean kongdb_backup_20230816/
    ```

### Declarative restore

If you need to roll back, change the DB-less Kong instance back to the original version, validate the declarative config, then sync it back with your Kong instance.

1. Check that {{site.base_gateway}} is online:

    ```sh
    deck ping
    ```
2. Validate the declarative config:

    ```sh
    deck validate [--online] -s /path/to/kong_backup.yaml
    ```

3. Once verified, restore a particular workspace or all workspaces at once:

    ```sh
    deck sync --all-workspaces -s /path/to/kong_backup.yaml
    deck sync --workspace it_dept -s /path/to/kong_backup.yaml
    ```

## Keyring materials backup and restore

If you have enabled keyring and data encryption, you must separately back up and restore keyring materials.

{:.important}
> **Caution**: Make sure to store the encryption key in a safe place. 
If the encryption key is lost, you will permanently lose access to the encrypted {{site.base_gateway}} 
configuration data and there is no other way to recover it.

For technical details, refer to the [manual backup method](/gateway/latest/kong-enterprise/db-encryption/#manual-export-and-manual-import) and the [automatic backup method](/gateway/latest/kong-enterprise/db-encryption/#automatic-backup-and-manual-recovery).

## kong.conf backup

Manually back up the following files:

* {{site.base_gateway}} configuration file `kong.conf`.
* Files in the {{site.base_gateway}} prefix, such as keys, certificates, and `nginx-kong.conf`.
* Any other files you have created for your {{site.base_gateway}} deployment.

Although these files don't contain {{site.base_gateway}} entities, without them, you won't be able to launch {{site.base_gateway}}.

{:.note}
> **Note**: If you have built a commercial offering where Kong is stateless -- that is, where everything that gets configured on either the AMI or the Docker container is defined in version control and pushed into the platform that it's running on -- back up Kong's configuration parameters in your own operational or secure way.