---
title: Back Up and Restore Konnect Configuration
content_type: how-to
---

Use [decK](/deck/latest/installation/) to back up and restore 
{{site.konnect_short_name}}'s runtime group configuration. 

With `deck dump`, decK generates state files for each runtime group, which act 
as snapshots of the runtime group's configuration at that point in time.
If a runtime group's configuration is ever corrupted, you can then use these snapshots to 
restore your runtime group, or bring up another runtime group with the same configuration.

Review the list of [entities managed by decK](/deck/latest/reference/entities/) to see what can 
be backed up.

{:.note}
> **Note:** You can't use this method to back up
Dev Portal configuration and objects, such as documents, specs, and applications.
There is currently no automated way to back up Dev Portal content.

## Back up a {{site.konnect_short_name}} runtime group

Use `deck dump` to back up your configuration:

```sh
deck dump \
--konnect-token <your-PAT> \
--konnect-runtime-group-name <group-name> \
--output-file /path/to/<my-backup.yaml>
```

We recommend using a personal access token to authenticate with the {{site.konnect_short_name}} org. 
You can also choose a [different form of authentication](/deck/latest/guides/konnect).

This command generates a state file for the runtime group's entity
configuration, for example:

```yaml
_format_version: "3.0"
_konnect:
    runtime_group_name: us-west
consumers:
- username: DianaPrince
- username: WallyWest
services:
- connect_timeout: 60000
    host: mockbin.org
    name: MyService
    tags:
    - _KonnectService:example_service
    ...
```

## Restore a {{site.konnect_short_name}} runtime group

You can restore entity configuration for a runtime group using a declarative configuration file.
Note that you must do this for one group at a time.

Assuming you have a backup file, for example, `my-backup.yaml`:

Run a diff between your backup file and the runtime group in {{site.konnect_short_name}} to 
make sure you're applying the configuration you want:

```sh
deck diff \
--konnect-token <your-PAT> \
--konnect-runtime-group-name <group-name> \
--output-file /path/to/<my-backup.yaml>
```

If you're satisfied with the diff result, run `deck sync` to sync your configuration to 
a runtime group:

```sh
deck sync \
--konnect-token <your-PAT> \
--konnect-runtime-group-name <group-name> \
--output-file /path/to/<my-backup.yaml>
```

Check your runtime group in {{site.konnect_short_name}} to make sure the sync worked. 
Open **Runtime Manager**, select your runtime group, and check through the configured entities.

## More information
* [Entities managed by decK](/deck/latest/reference/entities/)
* [Using tags to back up a subset of configuration](/deck/latest/guides/backup-restore/#manage-a-subset-of-configuration)