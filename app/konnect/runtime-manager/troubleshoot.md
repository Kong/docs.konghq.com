---
title: Troubleshoot Runtime Instances
content_type: how-to
---

## Out of sync runtime instance

**Problem**

Occasionally, a {{site.base_gateway}} runtime instance might get out of sync
with the {{site.konnect_short_name}} control plane. If this happens, you will
see the status `Out of sync` on the Runtime Instances page, meaning the control
plane can't communicate with the instance.

**Solution**

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

**Problem**

If a {{site.konnect_short_name}} feature isn’t working on your runtime instance,
the version may be out of date.

**Solution**

Verify that your instance versions are up to date:

1. Open {% konnect_icon runtimes %} **Runtime Manager**, then open your runtime group.

1. Click **+ Add runtime instance** and check the {{site.base_gateway}} version
in the code block. This is the version that the {{site.konnect_short_name}}
control plane is running.

1. Return to the runtime instances page.

1. Check the runtime instance versions in the table. If you see
an instance running an older version of {{site.base_gateway}}, your runtime
instance may need [upgrading](/konnect/runtime-manager/runtime-instances/upgrade/).

If your version is up to date but the feature still isn't working, contact
[Kong Support](https://support.konghq.com/).

## Kubernetes runtime instance installation does not work

**Problem**

You followed the Kubernetes installation instructions in Runtime Manager 
but your runtime instance isn't connecting.
 
**Solution**

Check your deployment logs for the error:

```bash
kubectl logs deployment/my-kong-kong -n kong
```

If you find any errors and need to update `values.yaml`, make your changes,
save the file, then reapply the configuration by running the Helm `upgrade`
command:

```bash
helm upgrade my-kong kong/kong -n kong \
  --values ./values.yaml
```

## Connect a data plane to {{site.konnect_saas}} that is behind a non-trasparent forward proxy.

In situations where forward proxies are non-transparent, you can still connect the {{site.base_gateway}} data plane with the {{site.konnect_saas}} control plane.
To do this, you need to configure each {{site.base_gateway}} runtime instance to authenticate with the proxy server and allow traffic through.
For more information, see [Control Plane and Data Plane Communication through a Forward Proxy](/gateway/latest/production/networking/cp-dp-proxy/) in the {{site.base_gateway}} documentation.