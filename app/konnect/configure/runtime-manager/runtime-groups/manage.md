---
title: Manage Runtime Groups
no_version: true
---

Create, update, and delete runtime groups through the
[Runtime Manager](https://cloud.konghq.com/runtime-manager) in Konnect.

You can find the list of all runtime groups in the Runtime Manager. If you don't
have an Enterprise account, the Runtime Manager will only ever have one
runtime group entry.

From a runtime group details page, you can
[create and manage runtime instances](/konnect/configure/runtime-manager/#types-of-runtimes)
and configure any [global entities](/konnect/configure/runtime-manager/runtime-groups/manage-entities)
in the group.

## Prerequisites
You have the **Organization Admin** role in {{site.konnect_saas}}.

## Create a runtime group
{:.badge .enterprise}

1. In Konnect, open ![runtimes icon](/assets/images/icons/konnect/icn-runtimes.svg){:.inline .konnect-icn .no-image-expand}
**Runtimes** from the left side menu.

1. Click **Create Runtime Group**.

1. Name the runtime group.

    Each runtime group in the organization must have a unique name.

<!--
1. Add any labels in `key:value` pair format.

    For example, you might set `location:us-west`, where `location` is the key
    and the `us-west` is the value.

    These labels are completely custom. Set anything that you need. -->

1. Click **Create**.

<!--
## Edit a runtime group

1. In Konnect, open ![runtimes icon](/assets/images/icons/konnect/icn-runtimes.svg){:.inline .konnect-icn .no-image-expand}
**Runtimes** from the left side menu.

1. Click the action menu icon on the far right of a row and select **Edit**.

1. Edit the group details, then click **Update**.

## Delete a runtime group
{:.badge .enterprise}

When a runtime group is deleted, all associated entities are also deleted.
This includes all entities configured in the Runtime Manager for this group. We
recommend backing up your runtime group configuration before deleting the group.

Runtime instances that are still active when the group is deleted will not be
terminated, but they will be orphaned. They will continue processing traffic
using the last configuration they received until they are either connected to
a new runtime group or manually shut down.

You cannot delete the default runtime group.

{:.warning}
> **Warning:** Deleting a group is irreversible. Make sure that you are
certain that you want to delete the group, and that all entities and runtime
instances in the have been accounted for.

1. Back up your configuration before deleting the runtime group. You
can use decK to accomplish this:

    ```sh
    deck dump \
    --konnect-password <pass> \
    --konnect-email <email> \
    --konnect-runtime-group <group-name> \
    --output-file /path/to/<my-backup.yaml>
    ```

    This command generates a state file for the runtime group's entity
    configuration. It looks something like this:

    ```yaml
    _format_version: "1.1"
    _konnect:
      runtime_group_name: us-west
    consumers:
    - username: DianaPrince
    - username: WallyWest
    services:
    - connect_timeout: 60000
      host: mockbin.org
      name: MyService
      ...
    ```

1. In Konnect, open ![runtimes icon](/assets/images/icons/konnect/icn-runtimes.svg){:.inline .konnect-icn .no-image-expand}
**Runtimes** from the left side menu.

1. Click the action menu icon on the far right of a row and select **Delete**.

1. Enter the group name, then confirm that you want to delete it. -->
