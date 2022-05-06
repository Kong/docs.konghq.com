---
title: Troubleshoot Runtime Instances
no_version: true
---

## Out of sync runtime instance

Occasionally, a {{site.base_gateway}} runtime instance might get out of sync
with the {{site.konnect_short_name}} control plane. If this happens, you would
see the status `Out of sync` on the Runtime Instances page, meaning the control
plane can't communicate with the instance.

Troubleshoot the issue using the following steps:

1. Ensure the runtime instance is running. If it's not running, start it; if it
is running, restart it.

    Check the sync status in the Runtime Manager.

1. Check the logs of the runtime that's appearing as `Out of sync`.
{{site.base_gateway}} logs can be found at `<kong-prefix-directory>/logs`,
where the default directory is `/usr/local/kong/logs`.

    If you find either of the following:

    * There is a connection error, where the instance failed to connect to the
    control plane.
    * Sending a ping to the control plane failed, or
    the runtime instance failed to receive a ping response from the control plane.

    Diagnose the host network where the instance resides.

    If you find a network issue and resolve it, restart the instance and check
    the sync status in the Runtime Manager.

1. If the logs show a license issue, contact [Kong Support](https://support.konghq.com/).

## Missing functionality

If you are trying to use a setting or feature in {{site.konnect_short_name}}
and it isn't working on your runtime instance, check the runtime instance
version. It may be out of date and doesn't support the new setting.

1. Check the version of {{site.base_gateway}} that the Konnect control plane is
currently running.

    1. Open {% konnect_icon runtimes %} **Runtimes**, then open your runtime group.
    1. Click **+ Create new runtime**, switch to a Linux or Kubernetes tab, and
    check the version in the codeblock.

1. Return to the runtime instances page.

1. Check the runtime instance versions in the table. If you see
an instance running an older version of {{site.base_gateway}}, your runtime
instance may need
[upgrading](/konnect/configure/runtime-manager/runtime-instances/upgrade).
