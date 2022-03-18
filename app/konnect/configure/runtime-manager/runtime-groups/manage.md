---
title: Manage Runtime Groups
no_version: true
---

Create, update, and delete runtime groups through the
[Runtime Manager](https://konnect.konghq.com/runtime-manager) in Konnect.

You can find the list of all runtime groups in the Runtime Manager. If you don't
have an Enterprise account, the Runtime Manager will only ever have one
runtime group entry.

From a runtime group details page, you can
[create and manage runtime instances](/konnect/configure/runtime-manager/#types-of-runtimes)
and configure any [global entities](/konnect/configure/runtime-manager/manage-entities)
in the group.

## Prerequisites
* TBA: Required permissions
* TBA: Any prereqs for deleting the group
  * Q: What are the prerequisites for deleting a group? Should you reassign users?
  * Q: What happens to the users that were previously assigned to the group? Are
  they dumped into the default runtime group, or do they have no permissions to
  access anything until manually changed?

## Create a runtime group
{:.badge .enterprise}

1. In Konnect, open the ![runtimes icon](/assets/images/icons/konnect/icn-runtimes.svg){:.inline .konnect-icn .no-image-expand}
**Runtime Manager** from the left side menu.

1. Click **Create Runtime Group**.

1. Name the runtime group and enter an optional description.

    Each runtime group in the organization must have a unique name.

1. Add any labels in key-value pair format.

    For example, you might set `location:us-west`, where `location` is the key
    and the `us-west` is the value.

    These labels are completely custom. Set anything that you need.

1. Click **Create**.

## Edit a runtime group

1. In Konnect, open the ![runtimes icon](/assets/images/icons/konnect/icn-runtimes.svg){:.inline .konnect-icn .no-image-expand}
**Runtime Manager** from the left side menu.

1. Click the action menu icon on the far right of a row and select **Edit**.

1. Edit the group details, then click **Update**.

## Delete a runtime group
{:.badge .enterprise}

When a runtime group is deleted, all associated entities are also deleted.
This includes associated Service versions in the Service Hub, as well as all
global Consumers, Plugins, Upstreams, Certificates, and SNIs configured for
this group.

Runtime instances that are still active when the group is deleted will not be
terminated, but they will be orphaned.

You cannot delete the default runtime group.

{:.warning}
> **Warning:** Deleting a group is irreversible. Make sure that you are
certain that you want to delete the group, and that all entities and runtime
instances in the have been accounted for.

1. In Konnect, open the ![runtimes icon](/assets/images/icons/konnect/icn-runtimes.svg){:.inline .konnect-icn .no-image-expand}
**Runtime Manager** from the left side menu.

1. Click the action menu icon on the far right of a row and select **Delete**.

1. Enter the group name, then confirm that you want to delete it.
