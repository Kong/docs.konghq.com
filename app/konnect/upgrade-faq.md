---
title: Frequently Asked Questions - Control Plane Upgrades
content_type: reference
---



### Are {{site.konnect_short_name}} control plane and associated database migrations or upgrades done by Kong Inc?

The {{site.base_gateway}} control plane and its dependencies are fully managed by {{site.konnect_short_name}}. As new versions of {{site.base_gateway}} are released, {{site.konnect_short_name}} supports them as long as they are under our [active support schedule](/gateway/latest/support-policy/#version-support-for-kong-gateway-enterprise/).


### Will {{site.konnect_short_name}} control plane upgrades always show incompatible messages on the Gateway Manager page if the data plane nodes are not the same version as the {{site.konnect_short_name}} control plane?

An old configuration may still be 100% compatible with older data plane nodes and therefore not show any error messages in the {{site.konnect_short_name}} UI. If there are compatibility issues detected when pushing the payload down to the data plane then this will be reflected in the UI.

### Will new features be available if {{site.konnect_short_name}} control plane detects incompatible data plane nodes?

New features will not be available for use or consumption on incompatible data plane nodes. You will see new features available in the {{site.konnect_short_name}} UI regardless of the data plane that is connected to the control plane in {{site.konnect_short_name}}. However, when an update payload is pushed to an incompatible data plane, the update will be automatically rejected by the data plane. 

This is managed by a version compatibility layer that checks the payload before the update gets sent to the data plane. If there are concerns with the payload, metadata is added to the node. That metadata is what will display incompatibility warnings or errors in the {{site.konnect_short_name}} UI. 

For example, let's say a parameter is introduced with a new version of a plugin, and is available in the {{site.konnect_short_name}} UI. The data plane, however, is running an older version of {{site.base_gateway}} and doesn't support the new parameter. If that parameter is not configured, or is assigned the default value, then no warning or incompatibility metadata will be applied to the node in {{site.konnect_short_name}}, and no warnings or errors will appear.

###  Can customers continue to use older versions of configurations as the {{site.konnect_short_name}} control plane auto-upgrades?

Yes all decK dumps, or YAML configurations, will continue to work in {{site.konnect_short_name}} after they are synced.

### Are there any disruptions if customers choose not to upgrade their data plane nodes?

There is **NO** disruption at all if customers choose **NOT** to upgrade their data plane nodes, as long as the version of the data plane is under our [{{site.base_gateway}} active support timeline](/gateway/latest/support-policy/#version-support-for-kong-gateway-enterprise/). 