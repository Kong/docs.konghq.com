---
title: Troubleshoot Runtime Instances
no_version: true
---

## Out of sync runtime instance

Occasionally, a {{site.base_gateway}} runtime instance might get out of sync
with the {{site.konnect_short_name}} control plane. If this happens, you will
see the status `Out of sync` on the Runtime Instances page, meaning the control
plane can't communicate with the instance.

Troubleshoot the issue using the following methods:

* Ensure the runtime instance is running. If it's not running, start it; if it
is running, restart it.

    Check the sync status in the Runtime Manager.

* Check the logs of the runtime that's appearing as `Out of sync`. The default
directory for {{site.base_gateway}} logs is [`/usr/local/kong/logs`](/gateway/latest/reference/configuration/#log_level).

    If you find any of the following errors:

    * Runtime instance failed to connect to the control plane.
    * Runtime instance failed to ping the control plane.
    * Runtime instance failed to receive a ping response from the control plane.

    You may have an issue on the host network where the instance resides.
    Diagnose and resolve the issue, then restart the instance and check
    the sync status in the Runtime Manager.

* If the logs show a license issue, contact [Kong Support](https://support.konghq.com/).

If you are unable to resolve sync issues using the above methods, contact
[Kong Support](https://support.konghq.com/).

## Missing functionality

If a {{site.konnect_short_name}} feature isn’t working on your runtime instance,
the version may be out of date.

Verify that your instance versions are up to date:

1. Open {% konnect_icon runtimes %} **Runtime Manager**, then open your runtime group.

1. Click **+ Add runtime instance** and check the {{site.base_gateway}} version
in the codeblock. This is the version that the {{site.konnect_short_name}} 
control plane is running.

1. Return to the runtime instances page.

1. Check the runtime instance versions in the table. If you see
an instance running an older version of {{site.base_gateway}}, your runtime
instance may need [upgrading](/konnect/configure/runtime-manager/runtime-instances/upgrade).

If your version is up to date but the feature still isn't working, contact
[Kong Support](https://support.konghq.com/).
