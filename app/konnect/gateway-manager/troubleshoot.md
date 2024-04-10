---
title: Troubleshoot Data Plane Nodes
content_type: how-to
---


### Out of sync data plane node

**Problem**

Occasionally, a {{site.base_gateway}} data plane node might get out of sync
with the {{site.konnect_short_name}} control plane. If this happens, you will
see the status `Out of sync` on the Data Plane Nodes page, meaning the control
plane can't communicate with the node.

**Solution**

Troubleshoot the issue using the following methods:

* Ensure the data plane node is running. If it's not running, start it; if it
is running, restart it.

    Check the sync status in the Gateway Manager.

* Check the logs of the data plane node that's appearing as `Out of sync`. The default
directory for {{site.base_gateway}} logs is [`/usr/local/kong/logs`](/gateway/latest/reference/configuration/#log_level).

    If you find any of the following errors:

    * Data plane node failed to connect to the control plane.
    * Data plane node failed to ping the control plane.
    * Data plane node failed to receive a ping response from the control plane.

    You may have an issue on the host network where the node resides.
    Diagnose and resolve the issue, then restart the node and check
    the sync status in the Gateway Manager.

* If the logs show a license issue, contact [Kong Support](https://support.konghq.com/).

If you are unable to resolve sync issues using the above methods, contact
[Kong Support](https://support.konghq.com/).

### Missing functionality

**Problem**

If a {{site.konnect_short_name}} feature isn’t working on your data plane node,
the version may be out of date.

**Solution**

{% navtabs %}
{% navtab Dedicated Cloud Gateway %}
With Dedicated Cloud Gateways, {{site.base_gateway}} updates can be performed with the {{site.konnect_short_name}} manager or API. {{site.konnect_short_name}} will automatically provision new data plane nodes and slowly migrate traffic while monitoring for errors. For more information, read the [Upgrade documentation](/konnect/gateway-manager/data-plane-nodes/upgrade/).
{% endnavtab %}
{% navtab Self-hosted %}
Verify that your data plane node versions are up to date:

1. Open {% konnect_icon runtimes %} **Gateway Manager**, then open your control plane.

1. Select **Data Plane Nodes** from the side menu, then click the **New Data Plane Node** button.

1. Check the {{site.base_gateway}} version
in the code block. This is the version that the {{site.konnect_short_name}}
control plane is running.

1. Return to the data plane nodes page.

1. Check the data plane node versions in the table. If you see
a node running an older version of {{site.base_gateway}}, your data plane node
may need [upgrading](/konnect/gateway-manager/data-plane-nodes/upgrade/).

If your version is up to date but the feature still isn't working, contact
[Kong Support](https://support.konghq.com/).
{% endnavtab %}
{% endnavtabs %}
### Kubernetes data plane node installation does not work

**Problem**

You followed the Kubernetes installation instructions in Gateway Manager 
but your data plane node isn't connecting.
 
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

### Connect a data plane to {{site.konnect_saas}} that is behind a non-trasparent forward proxy.

In situations where forward proxies are non-transparent, you can still connect the {{site.base_gateway}} data plane with the {{site.konnect_saas}} control plane.
To do this, you need to configure each {{site.base_gateway}} data plane node to authenticate with the proxy server and allow traffic through.
For more information, see [Control Plane and Data Plane Communication through a Forward Proxy](/gateway/latest/production/networking/cp-dp-proxy/) in the {{site.base_gateway}} documentation.
